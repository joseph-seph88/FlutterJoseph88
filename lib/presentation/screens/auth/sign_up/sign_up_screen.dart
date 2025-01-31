import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:o2/presentation/providers/auth_provider.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _showPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("회원가입"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 40,
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text("Email *"),
              ),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.people_alt),
                border: OutlineInputBorder(),
                hintText: "Email을 입력해 주세요.",
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(
              height: 40,
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text("비밀번호 *"),
              ),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _showPassword = !_showPassword;
                    });
                  },
                  icon: _showPassword
                      ? const Icon(Icons.visibility_off)
                      : const Icon(Icons.visibility),
                ),
                border: const OutlineInputBorder(),
                hintText: "Password",
              ),
              obscureText: _showPassword,
            ),
            const SizedBox(
              height: 40,
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text("이름"),
              ),
            ),
            Spacer(),
            SizedBox(
              height: 48,
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                onPressed: () async {
                  await ref.read(authProvider.notifier).signUp(
                        _emailController.text,
                        _passwordController.text,
                      );
                },
                child: const Text('회원가입'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
