import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:o2/core/theme/app_theme.dart';
import 'package:o2/presentation/screens/my/my_screen.dart';
import 'package:o2/presentation/screens/product/widgets/home_app_bar.dart';
import 'package:o2/presentation/screens/product/widgets/product_list_view.dart';
import 'package:o2/presentation/widgets/bottom_nav_bar.dart';
import 'package:o2/presentation/screens/map/map_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        break;
      case 1:
        break;
      case 2:
        context.go('/map');
        break;
      case 3:
        context.go('/chat');
        break;
      case 4:
        context.go('/my');
        break;
    }
  }

  Widget _buildScreen() {
    switch (_currentIndex) {
      case 0:
        return const ProductListView();
      case 1:
        return const MapScreen();
      case 4:
        return const MyScreen();
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: _currentIndex == 1 ? null : const HomeAppBar(),
      body: _buildScreen(),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
      floatingActionButton: _currentIndex == 0
          ? Container(
              margin: const EdgeInsets.only(bottom: AppStyles.largeSpacing),
              child: FloatingActionButton.extended(
                onPressed: () => context.push('/write'),
                backgroundColor: theme.colorScheme.primary,
                label: Row(
                  children: [
                    const Icon(
                      Icons.add,
                      color: AppColors.surface,
                    ),
                    const SizedBox(width: AppStyles.smallSpacing),
                    Text(
                      '글쓰기',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: AppColors.surface,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
