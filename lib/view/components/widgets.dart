import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_node_auth/constants/api_path.dart';
import 'package:flutter_node_auth/controller/api_controller.dart';
import 'package:flutter_node_auth/controller/auth_controller.dart';
import 'package:flutter_node_auth/controller/theme_controller.dart';
import 'package:flutter_node_auth/model/product.dart';
import 'package:flutter_node_auth/utils/app_helpers.dart';
import 'package:flutter_node_auth/view/app_setting_screens/languages_screen.dart';
import 'package:flutter_node_auth/view/app_setting_screens/themes_screen.dart';
import 'package:get/get.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'dart:math' as math;

import 'package:share_plus/share_plus.dart';

class CustomProfileCircleAvatar extends StatelessWidget {
  const CustomProfileCircleAvatar({
    Key? key,
    required this.profileImgUrl,
    this.radius = 50.0,
    this.borderRadius = 50.0,
  }) : super(key: key);
  final String profileImgUrl;
  final double radius;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50.0),
        child: Image(image: NetworkImage(profileImgUrl)),
      ),
    );
  }
}

class CustomMaterialButton extends StatelessWidget {
  const CustomMaterialButton({
    Key? key,
    required this.onPressed,
    required this.btnLabel,
  }) : super(key: key);

  final Function() onPressed;
  final String btnLabel;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      minWidth: double.infinity,
      color: Colors.black,
      height: 50.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Text(btnLabel, style: const TextStyle(color: Colors.white, fontSize: 18.0)),
    );
  }
}

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    Key? key,
    required TextEditingController nameController,
    required this.hintText,
    this.keyboardType = TextInputType.name,
    this.maxLines = 1,
  })  : _nameController = nameController,
        super(key: key);

  final TextEditingController _nameController;
  final String hintText;
  final TextInputType keyboardType;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _nameController,
      keyboardType: keyboardType,
      maxLines: maxLines,
      cursorColor: Colors.black,
      style: const TextStyle(fontSize: 18.0),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        filled: true,
        fillColor: const Color(0xfff2f2f2),
        hintText: hintText,
        hintStyle: const TextStyle(fontSize: 14.0, color: Colors.grey),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0), borderSide: const BorderSide(color: Color(0xfff2f2f2))),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0), borderSide: const BorderSide(color: Color(0xfff2f2f2))),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0), borderSide: const BorderSide(color: Color(0xfff2f2f2))),
      ),
    );
  }
}

class CustomConversationWidget extends StatelessWidget {
  const CustomConversationWidget({
    Key? key,
    required this.size,
    required this.lastMessage,
    required this.time,
    required this.username,
    required this.ontap,
    required this.profileUrl,
  }) : super(key: key);

  final Size size;
  final String username;
  final String time;
  final String lastMessage;
  final String profileUrl;
  final Function() ontap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        decoration: const BoxDecoration(),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: size.height * 0.03,
                  backgroundColor: const Color(0xfff2f2f2),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50.0),
                    child: CachedNetworkImage(
                      imageUrl: kbaseUrl + "/" + profileUrl,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                SizedBox(width: size.width * 0.04),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(username, style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600)),
                          Text(time, style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400, color: Colors.black87)),
                        ],
                      ),
                      SizedBox(height: size.height * 0.005),
                      Text(lastMessage.length >= 40 ? lastMessage.substring(0, 40) + "..." : lastMessage,
                          style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400, color: Colors.grey)),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: size.height * 0.02),
            const Divider(),
          ],
        ),
      ),
    );
  }
}

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class BuildBottomBar extends StatelessWidget {
  const BuildBottomBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: size.height * 0.1,
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      margin: const EdgeInsets.symmetric(horizontal: 30.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: const [BoxShadow(color: Colors.grey, offset: Offset(2, 7), blurRadius: 20.0)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.home, color: Colors.pink)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.home)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.home)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.home)),
        ],
      ),
    );
  }
}

class BuildTopBar extends StatelessWidget {
  const BuildTopBar({Key? key, required this.size, required this.onProfileTap, required this.controller}) : super(key: key);

  final Size size;
  final Function() onProfileTap;
  final ThemeController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      decoration: BoxDecoration(
        // color: controller.defaultTheme['bgColor'],
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: () => Scaffold.of(context).openDrawer(),
            child: const Icon(Icons.menu, color: Color(0xff444941), size: 28.0),
          ),
          SizedBox(width: size.width * 0.02),
          Expanded(
            child: TextFormField(
              cursorColor: Colors.black,
              style: const TextStyle(fontSize: 18.0, color: Colors.black),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                prefixIcon: const Icon(Icons.search),
                // fillColor: controller.defaultTheme['bgColor'],
                hintText: 'search'.tr,
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 16.0),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: const BorderSide(color: Colors.transparent, width: 1.0)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: const BorderSide(color: Colors.transparent, width: 1.0)),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: const BorderSide(color: Colors.transparent, width: 1.0)),
              ),
            ),
          ),
          SizedBox(width: size.width * 0.06),
          GetBuilder<AuthController>(
            builder: (controller) => InkWell(
              onTap: onProfileTap,
              borderRadius: BorderRadius.circular(50.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50.0),
                child: Image(
                  image: NetworkImage('$kbaseUrl/${controller.currentUser!.profile}'),
                  height: 35.0,
                  width: 35.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

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
  const ProductCard(
      {Key? key,
      required this.products,
      this.hasShadows = false,
      required this.ontap,
      required this.themeController,
      required this.index,
      required this.size,
      this.radiusDouble = 15.0})
      : super(key: key);
  final List<Product> products;
  final int index;
  final Size size;
  final double radiusDouble;
  final ThemeController themeController;
  final bool hasShadows;
  final Function() ontap;
  double doubleInRange(Random source, num start, num end) => source.nextDouble() * (end - start) + start;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5.0),
      decoration: BoxDecoration(
        boxShadow: [
          hasShadows
              ? BoxShadow(color: Colors.grey.shade400, offset: const Offset(2, 5), blurRadius: 10.0)
              : const BoxShadow(color: Colors.transparent, offset: Offset(2, 5), blurRadius: 10.0),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(radiusDouble),
        onTap: ontap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: const Color(0xfff2f2f2),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(radiusDouble), topRight: Radius.circular(radiusDouble)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(radiusDouble), topRight: Radius.circular(radiusDouble)),
                child: CachedNetworkImage(
                  imageUrl: '$kbaseUrl/${products[index].image}',
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
              padding: const EdgeInsets.only(left: 10.0),
              decoration: BoxDecoration(
                color: themeController.defaultTheme['greyishColor'],
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(radiusDouble), bottomRight: Radius.circular(radiusDouble)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: size.height * 0.01),
                  Text(products[index].name.capitalize.toString(),
                      style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: themeController.defaultTheme['blackColor'])),
                  SizedBox(height: size.height * 0.01),
                  Text(
                    '${formatPrice(products[index].price)} birr',
                    style: TextStyle(fontSize: 15.0, color: themeController.defaultTheme['greyColor']),
                  ),
                  SizedBox(height: size.height * 0.02),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget buildLoaderFooter(BuildContext context, LoadStatus? mode) {
  Widget body;
  if (mode == LoadStatus.idle) {
    body = const Text("pull up");
  } else if (mode == LoadStatus.loading) {
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

void shareProduct(ApiController controller, int selectedProductIndex) async {
  String? path;
  try {
    // Saved with this method.
    var imageId = await ImageDownloader.downloadImage("$kbaseUrl/${controller.products[selectedProductIndex].image}");
    if (imageId == null) {
      return;
    }
    // Below is a method of obtaining saved image information.
    // var fileName = await ImageDownloader.findName(imageId);
    path = await ImageDownloader.findPath(imageId);
    // var size = await ImageDownloader.findByteSize(imageId);
    // var mimeType = await ImageDownloader.findMimeType(imageId);
    // print(fileName);
    // print(path);
    // print(size);
    // print(mimeType);
  } on PlatformException catch (error) {
    print(error);
  }
  Share.shareFiles([path!],
      text:
          "${controller.products[selectedProductIndex].name.capitalize}\n${formatPrice(controller.products[selectedProductIndex].price)} Birr\ncall ${controller.products[selectedProductIndex].posterName.capitalize} : ${controller.products[selectedProductIndex].posterPhoneNumber}\nShared from Hooli Mart App");
}
