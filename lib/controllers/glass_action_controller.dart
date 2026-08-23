import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../provider/glass_button_provider.dart';

// ============================================================================
// GLASS ACTION CONTROLLER
// ============================================================================
//
// Contrôleur central des actions des boutons Glass.
//
// Responsabilités :
//
// - activation automatique
// - état loading
// - exécution d'une action réelle
// - mode démonstration
// - affichage du succès
// - affichage de l'erreur
// - nettoyage automatique du texte
// - désactivation automatique
// - protection contre les doubles actions
// - propagation des erreurs
// - synchronisation avec AsyncValue
//
// ============================================================================

class GlassActionController extends StateNotifier<AsyncValue<void>> {
  final Ref _ref;

  GlassActionController(this._ref) : super(const AsyncData(null));

  // ==========================================================================
  // EXÉCUTER UNE ACTION
  // ==========================================================================

  Future<void> run(
    String buttonId, {
    String loadingText = 'Connexion...',
    String successText = 'SUCCÈS!',
    String errorText = 'ERREUR',
    Duration actionDuration = const Duration(seconds: 3),
    Duration successDuration = const Duration(seconds: 1),
    Future<void> Function()? action,
    bool autoActivate = true,
    bool autoDeactivate = true,
  }) async {
    final notifier = _ref.read(glassButtonProvider.notifier);

    // ------------------------------------------------------------------------
    // RÉCUPÉRATION DE L'ÉTAT DU BOUTON
    // ------------------------------------------------------------------------

    final currentState = _ref.read(glassButtonProvider)[buttonId];

    // ------------------------------------------------------------------------
    // BOUTON INCONNU
    // ------------------------------------------------------------------------

    if (currentState == null) {
      debugPrint(
        '⚠️ GlassActionController : '
        'bouton "$buttonId" non initialisé.',
      );

      return;
    }

    // ------------------------------------------------------------------------
    // PROTECTION CONTRE LES DOUBLES ACTIONS
    // ------------------------------------------------------------------------

    if (currentState.isLoading) {
      debugPrint(
        'ℹ️ GlassActionController : '
        'action "$buttonId" déjà en cours.',
      );

      return;
    }

    // ------------------------------------------------------------------------
    // ACTIVATION AUTOMATIQUE
    // ------------------------------------------------------------------------

    if (autoActivate && !currentState.isActive) {
      notifier.setActive(buttonId, true);
    }

    // ------------------------------------------------------------------------
    // ÉTAT LOADING
    // ------------------------------------------------------------------------

    notifier.setLoading(buttonId, true, customText: loadingText);

    state = const AsyncLoading();

    // =========================================================================
    // ACTION
    // =========================================================================

    try {
      // =======================================================================
      // ACTION RÉELLE
      // =======================================================================

      if (action != null) {
        await action();
      } else {
        // ---------------------------------------------------------------------
        // MODE DÉMONSTRATION
        // ---------------------------------------------------------------------

        await Future<void>.delayed(actionDuration);
      }

      // =======================================================================
      // SUCCÈS
      // =======================================================================

      notifier.setLoading(buttonId, false, customText: successText);

      state = const AsyncData(null);

      // -----------------------------------------------------------------------
      // AFFICHAGE DU MESSAGE DE SUCCÈS
      // -----------------------------------------------------------------------

      await Future<void>.delayed(successDuration);

      // -----------------------------------------------------------------------
      // NETTOYAGE
      // -----------------------------------------------------------------------

      _clearButtonState(buttonId);

      // -----------------------------------------------------------------------
      // DÉSACTIVATION AUTOMATIQUE
      // -----------------------------------------------------------------------

      if (autoDeactivate) {
        _deactivateIfActive(buttonId);
      }
    } catch (error, stackTrace) {
      // =======================================================================
      // ERREUR
      // =======================================================================

      debugPrint(
        '❌ GlassActionController '
        '[$buttonId] : $error',
      );

      debugPrintStack(stackTrace: stackTrace);

      // -----------------------------------------------------------------------
      // ÉTAT ASYNC ERROR
      // -----------------------------------------------------------------------

      state = AsyncError(error, stackTrace);

      // -----------------------------------------------------------------------
      // AFFICHAGE DU MESSAGE D'ERREUR
      // -----------------------------------------------------------------------

      notifier.setLoading(buttonId, false, customText: errorText);

      // -----------------------------------------------------------------------
      // AFFICHAGE TEMPORAIRE DU MESSAGE D'ERREUR
      // -----------------------------------------------------------------------

      await Future<void>.delayed(successDuration);

      // -----------------------------------------------------------------------
      // NETTOYAGE
      // -----------------------------------------------------------------------

      _clearButtonState(buttonId);

      // -----------------------------------------------------------------------
      // DÉSACTIVATION AUTOMATIQUE
      // -----------------------------------------------------------------------

      if (autoDeactivate) {
        _deactivateIfActive(buttonId);
      }

      // -----------------------------------------------------------------------
      // PROPAGATION DE L'ERREUR
      // -----------------------------------------------------------------------
      //
      // Important :
      // L'erreur reste disponible pour le code appelant.
      //
      rethrow;
    }
  }

  // ==========================================================================
  // NETTOYER L'ÉTAT DU BOUTON
  // ==========================================================================

  void _clearButtonState(String buttonId) {
    final notifier = _ref.read(glassButtonProvider.notifier);

    final buttonState = _ref.read(glassButtonProvider)[buttonId];

    // ------------------------------------------------------------------------
    // Le bouton peut avoir été supprimé entre-temps.
    // ------------------------------------------------------------------------

    if (buttonState == null) {
      return;
    }

    notifier.setLoading(buttonId, false, clearCustomText: true);
  }

  // ==========================================================================
  // DÉSACTIVER SI ACTIF
  // ==========================================================================

  void _deactivateIfActive(String buttonId) {
    final buttonState = _ref.read(glassButtonProvider)[buttonId];

    // ------------------------------------------------------------------------
    // Bouton inexistant
    // ------------------------------------------------------------------------

    if (buttonState == null) {
      return;
    }

    // ------------------------------------------------------------------------
    // Désactivation uniquement s'il est actif
    // ------------------------------------------------------------------------

    if (!buttonState.isActive) {
      return;
    }

    _ref.read(glassButtonProvider.notifier).setActive(buttonId, false);
  }

  // ==========================================================================
  // TOGGLE
  // ==========================================================================

  void toggle(String buttonId) {
    _ref.read(glassButtonProvider.notifier).toggleActive(buttonId);
  }

  // ==========================================================================
  // ACTIVER
  // ==========================================================================

  void activate(String buttonId) {
    _ref.read(glassButtonProvider.notifier).setActive(buttonId, true);
  }

  // ==========================================================================
  // DÉSACTIVER
  // ==========================================================================

  void deactivate(String buttonId) {
    _ref.read(glassButtonProvider.notifier).setActive(buttonId, false);
  }

  // ==========================================================================
  // RESET
  // ==========================================================================

  void reset(String buttonId, {bool active = false}) {
    _ref
        .read(glassButtonProvider.notifier)
        .resetButton(buttonId, active: active);
  }
}

// ============================================================================
// PROVIDER
// ============================================================================

final glassActionControllerProvider =
    StateNotifierProvider<GlassActionController, AsyncValue<void>>((ref) {
      return GlassActionController(ref);
    });
