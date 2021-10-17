import 'package:flutter/material.dart';

class Root extends StatelessWidget {
  const Root({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Zion Mart",
                style: TextStyle(fontSize: 45.0, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: size.height * 0.08),
              const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
