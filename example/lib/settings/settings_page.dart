import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:universal_glass/glass.dart';
import 'package:universal_glass_example/settings/widgets/appearance/appearance_section.dart';
import 'sections/general_section.dart';

// ============================================================================
// SETTINGS PAGE
// ============================================================================

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // WATCH POUR REBUILD LIVE QUAND BLUR/NOISE/GRADIENT CHANGE
    final GlassThemeState theme = ref.watch(glassThemeProvider);

    return GlassScaffold(
      // =======================================================================
      // APP BAR - MODE CUSTOM GRADIENT POUR TEST LIVE
      // =======================================================================
      title: 'Settings',
      subtitle: 'APPLICATION SETTINGS',
      showLogo: true,
      showBackButton: true,
      useCustomGradient: true, 
      customGradientKey: 'appbar_gradient',
      blur: theme.blur,   
      noise: theme.noise, 
      hideNavigation: true,
      maxWidth: 1200, // Ajusté pour offrir un confort maximal à la double colonne PC

      // =======================================================================
      // CONTENU RESPONSIVE DE LA PAGE PARAMÈTRES
      // =======================================================================
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final bool compact = constraints.maxWidth < 600;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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

              Text(
                'Configurez l’apparence et les '
                'préférences de l’application.',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.54), 
                  fontSize: compact ? 11 : 12, 
                  height: 1.4,
                ),
              ),

              SizedBox(height: compact ? 24 : 30),

              // =================================================================
              // DISPOSITIF DE GRILLE RESPONSIVE SÉCURISÉ POUR LES RÉGLAGES
              // =================================================================
              GlassResponsiveGrid(
                spacing: 24,       // Bel espace aéré entre les deux blocs
                runSpacing: 24,    // Espace de sécurité lors du repli mobile
                mobileColumns: 1,  // Écrans mobiles : Empilage vertical logique
                tabletColumns: 1,  // Tablettes compactes en portrait
                desktopColumns: 2, // Grands écrans : Affichage côte à côte ultra-pro
                tabletBreakpoint: 600,
                desktopBreakpoint: 900, // Seuil de bascule chirurgical pour la double colonne
                children: [
                  // BLOC ÉLÉMENT 1 : PANNEAU APPARENCE
                  AppearanceSection(
                    onThemeChanged: () => ref.invalidate(glassThemeProvider),
                  ),

                  // BLOC ÉLÉMENT 2 : PANNEAU GÉNÉRAL
                  const GeneralSection(),
                ],
              ),

              const SizedBox(height: 36),
            ],
          );
        },
      ),
    );
  }
}
