
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:universal_glass/glass.dart';

import 'appearance_settings.dart';

/// ============================================================================
/// APPEARANCE CONTROLLER
/// ============================================================================
class AppearanceController {
  final WidgetRef ref;
  AppearanceController(this.ref);

  // ==========================================================================
  // STORAGE KEYS
  // ==========================================================================
  static const String themeModeKey = 'theme_mode';
  static const String glassStyleKey = 'appearance_glass_style'; // <-- AJOUT

  static const String aquaGradientKey = 'appbar_gradient_aqua';
  static const String classicGradientKey = 'appbar_gradient_classic';

  static const String blurEnabledKey = 'appearance_enable_blur';
  static const String blurKey = 'appearance_blur';

  static const String noiseEnabledKey = 'appearance_enable_noise';
  static const String noiseKey = 'appearance_noise';

  static const String gradientEnabledKey = 'appearance_enable_gradient';
  static const String gradientOpacityKey = 'appearance_gradient_opacity';
  static const String gradientDensityKey = 'appearance_gradient_density';

  static const String surfaceOpacityKey = 'appearance_surface_opacity';
  static const String borderRadiusKey = 'appearance_border_radius';

  static const String borderEnabledKey = 'appearance_enable_border';
  static const String borderOpacityKey = 'appearance_border_opacity';
  static const String borderWidthKey = 'appearance_border_width';

  static const String glowEnabledKey = 'appearance_enable_glow';
  static const String glowOpacityKey = 'appearance_glow_opacity';
  static const String glowBlurKey = 'appearance_glow_blur';

  static const String hoverEnabledKey = 'appearance_enable_hover';
  static const String hoverLiftKey = 'appearance_hover_lift';

  static const String shadowEnabledKey = 'appearance_enable_shadow';
  static const String shadowOpacityKey = 'appearance_shadow_opacity';
  static const String shadowBlurKey = 'appearance_shadow_blur';
  static const String shadowOffsetYKey = 'appearance_shadow_offset_y';

  // ==========================================================================
  // DEFAULT COLORS
  // ==========================================================================
  static const List<Color> defaultAquaColors = [
    Color(0xFF4DD0E1),
    Color(0xFF00BCD4),
  ];

  static const List<Color> defaultClassicColors = [
    Color(0xFF121212),
    Color(0xFF1A1A1A),
  ];

  // ==========================================================================
  // DEFAULT SETTINGS
  // ==========================================================================
  AppearanceSettings get defaults {
    return const AppearanceSettings(
      themeMode: AppThemeMode.aqua,
      glassStyle: GlassStyle.transparentAqua, // <-- AJOUT

      aquaColors: defaultAquaColors,
      classicColors: defaultClassicColors,

      enableBlur: true,
      blur: 12.0,

      enableNoise: false,
      noise: 0.0,

      enableGradient: true,
      gradientOpacity: 1.0,
      gradientDensity: 2,

      surfaceOpacity: 1.0,
      borderRadius: 20.0,

      enableBorder: true,
      borderOpacity: 0.18,
      borderWidth: 0.72,

      enableGlow: true,
      glowOpacity: 0.18,
      glowBlur: 18.0,

      enableHover: true,
      hoverLift: 3.0,

      enableShadow: true,
      shadowOpacity: 0.18,
      shadowBlur: 12.0,
      shadowOffsetY: 7.0,
    );
  }

  // ==========================================================================
  // LOAD
  // ==========================================================================
  Future<AppearanceSettings> load() async {
    final List<Color>? aqua = await GlassColorStorage.loadColorList(aquaGradientKey);
    final List<Color>? classic = await GlassColorStorage.loadColorList(classicGradientKey);
    final String? savedMode = await GlassColorStorage.loadString(themeModeKey);
    final String? savedStyle = await GlassColorStorage.loadString(glassStyleKey); // <-- LOAD STYLE

    final AppThemeMode themeMode = _parseThemeMode(savedMode);
    final GlassStyle glassStyle = _parseGlassStyle(savedStyle); // <-- PARSE STYLE

    final settings = defaults.copyWith(
      themeMode: themeMode,
      glassStyle: glassStyle, // <-- APPLIQUE STYLE

      aquaColors: aqua?? defaults.aquaColors,
      classicColors: classic?? defaults.classicColors,

      enableBlur: await _loadBool(blurEnabledKey)?? defaults.enableBlur,
      blur: await _loadDouble(blurKey)?? defaults.blur,

      enableNoise: await _loadBool(noiseEnabledKey)?? defaults.enableNoise,
      noise: await _loadDouble(noiseKey)?? defaults.noise,

      enableGradient: await _loadBool(gradientEnabledKey)?? defaults.enableGradient,
      gradientOpacity: await _loadDouble(gradientOpacityKey)?? defaults.gradientOpacity,
      gradientDensity: await _loadInt(gradientDensityKey)?? defaults.gradientDensity,

      surfaceOpacity: await _loadDouble(surfaceOpacityKey)?? defaults.surfaceOpacity,
      borderRadius: await _loadDouble(borderRadiusKey)?? defaults.borderRadius,

      enableBorder: await _loadBool(borderEnabledKey)?? defaults.enableBorder,
      borderOpacity: await _loadDouble(borderOpacityKey)?? defaults.borderOpacity,
      borderWidth: await _loadDouble(borderWidthKey)?? defaults.borderWidth,

      enableGlow: await _loadBool(glowEnabledKey)?? defaults.enableGlow,
      glowOpacity: await _loadDouble(glowOpacityKey)?? defaults.glowOpacity,
      glowBlur: await _loadDouble(glowBlurKey)?? defaults.glowBlur,

      enableHover: await _loadBool(hoverEnabledKey)?? defaults.enableHover,
      hoverLift: await _loadDouble(hoverLiftKey)?? defaults.hoverLift,

      enableShadow: await _loadBool(shadowEnabledKey)?? defaults.enableShadow,
      shadowOpacity: await _loadDouble(shadowOpacityKey)?? defaults.shadowOpacity,
      shadowBlur: await _loadDouble(shadowBlurKey)?? defaults.shadowBlur,
      shadowOffsetY: await _loadDouble(shadowOffsetYKey)?? defaults.shadowOffsetY,
    );

    // Sync avec le provider au démarrage
    await ref.read(glassThemeProvider.notifier).setGlassStyle(settings.glassStyle);

    return settings;
  }

  // ==========================================================================
  // APPLY
  // ==========================================================================
  Future<void> apply(AppearanceSettings settings) async {
    final notifier = ref.read(glassThemeProvider.notifier);

    // ------------------------------------------------------------------------
    // MODE + STYLE
    // ------------------------------------------------------------------------
    await GlassColorStorage.saveString(themeModeKey, settings.themeMode.name);
    await GlassColorStorage.saveString(glassStyleKey, settings.glassStyle.name); // <-- SAVE STYLE
    await notifier.setGlassStyle(settings.glassStyle); // <-- SYNC PROVIDER

    // ------------------------------------------------------------------------
    // COULEURS
    // ------------------------------------------------------------------------
    await GlassColorStorage.saveColorList(aquaGradientKey, settings.aquaColors);
    await GlassColorStorage.saveColorList(classicGradientKey, settings.classicColors);

    // ------------------------------------------------------------------------
    // AQUA / CLASSIC / SAGE
    // ------------------------------------------------------------------------
    final bool isAqua = settings.themeMode == AppThemeMode.aqua;
    final bool isSage = settings.isSage;

    if (isSage) {
      notifier.setAquaStyle(false);
      notifier.setEnableGradient(false);
    } else {
      notifier.setAquaStyle(isAqua);
      notifier.setEnableGradient(settings.enableGradient);
    }

    // ------------------------------------------------------------------------
    // GRADIENTS + BLUR + NOISE
    // ------------------------------------------------------------------------
    notifier.setAquaGradient(settings.aquaColors);
    notifier.setClassicGradient(settings.classicColors);
    notifier.setEnableBlur(settings.enableBlur);
    notifier.setBlur(settings.blur);
    notifier.setEnableNoise(settings.enableNoise);
    notifier.setNoise(settings.noise);

    // ------------------------------------------------------------------------
    // PERSISTENCE
    // ------------------------------------------------------------------------
    await _saveSettings(settings);
  }

  // ==========================================================================
  // UPDATE / CHANGE THEME MODE / COLORS / RESET - IDENTIQUE
  // ==========================================================================
  Future<AppearanceSettings> update(
    AppearanceSettings settings,
    AppearanceSettings Function(AppearanceSettings settings) change,
  ) async {
    final AppearanceSettings updated = change(settings);
    await apply(updated);
    return updated;
  }

  Future<AppearanceSettings> changeThemeMode(
    AppearanceSettings settings,
    AppThemeMode mode,
  ) async {
    final AppearanceSettings updated = settings.copyWith(themeMode: mode);
    await apply(updated);
    return updated;
  }

  Future<AppearanceSettings> setAquaColors(
    AppearanceSettings settings,
    List<Color> colors,
  ) async {
    final AppearanceSettings updated = settings.copyWith(aquaColors: List<Color>.from(colors));
    await apply(updated);
    return updated;
  }

  Future<AppearanceSettings> setClassicColors(
    AppearanceSettings settings,
    List<Color> colors,
  ) async {
    final AppearanceSettings updated = settings.copyWith(classicColors: List<Color>.from(colors));
    await apply(updated);
    return updated;
  }

  Future<AppearanceSettings> setColor(
    AppearanceSettings settings, {
    required int index,
    required Color color,
    required bool aqua,
  }) async {
    final List<Color> colors = List<Color>.from(aqua? settings.aquaColors : settings.classicColors);
    if (index < 0 || index >= colors.length) return settings;
    colors[index] = color;
    if (aqua) return setAquaColors(settings, colors);
    return setClassicColors(settings, colors);
  }

  Future<AppearanceSettings> reset() async {
    final AppearanceSettings settings = defaults;
    await apply(settings);
    return settings;
  }

  // ==========================================================================
  // SAVE SETTINGS
  // ==========================================================================
  Future<void> _saveSettings(AppearanceSettings settings) async {
    await _saveBool(blurEnabledKey, settings.enableBlur);
    await _saveDouble(blurKey, settings.blur);
    await _saveBool(noiseEnabledKey, settings.enableNoise);
    await _saveDouble(noiseKey, settings.noise);
    await _saveBool(gradientEnabledKey, settings.enableGradient);
    await _saveDouble(gradientOpacityKey, settings.gradientOpacity);
    await _saveInt(gradientDensityKey, settings.gradientDensity);
    await _saveDouble(surfaceOpacityKey, settings.surfaceOpacity);
    await _saveDouble(borderRadiusKey, settings.borderRadius);
    await _saveBool(borderEnabledKey, settings.enableBorder);
    await _saveDouble(borderOpacityKey, settings.borderOpacity);
    await _saveDouble(borderWidthKey, settings.borderWidth);
    await _saveBool(glowEnabledKey, settings.enableGlow);
    await _saveDouble(glowOpacityKey, settings.glowOpacity);
    await _saveDouble(glowBlurKey, settings.glowBlur);
    await _saveBool(hoverEnabledKey, settings.enableHover);
    await _saveDouble(hoverLiftKey, settings.hoverLift);
    await _saveBool(shadowEnabledKey, settings.enableShadow);
    await _saveDouble(shadowOpacityKey, settings.shadowOpacity);
    await _saveDouble(shadowBlurKey, settings.shadowBlur);
    await _saveDouble(shadowOffsetYKey, settings.shadowOffsetY);
  }

  // ==========================================================================
  // STORAGE HELPERS
  // ==========================================================================
  Future<bool?> _loadBool(String key) async {
    final String? value = await GlassColorStorage.loadString(key);
    if (value == null) return null;
    switch (value.toLowerCase()) {
      case 'true': return true;
      case 'false': return false;
      default: return null;
    }
  }

  Future<double?> _loadDouble(String key) async {
    final String? value = await GlassColorStorage.loadString(key);
    if (value == null) return null;
    return double.tryParse(value);
  }

  Future<int?> _loadInt(String key) async {
    final String? value = await GlassColorStorage.loadString(key);
    if (value == null) return null;
    return int.tryParse(value);
  }

  Future<void> _saveBool(String key, bool value) async {
    await GlassColorStorage.saveString(key, value.toString());
  }

  Future<void> _saveDouble(String key, double value) async {
    await GlassColorStorage.saveString(key, value.toString());
  }

  Future<void> _saveInt(String key, int value) async {
    await GlassColorStorage.saveString(key, value.toString());
  }

  // ==========================================================================
  // PARSERS
  // ==========================================================================
  AppThemeMode _parseThemeMode(String? value) {
    if (value == null) return AppThemeMode.aqua;
    return AppThemeMode.values.byName(value);
  }

  GlassStyle _parseGlassStyle(String? value) { // <-- AJOUT
    if (value == null) return GlassStyle.transparentAqua;
    try {
      return GlassStyle.values.byName(value);
    } catch (_) {
      return GlassStyle.transparentAqua;
    }
  }
}