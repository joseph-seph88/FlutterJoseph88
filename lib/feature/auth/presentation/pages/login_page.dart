import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:project_login/core/app_constant.dart';
import 'package:project_login/feature/auth/cubit/login_cubit.dart';
import 'package:project_login/feature/auth/cubit/login_state.dart';
import 'package:project_login/feature/auth/presentation/pages/sign_up_page.dart';
import 'package:project_login/feature/auth/presentation/widgets/email_field.dart';
import 'package:project_login/feature/auth/presentation/widgets/password_field.dart';
import 'package:project_login/feature/auth/presentation/widgets/social_login_button.dart';
import 'package:project_login/feature/home/home_page.dart';

class LoginPage extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state.status.isSuccess) {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomePage()));
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
                  EmailField(emailController: emailController),
                  const SizedBox(height: 16),
                  PasswordField(passwordController: passwordController),
                  const SizedBox(height: 24),
                  _buildLoginButton(),
                  const SizedBox(height: 8),
                  _buildPasswordForgotSection(),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SocialLoginButton(
                        buttonImage: AppConstant.image_google,
                        color: Colors.red,
                        onPressed: () {},
                      ),
                      SocialLoginButton(
                        buttonImage: AppConstant.image_naver,
                        color: Colors.blue,
                        onPressed: () {},
                      ),
                      SocialLoginButton(
                        buttonImage: AppConstant.image_kakao,
                        color: Colors.black,
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
      const Icon(Icons.android, size: 80, color: Color(0xFF6200EE)),
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

  Widget _buildLoginButton() {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) => ElevatedButton(
        onPressed: () {
          context.read<LoginCubit>().loginSubmitted(
              emailValue: emailController.text,
              passwordValue: passwordController.text);
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: const Color(0xFF6200EE),
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
            color: Color(0xFF6200EE),
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpButton(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Text('계정이 없으신가요?', style: TextStyle(color: Color(0xFF707070))),
      TextButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SignUpPage()));
        },
        child: const Text(
          '회원가입',
          style: TextStyle(
            color: Color(0xFF6200EE),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ]);
  }
}

//     return Scaffold(
//       body: BlocListener<LoginCubit, LoginState>(
//         listener: (context, state) {
//           if (state.status.isFailure) {
//             ScaffoldMessenger.of(context)
//               ..hideCurrentSnackBar()
//               ..showSnackBar(
//                 SnackBar(
//                   content: Text(state.errorMessage ?? '인증 실패'),
//                   backgroundColor: Colors.redAccent,
//                 ),
//               );
//           }
//           if (state.status.isSuccess) {
//             Navigator.of(context)
//                 .push(MaterialPageRoute(builder: (context) => HomePage()));
//           }
//         },
//         child: Scaffold(
//           backgroundColor: Colors.white,
//           body: SafeArea(
//             child: Center(
//               child: SingleChildScrollView(
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 30.0),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.stretch,
//                     children: [
//                       // 로고 및 환영 메시지
//                       const Icon(
//                         Icons.android,
//                         size: 80,
//                         color: Color(0xFF6200EE),
//                       ),
//                       const SizedBox(height: 20),
//                       const Text(
//                         '환영합니다',
//                         style: TextStyle(
//                           fontSize: 28,
//                           fontWeight: FontWeight.bold,
//                           color: Color(0xFF1F1F1F),
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                       const SizedBox(height: 8),
//                       const Text(
//                         '계정에 로그인하세요',
//                         style: TextStyle(
//                           fontSize: 16,
//                           color: Color(0xFF707070),
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                       const SizedBox(height: 40),

//                       // 이메일 입력
//                       EmailInputForm(),
//                       const SizedBox(height: 16),

//                       // 비밀번호 입력
//                       PasswordInputForm(),
//                       const SizedBox(height: 8),

//                       // 비밀번호 찾기
//                       Align(
//                         alignment: Alignment.centerRight,
//                         child: TextButton(
//                           onPressed: () {},
//                           child: const Text(
//                             '비밀번호를 잊으셨나요?',
//                             style: TextStyle(
//                               color: Color(0xFF6200EE),
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 24),

//                       // 로그인 버튼
//                       _LoginButton(),
//                       const SizedBox(height: 20),

//                       // 소셜 로그인 옵션
//                       const Row(
//                         children: [
//                           Expanded(child: Divider(thickness: 1)),
//                           Padding(
//                             padding: EdgeInsets.symmetric(horizontal: 16),
//                             child: Text(
//                               '또는',
//                               style: TextStyle(color: Color(0xFF707070)),
//                             ),
//                           ),
//                           Expanded(child: Divider(thickness: 1)),
//                         ],
//                       ),
//                       const SizedBox(height: 20),

//                       // 소셜 로그인 버튼
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           SocialLoginButton(
//                             icon: Icons.g_mobiledata,
//                             color: Colors.red,
//                             onPressed: () {},
//                           ),
//                           SocialLoginButton(
//                             icon: Icons.facebook,
//                             color: Colors.blue,
//                             onPressed: () {},
//                           ),
//                           SocialLoginButton(
//                             icon: Icons.apple,
//                             color: Colors.black,
//                             onPressed: () {},
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 30),

//                       // 회원가입 링크
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           const Text(
//                             '계정이 없으신가요?',
//                             style: TextStyle(color: Color(0xFF707070)),
//                           ),
//                           TextButton(
//                             onPressed: () {},
//                             child: const Text(
//                               '회원가입',
//                               style: TextStyle(
//                                 color: Color(0xFF6200EE),
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _LoginButton extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<LoginCubit, LoginState>(
//       buildWhen: (previous, current) => previous.status != current.status,
//       builder: (context, state) {
//         return ElevatedButton(
//           key: const Key('loginForm_continue_elevatedButton'),
//           style: ElevatedButton.styleFrom(
//             foregroundColor: Colors.white,
//             backgroundColor: const Color(0xFF6200EE),
//             minimumSize: const Size(double.infinity, 54),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//             elevation: 0,
//           ),
//           onPressed: () {},
//           // state.status.isValidated && !state.status.isInProgress
//           //     ? () => context.read<LoginCubit>().logInWithCredentials()
//           //     : null,
//           child: state.status.isInProgress
//               ? const SizedBox(
//                   height: 24,
//                   width: 24,
//                   child: CircularProgressIndicator(
//                     strokeWidth: 2.5,
//                     color: Colors.white,
//                   ),
//                 )
//               : const Text(
//                   '로그인',
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//         );
//       },
//     );
//   }
// }
