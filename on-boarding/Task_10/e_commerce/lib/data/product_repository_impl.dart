import '../domain/entities/product.dart';
import '../domain/repositories/product_repo.dart';

class ProductRepositoryImpl implements ProductRepository {
  final List<Product> _products = [
    Product(
      id: '1',
      name: "Derby Leather Shoes",
      category: "Men's shoe",
      price: 120.00,
      description: "A classic and versatile footwear option characterized by its open lacing system.",
      imageUrl: "assets/images/DLS.png",
    ),
    Product(
      id: '2',
      name: "Cloud Running Sneaker",
      category: "Sports",
      price: 95.00,
      description: "Lightweight running shoes designed for marathon performance.",
      imageUrl: "assets/images/CRS.png",
    ),
  ];

  @override
  Future<List<Product>> getProducts() async {
    await Future.delayed(const Duration(milliseconds: 300)); // Simulate delay
    return _products;
  }

  @override
  Future<Product> getProduct(String id) async {
    return _products.firstWhere((element) => element.id == id);
  }

  @override
  Future<void> createProduct(Product product) async {
    _products.add(product);
  }

  @override
  Future<void> updateProduct(Product product) async {
    final index = _products.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      _products[index] = product;
    }
  }

  @override
  Future<void> deleteProduct(String id) async {
    _products.removeWhere((p) => p.id == id);
  }
}