import 'package:flutter/material.dart';
import 'app_style.dart';

class AppTheme {
  static ThemeData light() {
    return ThemeData.light(useMaterial3: true).copyWith(
      visualDensity: VisualDensity.adaptivePlatformDensity,
      primaryColor: Colors.green,
      elevatedButtonTheme:
          ElevatedButtonThemeData(style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green.shade50
          )),
      popupMenuTheme: PopupMenuThemeData(color: Colors.green.shade50),
      floatingActionButtonTheme: FloatingActionButtonThemeData(),
      appBarTheme: AppBarTheme(),
      listTileTheme: ListTileThemeData(
        titleTextStyle: TextStyle(color: Colors.white),
        subtitleTextStyle: TextStyle(color: Colors.grey),
        tileColor: Colors.blueAccent,
        selectedTileColor: Colors.deepPurple,
        iconColor: Colors.green,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 2),
      ),
      cardTheme: CardTheme(
        color: Colors.white,
        shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(30))),
        // color: Colors.white,
        // shape: RoundedRectangleBorder(
        //     borderRadius: BorderRadius.all(Radius.circular(30))),
        margin: EdgeInsets.all(10),
      ),
      inputDecorationTheme: InputDecorationTheme(
          hintStyle: TextStyle(color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide(color: Colors.green),
          ),
          // enabledBorder: OutlineInputBorder(
          //   borderRadius: BorderRadius.circular(12),
          //   borderSide: const BorderSide(color: Colors.deepPurple),
          // ),
          // focusedBorder: OutlineInputBorder(
          //   borderRadius: BorderRadius.circular(12),
          //   borderSide: const BorderSide(color: Colors.black),
          // ),
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
      textTheme: TextTheme(
        // titleLarge: AppStyle.chatText(),
        // titleMedium: AppStyle.chatText(),
        bodyLarge: AppStyle.generalText(),
        bodyMedium: AppStyle.generalText(),
        // labelLarge:AppStyle.chatText() ,
        // labelMedium: AppStyle.chatText(),
      ),
    );
  }

  static ThemeData dark() {
    return ThemeData.dark().copyWith(
      primaryColor: Colors.blueGrey,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      // 다크 테마 스타일 설정
    );
  }
}
//
//
//
//
// abstract class AppColors {
//   static const primary = Color(0xFF1c6b3a);
//   static const background = Color(0xFFF8F9FA);
//   static const surface = Colors.white;
//   static const text = Color(0xFF212529);
//   static const textSecondary = Color(0xFF868E96);
//   static const divider = Color(0xFFE9ECEF);
//   static const backgroundTransparent = Color(0x00000000);
// }
//
// abstract class AppStyles {
//   // Spacing
//   static const defaultSpacing = 16.0;
//   static const smallSpacing = 8.0;
//   static const largeSpacing = 24.0;
//
//   // Radius
//   static const defaultRadius = 8.0;
//   static const largeRadius = 16.0;
//
//   // Padding
//   static const defaultPadding = EdgeInsets.all(defaultSpacing);
//   static const horizontalPadding = EdgeInsets.symmetric(horizontal: defaultSpacing);
//   static const verticalPadding = EdgeInsets.symmetric(vertical: defaultSpacing);
//
//   // Text Styles
//   static const titleLarge = TextStyle(
//     fontSize: 20,
//     fontWeight: FontWeight.bold,
//     height: 1.4,
//   );
//
//   static const titleMedium = TextStyle(
//     fontSize: 16,
//     fontWeight: FontWeight.bold,
//     height: 1.4,
//   );
//
//   static const bodySuper = TextStyle(
//     fontSize: 32,
//     fontWeight: FontWeight.w500,
//     height: 1.6,
//   );
//
//   static const bodyLarge = TextStyle(
//     fontSize: 16,
//     fontWeight: FontWeight.w400,
//     height: 1.6,
//   );
//
//   static const bodyMedium = TextStyle(
//     fontSize: 14,
//     fontWeight: FontWeight.w400,
//     height: 1.6,
//   );
//
//   static const labelLarge = TextStyle(
//     fontSize: 16,
//     fontWeight: FontWeight.w600,
//     height: 1.4,
//   );
//
//   static const labelMedium = TextStyle(
//     fontSize: 14,
//     fontWeight: FontWeight.w600,
//     height: 1.4,
//   );
// }
//
// class AppTheme {
//   static ThemeData light() {
//     return ThemeData.light(
//       useMaterial3: true,
//     ).copyWith(
//       colorScheme: ColorScheme.fromSeed(
//         seedColor: AppColors.primary,
//         brightness: Brightness.light,
//       ),
//       scaffoldBackgroundColor: AppColors.background,
//       appBarTheme: AppBarTheme(
//         backgroundColor: AppColors.surface,
//         foregroundColor: AppColors.text,
//         titleTextStyle: AppStyles.titleLarge.copyWith(
//           color: AppColors.text,
//         ),
//       ),
//       cardTheme: const CardTheme(
//         elevation: 0.5,
//         margin: EdgeInsets.symmetric(
//           horizontal: AppStyles.defaultSpacing,
//           vertical: AppStyles.smallSpacing,
//         ),
//         color: AppColors.surface,
//       ),
//       inputDecorationTheme: InputDecorationTheme(
//         filled: true,
//         fillColor: AppColors.surface,
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(AppStyles.defaultRadius),
//           borderSide: const BorderSide(color: AppColors.divider),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(AppStyles.defaultRadius),
//           borderSide: const BorderSide(color: AppColors.divider),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(AppStyles.defaultRadius),
//           borderSide: const BorderSide(color: AppColors.primary),
//         ),
//         contentPadding: AppStyles.defaultPadding,
//       ),
//       elevatedButtonTheme: ElevatedButtonThemeData(
//         style: ElevatedButton.styleFrom(
//           backgroundColor: AppColors.primary,
//           foregroundColor: AppColors.surface,
//           padding: const EdgeInsets.symmetric(
//             vertical: AppStyles.defaultSpacing,
//             horizontal: AppStyles.defaultSpacing,
//           ),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(AppStyles.defaultRadius),
//           ),
//           textStyle: AppStyles.labelLarge,
//         ),
//       ),
//       outlinedButtonTheme: OutlinedButtonThemeData(
//         style: OutlinedButton.styleFrom(
//           padding: const EdgeInsets.symmetric(
//             vertical: AppStyles.defaultSpacing,
//             horizontal: AppStyles.defaultSpacing,
//           ),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(AppStyles.defaultRadius),
//           ),
//           side: const BorderSide(color: AppColors.divider),
//           textStyle: AppStyles.labelLarge,
//         ),
//       ),
//       textTheme: const TextTheme(
//         titleLarge: AppStyles.titleLarge,
//         titleMedium: AppStyles.titleMedium,
//         bodyLarge: AppStyles.bodyLarge,
//         bodyMedium: AppStyles.bodyMedium,
//         labelLarge: AppStyles.labelLarge,
//         labelMedium: AppStyles.labelMedium,
//       ),
//       dividerTheme: const DividerThemeData(
//         color: AppColors.divider,
//         thickness: 1,
//         space: 1,
//       ),
//     );
//   }
// }
