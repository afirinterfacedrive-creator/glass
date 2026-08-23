import 'dart:ui';

import 'package:flutter/material.dart';

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
//
// Le contrôle réel est fourni via `child`.
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

  final Color accent;

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
    required this.child,
    required this.value,
    required this.accent,
    this.width,
    this.height,
    this.borderRadius = 18,
    this.padding = const EdgeInsets.all(12),
    this.blur = 10,
    this.inactiveOpacity = .055,
    this.activeOpacity = .085,
    this.borderWidth = 1,
    this.onTap,
  });

  // ==========================================================================
  // BUILD
  // ==========================================================================

  @override
  Widget build(BuildContext context) {
    final Widget shell = ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,

          width: width,
          height: height,

          padding: padding,

          decoration: BoxDecoration(
            // =================================================================
            // FOND GLASS
            // =================================================================
            color: Colors.white.withValues(
              alpha: value ? activeOpacity : inactiveOpacity,
            ),

            // =================================================================
            // BORDURE
            // =================================================================
            borderRadius: BorderRadius.circular(borderRadius),

            border: Border.all(
              width: borderWidth,
              color: value
                  ? accent.withValues(alpha: .32)
                  : Colors.white.withValues(alpha: .10),
            ),

            // =================================================================
            // OMBRES
            // =================================================================
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: .14),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),

              if (value)
                BoxShadow(
                  color: accent.withValues(alpha: .10),
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
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Colors.white.withValues(alpha: .03),
                          Colors.white.withValues(alpha: .16),
                          Colors.white.withValues(alpha: .03),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // ===============================================================
              // CONTENU PRINCIPAL
              // ===============================================================
              Center(child: child),
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
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: shell,
    );
  }
}
