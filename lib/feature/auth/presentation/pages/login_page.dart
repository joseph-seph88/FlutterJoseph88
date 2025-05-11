import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import 'package:project_login/app/router/route_name.dart';
import 'package:project_login/core/constants/app_constant.dart';
import 'package:project_login/core/app_style/app_theme.dart';
import 'package:project_login/feature/auth/cubit/login_cubit.dart';
import 'package:project_login/feature/auth/cubit/login_state.dart';
import 'package:project_login/feature/auth/presentation/widgets/input_field_form.dart';
import 'package:project_login/feature/auth/presentation/widgets/social_login_button.dart';

class LoginPage extends StatelessWidget {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state.status.isSuccess) {
            context.pushNamed(RouteNames.entry);
          }
        },
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                children: [
                  _buildTopSection(),
                  const SizedBox(height: 40),
                  _buildEmailSection(context),
                  const SizedBox(height: 16),
                  _buildPasswordSection(context),
                  const SizedBox(height: 24),
                  _buildLoginButton(),
                  const SizedBox(height: 8),
                  _buildPasswordForgotSection(),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SocialLoginButton(
                        buttonImage: AppConstant.imageGoogle,
                        onPressed: () {},
                      ),
                      SocialLoginButton(
                        buttonImage: AppConstant.imageNaver,
                        onPressed: () {},
                      ),
                      SocialLoginButton(
                        buttonImage: AppConstant.imageKakao,
                        onPressed: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildSignUpButton(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopSection() {
    return Column(children: [
      const Icon(Icons.android, size: 80, color: AppTheme.subPrimary),
      const SizedBox(height: 20),
      const Text(
        '환영합니다',
        style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1F1F1F)),
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 8),
      const Text(
        '계정에 로그인하세요',
        style: TextStyle(fontSize: 16, color: Color(0xFF707070)),
        textAlign: TextAlign.center,
      ),
    ]);
  }

  Widget _buildEmailSection(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
        buildWhen: (previous, current) => previous.email != current.email,
        builder: (context, state) {
          return InputFieldForm(
            textController: _emailController,
            isInitial: state.status.isInitial,
            isNotValid: state.email.isNotValid,
            errorMsg: state.email.error ?? '',
            textType: TextInputType.emailAddress,
            labelText: '이메일',
            hintText: 'example@email.com',
            prefixIcon: Icons.email_outlined,
          );
        });
  }

  Widget _buildPasswordSection(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
        buildWhen: (previous, current) =>
            previous.password != current.password ||
            previous.isPasswordVisible != current.isPasswordVisible,
        builder: (context, state) {
          return InputFieldForm(
            textController: _passwordController,
            isInitial: state.status.isInitial,
            isNotValid: state.password.isNotValid,
            errorMsg: state.password.error ?? '',
            isVisible: !state.isPasswordVisible,
            labelText: '비밀번호',
            prefixIcon: Icons.lock_outline,
            suffixIcon: !state.isPasswordVisible
                ? Icons.visibility_off
                : Icons.visibility,
            suffixIconOnPressed: () =>
                context.read<LoginCubit>().togglePasswordVisibility(),
          );
        });
  }

  Widget _buildLoginButton() {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) => ElevatedButton(
        onPressed: () {
          context.read<LoginCubit>().loginSubmitted(
              emailValue: _emailController.text,
              passwordValue: _passwordController.text);
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: AppTheme.subPrimary,
          minimumSize: const Size(double.infinity, 54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: state.status.isInProgress
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.white,
                ),
              )
            : const Text('로그인',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildPasswordForgotSection() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {},
        child: const Text(
          '비밀번호를 잊으셨나요?',
          style: TextStyle(
            color: AppTheme.subPrimary,
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpButton(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Text('계정이 없으신가요?', style: TextStyle(color: Color(0xFF707070))),
      TextButton(
        onPressed: () => context.pushNamed(RouteNames.signUp),
        child: const Text(
          '회원가입',
          style: TextStyle(
            color: AppTheme.subPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ]);
  }
}
