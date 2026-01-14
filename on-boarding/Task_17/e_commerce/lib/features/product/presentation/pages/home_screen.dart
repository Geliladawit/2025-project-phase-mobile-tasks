import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/injection.dart';
import '../../domain/usecases/get_product.dart';
import '../../../../core/utils/error_handler.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/widgets/loading_indicator.dart';
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
    try {
      final result = await getIt<ViewAllProductsUsecase>().call();
      if (mounted) {
        setState(() {
          products = result;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        ErrorHandler.showErrorSnackBar(
          context,
          message: AppConstants.loadingProductsError,
        );
      }
    }
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
          ? const LoadingIndicator()
          : products.isEmpty
              ? EmptyStateWidget(
                  message: AppConstants.noProductsMessage,
                  icon: Icons.inventory_2_outlined,
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(AppConstants.defaultPadding),
                  itemCount: products.length,
                  separatorBuilder: (_, __) => const SizedBox(height: AppConstants.cardSpacing),
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return GestureDetector(
                      onTap: () async {
                        await Navigator.pushNamed(
                          context,
                          AppConstants.detailsRoute,
                          arguments: product,
                        );
                        _loadData();
                      },
                      child: ProductCard(product: product),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppConstants.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () async {
          await Navigator.pushNamed(
            context,
            AppConstants.addEditRoute,
            arguments: null,
          );
          _loadData();
        },
      ),
    );
  }
}