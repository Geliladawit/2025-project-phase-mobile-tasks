import '../features/product/data/repositories/product_repository_impl.dart';
import '../features/product/domain/repositories/product_repo.dart';
import '../features/product/domain/usecases/create_product.dart';
import '../features/product/domain/usecases/delete_product.dart';
import '../features/product/domain/usecases/get_product.dart';
import '../features/product/domain/usecases/update_product.dart';

class Injection {
  static final ProductRepository repo = ProductRepositoryImpl();

  static final ViewAllProductsUsecase viewAll = ViewAllProductsUsecase(repo);
  static final CreateProductUsecase create = CreateProductUsecase(repo);
  static final UpdateProductUsecase update = UpdateProductUsecase(repo);
  static final DeleteProductUsecase delete = DeleteProductUsecase(repo);
}