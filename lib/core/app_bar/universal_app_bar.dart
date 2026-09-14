
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:universal_glass/constants/app_constants.dart';

import 'package:universal_glass/core/app_bar/universal_app_bar_content.dart';
import 'package:universal_glass/core/app_bar/universal_app_bar_decorator.dart';
import 'package:universal_glass/core/app_bar/universal_tab_item.dart';
import 'package:universal_glass/core/layout/glass_layout_extensions.dart';
import 'package:universal_glass/provider/glass_theme_provider.dart';
import 'package:universal_glass/provider/glass_theme_state.dart';

/// ============================================================================
/// UNIVERSAL APP BAR
/// ============================================================================
///
/// Construit uniquement le contenu de l'AppBar.
///
/// IMPORTANT :
///
/// UniversalAppBar NE crée PAS de GlassSurfaceContainer.
///
/// La surface visible de l'AppBar est créée par GlassScaffold.
///
/// Architecture :
///
/// GlassScaffold
///      │
///      └── GlassSurfaceContainer
///                │
///                └── UniversalAppBar
///                          │
///                          └── UniversalAppBarDecorator
///                                    │
///                                    └── UniversalAppBarContent
///
/// Cela garantit qu'il n'y a qu'une seule surface Glass pour l'AppBar.
///
/// Les paramètres visuels de l'AppBar restent génériques et optionnels.
/// Ils permettent notamment à une application de connecter ses propres
/// réglages d'apparence sans imposer de modèle de settings au package.
///
class UniversalAppBar extends ConsumerWidget
    implements PreferredSizeWidget {
  // ==========================================================================
  // OPTIONS GÉNÉRALES
  // ==========================================================================

  final bool showLogo;

  final String? title;

  final String? subtitle;

  final bool showBackButton;

  final VoidCallback? onBack;

  final List<Widget>? actions;

  final List<UniversalTabItem>? tabs;

  final bool hideNavigation;

  /// Conservé pour compatibilité avec l'API existante.
  ///
  /// La gestion réelle du fond est effectuée par GlassScaffold.
  final bool useGradientBackground;

  final bool compactMode;

  // ==========================================================================
  // HAUTEUR EXTERNE
  // ==========================================================================

  /// Lorsque GlassScaffold fournit cette valeur, UniversalAppBar utilise
  /// exactement cette hauteur.
  ///
  /// Cela évite que GlassScaffold et UniversalAppBar calculent chacun une
  /// hauteur différente.
  final double? height;

  // ==========================================================================
  // STYLE DES BOUTONS D'ACTION
  // ==========================================================================

  /// Opacité du fond blanc des boutons d'action.
  ///
  /// Si null, utilise [AppConstants.appBarDefaultActionBackgroundOpacity].
  final double? actionBackgroundOpacity;

  /// Opacité de la teinte d'accent dans le fond des boutons d'action.
  ///
  /// Si null, utilise [AppConstants.appBarDefaultActionAccentOpacity].
  final double? actionAccentOpacity;

  /// Opacité de la bordure des boutons d'action.
  ///
  /// Si null, utilise [AppConstants.appBarDefaultActionBorderOpacity].
  final double? actionBorderOpacity;

  /// Épaisseur de la bordure des boutons d'action.
  ///
  /// Si null, utilise [AppConstants.appBarDefaultActionBorderWidth].
  final double? actionBorderWidth;

  /// Opacité de l'ombre des boutons d'action.
  ///
  /// Si null, utilise [AppConstants.appBarDefaultActionShadowOpacity].
  final double? actionShadowOpacity;

  /// Flou de l'ombre des boutons d'action.
  ///
  /// Si null, utilise [AppConstants.appBarDefaultActionShadowBlur].
  final double? actionShadowBlur;

  /// Décalage vertical de l'ombre des boutons d'action.
  ///
  /// Si null, utilise [AppConstants.appBarDefaultActionShadowOffsetY].
  final double? actionShadowOffsetY;

  /// Opacité de l'ombre générale de l'AppBar.
  ///
  /// Si null :
  /// - grand desktop : [AppConstants.appBarDefaultShadowOpacity]
  /// - autres formats : [AppConstants.appBarDefaultNormalShadowOpacity]
  final double? shadowOpacity;

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
    this.useGradientBackground = true,
    this.compactMode = false,
    this.height,
    this.actionBackgroundOpacity,
    this.actionAccentOpacity,
    this.actionBorderOpacity,
    this.actionBorderWidth,
    this.actionShadowOpacity,
    this.actionShadowBlur,
    this.actionShadowOffsetY,
    this.shadowOpacity,
  });

  // ==========================================================================
  // HAUTEUR RESPONSIVE
  // ==========================================================================

  static double getAppBarHeight(
    double width,
  ) {
    if (width >= 1600.0) {
      return 100.0;
    }

    if (width >= 1200.0) {
      return 90.0;
    }

    if (width >= 950.0) {
      return 80.0;
    }

    return kToolbarHeight;
  }

  // ==========================================================================
  // PREFERRED SIZE
  // ==========================================================================

  @override
  Size get preferredSize {
    // ------------------------------------------------------------------------
    // Si GlassScaffold fournit explicitement la hauteur, elle devient la
    // source de vérité.
    // ------------------------------------------------------------------------

    if (height != null && height!.isFinite) {
      return Size.fromHeight(
        height!
            .clamp(
              AppConstants.minAppBarHeight,
              AppConstants.maxAppBarHeight,
            )
            .toDouble(),
      );
    }

    // ------------------------------------------------------------------------
    // Fallback : comportement historique.
    // ------------------------------------------------------------------------

    final Iterable<FlutterView> views =
        WidgetsBinding.instance.platformDispatcher.views;

    if (views.isEmpty) {
      return Size.fromHeight(
        AppConstants.minAppBarHeight,
      );
    }

    final FlutterView view = views.first;

    final double devicePixelRatio = view.devicePixelRatio;

    if (devicePixelRatio <= 0.0) {
      return Size.fromHeight(
        AppConstants.minAppBarHeight,
      );
    }

    final double width =
        view.physicalSize.width / devicePixelRatio;

    final double calculatedHeight =
        compactMode
            ? AppConstants.minAppBarHeight
            : getAppBarHeight(width);

    return Size.fromHeight(
      calculatedHeight.clamp(
        AppConstants.minAppBarHeight,
        AppConstants.maxAppBarHeight,
      ),
    );
  }

  // ==========================================================================
  // NORMALISATION
  // ==========================================================================

  double _normalizeOpacity(
    double? value,
    double fallback,
  ) {
    return (value ?? fallback).clamp(
      AppConstants.minBorderOpacity,
      AppConstants.maxBorderOpacity,
    );
  }

  double _normalizeBorderWidth(
    double? value,
  ) {
    return (value ?? AppConstants.appBarDefaultActionBorderWidth).clamp(
      AppConstants.minAppBarActionBorderWidth,
      AppConstants.maxAppBarActionBorderWidth,
    );
  }

  double _normalizeShadowBlur(
    double? value,
  ) {
    return (value ?? AppConstants.appBarDefaultActionShadowBlur).clamp(
      AppConstants.minAppBarActionShadowBlur,
      AppConstants.maxAppBarActionShadowBlur,
    );
  }

  double _normalizeShadowOffsetY(
    double? value,
  ) {
    return (value ?? AppConstants.appBarDefaultActionShadowOffsetY).clamp(
      AppConstants.minAppBarActionShadowOffsetY,
      AppConstants.maxAppBarActionShadowOffsetY,
    );
  }

  // ==========================================================================
  // BUILD
  // ==========================================================================

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    // =========================================================================
    // THEME
    // =========================================================================

    final GlassThemeState glassTheme =
        ref.watch(glassThemeProvider);

    final ThemeData theme =
        Theme.of(context);

    // =========================================================================
    // LAYOUT CENTRAL
    // =========================================================================

    final layout =
        context.glassLayout;

    // =========================================================================
    // HAUTEUR
    // =========================================================================
    //
    // PRIORITÉ :
    //
    // 1. hauteur fournie par GlassScaffold
    // 2. compactMode
    // 3. calcul responsive historique
    //
    // =========================================================================

    final double appBarHeight =
        height != null && height!.isFinite
            ? height!.clamp(
                AppConstants.minAppBarHeight,
                AppConstants.maxAppBarHeight,
              ).toDouble()
            : (
                compactMode
                    ? AppConstants.minAppBarHeight
                    : getAppBarHeight(
                        layout.screenWidth,
                      )
              );

    // =========================================================================
    // COULEURS
    // =========================================================================

    final Color accentColor =
        glassTheme.useAquaStyle
            ? AppConstants.aquaAccent
            : AppConstants.classicAccent;

    final Color iconColor =
        glassTheme.useAquaStyle
            ? AppConstants.aquaAccent
            : AppConstants.white;

    // =========================================================================
    // VALEURS D'ACTION
    // =========================================================================

    final double effectiveActionBackgroundOpacity =
        _normalizeOpacity(
      actionBackgroundOpacity,
      AppConstants.appBarDefaultActionBackgroundOpacity,
    );

    final double effectiveActionAccentOpacity =
        _normalizeOpacity(
      actionAccentOpacity,
      AppConstants.appBarDefaultActionAccentOpacity,
    );

    final double effectiveActionBorderOpacity =
        _normalizeOpacity(
      actionBorderOpacity,
      AppConstants.appBarDefaultActionBorderOpacity,
    );

    final double effectiveActionBorderWidth =
        _normalizeBorderWidth(
      actionBorderWidth,
    );

    final double effectiveActionShadowOpacity =
        _normalizeOpacity(
      actionShadowOpacity,
      AppConstants.appBarDefaultActionShadowOpacity,
    );

    final double effectiveActionShadowBlur =
        _normalizeShadowBlur(
      actionShadowBlur,
    );

    final double effectiveActionShadowOffsetY =
        _normalizeShadowOffsetY(
      actionShadowOffsetY,
    );

    // =========================================================================
    // OMBRE GÉNÉRALE DE L'APP BAR
    // =========================================================================

    final double effectiveShadowOpacity =
        _normalizeOpacity(
      shadowOpacity,
      layout.isLargeDesktop
          ? AppConstants.appBarDefaultShadowOpacity
          : AppConstants.appBarDefaultNormalShadowOpacity,
    );

    // =========================================================================
    // BOUTONS D'ACTION
    // =========================================================================

    final BoxDecoration actionDecoration =
        BoxDecoration(
      shape: BoxShape.circle,

      gradient: LinearGradient(
        begin: AppConstants.gradientBegin,
        end: AppConstants.gradientEnd,
        colors: [
          AppConstants.white.withValues(
            alpha: effectiveActionBackgroundOpacity,
          ),
          accentColor.withValues(
            alpha: effectiveActionAccentOpacity,
          ),
        ],
      ),

      border: Border.all(
        color: AppConstants.white.withValues(
          alpha: effectiveActionBorderOpacity,
        ),
        width: effectiveActionBorderWidth,
      ),

      boxShadow: [
        BoxShadow(
          color: accentColor.withValues(
            alpha: effectiveActionShadowOpacity,
          ),
          blurRadius: effectiveActionShadowBlur,
          spreadRadius: AppConstants.transparentOpacity,
          offset: Offset(
            AppConstants.transparentOpacity,
            effectiveActionShadowOffsetY,
          ),
        ),
      ],
    );

    // =========================================================================
    // ROUTE
    // =========================================================================

    final String currentRoute =
        ModalRoute.of(context)?.settings.name ?? '';

    // =========================================================================
    // NAVIGATION
    // =========================================================================

    final List<UniversalTabItem> activeTabs =
        hideNavigation
            ? const <UniversalTabItem>[]
            : (
                tabs ??
                const <UniversalTabItem>[]
              );

    // =========================================================================
    // OMBRE APP BAR
    // =========================================================================

    final Color appBarShadowColor =
        AppConstants.black.withValues(
      alpha: effectiveShadowOpacity,
    );

    // =========================================================================
    // CONTENU
    // =========================================================================
    //
    // Aucun GlassSurfaceContainer ici.
    //
    // La surface est fournie par GlassScaffold.
    //
    // =========================================================================

    return UniversalAppBarDecorator(
      height: appBarHeight,
      backgroundDecoration:
          const BoxDecoration(),
      child: UniversalAppBarContent(
        title: title,
        subtitle: subtitle,
        showLogo: showLogo,
        showBackButton: showBackButton,
        onBack: onBack,
        actions: actions,
        tabs: activeTabs,
        currentRoute: currentRoute,
        appBarHeight: appBarHeight,
        theme: theme,
        iconColor: iconColor,
        accentColor: accentColor,
        shadowColor: appBarShadowColor,
        actionDecoration: actionDecoration,
      ),
    );
  }
}
