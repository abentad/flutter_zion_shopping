import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_node_auth/constants/api_path.dart';
import 'package:flutter_node_auth/controller/auth_controller.dart';
import 'package:flutter_node_auth/model/product.dart';
import 'package:flutter_node_auth/model/product_image.dart';
import 'package:flutter_node_auth/model/user.dart';
import 'package:flutter_node_auth/view/home_screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';

class ApiController extends GetxController {
  //secure storage
  final _storage = const FlutterSecureStorage();
  final String _tokenKey = "token";
  //
  final List<Product> _products = [];
  List<Product> get products => _products;
  //
  List<ProductImage> _productImages = [];
  List<ProductImage> get productImages => _productImages;
  String _productViews = "  ";
  String get productViews => _productViews;

  //variables for fetching more products on scroll
  int _pages = 2;
  int _categoryPages = 2;
  final int _limits = 20;
  //
  User? _seller;
  User? get seller => _seller;
  final List<Product> _sellerProducts = [];
  List<Product> get sellerProducts => _sellerProducts;

  ApiController();

  Future<bool> getProducts(bool isinitcall) async {
    String? _token = await _storage.read(key: _tokenKey);
    if (_token != null) {
      Dio _dio = Dio(
        BaseOptions(
          baseUrl: kbaseUrl,
          connectTimeout: 10000,
          receiveTimeout: 100000,
          headers: {'x-access-token': _token},
          responseType: ResponseType.json,
        ),
      );
      try {
        if (isinitcall) {
          _products.clear();
          int _page = 1;
          int _limit = 20;
          _pages = 2;
          print('init fetch... page= $_page size = $_limit');
          final response = await _dio.get("/data/products?page=$_page&size=$_limit");
          if (response.statusCode == 200) {
            _products.clear();
            for (int i = 0; i < response.data['rows'].length; i++) {
              _products.add(Product.fromJson(response.data['rows'][i]));
            }
            update();
            return true;
          }
        } else {
          print('fetching more... page= $_pages limit = $_limits');
          final response = await _dio.get("/data/products?page=$_pages&size=$_limits");
          print(_products.length);
          if (response.statusCode == 200) {
            if (response.data['rows'].isNotEmpty) {
              for (var i = 0; i < response.data['rows'].length; i++) {
                _products.add(Product.fromJson(response.data['rows'][i]));
              }
              _pages = _pages + 1;
              print('next page: $_pages');
              update();
            } else {
              return false;
            }
            return true;
          }
        }
      } catch (e) {
        print(e);
        return false;
      }
    } else {
      print('no token found skippng fetch');
      return false;
    }
    return false;
  }

  Future<bool> getProductsByCategory(bool isinitcall, String category) async {
    String? _token = await _storage.read(key: _tokenKey);
    if (_token != null) {
      Dio _dio = Dio(
        BaseOptions(
          baseUrl: kbaseUrl,
          connectTimeout: 10000,
          receiveTimeout: 100000,
          headers: {'x-access-token': _token},
          responseType: ResponseType.json,
        ),
      );
      try {
        if (isinitcall) {
          _products.clear();
          int _page = 1;
          int _limit = 20;
          _categoryPages = 2;
          print('init fetch... page= $_page size = $_limit category = $category');
          final response = await _dio.get("/data/products/category?page=$_page&size=$_limit&category=$category");
          if (response.statusCode == 200) {
            _products.clear();
            for (int i = 0; i < response.data['rows'].length; i++) {
              _products.add(Product.fromJson(response.data['rows'][i]));
            }
            update();
            return true;
          }
        } else {
          print('fetching more... page= $_categoryPages limit = $_limits category = $category');
          final response = await _dio.get("/data/products/category?page=$_categoryPages&size=$_limits&category=$category");
          print(_products.length);
          if (response.statusCode == 200) {
            if (response.data['rows'].isNotEmpty) {
              for (var i = 0; i < response.data['rows'].length; i++) {
                _products.add(Product.fromJson(response.data['rows'][i]));
              }
              _categoryPages = _categoryPages + 1;
              print('next page: $_categoryPages');
              update();
            } else {
              return false;
            }
            return true;
          }
        }
      } catch (e) {
        print(e);
        return false;
      }
    } else {
      print('no token found skippng fetch');
      return false;
    }
    return false;
  }

  Future<bool> postProduct(String name, String description, String price, String category, List<File> imageFiles) async {
    String? _token = await _storage.read(key: _tokenKey);
    String posterId = Get.find<AuthController>().currentUser!.userId.toString();
    String posterName = Get.find<AuthController>().currentUser!.username.toString();
    String posterPhoneNumber = Get.find<AuthController>().currentUser!.phoneNumber.toString();
    String posterProfileAvatar = Get.find<AuthController>().currentUser!.profile.toString();
    String isPendingString = 'false';

    if (_token != null) {
      List<MultipartFile> _images = [];
      for (File imageFile in imageFiles) {
        _images.add(await MultipartFile.fromFile(imageFile.path));
      }
      print("image length to be uploaded: ${_images.length}");
      FormData formData = FormData.fromMap(
        {
          "posterId": posterId,
          "posterName": posterName,
          "posterPhoneNumber": posterPhoneNumber,
          "posterProfileAvatar": posterProfileAvatar,
          "isPending": isPendingString,
          "name": name,
          "views": 0,
          "description": description,
          "datePosted": DateTime.now().toString(),
          "price": price,
          "category": category,
          "gallery": _images,
        },
      );
      Dio _dio = Dio(
        BaseOptions(
          baseUrl: kbaseUrl,
          connectTimeout: 10000,
          receiveTimeout: 100000,
          headers: {'x-access-token': _token},
          responseType: ResponseType.json,
        ),
      );
      try {
        final response = await _dio.post('/data/post', data: formData);
        if (response.statusCode == 201) {
          bool result = await getProducts(true);
          if (result) {
            Get.offAll(() => const HomeScreen());
            return true;
          }
        }
      } catch (e) {
        print(e);
      }
    } else {
      print('no token found skippng post');
    }

    return false;
  }

  Future<bool> getProductImages(int id) async {
    String? _token = await _storage.read(key: _tokenKey);
    Dio _dio = Dio(
      BaseOptions(
        baseUrl: kbaseUrl,
        connectTimeout: 10000,
        receiveTimeout: 100000,
        headers: {'x-access-token': _token},
        responseType: ResponseType.json,
      ),
    );
    try {
      final response = await _dio.get('/image?id=$id');
      if (response.statusCode == 200) {
        _productImages.clear();
        for (var productImage in response.data['rows']) {
          _productImages.add(ProductImage.fromJson(productImage));
          print(_productImages.length);
        }
        _productViews = response.data['updatedView'].toString();
        update();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> getSellerById(String id) async {
    String? _token = await _storage.read(key: _tokenKey);
    int parsedId = int.parse(id);

    Dio _dio = Dio(
      BaseOptions(
        baseUrl: kbaseUrl,
        connectTimeout: 10000,
        receiveTimeout: 100000,
        headers: {'x-access-token': _token},
        responseType: ResponseType.json,
      ),
    );
    try {
      final response = await _dio.get('/user/seller?id=$parsedId');
      if (response.statusCode == 200) {
        _seller = User(
          userId: response.data['responseData']['userId'],
          username: response.data['responseData']['username'],
          email: response.data['responseData']['email'],
          profile: response.data['responseData']['profile'],
          phoneNumber: response.data['responseData']['phoneNumber'],
          dateJoined: response.data['responseData']['dateJoined'],
        );
        _sellerProducts.clear();
        for (var sellerProduct in response.data['sellerProducts']) {
          _sellerProducts.add(Product.fromJson(sellerProduct));
        }
        print(_sellerProducts.length);
        update();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  int getSellerProductViews() {
    int sum = 0;
    for (var product in _sellerProducts) {
      sum = sum + product.views;
    }
    return sum;
  }

  void resetProductImagesAndProductViews() {
    _productImages = [];
    _productViews = "  ";
  }
}
