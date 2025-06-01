import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foody_app/pages/Customer/search_page.dart';
import 'package:foody_app/pages/Customer/user_res_page.dart';
import 'package:foody_app/pages/Customer/widgets/grid_product.dart';
import 'package:foody_app/pages/Customer/widgets/restaurant_horizontal.dart';
import 'package:foody_app/pages/Restaurant/items.dart';
import 'package:foody_app/services/db.dart';
import 'package:foody_app/utilities/custom_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:foody_app/utilities/colours.dart';
import 'package:foody_app/utilities/custom_tiles.dart';

class UserMainHome extends StatefulWidget {
  const UserMainHome({super.key});

  @override
  State<UserMainHome> createState() => _UserMainHomeState();
}

class _UserMainHomeState extends State<UserMainHome>
    with AutomaticKeepAliveClientMixin {
  List<Item> prodItems = [];

  void getCtgItems() async {
    prodItems = await Db().getProductItems();
    setState(() {});
  }

  @override
  void initState() {
    getCtgItems();
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Delicious\nfood for you',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: colorPrimary,
                ),
              ),
            ),
            SizedBox(height: 20),
            RichText(
              text: TextSpan(
                  text: '     Hey you, ',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: ' Good Afternoom!',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                      ),
                    )
                  ]),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchPage(),
                  ),
                );
              },
              child: Container(
                margin: EdgeInsets.all(16),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Row(
                  children: [
                    Icon(Icons.search),
                    Text(
                      'Search',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    )
                  ],
                ),
              ),
            ),
            RestaurantHorizontal(),
            GridProduct(prodItems),
          ],
        ),
      ),
    );
  }
}

class RestaurantTiles extends StatefulWidget {
  const RestaurantTiles({super.key});

  @override
  State<RestaurantTiles> createState() => _RestaurantTilesState();
}

class _RestaurantTilesState extends State<RestaurantTiles> {
  @override
  Widget build(BuildContext context) {
    CollectionReference collectionRef =
        FirebaseFirestore.instance.collection('Restaurants');

    Stream<QuerySnapshot> stream = collectionRef.snapshots();
    return StreamBuilder(
        stream: stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final doc = snapshot.data!.docs[index];
                String resDesc = (doc.data() as Map<String, dynamic>)
                        .containsKey('description')
                    ? doc['description']
                    : '';
                String imageURL = (doc.data() as Map<String, dynamic>)
                        .containsKey('ImageURL')
                    ? doc['ImageURL']
                    : 'https://i.pinimg.com/736x/49/e5/8d/49e58d5922019b8ec4642a2e2b9291c2.jpg';
                bool isOpen =
                    (doc.data() as Map<String, dynamic>).containsKey('isOpen')
                        ? doc['isOpen']
                        : false;
                String address = doc['address'];
                return Visibility(
                  visible: isOpen,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserRestauarantPage(
                            data: {
                              'id': doc.id,
                              'restaurant': doc['restaurant'],
                              'image': imageURL,
                              'description': resDesc,
                              'address': address,
                              'email': doc['email'],
                              'phone': doc['phone'],
                            },
                          ),
                        ),
                      );
                    },
                    child: ImageTile(
                      heading: doc['restaurant'],
                      description: resDesc,
                      image: imageURL,
                    ),
                  ),
                );
              },
              scrollDirection: Axis.horizontal,
            );
          } else {
            return CustomShimmer(
              height: 200,
              width: MediaQuery.of(context).size.width,
            );
          }
        });
  }
}
