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
import '../features/product/domain/usecases/get_single_product.dart';
import '../features/product/domain/usecases/update_product.dart';
import '../features/product/domain/usecases/delete_product.dart';
import '../features/product/presentation/bloc/product_bloc.dart';
import 'network/network_info.dart';

class Injection {
  static late final ProductRepository repo;
  static late final ViewAllProductsUsecase viewAll;
  static late final GetSingleProductUsecase getSingle;
  static late final CreateProductUsecase create;
  static late final UpdateProductUsecase update;
  static late final DeleteProductUsecase delete;
  static late final ProductBloc productBloc;

  static Future<void> init() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final connectionChecker = kIsWeb ? null : InternetConnectionChecker();
    final client = http.Client();

    final networkInfo = NetworkInfoImpl(connectionChecker);

    final localDataSource = ProductLocalDataSourceImpl(sharedPreferences: sharedPreferences);
    
    final remoteDataSource = ProductRemoteDataSourceImpl(client: client); 

    repo = ProductRepositoryImpl(
      remoteDataSource: remoteDataSource,
      localDataSource: localDataSource,
      networkInfo: networkInfo,
    );

    // 5. Use Cases
    viewAll = ViewAllProductsUsecase(repo);
    getSingle = GetSingleProductUsecase(repo);
    create = CreateProductUsecase(repo);
    update = UpdateProductUsecase(repo);
    delete = DeleteProductUsecase(repo);

    // 6. BLoC
    productBloc = ProductBloc(
      getAllProduct: viewAll,
      getSingleProduct: getSingle,
      createProduct: create,
      updateProduct: update,
      deleteProduct: delete,
    );
  }
}