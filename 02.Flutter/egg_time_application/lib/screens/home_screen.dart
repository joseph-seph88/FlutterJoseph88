import 'package:egg_time_application/common/color_styles.dart';
import 'package:egg_time_application/screens/page4_character/character_main_homepage.dart';
import 'package:egg_time_application/screens/pomodoro_timer_screen.dart';
import 'package:egg_time_application/screens/settings_screen.dart';
import 'package:egg_time_application/screens/statistics_screen.dart';
import 'package:egg_time_application/screens/todo_list_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController();

  // int _selectdIndex = 0;

  // void _onItemTap(int index) {
  //   setState(() {
  //     _selectdIndex = index;
  //   });
  //   _pageController.jumpToPage(_selectdIndex);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: EggColors().yellowstyle6,
        title: const Text(
          "EGG TIME",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: EggColors().yellowstyle6,
              ),
              child: const Text(
                'Menu',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context); // Drawer 닫기
                _pageController.jumpToPage(0);
              },
            ),
            ListTile(
              leading: const Icon(Icons.today_outlined),
              title: const Text('Todo List'),
              onTap: () {
                Navigator.pop(context); // Drawer 닫기
                _pageController.jumpToPage(1);
              },
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context); // Drawer 닫기
                _pageController.jumpToPage(2);
              },
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context); // Drawer 닫기
                _pageController.jumpToPage(3);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context); // Drawer 닫기
                _pageController.jumpToPage(4);
              },
            ),
          ],
        ),
      ),
      body: PageView(
        controller: _pageController,
        // onPageChanged: _onItemTap,
        children: const [
          PomodoroTimerScreen(),
          TodoListScreen(),
          CharacterMainHomepage(),
          StatisticsScreen(),
          SettingsScreen(),
        ],
      ),
    );
  }
}
