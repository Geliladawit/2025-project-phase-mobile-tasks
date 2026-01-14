import '../entities/product.dart';
import '../repositories/product_repo.dart';

class CreateProductUsecase {
  final ProductRepository repository;
  CreateProductUsecase(this.repository);

  Future<void> call(Product product) async {
    return await repository.createProduct(product);
  }
}