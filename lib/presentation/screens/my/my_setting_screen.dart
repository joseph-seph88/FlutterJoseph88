import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:o2/core/theme/app_theme.dart';
import 'package:o2/presentation/providers/auth_provider.dart';

class MySettingScreen extends ConsumerWidget {
  const MySettingScreen({super.key});

  void _clickLogout(BuildContext context, WidgetRef ref, String text) {
    final providerData = FirebaseAuth.instance.currentUser?.providerData;
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
          if (text == "회원탈퇴" &&
              providerData != null &&
              providerData.isNotEmpty &&
              providerData[0].providerId == "password") ...[
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
              onPressed: () async {
                if (text == "로그아웃") {
                  await ref.read(authProvider.notifier).signOut();
                  if (context.mounted) {
                    context.go("/signIn");
                  }
                } else {
                  String userId = ref.read(authProvider)!.id;
                  await ref
                      .read(authProvider.notifier)
                      .withdraw(userId, passwordController.text);
                  if (context.mounted) {
                    context.go("/signIn");
                  }
                }
              },
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("설정"),
        centerTitle: true,
      ),
      body: Padding(
        padding: AppStyles.defaultPadding,
        child: Column(
          children: [
            Text(
              "알림 설정",
              style: theme.textTheme.bodyLarge?.copyWith(
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: AppStyles.defaultSpacing),
            GestureDetector(
              onTap: () => _clickLogout(context, ref, "로그아웃"),
              child: Text(
                "로그아웃",
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: AppColors.text,
                ),
              ),
            ),
            const SizedBox(height: AppStyles.defaultSpacing),
            GestureDetector(
              onTap: () => _clickLogout(context, ref, "회원탈퇴"),
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
