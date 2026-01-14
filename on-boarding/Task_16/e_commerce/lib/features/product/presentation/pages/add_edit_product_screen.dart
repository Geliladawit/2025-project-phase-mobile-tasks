import 'package:flutter/material.dart';
import '../../../../core/injection.dart';
import '../../domain/entities/product.dart';

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

  Future<void> _saveForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        final newProduct = Product(
          id: widget.product?.id ?? DateTime.now().toString(),
          name: _nameController.text,
          category: _categoryController.text,
          price: double.tryParse(_priceController.text) ?? 0.0,
          description: _descController.text,
          imageUrl: _imgController.text,
        );

        if (widget.product != null) {
          await Injection.update.call(newProduct);
        } else {
          await Injection.create.call(newProduct);
        }
        
        if (mounted) {
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                widget.product != null 
                  ? 'Failed to update product. Please check your internet connection.'
                  : 'Failed to create product. Please check your internet connection.',
              ),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      }
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
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF3F51F3), padding: const EdgeInsets.symmetric(vertical: 16)),
                child: Text(isEditing ? "UPDATE PRODUCT" : "ADD PRODUCT", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
        labelText: label, hintText: hint, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), filled: true, fillColor: Colors.white),
      validator: (value) => value == null || value.isEmpty ? 'Please enter $label' : null,
    );
  }
}