import 'package:flutter/material.dart';

import 'physical_toggle_header.dart';
import 'physical_toggle_shell.dart';
import 'physical_toggle_status.dart';

// ============================================================================
// PHYSICAL TOGGLE CARD
// ============================================================================
//
// Carte générique pour un contrôle physique.
//
// ARCHITECTURE
//
// PhysicalToggleCard
//      │
//      ├── PhysicalToggleHeader
//      │
//      ├── PhysicalToggleShell
//      │       └── child
//      │
//      └── PhysicalToggleStatus
//
// RESPONSABILITÉS
//
// - composer le Header
// - composer le Shell Glass
// - afficher le contrôle reçu via `child`
// - composer le Status
//
// NE GÈRE PAS
//
// - Riverpod
// - navigation
// - logique métier
// - état interne du toggle
// - callback du toggle
// - type du toggle
// - décoration Glass interne
//
// Le contrôle réel est entièrement fourni via `child`.
//
// ============================================================================

class PhysicalToggleCard extends StatelessWidget {
  // ==========================================================================
  // INFORMATIONS
  // ==========================================================================

  final String title;
  final String subtitle;
  final IconData icon;

  // ==========================================================================
  // ÉTAT D'AFFICHAGE
  // ==========================================================================

  final bool value;

  // ==========================================================================
  // COULEUR D'ACCENT
  // ==========================================================================

  final Color accent;

  // ==========================================================================
  // TOGGLE
  // ==========================================================================

  final Widget child;

  // ==========================================================================
  // DIMENSIONS OPTIONNELLES
  // ==========================================================================

  final double? width;
  final double? height;

  // ==========================================================================
  // PADDING
  // ==========================================================================

  final EdgeInsetsGeometry padding;

  // ==========================================================================
  // CONSTRUCTEUR
  // ==========================================================================

  const PhysicalToggleCard({
    super.key,

    required this.title,
    required this.subtitle,
    required this.icon,
    required this.value,
    required this.accent,
    required this.child,

    this.width,
    this.height,

    this.padding = const EdgeInsets.all(15),
  });

  // ==========================================================================
  // BUILD
  // ==========================================================================

  @override
  Widget build(BuildContext context) {
    return PhysicalToggleShell(
      value: value,
      accent: accent,

      width: width,
      height: height,

      padding: padding,

      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ===================================================================
          // HEADER
          // ===================================================================
          PhysicalToggleHeader(
            title: title,
            subtitle: subtitle,
            icon: icon,
            value: value,
            accent: accent,
          ),

          const SizedBox(height: 12),

          // ===================================================================
          // TOGGLE
          // ===================================================================
          //
          // Le contrôle conserve sa taille naturelle.
          //
          // Aucun Expanded.
          // Aucun height imposé.
          //
          // Cela évite les RenderFlex overflow sur mobile.
          //
          // ===================================================================
          Center(child: child),

          const SizedBox(height: 10),

          // ===================================================================
          // STATUS
          // ===================================================================
          PhysicalToggleStatus(value: value, accent: accent),
        ],
      ),
    );
  }
}
