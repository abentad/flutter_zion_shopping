import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_node_auth/constants/api_path.dart';
import 'package:flutter_node_auth/controller/api_controller.dart';
import 'package:flutter_node_auth/controller/theme_controller.dart';
import 'package:flutter_node_auth/utils/app_helpers.dart';
import 'package:flutter_node_auth/view/product/product_detail.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

import 'home_screen/home_screen_helpers.dart';

class SellerScreen extends StatelessWidget {
  const SellerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (notification) {
            notification.disallowGlow();
            return false;
          },
          child: CustomScrollView(
            slivers: [
              SliverPersistentHeader(
                floating: true,
                delegate: SliverAppBarDelegate(
                  minHeight: size.height * 0.18,
                  maxHeight: size.height * 0.18,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: Row(
                      children: [
                        Column(
                          children: [
                            SizedBox(height: size.height * 0.02),
                            CircleAvatar(
                              radius: 40.0,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50.0),
                                child: CachedNetworkImage(imageUrl: "$kbaseUrl/${Get.find<ApiController>().seller!.profile}"),
                              ),
                            ),
                            SizedBox(height: size.height * 0.02),
                          ],
                        ),
                        SizedBox(width: size.width * 0.04),
                        Column(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: size.height * 0.04),
                            Text(Get.find<ApiController>().seller!.username!.capitalize.toString(), style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600)),
                            SizedBox(height: size.height * 0.005),
                            Text(Get.find<ApiController>().seller!.phoneNumber!.toString(), style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400)),
                            Text("Joined on " + formatTime(DateTime.parse(Get.find<ApiController>().seller!.dateJoined.toString())),
                                style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              GetBuilder<ApiController>(
                builder: (controller) => SliverStaggeredGrid.countBuilder(
                  staggeredTileBuilder: (index) => const StaggeredTile.fit(1),
                  crossAxisCount: 2,
                  mainAxisSpacing: 20.0,
                  crossAxisSpacing: 0.0,
                  itemCount: controller.sellerProducts.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Get.to(() => ProductDetail(selectedProductIndex: index, productsList: controller.sellerProducts), transition: Transition.cupertino);
                      },
                      child: ProductCard(products: controller.sellerProducts, themeController: Get.find<ThemeController>(), index: index, size: size),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
