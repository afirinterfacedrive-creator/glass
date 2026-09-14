import 'package:universal_glass/glass.dart';
import 'package:universal_glass_example/settings/widgets/appearance/glass_style_adapter.dart';
import 'package:universal_glass_example/settings/widgets/appearance/models/appearance_input_settings.dart';

extension GlassLayoutContextToInputStyle on GlassLayoutContext {
  /// Convertit le contexte global en GlassInputStyle
  GlassInputStyle toInputStyle({
    double fieldHeight = 48,
    double fontSize = 14,
    GlassShapeType shape = GlassShapeType.pill,
  }) {
    final t = theme; // GlassThemeState

    // 1. Calcul des valeurs "effectives"
    final blur = t.enableBlur ? t.blur : 0.0;
    final borderOpacity = t.enableBorder ? t.borderOpacity : 0.0;
    final borderWidth = t.enableBorder ? t.borderWidth : 0.0;
    final shadowOpacity = t.enableShadow ? t.shadowOpacity : 0.0;
    final shadowBlur = t.enableShadow ? t.shadowBlur : 0.0;
    final shadowOffsetY = t.enableShadow ? t.shadowOffsetY : 0.0;
    final hoverLift = t.enableHover ? t.hoverLift : 0.0;

    // 2. Calcul backgroundOpacity selon le style
    double backgroundOpacity;
    switch (t.effectiveGlassStyle) {
      case GlassStyle.opaqueMat:
        backgroundOpacity = 0.95;
        break;
      case GlassStyle.opaqueHeavy:
        backgroundOpacity = 0.98;
        break;
      case GlassStyle.solidAqua:
      case GlassStyle.solidClassic:
      case GlassStyle.gradientOpaque:
        backgroundOpacity = 0.75;
        break;
      case GlassStyle.transparentAqua:
      case GlassStyle.transparentRed:
      case GlassStyle.transparentGreen:
        backgroundOpacity = 0.08;
        break;
      case GlassStyle.classicSb:
        backgroundOpacity = 0.10;
        break;
      case GlassStyle.custom:
      case GlassStyle.customGradient:
      // ignore: unreachable_switch_default
      default:
        backgroundOpacity = t.surfaceOpacity; // fallback sur le global
    }

    return AppearanceInputSettings(
      fieldHeight: fieldHeight,
      horizontalPadding: 16,
      verticalPadding: 12,
      borderRadius: t.borderRadius,
      blur: blur,
      backgroundOpacity: backgroundOpacity, // <- ICI
      enableBorder: t.enableBorder,
      borderOpacity: borderOpacity,
      borderWidth: borderWidth,
      enabled: true,
    ).toGlassStyle().copyWith(
      fieldHeight: fieldHeight,
      fontSize: fontSize,
      enableHover: t.enableHover,
      hoverLift: hoverLift,
      enableShadow: t.enableShadow,
      shadowOpacity: shadowOpacity,
      shadowBlur: shadowBlur,
      shadowOffsetY: shadowOffsetY,
      shape: shape,
    );
  }
}