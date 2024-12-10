import 'package:class_10_firebase/todo_app/providers/login_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const Row(
            children: [
              CircleAvatar(
                radius: 40,
              ),
              SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "User Name : Roy}",
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    "User E-mail: roy@roy.com",
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              )
            ],
          ),
          const SizedBox(height: 54),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
            onPressed: () async {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("로그아웃되었습니다.")),
                );
                ref.read(loginFirebaseProvider).signOut();
                context.go('/login');
              }
            },
            child: const Text(
              "LOGOUT",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
