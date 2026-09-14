import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:universal_glass/components/inputs/fieldoutlined/outlined_field_controller.dart';
import 'package:universal_glass/enums/glass_enums.dart';
import 'package:universal_glass/models/glass_input_style.dart'; // <- AJOUT
import 'package:universal_glass/theme/glass_effects.dart'; // <- AJOUT
import 'package:universal_glass/utils/glass_field_notch_wrapper.dart';
import 'package:universal_glass/utils/glass_input_state_style.dart';
import 'package:universal_glass/utils/glass_input_utils.dart';
import 'package:universal_glass/utils/glass_layout_calibrator.dart';
import 'package:universal_glass/utils/glass_text_formatter.dart';
import 'package:universal_glass/core/layout/glass_layout_context.dart';
import 'package:universal_glass/core/layout/glass_layout_scope.dart';

class UniversalGlassTextFieldOutlined extends ConsumerStatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;

  final GlassInputStyle style; // <- REMPLACE fieldHeight/fontSize/blur/shape
  final String label;
  final String? hintText;

  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixTap;

  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;

  final String? Function(String?)? validator;
  final AutovalidateMode autovalidateMode;

  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  final bool readOnly;
  final double? iconSize;
  final double? iconInnerRatio;
  final GlassTextCase textCase;
  final List<TextInputFormatter>? inputFormatters;
  final double? width;

  const UniversalGlassTextFieldOutlined({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.style, // <- REQUIRED
    required this.label,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixTap,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.validator,
    this.autovalidateMode = AutovalidateMode.disabled,
    this.onChanged,
    this.onSubmitted,
    this.readOnly = false,
    this.iconSize,
    this.iconInnerRatio,
    this.textCase = GlassTextCase.normal,
    this.inputFormatters,
    this.width,
  });

  @override
  ConsumerState<UniversalGlassTextFieldOutlined> createState() =>
      _UniversalGlassTextFieldOutlinedState();
}

class _UniversalGlassTextFieldOutlinedState
    extends ConsumerState<UniversalGlassTextFieldOutlined> {
  late OutlinedFieldController _ctrl;
  bool _isHovered = false; // <- AJOUT pour hover

  OutlinedFieldController _createController() {
    return OutlinedFieldController(
      controller: widget.controller,
      focusNode: widget.focusNode,
      validator: widget.validator,
      autovalidateMode: widget.autovalidateMode,
      onUpdate: () { if (mounted) setState(() {}); },
      obscureText: widget.obscureText,
    );
  }

  @override
  void initState() {
    super.initState();
    _ctrl = _createController();
    widget.focusNode.addListener(_onFocusChanged); // <- AJOUT
  }

  @override
  void didUpdateWidget(covariant UniversalGlassTextFieldOutlined oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller || oldWidget.focusNode != widget.focusNode) {
      _ctrl.dispose();
      widget.focusNode.removeListener(_onFocusChanged);
      widget.focusNode.addListener(_onFocusChanged);
      _ctrl = _createController();
      return;
    }
    if (oldWidget.validator != widget.validator ||
        oldWidget.autovalidateMode != widget.autovalidateMode ||
        oldWidget.obscureText != widget.obscureText) {
      _ctrl.updateConfiguration(
        validator: widget.validator,
        autovalidateMode: widget.autovalidateMode,
        obscureText: widget.obscureText,
      );
    }
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_onFocusChanged);
    _ctrl.dispose();
    super.dispose();
  }

  void _onFocusChanged() { if(mounted) setState(() {}); } // <- AJOUT

  void _handleSuffixTap() {
    if (!widget.style.enabled) return;
    if (widget.obscureText) {
      _ctrl.toggleObscure();
      return;
    }
    widget.onSuffixTap?.call();
  }

  IconData? get _effectiveSuffixIcon {
    if (widget.obscureText) {
      return _ctrl.isObscured ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    }
    return widget.suffixIcon;
  }

  @override
  Widget build(BuildContext context) {
    final GlassLayoutContext glass = GlassLayoutScope.of(context);
    final s = widget.style; // <- alias
    final decoration = glass.inputDecoration(hasError: _ctrl.shouldShowError, isFocused: _ctrl.isFocused);

    final bool hasText = widget.controller.text.isNotEmpty;
    final bool isFloating = _ctrl.isFocused || hasText;

    final double baseFontSize = s.fontSize <= 0.0 ? 1.0 : s.fontSize;
    final double textScaleFactor = MediaQuery.textScalerOf(context).scale(baseFontSize) / baseFontSize;
    final double effectiveTextScale = textScaleFactor.clamp(0.5, 3.0);

    // STATE STYLE AVEC HOVER
    final GlassInputStateStyle inputStyle = GlassInputStateStyle.resolve(
      decoration: decoration,
      hasError: _ctrl.shouldShowError,
      hasSuccess: _ctrl.shouldShowSuccess,
      isFocused: _ctrl.isFocused,
      isHovered: _isHovered, // <- AJOUT
      enabled: s.enabled,
    );

    final GlassLayoutCalibrator geo = GlassLayoutCalibrator(
      fieldHeight: s.fieldHeight, // <- vient du style
      fontSize: s.fontSize, // <- vient du style
      hasPrefixIcon: widget.prefixIcon != null,
      textScaleFactor: effectiveTextScale,
    );

    final BorderRadius borderRadius = BorderRadius.circular(s.borderRadius); // <- vient du style

    // EFFECTS DEPUIS LE STYLE
    final baseEffects = GlassEffects.fromTheme(glass.palette);
    final effectiveEffects = baseEffects.copyWith(
      bgBlur: s.enableBlur ? s.blur : 0,
      blur: s.enableBlur ? s.blur : 0,
      bgNoise: 0,
      noise: 0,
      surfaceOpacity: inputStyle.backgroundOpacity,
      enableBorder: s.enableBorder,
      borderRadius: s.borderRadius,
      borderOpacity: s.borderOpacity,
      borderWidth: s.borderWidth,
      enableShadow: s.enableShadow && inputStyle.isActive,
      shadowOpacity: s.shadowOpacity,
      shadowBlur: s.shadowBlur,
      shadowOffsetY: s.shadowOffsetY,
    );

    final Widget fieldContent = MouseRegion( // <- WRAP pour hover
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (widget.prefixIcon != null) ...[
            SizedBox(
              width: geo.iconSize,
              height: geo.iconSize,
              child: Center(
                child: context.buildInputIcon(
                  icon: widget.prefixIcon!,
                  isActive: inputStyle.isActive,
                  enabled: s.enabled,
                  onTap: null,
                  glowColor: inputStyle.borderColor,
                  fieldHeight: s.fieldHeight,
                  bubbleRatio: geo.isVeryCompact ? 0.65 : 0.60,
                  iconRatio: widget.iconSize != null ? widget.iconSize! / geo.iconSize : 0.66,
                  showGlow: inputStyle.shouldShowGlow,
                  hasError: inputStyle.hasError,
                  hasSuccess: inputStyle.showSuccess,
                ),
              ),
            ),
            SizedBox(width: geo.isVeryCompact ? 8.0 : 12.0),
          ],
          Expanded(
            child: TextFormField(
              controller: widget.controller,
              focusNode: widget.focusNode,
              enabled: s.enabled, // <- vient du style
              readOnly: widget.readOnly,
              obscureText: _ctrl.isObscured,
              keyboardType: widget.keyboardType,
              textInputAction: widget.textInputAction,
              textAlignVertical: TextAlignVertical.center,
              style: TextStyle(
                color: inputStyle.textColor,
                fontSize: s.fontSize,
                fontWeight: FontWeight.w400,
                leadingDistribution: TextLeadingDistribution.even,
                letterSpacing: decoration.letterSpacing,
              ),
              cursorColor: inputStyle.borderColor,
              inputFormatters: [
                if (widget.textCase == GlassTextCase.uppercase) GlassTextFormatter.uppercaseFormatter,
                if (widget.textCase == GlassTextCase.lowercase) GlassTextFormatter.lowercaseFormatter,
                if (widget.textCase == GlassTextCase.capitalize) GlassTextFormatter.capitalizeFormatter,
                ...?widget.inputFormatters,
              ],
              decoration: InputDecoration(
                isDense: true,
                isCollapsed: true,
                border: InputBorder.none,
                contentPadding: geo.contentPadding,
                hintText: isFloating ? widget.hintText : null, // <- hint seulement si flottant
                hintStyle: TextStyle(
                  color: inputStyle.hintColor,
                  fontSize: geo.hintFontSize,
                  fontWeight: FontWeight.w400,
                  leadingDistribution: TextLeadingDistribution.even,
                  letterSpacing: decoration.letterSpacing,
                ),
                errorText: null,
                suffixIcon: null,
              ),
              onChanged: (value) {
                widget.onChanged?.call(value);
                _ctrl.handleChanged(value);
              },
              onFieldSubmitted: (value) {
                _ctrl.handleSubmitted(value);
                widget.onSubmitted?.call(value);
              },
            ),
          ),
          _buildTrailingIcon(inputStyle, geo),
        ],
      ),
    );

    return GlassFieldNotchWrapper(
  label: widget.label,
  isFloating: isFloating,
  inputStyle: inputStyle,
  enabled: s.enabled,
  fieldHeight: s.fieldHeight,
  fontSize: s.fontSize,
  borderRadius: borderRadius,
  decoration: decoration,
  geo: geo,
  style: glass.effectiveGlassStyle,
  effects: effectiveEffects,
  shape: s.shape,
  width: widget.width,
  helperText: _ctrl.shouldShowError ? _ctrl.helperText : null,
  child: fieldContent,
);
  }

  Widget _buildTrailingIcon(GlassInputStateStyle inputStyle, GlassLayoutCalibrator geo) {
    final bool hasStatus = inputStyle.showError || inputStyle.showSuccess;
    if (hasStatus) return const SizedBox.shrink();

    final IconData? suffixIcon = _effectiveSuffixIcon;
    if (suffixIcon == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(left: 6.0),
      child: context.buildInputIcon(
        icon: suffixIcon,
        isActive: inputStyle.isActive,
        enabled: widget.style.enabled,
        onTap: widget.style.enabled ? _handleSuffixTap : null,
        glowColor: inputStyle.borderColor,
        fieldHeight: widget.style.fieldHeight,
        bubbleRatio: geo.isVeryCompact ? 0.65 : 0.60,
        iconRatio: widget.iconSize != null ? widget.iconSize! / geo.iconSize : 0.66,
        showGlow: inputStyle.shouldShowGlow,
        hasError: inputStyle.hasError,
        hasSuccess: inputStyle.showSuccess,
        onlyIcon: true,
      ),
    );
  }
}