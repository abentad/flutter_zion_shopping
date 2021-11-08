import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_node_auth/constants/api_path.dart';
import 'package:flutter_node_auth/controller/auth_controller.dart';
import 'package:flutter_node_auth/controller/message_controller.dart';
import 'package:flutter_node_auth/view/components/widgets.dart';
import 'package:flutter_node_auth/view/chat_screens/messages_screen.dart';
import 'package:get/get.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                SizedBox(height: size.height * 0.02),
                GetBuilder<AuthController>(
                  builder: (controller) => Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(border: Border.all(color: Colors.green, width: 2.0), shape: BoxShape.circle),
                        child: CustomProfileCircleAvatar(profileImgUrl: '$kbaseUrl/${controller.currentUser!.profile}'),
                      ),
                      SizedBox(width: size.width * 0.04),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(controller.currentUser!.username!.capitalize.toString(), style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.w500)),
                          Text(controller.currentUser!.email!.capitalize.toString(), style: const TextStyle(fontSize: 14.0, color: Colors.grey)),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: size.height * 0.08),
                CustomMaterialButton(
                  onPressed: () async {
                    bool result = await Get.find<MessageController>().getConversations(Get.find<AuthController>().currentUser!.userId.toString());
                    if (result) {
                      Navigator.push(context, CupertinoPageRoute(builder: (context) => const MessagesScreen()));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Something went wrong')));
                    }
                  },
                  btnLabel: "Messages",
                ),
                const Spacer(),
                CustomMaterialButton(
                  onPressed: () {
                    Get.find<AuthController>().signOut();
                  },
                  btnLabel: "Sign out",
                ),
                SizedBox(height: size.height * 0.04),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
