import '../entities/product.dart';
import '../repositories/product_repo.dart';

class UpdateProductUsecase {
  final ProductRepository repository;
  UpdateProductUsecase(this.repository);

  Future<void> call(Product product) async {
    return await repository.updateProduct(product);
  }
}