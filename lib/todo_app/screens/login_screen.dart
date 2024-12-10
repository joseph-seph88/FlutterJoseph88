import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/login_provider.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = ref.watch(emailProvider);
    final passwordController = ref.watch(passwordProvider);
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "LOGIN",
          style: TextStyle(
            color: Colors.indigo,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        toolbarHeight: 100,
      ),
      body: Form(
        key: formKey,
        child: ListView(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
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

                  return null;
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                      hintText: 'Password',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8))),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '비밀번호를 입력해주세요.';
                    }
                    return null;
                  }),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              alignment: Alignment.bottomCenter,
              child: const Text('Forgot Password ?'),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    final loginFirebase = ref.read(loginFirebaseProvider);
                    try {
                      final user = await loginFirebase.signInWithEmailPassword(
                        emailController.text.trim(),
                        passwordController.text.trim(),
                      );
                      if (context.mounted) {
                        if (user != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("로그인 성공.")),
                          );
                          emailController.clear();
                          passwordController.clear();
                          context.go('/home');
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("로그인 실패.")),
                          );
                        }
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("로그인 실패: $e")),
                        );
                      }
                    }
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
                child: const Text(
                  'Login',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('sign up'),
                TextButton(
                    onPressed: () {
                      emailController.clear();
                      passwordController.clear();
                      context.go('/register');
                    },
                    child: const Text(
                      'Register',
                      style: TextStyle(fontSize: 15, color: Colors.indigo),
                    ))
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 150),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo[200]),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("작업중임미다~")),
                  );
                },
                child: const Text(
                  'Google',
                  style: TextStyle(color: Colors.indigo),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
