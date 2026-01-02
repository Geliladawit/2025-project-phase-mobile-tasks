import 'package:e_commerce/features/product/domain/usecases/delete_product.dart';
import 'package:flutter/material.dart';
import '../../../../core/injection.dart';
import '../../domain/entities/product.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Stack(
            children: [
              Container(height: 250, width: double.infinity, color: const Color(0xFFF0EFEF),
                child: Image.network(product.imageUrl, fit: BoxFit.cover)),
              Positioned(top: 40, left: 20,
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  child: const CircleAvatar(backgroundColor: Colors.white, child: Icon(Icons.arrow_back_ios_new, size: 18, color: Colors.black)),
                ),
              ),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(product.category, style: TextStyle(color: Colors.grey[500])),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text(product.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  Text("\$${product.price}", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ]),
                const SizedBox(height: 20),
                const Text("Description", style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Text(product.description, style: TextStyle(color: Colors.grey[600], height: 1.5)),
              ]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16), side: const BorderSide(color: Colors.red)),
                  onPressed: () async {
                    await sl<DeleteProductUsecase>().call(product.id);
                    if (context.mounted) Navigator.pop(context);
                  },
                  child: const Text("DELETE", style: TextStyle(color: Colors.red)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF3F51F3), padding: const EdgeInsets.symmetric(vertical: 16)),
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/add_edit', arguments: product);
                  },
                  child: const Text("UPDATE", style: TextStyle(color: Colors.white)),
                ),
              ),
            ]),
          )
        ],
      ),
    );
  }
}