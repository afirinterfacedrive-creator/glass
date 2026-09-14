
// ignore: unnecessary_library_name
library universal_glass_theme;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_glass/provider/glass_appearance_service.dart';
import 'package:universal_glass/provider/glass_theme_state.dart';
import 'package:universal_glass/theme/glass_display_settings.dart';

import '../enums/glass_enums.dart';
import '../providers/shared_preferences_provider.dart';
import '../settings/widgets/glass_color_storage.dart';

part 'glass_theme_notifier_effects.dart';

/// ============================================================================
/// GLASS THEME NOTIFIER
/// ============================================================================
///
/// Gestionnaire central de l'état visuel Universal Glass.
///
/// Responsabilités :
///
/// - charger la configuration depuis SharedPreferences ;
/// - conserver le style Glass courant ;
/// - gérer le mode Aqua / Classic ;
/// - gérer les gradients ;
/// - gérer blur / noise ;
/// - gérer surface / bordure / glow / hover / shadow ;
/// - gérer l'affichage global ;
/// - gérer zoom / largeur / marges / breakpoints / densité ;
/// - importer/exporter une configuration complète via le service Appearance ;
/// - persister les modifications.


class GlassThemeNotifier extends Notifier<GlassThemeState>
    with GlassThemeNotifierEffects {
  // ==========================================================================
  // CLÉS DE STOCKAGE
  // ==========================================================================

  static const String _themeModeKey = 'theme_mode';

  static const String _glassStyleKey =
      'appearance_glass_style';

  static const String _aquaKey =
      'glass_use_aqua_style';

  static const String _enableGradientKey =
      'glass_enable_gradient';

  // ==========================================================================
  // GRADIENTS
  // ==========================================================================

  static const String _aquaGradientKey =
      'appbar_gradient_aqua';

  static const String _classicGradientKey =
      'appbar_gradient_classic';

  static const String _customGradientKey =
      'appbar_gradient_custom';

  static const String _gradientDensityKey =
      'appbar_gradient_density';

  static const String _gradientOpacityKey =
      'appbar_gradient_opacity';

  // ==========================================================================
  // BLUR / NOISE
  // ==========================================================================

  static const String _blurKey =
      'appearance_blur';

  static const String _noiseKey =
      'appearance_noise';

  static const String _enableBlurKey =
      'appearance_enable_blur';

  static const String _enableNoiseKey =
      'appearance_enable_noise';

  // ==========================================================================
  // SURFACE
  // ==========================================================================

  static const String _surfaceOpacityKey =
      'appearance_surface_opacity';

  // ==========================================================================
  // BORDER
  // ==========================================================================

  static const String _borderRadiusKey =
      'appearance_border_radius';

  static const String _enableBorderKey =
      'appearance_enable_border';

  static const String _borderOpacityKey =
      'appearance_border_opacity';

  static const String _borderWidthKey =
      'appearance_border_width';

  // ==========================================================================
  // GLOW
  // ==========================================================================

  static const String _enableGlowKey =
      'appearance_enable_glow';

  static const String _glowOpacityKey =
      'appearance_glow_opacity';

  static const String _glowBlurKey =
      'appearance_glow_blur';

  // ==========================================================================
  // HOVER
  // ==========================================================================

  static const String _enableHoverKey =
      'appearance_enable_hover';

  static const String _hoverLiftKey =
      'appearance_hover_lift';

  // ==========================================================================
  // SHADOW
  // ==========================================================================

  static const String _enableShadowKey =
      'appearance_enable_shadow';

  static const String _shadowOpacityKey =
      'appearance_shadow_opacity';

  static const String _shadowBlurKey =
      'appearance_shadow_blur';

  static const String _shadowOffsetYKey =
      'appearance_shadow_offset_y';

  // ==========================================================================
  // BREAKER
  // ==========================================================================

  static const String _breakerOnKey =
      'breaker_on';

  // ==========================================================================
  // DISPLAY
  // ==========================================================================

  static const String _displayMaxWidthKey =
      'display_max_width';

  static const String _displayZoomKey =
      'display_zoom';

  static const String _displayDesktopPaddingKey =
      'display_desktop_padding';

  static const String _displayTabletPaddingKey =
      'display_tablet_padding';

  static const String _displayMobilePaddingKey =
      'display_mobile_padding';

  static const String _displaySmallMobilePaddingKey =
      'display_small_mobile_padding';

  static const String _displayTabletBreakpointKey =
      'display_tablet_breakpoint';

  static const String _displayDesktopBreakpointKey =
      'display_desktop_breakpoint';

  static const String _displayDensityKey =
      'display_density';

  // ==========================================================================
  // PROTECTION DU CHARGEMENT ASYNCHRONE
  // ==========================================================================

  bool _userChangedAppearance = false;

  @override
void markAppearanceChanged() {
  _userChangedAppearance = true;
}

  // ==========================================================================
  // SHARED PREFERENCES
  // ==========================================================================

  @override
  SharedPreferences get _prefs {
    return ref.read(
      sharedPreferencesProvider,
    );
  }

  // ==========================================================================
  // BUILD
  // ==========================================================================

  @override
  GlassThemeState build() {
    const GlassThemeState initialState =
        GlassThemeState();

    Future<void>.microtask(
      _loadFromStorage,
    );

    return initialState;
  }

  // ==========================================================================
  // HELPERS DE LECTURE
  // ==========================================================================

  double? _readDouble(
    String key,
  ) {
    final Object? raw = _prefs.get(key);

    if (raw is double) {
      return raw;
    }

    if (raw is int) {
      return raw.toDouble();
    }

    return null;
  }

  bool? _readBool(
    String key,
  ) {
    final Object? raw = _prefs.get(key);

    if (raw is bool) {
      return raw;
    }

    return null;
  }

  String? _readString(
    String key,
  ) {
    final Object? raw = _prefs.get(key);

    if (raw is String) {
      return raw;
    }

    return null;
  }

  Future<double?> _readAndMigrateDouble(
    String key,
  ) async {
    final Object? raw = _prefs.get(key);

    if (raw is double) {
      return raw;
    }

    if (raw is int) {
      final double value = raw.toDouble();

      await _prefs.setDouble(
        key,
        value,
      );

      return value;
    }

    return null;
  }

  // ==========================================================================
  // PARSE THEME MODE
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

  // ==========================================================================
  // PARSE GLASS STYLE
  // ==========================================================================

  GlassStyle _parseGlassStyle(
    String? value,
  ) {
    if (value == null) {
      return GlassStyle.transparentAqua;
    }

    for (final GlassStyle style
        in GlassStyle.values) {
      if (style.name == value) {
        return style;
      }
    }

    return GlassStyle.transparentAqua;
  }

  // ==========================================================================
  // PARSE DISPLAY DENSITY
  // ==========================================================================

  GlassDensity _parseDisplayDensity(
    String? value,
  ) {
    if (value == null) {
      return GlassDensity.comfortable;
    }

    for (final GlassDensity density
        in GlassDensity.values) {
      if (density.name == value) {
        return density;
      }
    }

    return GlassDensity.comfortable;
  }

  // ==========================================================================
  // AQUA STYLE
  // ==========================================================================

  bool _isAquaStyle(
    GlassStyle style,
  ) {
    switch (style) {
      case GlassStyle.solidAqua:
      case GlassStyle.transparentAqua:
        return true;

      case GlassStyle.opaqueMat:
      case GlassStyle.gradientOpaque:
      case GlassStyle.customGradient:
      case GlassStyle.solidClassic:
      case GlassStyle.opaqueHeavy:
      case GlassStyle.transparentRed:
      case GlassStyle.transparentGreen:
      case GlassStyle.classicSb:
      case GlassStyle.custom:
        return false;
    }
  }

  // ==========================================================================
  // STYLE SUPPORTS GRADIENT
  // ==========================================================================

  bool _styleSupportsGradient(
    GlassStyle style,
  ) {
    switch (style) {
      case GlassStyle.opaqueMat:
      case GlassStyle.solidAqua:
      case GlassStyle.solidClassic:
      case GlassStyle.opaqueHeavy:
        return false;

      case GlassStyle.gradientOpaque:
      case GlassStyle.customGradient:
      case GlassStyle.transparentAqua:
      case GlassStyle.transparentRed:
      case GlassStyle.transparentGreen:
      case GlassStyle.classicSb:
      case GlassStyle.custom:
        return true;
    }
  }

  // ==========================================================================
  // LOAD DISPLAY SETTINGS
  // ==========================================================================

  GlassDisplaySettings _loadDisplaySettings() {
    final GlassDisplaySettings current =
        state.display;

    final double maxWidth =
        _readDouble(
          _displayMaxWidthKey,
        ) ??
        current.maxWidth;

    final double zoom =
        _readDouble(
          _displayZoomKey,
        ) ??
        current.zoom;

    final double desktopPadding =
        _readDouble(
          _displayDesktopPaddingKey,
        ) ??
        current.desktopPadding;

    final double tabletPadding =
        _readDouble(
          _displayTabletPaddingKey,
        ) ??
        current.tabletPadding;

    final double mobilePadding =
        _readDouble(
          _displayMobilePaddingKey,
        ) ??
        current.mobilePadding;

    final double smallMobilePadding =
        _readDouble(
          _displaySmallMobilePaddingKey,
        ) ??
        current.smallMobilePadding;

    final double tabletBreakpoint =
        _readDouble(
          _displayTabletBreakpointKey,
        ) ??
        current.tabletBreakpoint;

    final double desktopBreakpoint =
        _readDouble(
          _displayDesktopBreakpointKey,
        ) ??
        current.desktopBreakpoint;

    final GlassDensity density =
        _parseDisplayDensity(
      _readString(
        _displayDensityKey,
      ),
    );

    return GlassDisplaySettings(
      maxWidth: maxWidth,
      zoom: zoom,
      desktopPadding: desktopPadding,
      tabletPadding: tabletPadding,
      mobilePadding: mobilePadding,
      smallMobilePadding: smallMobilePadding,
      tabletBreakpoint: tabletBreakpoint,
      desktopBreakpoint: desktopBreakpoint,
      density: density,
    ).normalized();
  }

  // ==========================================================================
  // LOAD FROM STORAGE
  // ==========================================================================

  Future<void> _loadFromStorage() async {
    if (_userChangedAppearance) {
      return;
    }

    final String? savedMode =
        _readString(_themeModeKey);

    final AppThemeMode themeMode =
        _parseThemeMode(savedMode);

    final String? savedStyle =
        _readString(_glassStyleKey);

    final GlassStyle savedGlassStyle =
        _parseGlassStyle(savedStyle);

    final bool savedUseAquaStyle =
        _readBool(_aquaKey) ?? true;

    final bool savedEnableGradient =
        _readBool(_enableGradientKey) ?? true;

    final List<Color>? savedAquaGradient =
        await GlassColorStorage.loadColorList(
      _aquaGradientKey,
    );

    final List<Color>? savedClassicGradient =
        await GlassColorStorage.loadColorList(
      _classicGradientKey,
    );

    final List<Color>? savedCustomGradient =
        await GlassColorStorage.loadColorList(
      _customGradientKey,
    );

    if (_userChangedAppearance) {
      return;
    }

    final double savedGradientDensity =
        await _readAndMigrateDouble(
          _gradientDensityKey,
        ) ??
        state.gradientDensity;

    final double savedGradientOpacity =
        await _readAndMigrateDouble(
          _gradientOpacityKey,
        ) ??
        state.gradientOpacity;

    final double savedBlur =
        await _readAndMigrateDouble(
          _blurKey,
        ) ??
        state.blur;

    final bool savedEnableBlur =
        _readBool(_enableBlurKey) ??
        state.enableBlur;

    final double savedNoise =
        await _readAndMigrateDouble(
          _noiseKey,
        ) ??
        state.noise;

    final bool savedEnableNoise =
        _readBool(_enableNoiseKey) ??
        state.enableNoise;

    final double savedSurfaceOpacity =
        await _readAndMigrateDouble(
          _surfaceOpacityKey,
        ) ??
        state.surfaceOpacity;

    final double savedBorderRadius =
        await _readAndMigrateDouble(
          _borderRadiusKey,
        ) ??
        state.borderRadius;

    final bool savedEnableBorder =
        _readBool(_enableBorderKey) ??
        state.enableBorder;

    final double savedBorderOpacity =
        await _readAndMigrateDouble(
          _borderOpacityKey,
        ) ??
        state.borderOpacity;

    final double savedBorderWidth =
        await _readAndMigrateDouble(
          _borderWidthKey,
        ) ??
        state.borderWidth;

    final bool savedEnableGlow =
        _readBool(_enableGlowKey) ??
        state.enableGlow;

    final double savedGlowOpacity =
        await _readAndMigrateDouble(
          _glowOpacityKey,
        ) ??
        state.glowOpacity;

    final double savedGlowBlur =
        await _readAndMigrateDouble(
          _glowBlurKey,
        ) ??
        state.glowBlur;

    final bool savedEnableHover =
        _readBool(_enableHoverKey) ??
        state.enableHover;

    final double savedHoverLift =
        await _readAndMigrateDouble(
          _hoverLiftKey,
        ) ??
        state.hoverLift;

    final bool savedEnableShadow =
        _readBool(_enableShadowKey) ??
        state.enableShadow;

    final double savedShadowOpacity =
        await _readAndMigrateDouble(
          _shadowOpacityKey,
        ) ??
        state.shadowOpacity;

    final double savedShadowBlur =
        await _readAndMigrateDouble(
          _shadowBlurKey,
        ) ??
        state.shadowBlur;

    final double savedShadowOffsetY =
        await _readAndMigrateDouble(
          _shadowOffsetYKey,
        ) ??
        state.shadowOffsetY;

    final bool savedBreakerOn =
        _readBool(_breakerOnKey) ?? false;

    final GlassDisplaySettings savedDisplay =
        _loadDisplaySettings();

    if (_userChangedAppearance) {
      return;
    }

    state = state.copyWith(
      themeMode: themeMode,
      glassStyle: savedGlassStyle,
      useAquaStyle: savedUseAquaStyle,
      enableGradient: savedEnableGradient,
      aquaGradient:
          savedAquaGradient ?? state.aquaGradient,
      classicGradient:
          savedClassicGradient ??
          state.classicGradient,
      customGradientColors:
          savedCustomGradient,
      gradientDensity:
          savedGradientDensity,
      gradientOpacity:
          savedGradientOpacity,
      blur: savedBlur,
      noise: savedNoise,
      enableBlur: savedEnableBlur,
      enableNoise: savedEnableNoise,
      surfaceOpacity:
          savedSurfaceOpacity,
      borderRadius:
          savedBorderRadius,
      enableBorder:
          savedEnableBorder,
      borderOpacity:
          savedBorderOpacity,
      borderWidth:
          savedBorderWidth,
      enableGlow:
          savedEnableGlow,
      glowOpacity:
          savedGlowOpacity,
      glowBlur:
          savedGlowBlur,
      enableHover:
          savedEnableHover,
      hoverLift:
          savedHoverLift,
      enableShadow:
          savedEnableShadow,
      shadowOpacity:
          savedShadowOpacity,
      shadowBlur:
          savedShadowBlur,
      shadowOffsetY:
          savedShadowOffsetY,
      breakerOn:
          savedBreakerOn,
      display:
          savedDisplay,
    );
  }

  // ==========================================================================
  // APPLY COMPLETE APPEARANCE STATE
  // ==========================================================================

  Future<void> applyAppearanceState(
    GlassThemeState importedState,
  ) async {
    _userChangedAppearance = true;

    final GlassDisplaySettings normalizedDisplay =
        importedState.display.normalized();

    final double normalizedGradientDensity =
        importedState.gradientDensity
            .clamp(1.0, 10.0)
            .toDouble();

    final double normalizedGradientOpacity =
        importedState.gradientOpacity
            .clamp(0.0, 1.0)
            .toDouble();

    final double normalizedBlur =
        importedState.blur
            .clamp(0.0, 100.0)
            .toDouble();

    final double normalizedNoise =
        importedState.noise
            .clamp(0.0, 1.0)
            .toDouble();

    final double normalizedSurfaceOpacity =
        importedState.surfaceOpacity
            .clamp(0.0, 1.0)
            .toDouble();

    final double normalizedBorderRadius =
        importedState.borderRadius
            .clamp(0.0, 160.0)
            .toDouble();

    final double normalizedBorderOpacity =
        importedState.borderOpacity
            .clamp(0.0, 1.0)
            .toDouble();

    final double normalizedBorderWidth =
        importedState.borderWidth
            .clamp(0.0, 12.0)
            .toDouble();

    final double normalizedGlowOpacity =
        importedState.glowOpacity
            .clamp(0.0, 1.0)
            .toDouble();

    final double normalizedGlowBlur =
        importedState.glowBlur
            .clamp(0.0, 100.0)
            .toDouble();

    final double normalizedHoverLift =
        importedState.hoverLift
            .clamp(0.0, 30.0)
            .toDouble();

    final double normalizedShadowOpacity =
        importedState.shadowOpacity
            .clamp(0.0, 1.0)
            .toDouble();

    final double normalizedShadowBlur =
        importedState.shadowBlur
            .clamp(0.0, 100.0)
            .toDouble();

    final double normalizedShadowOffsetY =
        importedState.shadowOffsetY
            .clamp(-100.0, 100.0)
            .toDouble();

    final List<Color> aquaGradient =
        List<Color>.unmodifiable(
      importedState.aquaGradient,
    );

    final List<Color> classicGradient =
        List<Color>.unmodifiable(
      importedState.classicGradient,
    );

    final List<Color>? customGradient =
        importedState.customGradientColors == null
            ? null
            : List<Color>.unmodifiable(
                importedState.customGradientColors!,
              );

    final GlassThemeState normalizedState =
        importedState.copyWith(
      aquaGradient: aquaGradient,
      classicGradient: classicGradient,
      customGradientColors:
          customGradient,
      gradientDensity:
          normalizedGradientDensity,
      gradientOpacity:
          normalizedGradientOpacity,
      blur:
          normalizedBlur,
      noise:
          normalizedNoise,
      surfaceOpacity:
          normalizedSurfaceOpacity,
      borderRadius:
          normalizedBorderRadius,
      borderOpacity:
          normalizedBorderOpacity,
      borderWidth:
          normalizedBorderWidth,
      glowOpacity:
          normalizedGlowOpacity,
      glowBlur:
          normalizedGlowBlur,
      hoverLift:
          normalizedHoverLift,
      shadowOpacity:
          normalizedShadowOpacity,
      shadowBlur:
          normalizedShadowBlur,
      shadowOffsetY:
          normalizedShadowOffsetY,
      display:
          normalizedDisplay,
    );

    state = normalizedState;
    debugPrint(
  '[GlassThemeNotifier] IMPORT APPLIED → '
  'themeMode=${state.themeMode.name}, '
  'glassStyle=${state.glassStyle.name}, '
  'useAquaStyle=${state.useAquaStyle}, '
  'enableGradient=${state.enableGradient}',
);

    final List<Future<bool>> writes =
        <Future<bool>>[
      _prefs.setString(
        _themeModeKey,
        normalizedState.themeMode.name,
      ),
      _prefs.setString(
        _glassStyleKey,
        normalizedState.glassStyle.name,
      ),
      _prefs.setBool(
        _aquaKey,
        normalizedState.useAquaStyle,
      ),
      _prefs.setBool(
        _enableGradientKey,
        normalizedState.enableGradient,
      ),
      _prefs.setDouble(
        _gradientDensityKey,
        normalizedGradientDensity,
      ),
      _prefs.setDouble(
        _gradientOpacityKey,
        normalizedGradientOpacity,
      ),
      _prefs.setDouble(
        _blurKey,
        normalizedBlur,
      ),
      _prefs.setDouble(
        _noiseKey,
        normalizedNoise,
      ),
      _prefs.setBool(
        _enableBlurKey,
        normalizedState.enableBlur,
      ),
      _prefs.setBool(
        _enableNoiseKey,
        normalizedState.enableNoise,
      ),
      _prefs.setDouble(
        _surfaceOpacityKey,
        normalizedSurfaceOpacity,
      ),
      _prefs.setDouble(
        _borderRadiusKey,
        normalizedBorderRadius,
      ),
      _prefs.setBool(
        _enableBorderKey,
        normalizedState.enableBorder,
      ),
      _prefs.setDouble(
        _borderOpacityKey,
        normalizedBorderOpacity,
      ),
      _prefs.setDouble(
        _borderWidthKey,
        normalizedBorderWidth,
      ),
      _prefs.setBool(
        _enableGlowKey,
        normalizedState.enableGlow,
      ),
      _prefs.setDouble(
        _glowOpacityKey,
        normalizedGlowOpacity,
      ),
      _prefs.setDouble(
        _glowBlurKey,
        normalizedGlowBlur,
      ),
      _prefs.setBool(
        _enableHoverKey,
        normalizedState.enableHover,
      ),
      _prefs.setDouble(
        _hoverLiftKey,
        normalizedHoverLift,
      ),
      _prefs.setBool(
        _enableShadowKey,
        normalizedState.enableShadow,
      ),
      _prefs.setDouble(
        _shadowOpacityKey,
        normalizedShadowOpacity,
      ),
      _prefs.setDouble(
        _shadowBlurKey,
        normalizedShadowBlur,
      ),
      _prefs.setDouble(
        _shadowOffsetYKey,
        normalizedShadowOffsetY,
      ),
      _prefs.setBool(
        _breakerOnKey,
        normalizedState.breakerOn,
      ),
      _prefs.setDouble(
        _displayMaxWidthKey,
        normalizedDisplay.maxWidth,
      ),
      _prefs.setDouble(
        _displayZoomKey,
        normalizedDisplay.zoom,
      ),
      _prefs.setDouble(
        _displayDesktopPaddingKey,
        normalizedDisplay.desktopPadding,
      ),
      _prefs.setDouble(
        _displayTabletPaddingKey,
        normalizedDisplay.tabletPadding,
      ),
      _prefs.setDouble(
        _displayMobilePaddingKey,
        normalizedDisplay.mobilePadding,
      ),
      _prefs.setDouble(
        _displaySmallMobilePaddingKey,
        normalizedDisplay.smallMobilePadding,
      ),
      _prefs.setDouble(
        _displayTabletBreakpointKey,
        normalizedDisplay.tabletBreakpoint,
      ),
      _prefs.setDouble(
        _displayDesktopBreakpointKey,
        normalizedDisplay.desktopBreakpoint,
      ),
      _prefs.setString(
        _displayDensityKey,
        normalizedDisplay.density.name,
      ),
    ];

    final List<Future<void>> colorWrites =
        <Future<void>>[
      GlassColorStorage.saveColorList(
        _aquaGradientKey,
        aquaGradient,
      ),
      GlassColorStorage.saveColorList(
        _classicGradientKey,
        classicGradient,
      ),
    ];

    if (customGradient != null) {
      colorWrites.add(
        GlassColorStorage.saveColorList(
          _customGradientKey,
          customGradient,
        ),
      );
    }

    await Future.wait([
      ...writes,
      ...colorWrites,
    ]);

    if (customGradient == null) {
      await _prefs.remove(
        _customGradientKey,
      );
    }
  }

  // ==========================================================================
  // THEME MODE
  // ==========================================================================

  Future<void> setThemeMode(
    AppThemeMode mode,
  ) async {
    _userChangedAppearance = true;

    state = state.copyWith(
      themeMode: mode,
    );

    await _prefs.setString(
      _themeModeKey,
      mode.name,
    );
  }

  // ==========================================================================
  // GLASS STYLE
  // ==========================================================================

  // ignore: annotate_overrides
  Future<void> setGlassStyle(
    GlassStyle style,
  ) async {
    _userChangedAppearance = true;

    final bool useAqua =
        _isAquaStyle(style);

    final bool hasGradient =
        _styleSupportsGradient(style);

    state = state.copyWith(
      glassStyle: style,
      useAquaStyle: useAqua,
      enableGradient: hasGradient,
    );

    await Future.wait([
      _prefs.setString(
        _glassStyleKey,
        style.name,
      ),
      _prefs.setBool(
        _aquaKey,
        useAqua,
      ),
      _prefs.setBool(
        _enableGradientKey,
        hasGradient,
      ),
    ]);
  }

  // ==========================================================================
  // CLASSIC SB
  // ==========================================================================

  Future<void> setClassicSb() async {
    await setGlassStyle(
      GlassStyle.classicSb,
    );
  }

  // ==========================================================================
  // AQUA STYLE
  // ==========================================================================

  Future<void> setAquaStyle(
    bool value,
  ) async {
    final GlassStyle newStyle =
        value
            ? GlassStyle.transparentAqua
            : GlassStyle.opaqueMat;

    await setGlassStyle(
      newStyle,
    );
  }

  // ==========================================================================
  // TOGGLE AQUA
  // ==========================================================================

  Future<void> toggleAquaStyle() async {
    await setAquaStyle(
      !state.useAquaStyle,
    );
  }

  // ==========================================================================
  // DISPLAY SETTINGS
  // ==========================================================================

  Future<void> updateDisplaySettings(
    GlassDisplaySettings settings,
  ) async {
    _userChangedAppearance = true;

    final GlassDisplaySettings normalized =
        settings.normalized();

    state = state.copyWith(
      display: normalized,
    );

    await Future.wait([
      _prefs.setDouble(
        _displayMaxWidthKey,
        normalized.maxWidth,
      ),
      _prefs.setDouble(
        _displayZoomKey,
        normalized.zoom,
      ),
      _prefs.setDouble(
        _displayDesktopPaddingKey,
        normalized.desktopPadding,
      ),
      _prefs.setDouble(
        _displayTabletPaddingKey,
        normalized.tabletPadding,
      ),
      _prefs.setDouble(
        _displayMobilePaddingKey,
        normalized.mobilePadding,
      ),
      _prefs.setDouble(
        _displaySmallMobilePaddingKey,
        normalized.smallMobilePadding,
      ),
      _prefs.setDouble(
        _displayTabletBreakpointKey,
        normalized.tabletBreakpoint,
      ),
      _prefs.setDouble(
        _displayDesktopBreakpointKey,
        normalized.desktopBreakpoint,
      ),
      _prefs.setString(
        _displayDensityKey,
        normalized.density.name,
      ),
    ]);
  }

  // ==========================================================================
  // DISPLAY ZOOM
  // ==========================================================================

  Future<void> updateDisplayZoom(
    double zoom,
  ) async {
    await updateDisplaySettings(
      state.display.copyWith(
        zoom: zoom,
      ),
    );
  }

  // ==========================================================================
  // DISPLAY MAX WIDTH
  // ==========================================================================

  Future<void> updateDisplayMaxWidth(
    double maxWidth,
  ) async {
    await updateDisplaySettings(
      state.display.copyWith(
        maxWidth: maxWidth,
      ),
    );
  }

  // ==========================================================================
  // DISPLAY DESKTOP PADDING
  // ==========================================================================

  Future<void> updateDisplayDesktopPadding(
    double padding,
  ) async {
    await updateDisplaySettings(
      state.display.copyWith(
        desktopPadding: padding,
      ),
    );
  }

  // ==========================================================================
  // DISPLAY TABLET PADDING
  // ==========================================================================

  Future<void> updateDisplayTabletPadding(
    double padding,
  ) async {
    await updateDisplaySettings(
      state.display.copyWith(
        tabletPadding: padding,
      ),
    );
  }

  // ==========================================================================
  // DISPLAY MOBILE PADDING
  // ==========================================================================

  Future<void> updateDisplayMobilePadding(
    double padding,
  ) async {
    await updateDisplaySettings(
      state.display.copyWith(
        mobilePadding: padding,
      ),
    );
  }

  // ==========================================================================
  // DISPLAY SMALL MOBILE PADDING
  // ==========================================================================

  Future<void> updateDisplaySmallMobilePadding(
    double padding,
  ) async {
    await updateDisplaySettings(
      state.display.copyWith(
        smallMobilePadding: padding,
      ),
    );
  }

  // ==========================================================================
  // DISPLAY TABLET BREAKPOINT
  // ==========================================================================

  Future<void> updateDisplayTabletBreakpoint(
    double breakpoint,
  ) async {
    await updateDisplaySettings(
      state.display.copyWith(
        tabletBreakpoint: breakpoint,
      ),
    );
  }

  // ==========================================================================
  // DISPLAY DESKTOP BREAKPOINT
  // ==========================================================================

  Future<void> updateDisplayDesktopBreakpoint(
    double breakpoint,
  ) async {
    await updateDisplaySettings(
      state.display.copyWith(
        desktopBreakpoint: breakpoint,
      ),
    );
  }

  // ==========================================================================
  // DISPLAY DENSITY
  // ==========================================================================

  Future<void> updateDisplayDensity(
    GlassDensity density,
  ) async {
    await updateDisplaySettings(
      state.display.copyWith(
        density: density,
      ),
    );
  }

  // ==========================================================================
  // RESET DISPLAY SETTINGS
  // ==========================================================================

  // ignore: annotate_overrides
  Future<void> resetDisplaySettings() async {
    await updateDisplaySettings(
      GlassDisplaySettings.defaults,
    );
  }

  // ==========================================================================
  // IMPORT APPEARANCE
  // ==========================================================================

  Future<bool> importAppearance() async {
    final GlassThemeState? imported =
        await GlassAppearanceService.importAppearance();

    if (imported == null) {
      return false;
    }

    await applyAppearanceState(
      imported,
    );

    return true;
  }

  // ==========================================================================
  // EXPORT APPEARANCE
  // ==========================================================================

  Future<String?> exportAppearance({
    String? fileName,
    bool pretty = true,
  }) {
    return GlassAppearanceService.exportAppearance(
      state,
      fileName: fileName,
      pretty: pretty,
    );
  }
}

// ============================================================================
// PROVIDER
// ============================================================================

final glassThemeProvider =
    NotifierProvider<
        GlassThemeNotifier,
        GlassThemeState>(
  GlassThemeNotifier.new,
);
