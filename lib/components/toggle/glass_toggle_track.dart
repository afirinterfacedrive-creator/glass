import 'dart:ui';

import 'package:flutter/material.dart';

import 'glass_highlight.dart';

/// ============================================================================
/// GLASS TOGGLE TRACK
/// ============================================================================
///
/// Rail / coque principale du GlassToggle.
///
/// Responsabilités :
/// - créer le fond translucide Glass
/// - appliquer le BackdropFilter
/// - gérer l'apparence ON / OFF
/// - afficher les différents reflets
/// - produire le halo lumineux actif
///
/// L'interaction est gérée par [GlassToggle].
///
/// ============================================================================

class GlassToggleTrack extends StatelessWidget {
  final bool value;
  final Color activeColor;

  const GlassToggleTrack({
    super.key,
    required this.value,
    required this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),

      // ======================================================================
      // BLUR GLASS
      // ======================================================================
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),

        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),

            // ==================================================================
            // FOND GLASS
            // ==================================================================
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: value
                  ? [
                      activeColor.withValues(alpha: 0.30),
                      activeColor.withValues(alpha: 0.17),
                      Colors.white.withValues(alpha: 0.08),
                      Colors.black.withValues(alpha: 0.08),
                    ]
                  : [
                      Colors.white.withValues(alpha: 0.25),
                      Colors.white.withValues(alpha: 0.14),
                      Colors.white.withValues(alpha: 0.06),
                      Colors.black.withValues(alpha: 0.10),
                    ],
            ),

            // ==================================================================
            // BORDURE
            // ==================================================================
            border: Border.all(
              color: value
                  ? Colors.white.withValues(alpha: 0.78)
                  : Colors.white.withValues(alpha: 0.58),
              width: 1.15,
            ),

            // ==================================================================
            // OMBRES
            // ==================================================================
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.22),
                blurRadius: 7,
                spreadRadius: 0.2,
                offset: const Offset(0, 3),
              ),

              if (value)
                BoxShadow(
                  color: activeColor.withValues(alpha: 0.28),
                  blurRadius: 12,
                  spreadRadius: 0.5,
                ),
            ],
          ),

          // ====================================================================
          // REFLETS
          // ====================================================================
          child: Stack(
            children: [
              // ================================================================
              // REFLET SUPÉRIEUR
              // ================================================================
              const Positioned(
                left: 5,
                right: 5,
                top: 2,
                child: GlassHighlight(height: 8, opacity: 0.32),
              ),

              // ================================================================
              // REFLET DIAGONAL
              // ================================================================
              Positioned.fill(
                child: IgnorePointer(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withValues(alpha: 0.13),
                          Colors.transparent,
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.07),
                        ],
                        stops: const [0.0, 0.32, 0.70, 1.0],
                      ),
                    ),
                  ),
                ),
              ),

              // ================================================================
              // LIGNE LUMINEUSE SUPÉRIEURE
              // ================================================================
              Positioned(
                left: 10,
                right: 10,
                top: 1,
                child: Container(
                  height: 1.2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white.withValues(alpha: 0.72),
                  ),
                ),
              ),

              // ================================================================
              // REFLET INFÉRIEUR
              // ================================================================
              Positioned(
                left: 8,
                right: 8,
                bottom: 2,
                child: Container(
                  height: 1,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white.withValues(alpha: 0.14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
