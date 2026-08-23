import 'package:flutter/material.dart';

import 'package:glass/glass.dart';

import 'sections/appearance_section.dart';
import 'sections/general_section.dart';

// ============================================================================
// SETTINGS PAGE
// ============================================================================
//
// Page principale des paramètres.
//
// Architecture :
//
// SettingsPage
//      │
//      └── GlassScaffold
//             │
//             ├── UniversalAppBar
//             │      └── Bouton retour
//             │
//             └── Contenu
//                    │
//                    ├── AppearanceSection
//                    │      └── AquaGlassSwitch
//                    │
//                    └── GeneralSection
//                           ├── Notifications
//                           └── Sound
//
// ============================================================================
//
// RESPONSABILITÉS
//
// SettingsPage gère uniquement :
//
// - structure générale
// - titre
// - responsive local
// - organisation des sections
//
// Elle ne gère PAS :
//
// - Riverpod
// - GlassBackground
// - UniversalAppBar
// - bouton retour
// - toggle Aqua
// - cartes individuelles
// - logique des paramètres
//
// ============================================================================

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassScaffold(
      // =======================================================================
      // APP BAR
      // =======================================================================
      title: 'Settings',

      subtitle: 'APPLICATION SETTINGS',

      showLogo: true,

      showBackButton: true,

      hideNavigation: true,

      // =======================================================================
      // CONTENU
      // =======================================================================
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final bool compact = constraints.maxWidth < 600;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              // =================================================================
              // TITRE
              // =================================================================
              Text(
                'Settings',

                style: TextStyle(
                  color: Colors.white,

                  fontSize: compact ? 24 : 28,

                  fontWeight: FontWeight.bold,

                  shadows: const [
                    Shadow(blurRadius: 10, color: Colors.black26),
                  ],
                ),
              ),

              const SizedBox(height: 6),

              // =================================================================
              // DESCRIPTION
              // =================================================================
              Text(
                'Configurez l’apparence et les '
                'préférences de l’application.',

                style: TextStyle(
                  color: Colors.white54,

                  fontSize: compact ? 11 : 12,

                  height: 1.4,
                ),
              ),

              SizedBox(height: compact ? 24 : 30),

              // =================================================================
              // APPEARANCE
              // =================================================================
              const AppearanceSection(),

              SizedBox(height: compact ? 20 : 24),

              // =================================================================
              // GENERAL
              // =================================================================
              const GeneralSection(),

              const SizedBox(height: 36),
            ],
          );
        },
      ),
    );
  }
}
