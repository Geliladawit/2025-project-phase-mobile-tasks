import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/product.dart';
import '../repositories/product_repo.dart';

class CreateProductUsecase {
  final ProductRepository repository;
  CreateProductUsecase(this.repository);

  Future<Either<Failure, void>> call(Product product) async {
    try {
      await repository.createProduct(product);
      return const Right(null); 
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}