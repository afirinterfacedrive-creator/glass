
import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:universal_glass/theme/glass_color_palette.dart';

// ============================================================================
// PHYSICAL TOGGLE SHELL
// ============================================================================
//
// Conteneur visuel générique pour les contrôles physiques.
//
// RESPONSABILITÉS
//
// - fournir un environnement Glass autour d'un toggle
// - gérer le fond translucide
// - gérer le blur
// - gérer la bordure
// - gérer les reflets
// - gérer les ombres
// - gérer l'état ACTIVE / INACTIVE visuellement
// - utiliser GlassColorPalette pour les couleurs globales
// - utiliser accent pour la couleur spécifique du contrôle
// - gérer l'interaction tactile globale si nécessaire
//
// NE GÈRE PAS
//
// - Riverpod
// - navigation
// - logique métier
// - état interne du toggle
// - type du toggle
// - callback métier
// - création de la palette
//
// Le contrôle réel est fourni via `child`.
//
// ============================================================================
//
// ARCHITECTURE
//
// GlassColorPalette
//        │
//        ▼
// PhysicalToggleShell
//        │
//        ├── palette.white
//        ├── palette.black
//        ├── palette.border
//        │
//        └── accent
//               │
//               └── couleur spécifique du contrôle
//
// ============================================================================

class PhysicalToggleShell extends StatelessWidget {
  // ==========================================================================
  // CONTENU
  // ==========================================================================

  final Widget child;

  // ==========================================================================
  // ÉTAT
  // ==========================================================================

  final bool value;

  // ==========================================================================
  // COULEUR D'ACCENT
  // ==========================================================================
  //
  // Couleur spécifique au contrôle physique.
  //
  // Exemple :
  //
  // Breaker → rouge
  // Rotary  → ambre
  // Glass   → cyan
  //
  // ==========================================================================

  final Color accent;

  // ==========================================================================
  // PALETTE GLASS
  // ==========================================================================
  //
  // Palette globale Universal Glass injectée depuis l'extérieur.
  //
  // Le Shell ne récupère jamais Riverpod directement.
  //
  // ==========================================================================

  final GlassColorPalette palette;

  // ==========================================================================
  // DIMENSIONS
  // ==========================================================================

  final double? width;
  final double? height;

  // ==========================================================================
  // RAYON
  // ==========================================================================

  final double borderRadius;

  // ==========================================================================
  // PADDING
  // ==========================================================================

  final EdgeInsetsGeometry padding;

  // ==========================================================================
  // BLUR
  // ==========================================================================

  final double blur;

  // ==========================================================================
  // OPACITÉ
  // ==========================================================================

  final double inactiveOpacity;
  final double activeOpacity;

  // ==========================================================================
  // BORDURE
  // ==========================================================================

  final double borderWidth;

  // ==========================================================================
  // CALLBACK OPTIONNEL
  // ==========================================================================

  final VoidCallback? onTap;

  // ==========================================================================
  // CONSTRUCTEUR
  // ==========================================================================

  const PhysicalToggleShell({
    super.key,

    // ------------------------------------------------------------------------
    // CONTENU
    // ------------------------------------------------------------------------

    required this.child,

    // ------------------------------------------------------------------------
    // ÉTAT
    // ------------------------------------------------------------------------

    required this.value,

    // ------------------------------------------------------------------------
    // ACCENT
    // ------------------------------------------------------------------------

    required this.accent,

    // ------------------------------------------------------------------------
    // PALETTE
    // ------------------------------------------------------------------------

    required this.palette,

    // ------------------------------------------------------------------------
    // DIMENSIONS
    // ------------------------------------------------------------------------

    this.width,
    this.height,

    // ------------------------------------------------------------------------
    // RAYON
    // ------------------------------------------------------------------------

    this.borderRadius = 18,

    // ------------------------------------------------------------------------
    // PADDING
    // ------------------------------------------------------------------------

    this.padding = const EdgeInsets.all(12),

    // ------------------------------------------------------------------------
    // BLUR
    // ------------------------------------------------------------------------

    this.blur = 10,

    // ------------------------------------------------------------------------
    // OPACITÉ
    // ------------------------------------------------------------------------

    this.inactiveOpacity = .055,
    this.activeOpacity = .085,

    // ------------------------------------------------------------------------
    // BORDURE
    // ------------------------------------------------------------------------

    this.borderWidth = 1,

    // ------------------------------------------------------------------------
    // CALLBACK
    // ------------------------------------------------------------------------

    this.onTap,
  });

  // ==========================================================================
  // BUILD
  // ==========================================================================

  @override
  Widget build(BuildContext context) {
    // =========================================================================
    // COULEURS DE LA PALETTE
    // =========================================================================

    final Color glassLight =
        palette.white;

    final Color glassDark =
        palette.black;

    final Color borderColor =
        palette.border;

    // =========================================================================
    // SHELL
    // =========================================================================

    final Widget shell = ClipRRect(
      borderRadius:
          BorderRadius.circular(
        borderRadius,
      ),

      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: blur,
          sigmaY: blur,
        ),

        child: AnimatedContainer(
          duration:
              const Duration(
            milliseconds: 220,
          ),

          curve: Curves.easeOut,

          // -------------------------------------------------------------------
          // DIMENSIONS
          // -------------------------------------------------------------------

          width: width,
          height: height,

          // -------------------------------------------------------------------
          // PADDING
          // -------------------------------------------------------------------

          padding: padding,

          // -------------------------------------------------------------------
          // DÉCORATION
          // -------------------------------------------------------------------

          decoration: BoxDecoration(
            // =================================================================
            // FOND GLASS
            // =================================================================
            //
            // On utilise désormais la palette au lieu de Colors.white.
            //
            color: glassLight.withValues(
              alpha: value
                  ? activeOpacity
                  : inactiveOpacity,
            ),

            // =================================================================
            // BORDURE
            // =================================================================

            borderRadius:
                BorderRadius.circular(
              borderRadius,
            ),

            border: Border.all(
              width: borderWidth,

              color: value
                  ? accent.withValues(
                      alpha: .32,
                    )
                  : borderColor.withValues(
                      alpha: .10,
                    ),
            ),

            // =================================================================
            // OMBRES
            // =================================================================

            boxShadow: [
              // ---------------------------------------------------------------
              // OMBRE PRINCIPALE
              // ---------------------------------------------------------------

              BoxShadow(
                color: glassDark.withValues(
                  alpha: .14,
                ),

                blurRadius: 14,

                offset: const Offset(
                  0,
                  6,
                ),
              ),

              // ---------------------------------------------------------------
              // HALO ACTIF
              // ---------------------------------------------------------------

              if (value)
                BoxShadow(
                  color: accent.withValues(
                    alpha: .10,
                  ),

                  blurRadius: 18,

                  spreadRadius: 1,
                ),
            ],
          ),

          // ===================================================================
          // CONTENU
          // ===================================================================

          child: Stack(
            children: [
              // ===============================================================
              // REFLET SUPÉRIEUR
              // ===============================================================

              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 1,

                child: IgnorePointer(
                  child: Container(
                    decoration:
                        BoxDecoration(
                      gradient:
                          LinearGradient(
                        begin:
                            Alignment
                                .centerLeft,

                        end:
                            Alignment
                                .centerRight,

                        colors: [
                          glassLight
                              .withValues(
                            alpha: .03,
                          ),

                          glassLight
                              .withValues(
                            alpha: .16,
                          ),

                          glassLight
                              .withValues(
                            alpha: .03,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // ===============================================================
              // CONTENU PRINCIPAL
              // ===============================================================

              Center(
                child: child,
              ),
            ],
          ),
        ),
      ),
    );

    // =========================================================================
    // INTERACTION OPTIONNELLE
    // =========================================================================

    if (onTap == null) {
      return shell;
    }

    return GestureDetector(
      behavior:
          HitTestBehavior.opaque,

      onTap: onTap,

      child: shell,
    );
  }
}

