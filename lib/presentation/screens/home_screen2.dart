import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:o2/presentation/providers/map_provider.dart';
import 'package:o2/presentation/screens/map/map_screen.dart';
import 'package:o2/presentation/screens/product/product_list_view.dart';

final currentIndexProvider = StateProvider<int>((ref) => 0);

class HomeScreen2 extends ConsumerWidget {
  const HomeScreen2({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(currentIndexProvider);

    final List<Widget> pages = [
      ProductListView(),
      MapScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "홈"),
          BottomNavigationBarItem(icon: Icon(Icons.location_on), label: "동네지도"),
        ],
        currentIndex: currentIndex,
        onTap: (index) async {
          if (index == 1) {
            await ref
                .read(locationPermissionProvider.notifier)
                .requestPermission();
          }
          ref.read(currentIndexProvider.notifier).state = index;
        },
      ),
    );
  }
}
