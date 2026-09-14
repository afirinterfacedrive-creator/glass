import 'package:flutter/foundation.dart';
import 'package:universal_glass/glass.dart';
/// ============================================================================
/// APPEARANCE APP BAR SETTINGS
/// ============================================================================
/// Paramètres visuels et comportementaux globaux de l'AppBar.
/// Cette classe ne contient PAS les paramètres contextuels propres à une
/// instance de [UniversalAppBar], tels que :
/// - title
/// - subtitle
/// - showLogo
/// - showBackButton
/// - onBack
/// - actions
/// - tabs
/// - hideNavigation
/// Ces propriétés restent du ressort de [UniversalAppBar].
/// Les couleurs ne sont pas stockées ici.
/// Elles restent centralisées dans le système de palette Universal Glass.
/// Cette classe appartient à l'exemple et sert principalement à piloter
/// l'interface de configuration Appearance.
/// ============================================================================
@immutable
class AppearanceAppBarSettings{
  // ==========================================================================
  // GLOBAL
  // ==========================================================================
  /// Active ou désactive les personnalisations Appearance de l'AppBar.
  final bool enabled;
  /// Utilise le rendu de fond avec gradient pour l'AppBar.
  /// Le rendu final du fond reste assuré par la couche de scaffold/surface.
  /// Ce paramètre permet toutefois de contrôler le comportement visuel
  /// global de l'AppBar depuis Appearance.
  final bool useGradientBackground;
  /// Active le mode compact de l'AppBar.
  /// Lorsque false, la hauteur responsive de UniversalAppBar est conservée.
  final bool compactMode;
  /// Hauteur explicite de l'AppBar.
  /// null = comportement responsive automatique de UniversalAppBar.
  final double? height;
  // ==========================================================================
  // ACTION BUTTONS
  // ==========================================================================
  /// Opacité du fond blanc des boutons d'action.
  final double actionBackgroundOpacity;
  /// Opacité de la teinte accent appliquée au fond des boutons d'action.
  final double actionAccentOpacity;
  /// Opacité de la bordure des boutons d'action.
  final double actionBorderOpacity;
  /// Épaisseur de la bordure des boutons d'action.
  final double actionBorderWidth;
  /// Opacité de l'ombre des boutons d'action.
  final double actionShadowOpacity;
  /// Flou de l'ombre des boutons d'action.
  final double actionShadowBlur;
  /// Décalage vertical de l'ombre des boutons d'action.
  final double actionShadowOffsetY;
  // ==========================================================================
  // APP BAR SHADOW
  // ==========================================================================
  /// Opacité de l'ombre globale de l'AppBar.
  final double shadowOpacity;
  // ==========================================================================
  // CONSTRUCTOR
  // ==========================================================================
  const AppearanceAppBarSettings({
    this.enabled=AppConstants.appBarDefaultEnabled,
    this.useGradientBackground=AppConstants.appBarDefaultUseGradientBackground,
    this.compactMode=AppConstants.appBarDefaultCompactMode,
    this.height=AppConstants.appBarDefaultHeight,
    this.actionBackgroundOpacity=AppConstants.appBarDefaultActionBackgroundOpacity,
    this.actionAccentOpacity=AppConstants.appBarDefaultActionAccentOpacity,
    this.actionBorderOpacity=AppConstants.appBarDefaultActionBorderOpacity,
    this.actionBorderWidth=AppConstants.appBarDefaultActionBorderWidth,
    this.actionShadowOpacity=AppConstants.appBarDefaultActionShadowOpacity,
    this.actionShadowBlur=AppConstants.appBarDefaultActionShadowBlur,
    this.actionShadowOffsetY=AppConstants.appBarDefaultActionShadowOffsetY,
    this.shadowOpacity=AppConstants.appBarDefaultShadowOpacity,
  });
  // ==========================================================================
  // PRESETS
  // ==========================================================================
  /// Configuration par défaut.
  static const AppearanceAppBarSettings defaults=AppearanceAppBarSettings();
  /// Configuration compacte.
  static const AppearanceAppBarSettings compact=AppearanceAppBarSettings(compactMode: true,height: null);
  // ==========================================================================
  // EFFECTIVE VALUES
  // ==========================================================================
  /// Hauteur effective.
  /// null conserve le calcul responsive de UniversalAppBar.
  double? get effectiveHeight{
    if(height==null){
      return null;
    }
    if(!height!.isFinite){
      return null;
    }
    return height!.clamp(AppConstants.minAppBarHeight,AppConstants.maxAppBarHeight).toDouble();
  }
  bool get effectiveEnabled=>enabled;
  bool get effectiveUseGradientBackground=>enabled&&useGradientBackground;
  bool get effectiveCompactMode=>enabled&&compactMode;
  double get effectiveActionBackgroundOpacity=>_clampOpacity(actionBackgroundOpacity);
  double get effectiveActionAccentOpacity=>_clampOpacity(actionAccentOpacity);
  double get effectiveActionBorderOpacity=>_clampOpacity(actionBorderOpacity);
  double get effectiveActionBorderWidth=>actionBorderWidth.clamp(AppConstants.minAppBarActionBorderWidth,AppConstants.maxAppBarActionBorderWidth).toDouble();
  double get effectiveActionShadowOpacity=>_clampOpacity(actionShadowOpacity);
  double get effectiveActionShadowBlur=>actionShadowBlur.clamp(AppConstants.minAppBarActionShadowBlur,AppConstants.maxAppBarActionShadowBlur).toDouble();
  double get effectiveActionShadowOffsetY=>actionShadowOffsetY.clamp(AppConstants.minAppBarActionShadowOffsetY,AppConstants.maxAppBarActionShadowOffsetY).toDouble();
  double get effectiveShadowOpacity=>_clampOpacity(shadowOpacity);
  // ==========================================================================
  // COPY WITH
  // ==========================================================================
  AppearanceAppBarSettings copyWith({
    bool? enabled,
    bool? useGradientBackground,
    bool? compactMode,
    double? height,
    bool clearHeight=false,
    double? actionBackgroundOpacity,
    double? actionAccentOpacity,
    double? actionBorderOpacity,
    double? actionBorderWidth,
    double? actionShadowOpacity,
    double? actionShadowBlur,
    double? actionShadowOffsetY,
    double? shadowOpacity,
  }){
    return AppearanceAppBarSettings(
      enabled: enabled??this.enabled,
      useGradientBackground: useGradientBackground??this.useGradientBackground,
      compactMode: compactMode??this.compactMode,
      height: clearHeight?null:(height??this.height),
      actionBackgroundOpacity: actionBackgroundOpacity??this.actionBackgroundOpacity,
      actionAccentOpacity: actionAccentOpacity??this.actionAccentOpacity,
      actionBorderOpacity: actionBorderOpacity??this.actionBorderOpacity,
      actionBorderWidth: actionBorderWidth??this.actionBorderWidth,
      actionShadowOpacity: actionShadowOpacity??this.actionShadowOpacity,
      actionShadowBlur: actionShadowBlur??this.actionShadowBlur,
      actionShadowOffsetY: actionShadowOffsetY??this.actionShadowOffsetY,
      shadowOpacity: shadowOpacity??this.shadowOpacity,
    );
  }
  // ==========================================================================
  // NORMALIZATION
  // ==========================================================================
  AppearanceAppBarSettings normalized(){
    return AppearanceAppBarSettings(
      enabled: enabled,
      useGradientBackground: useGradientBackground,
      compactMode: compactMode,
      height: effectiveHeight,
      actionBackgroundOpacity: effectiveActionBackgroundOpacity,
      actionAccentOpacity: effectiveActionAccentOpacity,
      actionBorderOpacity: effectiveActionBorderOpacity,
      actionBorderWidth: effectiveActionBorderWidth,
      actionShadowOpacity: effectiveActionShadowOpacity,
      actionShadowBlur: effectiveActionShadowBlur,
      actionShadowOffsetY: effectiveActionShadowOffsetY,
      shadowOpacity: effectiveShadowOpacity,
    );
  }
  // ==========================================================================
  // JSON
  // ==========================================================================
  Map<String,dynamic> toJson(){
    return <String,dynamic>{
      'enabled': enabled,
      'useGradientBackground': useGradientBackground,
      'compactMode': compactMode,
      'height': effectiveHeight,
      'actionBackgroundOpacity': effectiveActionBackgroundOpacity,
      'actionAccentOpacity': effectiveActionAccentOpacity,
      'actionBorderOpacity': effectiveActionBorderOpacity,
      'actionBorderWidth': effectiveActionBorderWidth,
      'actionShadowOpacity': effectiveActionShadowOpacity,
      'actionShadowBlur': effectiveActionShadowBlur,
      'actionShadowOffsetY': effectiveActionShadowOffsetY,
      'shadowOpacity': effectiveShadowOpacity,
    };
  }
  factory AppearanceAppBarSettings.fromJson(Map<String,dynamic> json){
    return AppearanceAppBarSettings(
      enabled: _readBool(json['enabled'],AppConstants.appBarDefaultEnabled),
      useGradientBackground: _readBool(json['useGradientBackground'],AppConstants.appBarDefaultUseGradientBackground),
      compactMode: _readBool(json['compactMode'],AppConstants.appBarDefaultCompactMode),
      height: _readNullableDouble(json['height']),
      actionBackgroundOpacity: _readDouble(json['actionBackgroundOpacity'],AppConstants.appBarDefaultActionBackgroundOpacity),
      actionAccentOpacity: _readDouble(json['actionAccentOpacity'],AppConstants.appBarDefaultActionAccentOpacity),
      actionBorderOpacity: _readDouble(json['actionBorderOpacity'],AppConstants.appBarDefaultActionBorderOpacity),
      actionBorderWidth: _readDouble(json['actionBorderWidth'],AppConstants.appBarDefaultActionBorderWidth),
      actionShadowOpacity: _readDouble(json['actionShadowOpacity'],AppConstants.appBarDefaultActionShadowOpacity),
      actionShadowBlur: _readDouble(json['actionShadowBlur'],AppConstants.appBarDefaultActionShadowBlur),
      actionShadowOffsetY: _readDouble(json['actionShadowOffsetY'],AppConstants.appBarDefaultActionShadowOffsetY),
      shadowOpacity: _readDouble(json['shadowOpacity'],AppConstants.appBarDefaultShadowOpacity),
    );
  }
  // ==========================================================================
  // HELPERS
  // ==========================================================================
  static double _clampOpacity(double value){
    if(!value.isFinite){
      return AppConstants.minOpacity;
    }
    return value.clamp(AppConstants.minOpacity,AppConstants.maxOpacity).toDouble();
  }
  static bool _readBool(dynamic value,bool fallback){
    return value is bool?value:fallback;
  }
  static double _readDouble(dynamic value,double fallback){
    if(value is num){
      final double result=value.toDouble();
      if(result.isFinite){
        return result;
      }
    }
    return fallback;
  }
  static double? _readNullableDouble(dynamic value){
    if(value==null){
      return null;
    }
    if(value is num){
      final double result=value.toDouble();
      if(result.isFinite){
        return result;
      }
    }
    return null;
  }
  // ==========================================================================
  // EQUALITY
  // ==========================================================================
  @override
  bool operator==(Object other){
    if(identical(this,other)){
      return true;
    }
    return other is AppearanceAppBarSettings&&
        other.enabled==enabled&&
        other.useGradientBackground==useGradientBackground&&
        other.compactMode==compactMode&&
        other.height==height&&
        other.actionBackgroundOpacity==actionBackgroundOpacity&&
        other.actionAccentOpacity==actionAccentOpacity&&
        other.actionBorderOpacity==actionBorderOpacity&&
        other.actionBorderWidth==actionBorderWidth&&
        other.actionShadowOpacity==actionShadowOpacity&&
        other.actionShadowBlur==actionShadowBlur&&
        other.actionShadowOffsetY==actionShadowOffsetY&&
        other.shadowOpacity==shadowOpacity;
  }
  @override
  int get hashCode{
    return Object.hash(enabled,useGradientBackground,compactMode,height,actionBackgroundOpacity,actionAccentOpacity,actionBorderOpacity,actionBorderWidth,actionShadowOpacity,actionShadowBlur,actionShadowOffsetY,shadowOpacity);
  }
  @override
  String toString(){
    return 'AppearanceAppBarSettings(enabled: $enabled, useGradientBackground: $useGradientBackground, compactMode: $compactMode, height: $height, actionBackgroundOpacity: $actionBackgroundOpacity, actionAccentOpacity: $actionAccentOpacity, actionBorderOpacity: $actionBorderOpacity, actionBorderWidth: $actionBorderWidth, actionShadowOpacity: $actionShadowOpacity, actionShadowBlur: $actionShadowBlur, actionShadowOffsetY: $actionShadowOffsetY, shadowOpacity: $shadowOpacity)';
  }
}