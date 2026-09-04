import 'package:flutter/material.dart';
import 'package:universal_glass/components/inputs/fieldoutlined/outlined_field_decoration.dart';

import 'package:universal_glass/components/surface/glass_notch_shadow_wrapper.dart';
import 'package:universal_glass/components/surface/glass_surface_container.dart';
import 'package:universal_glass/utils/glass_layout_calibrator.dart';

import '../../../enums/glass_enums.dart';
import '../glass_input_decoration.dart';


class PhoneInputVisual extends StatelessWidget {
  final Widget countrySelector;
  final Widget textField;

  final String label;

  final bool isFloating;
  final bool hasError;
  final bool hasFocus;
  final bool enabled;

  final Color focusColor;
  final Color errorColor;

  final GlassInputDecoration decoration;
  final GlassStyle style;
  final GlassShapeType shape;

  final double? width;
  final double fieldHeight;

  final bool enableShadow;
  final double shadowOpacity;

  final GlassLayoutCalibrator calibrator;

  const PhoneInputVisual({
    super.key,
    required this.countrySelector,
    required this.textField,
    required this.label,
    required this.isFloating,
    required this.hasError,
    required this.hasFocus,
    required this.enabled,
    required this.focusColor,
    required this.errorColor,
    required this.decoration,
    required this.style,
    required this.shape,
    required this.width,
    required this.fieldHeight,
    required this.enableShadow,
    required this.shadowOpacity,
    required this.calibrator,
  });

  @override
  Widget build(BuildContext context) {
    // =======================================================================
    // NOTCH
    // =======================================================================

    final NotchClipper? notchClipper = isFloating
        ? NotchClipper(
            notchStart: calibrator.notchStart,
            notchWidth: calibrator.getLabelWidth(label),
          )
        : null;

    // =======================================================================
    // CONTENU
    // =======================================================================

    final Widget content = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        countrySelector,

        const SizedBox(width: 12),

        Expanded(
          child: calibrator.translateTextVertically(
            textField,
          ),
        ),
      ],
    );

    // =======================================================================
    // SURFACE
    // =======================================================================

    final Widget surface = GlassNotchShadowWrapper(
      clipper: notchClipper,

      isShadowEnabled:
          isFloating && enableShadow,

      shadowOpacity: shadowOpacity,

      elevation: 6.0,

      borderRadius: BorderRadius.circular(
        decoration.borderRadius,
      ),

      child: GlassSurfaceContainer(
        decoration: decoration,

        style: style,

        shape: shape,

        width: width,

        height: fieldHeight,

        borderRadius: BorderRadius.circular(
          decoration.borderRadius,
        ),

        // IMPORTANT :
        // La surface ne capture aucun tap.
        onTap: null,

        padding: const EdgeInsets.symmetric(
          horizontal: 14,
        ),

        liftOnHover: !hasFocus,

        disableShadow: true,

        clipBehavior: Clip.none,

        child: content,
      ),
    );

    // =======================================================================
    // RENDU
    // =======================================================================

    return Stack(
      clipBehavior: Clip.none,
      children: [
        surface,

        // ===================================================================
        // LABEL
        // ===================================================================

        AnimatedPositioned(
          duration: const Duration(
            milliseconds: 180,
          ),

          curve: Curves.easeInOutQuad,

          top: isFloating
              ? -8.5
              : calibrator.labelTopAtRest,

          left: calibrator.getLabelLeft(
            isFloating,
          ),

          child: IgnorePointer(
            child: AnimatedOpacity(
              duration: const Duration(
                milliseconds: 140,
              ),

              opacity: isFloating ? 1.0 : 0.0,

              child: AnimatedDefaultTextStyle(
                duration: const Duration(
                  milliseconds: 180,
                ),

                style: TextStyle(
                  color: hasError
                      ? errorColor
                      : hasFocus
                          ? focusColor
                          : Colors.white.withValues(
                              alpha: enabled
                                  ? (isFloating ? 0.6 : 0.4)
                                  : 0.20,
                            ),

                  fontSize: isFloating
                      ? 10.5
                      : (calibrator.isVeryCompact
                          ? 14
                          : decoration.fontSize),

                  fontWeight: isFloating
                      ? FontWeight.w700
                      : FontWeight.w500,

                  letterSpacing: 0.2,

                  backgroundColor:
                      Colors.transparent,
                ),

                child: Text(label),
              ),
            ),
          ),
        ),
      ],
    );
  }
}