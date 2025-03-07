import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:personal_select_chat/bloc/login/login_bloc.dart';
import 'package:personal_select_chat/bloc/login/login_event.dart';
import 'package:personal_select_chat/bloc/login/login_state.dart';
import 'package:personal_select_chat/core/theme/app_style.dart';
import 'package:personal_select_chat/core/utils/validator.dart';
import 'package:personal_select_chat/core/app/router/app_router.dart';

class LoginScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  LoginScreen({super.key});

  void controllerClear(BuildContext context) {
    _emailController.clear();
    _passwordController.clear();
    context.read<LoginBloc>().add(ResetLoginFormEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(height: 24),
                  _buildTop(),
                  _buildEmail(context),
                  SizedBox(height: 16),
                  _buildPassword(context),
                  SizedBox(height: 8),
                  _buildForget(),
                  SizedBox(height: 24),
                  _buildLoginBtn(context),
                  SizedBox(height: 16),
                  _buildDiver(),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildSocialButton(Icons.g_mobiledata, Colors.red),
                      SizedBox(width: 24),
                      _buildSocialButton(Icons.phone_android, Colors.green),
                      SizedBox(width: 24),
                      _buildSocialButton(
                          Icons.chat_bubble, Colors.yellow[700]!),
                    ],
                  ),
                  SizedBox(height: 32),
                  _buildRegister(context),
                ],
              )),
        ),
      )),
    );
  }

  Widget _buildTop() {
    return Column(
      children: [
        SizedBox(height: 20),
        Center(
            child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                    color: Colors.pink[100], shape: BoxShape.circle),
                child: Icon(Icons.favorite, size: 60, color: Colors.pink))),
        SizedBox(height: 24),
        Text('FreakXion',
            textAlign: TextAlign.center, style: AppStyle.pinkLargeMainBody()),
        Text('당신의 특별한 인연을 찾아보세요',
            textAlign: TextAlign.center,
            style: AppStyle.generalMediumSubBody()),
        SizedBox(height: 48),
      ],
    );
  }

  Widget _buildEmail(BuildContext context) {
    return TextFormField(
      key: Key('emailField'),
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration:
          InputDecoration(labelText: '이메일', prefixIcon: Icon(Icons.email)),
      onTapOutside: (_) => FocusScope.of(context).unfocus(),
      validator: (value) {
        final String? isEmptyResult =
            Validator.isEmptyValidator(value, "이메일을 입력해주세요");
        if (isEmptyResult != null) {
          return isEmptyResult;
        }
        return null;
      },
    );
  }

  Widget _buildPassword(BuildContext context) {
    return BlocSelector<LoginBloc, LoginState, bool>(
      selector: (state) {
        if (state is LoginFormState) {
          return state.isLoginPasswordVisible;
        }
        return false;
      },
      builder: (context, isVisible) {
        return TextFormField(
          key: Key('passwordField'),
          controller: _passwordController,
          obscureText: !isVisible,
          onTapOutside: (_) => FocusScope.of(context).unfocus(),
          decoration: InputDecoration(
              labelText: '비밀번호',
              prefixIcon: Icon(Icons.lock),
              suffixIcon: IconButton(
                  icon:
                      Icon(isVisible ? Icons.visibility : Icons.visibility_off),
                  onPressed: () => context.read<LoginBloc>().add(
                      LoginFormEvent(isLoginPasswordVisible: !isVisible)))),
          validator: (value) {
            final String? isEmptyResult =
                Validator.isEmptyValidator(value, "비밀번호를 입력해주세요");
            if (isEmptyResult != null) {
              return isEmptyResult;
            }
            return null;
          },
        );
      },
    );
  }

  Widget _buildForget() {
    return Align(
        alignment: Alignment.centerRight,
        child: TextButton(
            onPressed: () {},
            child:
                Text('비밀번호를 잊으셨나요?', style: AppStyle.purpleSmallBoldBody())));
  }

  Widget _buildLoginBtn(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          controllerClear(context);
          context.push(AppRouter.entry);
        }
      },
      style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 48),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: Colors.pink[100]),
      child: Text('로그인', style: AppStyle.pinkMediumLabel()),
    );
  }

  Widget _buildDiver() {
    return Row(
      children: [
        Expanded(child: Divider()),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text('또는', style: AppStyle.generalSmallMediumSubBody())),
        Expanded(child: Divider()),
      ],
    );
  }

  Widget _buildSocialButton(IconData icon, Color color) {
    return InkWell(
      onTap: () {},
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withAlpha(80),
                blurRadius: 8,
                offset: Offset(0, 3)),
          ],
        ),
        child: Icon(icon, color: color, size: 30),
      ),
    );
  }

  Widget _buildRegister(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('계정이 없으신가요?', style: AppStyle.generalSmallSubBody()),
        TextButton(
          onPressed: () {
            controllerClear(context);
            context.push(AppRouter.register);
          },
          child: Text('회원가입', style: AppStyle.purpleSmallBoldBody()),
        ),
      ],
    );
  }
}
