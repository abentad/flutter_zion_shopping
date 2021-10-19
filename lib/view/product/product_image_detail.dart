import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ProductImageDetail extends StatelessWidget {
  const ProductImageDetail({Key? key, required this.productImages, required this.selectedImageIndex}) : super(key: key);
  final List<String> productImages;
  final int selectedImageIndex;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              height: size.height,
              color: Colors.white,
              child: GestureDetector(
                onDoubleTap: () {},
                child: InteractiveViewer(
                  maxScale: 3.0,
                  child: CachedNetworkImage(
                    imageUrl: productImages[selectedImageIndex],
                    fit: BoxFit.contain,
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
