import 'package:flutter/material.dart';

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
