import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:universal_glass/components/inputs/universal_glass_phone_input.dart';
import 'package:universal_glass/components/inputs/phone/universal_glass_phone_input_view.dart';
import 'package:universal_glass/enums/glass_enums.dart';
import 'package:universal_glass/phone/phone_country.dart';
import 'package:universal_glass/phone/phone_country_registry.dart';

import 'package:universal_glass/utils/glass_text_formatter.dart';

class UniversalGlassPhoneInputState extends ConsumerState<UniversalGlassPhoneInput> {
  // ===========================================================================
  // CONTRÔLEURS INTERNES
  // ===========================================================================
  late final TextEditingController internalController;
  late final FocusNode internalFocusNode;
  late final Future<PhoneCountryRegistry> registryFuture;
  bool _countryInitializationStarted = false;

  // ===========================================================================
  // CONTRÔLEURS EFFECTIFS
  // ===========================================================================
  TextEditingController get controller => widget.controller?? internalController;
  FocusNode get focusNode => widget.focusNode?? internalFocusNode;

  // ===========================================================================
  // ÉTAT
  // ===========================================================================
  PhoneCountry? internalCountry;
  bool hasFocus = false; // <- utilisé par la view

  GlassFieldState fieldState = GlassFieldState.normal;
  String? helperText;

  // ===========================================================================
  // OPERATEUR DETECTE
  // ===========================================================================
  // ===========================================================================
  // OPERATEUR DETECTE (DYNAMIQUE POUR LES 254 PAYS)
  // ===========================================================================
    // ===========================================================================
  // OPERATEUR DETECTE (DYNAMIQUE ET COMPATIBLE 254 PAYS)
  // ===========================================================================
  String get detectedOperator {
    final String normalized = normalizePhoneNumber(controller.text);
    final PhoneCountry? country = effectiveCountry;

    if (country == null || normalized.isEmpty) return '';

    // Utilisation directe de la méthode interne du pays configuré
    final PhoneOperator? operator = country.operatorForPrefix(normalized);

    // Retourne le nom court s'il existe, sinon une chaîne vide
    return operator?.shortName ?? '';
  }


/*

  String get detectedOperator {
    final String normalized = normalizePhoneNumber(controller.text);
    final PhoneCountry? country = effectiveCountry;
    if (country == null || normalized.isEmpty) return '';

    if (country.isoCode == 'BF') {
      if (normalized.length < 2) return '';
      final String prefix = normalized.substring(0, 2);
      if (['01', '02', '03'].contains(prefix)) return 'Orange';
      if (['04', '05'].contains(prefix)) return 'Moov';
      if (['06', '07'].contains(prefix)) return 'Telecel';
    }

    if (country.isoCode == 'CI') {
      if (normalized.length < 2) return '';
      final String prefix = normalized.substring(0, 2);
      if (['01', '05', '07'].contains(prefix)) return 'Orange';
      if (['02', '08'].contains(prefix)) return 'Moov';
      if (['03', '09'].contains(prefix)) return 'MTN';
    }
    return '';
  }
*/
  // COMPATIBILITE
  String? get errorText => fieldState == GlassFieldState.error? helperText : null;
  String? get successText => fieldState == GlassFieldState.success? helperText : null;
  bool get hasError => fieldState == GlassFieldState.error;
  bool get hasSuccess => fieldState == GlassFieldState.success;
  bool get isFocused => focusNode.hasFocus; // <- AJOUT: getter pour la view

  // ===========================================================================
  // PAYS EFFECTIF
  // ===========================================================================
  PhoneCountry? get effectiveCountry => widget.country?? internalCountry;
  String get effectiveCountryCode => effectiveCountry?.dialCode?? '';
  String get effectiveCountryFlag => effectiveCountry?.flag?? '🌐';

  String? get effectiveFlagAsset {
    final PhoneCountry? country = effectiveCountry;
    if (country == null) return null;
    // ignore: unnecessary_nullable_for_final_variable_declarations
    final String? asset = country.effectiveFlagAsset;
    if (asset == null || asset.trim().isEmpty) return null;
    return asset;
  }

  // ===========================================================================
  // FORMATAGE EFFECTIF
  // ===========================================================================
  int get effectiveMaxPhoneDigits {
    final PhoneCountry? country = effectiveCountry;
    if (country!= null && country.nationalDigits.isNotEmpty) {
      return country.nationalDigits.reduce((int a, int b) => a > b? a : b);
    }
    return widget.maxPhoneDigits;
  }

  List<int> get effectivePhoneFormatGroups {
    final PhoneCountry? country = effectiveCountry;
    if (country!= null && country.formatGroups.isNotEmpty) {
      return country.formatGroups;
    }
    return widget.phoneFormatGroups;
  }

  String get effectiveHintText {
    final String? explicit = widget.hintText;
    if (explicit!= null && explicit.trim().isNotEmpty) return explicit;
    final PhoneCountry? country = effectiveCountry;
    if (country!= null) {
      final String placeholder = country.effectivePlaceholder;
      if (placeholder.trim().isNotEmpty) return placeholder;
    }
    if (widget.formatPhoneNumber && effectivePhoneFormatGroups.isNotEmpty) {
      return effectivePhoneFormatGroups.map((int group) => 'x' * group).join(' ');
    }
    return 'Numéro de téléphone';
  }

  // ===========================================================================
  // BUILD
  // ===========================================================================
  @override
  Widget build(BuildContext context) {
    return UniversalGlassPhoneInputView(state: this);
  }

  // ===========================================================================
  // INITIALISATION
  // ===========================================================================
  @override
  void initState() {
    super.initState();
    internalController = TextEditingController();
    internalFocusNode = FocusNode();
    focusNode.addListener(handleFocusChanged);
    hasFocus = focusNode.hasFocus;
    registryFuture = PhoneCountryRegistry.load();
    initializeCountry();
    formatInitialValue();

    if (widget.autofocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        if (widget.enabled &&!widget.readOnly) {
          focusNode.requestFocus();
        }
      });
    }
  }

  // ===========================================================================
  // INITIALISATION DU PAYS
  // ===========================================================================
  Future<void> initializeCountry() async {
    if (_countryInitializationStarted) return;
    if (widget.country!= null) return;
    _countryInitializationStarted = true;

    try {
      final PhoneCountryRegistry registry = await registryFuture;
      final PhoneCountry? country = registry.findByIsoCode(widget.initialCountryIsoCode);
      final PhoneCountry? selectedCountry = country?? registry.first();
      if (selectedCountry == null) return;
      if (!mounted) return;

      setState(() {
        internalCountry = selectedCountry;
        fieldState = GlassFieldState.normal;
        helperText = null;
      });

      formatInitialValue();
    } catch (error, stackTrace) {
      debugPrint('UniversalGlassPhoneInput: erreur chargement pays => $error');
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  // ===========================================================================
  // DID UPDATE WIDGET
  // ===========================================================================
  @override
  void didUpdateWidget(covariant UniversalGlassPhoneInput oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.focusNode!= widget.focusNode) {
      final FocusNode oldNode = oldWidget.focusNode?? internalFocusNode;
      oldNode.removeListener(handleFocusChanged);
      final FocusNode newNode = focusNode;
      newNode.addListener(handleFocusChanged);
      hasFocus = newNode.hasFocus;
    }

    if (oldWidget.controller!= widget.controller) {
      formatInitialValue();
    }

    if (oldWidget.country!= widget.country) {
      setState(() {
        fieldState = GlassFieldState.normal;
        helperText = null;
      });
      formatInitialValue();
    }

    if (oldWidget.initialCountryIsoCode!= widget.initialCountryIsoCode) {
      if (widget.country == null) {
        _countryInitializationStarted = false;
        initializeCountry();
      }
    }

    final bool formatChanged =
        oldWidget.maxPhoneDigits!= widget.maxPhoneDigits ||
       !_listEquals(oldWidget.phoneFormatGroups, widget.phoneFormatGroups) ||
        oldWidget.formatPhoneNumber!= widget.formatPhoneNumber;

    if (formatChanged) {
      formatInitialValue();
    }
  }

  bool _listEquals(List<int> a, List<int> b) {
    if (identical(a, b)) return true;
    if (a.length!= b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i]!= b[i]) return false;
    }
    return true;
  }

  // ===========================================================================
  // FOCUS - CORRIGE
  // ===========================================================================
  void handleFocusChanged() {
    if (!mounted) return;
    final bool focused = focusNode.hasFocus;
    if (hasFocus!= focused) { // <- FIX: on rebuild seulement si ça change
      setState(() {
        hasFocus = focused;
      });
    }

    if (!focused && widget.autovalidateMode == AutovalidateMode.onUnfocus) {
      validate(controller.text);
    }
  }

  // ===========================================================================
  // FORMATAGE INITIAL
  // ===========================================================================
  void formatInitialValue() {
    final String currentText = controller.text;
    if (currentText.isEmpty) return;

    int cursorOffset = controller.selection.baseOffset;
    if (cursorOffset < 0) cursorOffset = currentText.length;
    cursorOffset = cursorOffset.clamp(0, currentText.length);

    final int digitsBeforeCursor =
        GlassTextFormatter.countDigitsBeforeCursor(currentText, cursorOffset);

    final String formatted = GlassTextFormatter.formatPhone(
      currentText,
      groups: effectivePhoneFormatGroups,
      maxDigits: effectiveMaxPhoneDigits,
      enabled: widget.formatPhoneNumber,
    );

    if (currentText == formatted) return;

    final int newCursorPosition = GlassTextFormatter.calculateCursorPosition(
      formatted: formatted,
      digitCountBeforeCursor: digitsBeforeCursor,
    );

    controller.value = TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: newCursorPosition.clamp(0, formatted.length)),
      composing: TextRange.empty,
    );
  }

  // ===========================================================================
  // NORMALISATION
  // ===========================================================================
  String normalizePhoneNumber(String value) {
    return GlassTextFormatter.clearPhoneString(value, maxDigits: effectiveMaxPhoneDigits);
  }

  // ===========================================================================
  // CHANGEMENT TEXTE
  // ===========================================================================
  void handleChanged(String value) {
    final String normalized = normalizePhoneNumber(value);
    final bool shouldValidate =
        widget.autovalidateMode == AutovalidateMode.always ||
        widget.autovalidateMode == AutovalidateMode.onUserInteraction ||
        hasError;

    if (shouldValidate) validate(normalized);
    widget.onChanged?.call(normalized);
  }

  // ===========================================================================
  // SUBMIT
  // ===========================================================================
  void handleSubmitted(String value) {
    final String normalized = normalizePhoneNumber(value);
    validate(normalized);
    widget.onSubmitted?.call(normalized);
  }

  // ===========================================================================
  // VALIDATION
  // ===========================================================================
  void validate(String? value) {
    final String? Function(String?)? validator = widget.validator;
    if (validator == null) return;

    final String normalized = normalizePhoneNumber(value?? '');
    final String? newError = validator(normalized);
    final int digitCount = normalized.length;

    setState(() {
      if (newError!= null && newError.isNotEmpty) {
        fieldState = GlassFieldState.error;
        helperText = newError;
      } else if (digitCount > 0 && digitCount >= effectiveMaxPhoneDigits) {
        fieldState = GlassFieldState.success;
        helperText = widget.successText?? "Numéro valide";
      } else if (digitCount > 0) {
        fieldState = GlassFieldState.normal;
        helperText = null;
      } else {
        fieldState = GlassFieldState.normal;
        helperText = null;
      }
    });
  }

  // ===========================================================================
  // SÉLECTION DU PAYS
  // ===========================================================================
  void selectCountry(PhoneCountry country) {
    if (!mounted) return;
    setState(() {
      if (widget.country == null) internalCountry = country;
      fieldState = GlassFieldState.normal;
      helperText = null;
    });
    controller.clear();
    widget.onCountryChanged?.call(country);
  }

  // ===========================================================================
  // SUFFIX
  // ===========================================================================
  void handleSuffixTap() {
    if (!widget.enabled || widget.readOnly || widget.onSuffixTap == null) return;
    widget.onSuffixTap!();
  }

  // ===========================================================================
  // FORMATTERS
  // ===========================================================================
  List<TextInputFormatter> get inputFormatters {
    if (widget.formatPhoneNumber) {
      return <TextInputFormatter>[
        GlassTextFormatter.phoneFormatter(groups: effectivePhoneFormatGroups, maxDigits: effectiveMaxPhoneDigits),
      ];
    }
    return <TextInputFormatter>[
      FilteringTextInputFormatter.digitsOnly,
      LengthLimitingTextInputFormatter(effectiveMaxPhoneDigits),
    ];
  }

  // ===========================================================================
  // DISPOSE
  // ===========================================================================
  @override
  void dispose() {
    focusNode.removeListener(handleFocusChanged);
    internalController.dispose();
    internalFocusNode.dispose();
    super.dispose();
  }
}