import '../entities/product.dart';
import '../repositories/product_repo.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';

class ViewAllProductsUsecase {
  final ProductRepository repository;

  ViewAllProductsUsecase(this.repository);

  Future<Either<Failure, List<Product>>> call() async {
    try {
      final products = await repository.getProducts();
      return Right(products);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}

class GetProduct {
  final ProductRepository repository;

  GetProduct(this.repository);
  Future<Either<Failure, Product>> call(String id) async {
    try {
      final product = await repository.getProduct(id);
      return Right(product);
    } catch (e) {
      return Left(ServerFailure()); 
    }
  }
}