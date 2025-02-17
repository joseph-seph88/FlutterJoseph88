import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:o2/core/services/fcm_service.dart';
import 'package:o2/core/theme/app_theme.dart';
import 'package:o2/presentation/providers/auth_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MySettingScreen extends ConsumerStatefulWidget {
  const MySettingScreen({super.key});

  @override
  ConsumerState<MySettingScreen> createState() => _MySettingScreenState();
}

class _MySettingScreenState extends ConsumerState<MySettingScreen> {
  bool _isNotificationEnabled = true;

  @override
  void initState() {
    super.initState();
    _initNotificationSettings();
  }

  Future<void> _initNotificationSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isNotificationEnabled = prefs.getBool('notificationEnabled') ?? true;
    });
  }

  Future<void> _toggleNotification(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notificationEnabled', value);
    setState(() {
      _isNotificationEnabled = value;
    });
    if (value) {
      await FCMService().initialize();
    } else {
      await FirebaseMessaging.instance.deleteToken();
    }
  }

  void _showDialog(BuildContext context, String text) {
    final isEmailProvider = _isEmailProvider();
    final passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(text, style: const TextStyle(color: AppColors.text)),
        content: Text(
          "정말 $text할까요?",
          style: const TextStyle(color: AppColors.text),
        ),
        actions: [
          if (text == "회원탈퇴" && isEmailProvider) ...[
            TextField(
              controller: passwordController,
              style: const TextStyle(color: AppColors.text),
              decoration: const InputDecoration(
                hintText: "비밀번호를 입력해주세요.",
              ),
            ),
            const SizedBox(height: AppStyles.defaultSpacing),
          ],
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: ElevatedButton(
              onPressed: () => _onPressed(
                context,
                ref,
                text,
                passwordController.text,
              ),
              child: Text(text),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("닫기"),
            ),
          ),
        ],
      ),
    );
  }

  bool _isEmailProvider() {
    final providerData = FirebaseAuth.instance.currentUser?.providerData;
    return providerData != null &&
        providerData.isNotEmpty &&
        providerData[0].providerId == "password";
  }

  void _onPressed(
      BuildContext context, WidgetRef ref, String text, String password) async {
    if (text == "로그아웃") {
      await ref.read(authProvider.notifier).signOut();
      if (context.mounted) {
        context.go("/signIn");
      }
    } else {
      String userId = ref.read(authProvider)!.id;
      try {
        await ref.read(authProvider.notifier).withdraw(userId, password);
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString())),
          );
        }
      }
      if (context.mounted) {
        context.go("/signIn");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("설정"),
        centerTitle: true,
      ),
      body: Padding(
        padding: AppStyles.defaultPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "알림 설정",
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: AppColors.text,
                  ),
                ),
                Switch(
                  value: _isNotificationEnabled,
                  onChanged: _toggleNotification,
                ),
              ],
            ),
            const SizedBox(height: AppStyles.defaultSpacing),
            GestureDetector(
              onTap: () => _showDialog(context, "로그아웃"),
              child: Text(
                "로그아웃",
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: AppColors.text,
                ),
              ),
            ),
            const SizedBox(height: AppStyles.defaultSpacing),
            GestureDetector(
              onTap: () => _showDialog(context, "회원탈퇴"),
              child: Text(
                "회원탈퇴",
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: AppColors.text,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
