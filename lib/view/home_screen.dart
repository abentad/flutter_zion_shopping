import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_node_auth/controller/api_controller.dart';
import 'package:flutter_node_auth/controller/product_controller.dart';
import 'package:flutter_node_auth/controller/theme_controller.dart';
import 'package:flutter_node_auth/themes/theme_constants.dart';
import 'package:flutter_node_auth/view/components/widgets.dart';
import 'package:flutter_node_auth/view/product/product_add.dart';
import 'package:flutter_node_auth/view/product/product_detail.dart';
import 'package:flutter_node_auth/view/account_setting_screens/settings.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  DateTime timeBackPressed = DateTime.now();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.white, statusBarIconBrightness: Brightness.dark));
    final size = MediaQuery.of(context).size;

    return GetBuilder<ThemeController>(
      builder: (controller) => WillPopScope(
        onWillPop: () async {
          final difference = DateTime.now().difference(timeBackPressed);
          final isExitWarning = difference >= const Duration(seconds: 2);

          timeBackPressed = DateTime.now();
          if (isExitWarning) {
            const message = "Press back again to exit";
            Fluttertoast.showToast(msg: message, toastLength: Toast.LENGTH_SHORT, fontSize: 16.0);
            return false;
          } else {
            Fluttertoast.cancel();
            return true;
          }
        },
        child: Scaffold(
          // backgroundColor: controller.defaultTheme['bgColor'],
          // backgroundColor: Colors.white,
          drawer: buildDrawer(controller, context),
          floatingActionButton: Visibility(
            visible: _isVisible,
            child: FloatingActionButton(
              onPressed: () async {
                Get.to(() => const ProductAdd(), transition: Transition.cupertino);
                // Get.to(() => OnBoardingScreen(), transition: Transition.cupertino);
              },
              // backgroundColor: controller.defaultTheme['addButton'],
              // backgroundColor: Colors.teal,
              // child: Icon(Icons.add, color: controller.defaultTheme['whiteColor']),
              // child: const Icon(Icons.add, color: Colors.white),
              child: const Icon(Icons.add),
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
              header: WaterDropHeader(
                refresh: const CupertinoActivityIndicator(),
                complete: const SizedBox.shrink(),
                completeDuration: const Duration(milliseconds: 100),
                waterDropColor: Theme.of(context).primaryColor,
              ),
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
                        decoration: const BoxDecoration(),
                        child: Column(
                          children: [
                            SizedBox(height: size.height * 0.02),
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 10.0),
                              padding: const EdgeInsets.symmetric(horizontal: 10.0),
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(10.0),
                                boxShadow: [
                                  Theme.of(context).primaryColor == Colors.white
                                      ? BoxShadow(color: Colors.grey.shade300, offset: const Offset(2, 4), blurRadius: 10.0)
                                      : const BoxShadow(color: Colors.transparent, offset: Offset(2, 4), blurRadius: 10.0),
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
                                              if (_selectedIndex != index) {
                                                Get.find<ApiController>().getProducts(true);
                                              }
                                              _selectedIndex = index;
                                            });
                                            print("Category Index: " + _selectedIndex.toString());
                                          },
                                          child: Container(
                                            margin: index == 0 ? const EdgeInsets.only(left: 20.0, right: 10.0, bottom: 10.0) : const EdgeInsets.only(right: 10.0, bottom: 10.0),
                                            padding: const EdgeInsets.symmetric(horizontal: 25.0),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(5.0),
                                              color: _selectedIndex == 0 ? const Color(0xff444941) : const Color(0xfff2f2f2),
                                              border: _selectedIndex == 0
                                                  ? Border.all(color: chip_border_Color_selected, width: 1.0)
                                                  : Border.all(color: chip_border_Color_Unselected, width: 1.0),
                                            ),
                                            child: Center(
                                              child: Text(
                                                'All',
                                                style: TextStyle(color: _selectedIndex == 0 ? Colors.white : Colors.black),
                                              ),
                                            ),
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
                                        Get.find<ApiController>().getProductsByCategory(true, Get.find<ProductController>().homeScreenCategories[index - 1]['name']);
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
                        return Material(
                          color: Colors.transparent,
                          child: ProductCard(
                            ontap: () {
                              Get.to(() => ProductDetail(selectedProductIndex: index, productsList: controller.products), transition: Transition.cupertino);
                            },
                            products: controller.products,
                            themeController: Get.find<ThemeController>(),
                            index: index,
                            size: size,
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
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
