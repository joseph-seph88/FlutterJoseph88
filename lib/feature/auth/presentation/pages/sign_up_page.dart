import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import 'package:project_login/core/app_style/app_theme.dart';
import 'package:project_login/feature/auth/cubit/signup_cubit.dart';
import 'package:project_login/feature/auth/cubit/signup_state.dart';
import 'package:project_login/feature/auth/presentation/widgets/input_field_form.dart';

class SignUpPage extends StatelessWidget {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child:
            // decoration: BoxDecoration(
            //   gradient: LinearGradient(
            //     begin: Alignment.topCenter,
            //     end: Alignment.bottomCenter,
            //     colors: [
            //       const Color(0xFF2E3192),
            //       const Color(0xFF1BFFFF),
            //     ],
            //   ),
            // ),
            // height: double.infinity,
            Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPopButton(context),
            SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                children: [
                  _buildTopIcon(),
                  const SizedBox(height: 30),
                  _buildTopText(),
                  const SizedBox(height: 40),
                  _buildNameSection(),
                  const SizedBox(height: 16),
                  _buildEmailSection(),
                  const SizedBox(height: 16),
                  _buildPasswordSection(),
                  const SizedBox(height: 16),
                  _buildConfirmPasswordSection(),
                  const SizedBox(height: 32),
                  _buildSignUpButton(),
                  const SizedBox(height: 24),
                  _buildMoveLoginButton(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPopButton(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(10, 70, 0, 0),
        child: IconButton(
            onPressed: () => context.pop(), icon: Icon(Icons.arrow_back_ios)));
  }

  Widget _buildTopIcon() {
    return Container(
      height: 120,
      width: 120,
      decoration: BoxDecoration(
        color: AppTheme.subPrimary,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withAlpha(127), width: 2),
      ),
      child: const Center(
        child: Icon(
          Icons.person_outline,
          size: 60,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildTopText() {
    return Text('OMUX',
        style: TextStyle(
          color: AppTheme.subPrimary,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ));
  }

  Widget _buildNameSection() {
    return BlocBuilder<SignupCubit, SignupState>(
        buildWhen: (previous, current) => previous.name != current.name,
        builder: (context, state) {
          return InputFieldForm(
            textController: _nameController,
            isInitial: state.status.isInitial,
            isNotValid: state.name.isNotValid,
            errorMsg: state.name.error ?? '',
            textType: TextInputType.name,
            labelText: '이름',
            prefixIcon: Icons.face,
          );
        });
  }

  Widget _buildEmailSection() {
    return BlocBuilder<SignupCubit, SignupState>(
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

  Widget _buildPasswordSection() {
    return BlocBuilder<SignupCubit, SignupState>(
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
                context.read<SignupCubit>().togglePasswordVisibility(),
          );
        });
  }

  Widget _buildConfirmPasswordSection() {
    return BlocBuilder<SignupCubit, SignupState>(
        buildWhen: (previous, current) =>
            previous.confirmPassword != current.confirmPassword ||
            previous.isConfirmPasswordVisible !=
                current.isConfirmPasswordVisible,
        builder: (context, state) {
          return InputFieldForm(
            textController: _confirmPasswordController,
            isInitial: state.status.isInitial,
            isNotValid: state.confirmPassword.isNotValid,
            errorMsg: state.confirmPassword.error ?? '',
            isVisible: !state.isConfirmPasswordVisible,
            labelText: '비밀번호 확인',
            prefixIcon: Icons.lock_outline,
            suffixIcon: !state.isConfirmPasswordVisible
                ? Icons.visibility_off
                : Icons.visibility,
            suffixIconOnPressed: () =>
                context.read<SignupCubit>().toggleConfirmPasswordVisibility(),
          );
        });
  }

  Widget _buildMoveLoginButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '이미 가입된 계정이 있나요?',
          style: TextStyle(
            color: AppTheme.subPrimary,
            fontSize: 14,
          ),
        ),
        TextButton(
          onPressed: () => context.pop(),
          child: Text(
            'LOGIN',
            style: TextStyle(
              color: AppTheme.subPrimary,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSignUpButton() {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16), color: AppTheme.subPrimary
          // gradient:
          //     state.status.isValidated && !state.status.isSubmissionInProgress
          //         ? const LinearGradient(
          //             colors: [
          //               Color(0xFFFF5F6D),
          //               Color(0xFFFFC371),
          //             ],
          //           )
          //         : null,
          // color: state.status.isValidated ? null : Colors.grey.shade300,
          ),
      child: ElevatedButton(
        onPressed: () {},
        // state.status.isValidated && !state.status.isSubmissionInProgress
        //     ? () => context.read<SignupCubit>().signupFormSubmitted()
        //     : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text('SignUp'),
        // child: state.status.isSubmissionInProgress
        //     ? const CircularProgressIndicator(color: Colors.white)
        //     : Text(
        //         localizations.get('signup_button'),
        //         style: GoogleFonts.poppins(
        //           color: Colors.white,
        //           fontSize: 16,
        //           fontWeight: FontWeight.bold,
        //         ),
        //       ),
      ),
    );
  }
}
