import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/login_provider.dart';

class RegisterScreen extends ConsumerWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = ref.watch(emailProvider);
    final passwordController = ref.watch(passwordProvider);
    final formKey = GlobalKey<FormState>();
    final nicknameController = ref.watch(nicknameProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('REGISTER'),
        centerTitle: true,
        toolbarHeight: 100,
        leading: IconButton(
            onPressed: () {
              emailController.clear();
              passwordController.clear();
              nicknameController.clear();
              context.go('/login');
            },
            icon: const Icon(Icons.arrow_back_ios)),
      ),
      body: Form(
        key: formKey,
        child: ListView(
          children: [
            Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: TextFormField(
                    controller: nicknameController,
                    decoration: InputDecoration(
                        hintText: 'Nickname',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8))),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '닉네임을 입력해주세요.';
                      }
                      return null;
                    })),
            Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                      hintText: 'E-mail',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8))),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '이메일을 입력해주세요.';
                    }

                    final emailRegExp =
                    RegExp(r'^[a-zA-Z0-9]+@[a-zA-Z0-9]+\.[a-zA-Z]{2,}$');
                    if (!emailRegExp.hasMatch(value)) {
                      return '유효한 이메일을 입력해주세요.';
                    }
                    return null;
                  },
                )),
            Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                      hintText: 'Password',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8))),
                  validator: (value) => value != null && value.length >= 8
                      ? null
                      : '비밀번호는 8자리 이상이어야 합니다',
                )),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    try {
                      final loginFirebase =
                      ref.read(loginFirebaseProvider);
                      await loginFirebase.signUpWithEmailPassword(
                        emailController.text.trim(),
                        passwordController.text.trim(),
                      );

                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("회원가입 성공.")),
                        );
                        emailController.clear();
                        passwordController.clear();
                        nicknameController.clear();
                        context.go('/login');
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("회원가입 실패: $e")),
                        );
                      }
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("이메일 또는 비밀번호 형식이 맞지 않습니다.")),
                    );
                  }
                },
                child: const Text(
                  'Register',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
