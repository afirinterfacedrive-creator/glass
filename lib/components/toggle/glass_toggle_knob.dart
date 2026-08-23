// lib/components/toggle/glass_toggle_knob.dart

import 'package:flutter/material.dart';

/// ============================================================================
/// GLASS TOGGLE KNOB
/// ============================================================================
///
/// Bille / bouton mobile du GlassToggle.
///
/// Responsabilités :
/// - positionner le knob selon l'état ON/OFF
/// - produire l'effet de verre bombé
/// - gérer le reflet
/// - gérer le halo lumineux lorsque le toggle est actif
///
/// Le composant ne gère PAS le clic.
/// C'est [GlassToggle] qui gère l'interaction.
///
/// ============================================================================

class GlassToggleKnob extends StatelessWidget {
  /// État actuel du toggle.
  final bool value;

  /// Couleur principale lorsque le toggle est actif.
  final Color activeColor;

  /// Largeur totale du GlassToggle.
  final double width;

  /// Hauteur totale du GlassToggle.
  final double height;

  const GlassToggleKnob({
    super.key,
    required this.value,
    required this.activeColor,
    required this.width,
    required this.height,
  });

  // ==========================================================================
  // DIMENSIONS
  // ==========================================================================

  /// Taille minimale du knob.
  static const double minKnobSize = 20.0;

  /// Taille maximale du knob.
  static const double maxKnobSize = 34.0;

  /// Proportion du knob par rapport à la hauteur du toggle.
  static const double knobHeightFactor = 0.77;

  /// Marge intérieure du track.
  static const double horizontalMargin = 4.0;

  @override
  Widget build(BuildContext context) {
    // ------------------------------------------------------------------------
    // CALCUL DE LA TAILLE DU KNOB
    // ------------------------------------------------------------------------

    final double knobSize = (height * knobHeightFactor).clamp(
      minKnobSize,
      maxKnobSize,
    );

    // ------------------------------------------------------------------------
    // POSITION HORIZONTALE
    // ------------------------------------------------------------------------

    final double leftPosition = value
        ? width - knobSize - horizontalMargin
        : horizontalMargin;

    // ------------------------------------------------------------------------
    // POSITION VERTICALE
    // ------------------------------------------------------------------------

    final double topPosition = (height - knobSize) / 2;

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 380),
      curve: Curves.easeOutBack,
      left: leftPosition,
      top: topPosition,

      // ======================================================================
      // KNOB
      // ======================================================================
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        width: knobSize,
        height: knobSize,

        decoration: BoxDecoration(
          shape: BoxShape.circle,

          // ==================================================================
          // VERRE BOMBÉ
          // ==================================================================
          gradient: RadialGradient(
            center: const Alignment(-0.35, -0.45),
            radius: 0.95,
            colors: value
                ? [
                    Colors.white.withValues(alpha: 0.98),
                    activeColor.withValues(alpha: 0.90),
                    activeColor.withValues(alpha: 0.58),
                    Colors.white.withValues(alpha: 0.20),
                  ]
                : [
                    Colors.white.withValues(alpha: 0.98),
                    Colors.white.withValues(alpha: 0.78),
                    Colors.white.withValues(alpha: 0.48),
                    Colors.white.withValues(alpha: 0.20),
                  ],
          ),

          // ==================================================================
          // BORDURE
          // ==================================================================
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.90),
            width: 1,
          ),

          // ==================================================================
          // OMBRES
          // ==================================================================
          boxShadow: [
            // Ombre principale
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.24),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),

            // Ombre interne / profondeur
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 1,
              spreadRadius: 1,
            ),

            // Halo actif
            if (value)
              BoxShadow(
                color: activeColor.withValues(alpha: 0.45),
                blurRadius: 9,
                spreadRadius: 0.5,
              ),
          ],
        ),

        // ====================================================================
        // REFLETS
        // ====================================================================
        child: Stack(
          children: [
            // ==================================================================
            // REFLET PRINCIPAL
            // ==================================================================
            Positioned(
              left: knobSize * 0.148,
              top: knobSize * 0.111,
              child: Container(
                width: knobSize * 0.333,
                height: knobSize * 0.185,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(knobSize),
                  color: Colors.white.withValues(alpha: 0.78),
                ),
              ),
            ),

            // ==================================================================
            // HALO INTERNE
            // ==================================================================
            Positioned(
              left: knobSize * 0.074,
              top: knobSize * 0.074,
              child: Container(
                width: knobSize * 0.519,
                height: knobSize * 0.519,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Colors.white.withValues(alpha: 0.32),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            // ==================================================================
            // REFLET INFÉRIEUR
            // ==================================================================
            Positioned(
              left: knobSize * 0.185,
              right: knobSize * 0.185,
              bottom: knobSize * 0.111,
              child: Container(
                height: knobSize * 0.074,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(knobSize),
                  color: Colors.white.withValues(alpha: 0.30),
                ),
              ),
            ),

            // ==================================================================
            // REFLET LATÉRAL
            // ==================================================================
            Positioned(
              right: knobSize * 0.111,
              top: knobSize * 0.259,
              child: Container(
                width: knobSize * 0.074,
                height: knobSize * 0.296,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(knobSize),
                  color: Colors.white.withValues(alpha: 0.25),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
