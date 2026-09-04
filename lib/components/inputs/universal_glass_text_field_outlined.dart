// ignore_for_file: curly_braces_in_flow_control_structures
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:universal_glass/components/inputs/fieldoutlined/outlined_field_controller.dart';
import 'package:universal_glass/components/inputs/fieldoutlined/outlined_field_decoration.dart';
import 'package:universal_glass/components/surface/glass_surface_container.dart';
import 'package:universal_glass/enums/glass_enums.dart';
import 'package:universal_glass/theme/glass_color_palette.dart';
import 'package:universal_glass/utils/glass_input_utils.dart';
import 'package:universal_glass/utils/glass_text_formatter.dart';
import 'package:universal_glass/utils/glass_layout_calibrator.dart';
import 'package:universal_glass/utils/glass_theme_extension.dart';

class UniversalGlassTextFieldOutlined extends ConsumerStatefulWidget {
  // ========================================================================
  // CONTROLLERS
  // ========================================================================
  final TextEditingController controller;
  final FocusNode focusNode;
  // ========================================================================
  // TEXT
  // ========================================================================
  final String label;
  final String? hintText;
  // ========================================================================
  // ICONS
  // ========================================================================
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixTap;
  // ========================================================================
  // INPUT
  // ========================================================================
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  // ========================================================================
  // VALIDATION
  // ========================================================================
  final String? Function(String?)? validator;
  final AutovalidateMode autovalidateMode;
  // ========================================================================
  // CALLBACKS
  // ========================================================================
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  // ========================================================================
  // STATE
  // ========================================================================
  final bool enabled;
  final bool readOnly;
  // ========================================================================
  // DIMENSIONS
  // ========================================================================
  final double fieldHeight;
  final double fontSize;
  final double? iconSize;
  final double? iconInnerRatio;
  // ========================================================================
  // FORMAT
  // ========================================================================
  final GlassTextCase textCase;
  final List<TextInputFormatter>? inputFormatters;
  // ========================================================================
  // BACKDROP EFFECTS
  // ========================================================================
  final bool enableBackdropBlur;

  const UniversalGlassTextFieldOutlined({
    super.key,
    required this.controller,
    required this.focusNode,
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
    this.enabled = true,
    this.readOnly = false,
    this.fieldHeight = 58,
    this.fontSize = 16,
    this.iconSize,
    this.iconInnerRatio,
    this.textCase = GlassTextCase.normal,
    this.inputFormatters,
    this.enableBackdropBlur = true,
  });

  @override
  ConsumerState<UniversalGlassTextFieldOutlined> createState() => _UniversalGlassTextFieldOutlinedState();
}

class _UniversalGlassTextFieldOutlinedState extends ConsumerState<UniversalGlassTextFieldOutlined> {
  late OutlinedFieldController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = OutlinedFieldController(
      controller: widget.controller,
      focusNode: widget.focusNode,
      validator: widget.validator,
      autovalidateMode: widget.autovalidateMode,
      onUpdate: () => setState(() {}),
      obscureText: widget.obscureText,
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _handleSuffixTap() {
    if (widget.obscureText) {
      _ctrl.toggleObscure();
    } else {
      widget.onSuffixTap?.call();
    }
  }

  IconData? get _effectiveSuffixIcon {
    if (widget.obscureText) {
      return _ctrl.isObscured ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    }
    return widget.suffixIcon;
  }

   @override
Widget build(BuildContext context) {
  final glass = ref.watchGlassContext(context);
  final bool useAquaStyle = glass.theme.useAquaStyle;
  final palette = useAquaStyle ? GlassColorPalette.aquaPreset() : GlassColorPalette.classicPreset();
  final Color focusColor = useAquaStyle ? Colors.cyanAccent : palette.classicLight;
  
  final geo = GlassLayoutCalibrator(
    fieldHeight: widget.fieldHeight, 
    fontSize: widget.fontSize, 
    hasPrefixIcon: widget.prefixIcon != null,
  );
  
  final bool hasError = _ctrl.hasError;
  final bool isFocused = _ctrl.isFocused && widget.enabled;
  final bool hasText = widget.controller.text.isNotEmpty;
  final bool isFloating = isFocused || hasText;
  final Color textStyleColor = widget.enabled ? Colors.white : Colors.white.withValues(alpha: 0.35);
  final Color baseIconColor = hasError ? palette.error : (isFocused ? focusColor : palette.textSecondary.withValues(alpha: 0.7));
  final bool disableBackdropEffects = !widget.enableBackdropBlur;

  // FIX STABILITÉ : Calcul d'un padding horizontal fixe et invariant
  final double leftInternalPadding = widget.prefixIcon != null 
      ? (geo.isVeryCompact ? 2.0 : 4.0) 
      : 1.0;

  return Opacity(
    opacity: widget.enabled ? 1.0 : 0.65,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            ClipPath(
              clipper: isFloating ? NotchClipper(notchStart: geo.notchStart, notchWidth: geo.getLabelWidth(widget.label)) : null,
              child: GlassSurfaceContainer(
                decoration: glass.inputDecoration(hasError: hasError, isFocused: isFocused),
                style: glass.effectiveGlassStyle,
                shape: GlassShapeType.squareRounded,
                isFocused: isFocused,
                hasError: hasError,
                errorText: _ctrl.errorText,
                enabled: widget.enabled,
                disableBackdropEffects: disableBackdropEffects,
                clipBehavior: Clip.none,
                onTap: widget.enabled && !widget.readOnly ? () { widget.focusNode.requestFocus(); } : null,
                borderRadius: BorderRadius.circular(12),
                width: double.infinity,
                height: widget.fieldHeight,
                padding: const EdgeInsets.symmetric(horizontal: 12), // Aligné fixe à 12 horizontal
                liftOnHover: true,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // FIX : Suppression du Padding externe instable pour éliminer le doublement
                    if (widget.prefixIcon != null)
                      context.buildInputIcon(
                        icon: widget.prefixIcon!,
                        isActive: isFocused,
                        enabled: widget.enabled,
                        onTap: null,
                        color: baseIconColor,
                        fieldHeight: widget.fieldHeight,
                        bubbleRatio: geo.isVeryCompact ? 0.65 : 0.60,
                        iconRatio: widget.iconSize != null ? (widget.iconSize! / geo.iconSize) : 0.66,
                      ),
                    
                    // L'espace de séparation est désormais invariant
                    SizedBox(width: widget.prefixIcon != null ? (geo.isVeryCompact ? 8.0 : 12.0) : 0.0),
                    
                    Expanded(
                      child: TextField(
                        controller: widget.controller,
                        focusNode: widget.focusNode,
                        enabled: widget.enabled,
                        readOnly: widget.readOnly,
                        obscureText: _ctrl.isObscured,
                        keyboardType: widget.keyboardType,
                        textInputAction: widget.textInputAction,
                        textAlignVertical: TextAlignVertical.center,
                        style: TextStyle(color: textStyleColor, fontSize: geo.isVeryCompact ? 14 : widget.fontSize, fontWeight: FontWeight.w400, height: 1.0),
                        cursorColor: focusColor,
                        inputFormatters: [
                          if (widget.textCase == GlassTextCase.uppercase) GlassTextFormatter.uppercaseFormatter,
                          if (widget.textCase == GlassTextCase.lowercase) GlassTextFormatter.lowercaseFormatter,
                          if (widget.textCase == GlassTextCase.capitalize) GlassTextFormatter.capitalizeFormatter,
                          ...?widget.inputFormatters,
                        ],
                        decoration: InputDecoration(
                          isDense: true,
                          border: InputBorder.none,
                          // APPLICATION DU PADDING GAUCHE STABILISÉ ÉVITANT LES SPREADS INDÉSIRABLES
                          contentPadding: geo.contentPadding.copyWith(
                            left: leftInternalPadding,
                          ),
                          hintText: !isFloating ? null : widget.hintText,
                          hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.25), fontSize: geo.hintFontSize),
                        ),
                        onChanged: (val) {
                          widget.onChanged?.call(val);
                          if (widget.autovalidateMode == AutovalidateMode.onUserInteraction) {
                            _ctrl.validate(val);
                          }
                        },
                        onSubmitted: (val) {
                          _ctrl.validate(val);
                          widget.onSubmitted?.call(val);
                        },
                      ),
                    ),
                    if (_effectiveSuffixIcon != null) ...[
                      const SizedBox(width: 6),
                      context.buildInputIcon(
                        icon: _effectiveSuffixIcon!,
                        isActive: isFocused,
                        enabled: widget.enabled,
                        onTap: widget.enabled ? _handleSuffixTap : null,
                        color: baseIconColor,
                        fieldHeight: widget.fieldHeight,
                        bubbleRatio: geo.isVeryCompact ? 0.65 : 0.60,
                        iconRatio: widget.iconSize != null ? (widget.iconSize! / geo.iconSize) : 0.66,
                        showGlow: isFocused,
                      ),
                    ],
                  ],
                ),
              ),
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeInOutQuad,
              top: isFloating ? -8.5 : geo.labelTopAtRest,
              left: geo.getLabelLeft(isFloating),
              child: IgnorePointer(
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 180),
                  style: TextStyle(
                    color: (hasError && widget.enabled) ? palette.error : isFocused ? focusColor : Colors.white.withValues(alpha: widget.enabled ? (isFloating ? 0.6 : 0.4) : 0.20),
                    fontSize: isFloating ? 10.5 : (geo.isVeryCompact ? 14 : widget.fontSize),
                    fontWeight: isFloating ? FontWeight.w700 : FontWeight.w500,
                    letterSpacing: 0.2,
                    backgroundColor: Colors.transparent,
                  ),
                  child: Text(widget.label),
                ),
              ),
            ),
          ],
        ),
        if (hasError && widget.enabled)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 14),
            child: Text(_ctrl.errorText!, style: TextStyle(color: palette.error, fontSize: 12, fontWeight: FontWeight.w500)),
          ),
      ],
    ),
  );
}

  }