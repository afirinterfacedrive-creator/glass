import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:universal_glass/glass.dart';
import 'package:universal_glass_example/settings/widgets/appearance/appearance_settings.dart';



/// ============================================================================
/// APPEARANCE CONTROLLER
/// ============================================================================
///
/// Contrôleur de la configuration Appearance.
///
/// Le contrôleur est utilisé depuis un widget ConsumerState.
/// Il reçoit donc WidgetRef.
///
/// Le GlassThemeNotifier, lui, continue normalement d'utiliser Ref en interne.
///
class AppearanceController {
  final WidgetRef ref;

  AppearanceController(this.ref);

  // ==========================================================================
  // STORAGE KEYS
  // ==========================================================================

  static const String themeModeKey = 'theme_mode';

  static const String aquaGradientKey =
      'appbar_gradient_aqua';

  static const String classicGradientKey =
      'appbar_gradient_classic';

  static const String blurEnabledKey =
      'appearance_enable_blur';

  static const String blurKey =
      'appearance_blur';

  static const String noiseEnabledKey =
      'appearance_enable_noise';

  static const String noiseKey =
      'appearance_noise';

  static const String gradientEnabledKey =
      'appearance_enable_gradient';

  static const String gradientOpacityKey =
      'appearance_gradient_opacity';

  static const String gradientDensityKey =
      'appearance_gradient_density';

  static const String surfaceOpacityKey =
      'appearance_surface_opacity';

  static const String borderRadiusKey =
      'appearance_border_radius';

  static const String borderEnabledKey =
      'appearance_enable_border';

  static const String borderOpacityKey =
      'appearance_border_opacity';

  static const String borderWidthKey =
      'appearance_border_width';

  static const String glowEnabledKey =
      'appearance_enable_glow';

  static const String glowOpacityKey =
      'appearance_glow_opacity';

  static const String glowBlurKey =
      'appearance_glow_blur';

  static const String hoverEnabledKey =
      'appearance_enable_hover';

  static const String hoverLiftKey =
      'appearance_hover_lift';

  static const String shadowEnabledKey =
      'appearance_enable_shadow';

  static const String shadowOpacityKey =
      'appearance_shadow_opacity';

  static const String shadowBlurKey =
      'appearance_shadow_blur';

  static const String shadowOffsetYKey =
      'appearance_shadow_offset_y';

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
    final List<Color>? aqua =
        await GlassColorStorage.loadColorList(
      aquaGradientKey,
    );

    final List<Color>? classic =
        await GlassColorStorage.loadColorList(
      classicGradientKey,
    );

    final String? savedMode =
        await GlassColorStorage.loadString(
      themeModeKey,
    );

    final bool? enableBlur =
        await _loadBool(blurEnabledKey);

    final double? blur =
        await _loadDouble(blurKey);

    final bool? enableNoise =
        await _loadBool(noiseEnabledKey);

    final double? noise =
        await _loadDouble(noiseKey);

    final bool? enableGradient =
        await _loadBool(gradientEnabledKey);

    final double? gradientOpacity =
        await _loadDouble(gradientOpacityKey);

    final int? gradientDensity =
        await _loadInt(gradientDensityKey);

    final double? surfaceOpacity =
        await _loadDouble(surfaceOpacityKey);

    final double? borderRadius =
        await _loadDouble(borderRadiusKey);

    final bool? enableBorder =
        await _loadBool(borderEnabledKey);

    final double? borderOpacity =
        await _loadDouble(borderOpacityKey);

    final double? borderWidth =
        await _loadDouble(borderWidthKey);

    final bool? enableGlow =
        await _loadBool(glowEnabledKey);

    final double? glowOpacity =
        await _loadDouble(glowOpacityKey);

    final double? glowBlur =
        await _loadDouble(glowBlurKey);

    final bool? enableHover =
        await _loadBool(hoverEnabledKey);

    final double? hoverLift =
        await _loadDouble(hoverLiftKey);

    final bool? enableShadow =
        await _loadBool(shadowEnabledKey);

    final double? shadowOpacity =
        await _loadDouble(shadowOpacityKey);

    final double? shadowBlur =
        await _loadDouble(shadowBlurKey);

    final double? shadowOffsetY =
        await _loadDouble(shadowOffsetYKey);

    return defaults.copyWith(
      themeMode: _parseThemeMode(savedMode),

      aquaColors:
          aqua ?? defaults.aquaColors,

      classicColors:
          classic ?? defaults.classicColors,

      enableBlur:
          enableBlur ?? defaults.enableBlur,

      blur:
          blur ?? defaults.blur,

      enableNoise:
          enableNoise ?? defaults.enableNoise,

      noise:
          noise ?? defaults.noise,

      enableGradient:
          enableGradient ?? defaults.enableGradient,

      gradientOpacity:
          gradientOpacity ?? defaults.gradientOpacity,

      gradientDensity:
          gradientDensity ?? defaults.gradientDensity,

      surfaceOpacity:
          surfaceOpacity ?? defaults.surfaceOpacity,

      borderRadius:
          borderRadius ?? defaults.borderRadius,

      enableBorder:
          enableBorder ?? defaults.enableBorder,

      borderOpacity:
          borderOpacity ?? defaults.borderOpacity,

      borderWidth:
          borderWidth ?? defaults.borderWidth,

      enableGlow:
          enableGlow ?? defaults.enableGlow,

      glowOpacity:
          glowOpacity ?? defaults.glowOpacity,

      glowBlur:
          glowBlur ?? defaults.glowBlur,

      enableHover:
          enableHover ?? defaults.enableHover,

      hoverLift:
          hoverLift ?? defaults.hoverLift,

      enableShadow:
          enableShadow ?? defaults.enableShadow,

      shadowOpacity:
          shadowOpacity ?? defaults.shadowOpacity,

      shadowBlur:
          shadowBlur ?? defaults.shadowBlur,

      shadowOffsetY:
          shadowOffsetY ?? defaults.shadowOffsetY,
    );
  }

  // ==========================================================================
  // APPLY
  // ==========================================================================

  Future<void> apply(
    AppearanceSettings settings,
  ) async {
    final notifier =
        ref.read(glassThemeProvider.notifier);

    final bool isSage =
        settings.isSage;

    final bool useAqua =
        settings.isAqua;

    // ------------------------------------------------------------------------
    // MODE
    // ------------------------------------------------------------------------

    await GlassColorStorage.saveString(
      themeModeKey,
      settings.themeMode.name,
    );

    // ------------------------------------------------------------------------
    // COLORS
    // ------------------------------------------------------------------------

    await GlassColorStorage.saveColorList(
      aquaGradientKey,
      settings.aquaColors,
    );

    await GlassColorStorage.saveColorList(
      classicGradientKey,
      settings.classicColors,
    );

    // ------------------------------------------------------------------------
    // STYLE GLOBAL
    // ------------------------------------------------------------------------

    await notifier.setAquaStyle(
      useAqua,
    );

    // ------------------------------------------------------------------------
    // GRADIENT
    // ------------------------------------------------------------------------

    await notifier.setEnableGradient(
      isSage
          ? false
          : settings.enableGradient,
    );

    await notifier.setAquaGradient(
      settings.aquaColors,
    );

    await notifier.setClassicGradient(
      settings.classicColors,
    );

    await notifier.setGradientDensity(
      settings.gradientDensity,
    );

    await notifier.setGradientOpacity(
      settings.gradientOpacity,
    );

    // ------------------------------------------------------------------------
    // BLUR
    // ------------------------------------------------------------------------

    await notifier.setEnableBlur(
      isSage
          ? false
          : settings.enableBlur,
    );

    await notifier.setBlur(
      isSage
          ? 0.0
          : settings.blur,
    );

    // ------------------------------------------------------------------------
    // NOISE
    // ------------------------------------------------------------------------

    await notifier.setEnableNoise(
      isSage
          ? false
          : settings.enableNoise,
    );

    await notifier.setNoise(
      isSage
          ? 0.0
          : settings.noise,
    );

    // ------------------------------------------------------------------------
    // AUTRES PARAMÈTRES
    // ------------------------------------------------------------------------

    await _saveSettings(settings);
  }

  // ==========================================================================
  // APPLY + RETURN
  // ==========================================================================

  Future<AppearanceSettings> applyAndReturn(
    AppearanceSettings settings,
  ) async {
    await apply(settings);
    return settings;
  }

  // ==========================================================================
  // UPDATE
  // ==========================================================================

  Future<AppearanceSettings> update(
    AppearanceSettings settings,
    AppearanceSettings Function(
      AppearanceSettings settings,
    ) change,
  ) async {
    final AppearanceSettings updated =
        change(settings);

    await apply(updated);

    return updated;
  }

  // ==========================================================================
  // CHANGE MODE
  // ==========================================================================

  Future<AppearanceSettings> changeThemeMode(
    AppearanceSettings settings,
    AppThemeMode mode,
  ) async {
    return update(
      settings,
      (current) => current.copyWith(
        themeMode: mode,
      ),
    );
  }

  // ==========================================================================
  // COLOR
  // ==========================================================================

  Future<AppearanceSettings> setColor(
    AppearanceSettings settings, {
    required int index,
    required Color color,
    required bool aqua,
  }) async {
    final List<Color> colors = List<Color>.from(
      aqua
          ? settings.aquaColors
          : settings.classicColors,
    );

    if (index < 0 || index >= colors.length) {
      return settings;
    }

    colors[index] = color;

    final AppearanceSettings updated =
        aqua
            ? settings.copyWith(
                aquaColors: colors,
              )
            : settings.copyWith(
                classicColors: colors,
              );

    await apply(updated);

    return updated;
  }

  // ==========================================================================
  // RESET
  // ==========================================================================

  Future<AppearanceSettings> reset() async {
    final AppearanceSettings settings =
        defaults;

    await apply(settings);

    return settings;
  }

  // ==========================================================================
  // SAVE
  // ==========================================================================

  Future<void> _saveSettings(
    AppearanceSettings settings,
  ) async {
    await _saveBool(
      blurEnabledKey,
      settings.enableBlur,
    );

    await _saveDouble(
      blurKey,
      settings.blur,
    );

    await _saveBool(
      noiseEnabledKey,
      settings.enableNoise,
    );

    await _saveDouble(
      noiseKey,
      settings.noise,
    );

    await _saveBool(
      gradientEnabledKey,
      settings.enableGradient,
    );

    await _saveDouble(
      gradientOpacityKey,
      settings.gradientOpacity,
    );

    await _saveInt(
      gradientDensityKey,
      settings.gradientDensity,
    );

    await _saveDouble(
      surfaceOpacityKey,
      settings.surfaceOpacity,
    );

    await _saveDouble(
      borderRadiusKey,
      settings.borderRadius,
    );

    await _saveBool(
      borderEnabledKey,
      settings.enableBorder,
    );

    await _saveDouble(
      borderOpacityKey,
      settings.borderOpacity,
    );

    await _saveDouble(
      borderWidthKey,
      settings.borderWidth,
    );

    await _saveBool(
      glowEnabledKey,
      settings.enableGlow,
    );

    await _saveDouble(
      glowOpacityKey,
      settings.glowOpacity,
    );

    await _saveDouble(
      glowBlurKey,
      settings.glowBlur,
    );

    await _saveBool(
      hoverEnabledKey,
      settings.enableHover,
    );

    await _saveDouble(
      hoverLiftKey,
      settings.hoverLift,
    );

    await _saveBool(
      shadowEnabledKey,
      settings.enableShadow,
    );

    await _saveDouble(
      shadowOpacityKey,
      settings.shadowOpacity,
    );

    await _saveDouble(
      shadowBlurKey,
      settings.shadowBlur,
    );

    await _saveDouble(
      shadowOffsetYKey,
      settings.shadowOffsetY,
    );
  }

  // ==========================================================================
  // STORAGE HELPERS
  // ==========================================================================

  Future<bool?> _loadBool(String key) async {
    final String? value =
        await GlassColorStorage.loadString(key);

    if (value == null) {
      return null;
    }

    switch (value.toLowerCase()) {
      case 'true':
        return true;

      case 'false':
        return false;

      default:
        return null;
    }
  }

  Future<double?> _loadDouble(String key) async {
    final String? value =
        await GlassColorStorage.loadString(key);

    if (value == null) {
      return null;
    }

    return double.tryParse(value);
  }

  Future<int?> _loadInt(String key) async {
    final String? value =
        await GlassColorStorage.loadString(key);

    if (value == null) {
      return null;
    }

    return int.tryParse(value);
  }

  Future<void> _saveBool(
    String key,
    bool value,
  ) {
    return GlassColorStorage.saveBool(
      key,
      value,
    );
  }

  Future<void> _saveDouble(
    String key,
    double value,
  ) {
    return GlassColorStorage.saveDouble(
      key,
      value,
    );
  }

  Future<void> _saveInt(
    String key,
    int value,
  ) async {
    await GlassColorStorage.saveString(
      key,
      value.toString(),
    );
  }

  // ==========================================================================
  // THEME MODE PARSER
  // ==========================================================================

  AppThemeMode _parseThemeMode(
    String? value,
  ) {
    if (value == null) {
      return AppThemeMode.aqua;
    }

    for (final AppThemeMode mode
        in AppThemeMode.values) {
      if (mode.name == value) {
        return mode;
      }
    }

    return AppThemeMode.aqua;
  }
}