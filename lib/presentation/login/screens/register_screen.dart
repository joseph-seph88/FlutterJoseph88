import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:personal_select_chat/bloc/login/login_bloc.dart';
import 'package:personal_select_chat/bloc/login/login_event.dart';
import 'package:personal_select_chat/bloc/login/login_state.dart';
import 'package:personal_select_chat/core/theme/app_style.dart';
import 'package:personal_select_chat/core/utils/custom_snack_bar.dart';
import 'package:personal_select_chat/core/utils/validator.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    DateTime? selectedDate;
    final state = context.read<LoginBloc>().state;
    if (state is LoginFormState) {
      selectedDate = state.selectedDateTime;
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime(2006),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light()
              .copyWith(colorScheme: ColorScheme.light(primary: Colors.pink)),
          child: child!,
        );
      },
    );
    if (picked != null && context.mounted) {
      context.read<LoginBloc>().add(LoginFormEvent(selectedDateTime: picked));
    }
  }

  void controllerClear(BuildContext context) {
    _nameController.clear();
    _emailController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();
    context.read<LoginBloc>().add(ResetLoginFormEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          key: Key("scrollView"),
          child: Column(
            children: [
              _buildTitle(context),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildTop(),
                      SizedBox(height: 32),
                      _buildName(context),
                      SizedBox(height: 16),
                      _buildEmail(context),
                      SizedBox(height: 48),
                      _buildBirthDate(context),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 16),
                          Text('성별',
                              style: AppStyle.generalSmallMediumSubBody()),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                  child: _buildGenderSelectButton(
                                      '남성', Icons.male, context)),
                              SizedBox(width: 16),
                              Expanded(
                                  child: _buildGenderSelectButton(
                                      '여성', Icons.female, context)),
                            ],
                          ),
                          SizedBox(height: 16),
                        ],
                      ),
                      SizedBox(height: 24),
                      _buildPassword(context),
                      SizedBox(height: 16),
                      _buildConfirmPassword(context),
                      SizedBox(height: 38),
                      _buildAgreeTerms(),
                      SizedBox(height: 16),
                      _buildSignUp(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Row(children: [
      IconButton(
          key: Key('backButton'),
          onPressed: () {
            controllerClear(context);
            context.pop();
          },
          icon: Icon(Icons.arrow_back_ios)),
      Text('회원가입', style: AppStyle.generalLargeTitle()),
    ]);
  }

  Widget _buildTop() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFF58FB3),
            Color(0xFFE25181),
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('FreakXion과 함께', style: AppStyle.generalWhiteLargeBody()),
          SizedBox(height: 8),
          Text('특별한 만남을 시작하세요', style: AppStyle.generalWhiteMediumBody()),
          SizedBox(height: 16),
          Text('몇 가지 정보만 입력하면\n바로 시작할 수 있어요',
              style: AppStyle.generalWhite70SubBody()),
        ],
      ),
    );
  }

  Widget _buildName(BuildContext context) {
    return TextFormField(
      key: Key('nameField'),
      controller: _nameController,
      onTapOutside: (_) => FocusScope.of(context).unfocus(),
      decoration: InputDecoration(
          labelText: '이름', prefixIcon: Icon(Icons.person), hintText: '이름 입력..'),
      validator: (value) {
        final isEmptyResult = Validator.isEmptyValidator(value, '이름을 입력해주세요');
        if (isEmptyResult != null) {
          return isEmptyResult;
        }
        return null;
      },
    );
  }

  Widget _buildEmail(BuildContext context) {
    return TextFormField(
      key: Key('emailField'),
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      onTapOutside: (_) => FocusScope.of(context).unfocus(),
      decoration: InputDecoration(
          labelText: '이메일',
          prefixIcon: Icon(Icons.email),
          hintText: '이메일 입력..'),
      validator: (value) {
        final isEmptyResult = Validator.isEmptyValidator(value, '이메일을 입력해주세요');
        final isFormatResult = Validator.emailValidator(value);
        if (isEmptyResult != null) {
          return isEmptyResult;
        } else if (isFormatResult != null) {
          return isFormatResult;
        }
        return null;
      },
    );
  }

  Widget _buildBirthDate(BuildContext context) {
    return InkWell(
      key: Key('birthDate'),
      onTap: () => _selectDate(context),
      child: InputDecorator(
        decoration: InputDecoration(
            labelText: '생년월일',
            prefixIcon: Icon(Icons.cake),
            hintText: '생년월일 선택..',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
            filled: true,
            fillColor: Colors.grey[100]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BlocSelector<LoginBloc, LoginState, DateTime?>(selector: (state) {
              if (state is LoginFormState) {
                return state.selectedDateTime;
              }
              return null;
            }, builder: (context, selectedDate) {
              return Text(
                  selectedDate == null
                      ? '생년월일을 선택해주세요'
                      : '${selectedDate.year}년 ${selectedDate.month}월 ${selectedDate.day}일',
                  style: TextStyle(
                      color: selectedDate == null ? Colors.grey : Colors.black),
                  overflow: TextOverflow.ellipsis);
            }),
            Icon(Icons.arrow_drop_down, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildGenderSelectButton(
      String gender, IconData icon, BuildContext context) {
    return BlocSelector<LoginBloc, LoginState, String?>(selector: (state) {
      if (state is LoginFormState) {
        return state.gender;
      }
      return '';
    }, builder: (context, selectedGender) {
      bool isSelected = selectedGender == gender;

      return InkWell(
        onTap: () {
          context.read<LoginBloc>().add(LoginFormEvent(gender: gender));
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
              color: isSelected ? Colors.pink.withAlpha(20) : Colors.grey[100],
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                  color: isSelected ? Colors.pink : Colors.grey.shade300,
                  width: 2)),
          child: Column(
            children: [
              Icon(icon,
                  color: isSelected ? Colors.pink : Colors.grey, size: 30),
              SizedBox(height: 8),
              Text(
                gender,
                style: TextStyle(
                  color: isSelected ? Colors.pink : Colors.grey[700],
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildPassword(BuildContext context) {
    return BlocSelector<LoginBloc, LoginState, bool>(selector: (state) {
      if (state is LoginFormState) {
        return state.isRegisterPasswordVisible;
      }
      return false;
    }, builder: (context, isVisible) {
      return TextFormField(
        key: Key('passwordField'),
        controller: _passwordController,
        obscureText: !isVisible,
        onTapOutside: (_) => FocusScope.of(context).unfocus(),
        decoration: InputDecoration(
          labelText: '비밀번호',
          prefixIcon: Icon(Icons.lock),
          suffixIcon: IconButton(
            icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off),
            onPressed: () {
              context
                  .read<LoginBloc>()
                  .add(LoginFormEvent(isRegisterPasswordVisible: !isVisible));
            },
          ),
        ),
        validator: (value) {
          final isEmptyResult =
              Validator.isEmptyValidator(value, "비밀번호를 입력해주세요");
          final isFormatResult = Validator.passwordValidator(value);
          if (isEmptyResult != null) {
            return isEmptyResult;
          } else if (isFormatResult != null) {
            return isFormatResult;
          }
          return null;
        },
      );
    });
  }

  Widget _buildConfirmPassword(BuildContext context) {
    return BlocSelector<LoginBloc, LoginState, bool>(selector: (state) {
      if (state is LoginFormState) {
        return state.isConfirmPasswordVisible;
      }
      return false;
    }, builder: (context, isConfirmVisible) {
      return TextFormField(
        key: Key('confirmPasswordField'),
        controller: _confirmPasswordController,
        obscureText: !isConfirmVisible,
        onTapOutside: (_) => FocusScope.of(context).unfocus(),
        decoration: InputDecoration(
          labelText: '비밀번호 확인',
          prefixIcon: Icon(Icons.lock_outline),
          hintText: '비밀번호를 다시 입력해주세요',
          suffixIcon: IconButton(
            icon: Icon(
                isConfirmVisible ? Icons.visibility : Icons.visibility_off),
            onPressed: () {
              context.read<LoginBloc>().add(
                  LoginFormEvent(isConfirmPasswordVisible: !isConfirmVisible));
            },
          ),
        ),
        validator: (value) {
          final isEmptyResult =
              Validator.isEmptyValidator(value, "비밀번호를 입력해주세요");
          final isFormatResult = Validator.passwordValidator(value);
          final isSameResult = Validator.confirmPasswordValidator(
              value, _passwordController.text);
          if (isEmptyResult != null) {
            return isEmptyResult;
          } else if (isFormatResult != null) {
            return isFormatResult;
          } else if (isSameResult != null) {
            return isSameResult;
          }
          return null;
        },
      );
    });
  }

  Widget _buildAgreeTerms() {
    return Row(
      children: [
        SizedBox(height: 24),
        BlocSelector<LoginBloc, LoginState, bool>(selector: (state) {
          if (state is LoginFormState) {
            return state.isAgreeTerms;
          }
          return false;
        }, builder: (context, isAgree) {
          return Checkbox(
            value: isAgree,
            activeColor: Colors.pink,
            onChanged: (bool? value) {
              context
                  .read<LoginBloc>()
                  .add(LoginFormEvent(isAgreeTerms: value ?? false));
            },
          );
        }),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: TextStyle(color: Colors.black, fontSize: 14),
              children: [
                TextSpan(text: 'FreakXion\t'),
                TextSpan(
                  text: '이용약관\t',
                  style: TextStyle(
                    color: Colors.pink,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ),
                TextSpan(text: '과\t'),
                TextSpan(
                  text: '개인정보\t처리방침',
                  style: TextStyle(
                    color: Colors.pink,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ),
                TextSpan(text: '에\t동의합니다.'),
              ],
            ),
          ),
        ),
        SizedBox(height: 32),
      ],
    );
  }

  Widget _buildSignUp() {
    return BlocSelector<LoginBloc, LoginState, LoginFormState?>(
        selector: (state) {
      if (state is LoginFormState) {
        return state;
      }
      return null;
    }, builder: (context, formState) {
      DateTime? date = formState?.selectedDateTime;
      bool agreeTerms = formState?.isAgreeTerms ?? false;
      String? gender = formState?.gender;

      return ElevatedButton(
        key: Key('signUp'),
        onPressed: () {
          if (_formKey.currentState!.validate() &&
              date != null &&
              gender != null &&
              agreeTerms) {
            controllerClear(context);
            CustomSnackBar().showCustomSnackBar(context, '회원가입 성공');
            context.pop();
          } else if (_formKey.currentState!.validate() && date == null) {
            CustomSnackBar().showCustomSnackBar(context, '생년월일을 선택해주세요');
          } else if (_formKey.currentState!.validate() && gender == null) {
            CustomSnackBar().showCustomSnackBar(context, '성별을 선택해주세요');
          } else if (_formKey.currentState!.validate() && !agreeTerms) {
            CustomSnackBar().showCustomSnackBar(context, '이용약관에 동의해주세요');
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.pink[200],
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: Text('회원가입', style: AppStyle.generalWhiteMediumBody()),
      );
    });
  }
}
