import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:universal_glass/provider/glass_color_provider_provider.dart';
import 'package:universal_glass/theme/glass_color_palette.dart';

import '../enums/glass_enums.dart';
import '../provider/glass_button_provider.dart';
import '../provider/glass_theme_provider.dart';
import '../theme/glass_effects.dart';

/// ============================================================================
/// CONFIGURATION COMMUNE DES BOUTONS GLASS
/// ============================================================================

const List<String> defaultGlassButtonIds = [
  'rotation',
  'notification',
  'volume',
  'brightness',
  'custom_unique',
];

/// ============================================================================
/// GLASS PANEL CONTROLLER
/// ============================================================================

class GlassPanelController {
  final WidgetRef ref;

  GlassPanelController(this.ref);

  // ==========================================================================
  // NOTIFIER DES BOUTONS
  // ==========================================================================

  GlassButtonNotifier get notifier {
    return ref.read(glassButtonProvider.notifier);
  }

  // ==========================================================================
  // THÈME GLASS
  // ==========================================================================

  GlassThemeState get theme {
    return ref.read(glassThemeProvider);
  }

  // ==========================================================================
  // PALETTE DE COULEURS GLASS
  // ==========================================================================

  GlassColorPalette get colors {
    return ref.read(glassColorProvider).palette;
  }

  // ==========================================================================
  // STYLE AQUA
  // ==========================================================================

  bool get useAquaStyle {
    return theme.useAquaStyle;
  }

  // ==========================================================================
  // STYLE GLASS ACTUEL
  // ==========================================================================

  GlassStyle get currentStyle {
    return theme.style;
  }

  // ==========================================================================
  // COULEURS DU STYLE ACTUEL
  // ==========================================================================

  Color get accentColor => useAquaStyle? colors.aqua : colors.classic;
  Color get accentLightColor => useAquaStyle? colors.aquaLight : colors.classicLight;
  Color get accentDarkColor => useAquaStyle? colors.aquaDark : colors.classicDark;

  // ==========================================================================
  // SURFACE / TEXTE / BORDURE
  // ==========================================================================

  Color get surfaceColor => colors.surface;
  Color get surfaceSecondaryColor => colors.surfaceSecondary;
  Color get textPrimaryColor => colors.textPrimary;
  Color get textSecondaryColor => colors.textSecondary;
  Color get textTertiaryColor => colors.textTertiary;
  Color get textDisabledColor => colors.textDisabled;
  Color get borderColor => colors.border;

  // ==========================================================================
  // ÉTATS
  // ==========================================================================

  Color get successColor => colors.success;
  Color get warningColor => colors.warning;
  Color get errorColor => colors.error;
  Color get infoColor => colors.info;

  // ==========================================================================
  // EFFET GLASS ACTUEL
  // ==========================================================================
  ///
  /// AQUA = liquidAqua avec gradient
  /// CLASSIC = classic SANS gradient pour les previews
  /// ==========================================================================

  GlassEffects get containerEffect {
    if (useAquaStyle) {
      return GlassEffects.liquidAqua(colors);
    }
    return GlassEffects.classic; // <-- FIX: plus de gradient
  }

  // ==========================================================================
  // EFFETS PRÉDÉFINIS
  // ==========================================================================

  GlassEffects get aquaEffect => GlassEffects.liquidAqua(colors);
  GlassEffects get classicEffect => GlassEffects.classic; // <-- FIX
  GlassEffects get blueEffect => GlassEffects.liquidBlue(colors);
  GlassEffects get redEffect => GlassEffects.liquidRed(colors);
  GlassEffects get greenEffect => GlassEffects.liquidGreen(colors);
  GlassEffects get amberEffect => GlassEffects.liquidAmber(colors);
  GlassEffects get darkEffect => GlassEffects.liquidDark(colors);
  GlassEffects get whiteEffect => GlassEffects.liquidWhite(colors);

  // ==========================================================================
  // INITIALISATION DES BOUTONS
  // ==========================================================================

  void initialize() {
    for (final String id in defaultGlassButtonIds) {
      notifier.initButton(id, false);
    }
  }

  // ==========================================================================
  // CHANGEMENT DU STYLE
  // ==========================================================================

  Future<void> changeStyle(bool value) async {
    await ref.read(glassThemeProvider.notifier).setAquaStyle(value);
  }

  Future<void> toggleStyle() async {
    await ref.read(glassThemeProvider.notifier).toggleAquaStyle();
  }

  Future<void> resetTheme() async {
    await ref.read(glassThemeProvider.notifier).reset();
  }

  // ==========================================================================
  // ÉTAT DES BOUTONS
  // ==========================================================================

  GlassButtonState stateOf(String buttonId) {
    return ref.watch(glassButtonProvider.select((state) => state[buttonId]?? const GlassButtonState()));
  }

  bool isActive(String buttonId) {
    return ref.read(glassButtonProvider)[buttonId]?.isActive?? false;
  }

  bool isLoading(String buttonId) {
    return ref.read(glassButtonProvider)[buttonId]?.isLoading?? false;
  }

  String? customText(String buttonId) {
    return ref.read(glassButtonProvider)[buttonId]?.customText;
  }

  void toggle(String buttonId) => notifier.toggleActive(buttonId);
  void activate(String buttonId) => notifier.setActive(buttonId, true);
  void deactivate(String buttonId) => notifier.setActive(buttonId, false);

  void resetButton(String buttonId, {bool active = false}) {
    notifier.resetButton(buttonId, active: active);
  }
}