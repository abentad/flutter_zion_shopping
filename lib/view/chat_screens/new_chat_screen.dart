import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_node_auth/constants/api_path.dart';
import 'package:flutter_node_auth/controller/auth_controller.dart';
import 'package:flutter_node_auth/controller/message_controller.dart';
import 'package:flutter_node_auth/model/product.dart';
import 'package:flutter_node_auth/utils/app_helpers.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/string_extensions.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class NewChatScreen extends StatefulWidget {
  const NewChatScreen({Key? key, required this.selectedProductIndex, required this.productsList}) : super(key: key);
  final int? selectedProductIndex;
  final List<Product>? productsList;

  @override
  State<NewChatScreen> createState() => _NewChatScreenState();
}

class _NewChatScreenState extends State<NewChatScreen> {
  final TextEditingController _messageController = TextEditingController();

  final _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();

    //TODO: use this to scroll to the end of the list view after loading messages
    Timer(
      const Duration(milliseconds: 150),
      () => _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 150),
        curve: Curves.bounceIn,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Row(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const SizedBox(
                child: Icon(Icons.arrow_back, color: Colors.black),
              ),
            ),
            SizedBox(width: size.width * 0.04),
            CircleAvatar(
              radius: size.height * 0.03,
              backgroundColor: const Color(0xfff2f2f2),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50.0),
                // child: CachedNetworkImage(
                //   imageUrl: Get.find<MessageController>().conversations[widget.selectedConversationIndex!].senderProfileUrl == Get.find<AuthController>().currentUser!.profile
                //       ? kbaseUrl + "/" + Get.find<MessageController>().conversations[widget.selectedConversationIndex!].receiverProfileUrl
                //       : kbaseUrl + "/" + Get.find<MessageController>().conversations[widget.selectedConversationIndex!].senderProfileUrl,
                //   fit: BoxFit.fill,
                // ),
                child: CachedNetworkImage(
                  imageUrl: widget.productsList![widget.selectedProductIndex!].posterProfileAvatar,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            SizedBox(width: size.width * 0.04),
            Column(
              children: [
                Text(
                    // Get.find<MessageController>().conversations[widget.selectedConversationIndex!].senderName == Get.find<AuthController>().currentUser!.username
                    //     ? Get.find<MessageController>().conversations[widget.selectedConversationIndex!].receiverName.capitalize.toString()
                    //     : Get.find<MessageController>().conversations[widget.selectedConversationIndex!].senderName.capitalize.toString(),
                    widget.productsList![widget.selectedProductIndex!].posterName,
                    style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 18.0)),
              ],
            )
          ],
        ),
      ),
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(),
          child: Stack(
            children: [
              NotificationListener<OverscrollIndicatorNotification>(
                onNotification: (overscroll) {
                  overscroll.disallowGlow();
                  return false;
                },
                child: GetBuilder<MessageController>(
                  builder: (controller) => Column(
                    children: [
                      SizedBox(height: size.height * 0.12),
                      Expanded(
                        child: ListView.builder(
                          controller: _scrollController,
                          itemCount: controller.messages.length,
                          itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: BubbleSpecialTwo(
                              text: controller.messages[index].messageText,
                              isSender: controller.messages[index].senderId == Get.find<AuthController>().currentUser!.userId ? true : false,
                              sent: controller.messages[index].senderId == Get.find<AuthController>().currentUser!.userId ? true : false,
                              color: const Color(0xFFE8E8EE),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: size.height * 0.08),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 0.0,
                right: 0.0,
                top: 0.0,
                child: Container(
                  decoration: const BoxDecoration(color: Colors.white),
                  child: Column(
                    children: [
                      SizedBox(height: size.height * 0.01),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20.0),
                        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5.0),
                          boxShadow: [BoxShadow(color: Colors.grey.shade300, offset: const Offset(2, 4), blurRadius: 5.0)],
                        ),
                        child: Row(
                          children: [
                            Container(
                              height: size.height * 0.07,
                              width: size.width * 0.14,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: CachedNetworkImage(
                                  imageUrl: kbaseUrl + "/" + widget.productsList![widget.selectedProductIndex!].image,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            SizedBox(width: size.width * 0.04),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(widget.productsList![widget.selectedProductIndex!].name.capitalize.toString(),
                                          style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600)),
                                      Text("Posted:  " + GetTimeAgo.parse(widget.productsList![widget.selectedProductIndex!].datePosted),
                                          style: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.w400)),
                                    ],
                                  ),
                                  SizedBox(height: size.height * 0.005),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(formatPrice(widget.productsList![widget.selectedProductIndex!].price) + " Birr",
                                          style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400)),
                                      Row(
                                        children: [
                                          const Icon(MdiIcons.eye, color: Colors.grey),
                                          SizedBox(width: size.width * 0.02),
                                          Text(widget.productsList![widget.selectedProductIndex!].views.toString(),
                                              style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 14.0)),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 0.0,
                right: 0.0,
                bottom: 0.0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [BoxShadow(color: Colors.grey.shade300, offset: const Offset(2, -4), blurRadius: 5.0)],
                  ),
                  child: Row(
                    children: [
                      SizedBox(width: size.width * 0.02),
                      Expanded(
                        child: TextFormField(
                          // autofocus: true,
                          onTap: () {
                            _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: const Duration(milliseconds: 100), curve: Curves.bounceIn);
                          },
                          onEditingComplete: () async {
                            if (_messageController.text.isNotEmpty) {
                              String senderId = Get.find<AuthController>().currentUser!.userId.toString();
                              String receiverId = widget.productsList![widget.selectedProductIndex!].posterId;
                              String senderName = Get.find<AuthController>().currentUser!.username.toString();
                              String receiverName = widget.productsList![widget.selectedProductIndex!].posterName;
                              String senderProfileUrl = Get.find<AuthController>().currentUser!.profile.toString();
                              String receiverProfileUrl = widget.productsList![widget.selectedProductIndex!].posterProfileAvatar;
                              String lastMessage = _messageController.text;
                              // bool result = await Get.find<MessageController>().sendMessageToRoom(
                              //   message: _messageController.text,
                              //   // convId: Get.find<MessageController>().conversations[widget.selectedConversationIndex!].id.toString(),
                              //   convId: "new",
                              //   senderId: Get.find<AuthController>().currentUser!.userId.toString(),
                              //   senderName: Get.find<AuthController>().currentUser!.username.toString(),
                              //   //fix this part its causing notification error
                              //   // widget.productsList[widget.selectedProductIndex].posterId,
                              //   // Get.find<AuthController>().currentUser!.userId.toString() == "24" ? "25" : "24",
                              //   receiverId: widget.productsList![widget.selectedProductIndex!].posterId,
                              // );
                              bool result = await Get.find<MessageController>().postNewMessage(
                                senderId: senderId,
                                receiverId: receiverId,
                                senderName: senderName,
                                receiverName: receiverName,
                                senderProfileUrl: senderProfileUrl,
                                receiverProfileUrl: receiverProfileUrl,
                                lastMessage: lastMessage,
                                lastMessageSenderId: senderId,
                              );
                              if (result) {
                                _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: const Duration(milliseconds: 100), curve: Curves.bounceIn);
                                _messageController.clear();
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Something went wrong')));
                              }
                            }
                          },
                          textInputAction: TextInputAction.send,
                          cursorColor: Colors.black,
                          style: const TextStyle(fontSize: 18.0),
                          controller: _messageController,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                            filled: true,
                            fillColor: Colors.white,
                            hintText: "Message",
                            hintStyle: const TextStyle(color: Colors.grey),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0), borderSide: const BorderSide(color: Colors.white)),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(50.0), borderSide: const BorderSide(color: Colors.white)),
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(50.0), borderSide: const BorderSide(color: Colors.white)),
                          ),
                        ),
                      ),
                      SizedBox(width: size.width * 0.06),
                      const SizedBox(
                        child: Icon(MdiIcons.image, color: Colors.black),
                      ),
                      SizedBox(width: size.width * 0.06),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
