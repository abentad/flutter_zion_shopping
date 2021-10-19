import 'package:carousel_images/carousel_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_node_auth/constants/api_path.dart';
import 'package:flutter_node_auth/controller/api_controller.dart';
import 'package:flutter_node_auth/view/product/product_image_detail.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get_utils/src/extensions/string_extensions.dart';
import 'package:get/instance_manager.dart';
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
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.white, statusBarIconBrightness: Brightness.dark));

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
                    Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Color(0xfff2f2f2),
                      ),
                      child: CarouselImages(
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
                          const Text(
                            '200 birr',
                            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.teal),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: size.height * 0.02),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, top: 10.0),
                      child: Text(
                        'By ${controller.products[widget.selectedProductIndex].posterName.toString().capitalize}',
                        style: const TextStyle(fontSize: 16.0, color: Colors.grey),
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
                      color: Colors.transparent,
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
                        child: const Text('Message', style: TextStyle(color: Colors.white)),
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
