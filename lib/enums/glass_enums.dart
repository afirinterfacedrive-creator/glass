
// ============================================================================
// GLASS ENUMS
// ============================================================================
//
// Tous les enums génériques utilisés par les composants Glass.
//
// ============================================================================

// ignore: dangling_library_doc_comments
/// ============================================================================
// ignore: dangling_library_doc_comments
/// FORMES GLASS
// ignore: dangling_library_doc_comments
/// ============================================================================

/// Formes géométriques disponibles pour les composants Glass.
enum GlassShapeType {
  /// Bouton parfaitement circulaire.
  circle,

  /// Rectangle avec coins arrondis.
  /// Rayon fixe.
  squareRounded,

  /// Capsule verticale.
  /// Rayon = hauteur / 2.
  capsuleVertical,

  /// Capsule horizontale / pilule.
  /// Rayon = hauteur / 2.
  pillHorizontal,

  /// Capsule horizontale.
  ///
  /// Alias de [pillHorizontal] conservé pour compatibilité.
  pill,

  /// Stade / rectangle ultra arrondi.
  /// Rayon = hauteur / 2.
  stadium,
}

/// ============================================================================
/// SPINNER
/// ============================================================================

/// Position du spinner dans un composant Glass.
enum SpinnerPosition {
  /// Spinner placé à gauche.
  left,

  /// Spinner placé à droite.
  right,
}

/// ============================================================================
/// GLASS STYLE
/// ============================================================================

/// Styles visuels principaux de l'interface Glass.
///
/// Chaque style définit une identité visuelle de surface.
/// Les paramètres fins comme le blur, l'opacité, la bordure, le glow,
/// etc. sont ensuite déterminés par le moteur GlassEffects / Theme.
enum GlassStyle {
  /// 95 % opaque.
  ///
  /// Pour Sheets, BottomSheet et modals lourds.
  opaqueMat,

  /// Gradient sans transparence.
  ///
  /// Pour headers et CTA.
  gradientOpaque,

  /// Dégradé personnalisé via `customGradient`.
  ///
  /// Pour branding.
  customGradient,

  /// 75 % opaque avec teinte Aqua.
  ///
  /// Pour dialogs et AppBar.
  solidAqua,

  /// 75 % opaque gris/blanc.
  ///
  /// Pour dialogs alternatifs et cards secondaires.
  solidClassic,

  /// 98 % opaque.
  ///
  /// Pour bloquer complètement le fond.
  opaqueHeavy,

  /// 8 % opaque avec reflet Aqua.
  ///
  /// Pour Cards, Sections et Containers.
  transparentAqua,

  /// 8 % opaque avec teinte Rouge.
  ///
  /// Pour boutons danger, suppression et reset.
  transparentRed,

  /// 8 % opaque avec teinte Vert.
  ///
  /// Pour validation, import et success.
  transparentGreen,

  /// Gradient asymétrique de la carte Welcome.
  ///
  /// Style conservé pour compatibilité avec l'architecture Classic SB.
  classicSb,

  /// Mode custom complet.
  ///
  /// Utilise les [GlassEffects] passés au composant.
  custom,

  
}

/// ============================================================================
/// GLASS SURFACE ROLE
/// ============================================================================

/// Définit le contexte visuel dans lequel une surface Glass est utilisée.
///
/// Le rôle ne change pas le [GlassStyle].
///
/// Il permet au moteur de déterminer une densité, un contraste,
/// une profondeur et des effets adaptés au contexte.
///
/// Exemple :
///
/// ```text
/// transparentAqua + card
/// transparentAqua + dialog
/// transparentAqua + modal
/// ```
///
/// utilisent le même style de verre mais peuvent avoir des paramètres
/// de rendu différents.
///
/// IMPORTANT
///
/// [GlassSurfaceRole] décrit la SURFACE et non son contenu.
///
/// Un TextField peut donc utiliser :
///
/// ```dart
/// GlassSurfaceRole.field
/// ```
///
/// tandis que son label flottant, son notch et son helper text restent
/// gérés par les composants spécialisés du champ.
enum GlassSurfaceRole {
  /// Surface générique de type carte.
  card,

  /// Surface utilisée par un champ de saisie.
  field,

  /// Surface de panneau.
  panel,

  /// Surface de dialogue.
  dialog,

  /// Surface modale lourde.
  modal,

  /// Surface de header.
  header,

  /// Surface principale du body.
  body,

  /// Surface de footer.
  footer,

  /// Surface de tooltip.
  tooltip,

  /// Surface de menu.
  menu,
  appBar,
}

/// ============================================================================
/// GLASS PRESETS
/// ============================================================================

enum GlassPreset {
  aquaFrost,
  classicDark,
  light,
  dark,
  classicSb,
}

/// ============================================================================
/// FORMATS ET AJUSTEMENTS DES BULLES D'ENTRÉES
/// ============================================================================

/// Définit la manière dont le contenu est ajusté dans une bulle d'entrée.
enum GlassInputBubbleFit {
  /// Le contenu est redimensionné pour s'intégrer totalement à la bulle.
  contain,

  /// Le contenu est agrandi pour couvrir toute la surface.
  ///
  /// Idéal pour les images et les drapeaux.
  cover,
}

/// ============================================================================
/// FORME DES BULLES D'ENTRÉES
/// ============================================================================

/// Forme géométrique d'une bulle Glass.
///
/// Permet notamment de définir le contour utilisé par les composants
/// de type GlassInputBubble.
enum GlassInputBubbleShape {
  /// Bulle parfaitement circulaire.
  circle,

  /// Carré.
  square,

  /// Rectangle à coins arrondis.
  rectangle,

  /// Capsule / pilule horizontale.
  ///
  /// Le rayon est automatiquement basé sur la hauteur
  /// afin d'obtenir des extrémités parfaitement arrondies.
  pill,
}

/// ============================================================================
/// THÈME
/// ============================================================================

/// Modes de thème globaux de l'application.
enum AppThemeMode {
  system,
  dark,
  light,
  aqua,
  classic,
}

/// ============================================================================
/// TOGGLES
/// ============================================================================

enum GlassToggleSize {
  small,
  medium,
  large,
}

enum GlassToggleStyle {
  normal,
  breaker,
}

/// ============================================================================
/// TOASTS
/// ============================================================================

enum GlassToastType {
  success,
  error,
  info,
  warning,
}

enum GlassToastPosition {
  topCenter,
  bottomCenter,
  center,
}

/// ============================================================================
/// TEXTE
/// ============================================================================

/// Transformations textuelles disponibles.
enum GlassTextCase {
  /// Aucun changement.
  normal,

  /// Tout en majuscules.
  uppercase,

  /// Tout en minuscules.
  lowercase,

  /// Première lettre de chaque mot en majuscule.
  capitalize,

  /// Réduit les espaces multiples à un seul et supprime
  /// les espaces en début et fin.
  trimSpace,
}

/// ============================================================================
/// ÉTAT DES CHAMPS
/// ============================================================================

enum GlassFieldState {
  normal,
  error,
  success,
}

enum ComponentType {
  form,
  input,
  modalDialog,
  toast,
  tooltip,
}
