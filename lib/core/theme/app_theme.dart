import 'package:flutter/material.dart';

abstract class AppColors {
  static const primary = Color(0xFF1c6b3a);
  static const background = Color(0xFFF8F9FA);
  static const surface = Colors.white;
  static const text = Color(0xFF212529);
  static const textSecondary = Color(0xFF868E96);
  static const divider = Color(0xFFE9ECEF);
}

abstract class AppStyles {
  // Spacing
  static const defaultSpacing = 16.0;
  static const smallSpacing = 8.0;
  static const largeSpacing = 24.0;

  // Radius
  static const defaultRadius = 8.0;
  static const largeRadius = 16.0;

  // Padding
  static const defaultPadding = EdgeInsets.all(defaultSpacing);
  static const horizontalPadding = EdgeInsets.symmetric(horizontal: defaultSpacing);
  static const verticalPadding = EdgeInsets.symmetric(vertical: defaultSpacing);

  // Text Styles
  static const titleLarge = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    height: 1.4,
  );

  static const titleMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    height: 1.4,
  );

  static const bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.6,
  );

  static const bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.6,
  );

  static const labelLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  static const labelMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );
}

class AppTheme {
  static ThemeData light() {
    return ThemeData.light(
      useMaterial3: true,
    ).copyWith(
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.text,
        titleTextStyle: AppStyles.titleLarge.copyWith(
          color: AppColors.text,
        ),
      ),
      cardTheme: const CardTheme(
        elevation: 0.5,
        margin: EdgeInsets.symmetric(
          horizontal: AppStyles.defaultSpacing,
          vertical: AppStyles.smallSpacing,
        ),
        color: AppColors.surface,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppStyles.defaultRadius),
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppStyles.defaultRadius),
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppStyles.defaultRadius),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
        contentPadding: AppStyles.defaultPadding,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.surface,
          padding: const EdgeInsets.symmetric(
            vertical: AppStyles.defaultSpacing,
            horizontal: AppStyles.defaultSpacing,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppStyles.defaultRadius),
          ),
          textStyle: AppStyles.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            vertical: AppStyles.defaultSpacing,
            horizontal: AppStyles.defaultSpacing,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppStyles.defaultRadius),
          ),
          side: const BorderSide(color: AppColors.divider),
          textStyle: AppStyles.labelLarge,
        ),
      ),
      textTheme: const TextTheme(
        titleLarge: AppStyles.titleLarge,
        titleMedium: AppStyles.titleMedium,
        bodyLarge: AppStyles.bodyLarge,
        bodyMedium: AppStyles.bodyMedium,
        labelLarge: AppStyles.labelLarge,
        labelMedium: AppStyles.labelMedium,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
        space: 1,
      ),
    );
  }
}
