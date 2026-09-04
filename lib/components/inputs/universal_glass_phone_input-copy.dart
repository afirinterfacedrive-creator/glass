// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // <-- AJOUTE
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
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final PhoneCountry? country;
  final List<PhoneCountry>? countries;
  final String initialCountryIsoCode;
  final bool countryPickerEnabled;
  final void Function(PhoneCountry country)? onCountryChanged;
  final void Function(PhoneCountry country)? onCountryTap;
  final String countryPickerTitle;
  final String countryPickerSubtitle;
  final String label; // <-- NOUVEAU : Déclaration du label
  final String? hintText;
  final int maxPhoneDigits;
  final List<int> phoneFormatGroups;
  final bool formatPhoneNumber;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixTap;
  final bool enabled;
  final bool readOnly;
  final bool autofocus;
  final String? Function(String?)? validator;
  final AutovalidateMode autovalidateMode;
  final void Function(String)? onChanged;
  final VoidCallback? onTap;
  final void Function(String)? onSubmitted;
  final TextInputAction textInputAction;
  final double? width;
  final double fieldHeight;
  final GlassInputDecoration decoration;
  final GlassStyle style;
  final GlassShapeType shape;
  final GlassColorPalette palette; // Aligné sur ta signature

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
    this.label = 'Numéro de téléphone', // <-- NOUVEAU : Valeur par défaut standard
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
  ConsumerState<UniversalGlassPhoneInput> createState() => _UniversalGlassPhoneInputState();
}

class _UniversalGlassPhoneInputState extends ConsumerState<UniversalGlassPhoneInput> {
  late final TextEditingController _internalController;
  late final FocusNode _internalFocusNode;
  late final Future<PhoneCountryRegistry> _registryFuture;
  PhoneCountry? _internalCountry;
  bool _hasFocus = false;
  String? _errorText;

  TextEditingController get _controller => widget.controller ?? _internalController;
  FocusNode get _focusNode => widget.focusNode ?? _internalFocusNode;
  PhoneCountry? get _effectiveCountry => widget.country ?? _internalCountry;


  String get _effectiveCountryCode => _effectiveCountry?.dialCode?? '';
  String get _effectiveCountryFlag => _effectiveCountry?.flag?? '🌐';
  String? get _effectiveFlagAsset {
    final PhoneCountry? country = _effectiveCountry;
    if (country == null) return null;
    // ignore: unnecessary_nullable_for_final_variable_declarations
    final String? asset = country.effectiveFlagAsset;
    if (asset == null || asset.trim().isEmpty) return null;
    return asset;
  }

  int get _effectiveMaxPhoneDigits {
    final PhoneCountry? country = _effectiveCountry;
    if (country!= null && country.nationalDigits.isNotEmpty) {
      return country.nationalDigits.reduce((int a, int b) => a > b? a : b);
    }
    return widget.maxPhoneDigits;
  }

  List<int> get _effectivePhoneFormatGroups {
    final PhoneCountry? country = _effectiveCountry;
    if (country!= null && country.formatGroups.isNotEmpty) return country.formatGroups;
    return widget.phoneFormatGroups;
  }

  String get _effectiveHintText {
    final String? explicit = widget.hintText;
    if (explicit!= null && explicit.trim().isNotEmpty) return explicit;
    final PhoneCountry? country = _effectiveCountry;
    if (country!= null) {
      final String placeholder = country.effectivePlaceholder;
      if (placeholder.trim().isNotEmpty) return placeholder;
    }
    return 'Numéro de téléphone';
  }

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
        if (!mounted) return;
        if (widget.enabled &&!widget.readOnly) _focusNode.requestFocus();
      });
    }
  }

  Future<void> _initializeCountry() async {
    if (widget.country!= null) return;
    try {
      final PhoneCountryRegistry registry = await _registryFuture;
      final PhoneCountry? country = registry.findByIsoCode(widget.initialCountryIsoCode);
      if (!mounted) return;
      setState(() => _internalCountry = country?? registry.first());
      _formatInitialValue();
    } catch (error) {
      debugPrint('UniversalGlassPhoneInput: erreur chargement pays => $error');
    }
  }

  @override
  void didUpdateWidget(covariant UniversalGlassPhoneInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.focusNode!= widget.focusNode) {
      final FocusNode oldNode = oldWidget.focusNode?? _internalFocusNode;
      oldNode.removeListener(_handleFocusChanged);
      _focusNode.addListener(_handleFocusChanged);
      _hasFocus = _focusNode.hasFocus;
    }
    if (oldWidget.controller!= widget.controller) _formatInitialValue();
    if (oldWidget.country!= widget.country) { _errorText = null; _formatInitialValue(); }
    if (oldWidget.initialCountryIsoCode!= widget.initialCountryIsoCode) {
      if (widget.country == null) _initializeCountry();
    }
    if (oldWidget.maxPhoneDigits!= widget.maxPhoneDigits ||!_listEquals(oldWidget.phoneFormatGroups, widget.phoneFormatGroups) || oldWidget.formatPhoneNumber!= widget.formatPhoneNumber) {
      _formatInitialValue();
    }
  }

  bool _listEquals(List<int> a, List<int> b) {
    if (identical(a, b)) return true;
    if (a.length!= b.length) return false;
    for (int i = 0; i < a.length; i++) { if (a[i]!= b[i]) return false; }
    return true;
  }

  void _handleFocusChanged() {
    if (!mounted) return;
    final bool focused = _focusNode.hasFocus;
    if (_hasFocus == focused) return;
    setState(() => _hasFocus = focused);
    if (!focused && widget.autovalidateMode == AutovalidateMode.onUnfocus) _validate(_controller.text); // <- AJOUT VALIDATE
  }

  void _formatInitialValue() {
    final String current = _controller.text;
    if (current.isEmpty) return;
    final String digits = _normalizePhoneNumber(current);
    final String formatted = _formatPhoneNumber(digits);
    if (_controller.text == formatted) return;
    _controller.value = TextEditingValue(text: formatted, selection: TextSelection.collapsed(offset: formatted.length));
  }

  String _normalizePhoneNumber(String value) {
    String digits = value.replaceAll(RegExp(r'\D'), '');
    final int maxDigits = _effectiveMaxPhoneDigits;
    if (maxDigits >= 0 && digits.length > maxDigits) digits = digits.substring(0, maxDigits);
    return digits;
  }

  String _formatPhoneNumber(String digits) {
    if (!widget.formatPhoneNumber || digits.isEmpty) return digits;
    return _formatDigits(digits, _effectivePhoneFormatGroups);
  }

  String _formatDigits(String digits, List<int> groups) {
    if (digits.isEmpty) return '';
    final StringBuffer result = StringBuffer();
    int index = 0;
    for (final int groupSize in groups) {
      if (groupSize <= 0 || index >= digits.length) continue;
      final int end = (index + groupSize).clamp(0, digits.length).toInt();
      if (result.isNotEmpty) result.write(' ');
      result.write(digits.substring(index, end));
      index = end;
    }
    if (index < digits.length) {
      if (result.isNotEmpty) result.write(' ');
      result.write(digits.substring(index));
    }
    return result.toString();
  }

  void _handleChanged(String value) {
    final String normalized = _normalizePhoneNumber(value);
    if (widget.autovalidateMode == AutovalidateMode.always ||
        widget.autovalidateMode == AutovalidateMode.onUserInteraction ||
        _errorText!= null) _validate(normalized); // <- UNIFIE
    widget.onChanged?.call(normalized);
  }

  void _handleSubmitted(String value) {
    final String normalized = _normalizePhoneNumber(value);
    _validate(normalized);
    widget.onSubmitted?.call(normalized);
  }

  void _validate(String? value) {
    if (widget.validator == null) return;
    final String? error = widget.validator!(value);
    if (!mounted || _errorText == error) return;
    setState(() => _errorText = error);
  }

 Future<void> _handleCountryTap() async {
  if (!widget.enabled || widget.readOnly || !widget.countryPickerEnabled) return;
  FocusScope.of(context).unfocus();
  
  // FIX : Ajout de l'argument positionnel requis (_effectiveCountry) attendu par la signature
  if (widget.onCountryTap != null && _effectiveCountry != null) { 
    widget.onCountryTap!(_effectiveCountry!); 
    return; 
  }
  
  try {
    final PhoneCountryRegistry registry = await _registryFuture;
    if (!mounted) return;

    final glassContext = ref.watchGlassContext(context); 
    final GlassColorPalette palette = glassContext.palette;

    final List<PhoneCountry> countriesList = widget.countries ?? registry.all();

    final PhoneCountry? selected = await PhoneCountryPicker.show(
      context: context,
      countries: countriesList,
      palette: palette,
      selectedCountry: _effectiveCountry,
      title: widget.countryPickerTitle,
      subtitle: widget.countryPickerSubtitle,
    );
    if (selected == null || !mounted) return;
    _selectCountry(selected);
  } catch (error) {
    debugPrint('UniversalGlassPhoneInput: erreur country picker => $error');
  }
}

  void _selectCountry(PhoneCountry country) {
    if (widget.country == null) setState(() { _internalCountry = country; _errorText = null; });
    else setState(() => _errorText = null);
    _controller.clear();
    widget.onCountryChanged?.call(country);
    _formatInitialValue();
  }

  void _handleSuffixTap() { if (!widget.enabled || widget.onSuffixTap == null) return; widget.onSuffixTap!(); }
  void _handleContainerTap() { if (!widget.enabled || widget.readOnly) return; _focusNode.requestFocus(); widget.onTap?.call(); }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChanged);
    _internalController.dispose();
    _internalFocusNode.dispose();
    super.dispose();
  }

/*

@override
Widget build(BuildContext context) {
  final glass = ref.watchGlassContext(context);
  final bool hasError = _errorText != null && _errorText!.trim().isNotEmpty;
  final GlassInputDecoration effectiveDecoration = glass.inputDecoration(hasError: hasError, isFocused: _focusNode.hasFocus);
  final bool useAqua = glass.theme.useAquaStyle;
  final Color focusColor = useAqua ? Colors.cyanAccent : Colors.orangeAccent;

  // 1. CALIBRATEUR UI
  final geo = GlassLayoutCalibrator(
    fieldHeight: widget.fieldHeight, 
    fontSize: effectiveDecoration.fontSize, 
    hasPrefixIcon: true, 
  );

  final bool hasText = _controller.text.isNotEmpty;
  final bool isFloating = _focusNode.hasFocus || hasText;
  final BorderRadius radius = BorderRadius.circular(effectiveDecoration.borderRadius);

  // 2. FORMATTERS
  final List<TextInputFormatter> inputFormatters = <TextInputFormatter>[
    if (widget.formatPhoneNumber)
      _GlassPhoneInputFormatter(maxDigits: widget.maxPhoneDigits, groups: widget.phoneFormatGroups),
    if (!widget.formatPhoneNumber) FilteringTextInputFormatter.digitsOnly,
  ];

  // 3. HINT MASK
  String defaultHintMask = '';
  if (widget.formatPhoneNumber && widget.phoneFormatGroups.isNotEmpty) {
    defaultHintMask = widget.phoneFormatGroups.map((group) => 'x' * group).join(' ');
  } else {
    defaultHintMask = 'x' * widget.maxPhoneDigits;
  }
  final String finalHintText = widget.hintText ?? (defaultHintMask.isNotEmpty ? defaultHintMask : 'xx xx');

  // 4. TEXTFORMFIELD
  final Widget phoneTextField = TextFormField(
    controller: _controller,
    focusNode: _focusNode,
    enabled: widget.enabled,
    readOnly: widget.readOnly,
    keyboardType: TextInputType.phone,
    textInputAction: widget.textInputAction,
    inputFormatters: inputFormatters,
    textAlign: TextAlign.start, // <- aligné à gauche
    textAlignVertical: TextAlignVertical.center, // <- centré vertical
    style: TextStyle(
      color: widget.enabled ? Colors.white : Colors.white.withValues(alpha: 0.35),
      fontSize: effectiveDecoration.fontSize,
      fontWeight: effectiveDecoration.fontWeight,
      height: 1.0, // <- évite le décalage vertical
    ),
    cursorColor: focusColor,
    cursorHeight: effectiveDecoration.fontSize * 1.2, // <- curseur visible
    onChanged: (val) {
      if (widget.onChanged != null) widget.onChanged!(val);
      setState(() {}); 
    },
    decoration: InputDecoration(
      isDense: true,
      isCollapsed: true, // <- évite le centrage auto
      hintText: finalHintText,
      hintStyle: TextStyle(
        color: Colors.white.withValues(alpha: 0.35), 
        fontSize: geo.hintFontSize,
        height: 1.0,
      ),
      errorText: null, // Déporté en bas
      
      // PADDING : on aligne avec le label
      contentPadding: geo.contentPadding.copyWith(left: 14),

      // PREFIX : indicatif pays
      prefixIcon: Padding(
        padding: const EdgeInsets.only(left: 14, right: 8),
        child: _buildCountrySelector(
          decoration: effectiveDecoration,
          contentColor: _focusNode.hasFocus ? focusColor : effectiveDecoration.textColor,
          iconColor: _focusNode.hasFocus ? focusColor : effectiveDecoration.iconColor,
          hasError: hasError,
          palette: glass.palette,
          focusColor: focusColor,
        ),
      ),
      prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),

      // SUFFIX : clear button
      suffixIcon: widget.suffixIcon != null && _controller.text.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.only(right: 14),
              child: context.buildInputIcon(
                icon: widget.suffixIcon!,
                isActive: _focusNode.hasFocus,
                enabled: widget.enabled,
                onTap: widget.onSuffixTap,
                color: hasError ? effectiveDecoration.errorColor : effectiveDecoration.iconColor,
                fieldHeight: widget.fieldHeight,
                bubbleRatio: 0.6,
                onlyIcon: true,
              ),
            )
          : null,
      suffixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),

      border: InputBorder.none,
      enabledBorder: InputBorder.none,
      focusedBorder: InputBorder.none,
    ),
  );

  return Opacity(
    opacity: widget.enabled ? 1.0 : 0.65,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // 5. WRAPPER AVEC OMBRE ET ENCOCHE
        GlassNotchShadowWrapper(
          isShadowEnabled: _focusNode.hasFocus, // <- ombre seulement au focus
          shadowOpacity: 0.25,
          elevation: 8,
          borderRadius: radius,
          clipper: isFloating ? NotchClipper(notchStart: geo.notchStart, notchWidth: geo.getLabelWidth(widget.label)) : null,
          child: Stack(
            clipBehavior: Clip.none, // <- important pour que le label dépasse
            children: [
              // FOND GLASS AVEC ENCOCHE
              ClipPath(
                clipper: isFloating ? NotchClipper(notchStart: geo.notchStart, notchWidth: geo.getLabelWidth(widget.label)) : null,
                child: GlassSurfaceContainer(
                  decoration: effectiveDecoration,
                  style: glass.effectiveGlassStyle,
                  shape: widget.shape,
                  width: widget.width,
                  height: widget.fieldHeight,
                  borderRadius: radius,
                  padding: EdgeInsets.zero, 
                  liftOnHover: true, // <- hover toujours actif
                  clipBehavior: Clip.antiAlias, // <- pour que le tap passe
                  child: Align( // <- aligné à gauche au lieu de Center
                    alignment: Alignment.centerLeft,
                    child: phoneTextField,
                  ),
                ),
              ),

              // 6. LABEL FLOTTANT
              AnimatedPositioned(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeInOutQuad,
                top: isFloating ? -8.5 : geo.labelTopAtRest, 
                left: geo.getLabelLeft(isFloating),
                child: IgnorePointer(
                  ignoring: false, // <- permet au tap de passer au TextField
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 140),
                    opacity: isFloating ? 1.0 : 0.0, 
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 180),
                      style: TextStyle(
                        color: hasError 
                            ? effectiveDecoration.errorColor 
                            : _focusNode.hasFocus 
                                ? focusColor 
                                : Colors.white.withValues(alpha: widget.enabled ? (isFloating ? 0.6 : 0.4) : 0.20),
                        fontSize: isFloating ? 10.5 : (geo.isVeryCompact ? 14 : effectiveDecoration.fontSize),
                        fontWeight: isFloating ? FontWeight.w700 : FontWeight.w500,
                        letterSpacing: 0.2,
                        backgroundColor: Colors.transparent, 
                      ),
                      child: Text(widget.label),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // 7. ERREUR
        if (hasError && widget.enabled)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 14),
            child: Text(
              _errorText!, 
              style: TextStyle(color: effectiveDecoration.errorColor, fontSize: 12, fontWeight: FontWeight.w500)
            ),
          ),
      ],
    ),
  );
}
*/

@override
Widget build(BuildContext context) {
  final glass = ref.watchGlassContext(context);
  final bool hasError = _errorText != null && _errorText!.trim().isNotEmpty;
  final GlassInputDecoration effectiveDecoration = glass.inputDecoration(hasError: hasError, isFocused: _focusNode.hasFocus);
  final bool useAqua = glass.theme.useAquaStyle;
  final Color focusColor = useAqua ? Colors.cyanAccent : Colors.orangeAccent;

  final geo = GlassLayoutCalibrator(
    fieldHeight: widget.fieldHeight, 
    fontSize: effectiveDecoration.fontSize, 
    hasPrefixIcon: true, 
  );

  final bool hasText = _controller.text.isNotEmpty;
  final bool isFloating = _focusNode.hasFocus || hasText;
  final BorderRadius radius = BorderRadius.circular(effectiveDecoration.borderRadius);

  final List<TextInputFormatter> inputFormatters = <TextInputFormatter>[
    if (widget.formatPhoneNumber)
      _GlassPhoneInputFormatter(maxDigits: widget.maxPhoneDigits, groups: widget.phoneFormatGroups),
    if (!widget.formatPhoneNumber) FilteringTextInputFormatter.digitsOnly,
  ];

  String defaultHintMask = '';
  if (widget.formatPhoneNumber && widget.phoneFormatGroups.isNotEmpty) {
    defaultHintMask = widget.phoneFormatGroups.map((group) => 'x' * group).join(' ');
  } else {
    defaultHintMask = 'x' * widget.maxPhoneDigits;
  }
  final String finalHintText = widget.hintText ?? (defaultHintMask.isNotEmpty ? defaultHintMask : 'xx xx');

  final Widget phoneTextField = TextFormField(
    controller: _controller,
    focusNode: _focusNode,
    enabled: widget.enabled,
    readOnly: widget.readOnly,
    keyboardType: TextInputType.phone,
    textInputAction: widget.textInputAction,
    inputFormatters: inputFormatters,
    style: TextStyle(
      color: widget.enabled ? Colors.white : Colors.white.withValues(alpha: 0.35),
      fontSize: effectiveDecoration.fontSize,
      fontWeight: effectiveDecoration.fontWeight,
    ),
    cursorColor: focusColor,
    onTap: () { // <- FIX 1 : force le focus au 1er tap
      if (!_focusNode.hasFocus) _focusNode.requestFocus();
    },
    onChanged: (val) {
      if (widget.onChanged != null) widget.onChanged!(val);
      setState(() {}); 
    },
    decoration: InputDecoration(
      isDense: true,
      hintText: finalHintText, // <- on ne touche pas
      hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.35), fontSize: geo.hintFontSize),
      errorText: null,
      contentPadding: geo.contentPadding.copyWith(left: 14),
      prefixIcon: Padding(
        padding: const EdgeInsets.only(left: 14, right: 8),
        child: _buildCountrySelector(
          decoration: effectiveDecoration,
          contentColor: _focusNode.hasFocus ? focusColor : effectiveDecoration.textColor,
          iconColor: _focusNode.hasFocus ? focusColor : effectiveDecoration.iconColor,
          hasError: hasError,
          palette: glass.palette,
          focusColor: focusColor,
        ),
      ),
      prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
      // SUFFIX : clear button
      suffixIcon: widget.suffixIcon != null && _controller.text.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.only(right: 14),
              child: context.buildInputIcon(
                icon: widget.suffixIcon!,
                isActive: _focusNode.hasFocus,
                enabled: widget.enabled,
                onTap: widget.onSuffixTap,
                color: hasError ? effectiveDecoration.errorColor : effectiveDecoration.iconColor,
                fieldHeight: widget.fieldHeight,
                bubbleRatio: 0.6,
                onlyIcon: true,
              ),
            )
          : null,
      suffixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
      
      border: InputBorder.none,
      enabledBorder: InputBorder.none,
      focusedBorder: InputBorder.none,
    ),
  );

  return Opacity(
    opacity: widget.enabled ? 1.0 : 0.65,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        GlassNotchShadowWrapper(
          isShadowEnabled: _focusNode.hasFocus, // <- ombre au focus
          shadowOpacity: 0.25,
          elevation: 8,
          borderRadius: radius,
          clipper: isFloating ? NotchClipper(notchStart: geo.notchStart, notchWidth: geo.getLabelWidth(widget.label)) : null,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              ClipPath(
                clipper: isFloating ? NotchClipper(notchStart: geo.notchStart, notchWidth: geo.getLabelWidth(widget.label)) : null,
                child: GlassSurfaceContainer(
                  decoration: effectiveDecoration,
                  style: glass.effectiveGlassStyle,
                  shape: widget.shape,
                  width: widget.width,
                  height: widget.fieldHeight,
                  borderRadius: radius,
                  padding: EdgeInsets.zero, 
                  liftOnHover: true,
                  clipBehavior: Clip.antiAlias, // <- FIX 1 : pour que le tap passe
                  child: Center(child: phoneTextField), // <- on remet Center car ton hint est centré
                ),
              ),

              // LABEL FLOTTANT AVEC FOND
              AnimatedPositioned(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeInOutQuad,
                top: isFloating ? -8.5 : geo.labelTopAtRest, 
                left: geo.getLabelLeft(isFloating),
                child: IgnorePointer(
                  ignoring: false,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 140),
                    opacity: isFloating ? 1.0 : 0.0, 
                    child: Container( // <- FIX 2 : fond pour cacher derrière
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      decoration: BoxDecoration(
                        color: glass.palette.surface.withValues(alpha: 0.9), // <- fond glass
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 180),
                        style: TextStyle(
                          color: hasError 
                              ? effectiveDecoration.errorColor 
                              : _focusNode.hasFocus 
                                  ? focusColor 
                                  : Colors.white.withValues(alpha: widget.enabled ? (isFloating ? 0.6 : 0.4) : 0.20),
                          fontSize: isFloating ? 10.5 : (geo.isVeryCompact ? 14 : effectiveDecoration.fontSize),
                          fontWeight: isFloating ? FontWeight.w700 : FontWeight.w500,
                          letterSpacing: 0.2,
                        ),
                        child: Text(widget.label),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        
        if (hasError && widget.enabled)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 14),
            child: Text(_errorText!, style: TextStyle(color: effectiveDecoration.errorColor, fontSize: 12)),
          ),
      ],
    ),
  );
}
  
  Widget _buildCountrySelector({
    required GlassInputDecoration decoration, 
    required Color contentColor, 
    required Color iconColor, 
    required bool hasError, 
    required GlassColorPalette palette,
    required Color focusColor,
  }) {
    final bool canOpen = widget.enabled && !widget.readOnly && widget.countryPickerEnabled;

    final Color finalTextColor = !widget.enabled
        ? contentColor.withValues(alpha: 0.40)
        : _hasFocus ? focusColor : contentColor;

    final Color separatorColor = !widget.enabled
        ? palette.border.withValues(alpha: 0.2)
        : _hasFocus ? focusColor.withValues(alpha: 0.4) : palette.border.withValues(alpha: 0.3);

    final double currentBubbleSize = GlassInputUtils.bubbleSize(fieldHeight: widget.fieldHeight, ratio: 0.6);

    // 1 LIGNE : La bulle avec drapeau via ton extension simplifiée de contexte
    final Widget bubble = context.buildInputBubbleWithChild(
      child: _buildCountryFlag(size: GlassInputUtils.iconSize(bubbleSize: currentBubbleSize)),
      isActive: _hasFocus,
      enabled: canOpen,
      onTap: canOpen ? _handleCountryTap : null,
      fieldHeight: widget.fieldHeight,
      bubbleRatio: 0.6,
      hasError: hasError,
    );

    final Widget countryCode = Text(_effectiveCountryCode, style: TextStyle(color: finalTextColor, fontSize: decoration.fontSize - 1, fontWeight: FontWeight.w700));

    // 1 LIGNE : Le chevron compressé en mode icône nue sans sa bulle externe via l'extension contextuelle
    final Widget chevron = context.buildInputIcon(
      icon: Icons.keyboard_arrow_down_rounded,
      isActive: _hasFocus,
      enabled: canOpen,
      onTap: canOpen ? _handleCountryTap : null,
      fieldHeight: widget.fieldHeight,
      bubbleRatio: 0.5, 
      showGlow: false,
      onlyIcon: true, // Masque la bulle pour n'avoir que le glyphe cliquable
    );

    return Row(
      mainAxisSize: MainAxisSize.min, 
      crossAxisAlignment: CrossAxisAlignment.center, 
      children: [
        bubble, 
        const SizedBox(width: 8),
        MouseRegion(
          cursor: canOpen ? SystemMouseCursors.click : SystemMouseCursors.basic, 
          child: GestureDetector(
            behavior: HitTestBehavior.opaque, 
            onTap: canOpen ? _handleCountryTap : null, 
            child: Row(
              mainAxisSize: MainAxisSize.min, 
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                countryCode, 
                const SizedBox(width: 8), 
                // Utilisation de ta méthode utilitaire pour la hauteur du trait
                Container(width: 1, height: GlassInputUtils.separatorHeight(currentBubbleSize), color: separatorColor), 
                const SizedBox(width: 4), 
                chevron
              ]
            )
          )
        )
      ]
    );
  }

  Widget _buildSuffixIcon(Color baseIconColor) {
    if (widget.suffixIcon == null) return const SizedBox.shrink();

    // APPEL DIRECT en 1 seule ligne via ton extension d'UI contextuelle propre
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: context.buildInputIcon(
        icon: widget.suffixIcon!,
        isActive: _hasFocus,
        enabled: widget.enabled,
        onTap: widget.onSuffixTap != null ? _handleSuffixTap : null,
        color: baseIconColor,
        fieldHeight: widget.fieldHeight,
        bubbleRatio: 0.6, // Alignement symétrique parfait à 60% avec le CountrySelector
        showGlow: _hasFocus,
      ),
    );
  }

  Widget _buildCountryFlag({double size = 22}) {
    final String? asset = _effectiveFlagAsset;
    if (asset != null && asset.trim().isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Image.asset(
          asset, 
          package: 'universal_glass', 
          width: size, 
          height: size * 0.60, 
          fit: BoxFit.cover, 
          cacheWidth: (size * 2.4).toInt(),
          errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
            debugPrint('UniversalGlassPhoneInput: impossible de charger le drapeau "$asset" : $error');
            return _buildFallbackFlag(size: size);
          }
        )
      );
    }
    return _buildFallbackFlag(size: size);
  }

  Widget _buildFallbackFlag({double size = 22}) {
    final glass = ref.watchGlassContext(context); 
    return Text(_effectiveCountryFlag, textAlign: TextAlign.center, style: TextStyle(color: glass.palette.white, fontSize: size, height: 1.0));
  }


}

class _GlassPhoneInputFormatter extends TextInputFormatter {
  final int maxDigits; final List<int> groups;
  const _GlassPhoneInputFormatter({required this.maxDigits, required this.groups});
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    int cursorOffset = newValue.selection.isValid? newValue.selection.baseOffset : newValue.text.length;
    cursorOffset = cursorOffset.clamp(0, newValue.text.length).toInt();
    final String beforeCursor = newValue.text.substring(0, cursorOffset);
    int digitsBeforeCursor = _countDigits(beforeCursor);
    String digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (maxDigits >= 0 && digits.length > maxDigits) digits = digits.substring(0, maxDigits);
    digitsBeforeCursor = digitsBeforeCursor.clamp(0, digits.length).toInt();
    final String formatted = _format(digits);
    final int cursorPosition = _calculateCursorPosition(formatted: formatted, digitCountBeforeCursor: digitsBeforeCursor);
    return TextEditingValue(text: formatted, selection: TextSelection.collapsed(offset: cursorPosition));
  }
  int _countDigits(String value) { int count = 0; for (int i = 0; i < value.length; i++) { if (_isDigit(value[i])) count++; } return count; }
  String _format(String digits) { if (digits.isEmpty) return ''; final StringBuffer result = StringBuffer(); int index = 0; for (final int groupSize in groups) { if (groupSize <= 0 || index >= digits.length) continue; final int end = (index + groupSize).clamp(0, digits.length).toInt(); if (result.isNotEmpty) result.write(' '); result.write(digits.substring(index, end)); index = end; } if (index < digits.length) { if (result.isNotEmpty) result.write(' '); result.write(digits.substring(index)); } return result.toString(); }
  int _calculateCursorPosition({required String formatted, required int digitCountBeforeCursor}) { if (digitCountBeforeCursor <= 0) return 0; int foundDigits = 0; for (int i = 0; i < formatted.length; i++) { if (_isDigit(formatted[i])) { foundDigits++; if (foundDigits >= digitCountBeforeCursor) return i + 1; } } return formatted.length; }
  bool _isDigit(String character) => RegExp(r'^[0-9]$').hasMatch(character);
}