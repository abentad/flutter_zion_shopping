import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_node_auth/controller/api_controller.dart';
import 'package:flutter_node_auth/controller/product_controller.dart';
import 'package:flutter_node_auth/controller/theme_controller.dart';
import 'package:flutter_node_auth/view/components/home_components.dart';
import 'package:flutter_node_auth/view/home_screen/home_screen_helpers.dart';
import 'package:flutter_node_auth/view/product/product_add.dart';
import 'package:flutter_node_auth/view/product/product_detail.dart';
import 'package:flutter_node_auth/view/settings.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final RefreshController _refreshController = RefreshController(initialRefresh: false);
  late ScrollController _hideButtonController;
  late bool _isVisible;
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.white, statusBarIconBrightness: Brightness.dark));
    final size = MediaQuery.of(context).size;

    return GetBuilder<ThemeController>(
      builder: (controller) => Scaffold(
        backgroundColor: controller.defaultTheme['bgColor'],
        drawer: buildDrawer(controller, context),
        floatingActionButton: Visibility(
          visible: _isVisible,
          child: FloatingActionButton(
            onPressed: () async {
              Get.to(() => const ProductAdd(), transition: Transition.cupertino);
            },
            backgroundColor: controller.defaultTheme['addButton'],
            child: Icon(Icons.add, color: controller.defaultTheme['whiteColor']),
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
            footer: CustomFooter(builder: buildLoaderFooter),
            child: CustomScrollView(
              controller: _hideButtonController,
              slivers: [
                SliverPersistentHeader(
                  floating: true,
                  delegate: SliverAppBarDelegate(
                    minHeight: size.height * 0.19,
                    maxHeight: size.height * 0.19,
                    child: Container(
                      decoration: BoxDecoration(color: controller.defaultTheme['bgColor']),
                      child: Column(
                        children: [
                          SizedBox(height: size.height * 0.02),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10.0),
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: [
                                controller.defaultTheme['bgColor'] == Colors.black87
                                    ? BoxShadow(color: Colors.grey.shade700, offset: const Offset(2, 4), blurRadius: 10.0)
                                    : BoxShadow(color: Colors.grey.shade300, offset: const Offset(2, 4), blurRadius: 10.0),
                              ],
                            ),
                            child: BuildTopBar(
                              size: size,
                              controller: controller,
                              onProfileTap: () {
                                Get.to(() => const Settings(), transition: Transition.cupertino);
                              },
                            ),
                          ),
                          SizedBox(height: size.height * 0.02),
                          SizedBox(
                            height: size.height * 0.07,
                            child: ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemCount: Get.find<ProductController>().homeScreenCategories.length,
                              itemBuilder: (context, index) {
                                if (index == 0) {
                                  return Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _selectedIndex = index;
                                          });
                                          print(_selectedIndex);
                                        },
                                        child: Container(
                                          margin: index == 0 ? const EdgeInsets.only(left: 20.0, right: 10.0, bottom: 10.0) : const EdgeInsets.only(right: 10.0, bottom: 10.0),
                                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(5.0),
                                            color: _selectedIndex == 0 ? const Color(0xff444941) : const Color(0xfff2f2f2),
                                            border:
                                                _selectedIndex == 0 ? Border.all(color: const Color(0xfff8f8f8), width: 1.0) : Border.all(color: Colors.grey.shade300, width: 1.0),
                                          ),
                                          child: Center(child: Text('All', style: TextStyle(color: _selectedIndex == 0 ? Colors.white : Colors.black))),
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(bottom: 10.0, right: 10.0),
                                        decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 0.5)),
                                      ),
                                    ],
                                  );
                                }
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedIndex = index;
                                    });
                                    print(_selectedIndex);
                                  },
                                  child: Container(
                                    margin: index == 0 ? const EdgeInsets.only(left: 20.0, right: 10.0, bottom: 10.0) : const EdgeInsets.only(right: 10.0, bottom: 10.0),
                                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50.0),
                                      color: _selectedIndex == index ? const Color(0xff444941) : const Color(0xfff2f2f2),
                                      border:
                                          _selectedIndex == index ? Border.all(color: const Color(0xfff8f8f8), width: 1.0) : Border.all(color: Colors.grey.shade300, width: 1.0),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(Get.find<ProductController>().homeScreenCategories[index - 1]['icon'], color: _selectedIndex == index ? Colors.white : Colors.black),
                                        SizedBox(width: size.width * 0.02),
                                        Center(
                                            child: Text(Get.find<ProductController>().homeScreenCategories[index - 1]['name'],
                                                style: TextStyle(color: _selectedIndex == index ? Colors.white : Colors.black))),
                                      ],
                                    ),
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
                        child: ProductCard(controller: controller, themeController: Get.find<ThemeController>(), index: index, size: size),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void controlScrollDirection() {
    _isVisible = true;
    _hideButtonController = ScrollController();
    _hideButtonController.addListener(() {
      if (_hideButtonController.position.userScrollDirection == ScrollDirection.reverse) {
        if (_isVisible == true) {
          print("**** $_isVisible up");
          setState(() {
            _isVisible = false;
          });
        }
      } else {
        if (_hideButtonController.position.userScrollDirection == ScrollDirection.forward) {
          if (_isVisible == false) {
            print("**** $_isVisible down");
            setState(() {
              _isVisible = true;
            });
          }
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    controlScrollDirection();
  }

  @override
  void dispose() {
    super.dispose();
    _hideButtonController.dispose();
  }

  void _onLoading() async {
    try {
      bool result = await Get.find<ApiController>().getProducts(false);
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
    bool result = await Get.find<ApiController>().getProducts(true);
    if (result) {
      _refreshController.loadComplete();
    } else {
      _refreshController.loadNoData();
    }
    _refreshController.refreshCompleted();
  }
}
