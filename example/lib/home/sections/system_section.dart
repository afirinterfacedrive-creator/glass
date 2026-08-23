import 'package:flutter/material.dart';

import 'package:universal_glass/glass.dart';

import '../widgets/status_card.dart';

// ============================================================================
// SYSTEM SECTION
// ============================================================================
//
// Section affichant l'état du système dans l'application Example.
//
// IMPORTANT :
//
// - GlassThemeState vient du package Glass.
// - HomeStatusCard appartient à l'application Example.
// - Cette section ne fait pas partie du package Glass.
//
// ============================================================================

class SystemSection extends StatelessWidget {
  // ==========================================================================
  // THEME GLASS
  // ==========================================================================

  final GlassThemeState theme;

  // ==========================================================================
  // CONSTRUCTEUR
  // ==========================================================================

  const SystemSection({super.key, required this.theme});

  // ==========================================================================
  // BUILD
  // ==========================================================================

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ====================================================================
        // TITRE
        // ====================================================================
        const Text(
          'SYSTEM',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 13,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.3,
          ),
        ),

        const SizedBox(height: 14),

        // ====================================================================
        // ÉTATS
        // ====================================================================
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            // ==================================================================
            // GLASS ENGINE
            // ==================================================================
            HomeStatusCard(
              theme: theme,
              icon: Icons.cloud_done_outlined,
              title: 'Glass Engine',
              value: 'Ready',
              active: true,
            ),

            // ==================================================================
            // STORAGE
            // ==================================================================
            HomeStatusCard(
              theme: theme,
              icon: Icons.storage_outlined,
              title: 'Storage',
              value: 'Available',
              active: true,
            ),

            // ==================================================================
            // SYSTEM
            // ==================================================================
            HomeStatusCard(
              theme: theme,
              icon: Icons.memory_outlined,
              title: 'System',
              value: 'Online',
              active: true,
            ),
          ],
        ),
      ],
    );
  }
}
