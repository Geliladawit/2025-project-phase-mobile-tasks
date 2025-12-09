import '../data/product_repository_impl.dart';
import '../domain/repositories/product_repo.dart';
import '../domain/usecases/create_product.dart';
import '../domain/usecases/delete_product.dart';
import '../domain/usecases/get_product.dart';
import '../domain/usecases/update_product.dart';

class Injection {
  static final ProductRepository repo = ProductRepositoryImpl();

  static final ViewAllProductsUsecase viewAll = ViewAllProductsUsecase(repo);
  static final CreateProductUsecase create = CreateProductUsecase(repo);
  static final UpdateProductUsecase update = UpdateProductUsecase(repo);
  static final DeleteProductUsecase delete = DeleteProductUsecase(repo);
}