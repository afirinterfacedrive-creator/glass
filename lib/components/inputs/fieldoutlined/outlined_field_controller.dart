
import 'package:flutter/material.dart';

import 'package:universal_glass/enums/glass_enums.dart';

class OutlinedFieldController {
  final TextEditingController controller;
  final FocusNode focusNode;

  String? Function(String?)? validator;
  AutovalidateMode autovalidateMode;
  String? successText;

  final VoidCallback onUpdate;

  // ==========================================================================
  // ETAT
  // ==========================================================================

  String? helperText;

  GlassFieldState fieldState =
      GlassFieldState.normal;

  bool _wasFocused = false;

  /// Indique que l'utilisateur a réellement commencé à interagir
  /// avec le champ ou qu'une validation explicite a été demandée.
  bool _touched = false;

  bool isObscured;

  OutlinedFieldController({
    required this.controller,
    required this.focusNode,
    required this.validator,
    required this.autovalidateMode,
    this.successText,
    required this.onUpdate,
    required bool obscureText,
  }) : isObscured = obscureText {
    focusNode.addListener(_onFocusChange);
    controller.addListener(_onControllerChanged);

    // ------------------------------------------------------------------------
    // VALEUR INITIALE
    // ------------------------------------------------------------------------
    //
    // Une valeur initiale existante peut être considérée comme déjà renseignée,
    // mais on ne force pas l'affichage d'une erreur au premier affichage.
    //
    if (controller.text.isNotEmpty) {
      _touched = true;
      _validateValue(
        controller.text,
        notify: false,
      );
    }
  }

  // ==========================================================================
  // DISPOSE
  // ==========================================================================

  void dispose() {
    focusNode.removeListener(_onFocusChange);
    controller.removeListener(_onControllerChanged);
  }

  // ==========================================================================
  // MISE A JOUR DES PARAMETRES
  // ==========================================================================

  void updateConfiguration({
    String? Function(String?)? validator,
    AutovalidateMode? autovalidateMode,
    String? successText,
    bool? obscureText,
  }) {
    bool changed = false;

    if (this.validator != validator) {
      this.validator = validator;
      changed = true;
    }

    if (autovalidateMode != null &&
        this.autovalidateMode != autovalidateMode) {
      this.autovalidateMode = autovalidateMode;
      changed = true;
    }

    if (successText != null &&
        this.successText != successText) {
      this.successText = successText;
      changed = true;
    }

    if (obscureText != null &&
        isObscured != obscureText) {
      isObscured = obscureText;
      changed = true;
    }

    if (changed) {
      _revalidateIfNecessary();
    }
  }

  // ==========================================================================
  // FOCUS
  // ==========================================================================

  void _onFocusChange() {
    final bool isFocused =
        focusNode.hasFocus;

    // ------------------------------------------------------------------------
    // PERTE DE FOCUS
    // ------------------------------------------------------------------------

    if (_wasFocused && !isFocused) {
      _touched = true;

      if (autovalidateMode ==
          AutovalidateMode.onUnfocus) {
        validate(controller.text);
      }
    }

    _wasFocused = isFocused;

    onUpdate();
  }

  // ==========================================================================
  // CONTROLLER CHANGE
  // ==========================================================================

  void _onControllerChanged() {
    _validateOnTrack();
  }

  // ==========================================================================
  // VALIDATION AUTOMATIQUE
  // ==========================================================================

  void _validateOnTrack() {
    final bool shouldValidate =
        _touched ||
        autovalidateMode ==
            AutovalidateMode.always ||
        autovalidateMode ==
            AutovalidateMode.onUserInteraction ||
        hasError;

    if (!shouldValidate) {
      return;
    }

    _validateValue(
      controller.text,
      notify: true,
    );
  }

  // ==========================================================================
  // VALIDATION INTERNE
  // ==========================================================================

  void _validateValue(
    String value, {
    bool notify = true,
  }) {
    final String? newError =
        validator?.call(value);

    final bool hasValue =
        value.trim().isNotEmpty;

    GlassFieldState newState;
    String? newHelper;

    // ------------------------------------------------------------------------
    // ERROR
    // ------------------------------------------------------------------------

    if (newError != null &&
        newError.isNotEmpty) {
      newState =
          GlassFieldState.error;
      newHelper = newError;
    }

    // ------------------------------------------------------------------------
    // SUCCESS
    // ------------------------------------------------------------------------

    else if (hasValue) {
      newState =
          GlassFieldState.success;
      newHelper =
          successText ?? 'Valide';
    }

    // ------------------------------------------------------------------------
    // NORMAL
    // ------------------------------------------------------------------------

    else {
      newState =
          GlassFieldState.normal;
      newHelper = null;
    }

    final bool changed =
        fieldState != newState ||
        helperText != newHelper;

    fieldState = newState;
    helperText = newHelper;

    if (changed && notify) {
      onUpdate();
    }
  }

  // ==========================================================================
  // VALIDATION EXPLICITE
  // ==========================================================================

  void validate(String value) {
    _touched = true;

    _validateValue(
      value,
      notify: true,
    );
  }

  // ==========================================================================
  // CHANGEMENT UTILISATEUR
  // ==========================================================================

  void handleChanged(String value) {
    // ------------------------------------------------------------------------
    // IMPORTANT
    // ------------------------------------------------------------------------
    //
    // Le TextEditingController possède déjà un listener.
    //
    // On ne relance donc pas ici une seconde validation.
    //
    // On marque simplement le champ comme touché lorsque le mode exige
    // une interaction utilisateur.
    //
    if (autovalidateMode ==
        AutovalidateMode.onUserInteraction) {
      _touched = true;
    }
  }

  // ==========================================================================
  // SUBMIT
  // ==========================================================================

  void handleSubmitted(String value) {
    _touched = true;

    validate(value);
  }

  // ==========================================================================
  // PASSWORD / OBSCURE
  // ==========================================================================

  void toggleObscure() {
    isObscured = !isObscured;
    onUpdate();
  }

  // ==========================================================================
  // RESET
  // ==========================================================================

  void reset() {
    _touched = false;
    _wasFocused = focusNode.hasFocus;

    fieldState =
        GlassFieldState.normal;

    helperText = null;

    onUpdate();
  }

  // ==========================================================================
  // REVALIDATION APRES MODIFICATION DE CONFIGURATION
  // ==========================================================================

  void _revalidateIfNecessary() {
    if (!_touched &&
        autovalidateMode !=
            AutovalidateMode.always) {
      return;
    }

    _validateValue(
      controller.text,
      notify: true,
    );
  }

  // ==========================================================================
  // GETTERS
  // ==========================================================================

  bool get hasError {
    return fieldState ==
        GlassFieldState.error;
  }

  bool get hasSuccess {
    return fieldState ==
        GlassFieldState.success;
  }

  String? get errorText {
    return hasError
        ? helperText
        : null;
  }

  String? get successTextValue {
    return hasSuccess
        ? helperText
        : null;
  }

  bool get isFocused {
    return focusNode.hasFocus;
  }

  /// Erreur visible uniquement après interaction.
  bool get shouldShowError {
    return hasError && _touched;
  }

  /// Succès visible uniquement après interaction.
  bool get shouldShowSuccess {
    return hasSuccess && _touched;
  }

  bool get isTouched {
    return _touched;
  }
}
