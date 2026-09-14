import 'package:flutter/foundation.dart';
import 'package:universal_glass/enums/glass_enums.dart'; // <- AJOUT pour GlassShapeType

/// ============================================================================
/// GLASS INPUT STYLE
/// ============================================================================
///
/// Valeurs de layout et de style neutres pour tous les inputs glass.
///
/// Ce modèle ne dépend d'aucun thème app. Il sert de pont entre ton app
/// et les composants du package.
///
/// Utilise-le avec [GlassInputStateStyle] pour gérer les états.
@immutable
class GlassInputStyle {
  // --------------------------------------------------------------------------
  // LAYOUT
  // --------------------------------------------------------------------------
  final double fieldHeight;
  final double horizontalPadding;
  final double verticalPadding;
  final double borderRadius;
  final double fontSize; // <- AJOUT

  // --------------------------------------------------------------------------
  // SURFACE GLASS
  // --------------------------------------------------------------------------
  final double blur;
  final bool enableBlur;
  final double backgroundOpacity;

  // --------------------------------------------------------------------------
  // BORDURE
  // --------------------------------------------------------------------------
  final bool enableBorder;
  final double borderOpacity;
  final double borderWidth;

  // --------------------------------------------------------------------------
  // OMBRE
  // --------------------------------------------------------------------------
  final bool enableShadow;
  final double shadowOpacity;
  final double shadowBlur;
  final double shadowOffsetY;

  // --------------------------------------------------------------------------
  // INTERACTION
  // --------------------------------------------------------------------------
  final bool enabled;
  final bool enableHover;
  final double hoverLift;

  // --------------------------------------------------------------------------
  // SHAPE
  // --------------------------------------------------------------------------
  final GlassShapeType shape; // <- AJOUT

  const GlassInputStyle({
    // LAYOUT
    this.fieldHeight = 58.0,
    this.horizontalPadding = 16.0,
    this.verticalPadding = 12.0,
    this.borderRadius = 16.0,
    this.fontSize = 16.0, // <- AJOUT

    // SURFACE
    this.blur = 20.0,
    this.enableBlur = true,
    this.backgroundOpacity = 0.12,

    // BORDURE
    this.enableBorder = true,
    this.borderOpacity = 0.20,
    this.borderWidth = 1.0,

    // OMBRE
    this.enableShadow = true,
    this.shadowOpacity = 0.30,
    this.shadowBlur = 10.0,
    this.shadowOffsetY = 4.0,

    // INTERACTION
    this.enabled = true,
    this.enableHover = true,
    this.hoverLift = 2.0,

    // SHAPE
    this.shape = GlassShapeType.squareRounded, // <- AJOUT
  });

  /// Crée une copie avec les champs modifiés
  GlassInputStyle copyWith({
    double? fieldHeight,
    double? horizontalPadding,
    double? verticalPadding,
    double? borderRadius,
    double? fontSize, // <- AJOUT
    double? blur,
    bool? enableBlur,
    double? backgroundOpacity,
    bool? enableBorder,
    double? borderOpacity,
    double? borderWidth,
    bool? enableShadow,
    double? shadowOpacity,
    double? shadowBlur,
    double? shadowOffsetY,
    bool? enabled,
    bool? enableHover,
    double? hoverLift,
    GlassShapeType? shape, // <- AJOUT
  }) {
    return GlassInputStyle(
      fieldHeight: fieldHeight?? this.fieldHeight,
      horizontalPadding: horizontalPadding?? this.horizontalPadding,
      verticalPadding: verticalPadding?? this.verticalPadding,
      borderRadius: borderRadius?? this.borderRadius,
      fontSize: fontSize?? this.fontSize, // <- AJOUT
      blur: blur?? this.blur,
      enableBlur: enableBlur?? this.enableBlur,
      backgroundOpacity: backgroundOpacity?? this.backgroundOpacity,
      enableBorder: enableBorder?? this.enableBorder,
      borderOpacity: borderOpacity?? this.borderOpacity,
      borderWidth: borderWidth?? this.borderWidth,
      enableShadow: enableShadow?? this.enableShadow,
      shadowOpacity: shadowOpacity?? this.shadowOpacity,
      shadowBlur: shadowBlur?? this.shadowBlur,
      shadowOffsetY: shadowOffsetY?? this.shadowOffsetY,
      enabled: enabled?? this.enabled,
      enableHover: enableHover?? this.enableHover,
      hoverLift: hoverLift?? this.hoverLift,
      shape: shape?? this.shape, // <- AJOUT
    );
  }

  /// Style par défaut compact pour mobile
  factory GlassInputStyle.compact() {
    return const GlassInputStyle(
      fieldHeight: 48.0,
      horizontalPadding: 12.0,
      verticalPadding: 10.0,
      borderRadius: 12.0,
      fontSize: 14.0, // <- AJOUT
    );
  }

  /// Style par défaut dense
  factory GlassInputStyle.dense() {
    return const GlassInputStyle(
      fieldHeight: 40.0,
      horizontalPadding: 12.0,
      verticalPadding: 8.0,
      borderRadius: 10.0,
      fontSize: 13.0, // <- AJOUT
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GlassInputStyle &&
        other.fieldHeight == fieldHeight &&
        other.horizontalPadding == horizontalPadding &&
        other.verticalPadding == verticalPadding &&
        other.borderRadius == borderRadius &&
        other.fontSize == fontSize && // <- AJOUT
        other.blur == blur &&
        other.enableBlur == enableBlur &&
        other.backgroundOpacity == backgroundOpacity &&
        other.enableBorder == enableBorder &&
        other.borderOpacity == borderOpacity &&
        other.borderWidth == borderWidth &&
        other.enableShadow == enableShadow &&
        other.shadowOpacity == shadowOpacity &&
        other.shadowBlur == shadowBlur &&
        other.shadowOffsetY == shadowOffsetY &&
        other.enabled == enabled &&
        other.enableHover == enableHover &&
        other.hoverLift == hoverLift &&
        other.shape == shape; // <- AJOUT
  }

  @override
  int get hashCode {
    return Object.hash(
      fieldHeight,
      horizontalPadding,
      verticalPadding,
      borderRadius,
      fontSize, // <- AJOUT
      blur,
      enableBlur,
      backgroundOpacity,
      enableBorder,
      borderOpacity,
      borderWidth,
      enableShadow,
      shadowOpacity,
      shadowBlur,
      shadowOffsetY,
      enabled,
      enableHover,
      hoverLift,
      shape, // <- AJOUT
    );
  }

  @override
  String toString() {
    return 'GlassInputStyle(fieldHeight: $fieldHeight, fontSize: $fontSize, borderRadius: $borderRadius, shape: $shape, enabled: $enabled)';
  }
}