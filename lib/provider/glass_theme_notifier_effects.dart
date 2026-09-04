// ignore_for_file: deprecated_member_use
part of 'glass_theme_provider.dart';

/// Mixin contenant tous les setters pour la preview live
mixin GlassThemeNotifierEffects on Notifier<GlassThemeState> {
  
  SharedPreferences get _prefs;
  Future<void> setGlassStyle(GlassStyle style);

  // ===== GENERAL =====
  Future<void> setEnableBlur(bool v) async {
    await GlassColorStorage.saveBool(GlassThemeNotifier._enableBlurKey, v);
    state = state.copyWith(enableBlur: v);
  }
  Future<void> setEnableNoise(bool v) async {
    await GlassColorStorage.saveBool(GlassThemeNotifier._enableNoiseKey, v);
    state = state.copyWith(enableNoise: v);
  }
  Future<void> setEnableGlow(bool v) async {
    await GlassColorStorage.saveBool(GlassThemeNotifier._enableGlowKey, v);
    state = state.copyWith(enableGlow: v);
  }
  Future<void> setEnableShadow(bool v) async {
    await GlassColorStorage.saveBool(GlassThemeNotifier._enableShadowKey, v);
    state = state.copyWith(enableShadow: v);
  }
  Future<void> setEnableBorder(bool v) async {
    await GlassColorStorage.saveBool(GlassThemeNotifier._enableBorderKey, v);
    state = state.copyWith(enableBorder: v);
  }
  Future<void> setEnableGradient(bool v) async {
    await _prefs.setBool(GlassThemeNotifier._enableGradientKey, v);
    state = state.copyWith(enableGradient: v);
  }
  Future<void> setEnableHover(bool v) async {
    await GlassColorStorage.saveBool(GlassThemeNotifier._enableHoverKey, v);
    state = state.copyWith(enableHover: v);
  }
  Future<void> setBreakerOn(bool v) async { // <- AJOUT ICI
    await GlassColorStorage.saveBool(GlassThemeNotifier._breakerOnKey, v);
    state = state.copyWith(breakerOn: v);
  }

  // ===== BLUR & EFFECTS =====
  Future<void> setBlur(double v) async {
    final safe = v.clamp(0.0, 100.0);
    await GlassColorStorage.saveDouble(GlassThemeNotifier._blurKey, safe);
    state = state.copyWith(blur: safe);
  }
  Future<void> setNoise(double v) async {
    final safe = v.clamp(0.0, 1.0);
    await GlassColorStorage.saveDouble(GlassThemeNotifier._noiseKey, safe);
    state = state.copyWith(noise: safe);
  }
  Future<void> setGlowBlur(double v) async {
    final safe = v.clamp(0.0, 100.0);
    await GlassColorStorage.saveDouble(GlassThemeNotifier._glowBlurKey, safe);
    state = state.copyWith(glowBlur: safe);
  }
  Future<void> setGlowOpacity(double v) async {
    final safe = v.clamp(0.0, 1.0);
    await GlassColorStorage.saveDouble(GlassThemeNotifier._glowOpacityKey, safe);
    state = state.copyWith(glowOpacity: safe);
  }
  Future<void> setShadowBlur(double v) async {
    final safe = v.clamp(0.0, 100.0);
    await GlassColorStorage.saveDouble(GlassThemeNotifier._shadowBlurKey, safe);
    state = state.copyWith(shadowBlur: safe);
  }
  Future<void> setShadowOpacity(double v) async {
    final safe = v.clamp(0.0, 1.0);
    await GlassColorStorage.saveDouble(GlassThemeNotifier._shadowOpacityKey, safe);
    state = state.copyWith(shadowOpacity: safe);
  }
  Future<void> setShadowOffsetY(double v) async {
    await GlassColorStorage.saveDouble(GlassThemeNotifier._shadowOffsetYKey, v);
    state = state.copyWith(shadowOffsetY: v);
  }
  Future<void> setHoverLift(double v) async {
    final safe = v.clamp(0.0, 30.0);
    await GlassColorStorage.saveDouble(GlassThemeNotifier._hoverLiftKey, safe);
    state = state.copyWith(hoverLift: safe);
  }

  // ===== SURFACE =====
  Future<void> setBorderRadius(double v) async {
    final safe = v.clamp(0.0, 160.0);
    await GlassColorStorage.saveDouble(GlassThemeNotifier._borderRadiusKey, safe);
    state = state.copyWith(borderRadius: safe);
  }
  Future<void> setBorderWidth(double v) async {
    final safe = v.clamp(0.0, 12.0);
    await GlassColorStorage.saveDouble(GlassThemeNotifier._borderWidthKey, safe);
    state = state.copyWith(borderWidth: safe);
  }
  Future<void> setBorderOpacity(double v) async {
    final safe = v.clamp(0.0, 1.0);
    await GlassColorStorage.saveDouble(GlassThemeNotifier._borderOpacityKey, safe);
    state = state.copyWith(borderOpacity: safe);
  }
  Future<void> setSurfaceOpacity(double v) async {
    final safe = v.clamp(0.0, 1.0);
    await GlassColorStorage.saveDouble(GlassThemeNotifier._surfaceOpacityKey, safe);
    state = state.copyWith(surfaceOpacity: safe);
  }

  // ===== GRADIENT =====
  Future<void> setGradientDensity(int v) async {
    final safe = v.clamp(2, 4);
    await _prefs.setInt(GlassThemeNotifier._gradientDensityKey, safe);
    state = state.copyWith(gradientDensity: safe);
  }
  Future<void> setGradientOpacity(double v) async {
    final safe = v.clamp(0.0, 1.0);
    await _prefs.setDouble(GlassThemeNotifier._gradientOpacityKey, safe);
    state = state.copyWith(gradientOpacity: safe);
  }

  // ===== GRADIENT COLORS =====
  Future<void> setAquaGradient(List<Color> colors) async {
    final value = List<Color>.unmodifiable(colors);
    await GlassColorStorage.saveColorList(GlassThemeNotifier._aquaGradientKey, value);
    state = state.copyWith(aquaGradient: value);
  }
  Future<void> setClassicGradient(List<Color> colors) async {
    final value = List<Color>.unmodifiable(colors);
    await GlassColorStorage.saveColorList(GlassThemeNotifier._classicGradientKey, value);
    state = state.copyWith(classicGradient: value);
  }

  Future<void> reset() async {
    await setGlassStyle(GlassStyle.transparentAqua);
    await setAquaGradient(const [Color(0xFF4DD0E1), Color(0xFF00BCD4)]);
    await setClassicGradient(const [Color(0xFF121212), Color(0xFF1A1A1A)]);
    await setBlur(12.0);
    await setNoise(0.0);
    await setEnableBlur(true);
    await setEnableNoise(false);
    await setSurfaceOpacity(1.0);
    await setBorderRadius(20.0);
    await setEnableBorder(true);
    await setBorderOpacity(0.18);
    await setBorderWidth(0.72);
    await setEnableGlow(true);
    await setGlowOpacity(0.18);
    await setGlowBlur(18.0);
    await setEnableHover(true);
    await setHoverLift(3.0);
    await setEnableShadow(true);
    await setShadowOpacity(0.18);
    await setShadowBlur(12.0);
    await setShadowOffsetY(7.0);
    await setBreakerOn(false);
  }
}