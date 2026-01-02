import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:e_commerce/features/product/data/models/product_model.dart'; 
import 'package:e_commerce/features/product/domain/entities/product.dart';

void main() {
  const tProductModel = ProductModel(
    id: '1',
    name: 'Test Shoe',
    description: 'Test Desc',
    price: 100.0,
    imageUrl: 'image.jpg',
    category: 'Shoes',
  );

  test('should be a subclass of Product entity', () async {
    expect(tProductModel, isA<Product>());
  });

  group('fromJson', () {
    test('should return a valid model when the JSON price is a double', () async {
      final Map<String, dynamic> jsonMap = {
        "id": "1",
        "name": "Test Shoe",
        "description": "Test Desc",
        "price": 100.0,
        "imageUrl": "image.jpg",
        "category": "Shoes"
      };
      final result = ProductModel.fromJson(jsonMap);
      expect(result, tProductModel);
    });

    test('should return a valid model when the JSON price is an integer', () async {
      final Map<String, dynamic> jsonMap = {
        "id": "1",
        "name": "Test Shoe",
        "description": "Test Desc",
        "price": 100, 
        "imageUrl": "image.jpg",
        "category": "Shoes"
      };
      final result = ProductModel.fromJson(jsonMap);
      expect(result, tProductModel);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing the proper data', () async {
      final result = tProductModel.toJson();
      final expectedMap = {
        "id": "1",
        "name": "Test Shoe",
        "description": "Test Desc",
        "price": 100.0,
        "imageUrl": "image.jpg",
        "category": "Shoes"
      };
      expect(result, expectedMap);
    });
  });
}