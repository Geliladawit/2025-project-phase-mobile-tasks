import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

import 'package:e_commerce/core/error/exception.dart';
import 'package:e_commerce/features/product/data/datasources/product_remote_data_source.dart';
import 'package:e_commerce/features/product/data/models/product_model.dart';

// Generate Mocks for http.Client
@GenerateMocks([http.Client])
import 'product_remote_data_source_test.mocks.dart';

void main() {
  late ProductRemoteDataSourceImpl dataSource;
  late MockClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockClient();
    dataSource = ProductRemoteDataSourceImpl(client: mockHttpClient);
  });

  const String baseUrl = 'https://g5-flutter-learning-path-be.onrender.com/api/v1/products';

  group('getAllProducts', () {
    final String tJsonListString = jsonEncode({
      "data": [
        {
          "id": "1",
          "name": "Test Shoe",
          "description": "Desc",
          "price": 100.0,
          "imageUrl": "img",
          "category": "Shoes"
        }
      ]
    });

    const tProductModel = ProductModel(
        id: '1', name: 'Test Shoe', description: 'Desc', price: 100.0, imageUrl: 'img', category: 'Shoes');
    final tProductList = [tProductModel];

    test('should perform a GET request on a URL with application/json header', () async {
      when(mockHttpClient.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(tJsonListString, 200));

      await dataSource.getAllProducts();

      verify(mockHttpClient.get(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
      ));
    });

    test('should return List<ProductModel> when the response code is 200', () async {
      when(mockHttpClient.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(tJsonListString, 200));

      final result = await dataSource.getAllProducts();

      expect(result, equals(tProductList));
    });

    test('should throw a ServerException when the response code is 404 or other', () async {
      when(mockHttpClient.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response('Something went wrong', 404));

      final call = dataSource.getAllProducts;

      expect(() => call(), throwsA(isA<ServerException>()));
    });
  });

  group('getProduct', () {
    const String tProductId = '1';
    final String tJsonString = jsonEncode({
      "data": {
        "id": "1",
        "name": "Test Shoe",
        "description": "Desc",
        "price": 100.0,
        "imageUrl": "img",
        "category": "Shoes"
      }
    });

    const tProductModel = ProductModel(
        id: '1', name: 'Test Shoe', description: 'Desc', price: 100.0, imageUrl: 'img', category: 'Shoes');

    test('should perform a GET request on a URL with application/json header', () async {
      when(mockHttpClient.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(tJsonString, 200));

      await dataSource.getProduct(tProductId);

      verify(mockHttpClient.get(
        Uri.parse('$baseUrl/$tProductId'),
        headers: {'Content-Type': 'application/json'},
      ));
    });

    test('should return ProductModel when the response code is 200', () async {
      when(mockHttpClient.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(tJsonString, 200));

      final result = await dataSource.getProduct(tProductId);

      expect(result, equals(tProductModel));
    });

    test('should throw a ServerException when the response code is 404 or other', () async {
      when(mockHttpClient.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response('Something went wrong', 404));

      final call = dataSource.getProduct;

      expect(() => call(tProductId), throwsA(isA<ServerException>()));
    });
  });

  group('createProduct', () {
    const tProductModel = ProductModel(
        id: '1', name: 'Test Shoe', description: 'Desc', price: 100.0, imageUrl: 'img', category: 'Shoes');
    final String tJsonString = jsonEncode({
      "data": {
        "id": "1",
        "name": "Test Shoe",
        "description": "Desc",
        "price": 100.0,
        "imageUrl": "img",
        "category": "Shoes"
      }
    });

    test('should perform a POST request on a URL with application/json header and body', () async {
      when(mockHttpClient.post(any, headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer((_) async => http.Response(tJsonString, 201));

      await dataSource.createProduct(tProductModel);

      verify(mockHttpClient.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(tProductModel.toJson()),
      ));
    });

    test('should return ProductModel when the response code is 201', () async {
      when(mockHttpClient.post(any, headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer((_) async => http.Response(tJsonString, 201));

      final result = await dataSource.createProduct(tProductModel);

      expect(result, equals(tProductModel));
    });

    test('should return ProductModel when the response code is 200', () async {
      when(mockHttpClient.post(any, headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer((_) async => http.Response(tJsonString, 200));

      final result = await dataSource.createProduct(tProductModel);

      expect(result, equals(tProductModel));
    });

    test('should throw a ServerException when the response code is 400 or other', () async {
      when(mockHttpClient.post(any, headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer((_) async => http.Response('Something went wrong', 400));

      final call = dataSource.createProduct;

      expect(() => call(tProductModel), throwsA(isA<ServerException>()));
    });
  });

  group('updateProduct', () {
    const tProductModel = ProductModel(
        id: '1', name: 'Updated Shoe', description: 'Updated Desc', price: 150.0, imageUrl: 'img2', category: 'Shoes');
    final String tJsonString = jsonEncode({
      "data": {
        "id": "1",
        "name": "Updated Shoe",
        "description": "Updated Desc",
        "price": 150.0,
        "imageUrl": "img2",
        "category": "Shoes"
      }
    });

    test('should perform a PUT request on a URL with application/json header and body', () async {
      when(mockHttpClient.put(any, headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer((_) async => http.Response(tJsonString, 200));

      await dataSource.updateProduct(tProductModel);

      verify(mockHttpClient.put(
        Uri.parse('$baseUrl/${tProductModel.id}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(tProductModel.toJson()),
      ));
    });

    test('should return ProductModel when the response code is 200', () async {
      when(mockHttpClient.put(any, headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer((_) async => http.Response(tJsonString, 200));

      final result = await dataSource.updateProduct(tProductModel);

      expect(result, equals(tProductModel));
    });

    test('should throw a ServerException when the response code is 404 or other', () async {
      when(mockHttpClient.put(any, headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer((_) async => http.Response('Something went wrong', 404));

      final call = dataSource.updateProduct;

      expect(() => call(tProductModel), throwsA(isA<ServerException>()));
    });
  });

  group('deleteProduct', () {
    const String tProductId = '1';

    test('should perform a DELETE request on a URL with application/json header', () async {
      when(mockHttpClient.delete(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response('', 200));

      await dataSource.deleteProduct(tProductId);

      verify(mockHttpClient.delete(
        Uri.parse('$baseUrl/$tProductId'),
        headers: {'Content-Type': 'application/json'},
      ));
    });

    test('should return void when the response code is 200', () async {
      when(mockHttpClient.delete(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response('', 200));

      await expectLater(dataSource.deleteProduct(tProductId), completes);
    });

    test('should throw a ServerException when the response code is 404 or other', () async {
      when(mockHttpClient.delete(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response('Something went wrong', 404));

      final call = dataSource.deleteProduct;

      expect(() => call(tProductId), throwsA(isA<ServerException>()));
    });
  });
}