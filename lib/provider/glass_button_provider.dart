import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/shared_preferences_provider.dart';

// ============================================================================
// GLASS — BUTTON PROVIDER
// ============================================================================
//
// Gestion globale de l'état des boutons Glass.
//
// Compatible Riverpod 3.x.
//
// Responsabilités :
//
// - état actif / inactif
// - état loading
// - texte personnalisé
// - persistance SharedPreferences
// - initialisation des boutons
// - toggle
// - reset
//
// ============================================================================

// ============================================================================
// ÉTAT D'UN BOUTON GLASS
// ============================================================================

class GlassButtonState {
  final bool isActive;
  final bool isLoading;
  final String? customText;

  const GlassButtonState({
    this.isActive = false,
    this.isLoading = false,
    this.customText,
  });

  // ==========================================================================
  // COPY WITH
  // ==========================================================================

  GlassButtonState copyWith({
    bool? isActive,
    bool? isLoading,
    String? customText,
    bool clearCustomText = false,
  }) {
    return GlassButtonState(
      isActive: isActive ?? this.isActive,
      isLoading: isLoading ?? this.isLoading,
      customText: clearCustomText ? null : (customText ?? this.customText),
    );
  }

  // ==========================================================================
  // HELPERS
  // ==========================================================================

  bool get hasCustomText {
    return customText != null && customText!.trim().isNotEmpty;
  }
}

// ============================================================================
// NOTIFIER GLOBAL DES BOUTONS GLASS
// ============================================================================
//
// Riverpod 3.x :
//
// Ancien :
// StateNotifier<Map<String, GlassButtonState>>
//
// Nouveau :
// Notifier<Map<String, GlassButtonState>>
//
// ============================================================================

class GlassButtonNotifier extends Notifier<Map<String, GlassButtonState>> {
  // ==========================================================================
  // SHARED PREFERENCES
  // ==========================================================================

  SharedPreferences get _prefs {
    return ref.read(sharedPreferencesProvider);
  }

  // ==========================================================================
  // ÉTAT INITIAL
  // ==========================================================================

  @override
  Map<String, GlassButtonState> build() {
    return <String, GlassButtonState>{};
  }

  // ==========================================================================
  // INITIALISATION
  // ==========================================================================
  //
  // Initialise un bouton uniquement s'il n'existe pas encore.
  //
  // La valeur sauvegardée dans SharedPreferences est prioritaire.
  //
  // ==========================================================================

  void initButton(String id, bool defaultActive) {
    // ------------------------------------------------------------------------
    // NE PAS RÉINITIALISER UN BOUTON EXISTANT
    // ------------------------------------------------------------------------

    if (state.containsKey(id)) {
      return;
    }

    // ------------------------------------------------------------------------
    // RESTAURATION DE L'ÉTAT SAUVEGARDÉ
    // ------------------------------------------------------------------------

    final bool savedActive = _prefs.getBool('glass_btn_$id') ?? defaultActive;

    // ------------------------------------------------------------------------
    // AJOUT DU BOUTON
    // ------------------------------------------------------------------------

    state = {...state, id: GlassButtonState(isActive: savedActive)};
  }

  // ==========================================================================
  // ACTIVER / DÉSACTIVER
  // ==========================================================================

  void setActive(String id, bool value) {
    final GlassButtonState? current = state[id];

    // ------------------------------------------------------------------------
    // BOUTON INCONNU
    // ------------------------------------------------------------------------

    if (current == null) {
      return;
    }

    // ------------------------------------------------------------------------
    // MISE À JOUR DE L'ÉTAT
    // ------------------------------------------------------------------------

    state = {...state, id: current.copyWith(isActive: value)};

    // ------------------------------------------------------------------------
    // PERSISTANCE
    // ------------------------------------------------------------------------

    _prefs.setBool('glass_btn_$id', value);
  }

  // ==========================================================================
  // TOGGLE
  // ==========================================================================

  void toggleActive(String id) {
    final GlassButtonState? current = state[id];

    if (current == null) {
      return;
    }

    setActive(id, !current.isActive);
  }

  // ==========================================================================
  // LOADING
  // ==========================================================================

  void setLoading(
    String id,
    bool loading, {
    String? customText,
    bool clearCustomText = false,
  }) {
    final GlassButtonState? current = state[id];

    // ------------------------------------------------------------------------
    // BOUTON INCONNU
    // ------------------------------------------------------------------------

    if (current == null) {
      return;
    }

    // ------------------------------------------------------------------------
    // MISE À JOUR
    // ------------------------------------------------------------------------

    state = {
      ...state,
      id: current.copyWith(
        isLoading: loading,
        customText: customText,
        clearCustomText: clearCustomText,
      ),
    };
  }

  // ==========================================================================
  // TEXTE PERSONNALISÉ
  // ==========================================================================

  void setCustomText(String id, String? text) {
    final GlassButtonState? current = state[id];

    if (current == null) {
      return;
    }

    state = {...state, id: current.copyWith(customText: text)};
  }

  // ==========================================================================
  // EFFACER LE TEXTE PERSONNALISÉ
  // ==========================================================================

  void clearCustomText(String id) {
    final GlassButtonState? current = state[id];

    if (current == null) {
      return;
    }

    state = {...state, id: current.copyWith(clearCustomText: true)};
  }

  // ==========================================================================
  // RESET COMPLET
  // ==========================================================================
  //
  // Remet le bouton à son état initial :
  //
  // - isActive
  // - isLoading = false
  // - customText = null
  //
  // ==========================================================================

  void resetButton(String id, {bool active = false}) {
    // ------------------------------------------------------------------------
    // BOUTON INCONNU
    // ------------------------------------------------------------------------

    if (!state.containsKey(id)) {
      return;
    }

    // ------------------------------------------------------------------------
    // RESET
    // ------------------------------------------------------------------------

    state = {...state, id: GlassButtonState(isActive: active)};

    // ------------------------------------------------------------------------
    // PERSISTANCE
    // ------------------------------------------------------------------------

    _prefs.setBool('glass_btn_$id', active);
  }
}

// ============================================================================
// PROVIDER GLOBAL
// ============================================================================
//
// Riverpod 3.x
//
// Ancien :
//
// StateNotifierProvider
//
// Nouveau :
//
// NotifierProvider
//
// ============================================================================

final glassButtonProvider =
    NotifierProvider<GlassButtonNotifier, Map<String, GlassButtonState>>(
      GlassButtonNotifier.new,
    );

// ============================================================================
// FIN
// ============================================================================
