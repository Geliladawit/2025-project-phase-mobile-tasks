import '../../../../core/network/network_info.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repo.dart';
import '../datasources/product_local_data_source.dart';
import '../datasources/product_remote_data_source.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;
  final ProductLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  ProductRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<List<Product>> getProducts() async {
    if (await networkInfo.isConnected) {
      // 1. Fetch from Remote
      final remoteProducts = await remoteDataSource.getAllProducts();
      // 2. Cache Data
      await localDataSource.cacheProducts(remoteProducts);
      // 3. Return Data
      return remoteProducts;
    } else {
      // 1. Fetch from Local Cache
      return await localDataSource.getLastProducts();
    }
  }

  @override
  Future<Product> getProduct(String id) async {
    // For specific product, we usually always try network first
    // You could implement offline logic here too if you want
    return await remoteDataSource.getProduct(id);
  }

  @override
  Future<void> createProduct(Product product) async {
    // Convert Entity to Model
    final productModel = ProductModel(
      id: product.id,
      name: product.name,
      category: product.category,
      price: product.price,
      description: product.description,
      imageUrl: product.imageUrl,
    );
    await remoteDataSource.createProduct(productModel);
  }

  @override
  Future<void> updateProduct(Product product) async {
    final productModel = ProductModel(
      id: product.id,
      name: product.name,
      category: product.category,
      price: product.price,
      description: product.description,
      imageUrl: product.imageUrl,
    );
    await remoteDataSource.updateProduct(productModel);
  }

  @override
  Future<void> deleteProduct(String id) async {
    await remoteDataSource.deleteProduct(id);
  }
}