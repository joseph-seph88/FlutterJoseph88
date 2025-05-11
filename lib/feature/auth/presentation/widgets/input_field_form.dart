import 'package:flutter/material.dart';
import 'package:project_login/core/app_style/app_theme.dart';

class InputFieldForm extends StatelessWidget {
  final TextEditingController textController;
  final bool isInitial;
  final bool isNotValid;
  final String errorMsg;
  final TextInputType? textType;
  final String? keyStr;
  final String? labelText;
  final String? hintText;
  final bool? isVisible;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final Function()? suffixIconOnPressed;

  const InputFieldForm({
    super.key,
    required this.textController,
    required this.isInitial,
    required this.isNotValid,
    required this.errorMsg,
    this.textType,
    this.keyStr,
    this.labelText,
    this.hintText,
    this.isVisible,
    this.prefixIcon,
    this.suffixIcon,
    this.suffixIconOnPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
              color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
          child: TextField(
            key: Key(keyStr ?? ''),
            controller: textController,
            obscureText: isVisible ?? false,
            keyboardType: textType,
            decoration: InputDecoration(
              labelText: labelText,
              hintText: hintText,
              hintStyle: TextStyle(color: AppTheme.greyColor),
              labelStyle: const TextStyle(color: AppTheme.greyColor),
              prefixIcon: Icon(prefixIcon, color: AppTheme.greyColor),
              suffixIcon: IconButton(
                  onPressed: suffixIconOnPressed,
                  icon: Icon(suffixIcon, color: AppTheme.subPrimary)),
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
            ),
          ),
        ),
        if (!isInitial && isNotValid)
          Padding(
              padding: const EdgeInsets.only(top: 4, left: 40),
              child: Text(errorMsg,
                  style: const TextStyle(fontSize: 12, color: Colors.red))),
      ],
    );
  }
}

// class InputFieldForm extends StatelessWidget {
//   final String hintText;
//   final IconData icon;
//   final bool? isPassword;
//   final TextInputType? keyboardType;
//   final Function(String)? onChanged;
//   final String? errorText;

//   const InputFieldForm({
//     super.key,
//     required this.hintText,
//     required this.icon,
//     this.keyboardType,
//     this.isPassword,
//     this.onChanged,
//     this.errorText,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withAlpha(25),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: TextField(
//         onChanged: onChanged,
//         obscureText: isPassword ?? false,
//         keyboardType: keyboardType,
//         style: TextStyle(
//           color: Colors.black87,
//           fontSize: 16,
//         ),
//         decoration: InputDecoration(
//           contentPadding: const EdgeInsets.symmetric(vertical: 20),
//           border: InputBorder.none,
//           hintText: hintText,
//           hintStyle: TextStyle(
//             color: Colors.grey.shade500,
//           ),
//           prefixIcon: Icon(
//             icon,
//             color:
//                 errorText != null ? Colors.redAccent : const Color(0xFF2E3192),
//           ),
//           errorText: errorText,
//           errorStyle: TextStyle(
//             color: Colors.redAccent,
//           ),
//         ),
//       ),
//     );
//   }
// }
