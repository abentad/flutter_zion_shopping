import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_node_auth/constants/api_path.dart';
import 'package:flutter_node_auth/controller/api_controller.dart';
import 'package:flutter_node_auth/controller/theme_controller.dart';
import 'package:flutter_node_auth/utils/app_helpers.dart';
import 'package:flutter_node_auth/view/components/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

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
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
                            Text("+251" + Get.find<ApiController>().seller!.phoneNumber!.toString(), style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400)),
                            Text("Joined on " + formatTime(DateTime.parse(Get.find<ApiController>().seller!.dateJoined.toString())),
                                style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverPersistentHeader(
                floating: true,
                delegate: SliverAppBarDelegate(
                  minHeight: size.height * 0.15,
                  maxHeight: size.height * 0.15,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.white,
                      boxShadow: [BoxShadow(color: Colors.grey.shade400, offset: const Offset(2, 5), blurRadius: 10.0)],
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      children: [
                        SizedBox(width: size.width * 0.04),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 40.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: size.height * 0.04),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Products:", style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400)),
                                    Text(Get.find<ApiController>().sellerProducts.length.toString(), style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400)),
                                  ],
                                ),
                                SizedBox(height: size.height * 0.01),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Views:", style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400)),
                                    Text(Get.find<ApiController>().getSellerProductViews().toString(), style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: const [],
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
                  itemCount: controller.sellerProducts.length,
                  itemBuilder: (context, index) {
                    return ProductCard(
                      ontap: () {
                        // Get.to(() => ProductDetail(selectedProductIndex: index, productsList: controller.sellerProducts), transition: Transition.cupertino);
                      },
                      hasShadows: true,
                      products: controller.sellerProducts,
                      themeController: Get.find<ThemeController>(),
                      index: index,
                      size: size,
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
