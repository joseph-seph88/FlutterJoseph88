import 'package:egg_time_application/inherited_widgets/settings_inherited_widget.dart';
import 'package:egg_time_application/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  await initializeDateFormatting();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDark = false;

  bool isMute = false;

  @override
  void initState() {
    super.initState();
    _loadPreferences(); // 앱 시작 시 저장된 설정 불러오기
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isDark = prefs.getBool('isDark') ?? false;
      isMute = prefs.getBool('isMute') ?? false;
    });
  }

  Future<void> toggleDarkMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isDark = value;
    });
    await prefs.setBool('isDark', value); // 상태 저장
  }

  Future<void> toggleMute(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isMute = value;
    });
    await prefs.setBool('isMute', value); // 상태 저장
  }

  @override
  Widget build(BuildContext context) {
    // final settings = SettingsInheritedWidget.of(context);
    return SettingsInheritedWidget(
      isDark: isDark,
      isMute: isMute,
      isDarkToggle: toggleDarkMode,
      isMuteToggle: toggleMute,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.light,
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
        ),
        themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
        home: const HomeScreen(),
      ),
    );
  }
}
