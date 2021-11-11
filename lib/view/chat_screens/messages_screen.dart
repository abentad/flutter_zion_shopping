import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_node_auth/controller/api_controller.dart';
import 'package:flutter_node_auth/controller/auth_controller.dart';
import 'package:flutter_node_auth/controller/message_controller.dart';
import 'package:flutter_node_auth/utils/app_helpers.dart';
import 'package:flutter_node_auth/view/chat_screens/chat_screen.dart';
import 'package:flutter_node_auth/view/components/widgets.dart';
import 'package:get/get.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0.0,
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const SizedBox(
                child: Icon(Icons.arrow_back, color: Colors.black),
              ),
            ),
            SizedBox(width: size.width * 0.06),
            const Text('Messages', style: TextStyle(color: Colors.black)),
          ],
        ),
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SizedBox(
          child: Column(
            children: [
              GetBuilder<MessageController>(
                builder: (controller) => Expanded(
                  child: NotificationListener<OverscrollIndicatorNotification>(
                    onNotification: (notification) {
                      notification.disallowGlow();
                      return false;
                    },
                    child: ListView.builder(
                      itemCount: controller.conversations.length,
                      itemBuilder: (context, index) => CustomConversationWidget(
                        size: size,
                        ontap: () async {
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => ChatScreen(
                                  selectedProductIndex: 0,
                                  productsList: Get.find<ApiController>().products,
                                  conversation: controller.conversations[index],
                                ),
                              ));
                        },
                        username: Get.find<AuthController>().currentUser!.username == controller.conversations[index].senderName
                            ? controller.conversations[index].receiverName.capitalize.toString()
                            : controller.conversations[index].senderName.capitalize.toString(),
                        profileUrl: Get.find<AuthController>().currentUser!.profile == controller.conversations[index].senderProfileUrl
                            ? controller.conversations[index].receiverProfileUrl
                            : controller.conversations[index].senderProfileUrl,
                        time: formatTime(DateTime.parse(controller.conversations[index].lastMessageTimeSent)),
                        lastMessage: controller.conversations[index].lastMessage,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
