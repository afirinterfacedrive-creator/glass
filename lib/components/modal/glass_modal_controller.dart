import 'package:flutter/material.dart';

/// ============================================================================
/// GLASS MODAL CONTROLLER
/// ============================================================================
///
/// Controller interne utilisé par [GlassModal].
///
/// Ce controller n'est pas exporté par `glass.dart`.
///
/// Responsabilités :
///
/// - gérer l'ouverture/fermeture du modal ;
/// - conserver l'état de fermeture ;
/// - éviter les fermetures multiples ;
/// - exposer les méthodes nécessaires au widget.
///
/// ============================================================================
class GlassModalController {
  // ==========================================================================
  // CONSTRUCTEUR
  // ==========================================================================

  GlassModalController({
    VoidCallback? onClose,
  }) : _onClose = onClose;

  // ==========================================================================
  // CALLBACK
  // ==========================================================================

  final VoidCallback? _onClose;

  // ==========================================================================
  // ÉTAT
  // ==========================================================================

  bool _closed = false;

  /// Indique si le modal a déjà été fermé.
  bool get isClosed => _closed;

  // ==========================================================================
  // CLOSE
  // ==========================================================================

  void close() {
    if (_closed) {
      return;
    }

    _closed = true;
    _onClose?.call();
  }

  // ==========================================================================
  // RESET
  // ==========================================================================

  void reset() {
    _closed = false;
  }
}