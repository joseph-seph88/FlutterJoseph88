import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:o2/presentation/screens/chat/chat_list_screen.dart';
import 'package:o2/presentation/screens/map/map_screen.dart';
import 'package:o2/presentation/screens/my/my_screen.dart';
import 'package:o2/presentation/screens/product/product_list_screen.dart';
import '../widgets/bottom_nav_bar.dart';

final currentIndexProvider = StateProvider<int>((ref) => 0);

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(currentIndexProvider);

    final List<Widget> pages = [
      const ProductListScreen(),
      const MapScreen(),
      const ChatListScreen(),
      const MyScreen(),
    ];

    void onTabTapped(int index) async {
      ref.read(currentIndexProvider.notifier).state = index;
    }

    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: currentIndex,
        onTap: onTabTapped,
      ),
    );
  }
}
