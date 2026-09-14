import 'package:flutter/foundation.dart';
import 'package:universal_glass/glass.dart';
import 'package:universal_glass_example/settings/widgets/appearance/models/appearance_operator_settings.dart';

import 'models/appearance_app_bar_settings.dart';
import 'models/appearance_component_settings.dart';
import 'models/appearance_form_settings.dart';
import 'models/appearance_input_settings.dart';
import 'models/appearance_toast_settings.dart';
import 'models/appearance_tooltip_settings.dart';

export 'models/appearance_app_bar_settings.dart';
export 'models/appearance_component_settings.dart';
export 'models/appearance_form_settings.dart';
export 'models/appearance_input_settings.dart';
export 'models/appearance_toast_settings.dart';
export 'models/appearance_tooltip_settings.dart';

/// Configuration complète de l'apparence de l'application.
///
/// Cette classe est le conteneur central de tous les réglages Appearance.
///
/// Elle distingue :
///
/// - les réglages globaux de Glass ;
/// - les réglages spécifiques à l'AppBar ;
/// - les réglages communs aux composants ;
/// - les réglages spécifiques aux champs ;
/// - les réglages des formulaires ;
/// - les réglages des Toast ;
/// - les réglages des Tooltip ;
/// - les réglages spécifiques aux opérateurs.
///
/// La classe est immutable.
///
/// Aucune logique Riverpod, stockage ou application de thème ne doit être
/// placée ici. Ces responsabilités appartiennent à [AppearanceController].
@immutable
class AppearanceSettings {
  // ===========================================================================
  // GLOBAL — THEME
  // ===========================================================================

  final String themeMode;
  final String glassStyle;

  // ===========================================================================
  // GLOBAL — COLORS
  // ===========================================================================

  final List<int> aquaColors;
  final List<int> classicColors;

  // ===========================================================================
  // GLOBAL — BLUR
  // ===========================================================================

  final bool enableBlur;
  final double blur;

  // ===========================================================================
  // GLOBAL — NOISE
  // ===========================================================================

  final bool enableNoise;
  final double noise;

  // ===========================================================================
  // GLOBAL — GRADIENT
  // ===========================================================================

  final bool enableGradient;
  final double gradientOpacity;
  final double gradientDensity;

  // ===========================================================================
  // GLOBAL — SURFACE
  // ===========================================================================

  final double surfaceOpacity;
  final double borderRadius;

  // ===========================================================================
  // GLOBAL — BORDER
  // ===========================================================================

  final bool enableBorder;
  final double borderOpacity;
  final double borderWidth;

  // ===========================================================================
  // GLOBAL — GLOW
  // ===========================================================================

  final bool enableGlow;
  final double glowOpacity;
  final double glowBlur;

  // ===========================================================================
  // GLOBAL — HOVER
  // ===========================================================================

  final bool enableHover;
  final double hoverLift;

  // ===========================================================================
  // GLOBAL — SHADOW
  // ===========================================================================

  final bool enableShadow;
  final double shadowOpacity;
  final double shadowBlur;
  final double shadowOffsetY;

  // ===========================================================================
  // SPECIALIZED SETTINGS
  // ===========================================================================

  /// Réglages visuels spécifiques de l'AppBar.
  ///
  /// Les propriétés contextuelles comme title, tabs, showBackButton, etc.
  /// restent dans UniversalAppBar.
  final AppearanceAppBarSettings appBar;

  /// Réglages visuels communs aux composants.
  final AppearanceComponentSettings component;

  /// Réglages visuels spécifiques aux champs et contrôles d'entrée.
  final AppearanceInputSettings input;

  /// Réglages visuels et structurels des formulaires.
  final AppearanceFormSettings form;

  /// Réglages visuels des Toast.
  final AppearanceToastSettings toast;

  /// Réglages visuels des Tooltip.
  final AppearanceTooltipSettings tooltip;

  /// Réglages spécifiques aux composants opérateurs.
  final AppearanceOperatorSettings operator;

  // ===========================================================================
  // CONSTRUCTOR
  // ===========================================================================

  const AppearanceSettings({
    this.themeMode = AppConstants.defaultThemeMode,
    this.glassStyle = AppConstants.defaultGlassStyle,

    this.aquaColors = AppConstants.defaultAquaColors,
    this.classicColors = AppConstants.defaultClassicColors,

    this.enableBlur = AppConstants.defaultEnableBlur,
    this.blur = AppConstants.defaultBlur,

    this.enableNoise = AppConstants.defaultEnableNoise,
    this.noise = AppConstants.defaultNoise,

    this.enableGradient = AppConstants.defaultEnableGradient,
    this.gradientOpacity = AppConstants.defaultGradientOpacity,
    this.gradientDensity = AppConstants.defaultGradientDensity,

    this.surfaceOpacity = AppConstants.defaultSurfaceOpacity,
    this.borderRadius = AppConstants.defaultBorderRadius,

    this.enableBorder = AppConstants.defaultEnableBorder,
    this.borderOpacity = AppConstants.defaultBorderOpacity,
    this.borderWidth = AppConstants.defaultBorderWidth,

    this.enableGlow = AppConstants.defaultEnableGlow,
    this.glowOpacity = AppConstants.defaultGlowOpacity,
    this.glowBlur = AppConstants.defaultGlowBlur,

    this.enableHover = AppConstants.defaultEnableHover,
    this.hoverLift = AppConstants.defaultHoverLift,

    this.enableShadow = AppConstants.defaultEnableShadow,
    this.shadowOpacity = AppConstants.defaultShadowOpacity,
    this.shadowBlur = AppConstants.defaultShadowBlur,
    this.shadowOffsetY = AppConstants.defaultShadowOffsetY,

    this.appBar = const AppearanceAppBarSettings(),
    this.component = const AppearanceComponentSettings(),
    this.input = const AppearanceInputSettings(),
    this.form = const AppearanceFormSettings(),
    this.toast = const AppearanceToastSettings(),
    this.tooltip = const AppearanceTooltipSettings(),
    this.operator = const AppearanceOperatorSettings(),
  });

  // ===========================================================================
  // COPY WITH
  // ===========================================================================

  AppearanceSettings copyWith({
    String? themeMode,
    String? glassStyle,

    List<int>? aquaColors,
    List<int>? classicColors,

    bool? enableBlur,
    double? blur,

    bool? enableNoise,
    double? noise,

    bool? enableGradient,
    double? gradientOpacity,
    double? gradientDensity,

    double? surfaceOpacity,
    double? borderRadius,

    bool? enableBorder,
    double? borderOpacity,
    double? borderWidth,

    bool? enableGlow,
    double? glowOpacity,
    double? glowBlur,

    bool? enableHover,
    double? hoverLift,

    bool? enableShadow,
    double? shadowOpacity,
    double? shadowBlur,
    double? shadowOffsetY,

    AppearanceAppBarSettings? appBar,
    AppearanceComponentSettings? component,
    AppearanceInputSettings? input,
    AppearanceFormSettings? form,
    AppearanceToastSettings? toast,
    AppearanceTooltipSettings? tooltip,
    AppearanceOperatorSettings? operator,
  }) {
    return AppearanceSettings(
      themeMode: themeMode ?? this.themeMode,
      glassStyle: glassStyle ?? this.glassStyle,

      aquaColors: aquaColors ?? this.aquaColors,
      classicColors: classicColors ?? this.classicColors,

      enableBlur: enableBlur ?? this.enableBlur,
      blur: blur ?? this.blur,

      enableNoise: enableNoise ?? this.enableNoise,
      noise: noise ?? this.noise,

      enableGradient: enableGradient ?? this.enableGradient,
      gradientOpacity: gradientOpacity ?? this.gradientOpacity,
      gradientDensity: gradientDensity ?? this.gradientDensity,

      surfaceOpacity: surfaceOpacity ?? this.surfaceOpacity,
      borderRadius: borderRadius ?? this.borderRadius,

      enableBorder: enableBorder ?? this.enableBorder,
      borderOpacity: borderOpacity ?? this.borderOpacity,
      borderWidth: borderWidth ?? this.borderWidth,

      enableGlow: enableGlow ?? this.enableGlow,
      glowOpacity: glowOpacity ?? this.glowOpacity,
      glowBlur: glowBlur ?? this.glowBlur,

      enableHover: enableHover ?? this.enableHover,
      hoverLift: hoverLift ?? this.hoverLift,

      enableShadow: enableShadow ?? this.enableShadow,
      shadowOpacity: shadowOpacity ?? this.shadowOpacity,
      shadowBlur: shadowBlur ?? this.shadowBlur,
      shadowOffsetY: shadowOffsetY ?? this.shadowOffsetY,

      appBar: appBar ?? this.appBar,
      component: component ?? this.component,
      input: input ?? this.input,
      form: form ?? this.form,
      toast: toast ?? this.toast,
      tooltip: tooltip ?? this.tooltip,
      operator: operator ?? this.operator,
    );
  }

  // ===========================================================================
  // EFFECTIVE GLOBAL VALUES
  // ===========================================================================

  /// Blur global effectif.
  double get effectiveBlur {
    if (!enableBlur) {
      return 0.0;
    }

    return blur;
  }

  /// Noise global effectif.
  double get effectiveNoise {
    if (!enableNoise) {
      return 0.0;
    }

    return noise;
  }

  /// Opacité du gradient effective.
  double get effectiveGradientOpacity {
    if (!enableGradient) {
      return 0.0;
    }

    return gradientOpacity;
  }

  /// Densité du gradient effective.
  double get effectiveGradientDensity {
    if (!enableGradient) {
      return 0.0;
    }

    return gradientDensity;
  }

  /// Opacité globale de la surface.
  double get effectiveSurfaceOpacity {
    return surfaceOpacity;
  }

  /// Rayon global des surfaces.
  double get effectiveBorderRadius {
    return borderRadius;
  }

  /// Opacité globale de la bordure.
  double get effectiveBorderOpacity {
    if (!enableBorder) {
      return 0.0;
    }

    return borderOpacity;
  }

  /// Épaisseur globale de la bordure.
  double get effectiveBorderWidth {
    if (!enableBorder) {
      return 0.0;
    }

    return borderWidth;
  }

  /// Opacité globale du glow.
  double get effectiveGlowOpacity {
    if (!enableGlow) {
      return 0.0;
    }

    return glowOpacity;
  }

  /// Blur global du glow.
  double get effectiveGlowBlur {
    if (!enableGlow) {
      return 0.0;
    }

    return glowBlur;
  }

  /// Élévation/lift global du hover.
  double get effectiveHoverLift {
    if (!enableHover) {
      return 0.0;
    }

    return hoverLift;
  }

  /// Opacité globale de l'ombre.
  double get effectiveShadowOpacity {
    if (!enableShadow) {
      return 0.0;
    }

    return shadowOpacity;
  }

  /// Blur global de l'ombre.
  double get effectiveShadowBlur {
    if (!enableShadow) {
      return 0.0;
    }

    return shadowBlur;
  }

  /// Décalage vertical global de l'ombre.
  double get effectiveShadowOffsetY {
    if (!enableShadow) {
      return 0.0;
    }

    return shadowOffsetY;
  }

  // ===========================================================================
  // EFFECTIVE COMPONENT
  // ===========================================================================

  AppearanceComponentSettings get effectiveComponent {
    return component;
  }

  // ===========================================================================
  // ACTIVE COLORS
  // ===========================================================================

  /// Retourne la palette correspondant au style actuel.
  ///
  /// Les styles explicitement Classic utilisent [classicColors].
  /// Les autres styles utilisent [aquaColors].
  List<int> get activeColors {
    switch (glassStyle.toLowerCase()) {
      case 'solidclassic':
      case 'classic':
      case 'opaquemat':
      case 'opaqueheavy':
      case 'gradientopaque':
      case 'classicsb':
        return List<int>.unmodifiable(classicColors);

      case 'transparentaqua':
      case 'solidaqua':
      case 'customgradient':
      case 'transparentred':
      case 'transparentgreen':
      case 'custom':
      default:
        return List<int>.unmodifiable(aquaColors);
    }
  }

  // ===========================================================================
  // JSON
  // ===========================================================================

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'themeMode': themeMode,
      'glassStyle': glassStyle,

      'aquaColors': List<int>.from(aquaColors),
      'classicColors': List<int>.from(classicColors),

      'enableBlur': enableBlur,
      'blur': blur,

      'enableNoise': enableNoise,
      'noise': noise,

      'enableGradient': enableGradient,
      'gradientOpacity': gradientOpacity,
      'gradientDensity': gradientDensity,

      'surfaceOpacity': surfaceOpacity,
      'borderRadius': borderRadius,

      'enableBorder': enableBorder,
      'borderOpacity': borderOpacity,
      'borderWidth': borderWidth,

      'enableGlow': enableGlow,
      'glowOpacity': glowOpacity,
      'glowBlur': glowBlur,

      'enableHover': enableHover,
      'hoverLift': hoverLift,

      'enableShadow': enableShadow,
      'shadowOpacity': shadowOpacity,
      'shadowBlur': shadowBlur,
      'shadowOffsetY': shadowOffsetY,

      // Specialized settings.
      'appBar': appBar.toJson(),
      'component': component.toJson(),
      'input': input.toJson(),
      'form': form.toJson(),
      'toast': toast.toJson(),
      'tooltip': tooltip.toJson(),

      // Operator settings.
      'operator': operator.toJson(),
    };
  }

  // ===========================================================================
  // FROM JSON
  // ===========================================================================

  factory AppearanceSettings.fromJson(
    Map<String, dynamic> json,
  ) {
    return AppearanceSettings(
      themeMode: _readString(
        json,
        'themeMode',
        AppConstants.defaultThemeMode,
      ),

      glassStyle: _readString(
        json,
        'glassStyle',
        AppConstants.defaultGlassStyle,
      ),

      aquaColors: _readIntList(
        json,
        'aquaColors',
        AppConstants.defaultAquaColors,
      ),

      classicColors: _readIntList(
        json,
        'classicColors',
        AppConstants.defaultClassicColors,
      ),

      enableBlur: _readBool(
        json,
        'enableBlur',
        AppConstants.defaultEnableBlur,
      ),

      blur: _readDouble(
        json,
        'blur',
        AppConstants.defaultBlur,
      ),

      enableNoise: _readBool(
        json,
        'enableNoise',
        AppConstants.defaultEnableNoise,
      ),

      noise: _readDouble(
        json,
        'noise',
        AppConstants.defaultNoise,
      ),

      enableGradient: _readBool(
        json,
        'enableGradient',
        AppConstants.defaultEnableGradient,
      ),

      gradientOpacity: _readDouble(
        json,
        'gradientOpacity',
        AppConstants.defaultGradientOpacity,
      ),

      gradientDensity: _readDouble(
        json,
        'gradientDensity',
        AppConstants.defaultGradientDensity,
      ),

      surfaceOpacity: _readDouble(
        json,
        'surfaceOpacity',
        AppConstants.defaultSurfaceOpacity,
      ),

      borderRadius: _readDouble(
        json,
        'borderRadius',
        AppConstants.defaultBorderRadius,
      ),

      enableBorder: _readBool(
        json,
        'enableBorder',
        AppConstants.defaultEnableBorder,
      ),

      borderOpacity: _readDouble(
        json,
        'borderOpacity',
        AppConstants.defaultBorderOpacity,
      ),

      borderWidth: _readDouble(
        json,
        'borderWidth',
        AppConstants.defaultBorderWidth,
      ),

      enableGlow: _readBool(
        json,
        'enableGlow',
        AppConstants.defaultEnableGlow,
      ),

      glowOpacity: _readDouble(
        json,
        'glowOpacity',
        AppConstants.defaultGlowOpacity,
      ),

      glowBlur: _readDouble(
        json,
        'glowBlur',
        AppConstants.defaultGlowBlur,
      ),

      enableHover: _readBool(
        json,
        'enableHover',
        AppConstants.defaultEnableHover,
      ),

      hoverLift: _readDouble(
        json,
        'hoverLift',
        AppConstants.defaultHoverLift,
      ),

      enableShadow: _readBool(
        json,
        'enableShadow',
        AppConstants.defaultEnableShadow,
      ),

      shadowOpacity: _readDouble(
        json,
        'shadowOpacity',
        AppConstants.defaultShadowOpacity,
      ),

      shadowBlur: _readDouble(
        json,
        'shadowBlur',
        AppConstants.defaultShadowBlur,
      ),

      shadowOffsetY: _readDouble(
        json,
        'shadowOffsetY',
        AppConstants.defaultShadowOffsetY,
      ),

      // Specialized settings.
      appBar: AppearanceAppBarSettings.fromJson(
        _readMap(json, 'appBar'),
      ),

      component: AppearanceComponentSettings.fromJson(
        _readMap(json, 'component'),
      ),

      input: AppearanceInputSettings.fromJson(
        _readMap(json, 'input'),
      ),

      form: AppearanceFormSettings.fromJson(
        _readMap(json, 'form'),
      ),

      toast: AppearanceToastSettings.fromJson(
        _readMap(json, 'toast'),
      ),

      tooltip: AppearanceTooltipSettings.fromJson(
        _readMap(json, 'tooltip'),
      ),

      // Operator settings.
      //
      // Si la clé n'existe pas dans une ancienne configuration,
      // _readMap() retourne une Map vide et AppearanceOperatorSettings
      // utilise alors ses valeurs par défaut.
      operator: AppearanceOperatorSettings.fromJson(
        _readMap(json, 'operator'),
      ),
    );
  }

  // ===========================================================================
  // JSON HELPERS
  // ===========================================================================

  static String _readString(
    Map<String, dynamic> json,
    String key,
    String fallback,
  ) {
    final dynamic value = json[key];

    if (value is String && value.isNotEmpty) {
      return value;
    }

    return fallback;
  }

  static bool _readBool(
    Map<String, dynamic> json,
    String key,
    bool fallback,
  ) {
    final dynamic value = json[key];

    if (value is bool) {
      return value;
    }

    return fallback;
  }

  static double _readDouble(
    Map<String, dynamic> json,
    String key,
    double fallback,
  ) {
    final dynamic value = json[key];

    if (value is num) {
      final double result = value.toDouble();

      if (result.isFinite) {
        return result;
      }
    }

    return fallback;
  }

  static List<int> _readIntList(
    Map<String, dynamic> json,
    String key,
    List<int> fallback,
  ) {
    final dynamic value = json[key];

    if (value is List) {
      final List<int> result = <int>[];

      for (final dynamic item in value) {
        if (item is int) {
          result.add(item);
        } else if (item is num) {
          result.add(item.toInt());
        }
      }

      if (result.isNotEmpty) {
        return List<int>.unmodifiable(result);
      }
    }

    return List<int>.unmodifiable(fallback);
  }

  static Map<String, dynamic> _readMap(
    Map<String, dynamic> json,
    String key,
  ) {
    final dynamic value = json[key];

    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }

    return <String, dynamic>{};
  }
}