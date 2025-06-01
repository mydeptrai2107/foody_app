import 'package:cached_network_image/cached_network_image.dart';
import 'package:foody_app/pages/Restaurant/search_result_class.dart';
import 'package:foody_app/services/db.dart';
import 'package:foody_app/utilities/cache_manger.dart';
import 'package:foody_app/utilities/colours.dart';
import 'package:foody_app/utilities/custom_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import 'user_res_page.dart';

class SearchResultsPage extends StatefulWidget {
  const SearchResultsPage({super.key, required this.query});
  final String query;

  @override
  State<SearchResultsPage> createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  bool isLoading = true;
  List<SearchResult> results = [];
  void getResults() async {
    results = await Db().searchRestauarants(widget.query);
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getResults();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? CustomShimmer(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          )
        : Container(
            padding: const EdgeInsets.all(10),
            child: ListView.builder(
              itemCount: results.isEmpty ? 1 : results.length + 1,
              itemBuilder: (context, eIndex) {
                int index = eIndex - 1;

                if (results.isEmpty) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off_rounded,
                          size: 120,
                          color: colorPrimary,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Không tìm thấy kết quả nào',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '(Vui lòng thử một thuật ngữ tìm kiếm khác)',
                          style:
                              TextStyle(fontSize: 15, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  );
                } else if (eIndex == 0) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Text(
                        '${results.length} kết quả tìm kiếm cho "${widget.query}"',
                        style: const TextStyle(
                          fontSize: 20,
                          fontFamily: 'ubuntu-bold',
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  );
                }
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserRestauarantPage(data: {
                          'id': results[index].restDoc['id'],
                          'restaurant': results[index].restDoc['restaurant'],
                          'image': results[index].restDoc['ImageURL'] ??
                              'https://i.pinimg.com/736x/49/e5/8d/49e58d5922019b8ec4642a2e2b9291c2.jpg',
                          'description': results[index].restDoc['description'],
                        }),
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.only(
                        bottom: index == results.length - 1 ? 0 : 20),
                    constraints: const BoxConstraints(minHeight: 140),
                    padding: const EdgeInsets.all(10),
                    // height: 200,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.transparent),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withAlpha(50),
                            spreadRadius: 2,
                            blurRadius: 3,
                            offset: const Offset(0, 3)),
                      ],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        CachedNetworkImage(
                          imageUrl: results[index].restDoc['ImageURL'] ??
                              'https://i.pinimg.com/736x/49/e5/8d/49e58d5922019b8ec4642a2e2b9291c2.jpg',
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
                          placeholder: (context, url) => Shimmer(
                              child: Container(
                            height: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey[100],
                            ),
                          )),
                          errorWidget: (context, url, error) => Container(
                              height: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(Icons.error)),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            results[index].restDoc['restaurant'] ?? 'No Data',
                            style: const TextStyle(
                                fontFamily: 'Ubuntu-bold',
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            results[index].restDoc['description'] ??
                                'No description',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                overflow: TextOverflow.ellipsis),
                          ),
                        ),
                        buildSearchItemList(results, index),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
  }
}

Widget buildSearchItemList(List<SearchResult> results, int index) {
  if (results[index].items.isEmpty) {
    return const SizedBox();
  }
  return Container(
    decoration: BoxDecoration(
      border: Border(
        top: BorderSide(
          color: Colors.grey.withAlpha(50),
        ),
      ),
    ),
    height: 80,
    padding: const EdgeInsets.only(top: 10),
    margin: const EdgeInsets.only(top: 10),
    child: ListView(
      scrollDirection: Axis.horizontal,
      children: [
        for (var item in results[index].items)
          Container(
            width: 200,
            margin: const EdgeInsets.only(right: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CachedNetworkImage(
                  imageUrl: item.imageURL,
                  cacheManager: appCacheManager,
                  imageBuilder: (context, imageProvider) => Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  placeholder: (context, url) => Shimmer(
                      child: Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[100],
                    ),
                  )),
                  errorWidget: (context, url, error) => Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.error)),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: const TextStyle(
                            fontFamily: 'Ubuntu-bold',
                            fontWeight: FontWeight.bold,
                            fontSize: 12),
                      ),
                      const Spacer(),
                      Text(
                        'Rs ${item.price}',
                        style: const TextStyle(
                            fontFamily: 'Ubuntu-bold',
                            fontWeight: FontWeight.bold,
                            fontSize: 12),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
      ],
    ),
  );
}
