// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class SettingsInheritedWidget extends InheritedWidget {
  final bool isDark;
  final bool isMute;
  final Function isDarkToggle;
  final Function isMuteToggle;

  const SettingsInheritedWidget({
    super.key,
    required this.isDark,
    required this.isMute,
    required this.isDarkToggle,
    required this.isMuteToggle,
    required super.child,
  });

// of 메서드를 통해 위젯 트리 하위에서 쉽게 데이터에 접근할 수 있게 합니다.
  static SettingsInheritedWidget? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<SettingsInheritedWidget>();
  }

  @override
  bool updateShouldNotify(covariant SettingsInheritedWidget oldWidget) {
    return isDark != oldWidget.isDark || isMute != oldWidget.isMute;
  }
}
