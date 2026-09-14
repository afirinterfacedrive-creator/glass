// ignore_for_file: deprecated_member_use

part of 'glass_theme_provider.dart';

/// ============================================================================
/// GLASS THEME NOTIFIER EFFECTS
/// ============================================================================
///
/// Mixin regroupant les setters utilisés par les previews et les paramètres
/// d'apparence.
///
/// Principes :
///
/// - l'état est mis à jour immédiatement ;
/// - la valeur est normalisée avant application ;
/// - la valeur normalisée est ensuite persistée ;
/// - une valeur explicite de 0 reste toujours 0 ;
/// - les switches d'activation ne modifient jamais les valeurs numériques ;
/// - aucune valeur par défaut n'est injectée lorsqu'une valeur valide existe ;
/// - toute modification utilisateur empêche un chargement asynchrone tardif
///   de remplacer cette modification.
///
/// IMPORTANT :
///
/// `enableBlur == false` ne signifie PAS `blur == 0`.
///
/// De la même manière :
///
/// `enableGlow == false` ne signifie PAS `glowBlur == 0`.
///
/// Les valeurs numériques et les états d'activation sont volontairement
/// indépendants.
mixin GlassThemeNotifierEffects on Notifier<GlassThemeState> {
  // ==========================================================================
  // SHARED PREFERENCES
  // ==========================================================================

  SharedPreferences get _prefs;

  // ==========================================================================
  // USER CHANGE GUARD
  // ==========================================================================

  /// Signale qu'une modification explicite de l'apparence a été effectuée.
  ///
  /// Cette méthode est implémentée par [GlassThemeNotifier].
  ///
  /// Elle permet à `_loadFromStorage()` d'abandonner son chargement si
  /// l'utilisateur a déjà commencé à modifier l'apparence.
  void markAppearanceChanged();

  // ==========================================================================
  // HELPERS
  // ==========================================================================

  /// Normalise une valeur comprise entre [min] et [max].
  ///
  /// Le `clamp` est volontairement utilisé sans fallback :
  /// une valeur explicite de `0.0` reste donc `0.0`.
  double _clamp(
    double value,
    double min,
    double max,
  ) {
    return value.clamp(min, max).toDouble();
  }

  /// Persiste une valeur booléenne.
  Future<void> _saveBool(
    String key,
    bool value,
  ) {
    return GlassColorStorage.saveBool(
      key,
      value,
    );
  }

  /// Persiste une valeur numérique.
  Future<void> _saveDouble(
    String key,
    double value,
  ) {
    return GlassColorStorage.saveDouble(
      key,
      value,
    );
  }

  /// Marque immédiatement l'apparence comme modifiée par l'utilisateur.
  void _markChanged() {
    markAppearanceChanged();
  }

  // ==========================================================================
  // STYLE
  // ==========================================================================

  Future<void> setGlassStyle(
    GlassStyle style,
  );

  // ==========================================================================
  // GENERAL
  // ==========================================================================

  Future<void> setEnableBlur(
    bool value,
  ) async {
    _markChanged();

    state = state.copyWith(
      enableBlur: value,
    );

    await _saveBool(
      GlassThemeNotifier._enableBlurKey,
      value,
    );
  }

  Future<void> setEnableNoise(
    bool value,
  ) async {
    _markChanged();

    state = state.copyWith(
      enableNoise: value,
    );

    await _saveBool(
      GlassThemeNotifier._enableNoiseKey,
      value,
    );
  }

  Future<void> setEnableGlow(
    bool value,
  ) async {
    _markChanged();

    state = state.copyWith(
      enableGlow: value,
    );

    await _saveBool(
      GlassThemeNotifier._enableGlowKey,
      value,
    );
  }

  Future<void> setEnableShadow(
    bool value,
  ) async {
    _markChanged();

    state = state.copyWith(
      enableShadow: value,
    );

    await _saveBool(
      GlassThemeNotifier._enableShadowKey,
      value,
    );
  }

  Future<void> setEnableBorder(
    bool value,
  ) async {
    _markChanged();

    state = state.copyWith(
      enableBorder: value,
    );

    await _saveBool(
      GlassThemeNotifier._enableBorderKey,
      value,
    );
  }

  Future<void> setEnableGradient(
    bool value,
  ) async {
    _markChanged();

    state = state.copyWith(
      enableGradient: value,
    );

    await _saveBool(
      GlassThemeNotifier._enableGradientKey,
      value,
    );
  }

  Future<void> setEnableHover(
    bool value,
  ) async {
    _markChanged();

    state = state.copyWith(
      enableHover: value,
    );

    await _saveBool(
      GlassThemeNotifier._enableHoverKey,
      value,
    );
  }

  Future<void> setBreakerOn(
    bool value,
  ) async {
    _markChanged();

    state = state.copyWith(
      breakerOn: value,
    );

    await _saveBool(
      GlassThemeNotifier._breakerOnKey,
      value,
    );
  }

  // ==========================================================================
  // BLUR
  // ==========================================================================

  Future<void> setBlur(
    double value,
  ) async {
    _markChanged();

    final double safe = _clamp(
      value,
      0.0,
      100.0,
    );

    state = state.copyWith(
      blur: safe,
    );

    await _saveDouble(
      GlassThemeNotifier._blurKey,
      safe,
    );
  }

  // ==========================================================================
  // NOISE
  // ==========================================================================

  Future<void> setNoise(
    double value,
  ) async {
    _markChanged();

    final double safe = _clamp(
      value,
      0.0,
      1.0,
    );

    state = state.copyWith(
      noise: safe,
    );

    await _saveDouble(
      GlassThemeNotifier._noiseKey,
      safe,
    );
  }

  // ==========================================================================
  // GLOW
  // ==========================================================================

  Future<void> setGlowBlur(
    double value,
  ) async {
    _markChanged();

    final double safe = _clamp(
      value,
      0.0,
      100.0,
    );

    state = state.copyWith(
      glowBlur: safe,
    );

    await _saveDouble(
      GlassThemeNotifier._glowBlurKey,
      safe,
    );
  }

  Future<void> setGlowOpacity(
    double value,
  ) async {
    _markChanged();

    final double safe = _clamp(
      value,
      0.0,
      1.0,
    );

    state = state.copyWith(
      glowOpacity: safe,
    );

    await _saveDouble(
      GlassThemeNotifier._glowOpacityKey,
      safe,
    );
  }

  // ==========================================================================
  // SHADOW
  // ==========================================================================

  Future<void> setShadowBlur(
    double value,
  ) async {
    _markChanged();

    final double safe = _clamp(
      value,
      0.0,
      100.0,
    );

    state = state.copyWith(
      shadowBlur: safe,
    );

    await _saveDouble(
      GlassThemeNotifier._shadowBlurKey,
      safe,
    );
  }

  Future<void> setShadowOpacity(
    double value,
  ) async {
    _markChanged();

    final double safe = _clamp(
      value,
      0.0,
      1.0,
    );

    state = state.copyWith(
      shadowOpacity: safe,
    );

    await _saveDouble(
      GlassThemeNotifier._shadowOpacityKey,
      safe,
    );
  }

  Future<void> setShadowOffsetY(
    double value,
  ) async {
    _markChanged();

    final double safe = _clamp(
      value,
      -100.0,
      100.0,
    );

    state = state.copyWith(
      shadowOffsetY: safe,
    );

    await _saveDouble(
      GlassThemeNotifier._shadowOffsetYKey,
      safe,
    );
  }

  // ==========================================================================
  // HOVER
  // ==========================================================================

  Future<void> setHoverLift(
    double value,
  ) async {
    _markChanged();

    final double safe = _clamp(
      value,
      0.0,
      30.0,
    );

    state = state.copyWith(
      hoverLift: safe,
    );

    await _saveDouble(
      GlassThemeNotifier._hoverLiftKey,
      safe,
    );
  }

  // ==========================================================================
  // SURFACE
  // ==========================================================================

  Future<void> setSurfaceOpacity(
    double value,
  ) async {
    _markChanged();

    final double safe = _clamp(
      value,
      0.0,
      1.0,
    );

    state = state.copyWith(
      surfaceOpacity: safe,
    );

    await _saveDouble(
      GlassThemeNotifier._surfaceOpacityKey,
      safe,
    );
  }

  // ==========================================================================
  // BORDER
  // ==========================================================================

  Future<void> setBorderRadius(
    double value,
  ) async {
    _markChanged();

    final double safe = _clamp(
      value,
      0.0,
      160.0,
    );

    state = state.copyWith(
      borderRadius: safe,
    );

    await _saveDouble(
      GlassThemeNotifier._borderRadiusKey,
      safe,
    );
  }

  Future<void> setBorderWidth(
    double value,
  ) async {
    _markChanged();

    final double safe = _clamp(
      value,
      0.0,
      12.0,
    );

    state = state.copyWith(
      borderWidth: safe,
    );

    await _saveDouble(
      GlassThemeNotifier._borderWidthKey,
      safe,
    );
  }

  Future<void> setBorderOpacity(
    double value,
  ) async {
    _markChanged();

    final double safe = _clamp(
      value,
      0.0,
      1.0,
    );

    state = state.copyWith(
      borderOpacity: safe,
    );

    await _saveDouble(
      GlassThemeNotifier._borderOpacityKey,
      safe,
    );
  }

  // ==========================================================================
  // GRADIENT
  // ==========================================================================

  Future<void> setGradientDensity(
    double value,
  ) async {
    _markChanged();

    final double safe = _clamp(
      value,
      1.0,
      10.0,
    );

    state = state.copyWith(
      gradientDensity: safe,
    );

    await _saveDouble(
      GlassThemeNotifier._gradientDensityKey,
      safe,
    );
  }

  Future<void> setGradientOpacity(
    double value,
  ) async {
    _markChanged();

    final double safe = _clamp(
      value,
      0.0,
      1.0,
    );

    state = state.copyWith(
      gradientOpacity: safe,
    );

    await _saveDouble(
      GlassThemeNotifier._gradientOpacityKey,
      safe,
    );
  }

  // ==========================================================================
  // GRADIENT COLORS
  // ==========================================================================

  Future<void> setAquaGradient(
    List<Color> colors,
  ) async {
    _markChanged();

    final List<Color> value =
        List<Color>.unmodifiable(colors);

    state = state.copyWith(
      aquaGradient: value,
    );

    await GlassColorStorage.saveColorList(
      GlassThemeNotifier._aquaGradientKey,
      value,
    );
  }

  Future<void> setClassicGradient(
    List<Color> colors,
  ) async {
    _markChanged();

    final List<Color> value =
        List<Color>.unmodifiable(colors);

    state = state.copyWith(
      classicGradient: value,
    );

    await GlassColorStorage.saveColorList(
      GlassThemeNotifier._classicGradientKey,
      value,
    );
  }

  // ==========================================================================
  // DISPLAY : GLOBAL SETTINGS
  // ==========================================================================

  /// Met à jour toute la configuration d'affichage.
  ///
  /// La configuration est normalisée avant d'être appliquée.
  Future<void> setDisplaySettings(
    GlassDisplaySettings settings,
  ) async {
    _markChanged();

    final GlassDisplaySettings safe =
        settings.normalized();

    // ------------------------------------------------------------------------
    // APPLICATION IMMÉDIATE
    // ------------------------------------------------------------------------

    state = state.copyWith(
      display: safe,
    );

    // ------------------------------------------------------------------------
    // PERSISTANCE
    // ------------------------------------------------------------------------

    await Future.wait([
      _prefs.setDouble(
        GlassThemeNotifier._displayMaxWidthKey,
        safe.maxWidth,
      ),
      _prefs.setDouble(
        GlassThemeNotifier._displayZoomKey,
        safe.zoom,
      ),
      _prefs.setDouble(
        GlassThemeNotifier._displayDesktopPaddingKey,
        safe.desktopPadding,
      ),
      _prefs.setDouble(
        GlassThemeNotifier._displayTabletPaddingKey,
        safe.tabletPadding,
      ),
      _prefs.setDouble(
        GlassThemeNotifier._displayMobilePaddingKey,
        safe.mobilePadding,
      ),
      _prefs.setDouble(
        GlassThemeNotifier._displaySmallMobilePaddingKey,
        safe.smallMobilePadding,
      ),
      _prefs.setDouble(
        GlassThemeNotifier._displayTabletBreakpointKey,
        safe.tabletBreakpoint,
      ),
      _prefs.setDouble(
        GlassThemeNotifier._displayDesktopBreakpointKey,
        safe.desktopBreakpoint,
      ),
      _prefs.setString(
        GlassThemeNotifier._displayDensityKey,
        safe.density.name,
      ),
    ]);
  }

  // ==========================================================================
  // DISPLAY : ZOOM
  // ==========================================================================

  /// Définit le zoom global.
  ///
  /// Plage autorisée : 50 % → 200 %.
  Future<void> setDisplayZoom(
    double value,
  ) async {
    final double safe = _clamp(
      value,
      0.50,
      2.00,
    );

    await setDisplaySettings(
      state.display.copyWith(
        zoom: safe,
      ),
    );
  }

  // ==========================================================================
  // DISPLAY : MAX WIDTH
  // ==========================================================================

  /// Définit la largeur maximale du contenu.
  ///
  /// `0` signifie automatique.
  Future<void> setDisplayMaxWidth(
    double value,
  ) async {
    final double safe = value <= 0.0
        ? 0.0
        : _clamp(
            value,
            600.0,
            3000.0,
          );

    await setDisplaySettings(
      state.display.copyWith(
        maxWidth: safe,
      ),
    );
  }

  // ==========================================================================
  // DISPLAY : DESKTOP PADDING
  // ==========================================================================

  Future<void> setDisplayDesktopPadding(
    double value,
  ) async {
    final double safe = _clamp(
      value,
      0.0,
      100.0,
    );

    await setDisplaySettings(
      state.display.copyWith(
        desktopPadding: safe,
      ),
    );
  }

  // ==========================================================================
  // DISPLAY : TABLET PADDING
  // ==========================================================================

  Future<void> setDisplayTabletPadding(
    double value,
  ) async {
    final double safe = _clamp(
      value,
      0.0,
      100.0,
    );

    await setDisplaySettings(
      state.display.copyWith(
        tabletPadding: safe,
      ),
    );
  }

  // ==========================================================================
  // DISPLAY : MOBILE PADDING
  // ==========================================================================

  Future<void> setDisplayMobilePadding(
    double value,
  ) async {
    final double safe = _clamp(
      value,
      0.0,
      100.0,
    );

    await setDisplaySettings(
      state.display.copyWith(
        mobilePadding: safe,
      ),
    );
  }

  // ==========================================================================
  // DISPLAY : SMALL MOBILE PADDING
  // ==========================================================================

  Future<void> setDisplaySmallMobilePadding(
    double value,
  ) async {
    final double safe = _clamp(
      value,
      0.0,
      100.0,
    );

    await setDisplaySettings(
      state.display.copyWith(
        smallMobilePadding: safe,
      ),
    );
  }

  // ==========================================================================
  // DISPLAY : TABLET BREAKPOINT
  // ==========================================================================

  Future<void> setDisplayTabletBreakpoint(
    double value,
  ) async {
    final double safe = _clamp(
      value,
      400.0,
      1200.0,
    );

    await setDisplaySettings(
      state.display.copyWith(
        tabletBreakpoint: safe,
      ),
    );
  }

  // ==========================================================================
  // DISPLAY : DESKTOP BREAKPOINT
  // ==========================================================================

  Future<void> setDisplayDesktopBreakpoint(
    double value,
  ) async {
    final double safe = _clamp(
      value,
      800.0,
      2000.0,
    );

    await setDisplaySettings(
      state.display.copyWith(
        desktopBreakpoint: safe,
      ),
    );
  }

  // ==========================================================================
  // DISPLAY : DENSITY
  // ==========================================================================

  Future<void> setDisplayDensity(
    GlassDensity density,
  ) async {
    await setDisplaySettings(
      state.display.copyWith(
        density: density,
      ),
    );
  }

  // ==========================================================================
  // DISPLAY : PRESETS
  // ==========================================================================

  Future<void> setCompactDisplay() async {
    await setDisplaySettings(
      state.display.copyWith(
        density: GlassDensity.compact,
      ),
    );
  }

  Future<void> setComfortableDisplay() async {
    await setDisplaySettings(
      state.display.copyWith(
        density: GlassDensity.comfortable,
      ),
    );
  }

  Future<void> setSpaciousDisplay() async {
    await setDisplaySettings(
      state.display.copyWith(
        density: GlassDensity.spacious,
      ),
    );
  }

  // ==========================================================================
  // DISPLAY : RESET
  // ==========================================================================

  Future<void> resetDisplaySettings() async {
    await setDisplaySettings(
      GlassDisplaySettings.defaults,
    );
  }

  // ==========================================================================
  // RESET COMPLET
  // ==========================================================================

  /// Restaure les paramètres visuels par défaut.
  ///
  /// IMPORTANT :
  ///
  /// Les switches restent indépendants des valeurs numériques.
  ///
  /// Exemple :
  ///
  /// - `enableBlur = true`
  /// - `blur = 12`
  ///
  /// Le fait de désactiver Blur par la suite ne changera PAS `blur`.
  Future<void> reset() async {
    _markChanged();

    // ------------------------------------------------------------------------
    // STYLE
    // ------------------------------------------------------------------------

    await setGlassStyle(
      GlassStyle.transparentAqua,
    );

    // ------------------------------------------------------------------------
    // GRADIENTS
    // ------------------------------------------------------------------------
    //
    // Les valeurs par défaut sont récupérées depuis l'état initial du thème.
    // Elles restent donc centralisées dans GlassThemeState.
    // ------------------------------------------------------------------------

    const GlassThemeState defaults =
        GlassThemeState();

    await setAquaGradient(
      defaults.aquaGradient,
    );

    await setClassicGradient(
      defaults.classicGradient,
    );

    // ------------------------------------------------------------------------
    // BLUR
    // ------------------------------------------------------------------------

    await setBlur(12.0);
    await setNoise(0.0);

    await setEnableBlur(true);
    await setEnableNoise(false);

    // ------------------------------------------------------------------------
    // SURFACE
    // ------------------------------------------------------------------------

    await setSurfaceOpacity(1.0);

    // ------------------------------------------------------------------------
    // BORDER
    // ------------------------------------------------------------------------

    await setBorderRadius(20.0);
    await setBorderWidth(0.72);
    await setBorderOpacity(0.18);
    await setEnableBorder(true);

    // ------------------------------------------------------------------------
    // GLOW
    // ------------------------------------------------------------------------

    await setGlowBlur(18.0);
    await setGlowOpacity(0.18);
    await setEnableGlow(true);

    // ------------------------------------------------------------------------
    // HOVER
    // ------------------------------------------------------------------------

    await setHoverLift(3.0);
    await setEnableHover(true);

    // ------------------------------------------------------------------------
    // SHADOW
    // ------------------------------------------------------------------------

    await setShadowBlur(12.0);
    await setShadowOpacity(0.18);
    await setShadowOffsetY(7.0);
    await setEnableShadow(true);

    // ------------------------------------------------------------------------
    // BREAKER
    // ------------------------------------------------------------------------

    await setBreakerOn(false);

    // ------------------------------------------------------------------------
    // GRADIENT
    // ------------------------------------------------------------------------

    await setGradientDensity(2.0);
    await setGradientOpacity(1.0);
    await setEnableGradient(true);

    // ------------------------------------------------------------------------
    // DISPLAY
    // ------------------------------------------------------------------------

    await resetDisplaySettings();
  }
}