// ============================================================================
// APP ROUTES
// ============================================================================
//
// Centralisation de toutes les routes de l'application.
//
// Ne pas écrire les chemins directement dans les pages.
//
// Exemple :
//
// Navigator.of(context).pushNamed(AppRoutes.settings);
//
// ============================================================================

abstract final class AppRoutes {
  // ==========================================================================
  // HOME
  // ==========================================================================

  static const String home = '/';

  // ==========================================================================
  // CONTROL PANEL
  // ==========================================================================

  static const String controlPanel = '/control-panel';

  // ==========================================================================
  // SETTINGS
  // ==========================================================================

  static const String settings = '/settings';

  // ==========================================================================
  // PHYSICAL TOGGLES
  // ==========================================================================

  static const String physicalToggles = '/physical-toggles';

  // ==========================================================================
  // APPEARANCE
  // ==========================================================================

  static const String appearance = '/appearance';

  // ==========================================================================
  // GLASS PHONE INPUT
  // ==========================================================================
  //
  // Démonstration du UniversalGlassPhoneInput.
  //
  // Teste notamment :
  //
  // • formatage 71 20 00 00
  // • normalisation 71200000
  // • limitation à 8 chiffres
  // • collage
  // • suppression
  // • curseur
  // • validation
  // • focus
  //
  // ==========================================================================

  static const String phoneInput = '/phone-input';

  // ==========================================================================
  // DEMOS - OPTIONS POUR LES 6 NOUVEAUX GRADIENTS
  // ==========================================================================
  //
  // Pages de test pour valider les 3 options :
  //
  // A. Animation Gradient au hover
  // B. Export/Import des presets
  // C. Picker animé dans Appearance
  //
  // ==========================================================================

  static const String gradientAnimationDemo = '/demo-gradient-animation';

  static const String presetExportImportDemo = '/demo-preset-export-import';

  static const String presetPickerDemo = '/demo-preset-picker';

  // ==========================================================================
  // GALERIE DES 21 STYLES GLASS
  // ==========================================================================
  //
  // Page de prévisualisation et de test en direct pour l'ensemble des
  // 21 presets visuels du package (Gamme classique, Sage et Premium).
  //
  // ==========================================================================

  static const String styleGallery = '/demo-style-gallery';

  static const String glassGlobalSettings = '/glass-global-settings'; // <- AJOU
}
