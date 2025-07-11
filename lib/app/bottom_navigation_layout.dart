import 'package:ai_hair_official/features/hair/presentation/pages/photo_upload_page.dart';
import 'package:flutter/material.dart';

class BottomNavigationLayout extends StatefulWidget {
  const BottomNavigationLayout({super.key});

  @override
  State<BottomNavigationLayout> createState() => _BottomNavigationLayoutState();
}

class _BottomNavigationLayoutState extends State<BottomNavigationLayout> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const PhotoUploadPage(),
    const Center(child: Text('미디어 페이지 - 개발 중')),
    const Center(child: Text('비디오 페이지 - 개발 중')),
  ];

  final List<BottomNavigationBarItem> _bottomNavItems = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.forum),
      label: '커뮤니티',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.image),
      label: '미디어',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.image),
      label: '비디오',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: _bottomNavItems,
      ),
    );
  }
}
