import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:o2/core/theme/app_theme.dart';
import 'package:o2/presentation/providers/auth_provider.dart';
import 'package:o2/presentation/screens/auth/widgets/auth_icon_button.dart';

import 'widgets/auth_button.dart';
import 'widgets/auth_text_field.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _showPassword = true;

  void _togglePasswordVisible() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  void _onClickedLogInButton() async {
    final success = await ref.read(authProvider.notifier).signIn(
          _emailController.text,
          _passwordController.text,
        );

    if (success && mounted) {
      context.go("/home");
    }
  }

  void _onClickedGoogleButton() async {
    final success = await ref.read(authProvider.notifier).signInWithGoogle();
    if (success && mounted) {
      context.go("/home");
    }
  }

  void _onClickedFacebookButton() async {
    final success = await ref.read(authProvider.notifier).signInWithFacebook();
    if (success && mounted) {
      context.go("/home");
    }
  }

  void _onClickedNaverButton() async {
    final success = await ref.read(authProvider.notifier).signInWithNaver();
    if (success && mounted) {
      context.go("/home");
    }
  }

  void _onClickedKakaoButton() async {
    final success = await ref.read(authProvider.notifier).signInWithKakao();
    if (success && mounted) {
      context.go("/home");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: AppStyles.defaultPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            AuthTextField(
              controller: _emailController,
              fieldName: "email",
            ),
            const SizedBox(height: AppStyles.defaultSpacing),
            AuthTextField(
              controller: _passwordController,
              fieldName: "password",
              obscureText: _showPassword,
              onSuffixIconPressed: _togglePasswordVisible,
            ),
            const SizedBox(height: AppStyles.defaultSpacing),
            AuthButton(
              onPressed: _onClickedLogInButton,
              text: "로그인",
            ),
            const SizedBox(height: AppStyles.defaultSpacing),
            Container(
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(AppStyles.defaultRadius),
              ),
              child: Column(
                children: [
                  const SizedBox(height: AppStyles.defaultSpacing),
                  const Text("소셜 계정으로 로그인", style: AppStyles.labelLarge),
                  const SizedBox(height: AppStyles.smallSpacing),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      AuthIconButton(
                          onPressed: _onClickedGoogleButton,
                          iconPath: "assets/icons/google_logo.svg"),
                      AuthIconButton(
                          onPressed: _onClickedFacebookButton,
                          iconPath: "assets/icons/facebook_logo.svg"),
                      AuthIconButton(
                          onPressed: _onClickedNaverButton,
                          iconPath: "assets/icons/naver_logo.svg"),
                      AuthIconButton(
                          onPressed: _onClickedKakaoButton,
                          iconPath: "assets/icons/kakao_logo.svg"),
                    ],
                  ),
                  const SizedBox(height: AppStyles.smallSpacing),
                ],
              ),
            ),
            const Spacer(),
            AuthButton(
              onPressed: () => context.push("/signUp"),
              text: "새 계정 만들기",
            ),
          ],
        ),
      ),
    );
  }
}
