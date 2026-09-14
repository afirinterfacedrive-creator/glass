import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:universal_glass/glass.dart';
import 'package:universal_glass_example/routes/app_router.dart';
import 'package:universal_glass_example/settings/widgets/appearance/appearance_profiles_provider.dart';

import 'home_widgets_exports.dart';

// ============================================================================
// HOME PAGE
// ============================================================================
//
// IMPORTANT :
//
// HomePage crée GlassScaffold.
//
// Elle ne peut donc PAS utiliser :
//
//     context.glassLayout
//
// directement dans son propre build().
//
// Le GlassLayoutScope est créé à l'intérieur de GlassScaffold.
//
// La lecture de GlassLayoutContext est donc déléguée à
// _HomePageContent, qui se trouve sous GlassScaffold.
// ============================================================================

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

// ============================================================================
// HOME PAGE STATE
// ============================================================================

class _HomePageState extends ConsumerState<HomePage> {
  bool _isBreakerOn = false;
  bool _glow = true;
  bool _aqua = false;

  @override
  Widget build(BuildContext context) {
    final GlassThemeState theme = ref.watch(glassThemeProvider);

    // =========================================================================
    // IMPORTANT
    // =========================================================================
    //
    // Aucun context.glassLayout ici.
    //
    // GlassLayoutScope n'existe qu'à l'intérieur de GlassScaffold.
    //
    // =========================================================================

    return GlassScaffold(
      // =======================================================================
      // APP BAR
      // =======================================================================
      title: 'Glass',

      subtitle: 'CONTROL CENTER',

      showLogo: true,

      showBackButton: false,

      blur: 0.0,

      noise: theme.effectiveNoise,

      compactMode: false,

      hideNavigation: true,

      actions: [HomeThemeIndicator(theme: theme)],

      // =======================================================================
      // AFFICHAGE
      // =======================================================================
      maxWidth: 1200.0,

      enableScroll: true,

      // =========================================================================
      // CONTENU
      // =========================================================================
      //
      // _HomePageContent est construit sous :
      //
      // GlassScaleScope
      //       ↓
      // GlassLayoutScope
      //       ↓
      // _HomePageContent
      //
      // Il peut donc utiliser context.glassLayout.
      //
      // =========================================================================
      child: _HomePageContent(
        theme: theme,
        glow: _glow,
        aqua: _aqua,
        breakerOn: _isBreakerOn,
        onGlowChanged: (bool value) {
          setState(() {
            _glow = value;
          });
        },
        onAquaChanged: (bool value) {
          setState(() {
            _aqua = value;
          });
        },
        onBreakerChanged: (bool value) {
          setState(() {
            _isBreakerOn = value;
          });
        },
      ),
    );
  }
}

// ============================================================================
// HOME PAGE CONTENT
// ============================================================================
//
// Ce widget est volontairement séparé de HomePage.
//
// Il est construit par GlassScaffold et se trouve donc sous GlassLayoutScope.
//
// C'est ici que le responsive centralisé doit être utilisé.
// ============================================================================

class _HomePageContent extends ConsumerWidget { // <- 1. Passe en ConsumerWidget
  final GlassThemeState theme;
  final bool glow;
  final bool aqua;
  final bool breakerOn;

  final ValueChanged<bool> onGlowChanged;
  final ValueChanged<bool> onAquaChanged;
  final ValueChanged<bool> onBreakerChanged;

  const _HomePageContent({
    required this.theme,
    required this.glow,
    required this.aqua,
    required this.breakerOn,
    required this.onGlowChanged,
    required this.onAquaChanged,
    required this.onBreakerChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) { // <- 2. Ajoute WidgetRef
    final layout = context.glassLayout;
    
    // 3. Récupère les settings globaux
    final appearance = ref.watch(appearanceProfilesProvider).aqua;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const HomeWelcomeCard(),
        SizedBox(height: layout.spacing(28.0)),

        Wrap(
          spacing: layout.spacing(8.0),
          runSpacing: layout.spacing(8.0),
          children: [
            GlassPreviewSwitch(height: layout.controlHeight(45.0), label: 'Glow', value: glow, onChanged: onGlowChanged),
            GlassPreviewToggle(height: layout.controlHeight(45.0), label: 'Aqua', value: aqua, onChanged: onAquaChanged),
            GlassPreviewBreaker(height: layout.controlHeight(45.0), label: 'Breaker', value: breakerOn, onChanged: onBreakerChanged),
          ],
        ),

        SizedBox(height: layout.spacing(28.0)),

        GlassResponsiveGrid(
          spacing: layout.spacing(24.0),
          runSpacing: layout.spacing(24.0),
          mobileColumns: 1,
          tabletColumns: 1,
          desktopColumns: 2,
          children: [
            const UniversalGlassHomePreview(),

            // ------------------------------------------------------------------
            // PHONE INPUT - ICI LE FIX
            // ------------------------------------------------------------------
            _noScroll(
              HomePhoneInputPreview(
                phoneController: AppRouter.sharedPhoneController,
                settings: appearance, // <- 4. AJOUTE CA
                useAquaStyle: aqua,
              ),
            ),

            const UniversalGlassTextBoxView(),
            const HomeUniversalGlassTextFieldView(),
            _noScroll(const HomeSearchInputPreview()),
            const HomeConfirmDialogPreview(),
          ],
        ),

        SizedBox(height: layout.spacing(28.0)),
        const HomeQuickAccess(),
        SizedBox(height: layout.spacing(28.0)),
        const SystemSection(),
        SizedBox(height: layout.spacing(30.0)),
      ],
    );
  }

  Widget _noScroll(Widget child) {
    return NotificationListener<ScrollNotification>(
      onNotification: (_) => true,
      child: child,
    );
  }
}