import '../../features/product/domain/entities/product.dart';
import '../../features/product/data/models/product_model.dart';

/// Utility class for mapping between Product entity and ProductModel
/// Eliminates code duplication in repository layer
class ProductMapper {
  ProductMapper._(); // Private constructor to prevent instantiation

  /// Converts a Product entity to ProductModel
  static ProductModel toModel(Product product) {
    return ProductModel(
      id: product.id,
      name: product.name,
      category: product.category,
      price: product.price,
      description: product.description,
      imageUrl: product.imageUrl,
    );
  }

  /// Converts a ProductModel to Product entity
  /// Note: ProductModel extends Product, so this is mainly for consistency
  static Product toEntity(ProductModel model) {
    return Product(
      id: model.id,
      name: model.name,
      category: model.category,
      price: model.price,
      description: model.description,
      imageUrl: model.imageUrl,
    );
  }

  /// Converts a list of ProductModel to list of Product entities
  static List<Product> toEntityList(List<ProductModel> models) {
    return models.map((model) => toEntity(model)).toList();
  }
}

