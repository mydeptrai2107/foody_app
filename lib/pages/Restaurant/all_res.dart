import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foody_app/utilities/cache_manger.dart';

import 'package:foody_app/utilities/custom_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:foody_app/pages/Customer/user_res_page.dart';

class AllRes extends StatefulWidget {
  const AllRes({super.key});
  @override
  State<AllRes> createState() => _AllResState();
}

class _AllResState extends State<AllRes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tất cả nhà hàng'),
      ),
      body: StreamBuilder(
        stream:
            FirebaseFirestore.instance.collection('Restaurants').snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView.separated(
              separatorBuilder: (context, index) => const Divider(),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var res = snapshot.data!.docs[index];
                final doc = snapshot.data!.docs[index];
                String resDesc = doc.data().containsKey('description')
                    ? doc['description']
                    : '';
                String imageURL =
                    doc.data().containsKey('ImageURL') ? doc['ImageURL'] : '';
                bool isOpen =
                    (doc.data()).containsKey('isOpen') ? doc['isOpen'] : false;
                String address = doc['address'];
                return Visibility(
                  visible: isOpen,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    shadowColor: Colors.grey.withAlpha(50),
                    child: InkWell(
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
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CachedNetworkImage(
                              imageUrl: imageURL,
                              cacheManager: appCacheManager,
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                height: 150,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              placeholder: (context, url) =>
                                  const CustomShimmer(),
                              errorWidget: (context, url, error) => Container(
                                height: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(Icons.error),
                              ),
                            ),
                            const SizedBox(height: 10.0),
                            Text(
                              res['restaurant'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6.0),
                            Text(
                              res['address'],
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
