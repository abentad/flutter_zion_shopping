import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_node_auth/controller/api_controller.dart';
import 'package:flutter_node_auth/controller/auth_controller.dart';
import 'package:flutter_node_auth/controller/product_controller.dart';
import 'package:flutter_node_auth/view/components/loading.dart';
import 'package:flutter_node_auth/view/components/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProductAdd extends StatefulWidget {
  const ProductAdd({Key? key}) : super(key: key);

  @override
  State<ProductAdd> createState() => _ProductAddState();
}

class _ProductAddState extends State<ProductAdd> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final List<File> _imageFiles = [];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            decoration: const BoxDecoration(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('New Product', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600)),
                    TextButton(
                      onPressed: () {
                        postProduct(
                          context,
                          nameController: _nameController,
                          priceController: _priceController,
                          categoryController: _categoryController,
                          descriptionController: _descriptionController,
                          imageFiles: _imageFiles,
                        );
                      },
                      child: const Text('Post', style: TextStyle(color: Colors.teal, fontSize: 18.0, fontWeight: FontWeight.bold)),
                    )
                  ],
                ),
                SizedBox(height: size.height * 0.04),
                CustomTextFormField(nameController: _nameController, hintText: "Name"),
                SizedBox(height: size.height * 0.02),
                CustomTextFormField(nameController: _priceController, hintText: "Price", keyboardType: TextInputType.number),
                SizedBox(height: size.height * 0.02),
                GetBuilder<ProductController>(
                  builder: (controller) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade200, width: 1.0),
                      borderRadius: BorderRadius.circular(10.0),
                      color: const Color(0xfff2f2f2),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        value: Get.find<ProductController>().selectedCategory,
                        isExpanded: true,
                        items: Get.find<ProductController>()
                            .categories
                            .map(
                              (category) => DropdownMenuItem(
                                value: category,
                                child: Text(category),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          controller.changeCategory(value.toString());
                          FocusScope.of(context).unfocus();
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.02),
                CustomTextFormField(nameController: _descriptionController, hintText: "Description", maxLines: 6),
                SizedBox(height: size.height * 0.02),
                const Text('Images', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400, color: Colors.grey)),
                SizedBox(height: size.height * 0.02),
                Container(
                  height: size.height * 0.4,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: const Color(0xfff2f2f2),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                          width: double.infinity,
                          decoration: const BoxDecoration(
                              // color: Colors.purple,
                              ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: ListView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  itemCount: _imageFiles.length,
                                  itemBuilder: (context, index) => Container(
                                    // height: size.height * 0.3,
                                    width: size.width * 0.6,
                                    margin: const EdgeInsets.all(10.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: Colors.white,
                                      image: DecorationImage(image: FileImage(_imageFiles[index]), fit: BoxFit.contain),
                                    ),
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          right: 0.0,
                                          child: Container(
                                            margin: const EdgeInsets.all(10.0),
                                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), color: const Color(0xfff2f2f2)),
                                            child: IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  _imageFiles.removeAt(index);
                                                });
                                              },
                                              icon: const Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      _imageFiles.length == 3
                          ? const SizedBox.shrink()
                          : Expanded(
                              child: InkWell(
                                onTap: () async {
                                  if (_imageFiles.length < 3) {
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (context) => Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SizedBox(height: size.height * 0.02),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                            child: MaterialButton(
                                              onPressed: () async {
                                                FocusScope.of(context).unfocus();
                                                File pickedFile = await Get.find<AuthController>().chooseImage(ImageSource.camera);
                                                File croppedFile = await Get.find<AuthController>().cropImage(pickedFile);
                                                setState(() {
                                                  _imageFiles.add(croppedFile);
                                                });
                                                Get.back();
                                              },
                                              color: Colors.black,
                                              minWidth: double.infinity,
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                                              height: size.height * 0.1,
                                              child: const Text("Camera", style: TextStyle(fontSize: 16.0, color: Colors.white)),
                                            ),
                                          ),
                                          SizedBox(height: size.height * 0.02),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                            child: MaterialButton(
                                              onPressed: () async {
                                                FocusScope.of(context).unfocus();
                                                File pickedFile = await Get.find<AuthController>().chooseImage(ImageSource.gallery);
                                                File croppedFile = await Get.find<AuthController>().cropImage(pickedFile);
                                                setState(() {
                                                  _imageFiles.add(croppedFile);
                                                });
                                                Get.back();
                                              },
                                              color: Colors.black,
                                              minWidth: double.infinity,
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                                              height: size.height * 0.1,
                                              child: const Text("Gallery", style: TextStyle(fontSize: 16.0, color: Colors.white)),
                                            ),
                                          ),
                                          SizedBox(height: size.height * 0.02),
                                        ],
                                      ),
                                    );
                                  } else {
                                    print('cant upload more than 3 images');
                                  }
                                },
                                child: Container(
                                  margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10.0)),
                                  child: const Center(child: Icon(Icons.add)),
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void postProduct(
  BuildContext context, {
  TextEditingController? nameController,
  descriptionController,
  priceController,
  categoryController,
  List<File>? imageFiles,
}) async {
  FocusScope.of(context).unfocus();
  Get.to(() => const Loading(), transition: Transition.fade);
  bool result = await Get.find<ApiController>().postProduct(
    nameController!.text,
    descriptionController.text,
    priceController.text.trim(),
    Get.find<ProductController>().selectedCategory.trim(),
    imageFiles!,
  );
  if (result) {
    print('posted');
  } else {
    print('unable to post');
  }
}
