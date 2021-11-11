import 'dart:io';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_node_auth/controller/auth_controller.dart';
import 'package:flutter_node_auth/controller/notification_controller.dart';
import 'package:flutter_node_auth/view/auth/auth_widgets.dart';
import 'package:flutter_node_auth/view/home_screen.dart';
import 'package:flutter_node_auth/view/auth/sign_in.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:image_picker/image_picker.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  bool _isPassValidatorVisible = false;
  bool _isPassValid = false;

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
                  child: CustomTextFormField(
                    onchanged: (_) {},
                    controller: _usernameController,
                    keyboardType: TextInputType.name,
                    paddingRight: 20.0,
                    prefixText: "Username",
                  ),
                ),
                SizedBox(height: size.height * 0.02),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: CustomTextFormField(
                    onchanged: (_) {},
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    paddingRight: 53.0,
                    prefixText: "Email",
                  ),
                ),
                SizedBox(height: size.height * 0.02),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: CustomTextFormField(
                    onchanged: (_) {},
                    controller: _phoneNumberController,
                    keyboardType: TextInputType.phone,
                    paddingRight: 55.5,
                    prefixText: "+251",
                  ),
                ),
                SizedBox(height: size.height * 0.02),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: CustomTextFormField(
                    onchanged: (value) {
                      setState(() {
                        _isPassValidatorVisible = true;
                      });
                    },
                    controller: _passwordController,
                    keyboardType: TextInputType.name,
                    paddingRight: 23.0,
                    prefixText: "Password",
                    isObsecure: true,
                    hasPasswordVisibilityButton: true,
                  ),
                ),
                SizedBox(height: size.height * 0.02),
                _isPassValidatorVisible
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: FlutterPwValidator(
                          controller: _passwordController,
                          minLength: 8,
                          width: size.width * 0.9,
                          height: size.height * 0.05,
                          onSuccess: () {
                            setState(() {
                              _isPassValid = true;
                            });
                          },
                        ),
                      )
                    : const SizedBox.shrink(),
                SizedBox(height: size.height * 0.04),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: MaterialButton(
                    onPressed: () async {
                      if (_usernameController.text.isNotEmpty &&
                          _emailController.text.isNotEmpty &&
                          _passwordController.text.isNotEmpty &&
                          _phoneNumberController.text.isNotEmpty &&
                          _isPassValid) {
                        if (EmailValidator.validate(_emailController.text.trim())) {
                          File file = await Get.find<AuthController>().chooseImage(ImageSource.gallery);
                          bool _result = await Get.find<AuthController>().signUpUser(
                            _usernameController.text,
                            _emailController.text,
                            _phoneNumberController.text,
                            _passwordController.text,
                            file,
                            Get.find<NotificationController>().token.toString(),
                          );
                          if (_result) {
                            Get.offAll(() => const HomeScreen(), transition: Transition.fade);
                          }
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
