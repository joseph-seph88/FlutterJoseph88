import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/navigator_provider.dart';

class CustomNavigatorBar extends ConsumerWidget {
  const CustomNavigatorBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTab = ref.watch(navigatorProvider);

    void routeScreen(int index) {
      switch (index) {
        case 0:
          context.go('/home');
          break;
        case 1:
          context.go('/todo');
          break;
        case 2:
          context.go('/upload');
          break;
        case 3:
          context.go('/settings');
          break;
      }
    }

    return BottomNavigationBar(
        currentIndex: selectedTab,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          ref.read(navigatorProvider.notifier).state = index;
          routeScreen(index);
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.today_outlined), label: 'Todo'),
          BottomNavigationBarItem(icon: Icon(Icons.upload_file), label: 'Upload'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Settings'),
        ]);
  }
}
