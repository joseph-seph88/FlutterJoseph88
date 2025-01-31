import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:o2/core/theme/app_theme.dart';
import 'package:o2/presentation/screens/product/widgets/home_app_bar.dart';
import 'package:o2/presentation/screens/product/widgets/product_list_view.dart';
import 'package:o2/presentation/widgets/bottom_nav_bar.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const HomeAppBar(),
      body: const Column(
        children: [
          Expanded(
            child: ProductListView(),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: AppStyles.largeSpacing),
        child: FloatingActionButton.extended(
          onPressed: () => context.push('/write'),
          backgroundColor: theme.colorScheme.primary,
          label: Row(
            children: [
              Icon(
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
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
