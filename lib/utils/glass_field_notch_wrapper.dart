import 'package:flutter/material.dart';
import 'package:universal_glass/components/surface/glass_field_notch.dart';
import 'package:universal_glass/components/surface/glass_notch_shadow_wrapper.dart';
import 'package:universal_glass/components/surface/glass_surface_container.dart';
import 'package:universal_glass/enums/glass_enums.dart';
import 'package:universal_glass/utils/glass_input_decoration.dart';
import 'package:universal_glass/utils/glass_input_state_style.dart'; // <- AJOUT
import 'package:universal_glass/utils/glass_layout_calibrator.dart';
import 'package:universal_glass/theme/glass_effects.dart';

class GlassFieldNotchWrapper extends StatelessWidget {
  final String label;
  final Widget child;
  final bool isFloating;
  final GlassInputStateStyle inputStyle; // <- REMPLACE hasFocus + state + focusColor
  final bool enabled;
  final double fieldHeight;
  final double fontSize;
  final BorderRadius borderRadius;
  final GlassInputDecoration decoration;
  final GlassLayoutCalibrator geo;
  final GlassStyle style;
  final GlassEffects effects;
  final GlassShapeType shape;
  final double? width;
  final String? helperText;

  const GlassFieldNotchWrapper({
    super.key,
    required this.label,
    required this.child,
    required this.isFloating,
    required this.inputStyle, // <- ICI
    required this.enabled,
    required this.fieldHeight,
    required this.fontSize,
    required this.borderRadius,
    required this.decoration,
    required this.geo,
    required this.style,
    required this.effects,
    required this.shape,
    this.width,
    this.helperText,
  });

  @override
  Widget build(BuildContext context) {
    // 1. TOUT VIENT DE inputStyle
    final double notchStart = geo.notchStart + (decoration.safeBorderWidth / 2);
    final double notchWidth = geo.getLabelWidth(label) + 12;

    final IconData? statusIcon = inputStyle.showError
        ? Icons.error_outline
        : inputStyle.showSuccess
            ? Icons.check_circle_outline
            : null;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: width,
          height: fieldHeight,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // 1. SURFACE + OMBRE
              GlassNotchShadowWrapper(
                clipper: null,
                isShadowEnabled: inputStyle.isActive, // <- MAJ
                shadowOpacity: inputStyle.hasError ? 0.4 : 0.35,
                elevation: 10,
                borderRadius: borderRadius,
                child: GlassSurfaceContainer(
                  decoration: decoration,
                  style: style,
                  effects: effects,
                  shape: shape,
                  isFocused: inputStyle.isFocused, // <- MAJ
                  hasError: inputStyle.hasError, // <- MAJ
                  enabled: enabled,
                  width: width,
                  height: fieldHeight,
                  borderRadius: borderRadius,
                  padding: EdgeInsets.fromLTRB(
                    decoration.safeHorizontalPadding + 2,
                    0,
                    decoration.safeHorizontalPadding,
                    0
                  ),
                  liftOnHover: inputStyle.showHover, // <- MAJ
                  child: Row(
                    children: [
                      Expanded(child: child),
                      if (statusIcon != null)
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Icon(statusIcon, size: 20, color: inputStyle.borderColor), // <- MAJ
                        ),
                    ],
                  ),
                ),
              ),

              // 2. NOTCH VISUEL
              if (isFloating)
                GlassFieldNotch(
                  notchStart: notchStart,
                  notchWidth: notchWidth,
                  color: decoration.color,
                  borderColor: inputStyle.borderColor, // <- MAJ
                  borderWidth: inputStyle.borderWidth, // <- MAJ
                  borderRadius: borderRadius,
                ),

              // 3. LABEL FLOTTANT
              if (isFloating)
                Positioned(
                  top: -13,
                  left: notchStart + 6,
                  child: IgnorePointer(
                    ignoring: true,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4),
                      decoration: BoxDecoration(
                        color: inputStyle.labelBackgroundColor, // <- MAJ: vient du style
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: inputStyle.effectiveLabelColor, // <- MAJ
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),

        // 4. HELPER TEXT
        if (helperText != null && helperText!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 14, right: 14),
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: 1.0,
              child: Text(
                helperText!,
                style: TextStyle(
                  color: inputStyle.showError // <- MAJ
                      ? decoration.errorColor 
                      : inputStyle.showSuccess 
                          ? Colors.greenAccent 
                          : decoration.hintColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
      ],
    );
  }


}