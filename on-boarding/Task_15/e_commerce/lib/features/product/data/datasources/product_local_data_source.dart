import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/error/exception.dart';
import '../models/product_model.dart';

abstract class ProductLocalDataSource {
  Future<List<ProductModel>> getLastProducts();
  Future<void> cacheProducts(List<ProductModel> productsToCache);
}

const CACHED_PRODUCTS = 'CACHED_PRODUCTS';

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  final SharedPreferences sharedPreferences;

  ProductLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<ProductModel>> getLastProducts() {
    final jsonString = sharedPreferences.getString(CACHED_PRODUCTS);
    
    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      
      final List<ProductModel> products = jsonList
          .map((jsonItem) => ProductModel.fromJson(jsonItem))
          .toList();
          
      return Future.value(products);
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheProducts(List<ProductModel> productsToCache) {
    final List<Map<String, dynamic>> jsonList = 
        productsToCache.map((product) => product.toJson()).toList();
    
    final String jsonString = json.encode(jsonList);
    
    return sharedPreferences.setString(CACHED_PRODUCTS, jsonString);
  }
}