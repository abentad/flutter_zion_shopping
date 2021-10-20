import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:transition/transition.dart';

class ProductImageDetail extends StatelessWidget {
  const ProductImageDetail({Key? key, required this.productImages, required this.selectedImageIndex}) : super(key: key);
  final List<String> productImages;
  final int selectedImageIndex;

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
        child: CarouselSlider.builder(
          itemCount: productImages.length,
          itemBuilder: (context, index, realIndex) {
            return GestureDetector(
              onTap: () {
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
              child: InteractiveViewer(
                maxScale: 3.0,
                child: CachedNetworkImage(
                  imageUrl: productImages[index],
                  fit: BoxFit.contain,
                ),
              ),
            );
          },
          options: CarouselOptions(
            enableInfiniteScroll: false,
            height: double.infinity,
            aspectRatio: 16 / 9,
            viewportFraction: 1.0,
            initialPage: 0,
            reverse: false,
            // autoPlay: true,
            autoPlayInterval: const Duration(seconds: 3),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            enlargeCenterPage: true,
            onPageChanged: (index, reason) {},
            scrollDirection: Axis.horizontal,
          ),
        ),
      ),
    );
  }
}
