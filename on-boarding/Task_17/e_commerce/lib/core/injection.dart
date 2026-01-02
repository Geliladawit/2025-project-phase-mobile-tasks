import 'package:get_it/get_it.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../features/product/data/repositories/product_repository_impl.dart';
import '../features/product/data/datasources/product_remote_data_source.dart';
import '../features/product/data/datasources/product_local_data_source.dart';
import '../features/product/domain/repositories/product_repo.dart';
import '../features/product/domain/usecases/create_product.dart';
import '../features/product/domain/usecases/get_product.dart'; 
import '../features/product/domain/usecases/update_product.dart';
import '../features/product/domain/usecases/delete_product.dart';
import 'network/network_info.dart';
import '../features/product/presentation/bloc/product_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Features - Product
  
  sl.registerLazySingleton(() => ViewAllProductsUsecase(sl()));
  sl.registerLazySingleton(() => CreateProductUsecase(sl()));
  sl.registerLazySingleton(() => UpdateProductUsecase(sl()));
  sl.registerLazySingleton(() => DeleteProductUsecase(sl()));

  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  sl.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(client: sl()),
  );

  sl.registerLazySingleton<ProductLocalDataSource>(
    () => ProductLocalDataSourceImpl(sharedPreferences: sl()),
  );

  // Core
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(sl()),
  );
  // Bloc
  sl.registerFactory(
    () => ProductBloc(
      viewAllProductsUsecase: sl(),
      getProductUsecase: sl(), 
      createProductUsecase: sl(),
      updateProductUsecase: sl(),
      deleteProductUsecase: sl(),
    ),
  );
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  
  sl.registerLazySingleton(() => http.Client());
  
  if (kIsWeb) {
    if (!kIsWeb) {
      sl.registerLazySingleton(() => InternetConnectionChecker());
    }
  } else {
    sl.registerLazySingleton(() => InternetConnectionChecker());
  }
}