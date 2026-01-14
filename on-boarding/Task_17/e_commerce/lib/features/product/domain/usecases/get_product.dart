import '../entities/product.dart';
import '../repositories/product_repo.dart';

class ViewAllProductsUsecase {
  final ProductRepository repository;
  ViewAllProductsUsecase(this.repository);

  Future<List<Product>> call() async {
    return await repository.getProducts();
  }
}