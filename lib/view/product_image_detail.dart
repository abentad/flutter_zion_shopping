import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_view/photo_view.dart';

class ProductImageDetail extends StatelessWidget {
  const ProductImageDetail({Key? key, required this.productImages, required this.selectedImageIndex}) : super(key: key);
  final List<String> productImages;
  final int selectedImageIndex;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.light));

    return Scaffold(
      body: PhotoView(
        imageProvider: NetworkImage(productImages[selectedImageIndex]),
        minScale: PhotoViewComputedScale.contained * 0.8,
        maxScale: PhotoViewComputedScale.covered * 2,
        enableRotation: true,
      ),
    );
  }
}
