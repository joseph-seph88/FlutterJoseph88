import 'package:flutter/material.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_navigator_bar.dart';


class MainNavigator extends StatelessWidget implements PreferredSizeWidget {
  final Widget child;

  const MainNavigator({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: child,
      bottomNavigationBar: const CustomNavigatorBar(),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60.0);
}

