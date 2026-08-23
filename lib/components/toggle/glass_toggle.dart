// lib/components/toggle/glass_toggle.dart

import 'package:flutter/material.dart';

import 'glass_toggle_knob.dart';
import 'glass_toggle_track.dart';

/// ============================================================================
/// GLASS TOGGLE
/// ============================================================================
///
/// Toggle principal du package Glass.
///
/// Architecture :
///
/// GlassToggle
///     │
///     ├── GlassToggleTrack
///     │       └── GlassHighlight
///     │
///     └── GlassToggleKnob
///
/// Le composant gère :
/// - l'interaction utilisateur
/// - l'état ON / OFF fourni par le parent
/// - le curseur desktop
/// - l'animation d'appui
///
/// Le rendu Glass est délégué à :
/// - GlassToggleTrack
/// - GlassToggleKnob
///
/// ============================================================================

class GlassToggle extends StatefulWidget {
  /// État actuel du toggle.
  final bool value;

  /// Callback appelé lors du changement d'état.
  final ValueChanged<bool> onChanged;

  /// Couleur principale lorsque le toggle est actif.
  final Color activeColor;

  /// Largeur totale du toggle.
  final double width;

  /// Hauteur totale du toggle.
  final double height;

  /// Permet d'activer ou désactiver l'interaction.
  final bool enabled;

  const GlassToggle({
    super.key,
    required this.value,
    required this.onChanged,
    this.activeColor = Colors.cyanAccent,
    this.width = 65,
    this.height = 35,
    this.enabled = true,
  });

  @override
  State<GlassToggle> createState() => _GlassToggleState();
}

class _GlassToggleState extends State<GlassToggle> {
  bool _pressed = false;

  // ==========================================================================
  // INTERACTION
  // ==========================================================================

  void _handleTap() {
    if (!widget.enabled) {
      return;
    }

    widget.onChanged(!widget.value);
  }

  void _handleTapDown(TapDownDetails details) {
    if (!widget.enabled) {
      return;
    }

    setState(() {
      _pressed = true;
    });
  }

  void _handleTapUp(TapUpDetails details) {
    if (!widget.enabled) {
      return;
    }

    setState(() {
      _pressed = false;
    });
  }

  void _handleTapCancel() {
    if (!widget.enabled) {
      return;
    }

    setState(() {
      _pressed = false;
    });
  }

  // ==========================================================================
  // BUILD
  // ==========================================================================

  @override
  Widget build(BuildContext context) {
    Widget toggle = SizedBox(
      width: widget.width,
      height: widget.height,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // ==================================================================
          // TRACK
          // ==================================================================
          Positioned.fill(
            child: GlassToggleTrack(
              value: widget.value,
              activeColor: widget.activeColor,
            ),
          ),

          // ==================================================================
          // KNOB
          // ==================================================================
          GlassToggleKnob(
            value: widget.value,
            activeColor: widget.activeColor,
            width: widget.width,
            height: widget.height,
          ),
        ],
      ),
    );

    // =========================================================================
    // ÉTAT DÉSACTIVÉ
    // =========================================================================

    if (!widget.enabled) {
      toggle = Opacity(opacity: 0.45, child: toggle);
    }

    // =========================================================================
    // ANIMATION D'APPUI
    // =========================================================================

    return MouseRegion(
      cursor: widget.enabled
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,

      child: GestureDetector(
        behavior: HitTestBehavior.opaque,

        onTap: widget.enabled ? _handleTap : null,

        onTapDown: widget.enabled ? _handleTapDown : null,

        onTapUp: widget.enabled ? _handleTapUp : null,

        onTapCancel: widget.enabled ? _handleTapCancel : null,

        child: AnimatedScale(
          scale: _pressed ? 0.94 : 1.0,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOutCubic,
          child: toggle,
        ),
      ),
    );
  }
}
