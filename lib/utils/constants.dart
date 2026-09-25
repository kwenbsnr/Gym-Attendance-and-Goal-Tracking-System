import 'package:flutter/material.dart';

class AppColors {
  static const Color black = Color(0xFF1E1E1E);
  static const Color white = Color(0xFFFFFFFF);
  static const Color yellow = Color(0xFFFFD700);
  static const Color darkYellow = Color(0xFFCCB000);
  static const Color lightYellow = Color(0xFFFFF3C9);
  static const Color grey = Color(0xFFF5F5F5);
  static const Color darkGrey = Color(0xFF2D2D2D);
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  
  // Updated method using withValues (new Flutter syntax)
  static Color withOpacityColor(Color color, double opacity) {
    return color.withValues(alpha: opacity);
  }

  static Color withOpacity(Color color, double d) {
    return color.withValues(alpha: d);
  }
}

class AppTextStyles {
  static const String fontFamily = 'Poppins';
  
  static const TextStyle heading1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.black,
    letterSpacing: -0.5,
  );
  
  static const TextStyle heading2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.black,
    letterSpacing: -0.3,
  );
  
  static const TextStyle heading3 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.black,
  );
  
  static const TextStyle bodyText = TextStyle(
    fontSize: 16,
    color: AppColors.black,
  );
  
  static const TextStyle caption = TextStyle(
    fontSize: 14,
    color: Colors.grey,
  );
  
  static const TextStyle smallText = TextStyle(
    fontSize: 12,
    color: Colors.grey,
  );
  
  static const TextStyle buttonText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.black,
  );
}

class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
}

class AppBorderRadius {
  static const BorderRadius small = BorderRadius.all(Radius.circular(8));
  static const BorderRadius medium = BorderRadius.all(Radius.circular(12));
  static const BorderRadius large = BorderRadius.all(Radius.circular(16));
  static const BorderRadius xlarge = BorderRadius.all(Radius.circular(20));
  static const BorderRadius circle = BorderRadius.all(Radius.circular(100));
}