import 'package:flutter/material.dart';

/// ============================================================================
/// GLASS TOOLTIP CONTROLLER
/// ============================================================================
///
/// Controller interne de [GlassTooltip].
///
/// Il permet de contrôler explicitement l'état d'affichage d'un tooltip.
///
class GlassTooltipController {
  GlassTooltipController({
    VoidCallback? onShow,
    VoidCallback? onHide,
  })  : _onShow = onShow,
        _onHide = onHide;

  final VoidCallback? _onShow;
  final VoidCallback? _onHide;

  bool _visible = false;

  /// Indique si le tooltip est actuellement considéré comme visible.
  bool get isVisible => _visible;

  // ==========================================================================
  // SHOW
  // ==========================================================================

  void show() {
    if (_visible) {
      return;
    }

    _visible = true;
    _onShow?.call();
  }

  // ==========================================================================
  // HIDE
  // ==========================================================================

  void hide() {
    if (!_visible) {
      return;
    }

    _visible = false;
    _onHide?.call();
  }

  // ==========================================================================
  // TOGGLE
  // ==========================================================================

  void toggle() {
    if (_visible) {
      hide();
    } else {
      show();
    }
  }

  // ==========================================================================
  // RESET
  // ==========================================================================

  void reset() {
    _visible = false;
  }
}