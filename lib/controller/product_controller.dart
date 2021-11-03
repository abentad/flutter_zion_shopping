import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ProductController extends GetxController {
  List<String> _categories = [];
  List<String> get categories => _categories;

  final List<Map<String, dynamic>> _homeScreenCategories = [
    {"name": "Electronic", "icon": MdiIcons.laptop},
    {"name": "Car", "icon": MdiIcons.car},
    {"name": "Accessory", "icon": MdiIcons.battery},
    {"name": "Shoe", "icon": MdiIcons.shoePrint},
    {},
  ];
  List<Map<String, dynamic>> get homeScreenCategories => _homeScreenCategories;

  String _selectedCategory = '';
  String get selectedCategory => _selectedCategory;

  ProductController() {
    _categories = ['Electronic', 'Car', 'Accessory', 'Shoe'];
    _selectedCategory = _categories[0];
  }

  void changeCategory(String newCategory) {
    _selectedCategory = _categories[_categories.indexOf(newCategory)];
    update();
  }
}
