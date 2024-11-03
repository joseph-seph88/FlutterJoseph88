import 'package:egg_time_application/inherited_widgets/settings_inherited_widget.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final settings = SettingsInheritedWidget.of(context);
    return ListView(
      children: [
        ListTile(
          title: const Text("Dart Mode"),
          trailing: Switch(
            value: settings!.isDark,
            onChanged: (value) => settings.isDarkToggle(value),
          ),
        ),
        ListTile(
          title: const Text("Mute"),
          trailing: Switch(
            value: settings.isMute,
            onChanged: (value) => settings.isMuteToggle(value),
          ),
        ),
        const ListTile(),
      ],
    );
  }
}
