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

  /// Rectangle avec coins arrondis. Rayon fixe.
  squareRounded,

  /// Capsule verticale. Rayon = hauteur / 2
  capsuleVertical,

  /// Capsule horizontale / pilule. Rayon = hauteur / 2
  pillHorizontal,

  /// Capsule horizontale. Alias de pillHorizontal pour compat.
  pill,

  /// Stade / rectangle ultra arrondi. Rayon = hauteur / 2
  stadium,
}

/// Position du spinner dans un composant Glass.
enum SpinnerPosition {
  /// Spinner placé à gauche.
  left,

  /// Spinner placé à droite.
  right,
}
/// Styles visuels principaux de l'interface Glass.
/// Chaque style définit un preset de blur/opacity/border/glow
enum GlassStyle {
  /// 95% opaque. Pour Sheets, BottomSheet, Modals lourds
  opaqueMat,        
  
  /// Gradient mais 0% transparent. Pour headers CTA
  gradientOpaque,   
  
  /// Dégradé personnalisé via `customGradient`. Pour branding
  customGradient,   
  
  /// 75% opaque tint Aqua. Dialogs, AppBar
  solidAqua,        
  
  /// 75% opaque gris/blanc. Dialogs alternatifs, Cards secondaires
  solidClassic,     
  
  /// 98% opaque. Pour bloquer complètement le fond
  opaqueHeavy,      
  
  /// 8% opaque reflet Aqua. Cards, Sections, Containers
  transparentAqua,  
  
  /// 3% opaque. Inputs, Champs, TextFields
  ghost,            
  
  /// Style dédié AppBar avec gradient subtil + blur moyen
  appBar,           
  
  /// Gradient asymétrique carte Bienvenue
  classicSb,        

  // ================= SAGE PACK =================
  /// Noir 20% + Accent Rouge KDTV. Dashboard admin
  sage,             
  
  /// Noir 30% + Bordure Rouge + Glow rouge. Mode Pro
  sagePro,          
  
  /// #000 100%. OLED pure. Economie batterie
  sageOled,         
  
  /// Noir 15% + glass + Accent Rouge. Mix glass + sage
  sageGlass,        

  /// Mode custom complet. Utilise 100% `GlassEffects` passé en param
  custom,
}

enum GlassPreset {
  aquaFrost,
  classicDark,
  sagePro,
  sageOled,
  sageGlass,
  light,
  dark,
  classicSb,
}

// ============================================================================
// FORMATS ET AJUSTEMENTS DE BULLES D'ENTRÉES
// ============================================================================

enum GlassInputBubbleFit {
  /// Le contenu est redimensionné pour s'intégrer totalement à la bulle.
  contain,
  
  /// Le contenu est agrandi pour couvrir toute la surface (idéal pour images/drapeaux).
  cover,
} 

/// Forme géométrique d'une bulle Glass.
///
/// Permet notamment de définir le contour utilisé par
/// les composants de type GlassInputBubble.
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

/// Modes de thème globaux de l'application.
enum AppThemeMode { 
  system, 
  dark, 
  light, 
  aqua, 
  classic, 
  sage,     // <-- SAGE STANDARD
  sagePro,  // <-- SAGE PRO
  sageOled, // <-- SAGE OLED
  sageGlass // <-- SAGE GLASS
}


enum GlassToggleSize { small, medium, large }
enum GlassToggleStyle { normal, breaker }

enum GlassToastType { success, error, info, warning }

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