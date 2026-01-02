import 'dart:convert';
import 'package:http/http.dart' as http; 

import '../../../../core/error/exception.dart';
import '../models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getAllProducts();
  Future<ProductModel> getProduct(String id);
  Future<ProductModel> createProduct(ProductModel product);
  Future<ProductModel> updateProduct(ProductModel product);
  Future<void> deleteProduct(String id);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final http.Client client;

  ProductRemoteDataSourceImpl({required this.client}); 

  static const String baseUrl = 'https://g5-flutter-learning-path-be.onrender.com/api/v1/products';

  Map<String, String> get _headers => {'Content-Type': 'application/json'};

    dynamic _handleResponse(http.Response response) {
      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        throw ServerException();
      }
    }

  @override
  Future<List<ProductModel>> getAllProducts() async {
    final response = await client.get(Uri.parse(baseUrl), headers: _headers);
    
    final jsonResponse = _handleResponse(response);
    
    final List<dynamic> data = jsonResponse['data'];
    return data.map((json) => ProductModel.fromJson(json)).toList();
  }


  @override
  Future<ProductModel> getProduct(String id) async {
    final response = await client.get(Uri.parse('$baseUrl/$id'), headers: _headers);
    
    final jsonResponse = _handleResponse(response);
    return ProductModel.fromJson(jsonResponse['data']);
  }

  @override
  Future<ProductModel> createProduct(ProductModel product) async {
    final response = await client.post(
      Uri.parse(baseUrl),
      headers: _headers,
      body: json.encode(product.toJson()),
    );

    final jsonResponse = _handleResponse(response);
    return ProductModel.fromJson(jsonResponse['data']);
  }

  @override
  Future<ProductModel> updateProduct(ProductModel product) async {
    final response = await client.put(
      Uri.parse('$baseUrl/${product.id}'),
      headers: _headers,
      body: json.encode(product.toJson()),
    );

    final jsonResponse = _handleResponse(response);
    return ProductModel.fromJson(jsonResponse['data']);
  }

  @override
  Future<void> deleteProduct(String id) async {
    final response = await client.delete(Uri.parse('$baseUrl/$id'), headers: _headers);
    
    if (response.statusCode != 200) {
      throw ServerException();
    }
  }
}