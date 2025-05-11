import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_login/core/app_style/app_theme.dart';
import 'package:project_login/feature/entry/cubit/entry_cubit.dart';
import 'package:project_login/feature/entry/cubit/entry_state.dart';
import 'package:project_login/feature/favorite_store/pages/favorite_store_page.dart';
import 'package:project_login/feature/food_recommend/pages/food_recommend.dart';
import 'package:project_login/feature/home/pages/home_page.dart';
import 'package:project_login/feature/my_info/pages/my_info_page.dart';
import 'package:project_login/feature/order_history/pages/order_history_page.dart';
import 'package:project_login/feature/search_store/pages/search_store_page.dart';

class EntryPage extends StatelessWidget {
  const EntryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EntryCubit, EntryState>(builder: (context, state) {
      final currentIndex = state.currentIndex;

      return Scaffold(
        body: SafeArea(child: _buildCurrentPage(currentIndex)),
        bottomNavigationBar: _buildBottomNavigationBar(context, currentIndex),
      );
    });
  }

  Widget _buildCurrentPage(currentIndex) {
    switch (currentIndex) {
      case 0:
        return HomePage();
      case 1:
        return FoodRecommend();
      case 2:
        return SearchStorePage();
      case 3:
        return FavoriteStorePage();
      case 4:
        return MyInfoPage();
      default:
        return Center(
          child: Text('NEXT'),
        );
    }
  }

  Widget _buildBottomNavigationBar(BuildContext context, int currentIndex) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      selectedItemColor: AppTheme.primaryColor,
      unselectedItemColor: AppTheme.greyColor,
      type: BottomNavigationBarType.fixed,
      onTap: (index) {
        context.read<EntryCubit>().pageNavigation(index);
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: '먹홈',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.select_all),
          label: '먹겜',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: '먹검색',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_border),
          label: '먹금통',
        ),
        // BottomNavigationBarItem(
        //   icon: Icon(Icons.receipt_long),
        //   label: '먹주문내역',
        // ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: '마이먹',
        ),
      ],
    );
  }
}
