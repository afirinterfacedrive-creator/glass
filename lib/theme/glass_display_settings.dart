import 'package:flutter/foundation.dart';

/// Densité générale de l'interface.
enum GlassDensity {
  compact,
  comfortable,
  spacious,
}

/// Configuration globale de l'affichage Universal Glass.
///
/// Cette classe ne contient aucun état Flutter.
/// Elle représente uniquement les paramètres d'affichage.
@immutable
class GlassDisplaySettings {
  /// Largeur maximale du contenu.
  ///
  /// 0 signifie automatique / aucune limite.
  final double maxWidth;

  /// Zoom global de l'application.
  ///
  /// 1.0 = 100 %
  /// 1.25 = 125 %
  /// 1.50 = 150 %
  final double zoom;

  /// Padding horizontal desktop.
  final double desktopPadding;

  /// Padding horizontal tablette.
  final double tabletPadding;

  /// Padding horizontal mobile.
  final double mobilePadding;

  /// Padding horizontal petit mobile.
  final double smallMobilePadding;

  /// Seuil tablette.
  final double tabletBreakpoint;

  /// Seuil desktop.
  final double desktopBreakpoint;

  /// Densité globale.
  final GlassDensity density;

  const GlassDisplaySettings({
    this.maxWidth = 1440.0,
    this.zoom = 1.0,
    this.desktopPadding = 12.0,
    this.tabletPadding = 10.0,
    this.mobilePadding = 8.0,
    this.smallMobilePadding = 4.0,
    this.tabletBreakpoint = 600.0,
    this.desktopBreakpoint = 1100.0,
    this.density = GlassDensity.comfortable,
  });

  static const GlassDisplaySettings defaults =
      GlassDisplaySettings();

  static const GlassDisplaySettings compact =
      GlassDisplaySettings(
    maxWidth: 1440.0,
    zoom: 1.0,
    desktopPadding: 8.0,
    tabletPadding: 6.0,
    mobilePadding: 6.0,
    smallMobilePadding: 3.0,
    density: GlassDensity.compact,
  );

  static const GlassDisplaySettings comfortable =
      GlassDisplaySettings(
    maxWidth: 1440.0,
    zoom: 1.0,
    desktopPadding: 12.0,
    tabletPadding: 10.0,
    mobilePadding: 8.0,
    smallMobilePadding: 4.0,
    density: GlassDensity.comfortable,
  );

  static const GlassDisplaySettings spacious =
      GlassDisplaySettings(
    maxWidth: 1440.0,
    zoom: 1.0,
    desktopPadding: 18.0,
    tabletPadding: 14.0,
    mobilePadding: 12.0,
    smallMobilePadding: 6.0,
    density: GlassDensity.spacious,
  );

  GlassDisplaySettings copyWith({
    double? maxWidth,
    double? zoom,
    double? desktopPadding,
    double? tabletPadding,
    double? mobilePadding,
    double? smallMobilePadding,
    double? tabletBreakpoint,
    double? desktopBreakpoint,
    GlassDensity? density,
  }) {
    return GlassDisplaySettings(
      maxWidth: maxWidth ?? this.maxWidth,
      zoom: zoom ?? this.zoom,
      desktopPadding: desktopPadding ?? this.desktopPadding,
      tabletPadding: tabletPadding ?? this.tabletPadding,
      mobilePadding: mobilePadding ?? this.mobilePadding,
      smallMobilePadding:
          smallMobilePadding ?? this.smallMobilePadding,
      tabletBreakpoint:
          tabletBreakpoint ?? this.tabletBreakpoint,
      desktopBreakpoint:
          desktopBreakpoint ?? this.desktopBreakpoint,
      density: density ?? this.density,
    );
  }

  GlassDisplaySettings normalized() {
    final double normalizedTabletBreakpoint =
        tabletBreakpoint.clamp(
      400.0,
      1200.0,
    ).toDouble();

    double normalizedDesktopBreakpoint =
        desktopBreakpoint.clamp(
      800.0,
      2000.0,
    ).toDouble();

    if (normalizedDesktopBreakpoint <=
        normalizedTabletBreakpoint) {
      normalizedDesktopBreakpoint =
          normalizedTabletBreakpoint + 100.0;
    }

    return copyWith(
      maxWidth: maxWidth <= 0
          ? 0.0
          : maxWidth
              .clamp(600.0, 3000.0)
              .toDouble(),
      zoom: zoom
          .clamp(0.50, 2.00)
          .toDouble(),
      desktopPadding: desktopPadding
          .clamp(0.0, 100.0)
          .toDouble(),
      tabletPadding: tabletPadding
          .clamp(0.0, 100.0)
          .toDouble(),
      mobilePadding: mobilePadding
          .clamp(0.0, 100.0)
          .toDouble(),
      smallMobilePadding: smallMobilePadding
          .clamp(0.0, 100.0)
          .toDouble(),
      tabletBreakpoint: normalizedTabletBreakpoint,
      desktopBreakpoint: normalizedDesktopBreakpoint,
    );
  }

  double get spacingFactor {
    switch (density) {
      case GlassDensity.compact:
        return 0.85;

      case GlassDensity.comfortable:
        return 1.0;

      case GlassDensity.spacious:
        return 1.15;
    }
  }

  double get controlHeightFactor {
    switch (density) {
      case GlassDensity.compact:
        return 0.90;

      case GlassDensity.comfortable:
        return 1.0;

      case GlassDensity.spacious:
        return 1.10;
    }
  }

  double get borderRadiusFactor {
    switch (density) {
      case GlassDensity.compact:
        return 0.92;

      case GlassDensity.comfortable:
        return 1.0;

      case GlassDensity.spacious:
        return 1.06;
    }
  }

  double get fontSizeFactor {
    switch (density) {
      case GlassDensity.compact:
        return 0.96;

      case GlassDensity.comfortable:
        return 1.0;

      case GlassDensity.spacious:
        return 1.04;
    }
  }

  static const List<double> zoomPresets = [
    0.75,
    0.80,
    0.90,
    1.00,
    1.10,
    1.25,
    1.50,
    1.75,
    2.00,
  ];

  String get zoomLabel {
    return '${(zoom * 100).round()} %';
  }

  String get maxWidthLabel {
    if (maxWidth <= 0) {
      return 'Automatique';
    }

    return '${maxWidth.round()} px';
  }

  String get densityLabel {
    switch (density) {
      case GlassDensity.compact:
        return 'Compacte';

      case GlassDensity.comfortable:
        return 'Confortable';

      case GlassDensity.spacious:
        return 'Spacieuse';
    }
  }
}