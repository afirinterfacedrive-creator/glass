// ============================================================================
// GLASS ENUMS
// ============================================================================
//
// Tous les enums génériques utilisés par les composants Glass.
//
// ============================================================================

/// Formes géométriques disponibles pour les composants Glass.
enum GlassShapeType {
  /// Bouton parfaitement circulaire.
  circle,

  /// Rectangle avec coins arrondis.
  squareRounded,

  /// Capsule verticale.
  capsuleVertical,

  /// Capsule horizontale.
  pillHorizontal,
}

/// Position du spinner dans un composant Glass.
enum SpinnerPosition {
  /// Spinner placé à gauche.
  left,

  /// Spinner placé à droite.
  right,
}

/// Styles visuels principaux de l'interface Glass.
enum GlassStyle {
  /// Style opaque.
  opaqueMat,

  /// Style transparent avec reflet Aqua.
  transparentAqua,
}
