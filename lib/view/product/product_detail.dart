import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_images/carousel_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_node_auth/constants/api_path.dart';
import 'package:flutter_node_auth/controller/api_controller.dart';
import 'package:flutter_node_auth/view/product/product_image_detail.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get_utils/src/extensions/string_extensions.dart';
import 'package:get/instance_manager.dart';
import 'package:intl/intl.dart';
import 'package:transition/transition.dart';

class ProductDetail extends StatefulWidget {
  const ProductDetail({Key? key, required this.selectedProductIndex}) : super(key: key);

  final int selectedProductIndex;

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  List<String> productImages = [];

  @override
  void initState() {
    super.initState();
    addImagesToList();
  }

  void addImagesToList() {
    for (var i = 0; i < Get.find<ApiController>().products[widget.selectedProductIndex].productImages!.length; i++) {
      setState(() {
        productImages.add("$kbaseUrl/${Get.find<ApiController>().products[widget.selectedProductIndex].productImages![i]}");
      });
    }
    print("Images length: " + productImages.length.toString());
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
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //Carousel image
                    Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Color(0xfff2f2f2),
                      ),
                      child: CarouselImages(
                        viewportFraction: 1.0,
                        borderRadius: 0.0,
                        scaleFactor: 0.6,
                        listImages: productImages,
                        height: 300.0,
                        cachedNetworkImage: true,
                        verticalAlignment: Alignment.topCenter,
                        onTap: (index) {
                          print('Tapped on page $index');
                          Navigator.push(
                            context,
                            Transition(
                              child: ProductImageDetail(selectedImageIndex: index, productImages: productImages),
                              transitionEffect: TransitionEffect.FADE,
                              curve: Curves.easeIn,
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: size.height * 0.02),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, top: 10.0, right: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${controller.products[widget.selectedProductIndex].name.toString().capitalize}',
                            style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            controller.products[widget.selectedProductIndex].price == null ? '0 Birr' : '${controller.products[widget.selectedProductIndex].price} Birr',
                            style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.teal),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: size.height * 0.01),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Text(
                        "Posted " + DateFormat('yMMMEd').format(DateTime.parse(controller.products[widget.selectedProductIndex].datePosted.toString())),
                        style: const TextStyle(fontSize: 14.0, color: Colors.grey, fontWeight: FontWeight.w600),
                      ),
                    ),
                    SizedBox(height: size.height * 0.02),
                    const Padding(
                      padding: EdgeInsets.only(left: 20.0, top: 10.0),
                      child: Text(
                        'Description',
                        style: TextStyle(fontSize: 16.0, color: Colors.black, fontWeight: FontWeight.w600),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, top: 10.0),
                      child: Text(
                        controller.products[widget.selectedProductIndex].description!.capitalize.toString(),
                        style: const TextStyle(fontSize: 16.0),
                      ),
                    ),
                    //advertiser tab
                    SizedBox(height: size.height * 0.02),
                    const Padding(
                      padding: EdgeInsets.only(left: 20.0, top: 10.0),
                      child: Text(
                        'Advertiser',
                        style: TextStyle(fontSize: 16.0, color: Colors.black, fontWeight: FontWeight.w600),
                      ),
                    ),
                    SizedBox(height: size.height * 0.02),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: size.height * 0.03,
                              backgroundColor: const Color(0xfff2f2f2),
                              child: controller.products[widget.selectedProductIndex].posterProfileAvatar == null
                                  ? null
                                  : ClipRRect(
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
                                  controller.products[widget.selectedProductIndex].posterName!.capitalize.toString(),
                                  style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
                                ),
                                SizedBox(height: size.height * 0.005),
                                Text("+251" + controller.products[widget.selectedProductIndex].posterPhoneNumber!.capitalize.toString()),
                              ],
                            )
                          ],
                        ),
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(width: size.width * 0.02),
                    MaterialButton(
                      onPressed: () {},
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
                        child: Text('Message ${controller.products[widget.selectedProductIndex].posterName!.capitalize.toString()}', style: const TextStyle(color: Colors.white)),
                      ),
                    ),
                    SizedBox(width: size.width * 0.02),
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
