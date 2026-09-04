
// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:universal_glass/components/inputs/fieldoutlined/outlined_field_decoration.dart';

import 'package:universal_glass/components/surface/glass_notch_shadow_wrapper.dart';
import 'package:universal_glass/components/surface/glass_surface_container.dart';
import 'package:universal_glass/phone/phone_country.dart';
import 'package:universal_glass/phone/phone_country_picker.dart';
import 'package:universal_glass/phone/phone_country_registry.dart';
import 'package:universal_glass/utils/glass_input_utils.dart';
import 'package:universal_glass/utils/glass_layout_calibrator.dart';
import 'package:universal_glass/utils/glass_palettes.dart';
import 'package:universal_glass/utils/glass_theme_extension.dart';

import '../../enums/glass_enums.dart';
import '../../theme/glass_color_palette.dart';
import 'glass_input_decoration.dart';

class UniversalGlassPhoneInput extends ConsumerStatefulWidget {
  // ===========================================================================
  // DONNÉES
  // ===========================================================================

  final TextEditingController? controller;
  final FocusNode? focusNode;

  final PhoneCountry? country;
  final List<PhoneCountry>? countries;

  final String initialCountryIsoCode;

  // ===========================================================================
  // PAYS
  // ===========================================================================

  final bool countryPickerEnabled;
  final void Function(PhoneCountry country)? onCountryChanged;
  final void Function(PhoneCountry country)? onCountryTap;

  final String countryPickerTitle;
  final String countryPickerSubtitle;

  // ===========================================================================
  // TEXTE
  // ===========================================================================

  final String label;
  final String? hintText;

  final int maxPhoneDigits;
  final List<int> phoneFormatGroups;
  final bool formatPhoneNumber;

  // ===========================================================================
  // ICÔNES
  // ===========================================================================

  final IconData? suffixIcon;
  final VoidCallback? onSuffixTap;

  // ===========================================================================
  // ÉTAT
  // ===========================================================================

  final bool enabled;
  final bool readOnly;
  final bool autofocus;

  // ===========================================================================
  // VALIDATION
  // ===========================================================================

  final String? Function(String?)? validator;
  final AutovalidateMode autovalidateMode;

  // ===========================================================================
  // CALLBACKS
  // ===========================================================================

  final void Function(String)? onChanged;
  final VoidCallback? onTap;
  final void Function(String)? onSubmitted;

  // ===========================================================================
  // CLAVIER
  // ===========================================================================

  final TextInputAction textInputAction;

  // ===========================================================================
  // APPARENCE
  // ===========================================================================

  final double? width;
  final double fieldHeight;

  final GlassInputDecoration decoration;
  final GlassStyle style;
  final GlassShapeType shape;

  /// Conservé dans l'API publique pour compatibilité.
  final GlassColorPalette palette;

  const UniversalGlassPhoneInput({
    super.key,
    this.controller,
    this.focusNode,
    this.country,
    this.countries,
    this.initialCountryIsoCode = 'BF',
    this.countryPickerEnabled = true,
    this.onCountryChanged,
    this.onCountryTap,
    this.countryPickerTitle = 'Changer de pays',
    this.countryPickerSubtitle = 'Sélectionnez votre indicatif',
    this.label = 'Numéro de téléphone',
    this.hintText,
    this.maxPhoneDigits = 8,
    this.phoneFormatGroups = const <int>[2, 2, 2, 2],
    this.formatPhoneNumber = true,
    this.suffixIcon,
    this.onSuffixTap,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.validator,
    this.autovalidateMode = AutovalidateMode.disabled,
    this.onChanged,
    this.onTap,
    this.onSubmitted,
    this.textInputAction = TextInputAction.next,
    this.width,
    this.fieldHeight = 55,
    this.decoration = const GlassInputDecoration(),
    this.style = GlassStyle.transparentAqua,
    this.shape = GlassShapeType.squareRounded,
    this.palette = GlassPalettes.aqua,
  });

  @override
  ConsumerState<UniversalGlassPhoneInput> createState() =>
      _UniversalGlassPhoneInputState();
}

// =============================================================================
// STATE
// =============================================================================

class _UniversalGlassPhoneInputState
    extends ConsumerState<UniversalGlassPhoneInput> {
  // ===========================================================================
  // CONTRÔLEURS
  // ===========================================================================

  late final TextEditingController _internalController;
  late final FocusNode _internalFocusNode;

  late final Future<PhoneCountryRegistry> _registryFuture;

  // ===========================================================================
  // ÉTAT
  // ===========================================================================

  PhoneCountry? _internalCountry;

  bool _hasFocus = false;

  String? _errorText;

  // ===========================================================================
  // GETTERS
  // ===========================================================================

  TextEditingController get _controller =>
      widget.controller ?? _internalController;

  FocusNode get _focusNode =>
      widget.focusNode ?? _internalFocusNode;

  PhoneCountry? get _effectiveCountry =>
      widget.country ?? _internalCountry;

  String get _effectiveCountryCode =>
      _effectiveCountry?.dialCode ?? '';

  String get _effectiveCountryFlag =>
      _effectiveCountry?.flag ?? '🌐';

  String? get _effectiveFlagAsset {
    final PhoneCountry? country = _effectiveCountry;

    if (country == null) {
      return null;
    }

    final String? asset = country.effectiveFlagAsset;

    if (asset == null || asset.trim().isEmpty) {
      return null;
    }

    return asset;
  }

  int get _effectiveMaxPhoneDigits {
    final PhoneCountry? country = _effectiveCountry;

    if (country != null && country.nationalDigits.isNotEmpty) {
      return country.nationalDigits.reduce(
        (int a, int b) => a > b ? a : b,
      );
    }

    return widget.maxPhoneDigits;
  }

  List<int> get _effectivePhoneFormatGroups {
    final PhoneCountry? country = _effectiveCountry;

    if (country != null && country.formatGroups.isNotEmpty) {
      return country.formatGroups;
    }

    return widget.phoneFormatGroups;
  }

  String get _effectiveHintText {
    final String? explicit = widget.hintText;

    if (explicit != null && explicit.trim().isNotEmpty) {
      return explicit;
    }

    final PhoneCountry? country = _effectiveCountry;

    if (country != null) {
      final String placeholder = country.effectivePlaceholder;

      if (placeholder.trim().isNotEmpty) {
        return placeholder;
      }
    }

    if (widget.formatPhoneNumber &&
        _effectivePhoneFormatGroups.isNotEmpty) {
      return _effectivePhoneFormatGroups
          .map((int group) => 'x' * group)
          .join(' ');
    }

    return 'Numéro de téléphone';
  }

  // ===========================================================================
  // INIT
  // ===========================================================================

  @override
  void initState() {
    super.initState();

    _internalController = TextEditingController();
    _internalFocusNode = FocusNode();

    _focusNode.addListener(_handleFocusChanged);

    _hasFocus = _focusNode.hasFocus;

    _registryFuture = PhoneCountryRegistry.load();

    _initializeCountry();

    _formatInitialValue();

    if (widget.autofocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          return;
        }

        if (widget.enabled && !widget.readOnly) {
          _focusNode.requestFocus();
        }
      });
    }
  }

  // ===========================================================================
  // PAYS
  // ===========================================================================

  Future<void> _initializeCountry() async {
    if (widget.country != null) {
      return;
    }

    try {
      final PhoneCountryRegistry registry = await _registryFuture;

      final PhoneCountry? country =
          registry.findByIsoCode(widget.initialCountryIsoCode);

      if (!mounted) {
        return;
      }

      setState(() {
        _internalCountry = country ?? registry.first();
      });

      _formatInitialValue();
    } catch (error) {
      debugPrint(
        'UniversalGlassPhoneInput: erreur chargement pays => $error',
      );
    }
  }

  // ===========================================================================
  // UPDATE WIDGET
  // ===========================================================================

  @override
  void didUpdateWidget(
    covariant UniversalGlassPhoneInput oldWidget,
  ) {
    super.didUpdateWidget(oldWidget);

    // -------------------------------------------------------------------------
    // FocusNode
    // -------------------------------------------------------------------------

    if (oldWidget.focusNode != widget.focusNode) {
      final FocusNode oldNode =
          oldWidget.focusNode ?? _internalFocusNode;

      oldNode.removeListener(_handleFocusChanged);

      _focusNode.addListener(_handleFocusChanged);

      _hasFocus = _focusNode.hasFocus;
    }

    // -------------------------------------------------------------------------
    // Controller
    // -------------------------------------------------------------------------

    if (oldWidget.controller != widget.controller) {
      _formatInitialValue();
    }

    // -------------------------------------------------------------------------
    // Pays
    // -------------------------------------------------------------------------

    if (oldWidget.country != widget.country) {
      _errorText = null;
      _formatInitialValue();
    }

    if (oldWidget.initialCountryIsoCode !=
        widget.initialCountryIsoCode) {
      if (widget.country == null) {
        _initializeCountry();
      }
    }

    // -------------------------------------------------------------------------
    // Formatage
    // -------------------------------------------------------------------------

    if (oldWidget.maxPhoneDigits != widget.maxPhoneDigits ||
        !_listEquals(
          oldWidget.phoneFormatGroups,
          widget.phoneFormatGroups,
        ) ||
        oldWidget.formatPhoneNumber != widget.formatPhoneNumber) {
      _formatInitialValue();
    }
  }

  // ===========================================================================
  // LIST EQUALITY
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

  void _handleFocusChanged() {
    if (!mounted) {
      return;
    }

    final bool focused = _focusNode.hasFocus;

    if (_hasFocus == focused) {
      return;
    }

    setState(() {
      _hasFocus = focused;
    });

    if (!focused &&
        widget.autovalidateMode ==
            AutovalidateMode.onUnfocus) {
      _validate(_controller.text);
    }
  }

  // ===========================================================================
  // FORMATAGE INITIAL
  // ===========================================================================

  void _formatInitialValue() {
    final String current = _controller.text;

    if (current.isEmpty) {
      return;
    }

    final String digits = _normalizePhoneNumber(current);
    final String formatted = _formatPhoneNumber(digits);

    if (_controller.text == formatted) {
      return;
    }

    _controller.value = TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(
        offset: formatted.length,
      ),
    );
  }

  // ===========================================================================
  // NORMALISATION
  // ===========================================================================

  String _normalizePhoneNumber(String value) {
    String digits = value.replaceAll(RegExp(r'\D'), '');

    final int maxDigits = _effectiveMaxPhoneDigits;

    if (maxDigits >= 0 && digits.length > maxDigits) {
      digits = digits.substring(0, maxDigits);
    }

    return digits;
  }

  // ===========================================================================
  // FORMATAGE
  // ===========================================================================

  String _formatPhoneNumber(String digits) {
    if (!widget.formatPhoneNumber || digits.isEmpty) {
      return digits;
    }

    return _formatDigits(
      digits,
      _effectivePhoneFormatGroups,
    );
  }

  String _formatDigits(
    String digits,
    List<int> groups,
  ) {
    if (digits.isEmpty) {
      return '';
    }

    final StringBuffer result = StringBuffer();

    int index = 0;

    for (final int groupSize in groups) {
      if (groupSize <= 0 || index >= digits.length) {
        continue;
      }

      final int end =
          (index + groupSize)
              .clamp(0, digits.length)
              .toInt();

      if (result.isNotEmpty) {
        result.write(' ');
      }

      result.write(
        digits.substring(index, end),
      );

      index = end;
    }

    if (index < digits.length) {
      if (result.isNotEmpty) {
        result.write(' ');
      }

      result.write(
        digits.substring(index),
      );
    }

    return result.toString();
  }

  // ===========================================================================
  // CHANGEMENT TEXTE
  // ===========================================================================

  void _handleChanged(String value) {
    final String normalized =
        _normalizePhoneNumber(value);

    if (widget.autovalidateMode ==
            AutovalidateMode.always ||
        widget.autovalidateMode ==
            AutovalidateMode.onUserInteraction ||
        _errorText != null) {
      _validate(normalized);
    }

    widget.onChanged?.call(normalized);

    if (mounted) {
      setState(() {});
    }
  }

  // ===========================================================================
  // SUBMIT
  // ===========================================================================

  void _handleSubmitted(String value) {
    final String normalized =
        _normalizePhoneNumber(value);

    _validate(normalized);

    widget.onSubmitted?.call(normalized);
  }

  // ===========================================================================
  // VALIDATION
  // ===========================================================================

  void _validate(String? value) {
    if (widget.validator == null) {
      return;
    }

    final String? error =
        widget.validator!(value);

    if (!mounted || _errorText == error) {
      return;
    }

    setState(() {
      _errorText = error;
    });
  }

  // ===========================================================================
  // COUNTRY PICKER
  // ===========================================================================

  Future<void> _handleCountryTap() async {
    if (!widget.enabled ||
        widget.readOnly ||
        !widget.countryPickerEnabled) {
      return;
    }

    FocusScope.of(context).unfocus();

    final PhoneCountry? currentCountry =
        _effectiveCountry;

    if (widget.onCountryTap != null &&
        currentCountry != null) {
      widget.onCountryTap!(currentCountry);
      return;
    }

    try {
      final PhoneCountryRegistry registry =
          await _registryFuture;

      if (!mounted) {
        return;
      }

      final glassContext =
          ref.watchGlassContext(context);

      final GlassColorPalette palette =
          glassContext.palette;

      final List<PhoneCountry> countriesList =
          widget.countries ?? registry.all();

      final PhoneCountry? selected =
          await PhoneCountryPicker.show(
        context: context,
        countries: countriesList,
        palette: palette,
        selectedCountry: currentCountry,
        title: widget.countryPickerTitle,
        subtitle: widget.countryPickerSubtitle,
      );

      if (selected == null || !mounted) {
        return;
      }

      _selectCountry(selected);
    } catch (error) {
      debugPrint(
        'UniversalGlassPhoneInput: '
        'erreur country picker => $error',
      );
    }
  }

  // ===========================================================================
  // SÉLECTION PAYS
  // ===========================================================================

  void _selectCountry(PhoneCountry country) {
    if (widget.country == null) {
      setState(() {
        _internalCountry = country;
        _errorText = null;
      });
    } else {
      setState(() {
        _errorText = null;
      });
    }

    _controller.clear();

    widget.onCountryChanged?.call(country);
  }

  // ===========================================================================
  // SUFFIX
  // ===========================================================================

  void _handleSuffixTap() {
    if (!widget.enabled ||
        widget.readOnly ||
        widget.onSuffixTap == null) {
      return;
    }

    widget.onSuffixTap!();
  }

  // ===========================================================================
  // DISPOSE
  // ===========================================================================

  @override
  void dispose() {
    _focusNode.removeListener(
      _handleFocusChanged,
    );

    _internalController.dispose();
    _internalFocusNode.dispose();

    super.dispose();
  }

  // ===========================================================================
// BUILD
// ===========================================================================

@override
Widget build(BuildContext context) {
  final glass = ref.watchGlassContext(context);

  final bool hasError =
      _errorText != null && _errorText!.trim().isNotEmpty;

  final GlassInputDecoration effectiveDecoration = glass.inputDecoration(
    hasError: hasError,
    isFocused: _focusNode.hasFocus,
  );

  final bool useAqua = glass.theme.useAquaStyle;

  final Color focusColor = useAqua
      ? Colors.cyanAccent
      : Colors.orangeAccent;

  // =========================================================================
  // 1. CALIBRATION
  // =========================================================================

  final GlassLayoutCalibrator geo = GlassLayoutCalibrator(
    fieldHeight: widget.fieldHeight,
    fontSize: effectiveDecoration.fontSize,
    hasPrefixIcon: true,
  );

  final bool hasText = _controller.text.isNotEmpty;

  final bool isFloating =
      _focusNode.hasFocus || hasText;

  // =========================================================================
  // 2. FORMATTERS
  // =========================================================================

  final List<TextInputFormatter> inputFormatters =
      <TextInputFormatter>[
    if (widget.formatPhoneNumber)
      _GlassPhoneInputFormatter(
        maxDigits: _effectiveMaxPhoneDigits,
        groups: _effectivePhoneFormatGroups,
      ),

    if (!widget.formatPhoneNumber)
      FilteringTextInputFormatter.digitsOnly,
  ];

  // =========================================================================
  // 3. COUNTRY SELECTOR
  // =========================================================================

  final Widget countrySelector = _buildCountrySelector(
    decoration: effectiveDecoration,
    contentColor: _focusNode.hasFocus
        ? focusColor
        : effectiveDecoration.textColor,
    iconColor: _focusNode.hasFocus
        ? focusColor
        : effectiveDecoration.iconColor,
    hasError: hasError,
    palette: glass.palette,
    focusColor: focusColor,
  );

  // =========================================================================
  // 4. TEXT FIELD
  // =========================================================================
  //
  // IMPORTANT :
  //
  // Le TextFormField reste entièrement responsable :
  //   - du focus ;
  //   - du tap ;
  //   - de la position du curseur ;
  //   - de la sélection du texte.
  //
  // Aucun requestFocus() ici.
  // Aucun GestureDetector autour du champ.
  // Aucun onTap du GlassSurfaceContainer.
  //
  // Le ClipPath du notch ne doit plus entourer ce widget.
  // =========================================================================

  final Widget phoneTextField = TextFormField(
    controller: _controller,
    focusNode: _focusNode,

    showCursor: true,

    enabled: widget.enabled,
    readOnly: widget.readOnly,

    keyboardType: TextInputType.phone,
    textInputAction: widget.textInputAction,

    textAlignVertical: TextAlignVertical.center,

    inputFormatters: inputFormatters,

    style: TextStyle(
      color: widget.enabled
          ? Colors.white
          : Colors.white.withValues(alpha: 0.35),
      fontSize: effectiveDecoration.fontSize,
      fontWeight: effectiveDecoration.fontWeight,
    ),

    cursorColor: focusColor,

    // IMPORTANT :
    // On transmet uniquement le callback utilisateur.
    //
    // On NE fait PAS :
    // _focusNode.requestFocus()
    //
    // Flutter conserve ainsi son comportement natif de placement
    // du curseur au point exact du clic.
    onTap: widget.onTap,

    onChanged: _handleChanged,

    onFieldSubmitted: _handleSubmitted,

    decoration: InputDecoration(
      isDense: true,

      hintText: _effectiveHintText,

      hintStyle: TextStyle(
        color: Colors.white.withValues(alpha: 0.35),
        fontSize: geo.hintFontSize,
      ),

      errorText: null,

      // Aucun padding vertical ici.
      //
      // Le déplacement vertical visuel est centralisé dans
      // GlassLayoutCalibrator.
      contentPadding: EdgeInsets.zero,

      // ---------------------------------------------------------------------
      // SUFFIX
      // ---------------------------------------------------------------------

      suffixIcon:
          widget.suffixIcon != null &&
                  _controller.text.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(
                    left: 6,
                    right: 2,
                  ),
                  child: context.buildInputIcon(
                    icon: widget.suffixIcon!,
                    isActive: _focusNode.hasFocus,
                    enabled: widget.enabled,
                    onTap: widget.onSuffixTap != null
                        ? _handleSuffixTap
                        : null,
                    color: hasError
                        ? effectiveDecoration.errorColor
                        : effectiveDecoration.iconColor,
                    fieldHeight: widget.fieldHeight,
                    bubbleRatio: 0.6,
                    onlyIcon: true,
                  ),
                )
              : null,

      suffixIconConstraints: const BoxConstraints(
        minWidth: 0,
        minHeight: 0,
      ),

      border: InputBorder.none,
      enabledBorder: InputBorder.none,
      focusedBorder: InputBorder.none,
    ),
  );

  // =========================================================================
  // 5. CONTENU DE LA SURFACE
  // =========================================================================
  //
  // Structure :
  //
  //   [ BUBBLE ]  +226  [ TEXTE / HINT ............ ] [SUFFIX]
  //
  // La Row est alignée à gauche.
  // CrossAxisAlignment.center assure le centrage vertical.
  // =========================================================================

  final Widget centeredContent = Row(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      countrySelector,

      const SizedBox(width: 12),

      Expanded(
        child: geo.translateTextVertically(
          phoneTextField,
        ),
      ),
    ],
  );

  // =========================================================================
  // 6. NOTCH
  // =========================================================================

  final NotchClipper? notchClipper = isFloating
      ? NotchClipper(
          notchStart: geo.notchStart,
          notchWidth: geo.getLabelWidth(
            widget.label,
          ),
        )
      : null;

  // =========================================================================
  // 7. SURFACE
  // =========================================================================
  //
  // IMPORTANT :
  //
  // GlassSurfaceContainer :
  //   - ne capture PAS le tap ;
  //   - ne possède PAS de ClipPath du notch ;
  //   - n'a PAS son ombre rectangulaire ;
  //
  // GlassNotchShadowWrapper :
  //   - dessine uniquement l'ombre du notch ;
  //   - utilise IgnorePointer pour la couche graphique ;
  //   - laisse le child interactif intact.
  // =========================================================================

  final Widget glassField = GlassNotchShadowWrapper(
    clipper: notchClipper,

    isShadowEnabled:
        isFloating &&
        glass.theme.enableShadow,

    shadowOpacity:
        glass.theme.shadowOpacity,

    elevation: 6.0,

    borderRadius: BorderRadius.circular(
      effectiveDecoration.borderRadius,
    ),

    child: GlassSurfaceContainer(
      decoration: effectiveDecoration,

      style: glass.effectiveGlassStyle,

      shape: widget.shape,

      width: widget.width,

      height: widget.fieldHeight,

      borderRadius: BorderRadius.circular(
        effectiveDecoration.borderRadius,
      ),

      // IMPORTANT :
      // Le TextFormField doit recevoir directement les événements tactiles.
      onTap: null,

      padding: const EdgeInsets.symmetric(
        horizontal: 14,
      ),

      liftOnHover:
          !_focusNode.hasFocus,

      // L'ombre du rectangle est désactivée.
      //
      // Seule l'ombre spécifique du notch reste active.
      disableShadow: true,

      // Aucun clipping du contenu interactif.
      clipBehavior: Clip.none,

      child: centeredContent,
    ),
  );

  // =========================================================================
  // 8. RENDU FINAL
  // =========================================================================

  return Opacity(
    opacity: widget.enabled ? 1.0 : 0.65,

    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,

      children: [
        Stack(
          clipBehavior: Clip.none,

          children: [
            glassField,

            // ===============================================================
            // LABEL FLOTTANT
            // ===============================================================

            AnimatedPositioned(
              duration: const Duration(
                milliseconds: 180,
              ),

              curve: Curves.easeInOutQuad,

              top: isFloating
                  ? -8.5
                  : geo.labelTopAtRest,

              left: geo.getLabelLeft(
                isFloating,
              ),

              child: IgnorePointer(
                child: AnimatedOpacity(
                  duration: const Duration(
                    milliseconds: 140,
                  ),

                  opacity:
                      isFloating ? 1.0 : 0.0,

                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(
                      milliseconds: 180,
                    ),

                    style: TextStyle(
                      color: hasError
                          ? effectiveDecoration.errorColor
                          : _focusNode.hasFocus
                              ? focusColor
                              : Colors.white.withValues(
                                  alpha: widget.enabled
                                      ? (isFloating
                                          ? 0.6
                                          : 0.4)
                                      : 0.20,
                                ),

                      fontSize: isFloating
                          ? 10.5
                          : (geo.isVeryCompact
                              ? 14
                              : effectiveDecoration.fontSize),

                      fontWeight: isFloating
                          ? FontWeight.w700
                          : FontWeight.w500,

                      letterSpacing: 0.2,

                      backgroundColor:
                          Colors.transparent,
                    ),

                    child: Text(
                      widget.label,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),

        // ===================================================================
        // ERREUR
        // ===================================================================

        if (hasError && widget.enabled)
          Padding(
            padding: const EdgeInsets.only(
              top: 6,
              left: 14,
            ),

            child: Text(
              _errorText!,

              style: TextStyle(
                color: effectiveDecoration.errorColor,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    ),
  );
}

  // ===========================================================================
  // COUNTRY SELECTOR
  // ===========================================================================

  Widget _buildCountrySelector({
    required GlassInputDecoration decoration,
    required Color contentColor,
    required Color iconColor,
    required bool hasError,
    required GlassColorPalette palette,
    required Color focusColor,
  }) {
    final bool canOpen =
        widget.enabled &&
        !widget.readOnly &&
        widget.countryPickerEnabled;

    final Color finalTextColor =
        !widget.enabled
            ? contentColor.withValues(
                alpha: 0.40,
              )
            : _hasFocus
                ? focusColor
                : contentColor;

    final Color separatorColor =
        !widget.enabled
            ? palette.border.withValues(
                alpha: 0.2,
              )
            : _hasFocus
                ? focusColor.withValues(
                    alpha: 0.4,
                  )
                : palette.border.withValues(
                    alpha: 0.3,
                  );

    final double currentBubbleSize =
        GlassInputUtils.bubbleSize(
      fieldHeight: widget.fieldHeight,
      ratio: 0.6,
    );

    // -------------------------------------------------------------------------
    // DRAPEAU
    // -------------------------------------------------------------------------

    final Widget bubble =
        context.buildInputBubbleWithChild(
      child: _buildCountryFlag(
        size: GlassInputUtils.iconSize(
          bubbleSize: currentBubbleSize,
        ),
      ),

      isActive: _hasFocus,

      enabled: canOpen,

      onTap:
          canOpen
              ? _handleCountryTap
              : null,

      fieldHeight:
          widget.fieldHeight,

      bubbleRatio: 0.6,

      hasError: hasError,
    );

    // -------------------------------------------------------------------------
    // INDICATIF
    // -------------------------------------------------------------------------

    final Widget countryCode =
        Text(
      _effectiveCountryCode,

      style: TextStyle(
        color: finalTextColor,
        fontSize:
            decoration.fontSize - 1,
        fontWeight:
            FontWeight.w700,
      ),
    );

    // -------------------------------------------------------------------------
    // CHEVRON
    // -------------------------------------------------------------------------

    final Widget chevron =
        context.buildInputIcon(
      icon:
          Icons.keyboard_arrow_down_rounded,

      isActive: _hasFocus,

      enabled: canOpen,

      onTap:
          canOpen
              ? _handleCountryTap
              : null,

      fieldHeight:
          widget.fieldHeight,

      bubbleRatio: 0.5,

      showGlow: false,

      onlyIcon: true,
    );

    // -------------------------------------------------------------------------
    // ROW
    // -------------------------------------------------------------------------

    return Row(
      mainAxisSize:
          MainAxisSize.min,

      crossAxisAlignment:
          CrossAxisAlignment.center,

      children: [
        bubble,

        const SizedBox(
          width: 8,
        ),

        MouseRegion(
          cursor: canOpen
              ? SystemMouseCursors.click
              : SystemMouseCursors.basic,

          child: GestureDetector(
            behavior:
                HitTestBehavior.opaque,

            onTap:
                canOpen
                    ? _handleCountryTap
                    : null,

            child: Row(
              mainAxisSize:
                  MainAxisSize.min,

              crossAxisAlignment:
                  CrossAxisAlignment.center,

              children: [
                countryCode,

                const SizedBox(
                  width: 8,
                ),

                Container(
                  width: 1,

                  height:
                      GlassInputUtils
                          .separatorHeight(
                    currentBubbleSize,
                  ),

                  color:
                      separatorColor,
                ),

                const SizedBox(
                  width: 4,
                ),

                chevron,
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // DRAPEAU
  // ===========================================================================

  Widget _buildCountryFlag({
    double size = 22,
  }) {
    final String? asset =
        _effectiveFlagAsset;

    if (asset != null &&
        asset.trim().isNotEmpty) {
      return ClipRRect(
        borderRadius:
            BorderRadius.circular(4),

        child: Image.asset(
          asset,

          package:
              'universal_glass',

          width: size,

          height:
              size * 0.60,

          fit: BoxFit.cover,

          cacheWidth:
              (size * 2.4).toInt(),

          errorBuilder: (
            BuildContext context,
            Object error,
            StackTrace? stackTrace,
          ) {
            debugPrint(
              'UniversalGlassPhoneInput: '
              'impossible de charger le '
              'drapeau "$asset" : $error',
            );

            return _buildFallbackFlag(
              size: size,
            );
          },
        ),
      );
    }

    return _buildFallbackFlag(
      size: size,
    );
  }

  // ===========================================================================
  // DRAPEAU FALLBACK
  // ===========================================================================

  Widget _buildFallbackFlag({
    double size = 22,
  }) {
    final glass =
        ref.watchGlassContext(context);

    return Text(
      _effectiveCountryFlag,

      textAlign: TextAlign.center,

      style: TextStyle(
        color: glass.palette.white,
        fontSize: size,
        height: 1.0,
      ),
    );
  }
}

// =============================================================================
// PHONE INPUT FORMATTER
// =============================================================================

class _GlassPhoneInputFormatter
    extends TextInputFormatter {
  final int maxDigits;
  final List<int> groups;

  const _GlassPhoneInputFormatter({
    required this.maxDigits,
    required this.groups,
  });

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // -------------------------------------------------------------------------
    // Position du curseur demandée par Flutter.
    // -------------------------------------------------------------------------

    int cursorOffset =
        newValue.selection.isValid
            ? newValue.selection.baseOffset
            : newValue.text.length;

    cursorOffset = cursorOffset
        .clamp(
          0,
          newValue.text.length,
        )
        .toInt();

    // -------------------------------------------------------------------------
    // Nombre de chiffres avant le curseur.
    //
    // C'est la clé pour conserver le curseur au bon endroit
    // lorsque les espaces sont ajoutés.
    // -------------------------------------------------------------------------

    final String beforeCursor =
        newValue.text.substring(
      0,
      cursorOffset,
    );

    int digitsBeforeCursor =
        _countDigits(beforeCursor);

    // -------------------------------------------------------------------------
    // Extraction des chiffres.
    // -------------------------------------------------------------------------

    String digits =
        newValue.text.replaceAll(
      RegExp(r'\D'),
      '',
    );

    // -------------------------------------------------------------------------
    // Limite.
    // -------------------------------------------------------------------------

    if (maxDigits >= 0 &&
        digits.length > maxDigits) {
      digits =
          digits.substring(0, maxDigits);
    }

    digitsBeforeCursor =
        digitsBeforeCursor
            .clamp(0, digits.length)
            .toInt();

    // -------------------------------------------------------------------------
    // Nouveau texte formaté.
    // -------------------------------------------------------------------------

    final String formatted =
        _format(digits);

    // -------------------------------------------------------------------------
    // Nouveau curseur.
    // -------------------------------------------------------------------------

    final int cursorPosition =
        _calculateCursorPosition(
      formatted: formatted,
      digitCountBeforeCursor:
          digitsBeforeCursor,
    );

    return TextEditingValue(
      text: formatted,

      selection:
          TextSelection.collapsed(
        offset: cursorPosition,
      ),

      composing:
          TextRange.empty,
    );
  }

  // ===========================================================================
  // COMPTER LES CHIFFRES
  // ===========================================================================

  int _countDigits(String value) {
    int count = 0;

    for (int i = 0;
        i < value.length;
        i++) {
      if (_isDigit(value[i])) {
        count++;
      }
    }

    return count;
  }

  // ===========================================================================
  // FORMATAGE
  // ===========================================================================

  String _format(String digits) {
    if (digits.isEmpty) {
      return '';
    }

    final StringBuffer result =
        StringBuffer();

    int index = 0;

    for (final int groupSize in groups) {
      if (groupSize <= 0 ||
          index >= digits.length) {
        continue;
      }

      final int end =
          (index + groupSize)
              .clamp(
                0,
                digits.length,
              )
              .toInt();

      if (result.isNotEmpty) {
        result.write(' ');
      }

      result.write(
        digits.substring(
          index,
          end,
        ),
      );

      index = end;
    }

    if (index < digits.length) {
      if (result.isNotEmpty) {
        result.write(' ');
      }

      result.write(
        digits.substring(index),
      );
    }

    return result.toString();
  }

  // ===========================================================================
  // POSITION DU CURSEUR
  // ===========================================================================

  int _calculateCursorPosition({
    required String formatted,
    required int digitCountBeforeCursor,
  }) {
    if (digitCountBeforeCursor <= 0) {
      return 0;
    }

    int foundDigits = 0;

    for (int i = 0;
        i < formatted.length;
        i++) {
      if (_isDigit(formatted[i])) {
        foundDigits++;

        if (foundDigits >=
            digitCountBeforeCursor) {
          return i + 1;
        }
      }
    }

    return formatted.length;
  }

  // ===========================================================================
  // DIGIT
  // ===========================================================================

  bool _isDigit(String character) {
    return RegExp(
      r'^[0-9]$',
    ).hasMatch(character);
  }
}
