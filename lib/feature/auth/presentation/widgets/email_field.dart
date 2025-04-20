import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:project_login/feature/auth/cubit/login_cubit.dart';
import 'package:project_login/feature/auth/cubit/login_state.dart';

class EmailField extends StatelessWidget {
  final TextEditingController emailController;

  const EmailField({super.key, required this.emailController});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.email != current.email,
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
                key: const Key('loginForm_emailInput_textField'),
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: '이메일',
                  hintText: 'example@email.com',
                  hintStyle: TextStyle(color: Colors.grey),
                  labelStyle: const TextStyle(color: Color(0xFF6200EE)),
                  prefixIcon: const Icon(Icons.email_outlined,
                      color: Color(0xFF6200EE)),
                  border: InputBorder.none,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
              ),
            ),
            if (!state.status.isInitial && state.email.isNotValid)
              Padding(
                padding: const EdgeInsets.only(top: 4, left: 40),
                child: Text(
                  state.email.error ?? '',
                  style: const TextStyle(fontSize: 12, color: Colors.red),
                ),
              ),
          ],
        );
      },
    );
  }
}
