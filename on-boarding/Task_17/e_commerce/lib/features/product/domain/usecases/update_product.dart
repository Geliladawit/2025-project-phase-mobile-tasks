import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/product.dart';
import '../repositories/product_repo.dart';

class UpdateProductUsecase {
  final ProductRepository repository;
  UpdateProductUsecase(this.repository);

  Future<Either<Failure, void>> call(Product product) async {
    try {
      await repository.updateProduct(product);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}