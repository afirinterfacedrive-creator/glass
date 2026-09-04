import 'package:flutter/material.dart';
import 'package:universal_glass/enums/glass_enums.dart';
import 'package:universal_glass/provider/glass_theme_provider.dart';
import 'package:universal_glass/theme/glass_effects.dart';

class GlassSurfaceConfig {
  final GlassStyle style;
  final GlassShapeType shape;
  final GlassEffects? effects;
  final GlassThemeState theme;
  final bool isFocused;
  final bool hasError;
  final bool enabled;
  final bool isHovered;
  final bool liftOnHover;
  
  // NOUVEAU: pour respecter la decoration
  final Color? borderColor;
  final Color? focusBorderColor;
  final double? borderWidth;
  final double? focusBorderWidth;

  final List<Color>? customColorsAqua;
  final List<Color>? customColorsClassic;
  final List<Color>? customGradient;
  final List<Color>? loadedGradient;
  final String? customKey;

  const GlassSurfaceConfig({
    required this.style,
    required this.shape,
    required this.effects,
    required this.theme,
    required this.isFocused,
    required this.hasError,
    required this.enabled,
    required this.isHovered,
    required this.liftOnHover,
    this.borderColor, // <- AJOUT
    this.focusBorderColor, // <- AJOUT
    this.borderWidth, // <- AJOUT
    this.focusBorderWidth, // <- AJOUT
    this.customColorsAqua,
    this.customColorsClassic,
    this.customGradient,
    this.loadedGradient,
    this.customKey,
  });
}