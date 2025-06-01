import 'dart:io';
import 'package:foody_app/pages/Restaurant/items.dart';
import 'package:foody_app/pages/Restaurant/search_result_class.dart';
import 'package:foody_app/utilities/order_item.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:foody_app/utilities/order.dart' as ord;

class Db {
  final db = FirebaseFirestore.instance;
  Future<Map<String, dynamic>> getUserInfo(String uid) async {
    final doc = await db.collection('Customers').doc(uid).get();
    return doc.data()!;
  }

  Future<void> updateOrderStatus(
    String status,
    String restId,
    String custId,
    String orderId,
  ) async {
    await db
        .collection('Customers')
        .doc(custId)
        .collection('Orders')
        .doc(orderId)
        .update({'status': status});
    await db
        .collection('Restaurants')
        .doc(restId)
        .collection('Orders')
        .doc(orderId)
        .update({'status': status});
  }

  Future<void> addOrder(ord.Order order) async {
    //Setting to user side
    final doc =
        db.collection('Customers').doc(order.custId).collection('Orders').doc();
    await doc.set({
      'restId': order.restId,
      'custId': order.custId,
      'userAddress': order.userAddress,
      'payMentMethod': order.payMentMethod,
      'status': order.status,
      'phone': order.phone,
      'createAt': FieldValue.serverTimestamp(),
      'orderItems': order.orderItems,
    });

    //Setting in Restaurant side
    final docRest = db
        .collection('Restaurants')
        .doc(order.restId)
        .collection('Orders')
        .doc(doc.id);

    await docRest.set({
      'restId': order.restId,
      'custId': order.custId,
      'userAddress': order.userAddress,
      'payMentMethod': order.payMentMethod,
      'status': order.status,
      'phone': order.phone,
      'createAt': FieldValue.serverTimestamp(),
      'orderItems': order.orderItems,
    });
  }

  Future<void> addOrderItemToCart(
    String uid,
    Map<String, dynamic> orderItem, {
    StateSetter? setState,
  }) async {
    final doc = db.collection('Customers').doc(uid).collection('Cart').doc();
    await doc.set(orderItem);
    CartList.list.add(OrderItem(
      id: doc.id,
      itemId: orderItem['itemId'],
      imageURL: orderItem['imageURL'],
      category: orderItem['category'],
      title: orderItem['name'],
      quantity: orderItem['quantity'],
      addOns: orderItem['addOns'],
      spcInstr: orderItem['spcInstr'],
      basePrice: orderItem['basePrice'],
      restId: orderItem['restId'],
    ));
  }

  Future<void> clearCart(String uid) async {
    await db
        .collection('Customers')
        .doc(uid)
        .collection('Cart')
        .get()
        .then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.delete();
      }
    });
  }

  Future<void> loadCartItems(String uid) async {
    final cartItems =
        await db.collection('Customers').doc(uid).collection('Cart').get();
    for (final item in cartItems.docs) {
      OrderItem orderItem = OrderItem(
        id: item.id,
        itemId: item['itemId'],
        imageURL: item['imageURL'],
        category: item['category'],
        title: item['name'],
        quantity: item['quantity'],
        addOns: item['addOns'],
        spcInstr: item['spcInstr'],
        basePrice: item['basePrice'],
        restId: item['restId'],
      );
      CartList.list.add(orderItem);
    }
  }

  Future<void> updateUserAddress(String uid, String add) async {
    await db.collection('Customers').doc(uid).update({'stAddress': add});
  }

  Future<void> updateRestaurantAddress(String uid, String add) async {
    await db.collection('Restaurants').doc(uid).update({'address': add});
  }

  Future<List<SearchResult>> searchRestauarants(String query) async {
    query = query.toLowerCase();
    final queryWords = query.split(RegExp(r'[\s,-]'));

    // Lấy tất cả các Items
    final itemCollectionRef = db.collectionGroup('Items');
    final itemQuerySnapshot = await itemCollectionRef.get();

    Map<String, SearchResult> restContainingItem = {};

    for (final itemDoc in itemQuerySnapshot.docs) {
      final name = itemDoc['name'].toString().toLowerCase();

      // Kiểm tra nếu tên item chứa từ khóa
      if (queryWords.any((word) => name.contains(word))) {
        final restDoc = await itemDoc.reference.parent.parent!.get();
        final restName = restDoc['restaurant'];

        if (!restContainingItem.containsKey(restName)) {
          Map<String, dynamic> restDocData = restDoc.data()!;
          restDocData['id'] = restDoc.id;
          restContainingItem[restName] =
              SearchResult(restDoc: restDocData, items: []);
        }

        restContainingItem[restName]!.items.add(Item(
              itemId: itemDoc.id,
              name: itemDoc['name'],
              price: itemDoc['price'],
              desc: itemDoc['desc'],
              imageURL: itemDoc['ImageURL'],
              addOns: itemDoc['addOns'],
              category: itemDoc['category'],
            ));
      }
    }

    // Lấy tất cả các Restaurants
    final allRestaurantsSnapshot = await db.collection('Restaurants').get();

    for (final doc in allRestaurantsSnapshot.docs) {
      final restName = doc['restaurant'].toString().toLowerCase();

      if (queryWords.any((word) => restName.contains(word))) {
        if (!restContainingItem.containsKey(doc['restaurant'])) {
          restContainingItem[doc['restaurant']] =
              SearchResult(restDoc: doc.data(), items: []);
        }
      }
    }

    return restContainingItem.values.toList();
  }

  Future<bool> getIsOpenStatus(String uid) async {
    final doc = await FirebaseFirestore.instance
        .collection('Restaurants')
        .doc(uid)
        .get();
    return (doc.data() as Map<String, dynamic>).containsKey('isOpen')
        ? doc['isOpen']
        : false;
  }

  Future<void> toggleOpenStatus(String uid, bool isOpen) async {
    final doc = FirebaseFirestore.instance.collection('Restaurants').doc(uid);
    await doc.update({'isOpen': isOpen});
  }

  Future<List<String>> getRestaurantCategories(String uid) async {
    final doc = await FirebaseFirestore.instance
        .collection('Restaurants')
        .doc(uid)
        .get();
    List<String> ctgs = List<String>.from(doc['Categories']);
    return ctgs;
  }

  Future<void> deleteItem(String uid, String itemId) async {
    final doc = FirebaseFirestore.instance
        .collection('Restaurants')
        .doc(uid)
        .collection('Items')
        .doc(itemId);
    await doc.delete();
  }

  Future<Item> updateItem(
    String uid,
    File imageFile,
    String itemId,
    Map<String, dynamic> item,
  ) async {
    //This doc is the document reference of the item
    item['nameLower'] = item['name'].toString().toLowerCase();
    item['nameArray'] = item['nameLower'].toString().split(RegExp(r'[\s,-]'));
    final doc = FirebaseFirestore.instance
        .collection('Restaurants')
        .doc(uid)
        .collection('Items')
        .doc(itemId);

    //If there is no image file then just update with item Map
    if (imageFile.path.isEmpty) {
      await doc.update(item);
      return Item(
        itemId: doc.id,
        name: item['name'],
        price: item['price'],
        desc: item['desc'],
        imageURL: item['ImageURL'],
        category: item['category'],
        addOns: item['addOns'],
        isAvailable: item['isAvailable'],
      );
    }
    // Get the file extension from the file path
    final String fileExtension = p.extension(imageFile.path);
    final ref = FirebaseStorage.instance
        .ref()
        .child('RestaurantImages/$uid/itemImages/${doc.id}$fileExtension');

    final taskSnap = await ref.putFile(imageFile);
    final url = await taskSnap.ref.getDownloadURL();

    //Adding the image url to the database
    await doc.update({
      "ImageURL": url,
    });

    return Item(
      itemId: doc.id,
      name: item['name'],
      price: item['price'],
      desc: item['desc'],
      imageURL: url,
      category: item['category'],
      addOns: item['addOns'],
      isAvailable: item['isAvailable'],
    );
  }

  Future<Item> addItemInRestaurant(
      String uid, File imageFile, Map<String, dynamic> item) async {
    item['nameLower'] = item['name'].toString().toLowerCase();
    item['nameArray'] = item['nameLower'].toString().split(RegExp(r'[\s,-]'));
    //This doc is the document reference of the item
    final doc = await FirebaseFirestore.instance
        .collection('Restaurants')
        .doc(uid)
        .collection('Items')
        .add(item);

    //If there is no image file then place null in imageURl
    if (imageFile.path.isEmpty) {
      await doc.update({
        "ImageURL": '',
      });
      return Item(
        itemId: doc.id,
        name: item['name'],
        price: item['price'],
        desc: item['desc'],
        imageURL: '',
        category: item['category'],
        addOns: item['addOns'],
      );
    }
    // Get the file extension from the file path
    final String fileExtension = p.extension(imageFile.path);
    final ref = FirebaseStorage.instance
        .ref()
        .child('RestaurantImages/$uid/itemImages/${doc.id}$fileExtension');

    final taskSnap = await ref.putFile(imageFile);
    final url = await taskSnap.ref.getDownloadURL();

    //Adding the image url to the database
    await doc.update({
      "ImageURL": url,
    });

    return Item(
      itemId: doc.id,
      name: item['name'],
      price: item['price'],
      desc: item['desc'],
      imageURL: url,
      category: item['category'],
      addOns: item['addOns'],
    );
  }

  Future<List<Item>> getRestaurantItems(String resId) async {
    final doc = await FirebaseFirestore.instance
        .collection('Restaurants')
        .doc(resId)
        .collection('Items')
        .get();
    List<Item> items = [];
    for (var item in doc.docs) {
      items.add(Item(
        itemId: item.id,
        name: item['name'],
        price: item['price'],
        desc: item['desc'],
        imageURL: item['ImageURL'],
        category: item['category'],
        addOns: item['addOns'],
        isAvailable: item['isAvailable'],
      ));
    }

    return items;
  }

  //This functions sets the Map with ctgs as keys and list of items as a value
  Future<Map<String, List<Item>>> getCtgItems(String resId) async {
    Map<String, List<Item>> ctgItems = {};
    List<String> categories = await Db().getRestaurantCategories(resId);
    List<Item> items = await Db().getRestaurantItems(resId);
    for (var ctg in categories) {
      ctgItems[ctg] = [];
    }
    for (var item in items) {
      ctgItems[item.category]!.add(item);
    }
    return ctgItems;
  }

  Future<List<Item>> getProductItems() async {
    final firestore = FirebaseFirestore.instance;
    List<Item> result = [];

    final restaurantSnapshot = await firestore.collection('Restaurants').get();
    for (var doc in restaurantSnapshot.docs) {
      String restaurantId = doc.id;

      final document = await FirebaseFirestore.instance
          .collection('Restaurants')
          .doc(restaurantId)
          .collection('Items')
          .get();
      List<Item> items = [];
      for (var item in document.docs) {
        items.add(
          Item(
            resId: restaurantId,
            itemId: item.id,
            name: item['name'],
            price: item['price'],
            desc: item['desc'],
            imageURL: item['ImageURL'],
            isAvailable: item['isAvailable'],
            category: item['category'],
            addOns: item['addOns'],
          ),
        );
      }

      result.addAll(items);
    }

    return result;
  }
}
