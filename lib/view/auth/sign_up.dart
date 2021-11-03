import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_node_auth/controller/auth_controller.dart';
import 'package:flutter_node_auth/view/home_screen.dart';
import 'package:flutter_node_auth/view/auth/sign_in.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:image_picker/image_picker.dart';

class SignUp extends StatelessWidget {
  SignUp({Key? key}) : super(key: key);

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          reverse: true,
          child: Container(
            decoration: const BoxDecoration(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: size.height * 0.06),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text('Sign Up', style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold)),
                ),
                SizedBox(height: size.height * 0.02),
                const Padding(
                  padding: EdgeInsets.only(left: 20.0, right: 60.0),
                  child:
                      Text('Create an account so you can order your favorite food even faster', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w400, color: Colors.grey)),
                ),
                SizedBox(height: size.height * 0.06),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: TextFormField(
                    controller: _usernameController,
                    cursorColor: Colors.black,
                    style: const TextStyle(fontSize: 18.0),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                      filled: true,
                      fillColor: const Color(0xfff2f2f2),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0), borderSide: const BorderSide(color: Color(0xfff2f2f2))),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0), borderSide: const BorderSide(color: Color(0xfff2f2f2))),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0), borderSide: const BorderSide(color: Color(0xfff2f2f2))),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 27),
                        child: Text("Username", style: TextStyle(fontSize: 16.0, color: Colors.grey.shade600)),
                      ),
                      prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.02),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: TextFormField(
                    controller: _emailController,
                    cursorColor: Colors.black,
                    style: const TextStyle(fontSize: 18.0),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                      filled: true,
                      fillColor: const Color(0xfff2f2f2),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0), borderSide: const BorderSide(color: Color(0xfff2f2f2))),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0), borderSide: const BorderSide(color: Color(0xfff2f2f2))),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0), borderSide: const BorderSide(color: Color(0xfff2f2f2))),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 60),
                        child: Text("Email", style: TextStyle(fontSize: 16.0, color: Colors.grey.shade600)),
                      ),
                      prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.02),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: TextFormField(
                    keyboardType: TextInputType.phone,
                    controller: _phoneNumberController,
                    cursorColor: Colors.black,
                    style: const TextStyle(fontSize: 18.0),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                      filled: true,
                      fillColor: const Color(0xfff2f2f2),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0), borderSide: const BorderSide(color: Color(0xfff2f2f2))),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0), borderSide: const BorderSide(color: Color(0xfff2f2f2))),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0), borderSide: const BorderSide(color: Color(0xfff2f2f2))),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 30),
                        child: Text("+251", style: TextStyle(fontSize: 16.0, color: Colors.grey.shade600)),
                      ),
                      prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.02),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: TextFormField(
                    controller: _passwordController,
                    cursorColor: Colors.black,
                    style: const TextStyle(fontSize: 18.0),
                    obscureText: true,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                      filled: true,
                      fillColor: const Color(0xfff2f2f2),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0), borderSide: const BorderSide(color: Color(0xfff2f2f2))),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0), borderSide: const BorderSide(color: Color(0xfff2f2f2))),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0), borderSide: const BorderSide(color: Color(0xfff2f2f2))),
                      suffixIcon: const Icon(Icons.visibility_off),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 30),
                        child: Text("Password", style: TextStyle(fontSize: 16.0, color: Colors.grey.shade600)),
                      ),
                      prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.02),
                const Padding(
                  padding: EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Text('Your password must be 8 or more characters long & contain a mix of upper & lower case letter, numbers & symbols.',
                      style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w400, color: Colors.grey)),
                ),
                SizedBox(height: size.height * 0.04),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: MaterialButton(
                    onPressed: () async {
                      if (_usernameController.text != "" && _emailController.text != "" && _passwordController.text != "" && _phoneNumberController.text != "") {
                        File file = await Get.find<AuthController>().chooseImage(ImageSource.gallery);
                        bool _result = await Get.find<AuthController>()
                            .signUpUser(_usernameController.text, _emailController.text, _phoneNumberController.text, _passwordController.text, file);
                        if (_result) {
                          Get.offAll(() => const HomeScreen(), transition: Transition.fade);
                        }
                      }
                    },
                    color: Colors.black,
                    minWidth: double.infinity,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                    height: size.height * 0.07,
                    child: const Text("Create an account", style: TextStyle(fontSize: 16.0, color: Colors.white)),
                  ),
                ),
                SizedBox(height: size.height * 0.02),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 90.0),
                  child: Center(
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(
                        text: 'By signing up, you agree to our ',
                        style: TextStyle(color: Colors.grey, fontSize: 16.0),
                        children: [
                          TextSpan(text: 'Terms of Use ', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600)),
                          TextSpan(text: 'and '),
                          TextSpan(text: 'Privacy Policy', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.06),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account?", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16.0)),
                    TextButton(
                      // onPressed: () => Navigator.push(context, CupertinoPageRoute(builder: (context) => const SignIn())),
                      onPressed: () => Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(builder: (context) => SignIn()), (route) => route.isFirst),
                      child: const Text(
                        'Sign in',
                        style: TextStyle(decoration: TextDecoration.underline, fontWeight: FontWeight.w600, fontSize: 16.0, color: Colors.black),
                      ),
                    ),
                  ],
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
