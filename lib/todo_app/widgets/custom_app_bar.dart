import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/navigator_provider.dart';

class CustomAppBar extends ConsumerWidget implements PreferredSizeWidget{
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTab = ref.watch(navigatorProvider);

    String getAppBarTitle() {
      switch (selectedTab) {
        case 0:
          return 'HOME';
        case 1:
          return 'TODO';
        case 2:
          return 'UPLOAD';
        case 3:
          return 'SETTINGS';
        default:
          return 'DEFAULT';
      }
    }

    return AppBar(
      title: Text(
        getAppBarTitle(),
        style: const TextStyle(
          color: Colors.indigo,
          fontWeight: FontWeight.bold,
          fontSize: 28,
        ),
      ),
      centerTitle: true,
      toolbarHeight: 45,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60.0);
}
