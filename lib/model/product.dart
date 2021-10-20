import 'dart:convert';

import 'package:flutter/foundation.dart';

class Product {
  String? sId;
  String? posterId;
  String? posterName;
  String? posterPhoneNumber;
  String? posterProfileAvatar;
  String? name;
  String? description;
  String? price;
  String? category;
  String? datePosted;
  List<dynamic>? productImages;
  Product({
    this.sId,
    this.posterId,
    this.posterName,
    this.posterPhoneNumber,
    this.posterProfileAvatar,
    this.name,
    this.description,
    this.price,
    this.category,
    this.datePosted,
    this.productImages,
  });

  Product copyWith({
    String? sId,
    String? posterId,
    String? posterName,
    String? posterPhoneNumber,
    String? posterProfileAvatar,
    String? name,
    String? description,
    String? price,
    String? category,
    String? datePosted,
    List<dynamic>? productImages,
  }) {
    return Product(
      sId: sId ?? this.sId,
      posterId: posterId ?? this.posterId,
      posterName: posterName ?? this.posterName,
      posterPhoneNumber: posterPhoneNumber ?? this.posterPhoneNumber,
      posterProfileAvatar: posterProfileAvatar ?? this.posterProfileAvatar,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      category: category ?? this.category,
      datePosted: datePosted ?? this.datePosted,
      productImages: productImages ?? this.productImages,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'sId': sId,
      'posterId': posterId,
      'posterName': posterName,
      'posterPhoneNumber': posterPhoneNumber,
      'posterProfileAvatar': posterProfileAvatar,
      'name': name,
      'description': description,
      'price': price,
      'category': category,
      'datePosted': datePosted,
      'productImages': productImages,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      sId: map['sId'],
      posterId: map['posterId'],
      posterName: map['posterName'],
      posterPhoneNumber: map['posterPhoneNumber'],
      posterProfileAvatar: map['posterProfileAvatar'],
      name: map['name'],
      description: map['description'],
      price: map['price'],
      category: map['category'],
      datePosted: map['datePosted'],
      productImages: List<dynamic>.from(map['productImages']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) => Product.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Product(sId: $sId, posterId: $posterId, posterName: $posterName, posterPhoneNumber: $posterPhoneNumber, posterProfileAvatar: $posterProfileAvatar, name: $name, description: $description, price: $price, category: $category, datePosted: $datePosted, productImages: $productImages)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Product &&
        other.sId == sId &&
        other.posterId == posterId &&
        other.posterName == posterName &&
        other.posterPhoneNumber == posterPhoneNumber &&
        other.posterProfileAvatar == posterProfileAvatar &&
        other.name == name &&
        other.description == description &&
        other.price == price &&
        other.category == category &&
        other.datePosted == datePosted &&
        listEquals(other.productImages, productImages);
  }

  @override
  int get hashCode {
    return sId.hashCode ^
        posterId.hashCode ^
        posterName.hashCode ^
        posterPhoneNumber.hashCode ^
        posterProfileAvatar.hashCode ^
        name.hashCode ^
        description.hashCode ^
        price.hashCode ^
        category.hashCode ^
        datePosted.hashCode ^
        productImages.hashCode;
  }
}
