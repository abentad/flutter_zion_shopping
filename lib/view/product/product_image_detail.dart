import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ProductImageDetail extends StatefulWidget {
  const ProductImageDetail({Key? key, required this.productImages, required this.selectedImageIndex}) : super(key: key);
  final List<String> productImages;
  final int selectedImageIndex;

  @override
  State<ProductImageDetail> createState() => _ProductImageDetailState();
}

class _ProductImageDetailState extends State<ProductImageDetail> with SingleTickerProviderStateMixin {
  late int activeIndex;
  late TransformationController _viewerController;
  TapDownDetails? _tapDownDetails;

  late AnimationController animationController;
  Animation<Matrix4>? animation;

  @override
  void initState() {
    activeIndex = widget.selectedImageIndex;
    _viewerController = TransformationController();
    animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 300))
      ..addListener(() {
        _viewerController.value = animation!.value;
      });
    super.initState();
  }

  @override
  void dispose() {
    _viewerController.dispose();
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          // color: Color(0xfff2f2f2),
          color: Colors.black,
        ),
        child: GestureDetector(
          onDoubleTapDown: (details) => _tapDownDetails = details,
          onDoubleTap: () {
            final position = _tapDownDetails!.localPosition;
            const double scale = 3;
            final x = -position.dx * (scale - 1);
            final y = -position.dy * (scale - 1);
            final zoomed = Matrix4.identity()
              ..translate(x, y)
              ..scale(scale);
            final end = _viewerController.value.isIdentity() ? zoomed : Matrix4.identity();
            animation = Matrix4Tween(begin: _viewerController.value, end: end).animate(CurveTween(curve: Curves.easeOut).animate(animationController));
            animationController.forward(from: 0);
          },
          child: InteractiveViewer(
            transformationController: _viewerController,
            maxScale: 3.0,
            child: CachedNetworkImage(
              imageUrl: widget.productImages[activeIndex],
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
