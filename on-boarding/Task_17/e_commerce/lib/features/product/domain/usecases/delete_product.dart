import '../repositories/product_repo.dart';

class DeleteProductUsecase {
  final ProductRepository repository;
  DeleteProductUsecase(this.repository);

  Future<void> call(String id) async {
    return await repository.deleteProduct(id);
  }
}