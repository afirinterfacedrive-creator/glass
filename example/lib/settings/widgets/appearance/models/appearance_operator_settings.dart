import 'package:universal_glass_example/settings/widgets/appearance/models/appearance_component_settings.dart';

/// Réglages spécifiques aux composants liés aux opérateurs.
///
/// Hérite de [AppearanceComponentSettings] afin de conserver exactement
/// le même système visuel que les autres composants.
///
/// Les [prefixes] restent une donnée spécifique au composant opérateur.
class AppearanceOperatorSettings extends AppearanceComponentSettings {
  // ===========================================================================
  // OPERATOR DATA
  // ===========================================================================

  /// Liste des préfixes associés à l'opérateur.
  final List<String> prefixes;

  // ===========================================================================
  // CONSTRUCTOR
  // ===========================================================================

  const AppearanceOperatorSettings({
    super.enabled = true,

    // Blur.
    super.enableBlur = true,
    super.blur = 10.0,

    // Background.
    super.backgroundOpacity = 0.15,

    // Border.
    super.enableBorder = true,
    super.borderOpacity = 0.2,
    super.borderWidth = 1.0,
    super.borderRadius = 16.0,

    // Shadow.
    super.enableShadow = true,
    super.shadowOpacity = 0.12,
    super.shadowBlur = 20.0,
    super.shadowOffsetY = 8.0,

    // Hover.
    super.enableHover = true,
    super.hoverLift = 4.0,

    // Padding.
    super.horizontalPadding = 16.0,
    super.verticalPadding = 12.0,

    // Operator-specific data.
    this.prefixes = const <String>[],
  });

  // ===========================================================================
  // COPY WITH
  // ===========================================================================

  @override
  AppearanceOperatorSettings copyWith({
    bool? enabled,

    bool? enableBlur,
    double? blur,

    double? backgroundOpacity,

    bool? enableBorder,
    double? borderOpacity,
    double? borderWidth,
    double? borderRadius,

    bool? enableShadow,
    double? shadowOpacity,
    double? shadowBlur,
    double? shadowOffsetY,

    bool? enableHover,
    double? hoverLift,

    double? horizontalPadding,
    double? verticalPadding,

    List<String>? prefixes,
  }) {
    return AppearanceOperatorSettings(
      enabled: enabled ?? this.enabled,

      enableBlur: enableBlur ?? this.enableBlur,
      blur: blur ?? this.blur,

      backgroundOpacity:
          backgroundOpacity ?? this.backgroundOpacity,

      enableBorder:
          enableBorder ?? this.enableBorder,
      borderOpacity:
          borderOpacity ?? this.borderOpacity,
      borderWidth:
          borderWidth ?? this.borderWidth,
      borderRadius:
          borderRadius ?? this.borderRadius,

      enableShadow:
          enableShadow ?? this.enableShadow,
      shadowOpacity:
          shadowOpacity ?? this.shadowOpacity,
      shadowBlur:
          shadowBlur ?? this.shadowBlur,
      shadowOffsetY:
          shadowOffsetY ?? this.shadowOffsetY,

      enableHover:
          enableHover ?? this.enableHover,
      hoverLift:
          hoverLift ?? this.hoverLift,

      horizontalPadding:
          horizontalPadding ?? this.horizontalPadding,
      verticalPadding:
          verticalPadding ?? this.verticalPadding,

      prefixes:
          prefixes ?? this.prefixes,
    );
  }

  // ===========================================================================
  // JSON
  // ===========================================================================

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      // Component settings.
      'enabled': enabled,

      'enableBlur': enableBlur,
      'blur': blur,

      'backgroundOpacity': backgroundOpacity,

      'enableBorder': enableBorder,
      'borderOpacity': borderOpacity,
      'borderWidth': borderWidth,
      'borderRadius': borderRadius,

      'enableShadow': enableShadow,
      'shadowOpacity': shadowOpacity,
      'shadowBlur': shadowBlur,
      'shadowOffsetY': shadowOffsetY,

      'enableHover': enableHover,
      'hoverLift': hoverLift,

      'horizontalPadding': horizontalPadding,
      'verticalPadding': verticalPadding,

      // Operator-specific settings.
      'prefixes': List<String>.from(prefixes),
    };
  }

  // ===========================================================================
  // FROM JSON
  // ===========================================================================

  factory AppearanceOperatorSettings.fromJson(
    Map<String, dynamic> json,
  ) {
    return AppearanceOperatorSettings(
      enabled: _readBool(
        json,
        'enabled',
        true,
      ),

      enableBlur: _readBool(
        json,
        'enableBlur',
        true,
      ),

      blur: _readDouble(
        json,
        'blur',
        10.0,
      ),

      backgroundOpacity: _readDouble(
        json,
        'backgroundOpacity',
        0.15,
      ),

      enableBorder: _readBool(
        json,
        'enableBorder',
        true,
      ),

      borderOpacity: _readDouble(
        json,
        'borderOpacity',
        0.2,
      ),

      borderWidth: _readDouble(
        json,
        'borderWidth',
        1.0,
      ),

      borderRadius: _readDouble(
        json,
        'borderRadius',
        16.0,
      ),

      enableShadow: _readBool(
        json,
        'enableShadow',
        true,
      ),

      shadowOpacity: _readDouble(
        json,
        'shadowOpacity',
        0.12,
      ),

      shadowBlur: _readDouble(
        json,
        'shadowBlur',
        20.0,
      ),

      shadowOffsetY: _readDouble(
        json,
        'shadowOffsetY',
        8.0,
      ),

      enableHover: _readBool(
        json,
        'enableHover',
        true,
      ),

      hoverLift: _readDouble(
        json,
        'hoverLift',
        4.0,
      ),

      horizontalPadding: _readDouble(
        json,
        'horizontalPadding',
        16.0,
      ),

      verticalPadding: _readDouble(
        json,
        'verticalPadding',
        12.0,
      ),

      prefixes: _readStringList(
        json,
        'prefixes',
      ),
    );
  }

  // ===========================================================================
  // JSON HELPERS
  // ===========================================================================

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

  static List<String> _readStringList(
    Map<String, dynamic> json,
    String key,
  ) {
    final dynamic value = json[key];

    if (value is List) {
      final List<String> result = <String>[];

      for (final dynamic item in value) {
        if (item is String && item.isNotEmpty) {
          result.add(item);
        }
      }

      return List<String>.unmodifiable(result);
    }

    return const <String>[];
  }
}