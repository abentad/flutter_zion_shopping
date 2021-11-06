import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_node_auth/constants/api_path.dart';

class CustomProfileCircleAvatar extends StatelessWidget {
  const CustomProfileCircleAvatar({
    Key? key,
    required this.profileImgUrl,
    this.radius = 50.0,
    this.borderRadius = 50.0,
  }) : super(key: key);
  final String profileImgUrl;
  final double radius;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50.0),
        child: Image(image: NetworkImage(profileImgUrl)),
      ),
    );
  }
}

class CustomMaterialButton extends StatelessWidget {
  const CustomMaterialButton({
    Key? key,
    required this.onPressed,
    required this.btnLabel,
  }) : super(key: key);

  final Function() onPressed;
  final String btnLabel;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      minWidth: double.infinity,
      color: Colors.black,
      height: 50.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Text(btnLabel, style: const TextStyle(color: Colors.white, fontSize: 18.0)),
    );
  }
}

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    Key? key,
    required TextEditingController nameController,
    required this.hintText,
    this.keyboardType = TextInputType.name,
    this.maxLines = 1,
  })  : _nameController = nameController,
        super(key: key);

  final TextEditingController _nameController;
  final String hintText;
  final TextInputType keyboardType;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _nameController,
      keyboardType: keyboardType,
      maxLines: maxLines,
      cursorColor: Colors.black,
      style: const TextStyle(fontSize: 18.0),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        filled: true,
        fillColor: const Color(0xfff2f2f2),
        hintText: hintText,
        hintStyle: const TextStyle(fontSize: 14.0, color: Colors.grey),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0), borderSide: const BorderSide(color: Color(0xfff2f2f2))),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0), borderSide: const BorderSide(color: Color(0xfff2f2f2))),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0), borderSide: const BorderSide(color: Color(0xfff2f2f2))),
      ),
    );
  }
}

class CustomConversationWidget extends StatelessWidget {
  const CustomConversationWidget({
    Key? key,
    required this.size,
    required this.lastMessage,
    required this.time,
    required this.username,
    required this.ontap,
    required this.profileUrl,
  }) : super(key: key);

  final Size size;
  final String username;
  final String time;
  final String lastMessage;
  final String profileUrl;
  final Function() ontap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        decoration: const BoxDecoration(),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: size.height * 0.03,
                  backgroundColor: const Color(0xfff2f2f2),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50.0),
                    child: CachedNetworkImage(
                      imageUrl: kbaseUrl + "/" + profileUrl,
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
                          Text(username, style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600)),
                          Text(time, style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400, color: Colors.black87)),
                        ],
                      ),
                      SizedBox(height: size.height * 0.005),
                      Text(lastMessage.length >= 40 ? lastMessage.substring(0, 40) + "..." : lastMessage,
                          style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400, color: Colors.grey)),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: size.height * 0.02),
            const Divider(),
          ],
        ),
      ),
    );
  }
}
