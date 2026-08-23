import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:universal_glass/core/app_bar/universal_app_bar_content.dart';
import 'package:universal_glass/core/app_bar/universal_app_bar_decorator.dart';
import 'package:universal_glass/core/app_bar/universal_tab_item.dart';
import 'package:universal_glass/provider/glass_theme_provider.dart';

// ============================================================================
// UNIVERSAL APP BAR
// ============================================================================
//
// AppBar générique du projet.
//
// RESPONSABILITÉS
//
// - Responsive mobile / tablette / desktop / TV
// - Gestion du thème Glass
// - Logo
// - Titre
// - Sous-titre
// - Bouton retour
// - Actions personnalisées
// - Onglets
// - Route active
// - Mode compact
// - Masquage navigation
// - Décoration Glass
//
// IMPORTANT
//
// Le rendu visuel est volontairement indépendant des différences de thème
// entre Windows, Chrome et les autres plateformes.
//
// L'objectif est d'obtenir le même rendu Glass doux sur toutes les plateformes.
//
// ============================================================================

class UniversalAppBar extends ConsumerWidget implements PreferredSizeWidget {
  // ==========================================================================
  // IDENTITÉ
  // ==========================================================================

  final bool showLogo;
  final String? title;
  final String? subtitle;

  // ==========================================================================
  // RETOUR
  // ==========================================================================

  final bool showBackButton;
  final VoidCallback? onBack;

  // ==========================================================================
  // ACTIONS
  // ==========================================================================

  final List<Widget>? actions;

  // ==========================================================================
  // NAVIGATION
  // ==========================================================================

  final List<UniversalTabItem>? tabs;
  final bool hideNavigation;

  // ==========================================================================
  // APPARENCE
  // ==========================================================================

  final bool useGradientBackground;

  // ==========================================================================
  // RESPONSIVE
  // ==========================================================================

  /// Force une hauteur compacte.
  final bool compactMode;

  /// Empêche l'AppBar de passer en mode desktop / TV.
  final bool forceMobileLayout;

  // ==========================================================================
  // CONSTRUCTEUR
  // ==========================================================================

  const UniversalAppBar({
    super.key,
    this.showLogo = true,
    this.title,
    this.subtitle,
    this.showBackButton = false,
    this.onBack,
    this.actions,
    this.tabs,
    this.hideNavigation = false,
    this.useGradientBackground = false,
    this.compactMode = false,
    this.forceMobileLayout = false,
  });

  // ==========================================================================
  // HAUTEUR RESPONSIVE
  // ==========================================================================

  static double getAppBarHeight(double width) {
    if (width >= 1600) {
      return 100.0;
    }

    if (width >= 1200) {
      return 90.0;
    }

    if (width >= 950) {
      return 80.0;
    }

    return kToolbarHeight;
  }

  // ==========================================================================
  // SCALE RESPONSIVE
  // ==========================================================================

  static double getScale(double width) {
    if (width >= 1600) {
      return 1.70;
    }

    if (width >= 1400) {
      return 1.50;
    }

    if (width >= 1200) {
      return 1.30;
    }

    if (width >= 950) {
      return 1.15;
    }

    if (width >= 600) {
      return 1.00;
    }

    return 0.90;
  }

  // ==========================================================================
  // LARGEUR DE LA VUE
  // ==========================================================================

  static double getCurrentViewWidth() {
    final views = WidgetsBinding.instance.platformDispatcher.views;

    if (views.isEmpty) {
      return 0.0;
    }

    final FlutterView view = views.first;

    final double devicePixelRatio = view.devicePixelRatio;

    if (devicePixelRatio <= 0) {
      return 0.0;
    }

    return view.physicalSize.width / devicePixelRatio;
  }

  // ==========================================================================
  // PREFERRED SIZE
  // ==========================================================================

  @override
  Size get preferredSize {
    final double width = getCurrentViewWidth();

    final double height = compactMode
        ? kToolbarHeight
        : getAppBarHeight(width);

    return Size.fromHeight(height);
  }

  // ==========================================================================
  // BUILD
  // ==========================================================================

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ========================================================================
    // THÈME GLASS
    // ========================================================================

    final GlassThemeState glassTheme = ref.watch(glassThemeProvider);

    final ThemeData theme = Theme.of(context);

    // ========================================================================
    // LARGEUR
    // ========================================================================

    final double screenWidth = MediaQuery.sizeOf(context).width;

    // ========================================================================
    // RESPONSIVE
    // ========================================================================

    final double appBarHeight = compactMode
        ? kToolbarHeight
        : getAppBarHeight(screenWidth);

    final double scale = compactMode
        ? 0.90
        : getScale(screenWidth);

    final bool isTv =
        !forceMobileLayout && screenWidth >= 1600;

    final bool isDesktop =
        !forceMobileLayout && screenWidth >= 950;

    final bool isTablet =
        !forceMobileLayout &&
        screenWidth >= 600 &&
        screenWidth < 950;

    // ========================================================================
    // COULEUR D'ACCENT
    // ========================================================================

    final Color accentColor = glassTheme.useAquaStyle
        ? Colors.cyanAccent
        : Colors.orangeAccent;

    // =========================================================================
    // PALETTE GLASS UNIFORMISÉE
    // =========================================================================
    //
    // IMPORTANT :
    //
    // On évite volontairement les couleurs provenant de ColorScheme pour le
    // fond principal de l'AppBar.
    //
    // Windows et Chrome peuvent avoir des ColorScheme différents.
    //
    // En utilisant directement les mêmes valeurs Glass, le rendu reste
    // beaucoup plus proche entre les plateformes.
    //
    // =========================================================================

    final Color glassColor = glassTheme.useAquaStyle
        ? Colors.black.withValues(alpha: 0.20)
        : Colors.black.withValues(alpha: 0.28);

    final Color borderColor = glassTheme.useAquaStyle
        ? Colors.white.withValues(alpha: 0.20)
        : Colors.white.withValues(alpha: 0.15);

    final Color iconColor = glassTheme.useAquaStyle
        ? Colors.cyanAccent
        : Colors.white;

    // =========================================================================
    // DÉCORATION DES ACTIONS
    // =========================================================================

    final BoxDecoration actionDecoration = BoxDecoration(
      shape: BoxShape.circle,

      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withValues(alpha: 0.14),
          accentColor.withValues(alpha: 0.07),
        ],
      ),

      border: Border.all(
        color: borderColor,
        width: 0.8,
      ),

      // Ombre très légère.
      //
      // L'objectif est d'éviter l'aspect "bouton sombre" de Windows tout en
      // conservant une petite profondeur Glass.
      boxShadow: [
        BoxShadow(
          color: accentColor.withValues(alpha: 0.06),
          blurRadius: 8,
          spreadRadius: 0,
          offset: const Offset(0, 1),
        ),
      ],
    );

    // =========================================================================
    // DÉCORATION DE L'APP BAR
    // =========================================================================
    //
    // Rendu volontairement doux.
    //
    // Chrome donne naturellement une impression plus légère avec les
    // transparences. On reproduit cette sensation avec une base moins opaque
    // plutôt que de laisser Windows assombrir visuellement la surface.
    //
    // =========================================================================

    final BoxDecoration appBarDecoration;

    if (useGradientBackground) {
      appBarDecoration = BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.black.withValues(alpha: 0.30),
            accentColor.withValues(alpha: 0.07),
            Colors.black.withValues(alpha: 0.24),
          ],
        ),

        border: Border(
          bottom: BorderSide(
            color: borderColor,
            width: 1,
          ),
        ),
      );
    } else {
      appBarDecoration = BoxDecoration(
        color: glassColor,

        border: Border(
          bottom: BorderSide(
            color: borderColor,
            width: 1,
          ),
        ),
      );
    }

    // =========================================================================
    // ROUTE COURANTE
    // =========================================================================

    final String currentRoute =
        ModalRoute.of(context)?.settings.name ?? '';

    // =========================================================================
    // ONGLETS ACTIFS
    // =========================================================================

    final List<UniversalTabItem> activeTabs = hideNavigation
        ? const []
        : (tabs ?? const []);

    // =========================================================================
    // OMBRE APP BAR
    // =========================================================================
    //
    // IMPORTANT :
    //
    // On ne prend plus Theme.of(context).colorScheme.shadow.
    //
    // Cette couleur peut varier entre Windows et Chrome et était notamment
    // responsable d'une partie de la différence visuelle constatée.
    //
    // =========================================================================

    final Color appBarShadowColor =
        Colors.black.withValues(
          alpha: isTv ? 0.10 : 0.045,
        );

    // =========================================================================
    // DÉCORATEUR
    // =========================================================================

    return UniversalAppBarDecorator(
      height: appBarHeight,

      backgroundDecoration: appBarDecoration,

      useGradientBackground: useGradientBackground,

      child: UniversalAppBarContent(
        // ====================================================================
        // IDENTITÉ
        // ====================================================================

        title: title,

        subtitle: subtitle,

        showLogo: showLogo,

        // ====================================================================
        // RETOUR
        // ====================================================================

        showBackButton: showBackButton,

        onBack: onBack,

        // ====================================================================
        // ACTIONS
        // ====================================================================

        actions: actions,

        // ====================================================================
        // NAVIGATION
        // ====================================================================

        tabs: activeTabs,

        currentRoute: currentRoute,

        // ====================================================================
        // RESPONSIVE
        // ====================================================================

        isTv: isTv,

        isDesktop: isDesktop,

        isTablet: isTablet,

        scale: scale,

        appBarHeight: appBarHeight,

        // ====================================================================
        // THÈME
        // ====================================================================

        theme: theme,

        iconColor: iconColor,

        accentColor: accentColor,

        // ====================================================================
        // OMBRE
        // ====================================================================

        shadowColor: appBarShadowColor,

        // ====================================================================
        // ACTIONS
        // ====================================================================

        actionDecoration: actionDecoration,
      ),
    );
  }
}

