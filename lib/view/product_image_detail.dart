import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProductImageDetail extends StatelessWidget {
  const ProductImageDetail({Key? key, required this.productImages, required this.selectedImageIndex}) : super(key: key);
  final List<String> productImages;
  final int selectedImageIndex;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.light));

    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              color: Colors.white,
              child: GestureDetector(
                onDoubleTap: () {},
                child: InteractiveViewer(
                  maxScale: 3.0,
                  child: CachedNetworkImage(
                    imageUrl: productImages[selectedImageIndex],
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
