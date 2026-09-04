// ignore: unnecessary_library_name
library universal_glass_theme;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_glass/utils/glass_classic_sb_decoration.dart';

import '../enums/glass_enums.dart';
import '../providers/shared_preferences_provider.dart';
import '../settings/widgets/glass_color_storage.dart';

part 'glass_theme_state.dart';
part 'glass_theme_notifier_effects.dart'; // <- AJOUTE CETTE LIGNE

class GlassThemeNotifier extends Notifier<GlassThemeState> with GlassThemeNotifierEffects {
  static const String _themeModeKey = 'theme_mode';
  static const String _glassStyleKey = 'appearance_glass_style';
  static const String _aquaKey = 'glass_use_aqua_style';
  static const String _enableGradientKey = 'glass_enable_gradient';
  static const String _aquaGradientKey = 'appbar_gradient_aqua';
  static const String _classicGradientKey = 'appbar_gradient_classic';
  static const String _customGradientKey = 'appbar_gradient_custom';
  static const String _gradientDensityKey = 'appbar_gradient_density';
  static const String _gradientOpacityKey = 'appbar_gradient_opacity';
  static const String _blurKey = 'appearance_blur';
  static const String _noiseKey = 'appearance_noise';
  static const String _enableBlurKey = 'appearance_enable_blur';
  static const String _enableNoiseKey = 'appearance_enable_noise';
  static const String _surfaceOpacityKey = 'appearance_surface_opacity';
  static const String _borderRadiusKey = 'appearance_border_radius';
  static const String _enableBorderKey = 'appearance_enable_border';
  static const String _borderOpacityKey = 'appearance_border_opacity';
  static const String _borderWidthKey = 'appearance_border_width';
  static const String _enableGlowKey = 'appearance_enable_glow';
  static const String _glowOpacityKey = 'appearance_glow_opacity';
  static const String _glowBlurKey = 'appearance_glow_blur';
  static const String _enableHoverKey = 'appearance_enable_hover';
  static const String _hoverLiftKey = 'appearance_hover_lift';
  static const String _enableShadowKey = 'appearance_enable_shadow';
  static const String _shadowOpacityKey = 'appearance_shadow_opacity';
  static const String _shadowBlurKey = 'appearance_shadow_blur';
  static const String _shadowOffsetYKey = 'appearance_shadow_offset_y';
  static const String _breakerOnKey = 'breaker_on';

  @override
  SharedPreferences get _prefs => ref.read(sharedPreferencesProvider);

  @override
  GlassThemeState build() {
    final GlassThemeState initialState = const GlassThemeState();
    Future<void>.microtask(_loadFromStorage);
    return initialState;
  }

  Future<void> _loadFromStorage() async {
    final String? savedMode = _prefs.getString(_themeModeKey);
    final String? savedStyle = _prefs.getString(_glassStyleKey);

    final AppThemeMode themeMode = AppThemeMode.values.firstWhere(
      (e) => e.name == savedMode,
      orElse: () => AppThemeMode.aqua,
    );

    final GlassStyle glassStyle = GlassStyle.values.firstWhere(
      (e) => e.name == savedStyle,
      orElse: () => GlassStyle.transparentAqua,
    );

    state = state.copyWith(
      themeMode: themeMode,
      glassStyle: glassStyle,
      useAquaStyle: _prefs.getBool(_aquaKey) ?? true,
      enableGradient: _prefs.getBool(_enableGradientKey) ?? true,
      aquaGradient: await GlassColorStorage.loadColorList(_aquaGradientKey) ?? state.aquaGradient,
      classicGradient: await GlassColorStorage.loadColorList(_classicGradientKey) ?? state.classicGradient,
      customGradientColors: await GlassColorStorage.loadColorList(_customGradientKey),
      gradientDensity: _prefs.getInt(_gradientDensityKey) ?? state.gradientDensity,
      gradientOpacity: _prefs.getDouble(_gradientOpacityKey) ?? state.gradientOpacity,
      blur: await GlassColorStorage.loadDouble(_blurKey) ?? state.blur,
      noise: await GlassColorStorage.loadDouble(_noiseKey) ?? state.noise,
      enableBlur: await GlassColorStorage.loadBool(_enableBlurKey) ?? state.enableBlur,
      enableNoise: await GlassColorStorage.loadBool(_enableNoiseKey) ?? state.enableNoise,
      surfaceOpacity: await GlassColorStorage.loadDouble(_surfaceOpacityKey) ?? state.surfaceOpacity,
      borderRadius: await GlassColorStorage.loadDouble(_borderRadiusKey) ?? state.borderRadius,
      enableBorder: await GlassColorStorage.loadBool(_enableBorderKey) ?? state.enableBorder,
      borderOpacity: await GlassColorStorage.loadDouble(_borderOpacityKey) ?? state.borderOpacity,
      borderWidth: await GlassColorStorage.loadDouble(_borderWidthKey) ?? state.borderWidth,
      enableGlow: await GlassColorStorage.loadBool(_enableGlowKey) ?? state.enableGlow,
      glowOpacity: await GlassColorStorage.loadDouble(_glowOpacityKey) ?? state.glowOpacity,
      glowBlur: await GlassColorStorage.loadDouble(_glowBlurKey) ?? state.glowBlur,
      enableHover: await GlassColorStorage.loadBool(_enableHoverKey) ?? state.enableHover,
      hoverLift: await GlassColorStorage.loadDouble(_hoverLiftKey) ?? state.hoverLift,
      enableShadow: await GlassColorStorage.loadBool(_enableShadowKey) ?? state.enableShadow,
      shadowOpacity: await GlassColorStorage.loadDouble(_shadowOpacityKey) ?? state.shadowOpacity,
      shadowBlur: await GlassColorStorage.loadDouble(_shadowBlurKey) ?? state.shadowBlur,
      shadowOffsetY: await GlassColorStorage.loadDouble(_shadowOffsetYKey) ?? state.shadowOffsetY,
      breakerOn: await GlassColorStorage.loadBool(_breakerOnKey) ?? false,
    );
  }

  Future<void> setThemeMode(AppThemeMode mode) async {
    await _prefs.setString(_themeModeKey, mode.name);
    state = state.copyWith(themeMode: mode);
  }

  
  @override
  Future<void> setGlassStyle(GlassStyle style) async {
    final bool useAqua = [
      GlassStyle.transparentAqua, GlassStyle.solidAqua, GlassStyle.ghost,
      GlassStyle.sage, GlassStyle.sagePro, GlassStyle.sageOled, GlassStyle.sageGlass,
      GlassStyle.classicSb,
    ].contains(style);

    final bool hasGradient = ![
      GlassStyle.opaqueHeavy, GlassStyle.opaqueMat, GlassStyle.solidAqua, GlassStyle.solidClassic,
    ].contains(style);

    state = state.copyWith(
      glassStyle: style,
      useAquaStyle: useAqua,
      enableGradient: hasGradient,
    );
    
    await _prefs.setString(_glassStyleKey, style.name);
    await _prefs.setBool(_aquaKey, useAqua);
  }

  Future<void> setClassicSb() async => setGlassStyle(GlassStyle.classicSb);
  Future<void> setSagePro() async => setGlassStyle(GlassStyle.sagePro);
  Future<void> setSageGlass() async => setGlassStyle(GlassStyle.sageGlass);
 
  Future<void> setAquaStyle(bool value) async {
    final newStyle = value ? GlassStyle.transparentAqua : GlassStyle.opaqueMat;
    await setGlassStyle(newStyle);
  }

  Future<void> toggleAquaStyle() async => setAquaStyle(!state.useAquaStyle);
}

final glassThemeProvider = NotifierProvider<GlassThemeNotifier, GlassThemeState>(
  GlassThemeNotifier.new,
);