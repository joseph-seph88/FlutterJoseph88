import 'package:flutter/material.dart';
import 'package:personal_select_chat/presentation/screens/chat_screen.dart';
import 'package:personal_select_chat/presentation/screens/favorite_screen.dart';
import 'package:personal_select_chat/presentation/screens/profile_screen.dart';
import '../../core/utils/app_constant.dart';
import 'home_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    FavoriteScreen(),
    ChatScreen(),
    ProfileScreen(),
  ];

  void _onNavItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _screens[_currentIndex],
        bottomNavigationBar: _buildBottomNavigationBar());
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: _onNavItemTapped,
      selectedItemColor: Color(0xFFFF4D67),
      unselectedItemColor: Colors.grey.shade600,
      iconSize: 28,
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
            icon: Icon(Icons.explore), label: AppConstant.explore),
        BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border), label: AppConstant.favorite),
        BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline), label: AppConstant.message),
        BottomNavigationBarItem(
            icon: Icon(Icons.person_outline), label: AppConstant.profile),
      ],
    );
  }
}
