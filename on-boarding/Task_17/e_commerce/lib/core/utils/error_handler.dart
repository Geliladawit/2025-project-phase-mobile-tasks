import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

/// Utility class for handling and displaying errors consistently across the app
class ErrorHandler {
  ErrorHandler._(); // Private constructor to prevent instantiation

  /// Shows a standardized error snackbar
  static void showErrorSnackBar(
    BuildContext context, {
    required String message,
    Color? backgroundColor,
    Duration? duration,
  }) {
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor ?? AppConstants.errorColor,
        duration: duration ?? AppConstants.snackBarDuration,
      ),
    );
  }

  /// Shows a success snackbar
  static void showSuccessSnackBar(
    BuildContext context, {
    required String message,
    Duration? duration,
  }) {
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: duration ?? AppConstants.snackBarDuration,
      ),
    );
  }

  /// Handles errors from async operations with appropriate error messages
  static void handleError(
    BuildContext context,
    dynamic error, {
    String? customMessage,
  }) {
    String message;
    
    if (customMessage != null) {
      message = customMessage;
    } else {
      // Default error message based on error type
      message = 'An error occurred. Please try again.';
    }

    showErrorSnackBar(context, message: message);
  }
}

