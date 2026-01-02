import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:e_commerce/core/error/exception.dart';
import 'package:e_commerce/core/network/network_info.dart';
import 'package:e_commerce/features/product/data/datasources/product_local_data_source.dart';
import 'package:e_commerce/features/product/data/datasources/product_remote_data_source.dart';
import 'package:e_commerce/features/product/data/models/product_model.dart';
import 'package:e_commerce/features/product/data/repositories/product_repository_impl.dart';
import 'package:e_commerce/features/product/domain/entities/product.dart';

// Generate Mocks
@GenerateMocks([ProductRemoteDataSource, ProductLocalDataSource, NetworkInfo])
import 'product_repository_impl_test.mocks.dart';

void main() {
  late ProductRepositoryImpl repository;
  late MockProductRemoteDataSource mockRemoteDataSource;
  late MockProductLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockProductRemoteDataSource();
    mockLocalDataSource = MockProductLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = ProductRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  group('getProducts', () {
    const tProductModel = ProductModel(
        id: '1', name: 'Test', description: 'Desc', price: 100, imageUrl: 'img', category: 'Cat');
    final tProductModelList = [tProductModel];
    final List<Product> tProductList = tProductModelList;

    test('should check if the device is online', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDataSource.getAllProducts()).thenAnswer((_) async => []);
      
      await repository.getProducts();
      
      verify(mockNetworkInfo.isConnected);
    });

    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test('should return remote data when call is successful', () async {
        when(mockRemoteDataSource.getAllProducts()).thenAnswer((_) async => tProductModelList);

        final result = await repository.getProducts();

        verify(mockRemoteDataSource.getAllProducts());
        expect(result, equals(tProductList));
      });

      test('should cache data locally when call is successful', () async {
        when(mockRemoteDataSource.getAllProducts()).thenAnswer((_) async => tProductModelList);

        await repository.getProducts();

        verify(mockRemoteDataSource.getAllProducts());
        verify(mockLocalDataSource.cacheProducts(tProductModelList));
      });

      test('should throw ServerException when call is unsuccessful', () async {
        when(mockRemoteDataSource.getAllProducts()).thenThrow(ServerException());

        expect(() => repository.getProducts(), throwsA(isA<ServerException>()));
      });
    });

    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test('should return last locally cached data', () async {
        when(mockLocalDataSource.getLastProducts()).thenAnswer((_) async => tProductModelList);

        final result = await repository.getProducts();

        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastProducts());
        expect(result, equals(tProductList));
      });

      test('should throw CacheException when no cached data is present', () async {
        when(mockLocalDataSource.getLastProducts()).thenThrow(CacheException());

        expect(() => repository.getProducts(), throwsA(isA<CacheException>()));
      });
    });
  });
}