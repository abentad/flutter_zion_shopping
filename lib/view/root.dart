import 'package:flutter/material.dart';
import 'package:flutter_node_auth/constants/app_constants.dart';

class Root extends StatelessWidget {
  const Root({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: BuildLoadingWithLogo(size: size),
        ),
      ),
    );
  }
}

class BuildLoadingWithLogo extends StatelessWidget {
  const BuildLoadingWithLogo({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.black,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(kappName, style: TextStyle(fontSize: 55.0, fontWeight: FontWeight.w600, color: Colors.white)),
          SizedBox(height: size.height * 0.08),
          const CircularProgressIndicator(color: Colors.white),
        ],
      ),
    );
  }
}
