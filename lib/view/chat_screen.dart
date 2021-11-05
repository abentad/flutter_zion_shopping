import 'dart:async';

import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

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
            CircleAvatar(backgroundColor: Colors.teal.shade200),
            SizedBox(width: size.width * 0.04),
            Column(
              children: const [
                Text('Seller name', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 18.0)),
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
                        sent: true,
                        delivered: true,
                        seen: true,
                        // tail: false,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 10.0),
                      child: BubbleSpecialTwo(
                        text: 'bubble special tow with tail',
                        isSender: true,
                        color: Color(0xFFE8E8EE),
                        sent: true,
                        // tail: false,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 10.0),
                      child: BubbleSpecialTwo(
                        text: 'Hi, How are you?  i am ok but how is life to you man i mean what are you up to this days cause i am lost to thing how you are doing',
                        isSender: false,
                        color: Color(0xFFE8E8EE),
                        sent: true,
                        seen: true,
                        // tail: false,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 10.0),
                      child: BubbleSpecialTwo(
                        text: 'bubble special tow with tail',
                        isSender: true,
                        color: Color(0xFFE8E8EE),
                        sent: true,
                        // tail: false,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 10.0),
                      child: BubbleSpecialTwo(
                        text: 'Hi, How are you?  i am ok but how is life to you man i mean what are you up to this days cause i am lost to thing how you are doing',
                        isSender: false,
                        color: Color(0xFFE8E8EE),
                        sent: true,
                        seen: true,
                        // tail: false,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 10.0),
                      child: BubbleSpecialTwo(
                        text: 'bubble special tow with tail',
                        isSender: true,
                        color: Color(0xFFE8E8EE),
                        sent: true,
                        // tail: false,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 10.0),
                      child: BubbleSpecialTwo(
                        text: 'Hi, How are you?  i am ok but how is life to you man i mean what are you up to this days cause i am lost to thing how you are doing',
                        isSender: false,
                        color: Color(0xFFE8E8EE),
                        sent: true,
                        seen: true,
                        // tail: false,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 10.0),
                      child: BubbleSpecialTwo(
                        text: 'bubble special tow with tail',
                        isSender: true,
                        color: Color(0xFFE8E8EE),
                        sent: true,
                        // tail: false,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 10.0),
                      child: BubbleSpecialTwo(
                        text: 'Hi, How are you?  i am ok but how is life to you man i mean what are you up to this days cause i am lost to thing how you are doing',
                        isSender: false,
                        color: Color(0xFFE8E8EE),
                        sent: true,
                        seen: true,
                        // tail: false,
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
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            SizedBox(width: size.width * 0.04),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Item name', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600)),
                                SizedBox(height: size.height * 0.005),
                                const Text('Item price', style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400)),
                              ],
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
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  decoration: const BoxDecoration(color: Colors.white),
                  child: Row(
                    children: [
                      SizedBox(width: size.width * 0.02),
                      Expanded(
                        child: TextFormField(
                          textInputAction: TextInputAction.send,
                          cursorColor: Colors.black,
                          style: const TextStyle(fontSize: 18.0),
                          controller: _messageController,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                            filled: true,
                            fillColor: const Color(0xfff2f2f2),
                            hintText: "Message",
                            hintStyle: const TextStyle(color: Colors.grey),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(50.0), borderSide: const BorderSide(color: Color(0xfff2f2f2))),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(50.0), borderSide: const BorderSide(color: Color(0xfff2f2f2))),
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(50.0), borderSide: const BorderSide(color: Color(0xfff2f2f2))),
                          ),
                        ),
                      ),
                      SizedBox(width: size.width * 0.04),
                      const SizedBox(
                        child: Icon(MdiIcons.image, color: Colors.black),
                      ),
                      SizedBox(width: size.width * 0.04),
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
