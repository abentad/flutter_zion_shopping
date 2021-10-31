import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_node_auth/constants/api_path.dart';
import 'package:flutter_node_auth/controller/api_controller.dart';
import 'package:flutter_node_auth/model/user.dart';
import 'package:flutter_node_auth/view/auth/auth_choice.dart';
import 'package:flutter_node_auth/view/home_screen.dart';
import 'package:flutter_node_auth/view/components/loading.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class AuthController extends GetxController {
  //secure storage
  final _storage = const FlutterSecureStorage();
  final String _tokenKey = "token";
  //user
  User? _currentUser;
  User? get currentUser => _currentUser;

  AuthController() {
    checkUser();
  }

  void checkUser() async {
    String? token = await _storage.read(key: _tokenKey);
    if (token != null) {
      bool result = await signInWithToken(token);
      if (result) {
        Get.offAll(() => const HomeScreen(), transition: Transition.cupertino);
      }
    } else {
      Get.offAll(() => const AuthChoice(), transition: Transition.cupertino);
    }
  }

  //choose imageFile
  Future<File> chooseImage(ImageSource imageSourse) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? _image = await _picker.pickImage(source: imageSourse);
    return File(_image!.path);
  }

  Future<File> cropImage(File imageFile) async {
    File? cropped = await ImageCropper.cropImage(
      sourcePath: imageFile.path,
      // aspectRatio: const CropAspectRatio(ratioX: 1080.0, ratioY: 1920.0),
      compressQuality: 60,
      maxHeight: 1280,
      maxWidth: 720,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      androidUiSettings: const AndroidUiSettings(
        toolbarTitle: 'Crop Image',
        toolbarColor: Colors.black,
        toolbarWidgetColor: Colors.white,
        initAspectRatio: CropAspectRatioPreset.original,
        lockAspectRatio: false,
      ),
    );
    return File(cropped!.path);
  }

  //signup
  Future<bool> signUpUser(String username, String email, String phoneNumber, String password, File file) async {
    String endPoint = kbaseUrl + '/user/signup';

    FormData formData = FormData.fromMap({
      "username": username.trim(),
      "email": email.trim(),
      "password": password.trim(),
      "phoneNumber": phoneNumber.trim(),
      "profile": await MultipartFile.fromFile(file.path),
    });

    Dio dio = Dio();

    try {
      Get.to(() => const Loading(), transition: Transition.fade);
      final response = await dio.post(endPoint, data: formData);
      if (response.statusCode == 201) {
        print(response.statusCode);
        _currentUser = User.fromJson(response.toString());
        await _storage.write(key: _tokenKey, value: _currentUser!.token);
        print('fetching products');
        bool result = await Get.find<ApiController>().getProducts(true);
        if (result == true) {
          print(_currentUser!.userId);
          return true;
        }
      }
    } catch (e) {
      print(e);
    }
    return false;
  }

  //signin
  Future<bool> signInUser(String email, String password) async {
    try {
      Get.to(() => const Loading(), transition: Transition.fade);
      final response = await http.post(
        Uri.parse(kbaseUrl + '/user/signin'),
        headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(<String, String>{'email': email.trim(), 'password': password.trim()}),
      );
      if (response.statusCode == 200) {
        _currentUser = User.fromJson(response.body);
        await _storage.write(key: _tokenKey, value: _currentUser!.token);
        print('fetching products');
        bool result = await Get.find<ApiController>().getProducts(true);
        if (result == true) {
          print(_currentUser!.userId);
          return true;
        }
      }
    } catch (e) {
      print(e);
    }

    return false;
  }

  //signin
  Future<bool> signInWithToken(String token) async {
    final response = await http.get(
      Uri.parse(kbaseUrl + '/user/signinwithtoken'),
      headers: <String, String>{'x-access-token': token},
    );
    if (response.statusCode == 200) {
      _currentUser = User.fromJson(response.body);
      print(_currentUser);
      print('fetching products');
      bool result = await Get.find<ApiController>().getProducts(true);
      if (result == true) {
        print(_currentUser!.userId);
        return true;
      }
    }
    return false;
  }

  void signOut() async {
    if (await _storage.read(key: _tokenKey) != null) {
      await _storage.write(key: _tokenKey, value: null);
      Get.offAll(() => const AuthChoice(), transition: Transition.cupertino);
    }
  }
}
