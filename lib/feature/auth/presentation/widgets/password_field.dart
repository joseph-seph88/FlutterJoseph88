import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:project_login/core/app_style/app_theme.dart';
import 'package:project_login/feature/auth/cubit/login_cubit.dart';
import 'package:project_login/feature/auth/cubit/login_state.dart';

class PasswordField extends StatelessWidget {
  final TextEditingController passwordController;

  const PasswordField({super.key, required this.passwordController});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) =>
          previous.password != current.password ||
          previous.isPasswordVisible != current.isPasswordVisible,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                key: const Key('loginForm_passwordInput_textField'),
                controller: passwordController,
                obscureText: !state.isPasswordVisible,
                decoration: InputDecoration(
                  labelText: '비밀번호',
                  labelStyle: const TextStyle(color: AppTheme.primaryColor),
                  prefixIcon: const Icon(Icons.lock_outline,
                      color: AppTheme.primaryColor),
                  suffixIcon: IconButton(
                    icon: Icon(
                      state.isPasswordVisible
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: AppTheme.primaryColor,
                    ),
                    onPressed: () =>
                        context.read<LoginCubit>().togglePasswordVisibility(),
                  ),
                  border: InputBorder.none,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
                ),
              ),
            ),
            if (!state.status.isInitial && state.password.isNotValid)
              Padding(
                padding: const EdgeInsets.only(top: 4, left: 40),
                child: Text(
                  state.password.error ?? '',
                  style: const TextStyle(fontSize: 12, color: Colors.red),
                ),
              ),
          ],
        );
      },
    );
  }
}
