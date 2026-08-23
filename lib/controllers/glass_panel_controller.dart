import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../enums/glass_enums.dart';
import '../provider/glass_button_provider.dart';
import '../provider/glass_theme_provider.dart';
import '../theme/glass_effects.dart';

/// ============================================================================
/// CONFIGURATION COMMUNE DES BOUTONS GLASS
/// ============================================================================

const List<String> defaultGlassButtonIds = [
  'rotation',
  'notification',
  'volume',
  'brightness',
  'custom_unique',
];

/// ============================================================================
/// GLASS PANEL CONTROLLER
/// ============================================================================
///
/// Centralise uniquement la configuration et l'état visuel commun
/// du panel Glass.
///
/// Responsabilités :
///
/// - accès aux boutons Glass
/// - accès au thème Glass
/// - initialisation des boutons
/// - lecture de l'état d'un bouton
/// - activation / désactivation d'un bouton
/// - lecture du style Glass actuel
/// - lecture des effets Glass actuels
///
/// La logique d'action, de loading, de succès et d'erreur appartient
/// à [GlassActionController].
/// ============================================================================

class GlassPanelController {
  final WidgetRef ref;

  GlassPanelController(this.ref);

  // ==========================================================================
  // NOTIFIER DES BOUTONS
  // ==========================================================================

  GlassButtonNotifier get notifier {
    return ref.read(glassButtonProvider.notifier);
  }

  // ==========================================================================
  // THÈME GLASS
  // ==========================================================================

  GlassThemeState get theme {
    return ref.read(glassThemeProvider);
  }

  // ==========================================================================
  // STYLE AQUA
  // ==========================================================================

  bool get useAquaStyle {
    return theme.useAquaStyle;
  }

  // ==========================================================================
  // STYLE GLASS ACTUEL
  // ==========================================================================

  GlassStyle get currentStyle {
    return theme.style;
  }

  // ==========================================================================
  // EFFET GLASS ACTUEL
  // ==========================================================================

  GlassEffects get containerEffect {
    return theme.effects;
  }

  // ==========================================================================
  // COULEUR APP BAR
  // ==========================================================================

  Color get appBarBackgroundColor {
    return theme.appBarBackgroundColor;
  }

  // ==========================================================================
  // COULEUR BORDURE APP BAR
  // ==========================================================================

  Color get appBarBorderColor {
    return theme.appBarBorderColor;
  }

  // ==========================================================================
  // COULEUR ICÔNE APP BAR
  // ==========================================================================

  Color get appBarIconColor {
    return theme.appBarIconColor;
  }

  // ==========================================================================
  // INITIALISATION
  // ==========================================================================

  void initialize() {
    for (final String id in defaultGlassButtonIds) {
      notifier.initButton(id, false);
    }
  }

  // ==========================================================================
  // CHANGEMENT DU STYLE
  // ==========================================================================

  Future<void> changeStyle(bool value) async {
    await ref.read(glassThemeProvider.notifier).setAquaStyle(value);
  }

  // ==========================================================================
  // TOGGLE DU STYLE
  // ==========================================================================

  Future<void> toggleStyle() async {
    await ref.read(glassThemeProvider.notifier).toggleAquaStyle();
  }

  // ==========================================================================
  // RESET DU THÈME
  // ==========================================================================

  Future<void> resetTheme() async {
    await ref.read(glassThemeProvider.notifier).reset();
  }

  // ==========================================================================
  // ÉTAT D'UN BOUTON
  // ==========================================================================

  GlassButtonState stateOf(String buttonId) {
    return ref.watch(
      glassButtonProvider.select((state) {
        return state[buttonId] ?? const GlassButtonState();
      }),
    );
  }

  // ==========================================================================
  // BOUTON ACTIF ?
  // ==========================================================================

  bool isActive(String buttonId) {
    return ref.read(glassButtonProvider)[buttonId]?.isActive ?? false;
  }

  // ==========================================================================
  // BOUTON EN CHARGEMENT ?
  // ==========================================================================

  bool isLoading(String buttonId) {
    return ref.read(glassButtonProvider)[buttonId]?.isLoading ?? false;
  }

  // ==========================================================================
  // TEXTE PERSONNALISÉ
  // ==========================================================================

  String? customText(String buttonId) {
    return ref.read(glassButtonProvider)[buttonId]?.customText;
  }

  // ==========================================================================
  // TOGGLE SIMPLE
  // ==========================================================================

  void toggle(String buttonId) {
    notifier.toggleActive(buttonId);
  }

  // ==========================================================================
  // ACTIVER
  // ==========================================================================

  void activate(String buttonId) {
    notifier.setActive(buttonId, true);
  }

  // ==========================================================================
  // DÉSACTIVER
  // ==========================================================================

  void deactivate(String buttonId) {
    notifier.setActive(buttonId, false);
  }

  // ==========================================================================
  // RESET D'UN BOUTON
  // ==========================================================================

  void resetButton(String buttonId, {bool active = false}) {
    notifier.resetButton(buttonId, active: active);
  }
}
