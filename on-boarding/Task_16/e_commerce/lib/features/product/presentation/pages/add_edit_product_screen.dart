import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/injection.dart';
import '../../../../core/utils/error_handler.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
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
    _imgController = TextEditingController(
      text: widget.product?.imageUrl ?? AppConstants.defaultImageUrl,
    );
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
        
        if (!mounted) return;
        Navigator.pop(context);
      } catch (e) {
        if (!mounted) return;
        ErrorHandler.showErrorSnackBar(
          context,
          message: widget.product != null
              ? AppConstants.updateProductError
              : AppConstants.createProductError,
        );
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
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              CustomTextField(
                controller: _nameController,
                label: "Name",
                hint: "Enter product name",
              ),
              const SizedBox(height: AppConstants.defaultSpacing),
              CustomTextField(
                controller: _categoryController,
                label: "Category",
                hint: "e.g. Men's Shoe",
              ),
              const SizedBox(height: AppConstants.defaultSpacing),
              CustomTextField(
                controller: _priceController,
                label: "Price",
                hint: "0.00",
                isNumber: true,
              ),
              const SizedBox(height: AppConstants.defaultSpacing),
              CustomTextField(
                controller: _descController,
                label: "Description",
                hint: "Enter details...",
                maxLines: 4,
              ),
              const SizedBox(height: AppConstants.defaultSpacing),
              CustomTextField(
                controller: _imgController,
                label: "Image URL",
                hint: "Paste image link",
              ),
              const SizedBox(height: 30),
              CustomButton(
                text: isEditing ? "UPDATE PRODUCT" : "ADD PRODUCT",
                onPressed: _saveForm,
              ),
            ],
          ),
        ),
      ),
    );
  }
}