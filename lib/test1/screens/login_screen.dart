import 'package:class_10_firebase/google_login.dart';
import 'package:class_10_firebase/screens/main_screen.dart';
import 'package:class_10_firebase/services/login_service.dart';
import 'package:class_10_firebase/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/login_provider.dart';

class LoginScreen extends ConsumerWidget {
  LoginScreen({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = ref.read(emailControllerProvider);
    final passwordController = ref.read(passwordControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'LOGIN',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 30, color: Colors.indigo),
        ),
        centerTitle: true,
        toolbarHeight: 100,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(5),
              child: const Text(
                "Sign in",
                style: TextStyle(fontSize: 18),
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                          hintText: "E-Mail",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8))),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an email';
                        }
                        return null;
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      controller: passwordController,
                      decoration: InputDecoration(
                          hintText: "Password",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8))),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ),
            const Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Text('Forgot password'),
              ),
            ),
            Container(
              height: 50,
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    final user = await LoginService().loginUser(
                        emailController.text, passwordController.text);

                    if (context.mounted) {
                      if (user != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("로그인 성공")));
                        emailController.clear();
                        passwordController.clear();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MainScreen()),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("로그인 실패")));
                      }
                    }
                  }
                },
                child: const Text(
                  "Login",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Does not have account?"),
                TextButton(
                    onPressed: () {
                      emailController.clear();
                      passwordController.clear();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegisterScreen()));
                    },
                    child: const Text(
                      "Register",
                      style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    ))
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(50),
              child: ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.indigo[300]),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignInDemo()));
                  },
                  child: const Text(
                    "Google Login",
                    style: TextStyle(color: Colors.white),
                  )),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(50),
            //   child: ElevatedButton(
            //       style:
            //       ElevatedButton.styleFrom(backgroundColor: Colors.indigo[300]),
            //       onPressed: () {
            //         Navigator.push(
            //             context,
            //             MaterialPageRoute(
            //                 builder: (context) => const NaverLoginScreen()));
            //       },
            //       child: const Text(
            //         "Naver Login",
            //         style: TextStyle(color: Colors.white),
            //       )),
            // )
          ],
        ),
      ),
    );
  }
}
