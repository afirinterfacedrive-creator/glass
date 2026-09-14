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
  //
  // Configuration de l'apparence :
  //
  // • Aqua
  // • Classic
  // • Light
  // • Dark
  //
  // Le mode System utilise le profil Aqua comme fallback mais ne constitue
  // pas un profil personnalisable.
  //
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
  // • limitation à 8 chiffres selon le pays
  // • détection dynamique des opérateurs
  // • collage
  // • suppression
  // • curseur
  // • validation
  // • focus
  //
  // ==========================================================================

  static const String phoneInput = '/phone-input';

  // ==========================================================================
  // GLASS PHONE CRUD
  // ==========================================================================
  //
  // Panneau d'administration et de gestion dynamique des préfixes réseau.
  //
  // Permet de modifier la base locale des pays et territoires à chaud,
  // sans modifier le code source du package.
  //
  // ==========================================================================

  static const String phoneCrud = '/phone-crud';

  // ==========================================================================
  // GRADIENT ANIMATION DEMO
  // ==========================================================================
  //
  // Démonstration des animations de gradient.
  //
  // ==========================================================================

  static const String gradientAnimationDemo =
      '/demo-gradient-animation';

  // ==========================================================================
  // PRESET EXPORT / IMPORT DEMO
  // ==========================================================================
  //
  // Démonstration de l'export et de l'import des presets Glass.
  //
  // ==========================================================================

  static const String presetExportImportDemo =
      '/demo-preset-export-import';

  // ==========================================================================
  // PRESET PICKER DEMO
  // ==========================================================================
  //
  // Démonstration du sélecteur de presets Glass.
  //
  // ==========================================================================

  static const String presetPickerDemo =
      '/demo-preset-picker';

  // ==========================================================================
  // GLASS STYLE GALLERY
  // ==========================================================================
  //
  // Galerie de prévisualisation des styles Glass disponibles dans le package.
  //
  // Le nombre réel de styles est obtenu dynamiquement via :
  //
  // GlassStyle.values.length
  //
  // ==========================================================================

  static const String styleGallery =
      '/demo-style-gallery';

  // ==========================================================================
  // GLASS GLOBAL SETTINGS
  // ==========================================================================
  //
  // Configuration globale du système Glass.
  //
  // ==========================================================================

  static const String glassGlobalSettings =
      '/glass-global-settings';

  // ==========================================================================
  // COMPONENT PREVIEWS
  // ==========================================================================
  //
  // Pages de démonstration des composants interactifs Universal Glass.
  //
  // ==========================================================================

  /// Démonstration du Glass Dialog.
  static const String dialog =
      '/preview-dialog';

  /// Démonstration du Glass Modal.
  static const String modal =
      '/preview-modal';

  /// Démonstration du Glass Form.
  static const String form =
      '/preview-form';
}