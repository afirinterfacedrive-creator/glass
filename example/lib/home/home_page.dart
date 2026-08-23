import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glass/glass.dart';

import 'home_widgets_exports.dart';

// ============================================================================
// HOME PAGE
// ============================================================================
//
// Page d'accueil principale.
//
// ARCHITECTURE
//
// GlassBackground
//       │
//       └── HomePage
//             │
//             ├── UniversalAppBar
//             │      └── HomeThemeIndicator
//             │
//             └── Body
//                    │
//                    ├── HomeWelcomeCard
//                    │
//                    ├── HomeQuickAccess
//                    │      └── HomeActionCard
//                    │
//                    └── SystemSection
//                           └── StatusCard
//
// ============================================================================
//
// RESPONSABILITÉS
//
// HomePage gère uniquement :
//
// - le thème global
// - UniversalAppBar
// - GlassBackground
// - responsive global
// - disposition des sections
//
// ============================================================================

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // =========================================================================
    // THÈME GLASS
    // =========================================================================

    final GlassThemeState theme = ref.watch(glassThemeProvider);

    // =========================================================================
    // PAGE
    // =========================================================================

    return Scaffold(
      backgroundColor: Colors.transparent,

      // =======================================================================
      // UNIVERSAL APP BAR
      // =======================================================================
      appBar: UniversalAppBar(
        showLogo: true,
        title: 'Glass',
        subtitle: 'CONTROL CENTER',
        showBackButton: false,
        useGradientBackground: theme.useAquaStyle,
        compactMode: false,
        forceMobileLayout: false,
        hideNavigation: true,
        actions: [HomeThemeIndicator(theme: theme)],
      ),

      // =======================================================================
      // BODY
      // =======================================================================
      body: Stack(
        children: [
          // ===================================================================
          // BACKGROUND GLOBAL
          // ===================================================================
          const GlassBackground(),

          // ===================================================================
          // CONTENU
          // ===================================================================
          SafeArea(
            top: false,
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                // ===============================================================
                // RESPONSIVE
                // ===============================================================

                final bool isCompact = constraints.maxWidth < 600;

                // ===============================================================
                // SCROLL
                // ===============================================================

                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: isCompact ? 18 : 32,
                    vertical: 20,
                  ),

                  // =============================================================
                  // LARGEUR MAXIMALE
                  // =============================================================
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1100),

                      // ===========================================================
                      // SECTIONS
                      // ===========================================================
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // =====================================================
                          // WELCOME
                          // =====================================================
                          HomeWelcomeCard(theme: theme, compact: isCompact),

                          const SizedBox(height: 28),

                          // =====================================================
                          // QUICK ACCESS
                          // =====================================================
                          HomeQuickAccess(theme: theme),

                          const SizedBox(height: 28),

                          // =====================================================
                          // SYSTEM
                          // =====================================================
                          SystemSection(theme: theme),

                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
