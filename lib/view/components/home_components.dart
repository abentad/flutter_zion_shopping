import 'package:flutter/material.dart';
import 'package:flutter_node_auth/constants.dart';
import 'package:flutter_node_auth/controller/auth_controller.dart';
import 'package:get/get.dart';

class BuildBottomBar extends StatelessWidget {
  const BuildBottomBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: size.height * 0.1,
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      margin: const EdgeInsets.symmetric(horizontal: 30.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: const [BoxShadow(color: Colors.grey, offset: Offset(2, 7), blurRadius: 20.0)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.home, color: Colors.pink)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.home)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.home)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.home)),
        ],
      ),
    );
  }
}

class BuildTopBar extends StatelessWidget {
  const BuildTopBar({Key? key, required this.size, required this.onProfileTap}) : super(key: key);

  final Size size;
  final Function() onProfileTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      decoration: BoxDecoration(
        // color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: () => Scaffold.of(context).openDrawer(),
            child: const Icon(Icons.menu, color: Color(0xff444941), size: 28.0),
          ),
          SizedBox(width: size.width * 0.02),
          Expanded(
            child: TextFormField(
              cursorColor: Colors.black,
              style: const TextStyle(fontSize: 18.0, color: Colors.black),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                prefixIcon: const Icon(Icons.search),
                // fillColor: Colors.white,
                hintText: 'search'.tr,
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 16.0),
                enabledBorder:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: const BorderSide(color: Colors.transparent, width: 1.0)),
                focusedBorder:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: const BorderSide(color: Colors.transparent, width: 1.0)),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: const BorderSide(color: Colors.transparent, width: 1.0)),
              ),
            ),
          ),
          SizedBox(width: size.width * 0.06),
          GetBuilder<AuthController>(
            builder: (controller) => InkWell(
              onTap: onProfileTap,
              borderRadius: BorderRadius.circular(50.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50.0),
                child: Image(
                  image: NetworkImage('$kbaseUrl/${controller.currentUser!.profile}'),
                  height: 35.0,
                  width: 35.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
