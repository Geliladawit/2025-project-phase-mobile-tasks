import 'package:flutter/material.dart';
import 'core/constants/app_constants.dart';
import 'core/injection.dart';
import 'core/utils/route_helper.dart';
import 'features/product/domain/entities/product.dart';
import 'features/product/presentation/pages/add_edit_product_screen.dart';
import 'features/product/presentation/pages/home_screen.dart';
import 'features/product/presentation/pages/product_detail_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Injection.init();
  runApp(const EcommerceApp());
}

class EcommerceApp extends StatelessWidget {
  const EcommerceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shoe Shop',
      theme: ThemeData(
        scaffoldBackgroundColor: AppConstants.scaffoldBackgroundColor,
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      initialRoute: AppConstants.homeRoute,
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case AppConstants.homeRoute:
            return MaterialPageRoute(builder: (_) => const HomeScreen());
          case AppConstants.detailsRoute:
            final product = settings.arguments as Product;
            return RouteHelper.createSlideRoute(
              ProductDetailScreen(product: product),
            );
          case AppConstants.addEditRoute:
            final product = settings.arguments as Product?;
            return RouteHelper.createSlideRoute(
              AddEditProductScreen(product: product),
            );
          default:
            return null;
        }
      },
    );
  }
}