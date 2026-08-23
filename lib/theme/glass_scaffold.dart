import 'package:flutter/material.dart';

import 'glass_background.dart';
import 'package:universal_glass/core/app_bar/universal_app_bar.dart';

// ============================================================================
// GLASS SCAFFOLD
// ============================================================================
//
// Scaffold commun à toutes les pages Glass.
//
// Architecture :
//
// GlassScaffold
//      │
//      ├── GlassBackground
//      │
//      ├── UniversalAppBar
//      │      ├── Logo
//      │      ├── Titre
//      │      ├── Sous-titre
//      │      ├── Bouton retour
//      │      └── Navigation
//      │
//      └── SafeArea
//             └── contenu responsive
//
// ============================================================================
//
// RESPONSABILITÉS
//
// GlassScaffold centralise :
//
// - Scaffold
// - GlassBackground
// - UniversalAppBar
// - bouton retour
// - titre
// - sous-titre
// - logo
// - gradient AppBar
// - SafeArea
// - responsive global
// - scroll vertical
// - largeur maximale
// - padding global
//
// Les pages n'ont plus besoin de gérer ces éléments.
//
// Exemple :
//
// GlassScaffold(
//   title: 'Control Panel',
//   subtitle: 'GLASS CONTROLS',
//   showBackButton: true,
//   child: Column(
//     children: [...],
//   ),
// )
//
// ============================================================================

class GlassScaffold extends StatelessWidget {
  // ==========================================================================
  // CONTENU
  // ==========================================================================

  final Widget child;

  // ==========================================================================
  // APP BAR
  // ==========================================================================

  final String? title;

  final String? subtitle;

  final bool showLogo;

  final bool showBackButton;

  final bool useGradientBackground;

  final bool compactMode;

  final bool forceMobileLayout;

  final bool hideNavigation;

  final List<Widget>? actions;

  // ==========================================================================
  // RESPONSIVE
  // ==========================================================================

  final double maxWidth;

  final EdgeInsetsGeometry? padding;

  final bool enableScroll;

  // ==========================================================================
  // CONSTRUCTEUR
  // ==========================================================================

  const GlassScaffold({
    super.key,

    required this.child,

    this.title,

    this.subtitle,

    this.showLogo = true,

    this.showBackButton = false,

    this.useGradientBackground = false,

    this.compactMode = false,

    this.forceMobileLayout = false,

    this.hideNavigation = true,

    this.actions,

    this.maxWidth = 1100,

    this.padding,

    this.enableScroll = true,
  });

  // ==========================================================================
  // BUILD
  // ==========================================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,

      // ========================================================================
      // UNIVERSAL APP BAR
      // ========================================================================
      appBar: UniversalAppBar(
        title: title,

        subtitle: subtitle,

        showLogo: showLogo,

        showBackButton: showBackButton,

        useGradientBackground: useGradientBackground,

        compactMode: compactMode,

        forceMobileLayout: forceMobileLayout,

        hideNavigation: hideNavigation,

        actions: actions,
      ),

      // ========================================================================
      // BODY
      // ========================================================================
      body: Stack(
        children: [
          // ======================================================================
          // BACKGROUND GLASS
          // ======================================================================
          const GlassBackground(),

          // ======================================================================
          // CONTENU
          // ======================================================================
          SafeArea(
            top: false,

            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final double width = constraints.maxWidth;

                // ==================================================================
                // RESPONSIVE
                // ==================================================================

                final bool compact = width < 600;

                // ==================================================================
                // PADDING
                // ==================================================================

                final EdgeInsetsGeometry contentPadding =
                    padding ??
                    EdgeInsets.symmetric(
                      horizontal: compact ? 18 : 32,

                      vertical: compact ? 18 : 20,
                    );

                // ==================================================================
                // CONTENU
                // ==================================================================

                Widget content = Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: maxWidth),

                    child: child,
                  ),
                );

                // ==================================================================
                // SCROLL
                // ==================================================================

                if (enableScroll) {
                  content = SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),

                    padding: contentPadding,

                    child: content,
                  );
                } else {
                  content = Padding(padding: contentPadding, child: content);
                }

                return content;
              },
            ),
          ),
        ],
      ),
    );
  }
}
