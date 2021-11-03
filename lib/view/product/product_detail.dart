import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_node_auth/constants/api_path.dart';
import 'package:flutter_node_auth/controller/api_controller.dart';
import 'package:flutter_node_auth/utils/app_helpers.dart';
import 'package:flutter_node_auth/view/product/product_image_detail.dart';
import 'package:flutter_node_auth/view/product/product_screen_helper.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get_utils/src/extensions/string_extensions.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:transition/transition.dart';
import 'package:get/get.dart' as getter;

class ProductDetail extends StatefulWidget {
  const ProductDetail({Key? key, required this.selectedProductIndex}) : super(key: key);

  final int selectedProductIndex;

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  int activeIndex = 0;

  @override
  void initState() {
    super.initState();
    getter.Get.find<ApiController>().getProductImages(getter.Get.find<ApiController>().products[widget.selectedProductIndex].id);
  }

  @override
  void dispose() {
    super.dispose();
    getter.Get.find<ApiController>().resetProductImagesAndProductViews();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: GetBuilder<ApiController>(
        builder: (controller) => SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //Carousel image
                    Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 300.0,
                          decoration: BoxDecoration(
                            // color: Color(0xfff2f2f2),
                            color: Colors.grey.shade100,
                          ),
                          child: CarouselSlider.builder(
                            itemCount: controller.productImages.length,
                            itemBuilder: (context, index, realIndex) {
                              return GestureDetector(
                                onTap: () {
                                  print('Tapped on page $realIndex');
                                  Navigator.push(
                                    context,
                                    Transition(
                                      child: ProductImageDetail(selectedImageIndex: realIndex, productImages: controller.productImages),
                                      transitionEffect: TransitionEffect.FADE,
                                      curve: Curves.easeIn,
                                    ),
                                  );
                                },
                                child: CachedNetworkImage(
                                  imageUrl: kbaseUrl + "/" + controller.productImages[index].url,
                                  fit: BoxFit.contain,
                                ),
                              );
                            },
                            options: CarouselOptions(
                              enableInfiniteScroll: false,
                              height: 300.0,
                              aspectRatio: 16 / 9,
                              viewportFraction: 0.8,
                              initialPage: 0,
                              reverse: false,
                              // autoPlay: true,
                              autoPlayInterval: const Duration(seconds: 3),
                              autoPlayAnimationDuration: const Duration(milliseconds: 800),
                              autoPlayCurve: Curves.fastOutSlowIn,
                              enlargeCenterPage: true,
                              onPageChanged: (index, reason) {
                                setState(() {
                                  activeIndex = index;
                                });
                              },
                              scrollDirection: Axis.horizontal,
                            ),
                          ),
                        ),
                        Positioned(
                          left: 0.0,
                          right: 0.0,
                          top: 0.0,
                          child: Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
                              // decoration: BoxDecoration(boxShadow: [BoxShadow(color: Colors.grey.shade200, offset: const Offset(2, 2), blurRadius: 5.0)]),
                              child: AnimatedSmoothIndicator(
                                activeIndex: activeIndex,
                                count: controller.productImages.length,
                                effect: SlideEffect(
                                  activeDotColor: Colors.greenAccent,
                                  dotColor: Colors.grey,
                                  spacing: 8.0,
                                  radius: 4.0,
                                  dotWidth: controller.productImages.length > 1 ? size.width / controller.productImages.length : 0.0,
                                  dotHeight: 5.0,
                                  strokeWidth: 1.5,
                                ),
                              ),
                            ),
                          ),
                        ),
                        // Positioned(
                        //   // left: 0.0,
                        //   right: 10.0,
                        //   bottom: 5.0,
                        //   child: Center(
                        //     child: Container(
                        //       padding: const EdgeInsets.symmetric(horizontal: 3.0, vertical: 3.0),
                        //       decoration: BoxDecoration(
                        //         color: Colors.white,
                        //         borderRadius: BorderRadius.circular(10.0),
                        //         // boxShadow: [BoxShadow(color: Colors.grey.shade200, offset: const Offset(2, 2), blurRadius: 5.0)],
                        //       ),
                        //       child: IconButton(
                        //         onPressed: () {},
                        //         icon: const Icon(MdiIcons.share),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                    SizedBox(height: size.height * 0.02),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, top: 10.0, right: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${controller.products[widget.selectedProductIndex].name.toString().capitalize}',
                            style: const TextStyle(fontSize: 26.0, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${formatPrice(controller.products[widget.selectedProductIndex].price)} Birr',
                            style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold, color: Colors.teal),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: size.height * 0.01),
                    //
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Posted ${GetTimeAgo.parse(DateTime.parse(controller.products[widget.selectedProductIndex].datePosted.toString()))}",
                            style: const TextStyle(fontSize: 14.0, color: Colors.grey, fontWeight: FontWeight.w600),
                          ),
                          Row(
                            children: [
                              const Icon(MdiIcons.eye, color: Colors.grey),
                              SizedBox(width: size.width * 0.02),
                              Text(controller.productViews, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: size.height * 0.02),

                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.only(left: 15.0, top: 10.0, bottom: 10.0, right: 15.0),
                            decoration: BoxDecoration(
                              // color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(color: Colors.teal),
                            ),
                            child: Text(
                              controller.products[widget.selectedProductIndex].category.capitalize.toString(),
                              style: const TextStyle(fontSize: 14.0, color: Colors.black, fontWeight: FontWeight.w600),
                            ),
                          ),
                          Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), color: const Color(0xfff2f2f2)),
                                child: IconButton(
                                  onPressed: () async {
                                    shareProduct(controller, widget.selectedProductIndex);
                                  },
                                  icon: const Icon(MdiIcons.share),
                                ),
                              ),
                              SizedBox(width: size.width * 0.02),
                              Container(
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), color: const Color(0xfff2f2f2)),
                                child: IconButton(
                                  onPressed: () {},
                                  icon: const Icon(MdiIcons.flag),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: size.height * 0.02),
                    const Padding(
                      padding: EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Text(
                        'Description',
                        style: TextStyle(fontSize: 16.0, color: Colors.black, fontWeight: FontWeight.w600),
                      ),
                    ),
                    SizedBox(height: size.height * 0.02),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Text(
                        controller.products[widget.selectedProductIndex].description.capitalize.toString(),
                        style: const TextStyle(fontSize: 16.0),
                      ),
                    ),
                    SizedBox(height: size.height * 0.4)
                  ],
                ),
              ),
              Positioned(
                bottom: 10.0,
                left: 0.0,
                right: 0.0,
                child: Column(
                  children: [
                    //advertiser tab
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: size.height * 0.03,
                              backgroundColor: const Color(0xfff2f2f2),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50.0),
                                child: CachedNetworkImage(
                                  imageUrl: controller.products[widget.selectedProductIndex].posterProfileAvatar.toString(),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            SizedBox(width: size.width * 0.02),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  controller.products[widget.selectedProductIndex].posterName.capitalize.toString(),
                                  style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
                                ),
                                SizedBox(height: size.height * 0.005),
                                Text(controller.products[widget.selectedProductIndex].posterPhoneNumber.toString()),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    // SizedBox(height: size.height * 0.02),
                    Container(
                      height: size.height * 0.02,
                      decoration: const BoxDecoration(color: Colors.white),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(width: size.width * 0.02),
                        MaterialButton(
                          onPressed: () {
                            callNumber(controller.products[widget.selectedProductIndex].posterPhoneNumber.toString());
                          },
                          color: Colors.white,
                          splashColor: Colors.grey.shade200,
                          elevation: 0.0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0), side: const BorderSide(color: Colors.teal, width: 1.0)),
                          height: 50.0,
                          child: const Icon(Icons.phone, color: Colors.black),
                        ),
                        SizedBox(width: size.width * 0.02),
                        Expanded(
                          child: MaterialButton(
                            onPressed: () {},
                            color: Colors.teal,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                            height: 50.0,
                            child:
                                Text('Message ${controller.products[widget.selectedProductIndex].posterName.capitalize.toString()}', style: const TextStyle(color: Colors.white)),
                          ),
                        ),
                        SizedBox(width: size.width * 0.02),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
