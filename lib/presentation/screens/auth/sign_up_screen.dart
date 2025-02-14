import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:o2/core/utils/auth_validator.dart';
import 'package:o2/domain/entities/user_entity.dart';
import 'package:o2/presentation/providers/auth_provider.dart';
import 'package:o2/presentation/screens/auth/widgets/auth_text.dart';
import 'package:o2/presentation/screens/auth/widgets/text_field_data.dart';

import 'widgets/auth_button.dart';
import 'widgets/auth_text_field.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final List<TextFieldData> _listTextFieldData = [
    TextFieldData("email"),
    TextFieldData("password"),
    TextFieldData("passwordConfirm"),
    TextFieldData("name"),
  ];

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

      field.controller.addListener(() {
        if (field.isValid) {
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

  void _validateField(TextFieldData field) async {
    final result = await _getValidationResult(field);
    _updateFieldState(field, result);
  }

  Future<ValidatorResult> _getValidationResult(TextFieldData field) async {
    switch (field.fieldName) {
      case "email":
        return await AuthValidator.validateEmail(field.controller.text, ref);
      case "password":
        return AuthValidator.validatePassword(field.controller.text);
      case "passwordConfirm":
        return AuthValidator.validatePasswordConfirm(
            field.controller.text, _listTextFieldData[1].controller.text);
      default:
        return ValidatorResult(isValid: true, errorMessage: null);
    }
  }

  void _updateFieldState(TextFieldData field, ValidatorResult result) {
    setState(() {
      field.isValid = result.isValid;
      field.errorText = result.errorMessage;

      if (result.isValid) {
        _handleValidField(field);
      } else {
        _handleInvalidField(field);
      }
    });
  }

  void _handleValidField(TextFieldData field) {
    final currentIndex = _listTextFieldData.indexOf(field);
    if (currentIndex < _listTextFieldData.length - 1) {
      _listTextFieldData[currentIndex + 1].showField = true;
    }
    if (field.fieldName == "passwordConfirm") {
      _showSignUpButton = true;
    }
  }

  void _handleInvalidField(TextFieldData field) {
    final currentIndex = _listTextFieldData.indexOf(field);
    for (int index = currentIndex + 1;
        index < _listTextFieldData.length;
        index++) {
      _listTextFieldData[index].showField = false;
      _listTextFieldData[index].controller.clear();
    }
    _showSignUpButton = false;
  }

  void _togglePasswordVisible() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  void _onClickedSignUpButton() async {
    final userEntity = UserEntity(
      id: "",
      email: _listTextFieldData[0].controller.text,
      name: _listTextFieldData[2].controller.text,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final success = await ref
        .read(authProvider.notifier)
        .signUp(userEntity, _listTextFieldData[1].controller.text);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("회원가입이 완료되었습니다.")),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("회원가입"),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        behavior: HitTestBehavior.translucent,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (TextFieldData field in _listTextFieldData)
                if (field.showField) ...[
                  AuthText(fieldName: field.fieldName),
                  AuthTextField(
                    controller: field.controller,
                    fieldName: field.fieldName,
                    obscureText: field.fieldName.contains("password")
                        ? _showPassword
                        : null,
                    onSuffixIconPressed: field.fieldName.contains("password")
                        ? _togglePasswordVisible
                        : null,
                    focusNode: field.focusNode,
                    errorText: field.errorText,
                  ),
                ],
              const Spacer(),
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
