import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foody_app/pages/Customer/dine_in.dart';
import 'package:foody_app/utilities/cache_manger.dart';
import 'package:foody_app/utilities/colours.dart';
import 'package:flutter/material.dart';

import '../../utilities/custom_shimmer.dart';

class ResDine extends StatefulWidget {
  const ResDine({super.key});
  @override
  State<ResDine> createState() => _ResDineState();
}

class _ResDineState extends State<ResDine> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurants For Dining'),
        backgroundColor: colorPrimary,
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
          return ListView.separated(
            separatorBuilder: (context, index) => const Divider(),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var res = snapshot.data!.docs[index];
              final doc = snapshot.data!.docs[index];
              String imageURL =
                  (doc.data()).containsKey('ImageURL') ? doc['ImageURL'] : '';
              bool isOpen =
                  (doc.data()).containsKey('isOpen') ? doc['isOpen'] : false;
              return Visibility(
                visible: isOpen,
                child: Card(
                  elevation: 5,
                  shadowColor: Colors.grey.withAlpha(50),
                  child: InkWell(
                    onTap: () {
                      // navigate user res page
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              // builder: (context) => const Res_Dine()));
                              builder: (context) => DineInPage()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CachedNetworkImage(
                            imageUrl: imageURL,
                            cacheManager: appCacheManager,
                            imageBuilder: (context, imageProvider) => Container(
                              height: 120,
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
                                child: const Icon(Icons.error)),
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
          );
        },
      ),
    );
  }
}
