import '../../../../core/network/network_info.dart';
import '../../../../core/utils/product_mapper.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repo.dart';
import '../datasources/product_local_data_source.dart';
import '../datasources/product_remote_data_source.dart';

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
      try {
        final remoteProducts = await remoteDataSource.getAllProducts();
        await localDataSource.cacheProducts(remoteProducts);
        return remoteProducts;
      } catch (e) {
        // If remote fetch fails, try to get cached data
        try {
          return await localDataSource.getLastProducts();
        } catch (cacheException) {
          // If no cached data exists, rethrow the original server exception
          throw e;
        }
      }
    } else {
      return await localDataSource.getLastProducts();
    }
  }

  @override
  Future<Product> getProduct(String id) async {
    return await remoteDataSource.getProduct(id);
  }

  @override
  Future<void> createProduct(Product product) async {
    final productModel = ProductMapper.toModel(product);
    await remoteDataSource.createProduct(productModel);
  }

  @override
  Future<void> updateProduct(Product product) async {
    final productModel = ProductMapper.toModel(product);
    await remoteDataSource.updateProduct(productModel);
  }

  @override
  Future<void> deleteProduct(String id) async {
    await remoteDataSource.deleteProduct(id);
  }
}