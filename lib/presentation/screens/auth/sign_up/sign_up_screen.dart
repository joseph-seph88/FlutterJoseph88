import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:o2/presentation/providers/auth_provider.dart';
import 'package:o2/presentation/screens/auth/widgets/auth_text.dart';
import 'package:o2/presentation/screens/auth/widgets/text_field_data.dart';

import '../widgets/auth_button.dart';
import '../widgets/auth_text_field.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final List<TextFieldData> _listTextFieldData = [
    TextFieldData("email"),
    TextFieldData("password"),
    TextFieldData("name"),
  ];

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _showPassword = true;
  bool _showSignUpButton = false;

  @override
  void initState() {
    super.initState();

    for (TextFieldData field in _listTextFieldData) {
      field.focusNode.addListener(() {
        if (!field.focusNode.hasFocus) {
          _validateField(field);
        }
      });
    }
  }

  @override
  void dispose() {
    for (TextFieldData field in _listTextFieldData) {
      field.focusNode.dispose();
      field.controller.dispose();
    }
    super.dispose();
  }

  // 유효성 검사 함수
  void _validateField(TextFieldData field) {
    bool isValid = false;
    switch (field.fieldName) {
      case 'email':
        isValid = field.controller.text.contains('@') &&
            field.controller.text.isNotEmpty;
        break;
      case 'password':
        isValid = field.controller.text.length >= 6;
        break;
      case 'name':
        isValid = field.controller.text.isNotEmpty;
        break;
    }

    setState(() {
      field.isValid = isValid;

      // 이메일이 유효하면 비밀번호 필드를 보이게
      if (field.fieldName == 'email' && isValid) {
        _listTextFieldData[1].showField = true; // 비밀번호 필드 표시
      }
      // 비밀번호가 유효하면 이름 필드를 보이게
      if (field.fieldName == 'password' && isValid) {
        _listTextFieldData[2].showField = true; // 이름 필드 표시
      }

      if (field.fieldName == 'name' && isValid) {
        _showSignUpButton = true; // 이름 필드 표시
      }
    });
  }

  void _togglePasswordVisible() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  void _onClickedSignUpButton() async {
    await ref.read(authProvider.notifier).signUp(
          _emailController.text,
          _passwordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("회원가입"),
      ),
      body: GestureDetector(
        onTap: () {
          // for (var element in _listTextFieldData) {
          //   FocusScope.of(context).requestFocus(element.focusNode);
          // }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (TextFieldData field in _listTextFieldData)
                if (field.showField) ...[
                  AuthText(text: "${field.fieldName} *"),
                  AuthTextField(
                    controller: field.controller,
                    fieldName: field.fieldName,
                    obscureText:
                        field.fieldName == 'password' ? _showPassword : null,
                    onSuffixIconPressed: field.fieldName == 'password'
                        ? _togglePasswordVisible
                        : null,
                    focusNode: field.focusNode,
                  ),
                ],
              Spacer(),
              if (_showSignUpButton) ...[
                AuthButton(
                  onPressed: _onClickedSignUpButton,
                  text: "회원가입",
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
