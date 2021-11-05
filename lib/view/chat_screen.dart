import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_node_auth/constants/api_path.dart';
import 'package:flutter_node_auth/model/product.dart';
import 'package:flutter_node_auth/utils/app_helpers.dart';
import 'package:get/get_utils/src/extensions/string_extensions.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key, required this.selectedProductIndex, required this.productsList}) : super(key: key);
  final int selectedProductIndex;
  final List<Product> productsList;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();

  final _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();

    //TODO: use this to scroll to the end of the list view after loading messages
    Timer(const Duration(milliseconds: 150), () => _scrollController.jumpTo(_scrollController.position.maxScrollExtent));
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
                child: CachedNetworkImage(
                  imageUrl: widget.productsList[widget.selectedProductIndex].posterProfileAvatar.toString(),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            SizedBox(width: size.width * 0.04),
            Column(
              children: [
                Text(widget.productsList[widget.selectedProductIndex].posterName.capitalize.toString(),
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
                child: ListView(
                  controller: _scrollController,
                  children: [
                    SizedBox(height: size.height * 0.12),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 10.0),
                      child: BubbleSpecialTwo(
                        text: 'Hi, How are you?  i am ok but how is life to you man i mean what are you up to this days cause i am lost to thing how you are doing',
                        isSender: false,
                        color: Color(0xFFE8E8EE),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 10.0),
                      child: BubbleSpecialTwo(
                        text: 'bubble special tow with tail',
                        isSender: true,
                        color: Color(0xFFE8E8EE),
                        sent: true,
                        seen: true,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 10.0),
                      child: BubbleSpecialTwo(
                        text: 'Hi, How are you?  i am ok but how is life to you man i mean what are you up to this days cause i am lost to thing how you are doing',
                        isSender: false,
                        color: Color(0xFFE8E8EE),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 10.0),
                      child: BubbleSpecialTwo(
                        text: 'bubble special tow with tail',
                        isSender: true,
                        color: Color(0xFFE8E8EE),
                        sent: true,
                        seen: true,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 10.0),
                      child: BubbleSpecialTwo(
                        text: 'Hi, How are you?  i am ok but how is life to you man i mean what are you up to this days cause i am lost to thing how you are doing',
                        isSender: false,
                        color: Color(0xFFE8E8EE),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 10.0),
                      child: BubbleSpecialTwo(
                        text: 'bubble special tow with tail',
                        isSender: true,
                        color: Color(0xFFE8E8EE),
                        sent: true,
                        seen: true,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 10.0),
                      child: BubbleSpecialTwo(
                        text: 'Hi, How are you?  i am ok but how is life to you man i mean what are you up to this days cause i am lost to thing how you are doing',
                        isSender: false,
                        color: Color(0xFFE8E8EE),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 10.0),
                      child: BubbleSpecialTwo(
                        text: 'bubble special tow with tail',
                        isSender: true,
                        color: Color(0xFFE8E8EE),
                        sent: true,
                        seen: true,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 10.0),
                      child: BubbleSpecialTwo(
                        text: 'Hi, How are you?  i am ok but how is life to you man i mean what are you up to this days cause i am lost to thing how you are doing',
                        isSender: false,
                        color: Color(0xFFE8E8EE),
                      ),
                    ),
                    SizedBox(height: size.height * 0.1),
                  ],
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
                                color: const Color(0xfff2f2f2),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: CachedNetworkImage(
                                  imageUrl: kbaseUrl + "/" + widget.productsList[widget.selectedProductIndex].image,
                                  fit: BoxFit.fill,
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
                                      Text(widget.productsList[widget.selectedProductIndex].name.capitalize.toString(),
                                          style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600)),
                                      Text("Posted:  " + GetTimeAgo.parse(widget.productsList[widget.selectedProductIndex].datePosted),
                                          style: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.w400)),
                                    ],
                                  ),
                                  SizedBox(height: size.height * 0.005),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(formatPrice(widget.productsList[widget.selectedProductIndex].price) + " Birr",
                                          style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400)),
                                      Row(
                                        children: [
                                          const Icon(MdiIcons.eye, color: Colors.grey),
                                          SizedBox(width: size.width * 0.02),
                                          Text(widget.productsList[widget.selectedProductIndex].views.toString(),
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
                  // padding: const EdgeInsets.symmetric(vertical: 5.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [BoxShadow(color: Colors.grey.shade300, offset: const Offset(2, -4), blurRadius: 5.0)],
                  ),
                  child: Row(
                    children: [
                      SizedBox(width: size.width * 0.02),
                      Expanded(
                        child: TextFormField(
                          onEditingComplete: () {
                            _messageController.clear();
                            _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: const Duration(milliseconds: 100), curve: Curves.bounceIn);
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
