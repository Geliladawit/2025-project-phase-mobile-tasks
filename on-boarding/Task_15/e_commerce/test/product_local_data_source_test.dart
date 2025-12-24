import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:e_commerce/core/error/exception.dart';
import 'package:e_commerce/features/product/data/datasources/product_local_data_source.dart';
import 'package:e_commerce/features/product/data/models/product_model.dart';

// Generate Mock for SharedPreferences
@GenerateMocks([SharedPreferences])
import 'product_local_data_source_test.mocks.dart';

void main() {
  late ProductLocalDataSourceImpl dataSource;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = ProductLocalDataSourceImpl(sharedPreferences: mockSharedPreferences);
  });

  group('getLastProducts', () {
    final tProductModelList = [
      const ProductModel(id: '1', name: 'Test', description: 'Desc', price: 100, imageUrl: 'img', category: 'Cat')
    ];

    test('should return ProductModel List from SharedPreferences when there is one in the cache', () async {
      // arrange
      // Create the JSON string that SharedPreferences would return
      final List<Map<String, dynamic>> jsonMapList = tProductModelList.map((e) => e.toJson()).toList();
      final String jsonString = json.encode(jsonMapList);
      
      when(mockSharedPreferences.getString(any)).thenReturn(jsonString);

      // act
      final result = await dataSource.getLastProducts();

      // assert
      verify(mockSharedPreferences.getString('CACHED_PRODUCTS'));
      expect(result, equals(tProductModelList));
    });

    test('should throw a CacheException when there is not a cached value', () async {
      // arrange
      when(mockSharedPreferences.getString(any)).thenReturn(null);

      // act
      final call = dataSource.getLastProducts;

      // assert
      expect(() => call(), throwsA(isA<CacheException>()));
    });
  });

  group('cacheProducts', () {
    final tProductModelList = [
      const ProductModel(id: '1', name: 'Test', description: 'Desc', price: 100, imageUrl: 'img', category: 'Cat')
    ];

    test('should call SharedPreferences to cache the data', () async {
      // arrange
      when(mockSharedPreferences.setString(any, any)).thenAnswer((_) async => true);

      // act
      await dataSource.cacheProducts(tProductModelList);

      // assert
      final expectedJsonString = json.encode(tProductModelList.map((e) => e.toJson()).toList());
      verify(mockSharedPreferences.setString('CACHED_PRODUCTS', expectedJsonString));
    });
  });
}