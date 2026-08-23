import 'package:flutter/material.dart';

import 'package:glass/glass.dart';

import '../../routes/app_routes.dart';
import 'home_action_card.dart';

// ============================================================================
// HOME QUICK ACCESS
// ============================================================================
//
// Section contenant les raccourcis principaux de l'application Example.
//
// Responsabilités :
//
// - afficher les raccourcis principaux
// - utiliser les composants Glass du package
// - déclencher la navigation de l'application Example
//
// IMPORTANT :
//
// AppRoutes appartient à l'application Example.
// Il ne fait PAS partie du package Glass.
//
// ============================================================================

class HomeQuickAccess extends StatelessWidget {
  // ==========================================================================
  // THEME GLASS
  // ==========================================================================

  final GlassThemeState theme;

  // ==========================================================================
  // CONSTRUCTEUR
  // ==========================================================================

  const HomeQuickAccess({super.key, required this.theme});

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
          'QUICK ACCESS',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 13,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.3,
          ),
        ),

        const SizedBox(height: 14),

        // ====================================================================
        // RACCOURCIS
        // ====================================================================
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            // ==================================================================
            // CONTROL PANEL
            // ==================================================================
            HomeActionCard(
              theme: theme,
              icon: Icons.tune,
              title: 'Control Panel',
              subtitle: 'Contrôler les composants',
              onTap: () {
                Navigator.of(context).pushNamed(AppRoutes.controlPanel);
              },
            ),

            // ==================================================================
            // SETTINGS
            // ==================================================================
            HomeActionCard(
              theme: theme,
              icon: Icons.settings_outlined,
              title: 'Settings',
              subtitle: 'Configurer l’application',
              onTap: () {
                Navigator.of(context).pushNamed(AppRoutes.settings);
              },
            ),

            // ==================================================================
            // PHYSICAL TOGGLES
            // ==================================================================
            HomeActionCard(
              theme: theme,
              icon: Icons.toggle_on_outlined,
              title: 'Physical Toggles',
              subtitle: 'Tester les interrupteurs',
              onTap: () {
                Navigator.of(context).pushNamed(AppRoutes.physicalToggles);
              },
            ),

            // ==================================================================
            // APPEARANCE
            // ==================================================================
            HomeActionCard(
              theme: theme,
              icon: Icons.palette_outlined,
              title: 'Appearance',
              subtitle: 'Personnaliser le style',
              onTap: () {
                Navigator.of(context).pushNamed(AppRoutes.appearance);
              },
            ),
          ],
        ),
      ],
    );
  }
}
