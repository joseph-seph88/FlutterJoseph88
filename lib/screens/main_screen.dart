import 'package:class_10_firebase/screens/setting_screen.dart';
import 'package:class_10_firebase/screens/todo_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/page_navigation_provider.dart';

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(bottomNavigationProvider);

    final List<Widget> screens = [
      TodoScreen(),
      const SettingScreen(),
    ];

    return Scaffold(
      body: screens[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) {
          ref.read(bottomNavigationProvider.notifier).setSelectedIndex(index);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.check_box),
            label: '투두',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '세팅',
          ),
        ],
      ),
    );
  }
}
