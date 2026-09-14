import 'package:flutter/material.dart';
import 'package:universal_glass/phone/phone_country.dart';
import 'package:universal_glass/phone/phone_country_picker.dart';
import 'package:universal_glass/phone/phone_country_registry.dart';
import 'package:universal_glass/utils/glass_field_notch_wrapper.dart';
import 'package:universal_glass/utils/glass_input_decoration.dart';
import 'package:universal_glass/utils/glass_input_state_style.dart';
import 'package:universal_glass/components/inputs/phone/universal_glass_phone_input_state.dart';
import 'package:universal_glass/utils/glass_input_utils.dart';
import 'package:universal_glass/utils/glass_layout_calibrator.dart';
import 'package:universal_glass/theme/glass_effects.dart'; // <- AJOUT
import 'package:universal_glass/core/layout/glass_layout_context.dart';
import 'package:universal_glass/core/layout/glass_layout_scope.dart';

class UniversalGlassPhoneInputView extends StatelessWidget {
  final UniversalGlassPhoneInputState state;

  const UniversalGlassPhoneInputView({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return _PhoneInputVisualBuilder( // <- LA CLASSE EXISTE EN BAS
      focusNode: state.focusNode,
      controller: state.controller,
      builder: (BuildContext context, bool hasFocus, bool hasText) {
        return _buildPhoneInput(context: context);
      },
    );
  }

  Widget _buildPhoneInput({required BuildContext context}) {
    final widget = state.widget;
    final GlassLayoutContext glass = GlassLayoutScope.of(context);
    final s = widget.style; // <- ALIAS

    // 1. ETAT
    final bool hasText = state.controller.text.isNotEmpty;
    final bool isFloating = state.isFocused || hasText;

    // 2. DECO + STYLE UNIQUE
    final GlassInputDecoration decoration = glass.inputDecoration(
      hasError: state.hasError,
      isFocused: state.isFocused,
    );

    final GlassInputStateStyle inputStyle = GlassInputStateStyle.resolve(
      decoration: decoration,
      hasError: state.hasError,
      hasSuccess: state.hasSuccess,
      isFocused: state.isFocused,
      enabled: s.enabled,
    );

    final double textScaleFactor = MediaQuery.textScalerOf(context).scale(s.fontSize) / s.fontSize;
    final double effectiveTextScale = textScaleFactor.clamp(0.5, 3.0);

    final GlassLayoutCalibrator geo = GlassLayoutCalibrator(
      fieldHeight: s.fieldHeight,
      fontSize: s.fontSize,
      hasPrefixIcon: true,
      textScaleFactor: effectiveTextScale,
    );

    final BorderRadius borderRadius = BorderRadius.circular(s.borderRadius);

    final baseEffects = GlassEffects.fromTheme(glass.palette);
    final effectiveEffects = baseEffects.copyWith(
      bgBlur: s.enableBlur ? s.blur : 0,
      blur: s.enableBlur ? s.blur : 0,
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

    // 3. BADGE OPERATEUR
    Widget? operatorBadge;
    if (widget.showOperatorBadge && inputStyle.showSuccess) {
      final String operator = state.detectedOperator;
      if (operator.isNotEmpty) {
        operatorBadge = Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: inputStyle.borderColor.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: inputStyle.borderColor.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Text(
            operator,
            style: TextStyle(
              color: inputStyle.borderColor,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            ),
          ),
        );
      }
    }

    final Widget fieldContent = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildCountrySelector(context: context, geo: geo, inputStyle: inputStyle, decoration: decoration),
        const SizedBox(width: 12),
        Expanded(
          child: geo.translateTextVertically(
            TextFormField(
              controller: state.controller,
              focusNode: state.focusNode,
              enabled: s.enabled,
              readOnly: widget.readOnly,
              autofocus: false,
              showCursor: true,
              keyboardType: TextInputType.phone,
              textInputAction: widget.textInputAction,
              textAlign: TextAlign.start,
              textAlignVertical: TextAlignVertical.center,
              inputFormatters: widget.inputFormatters,
              style: TextStyle(
                color: inputStyle.textColor,
                fontSize: s.fontSize,
                fontWeight: FontWeight.w400,
                letterSpacing: decoration.letterSpacing,
              ),
              cursorColor: inputStyle.borderColor,
              cursorHeight: s.fontSize * 1.2,
              onTap: widget.onTap,
              onChanged: state.handleChanged,
              onFieldSubmitted: state.handleSubmitted,
              decoration: InputDecoration(
                isDense: true,
                isCollapsed: true,
                border: InputBorder.none,
                contentPadding: geo.contentPadding,
                hintText: isFloating ? widget.hintText : null,
                hintStyle: TextStyle(
                  color: inputStyle.hintColor,
                  fontSize: geo.hintFontSize,
                  fontWeight: FontWeight.w400,
                  height: null,
                  leadingDistribution: TextLeadingDistribution.even,
                  letterSpacing: decoration.letterSpacing,
                ),
              ),
            ),
          ),
        ),
        if (operatorBadge != null) ...[const SizedBox(width: 8), operatorBadge],
      ],
    );

    return Opacity(
      opacity: s.enabled ? 1.0 : 0.65,
      child: GlassFieldNotchWrapper(
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
        helperText: state.helperText,
         child: fieldContent,
      ),
    );
  }

  Widget _buildCountrySelector({
    required BuildContext context,
    required GlassLayoutCalibrator geo,
    required GlassInputStateStyle inputStyle,
    required GlassInputDecoration decoration,
  }) {
    final widget = state.widget;
    final s = widget.style;
    final GlassLayoutContext glass = GlassLayoutScope.of(context);
    final bool canOpen = s.enabled && !widget.readOnly && widget.countryPickerEnabled;

    final double bubbleSize = GlassInputUtils.bubbleSize(fieldHeight: s.fieldHeight, ratio: 0.6);

    final Widget bubble = context.buildInputBubbleWithChild(
      child: _buildCountryFlag(size: GlassInputUtils.iconSize(bubbleSize: bubbleSize)),
      fieldHeight: s.fieldHeight,
      isActive: inputStyle.isActive,
      enabled: canOpen,
      onTap: canOpen ? () => _handleCountryTap(context) : null,
      color: inputStyle.iconColor,
    );

    final Color finalTextColor = !s.enabled
        ? inputStyle.textColor.withValues(alpha: 0.40)
        : inputStyle.isActive
            ? inputStyle.borderColor
            : inputStyle.textColor;

    final Color separatorColor = inputStyle.isActive
        ? inputStyle.borderColor.withValues(alpha: 0.4)
        : glass.palette.border.withValues(alpha: 0.3);

    final Widget countryCode = Text(
      state.effectiveCountryCode,
      style: TextStyle(color: finalTextColor, fontSize: s.fontSize - 1, fontWeight: FontWeight.w700),
    );

    final Widget chevron = geo.translateChevron(
      context.buildInputIcon(
        icon: Icons.expand_more_rounded,
        isActive: inputStyle.isActive,
        enabled: canOpen,
        onTap: canOpen ? () => _handleCountryTap(context) : null,
        fieldHeight: s.fieldHeight,
        bubbleRatio: 0.66,
        hasError: inputStyle.hasError,
        onlyIcon: true,
      ),
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        bubble,
        const SizedBox(width: 8),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: canOpen ? () => _handleCountryTap(context) : null,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              countryCode,
              const SizedBox(width: 8),
              Container(width: 1, height: GlassInputUtils.separatorHeight(bubbleSize), color: separatorColor),
              const SizedBox(width: 4),
              chevron,
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _handleCountryTap(BuildContext context) async {
    final widget = state.widget;
    final s = widget.style;
    if (!s.enabled || widget.readOnly || !widget.countryPickerEnabled) return;

    FocusScope.of(context).unfocus();
    final PhoneCountry? currentCountry = state.effectiveCountry;

    if (widget.onCountryTap != null && currentCountry != null) {
      widget.onCountryTap!(currentCountry);
      return;
    }

    try {
      final PhoneCountryRegistry registry = await state.registryFuture;
      if (!context.mounted) return;
      final GlassLayoutContext glass = GlassLayoutScope.of(context);
      final List<PhoneCountry> countries = widget.countries ?? registry.all();

      final PhoneCountry? selected = await PhoneCountryPicker.show(
        context: context,
        countries: countries,
        palette: glass.palette,
        selectedCountry: currentCountry,
        title: widget.countryPickerTitle,
        subtitle: widget.countryPickerSubtitle,
      );

      if (selected != null && context.mounted) {
        state.selectCountry(selected);
      }
    } catch (error, stackTrace) {
      debugPrint('UniversalGlassPhoneInput: erreur country picker => $error');
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  Widget _buildCountryFlag({double size = 22}) {
    final String? asset = state.effectiveFlagAsset;
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
          errorBuilder: (context, error, stack) {
            return Text(state.effectiveCountryFlag, style: TextStyle(fontSize: size, height: 1));
          },
        ),
      );
    }
    return Text(state.effectiveCountryFlag, textAlign: TextAlign.center, style: TextStyle(fontSize: size, height: 1));
  }
}

// ===========================================================================
// HELPER: REBUILD SUR FOCUS/TEXTE
// ===========================================================================
class _PhoneInputVisualBuilder extends StatefulWidget { // <- REMETTRE CETTE CLASSE
  final FocusNode focusNode;
  final TextEditingController controller;
  final Widget Function(BuildContext context, bool hasFocus, bool hasText) builder;
  const _PhoneInputVisualBuilder({
    required this.focusNode,
    required this.controller,
    required this.builder,
  });
  @override
  State<_PhoneInputVisualBuilder> createState() => _PhoneInputVisualBuilderState();
}

class _PhoneInputVisualBuilderState extends State<_PhoneInputVisualBuilder> {
  late bool _hasFocus;
  late bool _hasText;
  @override
  void initState() {
    super.initState();
    _hasFocus = widget.focusNode.hasFocus;
    _hasText = widget.controller.text.isNotEmpty;
    widget.focusNode.addListener(_handleFocusChanged);
    widget.controller.addListener(_handleTextChanged);
  }

  @override
  void didUpdateWidget(covariant _PhoneInputVisualBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.focusNode != widget.focusNode) {
      oldWidget.focusNode.removeListener(_handleFocusChanged);
      _hasFocus = widget.focusNode.hasFocus;
      widget.focusNode.addListener(_handleFocusChanged);
    }
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_handleTextChanged);
      _hasText = widget.controller.text.isNotEmpty;
      widget.controller.addListener(_handleTextChanged);
    }
  }

  void _handleFocusChanged() {
    if (!mounted) return;
    final bool value = widget.focusNode.hasFocus;
    if (_hasFocus != value) setState(() => _hasFocus = value);
  }

  void _handleTextChanged() {
    if (!mounted) return;
    final bool value = widget.controller.text.isNotEmpty;
    if (_hasText != value) setState(() => _hasText = value);
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, _hasFocus, _hasText);
  @override
  void dispose() {
    widget.focusNode.removeListener(_handleFocusChanged);
    widget.controller.removeListener(_handleTextChanged);
    super.dispose();
  }
}