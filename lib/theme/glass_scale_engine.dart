import 'package:flutter/material.dart';

/// Moteur de scaling global Universal Glass.
///
/// Le principe est différent d'un simple Transform.scale().
///
/// Le contenu utilise un espace logique piloté par le facteur de zoom,
/// tandis que les dimensions visuelles sont calculées directement
/// à partir de ce facteur.
///
///
/// Comportement :
///
///   50 %  -> plus petit
///   75 %  -> plus petit
///   100 % -> normal
///   125 % -> plus grand
///   150 % -> plus grand
///   175 % -> plus grand
///   200 % -> beaucoup plus grand
///
/// IMPORTANT :
///
/// Ce moteur ne fait aucun Transform.scale().
/// Il fournit uniquement les dimensions adaptées au zoom.
class GlassScaleEngine {
  const GlassScaleEngine._();

  static const double minScale = 0.50;
  static const double maxScale = 2.00;

  /// Normalise le facteur de zoom.
  static double normalize(double value) {
    return value
        .clamp(
          minScale,
          maxScale,
        )
        .toDouble();
  }

  /// Convertit une dimension physique en dimension logique.
  ///
  /// Cette méthode est conservée comme utilitaire mathématique.
  ///
  /// Exemple :
  ///
  /// 200 px physiques à 200 % -> 100 px logiques.
  ///
  /// Elle ne doit PAS être utilisée pour calculer directement
  /// les tailles visuelles de l'interface.
  static double physicalToLogical(
    double value,
    double scale,
  ) {
    final double safeScale = normalize(scale);

    if (safeScale <= 0.0) {
      return value;
    }

    return value / safeScale;
  }

  /// Convertit une dimension logique en dimension physique.
  ///
  /// Exemple :
  ///
  /// 100 px logiques à 200 % -> 200 px physiques.
  static double logicalToPhysical(
    double value,
    double scale,
  ) {
    return value * normalize(scale);
  }

  /// Largeur visuelle adaptée au zoom.
  ///
  /// IMPORTANT :
  /// Plus le zoom augmente, plus la largeur augmente.
  ///
  /// 100 % -> value
  /// 150 % -> value * 1.5
  /// 200 % -> value * 2.0
  static double logicalWidth(
    double width,
    double scale,
  ) {
    return logicalToPhysical(
      width,
      scale,
    );
  }

  /// Hauteur visuelle adaptée au zoom.
  ///
  /// IMPORTANT :
  /// Plus le zoom augmente, plus la hauteur augmente.
  static double logicalHeight(
    double height,
    double scale,
  ) {
    return logicalToPhysical(
      height,
      scale,
    );
  }

  /// Transforme une taille visuelle.
  ///
  /// Exemple :
  ///
  /// size(20, 0.50) -> 10
  /// size(20, 1.00) -> 20
  /// size(20, 1.50) -> 30
  /// size(20, 2.00) -> 40
  static double size(
    double value,
    double scale,
  ) {
    return logicalToPhysical(
      value,
      scale,
    );
  }

  /// Transforme un rayon visuel.
  ///
  /// Exemple :
  ///
  /// radius(20, 0.50) -> 10
  /// radius(20, 1.00) -> 20
  /// radius(20, 1.50) -> 30
  /// radius(20, 2.00) -> 40
  static double radius(
    double value,
    double scale,
  ) {
    return logicalToPhysical(
      value,
      scale,
    );
  }

  /// Transforme une taille de police.
  ///
  /// Exemple :
  ///
  /// font(14, 0.50) -> 7
  /// font(14, 1.00) -> 14
  /// font(14, 1.50) -> 21
  /// font(14, 2.00) -> 28
  static double font(
    double value,
    double scale,
  ) {
    return logicalToPhysical(
      value,
      scale,
    );
  }
}

/// Données de scaling disponibles dans tout l'arbre.
@immutable
class GlassScaleData {
  final double scale;

  const GlassScaleData({
    required this.scale,
  });

  /// Facteur de zoom normalisé.
  double get value {
    return GlassScaleEngine.normalize(scale);
  }

  /// Pourcentage du zoom.
  ///
  /// Exemple :
  ///
  /// 1.0 -> 100
  /// 1.25 -> 125
  /// 1.5 -> 150
  /// 2.0 -> 200
  double get percentage {
    return value * 100.0;
  }

  /// Libellé utilisateur.
  String get label {
    return '${percentage.round()} %';
  }

  /// Indique si le zoom est à 100 %.
  bool get isNormal => value == 1.0;

  /// Indique si le zoom est supérieur à 100 %.
  bool get isZoomedIn => value > 1.0;

  /// Indique si le zoom est inférieur à 100 %.
  bool get isZoomedOut => value < 1.0;

  /// Transforme une taille selon le zoom.
  double size(double value) {
    return GlassScaleEngine.size(
      value,
      scale,
    );
  }

  /// Transforme un espacement selon le zoom.
  double spacing(double value) {
    return size(value);
  }

  /// Transforme un rayon selon le zoom.
  double radius(double value) {
    return GlassScaleEngine.radius(
      value,
      scale,
    );
  }

  /// Transforme une taille de police selon le zoom.
  double font(double value) {
    return GlassScaleEngine.font(
      value,
      scale,
    );
  }

  /// Transforme directement une dimension logique
  /// en dimension physique.
  double visual(double value) {
    return GlassScaleEngine.logicalToPhysical(
      value,
      scale,
    );
  }

  /// Transforme une largeur selon le zoom.
  double logicalWidth(double width) {
    return GlassScaleEngine.logicalWidth(
      width,
      scale,
    );
  }

  /// Transforme une hauteur selon le zoom.
  double logicalHeight(double height) {
    return GlassScaleEngine.logicalHeight(
      height,
      scale,
    );
  }

  /// Crée un EdgeInsets adapté au zoom.
  EdgeInsets padding({
    double left = 0.0,
    double top = 0.0,
    double right = 0.0,
    double bottom = 0.0,
  }) {
    return EdgeInsets.only(
      left: size(left),
      top: size(top),
      right: size(right),
      bottom: size(bottom),
    );
  }

  /// Crée un EdgeInsets symétrique adapté au zoom.
  EdgeInsets symmetric({
    double horizontal = 0.0,
    double vertical = 0.0,
  }) {
    return EdgeInsets.symmetric(
      horizontal: size(horizontal),
      vertical: size(vertical),
    );
  }
}

/// Fournit le moteur de scaling à tous les descendants.
///
/// IMPORTANT :
///
/// Ce widget ne transforme PAS son child.
///
/// Il transmet uniquement les données de zoom.
///
/// Le rendu est effectué explicitement par les composants
/// via GlassLayoutContext / GlassScaleData.
class GlassScale extends InheritedWidget {
  final GlassScaleData data;

  const GlassScale({
    super.key,
    required this.data,
    required super.child,
  });

  /// Récupère les données de scaling.
  static GlassScaleData of(
    BuildContext context,
  ) {
    final GlassScale? result =
        context.dependOnInheritedWidgetOfExactType<
            GlassScale>();

    return result?.data ??
        const GlassScaleData(
          scale: 1.0,
        );
  }

  /// Récupère les données de scaling sans erreur.
  static GlassScaleData maybeOf(
    BuildContext context,
  ) {
    final GlassScale? result =
        context.dependOnInheritedWidgetOfExactType<
            GlassScale>();

    return result?.data ??
        const GlassScaleData(
          scale: 1.0,
        );
  }

  @override
  bool updateShouldNotify(
    GlassScale oldWidget,
  ) {
    return oldWidget.data.scale != data.scale;
  }
}