import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/product_repo.dart';

class DeleteProductUsecase {
  final ProductRepository repository;
  DeleteProductUsecase(this.repository);

  Future<Either<Failure, void>> call(String id) async {
    try {
      await repository.deleteProduct(id);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}