import '../features/product/data/models/product_model.dart';
import '../features/product/data/repositories/product_repository_impl.dart';
import '../features/product/data/datasources/product_remote_data_source.dart';
import '../features/product/data/datasources/product_local_data_source.dart';
import '../features/product/domain/repositories/product_repo.dart';
import '../features/product/domain/usecases/create_product.dart';
import '../features/product/domain/usecases/get_product.dart'; 
import '../features/product/domain/usecases/update_product.dart';
import '../features/product/domain/usecases/delete_product.dart';
import 'network/network_info.dart';


class NetworkInfoImpl implements NetworkInfo {
  @override
  Future<bool> get isConnected => Future.value(true); 
}

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  @override
  Future<void> cacheProducts(List<ProductModel> productsToCache) async {} 
  
  @override
  Future<List<ProductModel>> getLastProducts() async => []; 

  @override
  Future<void> cacheProduct(ProductModel product) async {} 
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final List<ProductModel> _products = [
    const ProductModel(
      id: '1',
      name: "Derby Leather Shoes",
      category: "Men's shoe",
      price: 120.00,
      description: "A classic and versatile footwear option characterized by its open lacing system.",
      imageUrl: "assets/images/DLS.png",
    ),
    const ProductModel(
      id: '2',
      name: "Cloud Running Sneaker",
      category: "Sports",
      price: 95.00,
      description: "Lightweight running shoes designed for marathon performance.",
      imageUrl: "assets/images/CRS.png",
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
    final index = _products.indexWhere((p) => p.id == product.id);
    if (index != -1) _products[index] = product;
    return product;
  }

  @override
  Future<void> deleteProduct(String id) async {
    _products.removeWhere((p) => p.id == id);
  }
}

class Injection {
  static final NetworkInfo networkInfo = NetworkInfoImpl();
  static final ProductRemoteDataSource remoteDataSource = ProductRemoteDataSourceImpl();
  static final ProductLocalDataSource localDataSource = ProductLocalDataSourceImpl();

  static final ProductRepository repo = ProductRepositoryImpl(
    remoteDataSource: remoteDataSource,
    localDataSource: localDataSource,
    networkInfo: networkInfo,
  );

  static final ViewAllProductsUsecase viewAll = ViewAllProductsUsecase(repo);
  static final CreateProductUsecase create = CreateProductUsecase(repo);
  static final UpdateProductUsecase update = UpdateProductUsecase(repo);
  static final DeleteProductUsecase delete = DeleteProductUsecase(repo);
}