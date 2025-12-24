import 'package:flutter/foundation.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../features/product/data/models/product_model.dart';
import '../features/product/data/repositories/product_repository_impl.dart';
import '../features/product/data/datasources/product_remote_data_source.dart';
import '../features/product/data/datasources/product_local_data_source.dart'; // Import real impl
import '../features/product/domain/repositories/product_repo.dart';
import '../features/product/domain/usecases/create_product.dart';
import '../features/product/domain/usecases/get_product.dart'; 
import '../features/product/domain/usecases/update_product.dart';
import '../features/product/domain/usecases/delete_product.dart';
import 'network/network_info.dart';

// ============================================================================
// TEMPORARY REMOTE IMPLEMENTATION (Still fake until next task)
// ============================================================================
class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final List<ProductModel> _products = [
    const ProductModel(
      id: '1',
      name: "Derby Leather Shoes",
      category: "Men's shoe",
      price: 120.00,
      description: "A classic and versatile footwear option.",
      imageUrl: "https://m.media-amazon.com/images/I/71o6t+6D7sL._AC_UY1000_.jpg",
    ),
  ];

  @override
  Future<List<ProductModel>> getAllProducts() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _products;
  }

  @override
  Future<ProductModel> getProduct(String id) async {
    return _products.firstWhere((element) => element.id == id);
  }

  @override
  Future<ProductModel> createProduct(ProductModel product) async {
    _products.add(product);
    return product;
  }

  @override
  Future<ProductModel> updateProduct(ProductModel product) async {
    return product;
  }

  @override
  Future<void> deleteProduct(String id) async {
    _products.removeWhere((p) => p.id == id);
  }
}

// ============================================================================
// DEPENDENCY INJECTION CONTAINER
// ============================================================================

class Injection {
  static late final ProductRepository repo;
  static late final ViewAllProductsUsecase viewAll;
  static late final CreateProductUsecase create;
  static late final UpdateProductUsecase update;
  static late final DeleteProductUsecase delete;

  // CALL THIS FROM main.dart
  static Future<void> init() async {
    // 1. External
    final sharedPreferences = await SharedPreferences.getInstance();
    final connectionChecker = kIsWeb ? null : InternetConnectionChecker();

    // 2. Core
    final networkInfo = NetworkInfoImpl(connectionChecker);

    // 3. Data Sources
    // USE THE REAL LOCAL DATA SOURCE NOW!
    final localDataSource = ProductLocalDataSourceImpl(sharedPreferences: sharedPreferences);
    final remoteDataSource = ProductRemoteDataSourceImpl();

    // 4. Repository
    repo = ProductRepositoryImpl(
      remoteDataSource: remoteDataSource,
      localDataSource: localDataSource,
      networkInfo: networkInfo,
    );

    // 5. Use Cases
    viewAll = ViewAllProductsUsecase(repo);
    create = CreateProductUsecase(repo);
    update = UpdateProductUsecase(repo);
    delete = DeleteProductUsecase(repo);
  }
}