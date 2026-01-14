import 'package:flutter/material.dart';

/// Application-wide constants
class AppConstants {
  AppConstants._(); // Private constructor to prevent instantiation

  // API Configuration
  static const String apiBaseUrl = 'https://g5-flutter-learning-path-be.onrender.com/api/v1/products';
  
  // Cache Keys
  static const String cachedProductsKey = 'CACHED_PRODUCTS';
  
  // Default Values
  static const String defaultImageUrl = 'assets/images/DLS.png';
  
  // App Colors
  static const Color primaryColor = Color(0xFF3F51F3);
  static const Color errorColor = Colors.red;
  static const Color scaffoldBackgroundColor = Color(0xFFF5F5F5);
  static const Color cardBackgroundColor = Colors.white;
  static const Color imagePlaceholderColor = Color(0xFFF0EFEF);
  
  // Spacing
  static const double defaultPadding = 20.0;
  static const double defaultSpacing = 15.0;
  static const double cardSpacing = 20.0;
  
  // Durations
  static const Duration snackBarDuration = Duration(seconds: 3);
  
  // Routes
  static const String homeRoute = '/';
  static const String detailsRoute = '/details';
  static const String addEditRoute = '/add_edit';
  
  // Messages
  static const String noProductsMessage = 'No products yet. Add one!';
  static const String loadingProductsError = 'Failed to load products. Showing cached data if available.';
  static const String createProductError = 'Failed to create product. Please check your internet connection.';
  static const String updateProductError = 'Failed to update product. Please check your internet connection.';
  static const String deleteProductError = 'Failed to delete product. Please check your internet connection.';
  
  // Validation Messages
  static String getRequiredFieldMessage(String fieldName) => 'Please enter $fieldName';
}

