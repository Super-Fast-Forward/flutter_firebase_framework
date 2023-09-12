import 'package:flutter/material.dart';

class Toast {
  Toast._();

  static final GlobalKey<ScaffoldMessengerState> key =
      GlobalKey<ScaffoldMessengerState>();

  static void showByContext({
    required BuildContext context,
    required String message,
    SnackbarType type = SnackbarType.error,
    Color? color,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      _getSnackBar(message, type, color: color),
    );
  }

  static void show({
    required String message,
    SnackbarType type = SnackbarType.error,
    Color? color,
  }) {
    key.currentState?.showSnackBar(
      _getSnackBar(message, type, color: color),
    );
  }

  static SnackBar _getSnackBar(
    String message,
    SnackbarType type, {
    Color? color,
  }) {
    return SnackBar(
      shape: const RoundedRectangleBorder(),
      content: Text(
        message,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
      backgroundColor: color ?? getBackgroundColor(type),
      behavior: SnackBarBehavior.floating,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14.0),
      margin: EdgeInsets.zero,
    );
  }

  static Color getBackgroundColor(SnackbarType type) {
    switch (type) {
      case SnackbarType.error:
        return Colors.red;
      case SnackbarType.success:
        return Colors.green;
      case SnackbarType.info:
        return Colors.blue;
      default:
        return Colors.black;
    }
  }
}

enum SnackbarType {
  error,
  success,
  info,
  normal,
}
