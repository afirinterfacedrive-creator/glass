import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:glass/glass_exports.dart';

import 'sections/control_panel_section.dart';

// ============================================================================
// CONTROL PANEL PAGE
// ============================================================================
//
// Centre de contrôle principal de l'interface Glass.
//
// Architecture :
//
// ControlPanelPage
//       │
//       └── GlassScaffold
//              │
//              ├── GlassBackground
//              │
//              ├── UniversalAppBar
//              │      └── Bouton retour
//              │
//              └── Contenu
//                     │
//                     ├── PanelHeader
//                     │
//                     └── ControlPanelSection
//                            │
//                            ├── ControlPanelThemeCard
//                            └── autres contrôles
//
// ============================================================================
//
// RESPONSABILITÉS
//
// Cette page gère uniquement :
//
// - Riverpod
// - récupération du thème Glass
// - structure générale du contenu
//
// Elle ne gère PAS :
//
// - Scaffold
// - GlassBackground
// - UniversalAppBar
// - bouton retour
// - responsive global
// - scroll global
// - largeur maximale
// - dessin des cartes
// - effets Glass individuels
// - contrôles détaillés
// - animations internes
// - navigation détaillée
// - changement du thème Aqua
//
// Le changement du style Aqua est centralisé dans SettingsPage.
//
// ============================================================================

class ControlPanelPage extends ConsumerWidget {
  const ControlPanelPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // =========================================================================
    // THÈME GLASS
    // =========================================================================

    final GlassThemeState theme = ref.watch(glassThemeProvider);

    // =========================================================================
    // GLASS SCAFFOLD
    // =========================================================================

    return GlassScaffold(
      // =======================================================================
      // APP BAR
      // =======================================================================
      title: 'Control Panel',

      subtitle: 'GLASS CONTROLS',

      showLogo: true,

      showBackButton: true,

      useGradientBackground: theme.useAquaStyle,

      hideNavigation: true,

      // =======================================================================
      // CONTENU
      // =======================================================================
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          // ===================================================================
          // HEADER
          // ===================================================================
          const PanelHeader(
            title: 'Aesthetic Panel',
            subtitle: 'GLASS CONTROLS',
          ),

          const SizedBox(height: 28),

          // ===================================================================
          // SECTION PRINCIPALE
          // ===================================================================
          ControlPanelSection(theme: theme),

          const SizedBox(height: 36),
        ],
      ),
    );
  }
}
