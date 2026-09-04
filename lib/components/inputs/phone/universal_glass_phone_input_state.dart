import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:universal_glass/components/inputs/universal_glass_phone_input.dart';
import 'package:universal_glass/components/inputs/phone/universal_glass_phone_input_view.dart';
import 'package:universal_glass/phone/phone_country.dart';
import 'package:universal_glass/phone/phone_country_registry.dart';
import 'package:universal_glass/utils/glass_text_formatter.dart';

class UniversalGlassPhoneInputState
    extends ConsumerState<UniversalGlassPhoneInput> {
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

  TextEditingController get controller =>
      widget.controller ?? internalController;

  FocusNode get focusNode =>
      widget.focusNode ?? internalFocusNode;

  // ===========================================================================
  // ÉTAT
  // ===========================================================================

  PhoneCountry? internalCountry;

  /// État de focus conservé pour les consommateurs qui en ont besoin.
  ///
  /// IMPORTANT :
  /// Ce changement ne déclenche volontairement PAS de setState().
  /// Le rendu visuel du focus est maintenant géré localement par
  /// _PhoneInputFocusBuilder dans UniversalGlassPhoneInputView.
  bool hasFocus = false;

  String? errorText;

  // ===========================================================================
  // PAYS EFFECTIF
  // ===========================================================================

  PhoneCountry? get effectiveCountry =>
      widget.country ?? internalCountry;

  String get effectiveCountryCode =>
      effectiveCountry?.dialCode ?? '';

  String get effectiveCountryFlag =>
      effectiveCountry?.flag ?? '🌐';

  String? get effectiveFlagAsset {
    final PhoneCountry? country = effectiveCountry;

    if (country == null) {
      return null;
    }

    final String? asset = country.effectiveFlagAsset;

    if (asset == null || asset.trim().isEmpty) {
      return null;
    }

    return asset;
  }

  // ===========================================================================
  // FORMATAGE EFFECTIF
  // ===========================================================================

  int get effectiveMaxPhoneDigits {
    final PhoneCountry? country = effectiveCountry;

    if (country != null &&
        country.nationalDigits.isNotEmpty) {
      return country.nationalDigits.reduce(
        (int a, int b) => a > b ? a : b,
      );
    }

    return widget.maxPhoneDigits;
  }

  List<int> get effectivePhoneFormatGroups {
    final PhoneCountry? country = effectiveCountry;

    if (country != null &&
        country.formatGroups.isNotEmpty) {
      return country.formatGroups;
    }

    return widget.phoneFormatGroups;
  }

  String get effectiveHintText {
    final String? explicit = widget.hintText;

    if (explicit != null &&
        explicit.trim().isNotEmpty) {
      return explicit;
    }

    final PhoneCountry? country = effectiveCountry;

    if (country != null) {
      final String placeholder =
          country.effectivePlaceholder;

      if (placeholder.trim().isNotEmpty) {
        return placeholder;
      }
    }

    if (widget.formatPhoneNumber &&
        effectivePhoneFormatGroups.isNotEmpty) {
      return effectivePhoneFormatGroups
          .map(
            (int group) => 'x' * group,
          )
          .join(' ');
    }

    return 'Numéro de téléphone';
  }

  // ===========================================================================
  // BUILD
  // ===========================================================================

  @override
  Widget build(BuildContext context) {
    return UniversalGlassPhoneInputView(
      state: this,
    );
  }

  // ===========================================================================
  // INITIALISATION
  // ===========================================================================

  @override
  void initState() {
    super.initState();

    internalController =
        TextEditingController();

    internalFocusNode =
        FocusNode();

    // Le FocusNode effectif peut être celui fourni par le parent.
    focusNode.addListener(
      handleFocusChanged,
    );

    hasFocus =
        focusNode.hasFocus;

    registryFuture =
        PhoneCountryRegistry.load();

    initializeCountry();

    formatInitialValue();

    if (widget.autofocus) {
      WidgetsBinding.instance
          .addPostFrameCallback((_) {
        if (!mounted) {
          return;
        }

        if (widget.enabled &&
            !widget.readOnly) {
          focusNode.requestFocus();
        }
      });
    }
  }

  // ===========================================================================
  // INITIALISATION DU PAYS
  // ===========================================================================

  Future<void> initializeCountry() async {
    if (_countryInitializationStarted) {
      return;
    }

    if (widget.country != null) {
      return;
    }

    _countryInitializationStarted = true;

    try {
      final PhoneCountryRegistry registry =
          await registryFuture;

      final PhoneCountry? country =
          registry.findByIsoCode(
        widget.initialCountryIsoCode,
      );

      final PhoneCountry? selectedCountry =
          country ?? registry.first();

      if (selectedCountry == null) {
        return;
      }

      if (!mounted) {
        return;
      }

      setState(() {
        internalCountry =
            selectedCountry;

        errorText = null;
      });

      formatInitialValue();
    } catch (error, stackTrace) {
      debugPrint(
        'UniversalGlassPhoneInput: '
        'erreur chargement pays => $error',
      );

      debugPrintStack(
        stackTrace: stackTrace,
      );
    }
  }

  // ===========================================================================
  // DID UPDATE WIDGET
  // ===========================================================================

  @override
  void didUpdateWidget(
    covariant UniversalGlassPhoneInput oldWidget,
  ) {
    super.didUpdateWidget(oldWidget);

    // -------------------------------------------------------------------------
    // FOCUS NODE
    // -------------------------------------------------------------------------

    if (oldWidget.focusNode !=
        widget.focusNode) {
      final FocusNode oldNode =
          oldWidget.focusNode ??
              internalFocusNode;

      oldNode.removeListener(
        handleFocusChanged,
      );

      final FocusNode newNode =
          focusNode;

      newNode.addListener(
        handleFocusChanged,
      );

      hasFocus =
          newNode.hasFocus;
    }

    // -------------------------------------------------------------------------
    // CONTRÔLEUR
    // -------------------------------------------------------------------------

    if (oldWidget.controller !=
        widget.controller) {
      formatInitialValue();
    }

    // -------------------------------------------------------------------------
    // PAYS
    // -------------------------------------------------------------------------

    if (oldWidget.country !=
        widget.country) {
      errorText = null;

      formatInitialValue();
    }

    // -------------------------------------------------------------------------
    // PAYS INITIAL
    // -------------------------------------------------------------------------

    if (oldWidget.initialCountryIsoCode !=
        widget.initialCountryIsoCode) {
      if (widget.country == null) {
        _countryInitializationStarted =
            false;

        initializeCountry();
      }
    }

    // -------------------------------------------------------------------------
    // FORMATAGE
    // -------------------------------------------------------------------------

    final bool formatChanged =
        oldWidget.maxPhoneDigits !=
                widget.maxPhoneDigits ||
        !_listEquals(
          oldWidget.phoneFormatGroups,
          widget.phoneFormatGroups,
        ) ||
        oldWidget.formatPhoneNumber !=
            widget.formatPhoneNumber;

    if (formatChanged) {
      formatInitialValue();
    }
  }

  // ===========================================================================
  // COMPARAISON DE LISTES
  // ===========================================================================

  bool _listEquals(
    List<int> a,
    List<int> b,
  ) {
    if (identical(a, b)) {
      return true;
    }

    if (a.length != b.length) {
      return false;
    }

    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) {
        return false;
      }
    }

    return true;
  }

  // ===========================================================================
  // FOCUS
  // ===========================================================================

  void handleFocusChanged() {
    if (!mounted) {
      return;
    }

    final bool focused =
        focusNode.hasFocus;

    // IMPORTANT :
    //
    // Aucun setState() ici.
    //
    // Le TextFormField doit rester stable lorsque le focus change.
    // Un setState() sur UniversalGlassPhoneInputState provoquerait
    // la reconstruction de UniversalGlassPhoneInputView et pourrait
    // perturber le hit-test ainsi que la position du curseur.
    //
    // Le rendu dépendant du focus est maintenant géré par
    // _PhoneInputFocusBuilder dans UniversalGlassPhoneInputView.

    hasFocus = focused;

    // Validation uniquement lors de la perte du focus.
    if (!focused &&
        widget.autovalidateMode ==
            AutovalidateMode.onUnfocus) {
      validate(controller.text);
    }
  }

  // ===========================================================================
  // FORMATAGE INITIAL
  // ===========================================================================

  void formatInitialValue() {
    final String currentText =
        controller.text;

    if (currentText.isEmpty) {
      return;
    }

    int cursorOffset =
        controller.selection.baseOffset;

    if (cursorOffset < 0) {
      cursorOffset =
          currentText.length;
    }

    cursorOffset = cursorOffset.clamp(
      0,
      currentText.length,
    );

    final int digitsBeforeCursor =
        GlassTextFormatter
            .countDigitsBeforeCursor(
      currentText,
      cursorOffset,
    );

    final String formatted =
        GlassTextFormatter.formatPhone(
      currentText,
      groups:
          effectivePhoneFormatGroups,
      maxDigits:
          effectiveMaxPhoneDigits,
      enabled:
          widget.formatPhoneNumber,
    );

    if (currentText == formatted) {
      return;
    }

    final int newCursorPosition =
        GlassTextFormatter
            .calculateCursorPosition(
      formatted: formatted,
      digitCountBeforeCursor:
          digitsBeforeCursor,
    );

    controller.value =
        TextEditingValue(
      text: formatted,
      selection:
          TextSelection.collapsed(
        offset:
            newCursorPosition.clamp(
          0,
          formatted.length,
        ),
      ),
      composing:
          TextRange.empty,
    );
  }

  // ===========================================================================
  // NORMALISATION
  // ===========================================================================

  String normalizePhoneNumber(
    String value,
  ) {
    return GlassTextFormatter
        .clearPhoneString(
      value,
      maxDigits:
          effectiveMaxPhoneDigits,
    );
  }

  // ===========================================================================
  // CHANGEMENT TEXTE
  // ===========================================================================

  void handleChanged(
    String value,
  ) {
    final String normalized =
        normalizePhoneNumber(value);

    final bool shouldValidate =
        widget.autovalidateMode ==
                AutovalidateMode.always ||
        widget.autovalidateMode ==
            AutovalidateMode.onUserInteraction ||
        errorText != null;

    if (shouldValidate) {
      validate(normalized);
    }

    widget.onChanged?.call(
      normalized,
    );

    // IMPORTANT :
    //
    // Aucun setState() à chaque frappe.
    //
    // Cela permet de conserver stables :
    //
    // - EditableText
    // - sélection
    // - curseur
    // - FocusNode
    // - composing range
    //
    // Le parent peut recevoir onChanged sans que ce State
    // reconstruise inutilement le champ.
  }

  // ===========================================================================
  // SUBMIT
  // ===========================================================================

  void handleSubmitted(
    String value,
  ) {
    final String normalized =
        normalizePhoneNumber(value);

    validate(normalized);

    widget.onSubmitted?.call(
      normalized,
    );
  }

  // ===========================================================================
  // VALIDATION
  // ===========================================================================

  void validate(
    String? value,
  ) {
    final String? Function(String?)?
        validator =
        widget.validator;

    if (validator == null) {
      return;
    }

    final String? newError =
        validator(value);

    if (!mounted ||
        errorText == newError) {
      return;
    }

    setState(() {
      errorText = newError;
    });
  }

  // ===========================================================================
  // SÉLECTION DU PAYS
  // ===========================================================================

  void selectCountry(
    PhoneCountry country,
  ) {
    if (!mounted) {
      return;
    }

    setState(() {
      if (widget.country == null) {
        internalCountry = country;
      }

      errorText = null;
    });

    controller.clear();

    widget.onCountryChanged?.call(
      country,
    );
  }

  // ===========================================================================
  // SUFFIX
  // ===========================================================================

  void handleSuffixTap() {
    if (!widget.enabled ||
        widget.readOnly ||
        widget.onSuffixTap == null) {
      return;
    }

    widget.onSuffixTap!();
  }

  // ===========================================================================
  // FORMATTERS
  // ===========================================================================

  List<TextInputFormatter>
      get inputFormatters {
    if (widget.formatPhoneNumber) {
      return <TextInputFormatter>[
        GlassTextFormatter.phoneFormatter(
          groups:
              effectivePhoneFormatGroups,
          maxDigits:
              effectiveMaxPhoneDigits,
        ),
      ];
    }

    return <TextInputFormatter>[
      FilteringTextInputFormatter
          .digitsOnly,
      LengthLimitingTextInputFormatter(
        effectiveMaxPhoneDigits,
      ),
    ];
  }

  // ===========================================================================
  // DISPOSE
  // ===========================================================================

  @override
  void dispose() {
    // Retire le listener du FocusNode effectif.
    //
    // On ne dispose PAS le FocusNode fourni par le parent.
    // Seul internalFocusNode nous appartient.
    focusNode.removeListener(
      handleFocusChanged,
    );

    internalController.dispose();

    internalFocusNode.dispose();

    super.dispose();
  }
}