import 'package:e_commerce/features/product/domain/usecases/get_product.dart';
import 'package:flutter/material.dart';
import '../../../../core/injection.dart';
import '../../domain/entities/product.dart';
import '../widgets/product_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Product> products = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

Future<void> _loadData() async {
    final result = await sl<ViewAllProductsUsecase>().call();
    
    result.fold(
      (failure) {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      },
      (loadedProducts) {
        if (mounted) {
          setState(() {
            products = loadedProducts;
            isLoading = false;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Available Products", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : products.isEmpty
              ? const Center(child: Text("No products yet. Add one!"))
              : ListView.separated(
                  padding: const EdgeInsets.all(20),
                  itemCount: products.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 20),
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return GestureDetector(
                      onTap: () async {
                        await Navigator.pushNamed(context, '/details', arguments: product);
                        _loadData();
                      },
                      child: ProductCard(product: product),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF3F51F3),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () async {
          await Navigator.pushNamed(context, '/add_edit', arguments: null);
          _loadData();
        },
      ),
    );
  }
}