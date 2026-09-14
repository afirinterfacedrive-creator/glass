
import 'package:flutter/material.dart';

/// Constantes centrales de Universal Glass.
///
/// Cette classe ne contient aucune logique métier.
/// Elle centralise uniquement les valeurs utilisées par les différents
/// composants du système Glass.
///
/// Les valeurs de configuration modifiables par l'utilisateur restent
/// dans les modèles [AppearanceSettings] et associés.
/// Cette classe contient uniquement leurs valeurs par défaut, limites
/// et clés de persistance.
class AppConstants {
  const AppConstants._();

  // ===========================================================================
  // APP BAR
  // ===========================================================================

  /// Opacité minimale structurelle de l'AppBar.
  ///
  /// Même si Surface Opacity ou un gradient très transparent est utilisé,
  /// l'AppBar ne descendra jamais sous cette valeur.
  static const double appBarMinimumAlpha = 0.94;

  /// Opacité utilisée pour la partie basse du gradient AppBar.
  static const double appBarGradientBottomAlpha = 0.94;

  /// Intensité de teinte spécifique à l'AppBar.
  static const double appBarTintMultiplier = 1.00;

  // ===========================================================================
  // SURFACE ROLES
  // ===========================================================================

  static const double roleTintCard = 1.00;
  static const double roleTintField = 1.05;
  static const double roleTintPanel = 1.10;
  static const double roleTintHeader = 1.10;
  static const double roleTintBody = 1.08;
  static const double roleTintFooter = 1.12;
  static const double roleTintDialog = 1.28;
  static const double roleTintModal = 1.38;
  static const double roleTintTooltip = 1.18;
  static const double roleTintMenu = 1.22;

  // ===========================================================================
  // GRADIENT
  // ===========================================================================

  /// Alpha de départ utilisé par les gradients dynamiques.
  static const double gradientStartAlpha = 1.00;

  /// Alpha de fin utilisé par les gradients dynamiques.
  ///
  /// Permet d'obtenir une légère diminution d'intensité vers la fin du
  /// gradient tout en conservant un rendu visuel riche.
  static const double gradientEndAlpha = 0.85;

  /// Facteur de transparence appliqué à la seconde couleur d'un
  /// gradient Glass transparent.
  static const double transparentGlassBottomFactor = 0.55;

  /// Facteur de transparence appliqué à la seconde couleur d'un
  /// gradient Glass AppBar.
  static const double appBarGlassBottomFactor = 0.94;

  /// Direction par défaut du gradient.
  static const Alignment gradientBegin = Alignment.topLeft;

  static const Alignment gradientEnd = Alignment.bottomRight;

  /// Direction verticale utilisée lorsque nécessaire.
  static const Alignment gradientVerticalBegin = Alignment.topCenter;

  static const Alignment gradientVerticalEnd = Alignment.bottomCenter;

  // ===========================================================================
  // ALPHA
  // ===========================================================================

  static const double fullOpacity = 1.0;

  static const double transparentOpacity = 0.0;

  /// Opacité standard d'un contenu désactivé.
  static const double disabledContentOpacity = 0.40;

  /// Alias conservé pour compatibilité avec le code existant.
  static const double disabledTextOpacity = 0.40;

  // ===========================================================================
  // BORDER
  // ===========================================================================

  static const double minBorderWidth = 0.0;
  static const double maxBorderWidth = 12.0;

  static const double minBorderOpacity = 0.0;
  static const double maxBorderOpacity = 1.0;

  // ===========================================================================
  // RADIUS
  // ===========================================================================

  static const double minBorderRadius = 0.0;
  static const double maxBorderRadius = 160.0;

  // ===========================================================================
  // BLUR
  // ===========================================================================

  static const double minBlur = 0.0;
  static const double maxBlur = 100.0;

  // ===========================================================================
  // NOISE
  // ===========================================================================

  static const double minNoise = 0.0;
  static const double maxNoise = 1.0;

  // ===========================================================================
  // SHADOW
  // ===========================================================================

  static const double minShadowBlur = 0.0;
  static const double maxShadowBlur = 100.0;

  static const double minShadowOpacity = 0.0;
  static const double maxShadowOpacity = 1.0;

  static const double minShadowOffsetY = -100.0;
  static const double maxShadowOffsetY = 100.0;

  // ===========================================================================
  // GLOW
  // ===========================================================================

  static const double minGlowBlur = 0.0;
  static const double maxGlowBlur = 100.0;

  static const double minGlowOpacity = 0.0;
  static const double maxGlowOpacity = 1.0;

  // ===========================================================================
  // APPEARANCE — PERSISTENCE
  // ===========================================================================

  /// Clé principale utilisée pour sauvegarder toute la configuration
  /// Appearance sous forme JSON.
  static const String appearanceSettingsKey =
      'appearance_settings_v2';

  /// Anciennes clés conservées pour permettre au contrôleur de lire
  /// les anciennes configurations.
  static const String appearanceThemeModeKey =
      'appearance_theme_mode';

  static const String appearanceGlassStyleKey =
      'appearance_glass_style';

  static const String appearanceAquaColorsKey =
      'appearance_aqua_colors';

  static const String appearanceClassicColorsKey =
      'appearance_classic_colors';

  static const String appearanceEnableBlurKey =
      'appearance_enable_blur';

  static const String appearanceBlurKey =
      'appearance_blur';

  static const String appearanceEnableNoiseKey =
      'appearance_enable_noise';

  static const String appearanceNoiseKey =
      'appearance_noise';

  static const String appearanceEnableGradientKey =
      'appearance_enable_gradient';

  static const String appearanceGradientOpacityKey =
      'appearance_gradient_opacity';

  static const String appearanceGradientDensityKey =
      'appearance_gradient_density';

  static const String appearanceSurfaceOpacityKey =
      'appearance_surface_opacity';

  static const String appearanceBorderRadiusKey =
      'appearance_border_radius';

  static const String appearanceEnableBorderKey =
      'appearance_enable_border';

  static const String appearanceBorderOpacityKey =
      'appearance_border_opacity';

  static const String appearanceBorderWidthKey =
      'appearance_border_width';

  static const String appearanceEnableGlowKey =
      'appearance_enable_glow';

  static const String appearanceGlowOpacityKey =
      'appearance_glow_opacity';

  static const String appearanceGlowBlurKey =
      'appearance_glow_blur';

  static const String appearanceEnableHoverKey =
      'appearance_enable_hover';

  static const String appearanceHoverLiftKey =
      'appearance_hover_lift';

  static const String appearanceEnableShadowKey =
      'appearance_enable_shadow';

  static const String appearanceShadowOpacityKey =
      'appearance_shadow_opacity';

  static const String appearanceShadowBlurKey =
      'appearance_shadow_blur';

  static const String appearanceShadowOffsetYKey =
      'appearance_shadow_offset_y';

  // ===========================================================================
  // APPEARANCE — GLOBAL DEFAULTS
  // ===========================================================================

  /// Mode d'apparence initial.
  static const String defaultThemeMode = 'system';

  /// Style Glass initial.
  static const String defaultGlassStyle = 'aqua';

  /// Palette Aqua par défaut.
  ///
  /// Ces valeurs sont conservées pour la compatibilité avec le style
  /// Aqua existant de Universal Glass.
  static const List<int> defaultAquaColors = <int>[
    0xFF4DD0E1,
    0xFF00BCD4,
  ];

  /// Palette Classic par défaut.
  ///
  /// Le style Classic utilise volontairement des tons sombres et neutres.
  static const List<int> defaultClassicColors = <int>[
    0xFF121212,
    0xFF1A1A1A,
  ];

  /// Blur global par défaut.
  static const bool defaultEnableBlur = true;
  static const double defaultBlur = 12.0;

  /// Noise désactivé par défaut.
  static const bool defaultEnableNoise = false;
  static const double defaultNoise = 0.0;

  /// Gradient activé par défaut.
  static const bool defaultEnableGradient = true;
  static const double defaultGradientOpacity = 1.0;
  static const double defaultGradientDensity = 2.0;

  /// Opacité globale des surfaces.
  static const double defaultSurfaceOpacity = 1.0;

  /// Rayon global par défaut.
  static const double defaultBorderRadius = 20.0;

  /// Bordure globale.
  static const bool defaultEnableBorder = true;
  static const double defaultBorderOpacity = 0.18;
  static const double defaultBorderWidth = 0.72;

  /// Glow global.
  static const bool defaultEnableGlow = true;
  static const double defaultGlowOpacity = 0.18;
  static const double defaultGlowBlur = 18.0;

  /// Hover global.
  static const bool defaultEnableHover = true;
  static const double defaultHoverLift = 3.0;

  /// Ombre globale.
  static const bool defaultEnableShadow = true;
  static const double defaultShadowOpacity = 0.18;
  static const double defaultShadowBlur = 12.0;
  static const double defaultShadowOffsetY = 7.0;

  // ===========================================================================
  // APPEARANCE — COMPONENT DEFAULTS
  // ===========================================================================

  static const bool componentDefaultEnabled = true;

  static const bool componentDefaultEnableBlur = true;
  static const double componentDefaultBlur = 12.0;

  static const double componentDefaultBackgroundOpacity = 0.78;

  static const bool componentDefaultEnableBorder = true;
  static const double componentDefaultBorderOpacity = 0.14;
  static const double componentDefaultBorderWidth = 0.70;
  static const double componentDefaultBorderRadius = 18.0;

  static const bool componentDefaultEnableShadow = true;
  static const double componentDefaultShadowOpacity = 0.12;
  static const double componentDefaultShadowBlur = 10.0;
  static const double componentDefaultShadowOffsetY = 4.0;

  static const bool componentDefaultEnableHover = false;
  static const double componentDefaultHoverLift = 0.0;
  static const double componentverticalPadding = 16.0;
  static const double componenthorizontalPadding = 12.0;
 //this.horizontalPadding = 16.0, // <- AJOUTE
   // this.verticalPadding = 12.0,   // 
  // ===========================================================================
  // APPEARANCE — INPUT DEFAULTS
  // ===========================================================================

  static const bool inputDefaultEnabled = true;

  static const bool inputDefaultEnableBlur = true;
  static const double inputDefaultBlur = 8.0;

  static const double inputDefaultBackgroundOpacity = 0.62;

  static const bool inputDefaultEnableBorder = true;
  static const double inputDefaultBorderOpacity = 0.14;
  static const double inputDefaultBorderWidth = 0.70;
  static const double inputDefaultBorderRadius = 14.0;

  static const bool inputDefaultEnableShadow = true;
  static const double inputDefaultShadowOpacity = 0.08;
  static const double inputDefaultShadowBlur = 6.0;
  static const double inputDefaultShadowOffsetY = 2.0;

  static const bool inputDefaultEnableHover = false;
  static const double inputDefaultHoverLift = 0.0;

  static const double inputDefaultFieldHeight = 55.0;
  static const double inputDefaultHorizontalPadding = 16.0;
  static const double inputDefaultVerticalPadding = 8.0;

  // ===========================================================================
  // APPEARANCE — FORM DEFAULTS
  // ===========================================================================

  static const bool formDefaultEnabled = true;

  static const bool formDefaultEnableBlur = true;
  static const double formDefaultBlur = 10.0;

  static const double formDefaultBackgroundOpacity = 0.70;

  static const bool formDefaultEnableBorder = true;
  static const double formDefaultBorderOpacity = 0.12;
  static const double formDefaultBorderWidth = 0.70;
  static const double formDefaultBorderRadius = 16.0;

  static const bool formDefaultEnableShadow = true;
  static const double formDefaultShadowOpacity = 0.10;
  static const double formDefaultShadowBlur = 8.0;
  static const double formDefaultShadowOffsetY = 3.0;

  static const double formDefaultFieldSpacing = 14.0;
  static const double formDefaultSectionSpacing = 24.0;
  static const double formDefaultActionsSpacing = 12.0;

  static const double formDefaultHorizontalPadding = 18.0;
  static const double formDefaultVerticalPadding = 18.0;

  // ===========================================================================
  // APPEARANCE — TOAST DEFAULTS
  // ===========================================================================

  static const bool toastDefaultEnabled = true;

  static const bool toastDefaultEnableBlur = true;
  static const double toastDefaultBlur = 14.0;

  static const double toastDefaultBackgroundOpacity = 0.92;

  static const bool toastDefaultEnableBorder = true;
  static const double toastDefaultBorderOpacity = 0.14;
  static const double toastDefaultBorderWidth = 0.70;
  static const double toastDefaultBorderRadius = 16.0;

  static const bool toastDefaultEnableShadow = true;
  static const double toastDefaultShadowOpacity = 0.18;
  static const double toastDefaultShadowBlur = 14.0;
  static const double toastDefaultShadowOffsetY = 6.0;

  static const double toastDefaultHorizontalPadding = 16.0;
  static const double toastDefaultVerticalPadding = 12.0;

  static const double toastDefaultMaxWidth = 420.0;
  static const double toastDefaultDuration = 3.0;

  // ===========================================================================
  // APPEARANCE — TOOLTIP DEFAULTS
  // ===========================================================================

  static const bool tooltipDefaultEnabled = true;

  static const bool tooltipDefaultEnableBlur = true;
  static const double tooltipDefaultBlur = 10.0;

  static const double tooltipDefaultBackgroundOpacity = 0.94;

  static const bool tooltipDefaultEnableBorder = true;
  static const double tooltipDefaultBorderOpacity = 0.12;
  static const double tooltipDefaultBorderWidth = 0.60;
  static const double tooltipDefaultBorderRadius = 10.0;

  static const bool tooltipDefaultEnableShadow = true;
  static const double tooltipDefaultShadowOpacity = 0.12;
  static const double tooltipDefaultShadowBlur = 8.0;
  static const double tooltipDefaultShadowOffsetY = 3.0;

  static const double tooltipDefaultHorizontalPadding = 12.0;
  static const double tooltipDefaultVerticalPadding = 8.0;

  static const double tooltipDefaultMaxWidth = 320.0;
  static const double tooltipDefaultWaitDuration = 0.5;
  static const double tooltipDefaultShowDuration = 4.0;

  // ===========================================================================
  // APPEARANCE — COMMON LIMITS
  // ===========================================================================

  static const double minOpacity = 0.0;
  static const double maxOpacity = 1.0;

  static const double minHoverLift = 0.0;
  static const double maxHoverLift = 30.0;

  static const double minComponentRadius = 0.0;
  static const double maxComponentRadius = 100.0;

  // ===========================================================================
  // APPEARANCE — INPUT LIMITS
  // ===========================================================================

  static const double minFieldHeight = 32.0;
  static const double maxFieldHeight = 120.0;

  static const double minInputHorizontalPadding = 0.0;
  static const double maxInputHorizontalPadding = 60.0;

  static const double minInputVerticalPadding = 0.0;
  static const double maxInputVerticalPadding = 40.0;

  // ===========================================================================
  // APPEARANCE — FORM LIMITS
  // ===========================================================================

  static const double minFormSpacing = 0.0;
  static const double maxFormSpacing = 100.0;

  static const double minFormPadding = 0.0;
  static const double maxFormPadding = 100.0;

  // ===========================================================================
  // APPEARANCE — TOAST LIMITS
  // ===========================================================================

  static const double minToastMaxWidth = 120.0;
  static const double maxToastMaxWidth = 1000.0;

  static const double minToastDuration = 0.5;
  static const double maxToastDuration = 30.0;

  // ===========================================================================
  // APPEARANCE — TOOLTIP LIMITS
  // ===========================================================================

  static const double minTooltipMaxWidth = 100.0;
  static const double maxTooltipMaxWidth = 800.0;

  static const double minTooltipWaitDuration = 0.0;
  static const double maxTooltipWaitDuration = 10.0;

  static const double minTooltipShowDuration = 0.5;
  static const double maxTooltipShowDuration = 30.0;

  // ===========================================================================
  // COLORS
  // ===========================================================================

  /// Couleur d'accent historique utilisée par certains composants.
  ///
  /// La palette d'apparence reste toutefois prioritaire pour les nouveaux
  /// composants afin d'éviter de multiplier les couleurs codées en dur.
  static const Color aquaAccent = Colors.cyanAccent;

  /// Couleur d'accent historique conservée pour compatibilité.
  static const Color classicAccent = Colors.orangeAccent;

  /// Couleurs historiques utilisées par certains effets transparents.
  static const Color transparentRed = Colors.redAccent;

  static const Color transparentGreen = Colors.greenAccent;

  static const Color white = Colors.white;

  static const Color black = Colors.black;



  // ==========================================================================
  // APPEARANCE APP BAR DEFAULTS
  // ==========================================================================

  static const bool appBarDefaultEnabled = true;

  static const bool appBarDefaultUseGradientBackground = true;

  static const bool appBarDefaultCompactMode = false;

  /// null = hauteur responsive automatique.
  static const double? appBarDefaultHeight = null;

  // ACTION BUTTONS
  static const double appBarDefaultActionBackgroundOpacity = 0.14;
  static const double appBarDefaultActionAccentOpacity = 0.07;
  static const double appBarDefaultActionBorderOpacity = 0.20;
  static const double appBarDefaultActionBorderWidth = 0.80;
  static const double appBarDefaultActionShadowOpacity = 0.06;
  static const double appBarDefaultActionShadowBlur = 8.0;
  static const double appBarDefaultActionShadowOffsetY = 1.0;

// APP BAR SHADOW
static const double appBarDefaultShadowOpacity = 0.10;
static const double appBarDefaultNormalShadowOpacity = 0.045;

  // ==========================================================================
  // APP BAR LIMITS
  // ==========================================================================

  static const double minAppBarHeight = 56.0;
  static const double maxAppBarHeight = 200.0;

  static const double minAppBarActionBorderWidth = 0.0;
  static const double maxAppBarActionBorderWidth = 12.0;

  static const double minAppBarActionShadowBlur = 0.0;
  static const double maxAppBarActionShadowBlur = 100.0;

  static const double minAppBarActionShadowOffsetY = -100.0;
  static const double maxAppBarActionShadowOffsetY = 100.0;


}
