import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../features/product/data/repositories/product_repository_impl.dart';
import '../features/product/data/datasources/product_remote_data_source.dart';
import '../features/product/data/datasources/product_local_data_source.dart';
import '../features/product/domain/repositories/product_repo.dart';
import '../features/product/domain/usecases/create_product.dart';
import '../features/product/domain/usecases/get_product.dart';
import '../features/product/domain/usecases/get_single_product.dart';
import '../features/product/domain/usecases/update_product.dart';
import '../features/product/domain/usecases/delete_product.dart';
import '../features/product/presentation/bloc/product_bloc.dart';
import 'network/network_info.dart';

final getIt = GetIt.instance;

class Injection {
  static Future<void> init() async {
    // 1. External Dependencies
    // Register SharedPreferences as async singleton
    final sharedPreferences = await SharedPreferences.getInstance();
    getIt.registerSingleton<SharedPreferences>(sharedPreferences);

    // Register http.Client as factory (can be created multiple times)
    getIt.registerFactory<http.Client>(() => http.Client());

    // 2. Network Info
    // Register NetworkInfo as factory (handles null InternetConnectionChecker on web)
    getIt.registerFactory<NetworkInfo>(
      () => NetworkInfoImpl(kIsWeb ? null : InternetConnectionChecker()),
    );

    // 3. Data Sources
    // Register ProductLocalDataSource as factory (depends on SharedPreferences)
    getIt.registerFactory<ProductLocalDataSource>(
      () => ProductLocalDataSourceImpl(
        sharedPreferences: getIt<SharedPreferences>(),
      ),
    );

    // Register ProductRemoteDataSource as factory (depends on http.Client)
    getIt.registerFactory<ProductRemoteDataSource>(
      () => ProductRemoteDataSourceImpl(
        client: getIt<http.Client>(),
      ),
    );

    // 4. Repository
    // Register ProductRepository as singleton (depends on Data Sources and NetworkInfo)
    getIt.registerSingleton<ProductRepository>(
      ProductRepositoryImpl(
        remoteDataSource: getIt<ProductRemoteDataSource>(),
        localDataSource: getIt<ProductLocalDataSource>(),
        networkInfo: getIt<NetworkInfo>(),
      ),
    );

    // 5. Use Cases
    // Register all Use Cases as singletons (depend on Repository)
    getIt.registerSingleton<ViewAllProductsUsecase>(
      ViewAllProductsUsecase(getIt<ProductRepository>()),
    );

    getIt.registerSingleton<GetSingleProductUsecase>(
      GetSingleProductUsecase(getIt<ProductRepository>()),
    );

    getIt.registerSingleton<CreateProductUsecase>(
      CreateProductUsecase(getIt<ProductRepository>()),
    );

    getIt.registerSingleton<UpdateProductUsecase>(
      UpdateProductUsecase(getIt<ProductRepository>()),
    );

    getIt.registerSingleton<DeleteProductUsecase>(
      DeleteProductUsecase(getIt<ProductRepository>()),
    );

    // 6. BLoC
    // Register ProductBloc as singleton (depends on Use Cases)
    getIt.registerSingleton<ProductBloc>(
      ProductBloc(
        getAllProduct: getIt<ViewAllProductsUsecase>(),
        getSingleProduct: getIt<GetSingleProductUsecase>(),
        createProduct: getIt<CreateProductUsecase>(),
        updateProduct: getIt<UpdateProductUsecase>(),
        deleteProduct: getIt<DeleteProductUsecase>(),
      ),
    );
  }
}
