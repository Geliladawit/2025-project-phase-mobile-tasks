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
}