import 'package:flutter/material.dart';

class Product {
  final String id;
  final String name;
  final String category;
  final double price;
  final String description;
  final String imageUrl;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.description,
    required this.imageUrl,
  });
}

void main() {
  runApp(const EcommerceApp());
}

class EcommerceApp extends StatefulWidget {
  const EcommerceApp({super.key});

  @override
  State<EcommerceApp> createState() => _EcommerceAppState();
}

class _EcommerceAppState extends State<EcommerceApp> {
  List<Product> products = [
    Product(
      id: '1',
      name: "Derby Leather Shoes",
      category: "Men's shoe",
      price: 120.00,
      description: "A classic and versatile footwear option characterized by its open lacing system.",
      imageUrl: 'assets/images/DLS.png',
    ),
    Product(
      id: '2',
      name: "Cloud Running Sneaker",
      category: "Sports",
      price: 95.00,
      description: "Lightweight running shoes designed for marathon performance.",
      imageUrl: 'assets/images/CRS.png', 
    ),
  ];

  // Helper to handle Create/Update/Delete from the Home Screen
  void _handleProductUpdate(dynamic result) {
    if (result == null) return;

    setState(() {
      if (result is Map && result['action'] == 'delete') {
        products.removeWhere((p) => p.id == result['id']);
      } else if (result is Product) {
        final index = products.indexWhere((p) => p.id == result.id);
        if (index != -1) {
          products[index] = result; 
        } else {
          products.add(result);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shoe Shop',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(
              builder: (_) => HomeScreen(
                products: products,
                onListUpdate: _handleProductUpdate,
              ),
            );
          case '/details':
            final product = settings.arguments as Product;
            return _createRoute(ProductDetailScreen(product: product));
          case '/add_edit':
            final product = settings.arguments as Product?;
            return _createRoute(AddEditProductScreen(product: product));
          default:
            return null;
        }
      },
    );
  }

  // Animation Helper
  Route _createRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(position: animation.drive(tween), child: child);
      },
    );
  }
}

//  HOME
class HomeScreen extends StatelessWidget {
  final List<Product> products;
  final Function(dynamic) onListUpdate;

  const HomeScreen({super.key, required this.products, required this.onListUpdate});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Available Products", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: products.isEmpty 
        ? const Center(child: Text("No products yet. Add one!")) 
        : ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: products.length,
            separatorBuilder: (_, __) => const SizedBox(height: 20),
            itemBuilder: (context, index) {
              final product = products[index];
              return GestureDetector(
                onTap: () async {
                  final result = await Navigator.pushNamed(context, '/details', arguments: product);
                  onListUpdate(result);
                },
                child: _ProductCard(product: product),
              );
            },
          ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF3F51F3),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () async {
          final result = await Navigator.pushNamed(context, '/add_edit', arguments: null);
          onListUpdate(result);
        },
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Product product;
  const _ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(product.imageUrl, width: 80, height: 80, fit: BoxFit.cover,
              errorBuilder: (c, e, s) => Container(width: 80, height: 80, color: Colors.grey[200], child: const Icon(Icons.broken_image))),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text(product.category, style: TextStyle(color: Colors.grey[500])),
                const SizedBox(height: 4),
                Text("\$${product.price}", style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          )
        ],
      ),
    );
  }
}

// DETAILS
class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Image Header
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
          // Content
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
          // Buttons
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16), side: const BorderSide(color: Colors.red)),
                  onPressed: () {
                    Navigator.pop(context, {'action': 'delete', 'id': product.id});
                  },
                  child: const Text("DELETE", style: TextStyle(color: Colors.red)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF3F51F3), padding: const EdgeInsets.symmetric(vertical: 16)),
                  onPressed: () async {
                    final updatedProduct = await Navigator.pushNamed(context, '/add_edit', arguments: product);
                    if (updatedProduct != null) {
                      if(context.mounted) Navigator.pop(context, updatedProduct);
                    }
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

// ADD / EDIT 
class AddEditProductScreen extends StatefulWidget {
  final Product? product; 

  const AddEditProductScreen({super.key, this.product});

  @override
  State<AddEditProductScreen> createState() => _AddEditProductScreenState();
}

class _AddEditProductScreenState extends State<AddEditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _descController;
  late TextEditingController _categoryController;
  late TextEditingController _imgController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product?.name ?? '');
    _priceController = TextEditingController(text: widget.product?.price.toString() ?? '');
    _descController = TextEditingController(text: widget.product?.description ?? '');
    _categoryController = TextEditingController(text: widget.product?.category ?? '');
    _imgController = TextEditingController(text: widget.product?.imageUrl ?? 'assets/images/DLS.png');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descController.dispose();
    _categoryController.dispose();
    _imgController.dispose();
    super.dispose();
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      final newProduct = Product(
        id: widget.product?.id ?? DateTime.now().toString(), 
        name: _nameController.text,
        category: _categoryController.text,
        price: double.tryParse(_priceController.text) ?? 0.0,
        description: _descController.text,
        imageUrl: _imgController.text,
      );

      Navigator.pop(context, newProduct);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.product != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? "Edit Product" : "Add Product"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context), 
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField(_nameController, "Name", "Enter product name"),
              const SizedBox(height: 15),
              _buildTextField(_categoryController, "Category", "e.g. Men's Shoe"),
              const SizedBox(height: 15),
              _buildTextField(_priceController, "Price", "0.00", isNumber: true),
              const SizedBox(height: 15),
              _buildTextField(_descController, "Description", "Enter details...", maxLines: 4),
              const SizedBox(height: 15),
              _buildTextField(_imgController, "Image URL", "Paste image link"),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _saveForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3F51F3),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Text(isEditing ? "UPDATE PRODUCT" : "ADD PRODUCT", 
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, String hint, {bool isNumber = false, int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.white,
      ),
      validator: (value) => value == null || value.isEmpty ? 'Please enter $label' : null,
    );
  }
}