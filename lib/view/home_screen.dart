import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_node_auth/constants.dart';
import 'package:flutter_node_auth/controller/api_controller.dart';
import 'package:flutter_node_auth/view/components/home_components.dart';
import 'package:flutter_node_auth/view/product_add.dart';
import 'package:flutter_node_auth/view/product_detail.dart';
import 'package:flutter_node_auth/view/settings.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get_utils/src/extensions/string_extensions.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'dart:math' as math;

import 'package:pull_to_refresh/pull_to_refresh.dart';

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => math.max(maxHeight, minHeight);
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight || minHeight != oldDelegate.minHeight || child != oldDelegate.child;
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // final List<String> categories = ["Cars", "Electronics", "Jobs", "Clothes", "Shoes", "House Hold"];
  final List<Map<String, dynamic>> categories = [
    {"name": "Cars", "icon": Icons.car_rental},
    {"name": "Electronics", "icon": Icons.laptop},
    {"name": "Jobs", "icon": Icons.work},
    {"name": "Clothes", "icon": Icons.shopping_bag},
    {"name": "Shoes", "icon": Icons.handyman},
    {"name": "Houses", "icon": Icons.house},
    {},
  ];
  late ScrollController _hideButtonController;
  late bool _isVisible;

  @override
  void initState() {
    super.initState();
    // _createBottomBannerAd();
    // _createInlineBannerAd();
    _isVisible = true;
    _hideButtonController = ScrollController();
    _hideButtonController.addListener(() {
      if (_hideButtonController.position.userScrollDirection == ScrollDirection.reverse) {
        if (_isVisible == true) {
          /* only set when the previous state is false
             * Less widget rebuilds 
             */
          print("**** $_isVisible up"); //Move IO away from setState
          setState(() {
            _isVisible = false;
          });
        }
      } else {
        if (_hideButtonController.position.userScrollDirection == ScrollDirection.forward) {
          if (_isVisible == false) {
            /* only set when the previous state is false
               * Less widget rebuilds 
               */
            print("**** $_isVisible down"); //Move IO away from setState
            setState(() {
              _isVisible = true;
            });
          }
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    // _bottomBannerAd.dispose();
    // _inlineBannerAd.dispose();
    _hideButtonController.dispose();
  }

  final RefreshController _refreshController = RefreshController(initialRefresh: false);
  void _onLoading() async {
    // monitor network fetch
    try {
      bool result = await Get.find<ApiController>().getProducts(false);
      // if failed,use loadFailed(),if no data return,use LoadNodata()
      if (result) {
        _refreshController.loadComplete();
      } else {
        _refreshController.loadNoData();
      }
    } catch (e) {
      print(e);
    }
  }

  void _onRefresh() async {
    // monitor network fetch
    bool result = await Get.find<ApiController>().getProducts(true);
    if (result) {
      _refreshController.loadComplete();
    } else {
      _refreshController.loadNoData();
      // _refreshController.loadFailed();
    }
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  //-------bottombannerad
  // late BannerAd _bottomBannerAd;
  // bool _isBottomBannerAdLoaded = false;

  // void _createBottomBannerAd() {
  //   _bottomBannerAd = BannerAd(
  //     size: AdSize.banner,
  //     adUnitId: AdHelper.bannerAdUnitId,
  //     request: const AdRequest(),
  //     listener: BannerAdListener(
  //       onAdLoaded: (_) {
  //         setState(() {
  //           _isBottomBannerAdLoaded = true;
  //         });
  //       },
  //       onAdFailedToLoad: (ad, error) {
  //         ad.dispose();
  //       },
  //     ),
  //   );
  //   _bottomBannerAd.load();
  // }

  //--------------
  //--------------inlinebannerad--
  // final _inlineAdIndex = 3;
  // late BannerAd _inlineBannerAd;
  // bool _isInlineBannerAdLoaded = false;

  // void _createInlineBannerAd() {
  //   _inlineBannerAd = BannerAd(
  //     size: AdSize.mediumRectangle,
  //     adUnitId: AdHelper.bannerAdUnitId,
  //     request: const AdRequest(),
  //     listener: BannerAdListener(onAdLoaded: (_) {
  //       print('inline ad loaded');
  //       setState(() {
  //         _isInlineBannerAdLoaded = true;
  //       });
  //     }, onAdFailedToLoad: (ad, error) {
  //       print('inline ad failed');
  //       ad.dispose();
  //     }),
  //   );
  //   _inlineBannerAd.load();
  // }
  //------------------------

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      drawer: const Drawer(),
      floatingActionButton: Visibility(
        visible: _isVisible,
        child: FloatingActionButton(
          onPressed: () async {
            Get.to(() => const ProductAdd(), transition: Transition.cupertino);
          },
          backgroundColor: Colors.teal,
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: SmartRefresher(
          controller: _refreshController,
          physics: const BouncingScrollPhysics(),
          enablePullUp: true,
          enablePullDown: true,
          onLoading: _onLoading,
          onRefresh: _onRefresh,
          header: const WaterDropHeader(
              refresh: CupertinoActivityIndicator(), complete: SizedBox.shrink(), completeDuration: Duration(milliseconds: 100), waterDropColor: Colors.teal),
          footer: CustomFooter(
            builder: (context, mode) {
              Widget body;
              if (mode == LoadStatus.idle) {
                body = const Text("pull up");
              } else if (mode == LoadStatus.loading) {
                //TODO: put your custom loading animation here
                body = const CupertinoActivityIndicator();
              } else if (mode == LoadStatus.failed) {
                body = const Text("Load Failed!Click retry!");
              } else if (mode == LoadStatus.canLoading) {
                body = const Text("release to load more");
              } else if (mode == LoadStatus.noMore) {
                // body = const SizedBox.shrink();
                body = const Icon(Icons.done);
              } else {
                body = const Text("No more Data");
              }
              return SizedBox(height: 55.0, child: Center(child: body));
            },
          ),
          child: CustomScrollView(
            controller: _hideButtonController,
            slivers: [
              SliverPersistentHeader(
                floating: true,
                delegate: _SliverAppBarDelegate(
                  minHeight: size.height * 0.19,
                  maxHeight: size.height * 0.19,
                  child: Container(
                    decoration: const BoxDecoration(color: Colors.white),
                    child: Column(
                      children: [
                        SizedBox(height: size.height * 0.02),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10.0),
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          decoration: BoxDecoration(
                            color: const Color(0xfff2f2f2),
                            borderRadius: BorderRadius.circular(10.0),
                            boxShadow: [BoxShadow(color: Colors.grey.shade300, offset: const Offset(2, 7), blurRadius: 10.0)],
                          ),
                          child: BuildTopBar(
                            size: size,
                            onProfileTap: () {
                              Get.to(() => const Settings(), transition: Transition.cupertino);
                            },
                          ),
                        ),
                        SizedBox(height: size.height * 0.02),
                        Expanded(
                          child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemCount: categories.length,
                            itemBuilder: (context, index) {
                              if (index == 0) {
                                return Row(
                                  children: [
                                    Container(
                                      margin: index == 0
                                          ? const EdgeInsets.only(left: 20.0, right: 10.0, bottom: 10.0)
                                          : const EdgeInsets.only(right: 10.0, bottom: 10.0),
                                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5.0),
                                        color: const Color(0xff444941),
                                        border: Border.all(color: const Color(0xfff8f8f8), width: 1.0),
                                      ),
                                      child: const Center(child: Text('All', style: TextStyle(color: Colors.white))),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 10.0, right: 10.0),
                                      decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 0.5)),
                                    ),
                                  ],
                                );
                              }
                              return Container(
                                margin: index == 0
                                    ? const EdgeInsets.only(left: 20.0, right: 10.0, bottom: 10.0)
                                    : const EdgeInsets.only(right: 10.0, bottom: 10.0),
                                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50.0),
                                  color: const Color(0xfff2f2f2),
                                  border: Border.all(color: Colors.grey.shade300, width: 1.0),
                                ),
                                child: Row(
                                  children: [
                                    Icon(categories[index]['icon']),
                                    SizedBox(width: size.width * 0.02),
                                    Center(child: Text(categories[index - 1]['name'], style: const TextStyle(color: Colors.black))),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(child: Container(height: size.height * 0.02)),
              GetBuilder<ApiController>(
                builder: (controller) => SliverStaggeredGrid.countBuilder(
                  staggeredTileBuilder: (index) => const StaggeredTile.fit(1),
                  crossAxisCount: 2,
                  mainAxisSpacing: 20.0,
                  crossAxisSpacing: 0.0,
                  itemCount: controller.products.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Get.to(() => ProductDetail(selectedProductIndex: index), transition: Transition.cupertino);
                      },
                      child: ProductCard(controller: controller, index: index, size: size),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  const ProductCard({Key? key, required this.controller, required this.index, required this.size, this.radiusDouble = 15.0}) : super(key: key);
  final ApiController controller;
  final int index;
  final Size size;
  final double radiusDouble;
  double doubleInRange(Random source, num start, num end) => source.nextDouble() * (end - start) + start;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 5.0),
            decoration: BoxDecoration(
              color: const Color(0xfff2f2f2),
              borderRadius: BorderRadius.only(topLeft: Radius.circular(radiusDouble), topRight: Radius.circular(radiusDouble)),
              // boxShadow: const [BoxShadow(color: Colors.grey, offset: Offset(2, 8), blurRadius: 10.0)],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(radiusDouble), topRight: Radius.circular(radiusDouble)),
              child: CachedNetworkImage(
                //TODO: reverse
                imageUrl: '$kbaseUrl/${controller.products[index].productImages![0]}',
                placeholder: (context, url) => Container(
                  height: size.height * 0.15,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    // color: const Color(0xfff2f2f2),
                    color: Colors.transparent,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(radiusDouble), topRight: Radius.circular(radiusDouble)),
                    // boxShadow: const [BoxShadow(color: Colors.grey, offset: Offset(2, 8), blurRadius: 10.0)],
                  ),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 5.0),
            padding: const EdgeInsets.only(left: 10.0),
            decoration: BoxDecoration(
              color: const Color(0xfff2f2f2),
              // color: Colors.black,
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(radiusDouble), bottomRight: Radius.circular(radiusDouble)),
              // boxShadow: const [BoxShadow(color: Colors.grey, offset: Offset(2, 8), blurRadius: 10.0)],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: size.height * 0.01),
                Text(controller.products[index].name!.capitalize.toString(),
                    style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.black)),
                SizedBox(height: size.height * 0.01),
                const Text('\$200.00', style: TextStyle(fontSize: 15.0, color: Colors.grey)),
                SizedBox(height: size.height * 0.02),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
