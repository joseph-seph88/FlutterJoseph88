import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:o2/presentation/screens/chat/chat_list_screen.dart';
import 'package:o2/presentation/screens/map/like_shop_page.dart';
import 'package:o2/presentation/screens/map/map_screen.dart';
import 'package:o2/presentation/screens/product/widgets/product_list_view.dart';
import 'package:o2/presentation/screens/search/search_screen.dart';
import '../providers/permission_provider.dart';
import '../widgets/bottom_nav_bar.dart';

final currentIndexProvider = StateProvider<int>((ref) => 0);

class HomeScreen2 extends ConsumerWidget {
  const HomeScreen2({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _currentIndex = ref.watch(currentIndexProvider);

    final List<Widget> pages = [
      const ProductListView(),
      const SearchScreen(),
      const MapScreen(),
      const ChatListScreen(),
      const LikeShopPage(),
    ];

    void _onTabTapped(int index) async {
      ref.read(currentIndexProvider.notifier).state = index;

      if (index == 1) {
        await ref.read(locationPermissionProvider.notifier).requestPermission();
      }
    }

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),);
  }
}
