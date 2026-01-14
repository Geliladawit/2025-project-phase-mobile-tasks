import '../entities/product.dart';
import '../repositories/product_repo.dart';

class GetSingleProductUsecase {
  final ProductRepository repository;
  GetSingleProductUsecase(this.repository);

  Future<Product> call(String id) async {
    return await repository.getProduct(id);
  }
}

