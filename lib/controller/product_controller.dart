import 'package:get/get.dart';

class ProductController extends GetxController {
  List<String> _categories = [];
  List<String> get categories => _categories;

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
