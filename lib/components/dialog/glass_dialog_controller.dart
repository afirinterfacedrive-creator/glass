import 'package:flutter/material.dart';

/// ============================================================================
/// GLASS DIALOG CONTROLLER
/// ============================================================================
///
/// Controller interne de [GlassDialog].
///
class GlassDialogController {
  GlassDialogController({
    VoidCallback? onClose,
  }) : _onClose = onClose;

  final VoidCallback? _onClose;

  bool _closed = false;

  bool get isClosed => _closed;

  void close() {
    if (_closed) {
      return;
    }

    _closed = true;
    _onClose?.call();
  }

  void reset() {
    _closed = false;
  }
}