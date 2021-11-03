import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_node_auth/constants/api_path.dart';
import 'package:flutter_node_auth/controller/api_controller.dart';
import 'package:flutter_node_auth/controller/theme_controller.dart';
import 'package:flutter_node_auth/utils/app_helpers.dart';
import 'package:flutter_node_auth/view/app_setting_screens/languages_screen.dart';
import 'package:flutter_node_auth/view/app_setting_screens/themes_screen.dart';
import 'package:get/get_utils/src/extensions/string_extensions.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'dart:math' as math;

Widget buildDrawer(ThemeController controller, BuildContext context) {
  final size = MediaQuery.of(context).size;

  return Drawer(
    child: SafeArea(
      child: Container(
        decoration: BoxDecoration(
          color: controller.defaultTheme['bgColor'],
        ),
        child: Column(
          children: [
            Container(
              height: size.height * 0.25,
              width: double.infinity,
              decoration: const BoxDecoration(color: Colors.teal),
              child: const Center(child: FlutterLogo(size: 42.0)),
            ),
            SizedBox(height: size.height * 0.02),
            const Spacer(),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LanguageScreen(),
                      ));
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
                  decoration: const BoxDecoration(),
                  child: Row(
                    children: [
                      const Icon(Icons.language, size: 16.0),
                      SizedBox(width: size.width * 0.06),
                      const Text('Language', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400)),
                    ],
                  ),
                ),
              ),
            ),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ThemesScreen(),
                      ));
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
                  decoration: const BoxDecoration(),
                  child: Row(
                    children: [
                      const Icon(MdiIcons.themeLightDark, size: 16.0),
                      SizedBox(width: size.width * 0.06),
                      const Text('Themes', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400)),
                    ],
                  ),
                ),
              ),
            ),
            const Divider(),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
                  decoration: const BoxDecoration(),
                  child: Row(
                    children: [
                      const Icon(MdiIcons.help, size: 16.0),
                      SizedBox(width: size.width * 0.06),
                      const Text('Help', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400)),
                    ],
                  ),
                ),
              ),
            ),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
                  decoration: const BoxDecoration(),
                  child: Row(
                    children: [
                      const Icon(MdiIcons.share, size: 16.0),
                      SizedBox(width: size.width * 0.06),
                      const Text('Tell a Friend', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400)),
                    ],
                  ),
                ),
              ),
            ),
            // SizedBox(height: size.height * 0.02),
          ],
        ),
      ),
    ),
  );
}

class ProductCard extends StatelessWidget {
  const ProductCard({Key? key, required this.controller, required this.themeController, required this.index, required this.size, this.radiusDouble = 15.0}) : super(key: key);
  final ApiController controller;
  final int index;
  final Size size;
  final double radiusDouble;
  final ThemeController themeController;
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
                imageUrl: '$kbaseUrl/${controller.products[index].image}',
                placeholder: (context, url) => Container(
                  height: size.height * 0.15,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(radiusDouble), topRight: Radius.circular(radiusDouble)),
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
              color: themeController.defaultTheme['greyishColor'],
              // color: Colors.black,
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(radiusDouble), bottomRight: Radius.circular(radiusDouble)),
              // boxShadow: const [BoxShadow(color: Colors.grey, offset: Offset(2, 8), blurRadius: 10.0)],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: size.height * 0.01),
                Text(controller.products[index].name.capitalize.toString(),
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: themeController.defaultTheme['blackColor'])),
                SizedBox(height: size.height * 0.01),
                Text(
                  '${formatPrice(controller.products[index].price)} birr',
                  style: TextStyle(fontSize: 15.0, color: themeController.defaultTheme['greyColor']),
                ),
                SizedBox(height: size.height * 0.02),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget buildLoaderFooter(BuildContext context, LoadStatus? mode) {
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
    body = const SizedBox.shrink();
    // body = const Icon(Icons.done);
  } else {
    body = const Text("No more Data");
  }
  return SizedBox(height: 55.0, child: Center(child: body));
}

class SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  SliverAppBarDelegate({
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
  bool shouldRebuild(SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight || minHeight != oldDelegate.minHeight || child != oldDelegate.child;
  }
}
