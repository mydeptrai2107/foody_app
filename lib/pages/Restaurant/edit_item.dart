// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:foody_app/pages/Restaurant/items.dart';
import 'package:foody_app/services/auth_services.dart';
import 'package:foody_app/services/db.dart';
import 'package:foody_app/utilities/cache_manger.dart';
import 'package:foody_app/utilities/custom_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../utilities/custom_text_field.dart';
import 'package:foody_app/utilities/colours.dart';

String? priceValidator(String? value) {
  if (value!.isEmpty) {
    return 'Vui lòng nhập giá';
  }
  if (double.tryParse(value) == null) {
    return 'Vui lòng nhập đúng định dạng';
  }
  if (double.parse(value) < 0) {
    return 'Vui lòng nhập đúng định dạng';
  }
  return null;
}

class EditItemPage extends StatefulWidget {
  const EditItemPage({
    super.key,
    required this.categories,
    required this.item,
  });
  final List<String> categories;
  final Item item;

  @override
  State<EditItemPage> createState() => _EditItemPageState();
}

class _EditItemPageState extends State<EditItemPage> {
  final itemNameController = TextEditingController();
  final descController = TextEditingController();
  final priceController = TextEditingController();
  Map<String, dynamic> addOns = {};

  String selectedCategory = '';
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final picker = ImagePicker();
  late File imageFile = File('');
  String imageURL = '';

  bool isAvailable = true;

  @override
  void initState() {
    super.initState();
    selectedCategory = widget.item.category;
    itemNameController.text = widget.item.name;
    descController.text = widget.item.desc;
    priceController.text = widget.item.price.toString();
    addOns = widget.item.addOns;
    imageURL = widget.item.imageURL;
    isAvailable = widget.item.isAvailable ?? true;
    setState(() {});
  }

  @override
  void dispose() {
    itemNameController.dispose();
    descController.dispose();
    priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chỉnh sửa món ăn'),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: SingleChildScrollView(
          child: Form(
              key: _formKey,
              child: Container(
                padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                child: Column(
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          fixedSize:
                              Size(MediaQuery.of(context).size.width, 50)),
                      onPressed: () async {
                        bool result = await showDialog(
                          context: context,
                          builder: buildDeleteAlert,
                        );
                        if (result) {
                          await Db().deleteItem(
                            AuthServices().auth.currentUser!.uid,
                            widget.item.itemId,
                          );
                          Navigator.pop(context, [widget.item, true]);
                        }
                      },
                      icon: Icon(
                        Icons.delete,
                        color: appRed,
                      ),
                      label: Text(
                        'Xóa món ăn',
                        style: TextStyle(
                          color: appRed,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SwitchListTile(
                      contentPadding: const EdgeInsets.all(0),
                      title: const Text(
                        'Trạng thái món ăn',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'ubuntu-bold',
                        ),
                      ),
                      subtitle: Text(isAvailable ? 'Đang bán' : 'Hết hàng'),
                      value: isAvailable,
                      onChanged: (bool value) async {
                        setState(() {
                          isAvailable = value;
                        });

                        Item item = await Db().updateItem(
                            AuthServices().auth.currentUser!.uid,
                            imageFile,
                            widget.item.itemId, {
                          'name': itemNameController.text,
                          'desc': descController.text,
                          'price': double.parse(priceController.text),
                          'category': selectedCategory,
                          'addOns': addOns,
                          'ImageURL': imageURL,
                          'isAvailable': isAvailable,
                        });
                        Navigator.pop(context, [item, false]);
                      },
                    ),
                    const SizedBox(height: 20),

                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Tên món ăn',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'ubuntu-bold',
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    //Item name text field
                    CustomTextField(
                        labelText: '',
                        hintText: '',
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Vui lòng nhập tên món ăn';
                          }
                          return null;
                        },
                        emailController: itemNameController,
                        boxH: 100,
                        primaryColor: colorPrimary),
                    const SizedBox(height: 20),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Mô tả món ăn',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'ubuntu-bold',
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: descController,
                      onTapOutside: (event) => FocusScope.of(context).unfocus(),
                      maxLines: 3,
                      maxLength: 80,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: colorPrimary),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: colorPrimary),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: colorPrimary),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Giá món ăn',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'ubuntu-bold',
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      inputType: TextInputType.number,
                      emailController: priceController,
                      boxH: 100,
                      primaryColor: colorPrimary,
                      hintText: '',
                      labelText: '',
                      validator: priceValidator,
                    ),
                    const SizedBox(height: 20),
                    //Item image
                    Row(
                      children: [
                        const Text(
                          'Ảnh món ăn',
                          style: TextStyle(
                              fontSize: 20, fontFamily: 'ubuntu-bold'),
                        ),
                        const Spacer(),
                        IconButton(
                            onPressed: () {
                              picker
                                  .pickImage(source: ImageSource.gallery)
                                  .then((value) {
                                setState(() {
                                  imageFile = File(value!.path);
                                });
                              });
                            },
                            icon: const Icon(Icons.upload))
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: buildEditImageWidget(imageFile, imageURL),
                    ),
                    const SizedBox(height: 20),

                    //Category select Dropdown
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Danh mục',
                        style:
                            TextStyle(fontSize: 20, fontFamily: 'ubuntu-bold'),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: DropdownButtonFormField(
                        borderRadius: BorderRadius.circular(20),
                        isExpanded: true,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                        value: selectedCategory,
                        items: widget.categories.map((String value) {
                          return DropdownMenuItem(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedCategory = value!;
                          });
                        },
                      ),
                    ),

                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(10),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Text(
                                'Thêm lựa chọn',
                                style: TextStyle(
                                    fontFamily: 'ubuntu-bold', fontSize: 20),
                              ),
                              const Spacer(),
                              IconButton(
                                onPressed: () {
                                  final key = GlobalKey<FormState>();
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return buildAddonCreate(
                                            context, key, addOns);
                                      });
                                },
                                icon: const Icon(Icons.add),
                              ),
                            ],
                          ),

                          //Addon List
                          buildAddOnList(context, addOns),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.all<Color>(colorPrimary),
                          fixedSize: WidgetStateProperty.all<Size>(Size(
                              MediaQuery.of(context).size.width / 3,
                              MediaQuery.of(context).size.height / 18)),
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                        onPressed: () async {
                          if (!_formKey.currentState!.validate()) {
                            return;
                          }
                          setState(() {
                            isLoading = true;
                          });

                          Item item = await Db().updateItem(
                              AuthServices().auth.currentUser!.uid,
                              imageFile,
                              widget.item.itemId, {
                            'name': itemNameController.text,
                            'desc': descController.text,
                            'price': double.parse(priceController.text),
                            'category': selectedCategory,
                            'addOns': addOns,
                            'ImageURL': imageURL,
                          });
                          setState(() {
                            isLoading = false;
                          });

                          Navigator.pop(context, [item, false]);
                        },
                        child: isLoading
                            ? const CircularProgressIndicator(
                                strokeWidth: 1,
                                color: Colors.white,
                              )
                            : const Text(
                                'Lưu thay đổi',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }

  Widget buildDeleteAlert(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text('Xóa món ăn này'),
      content: const Text('Bạn có chắn sẽ xóa món này?'),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: const Text('Hủy')),
        TextButton(
          onPressed: () async {
            Navigator.pop(context, true);
          },
          child: const Text('Xóa'),
        ),
      ],
    );
  }
}

Widget buildEditImageWidget(File imageFile, String imageURL) {
  if (imageFile.path.isEmpty) {
    return CachedNetworkImage(
      imageUrl: imageURL,
      cacheManager: appCacheManager,
      placeholder: (context, url) => const CustomShimmer(),
    );
  } else {
    return Image.file(imageFile);
  }
}

Widget buildAddOnList(BuildContext context, Map<String, dynamic> addOns) {
  return SizedBox(
    height: 300,
    child: ListView.builder(
      itemCount: max(addOns.length, 1),
      itemBuilder: (context, index) {
        return addOns.isEmpty
            ? const SizedBox(
                height: 300, child: Center(child: Text('No Add ons!')))
            : Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 5,
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  leading: SizedBox(
                    width: 20,
                    child: IconButton(
                      iconSize: 20,
                      onPressed: () {
                        final key = GlobalKey<FormState>();
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return buildEditAddon(
                                  context, key, addOns, index);
                            });
                      },
                      icon: const Icon(Icons.edit),
                    ),
                  ),
                  tileColor: Colors.white,
                  title: Text(
                    '${addOns.keys.toList()[index]}\nRs: ${addOns.values.toList()[index]}',
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      addOns.remove(addOns.keys.toList()[index]);
                    },
                    icon: const Icon(Icons.delete),
                  ),
                ),
              );
      },
    ),
  );
}

Widget buildEditAddon(BuildContext context, GlobalKey<FormState> key,
    Map<String, dynamic> addOns, int index) {
  final nameController = TextEditingController();
  final addOnPriceController = TextEditingController();
  nameController.text = addOns.keys.toList()[index];
  addOnPriceController.text = addOns.values.toList()[index].toString();
  return AlertDialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    title: const Text('Chỉnh sửa lựa chọn'),
    content: Form(
        key: key,
        child: SizedBox(
          height: 150,
          child: Column(
            children: [
              TextFormField(
                validator: (value) =>
                    value!.isEmpty ? 'Vui lòng thêm tên lựa chọn' : null,
                controller: nameController,
                decoration:
                    const InputDecoration(hintText: 'Thêm tên lựa chọn'),
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                validator: priceValidator,
                controller: addOnPriceController,
                decoration: const InputDecoration(hintText: 'Thêm giá'),
              ),
            ],
          ),
        )),
    actions: [
      TextButton(
        child: const Text('Hủy'),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      TextButton(
        child: const Text('Chỉnh sửa'),
        onPressed: () {
          if (key.currentState!.validate()) {
            addOns.remove(addOns.keys.toList()[index]);
            addOns[nameController.text] = int.parse(addOnPriceController.text);
            Navigator.of(context).pop();
          }
        },
      ),
    ],
  );
}

Widget buildAddonCreate(BuildContext context, GlobalKey<FormState> key,
    Map<String, dynamic> addOns) {
  final nameController = TextEditingController();
  final addOnPriceController = TextEditingController();
  return AlertDialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    title: const Text('Create Add on'),
    content: Form(
        key: key,
        child: SizedBox(
          height: 150,
          child: Column(
            children: [
              TextFormField(
                validator: (value) =>
                    value!.isEmpty ? 'Please enter add on name' : null,
                controller: nameController,
                decoration: const InputDecoration(hintText: 'Add on name'),
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                validator: priceValidator,
                controller: addOnPriceController,
                decoration: const InputDecoration(hintText: 'Add on Price'),
              ),
            ],
          ),
        )),
    actions: [
      TextButton(
        child: const Text('CANCEL'),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      TextButton(
        child: const Text('CREATE'),
        onPressed: () async {
          if (key.currentState!.validate()) {
            addOns[nameController.text] = int.parse(addOnPriceController.text);
            Navigator.of(context).pop();
          }
        },
      ),
    ],
  );
}
