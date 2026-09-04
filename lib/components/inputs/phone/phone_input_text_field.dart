import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PhoneInputTextField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;

  final bool enabled;
  final bool readOnly;
  final String? hintText;

  final double fontSize;
  final FontWeight fontWeight;
  final double hintFontSize;

  final Color textColor;
  final Color hintColor;
  final Color cursorColor;

  final TextInputAction textInputAction;
  final List<TextInputFormatter> inputFormatters;

  final Widget? suffixIcon;

  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  const PhoneInputTextField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.enabled,
    required this.readOnly,
    required this.hintText,
    required this.fontSize,
    required this.fontWeight,
    required this.hintFontSize,
    required this.textColor,
    required this.hintColor,
    required this.cursorColor,
    required this.textInputAction,
    required this.inputFormatters,
    required this.suffixIcon,
    required this.onTap,
    required this.onChanged,
    required this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,

      enabled: enabled,
      readOnly: readOnly,

      showCursor: true,

      keyboardType: TextInputType.phone,
      textInputAction: textInputAction,

      textAlignVertical: TextAlignVertical.center,

      inputFormatters: inputFormatters,

      style: TextStyle(
        color: textColor,
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),

      cursorColor: cursorColor,

      // IMPORTANT :
      // Aucun requestFocus ici.
      //
      // Le TextFormField garde entièrement le contrôle du tap,
      // du focus et du positionnement du curseur.
      onTap: onTap,

      onChanged: onChanged,

      onFieldSubmitted: onSubmitted,

      decoration: InputDecoration(
        isDense: true,

        hintText: hintText,

        hintStyle: TextStyle(
          color: hintColor,
          fontSize: hintFontSize,
        ),

        errorText: null,

        contentPadding: EdgeInsets.zero,

        suffixIcon: suffixIcon,

        suffixIconConstraints: const BoxConstraints(
          minWidth: 0,
          minHeight: 0,
        ),

        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
      ),
    );
  }
}