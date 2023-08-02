import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Toast {
  Toast._();

  static final GlobalKey<ScaffoldMessengerState> key =
      GlobalKey<ScaffoldMessengerState>();

  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason>? show(
    String message,
  ) =>
      key.currentState
          ?.showSnackBar(_getSnackBar(message, SnackbarType.normal));

  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason>?
      showByContext({
    required BuildContext context,
    required String message,
    SnackbarType type = SnackbarType.info,
    Color? color,
  }) {
    return ScaffoldMessenger.of(context).showSnackBar(
      _getSnackBar(message, type, color: color),
    );
  }

  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason>? showInfo(
    String message, {
    Color? color,
  }) {
    return key.currentState?.showSnackBar(
      _getSnackBar(message, SnackbarType.info, color: color),
    );
  }

  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason>? showError(
    String message,
  ) =>
      key.currentState?.showSnackBar(_getSnackBar(message, SnackbarType.error));

  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason>? showSuccess(
    String message,
  ) =>
      key.currentState
          ?.showSnackBar(_getSnackBar(message, SnackbarType.success));

  static SnackBar _getSnackBar(
    String message,
    SnackbarType type, {
    Color? color,
  }) {
    return SnackBar(
      shape: const RoundedRectangleBorder(),
      content: SizedBox(
        width: 1.0,
        child: Row(
          children: [
            if (getIcon(type) != null) ...[
              getIcon(type)!,
              const SizedBox(width: 8),
            ],
            Expanded(
              child: Text(
                message,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
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

  static Widget? getIcon(SnackbarType type) {
    switch (type) {
      case SnackbarType.error:
        return GestureDetector(
          onTap: () => key.currentState?.hideCurrentSnackBar(),
          child: SvgPicture.asset(
            'assets/close-line',
            color: Colors.white,
          ),
        );
      case SnackbarType.success:
        return const Icon(Icons.done, color: Colors.white);
      case SnackbarType.info:
        return SvgPicture.asset(
          'assets/information-line',
          color: Colors.white,
        );
      default:
        return null;
    }
  }
}

enum SnackbarType {
  error,
  success,
  info,
  normal,
}
