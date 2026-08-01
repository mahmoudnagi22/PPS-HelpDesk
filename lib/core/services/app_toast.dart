import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../constants/app_colors.dart';

class AppToast {
  static void primary(String message) => _show(message, AppColors.primary);

  static void success(String message) => _show(message, AppColors.success);

  static void danger(String message) => _show(message, AppColors.danger);

  static void _show(String message, Color backgroundColor) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: backgroundColor,
      textColor: AppColors.surface,
      fontSize: 14,
    );
  }
}
