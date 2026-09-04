import 'package:flutter/material.dart';

class OutlinedFieldController {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String? Function(String?)? validator;
  final AutovalidateMode autovalidateMode;
  final VoidCallback onUpdate;

  String? errorText;
  bool _wasFocused = false;
  bool isObscured;

  OutlinedFieldController({
    required this.controller,
    required this.focusNode,
    required this.validator,
    required this.autovalidateMode,
    required this.onUpdate,
    required bool obscureText,
  }) : isObscured = obscureText {
    focusNode.addListener(_onFocusChange);
    controller.addListener(_validateOnTrack);
  }

  void dispose() {
    focusNode.removeListener(_onFocusChange);
    controller.removeListener(_validateOnTrack);
  }

  void _onFocusChange() {
    if (_wasFocused && !focusNode.hasFocus) {
      if (validator != null) errorText = validator!(controller.text);
    }
    _wasFocused = focusNode.hasFocus;
    onUpdate();
  }

  void _validateOnTrack() {
    if (autovalidateMode == AutovalidateMode.onUserInteraction && errorText != null) {
      final error = validator?.call(controller.text);
      if (errorText != error) {
        errorText = error;
        onUpdate();
      }
    }
  }

  void validate(String value) {
    if (validator != null) {
      errorText = validator!(value);
      onUpdate();
    }
  }

  void toggleObscure() {
    isObscured = !isObscured;
    onUpdate();
  }

  bool get hasError => errorText != null && errorText!.trim().isNotEmpty;
  bool get isFocused => focusNode.hasFocus;
}