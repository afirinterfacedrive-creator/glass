import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:universal_glass/enums/glass_enums.dart';

mixin GlassFieldStateMixin<T extends ConsumerStatefulWidget> on ConsumerState<T> { // <- 1. ICI: ConsumerStatefulWidget
  // ===========================================================================
  // ETAT A OVERRIDER
  // ===========================================================================
  TextEditingController get controller;
  FocusNode get focusNode;
  String? get successText;
  String? Function(String?)? get validator;
  AutovalidateMode get autovalidateMode;
  VoidCallback? get onValidated;

  // ===========================================================================
  // ETAT INTERNE
  // ===========================================================================
  bool hasFocus = false;
  GlassFieldState fieldState = GlassFieldState.normal;
  String? helperText;

  // ===========================================================================
  // GETTERS COMPAT
  // ===========================================================================
  String? get errorText => fieldState == GlassFieldState.error ? helperText : null;
  String? get successHelperText => fieldState == GlassFieldState.success ? helperText : null;
  bool get hasError => fieldState == GlassFieldState.error;
  bool get hasSuccess => fieldState == GlassFieldState.success;

  // ===========================================================================
  // LIFECYCLE
  // ===========================================================================
  void initGlassFieldState() {
    focusNode.addListener(_handleFocusChanged);
    hasFocus = focusNode.hasFocus;
  }

  void disposeGlassFieldState() {
    focusNode.removeListener(_handleFocusChanged);
  }

  void didUpdateGlassFieldState(
    FocusNode oldFocusNode,
    FocusNode newFocusNode,
  ) {
    if (oldFocusNode != newFocusNode) {
      oldFocusNode.removeListener(_handleFocusChanged);
      newFocusNode.addListener(_handleFocusChanged);
      hasFocus = newFocusNode.hasFocus;
    }
  }

  // ===========================================================================
  // FOCUS
  // ===========================================================================
  void _handleFocusChanged() {
    if (!mounted) return;
    hasFocus = focusNode.hasFocus;

    if (!hasFocus && autovalidateMode == AutovalidateMode.onUnfocus) {
      validate(controller.text);
    }
    setState(() {}); // pour rebuild border/focus
  }

  // ===========================================================================
  // VALIDATION
  // ===========================================================================
  void validate(String? value) {
    final String? Function(String?)? validator = this.validator;
    if (validator == null) return;

    final String? newError = validator(value);
    final bool hasValue = (value ?? '').isNotEmpty;

    setState(() {
      if (newError != null && newError.isNotEmpty) {
        fieldState = GlassFieldState.error;
        helperText = newError;
      } else if (hasValue) {
        fieldState = GlassFieldState.success;
        helperText = successText ?? "Valide";
      } else {
        fieldState = GlassFieldState.normal;
        helperText = null;
      }
    });

    onValidated?.call();
  }

  // ===========================================================================
  // HELPERS
  // ===========================================================================
  void setError(String message) {
    setState(() {
      fieldState = GlassFieldState.error;
      helperText = message;
    });
  }

  void setSuccess([String? message]) {
    setState(() {
      fieldState = GlassFieldState.success;
      helperText = message ?? successText ?? "Valide";
    });
  }

  void resetState() {
    setState(() {
      fieldState = GlassFieldState.normal;
      helperText = null;
    });
  }

  void handleChanged(String value) {
    final bool shouldValidate =
        autovalidateMode == AutovalidateMode.always ||
        autovalidateMode == AutovalidateMode.onUserInteraction ||
        hasError;

    if (shouldValidate) validate(value);
  }

  void handleSubmitted(String value) {
    validate(value);
  }
}