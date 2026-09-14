
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:universal_glass/components/surface/glass_surface_container.dart';
import 'package:universal_glass/core/app_bar/universal_app_bar.dart';
import 'package:universal_glass/core/layout/glass_layout_extensions.dart';
import 'package:universal_glass/core/layout/glass_layout_scope.dart';
import 'package:universal_glass/enums/glass_enums.dart';
import 'package:universal_glass/provider/glass_theme_provider.dart';
import 'package:universal_glass/provider/glass_theme_state.dart';
import 'package:universal_glass/theme/glass_effects.dart';
import 'package:universal_glass/theme/glass_scale_engine.dart';
import 'package:universal_glass/theme/glass_scale_scope.dart';

import 'glass_background.dart';

/// ============================================================================
/// GLASS SCAFFOLD
/// ============================================================================
///
/// Scaffold principal de Universal Glass.
///
/// Architecture :
///
/// GlassScaffold
///   └── GlassScaleScope
///        └── GlassLayoutScope
///             └── _GlassScaffoldContent
///                  └── Scaffold
///                       ├── GlassSurfaceContainer
///                       │    └── UniversalAppBar
///                       └── Body
///
///
/// RESPONSABILITÉS
/// ============================================================================
///
/// GlassScaleScope
///     → zoom global
///
/// GlassLayoutScope
///     → responsive
///     → breakpoints
///     → densité
///     → paddings
///     → largeur maximale
///     → GlassStyle effectif
///
/// GlassScaffold
///     → structure générale
///     → AppBar
///     → background
///     → scroll
///
/// GlassSurfaceContainer
///     → surface visuelle
///
/// GlassSurfaceRenderer
///     → style
///     → gradient
///     → bordure
///     → ombre
///     → glow
///     → opacité
///     → rendu
///
/// GlassSurfaceGradient
///     → résolution du gradient
///
/// UniversalAppBar
///     → contenu visuel de l'AppBar uniquement
///
///
/// IMPORTANT
/// ============================================================================
///
/// GlassScaffold NE possède volontairement plus :
///
///     - appBarGradient
///     - useCustomGradient
///     - customGradientKey
///
/// Le style de l'AppBar provient exclusivement du système global.
///
/// Exemple :
///
///     gradientOpaque
///         ↓
///     opaqueMat
///
/// L'AppBar suit automatiquement.
///
/// Même chose pour tous les autres GlassStyle.
class GlassScaffold extends ConsumerWidget {
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

  /// Active ou désactive complètement l'AppBar.
  ///
  /// Cette propriété est distincte de [hideNavigation].
  ///
  /// [appBarEnabled]
  ///     → contrôle la présence de l'AppBar.
  ///
  /// [hideNavigation]
  ///     → contrôle uniquement la navigation interne de l'AppBar.
  final bool appBarEnabled;

  /// Indique éventuellement au contenu de l'AppBar qu'un rendu gradient
  /// est souhaité.
  ///
  /// IMPORTANT :
  ///
  /// Cette propriété ne choisit PAS le GlassStyle.
  ///
  /// Le GlassStyle réel provient toujours de :
  ///
  ///     context.glassLayout.effectiveGlassStyle
  ///
  /// Cette propriété est conservée pour compatibilité avec
  /// [UniversalAppBar].
  final bool? useGradientBackground;

  /// Mode compact de l'AppBar.
  ///
  /// `null` signifie que le comportement par défaut est utilisé.
  ///
  /// Une valeur explicite permet à l'appelant de forcer le mode compact
  /// ou non compact.
  final bool? compactMode;

  /// Hauteur personnalisée de l'AppBar.
  ///
  /// Si `null`, la hauteur responsive automatique est utilisée.
  ///
  /// La valeur est automatiquement limitée entre [kToolbarHeight]
  /// et `200.0`.
  final double? appBarHeight;

  final bool hideNavigation;

  final List<Widget>? actions;

  // ==========================================================================
  // APP BAR APPEARANCE
  // ==========================================================================

  /// Opacité du fond des actions de l'AppBar.
  ///
  /// Si `null`, [UniversalAppBar] utilise sa valeur par défaut.
  final double? actionBackgroundOpacity;

  /// Opacité de l'accent des actions de l'AppBar.
  ///
  /// Si `null`, [UniversalAppBar] utilise sa valeur par défaut.
  final double? actionAccentOpacity;

  /// Opacité de la bordure des actions de l'AppBar.
  ///
  /// Si `null`, [UniversalAppBar] utilise sa valeur par défaut.
  final double? actionBorderOpacity;

  /// Largeur de la bordure des actions de l'AppBar.
  ///
  /// Si `null`, [UniversalAppBar] utilise sa valeur par défaut.
  final double? actionBorderWidth;

  /// Opacité de l'ombre des actions de l'AppBar.
  ///
  /// Si `null`, [UniversalAppBar] utilise sa valeur par défaut.
  final double? actionShadowOpacity;

  /// Flou de l'ombre des actions de l'AppBar.
  ///
  /// Si `null`, [UniversalAppBar] utilise sa valeur par défaut.
  final double? actionShadowBlur;

  /// Décalage vertical de l'ombre des actions de l'AppBar.
  ///
  /// Si `null`, [UniversalAppBar] utilise sa valeur par défaut.
  final double? actionShadowOffsetY;

  /// Opacité de l'ombre générale de l'AppBar.
  ///
  /// Si `null`, [UniversalAppBar] utilise sa valeur par défaut responsive.
  final double? shadowOpacity;

  // ==========================================================================
  // AFFICHAGE
  // ==========================================================================

  /// Largeur maximale locale.
  ///
  /// Si null, utilise theme.display.maxWidth.
  final double? maxWidth;

  /// Padding complet local.
  ///
  /// Si null, utilise le padding responsive centralisé.
  final EdgeInsetsGeometry? padding;

  /// Zoom local.
  ///
  /// Si null, utilise theme.display.zoom.
  final double? zoom;

  /// Adapte automatiquement le zoom sur les petits écrans.
  final bool adaptiveZoom;

  /// Breakpoint tablette local.
  final double? tabletBreakpoint;

  /// Breakpoint desktop local.
  final double? desktopBreakpoint;

  /// Padding horizontal desktop.
  final double? desktopHorizontalPadding;

  /// Padding horizontal tablette.
  final double? tabletHorizontalPadding;

  /// Padding horizontal mobile.
  final double? mobileHorizontalPadding;

  /// Padding horizontal petit mobile.
  final double? smallMobileHorizontalPadding;

  // ==========================================================================
  // SCROLL
  // ==========================================================================

  final bool enableScroll;

  // ==========================================================================
  // APP BAR EFFECTS
  // ==========================================================================

  /// Blur de l'AppBar.
  ///
  /// Si null, utilise theme.effectiveBlur.
  final double? blur;

  /// Noise de l'AppBar.
  ///
  /// Si null, utilise theme.effectiveNoise.
  final double? noise;

  // ==========================================================================
  // CONSTRUCTEUR
  // ==========================================================================

  const GlassScaffold({
    super.key,
    required this.child,

    // AppBar
    this.title,
    this.subtitle,
    this.showLogo = true,
    this.showBackButton = false,
    this.appBarEnabled = true,
    this.useGradientBackground,
    this.compactMode,
    this.appBarHeight,
    this.hideNavigation = true,
    this.actions,

    // AppBar appearance
    this.actionBackgroundOpacity,
    this.actionAccentOpacity,
    this.actionBorderOpacity,
    this.actionBorderWidth,
    this.actionShadowOpacity,
    this.actionShadowBlur,
    this.actionShadowOffsetY,
    this.shadowOpacity,

    // Affichage
    this.maxWidth,
    this.padding,
    this.zoom,
    this.adaptiveZoom = false,
    this.tabletBreakpoint,
    this.desktopBreakpoint,
    this.desktopHorizontalPadding,
    this.tabletHorizontalPadding,
    this.mobileHorizontalPadding,
    this.smallMobileHorizontalPadding,

    // Scroll
    this.enableScroll = true,

    // AppBar effects
    this.blur,
    this.noise,
  });

  // ==========================================================================
  // BUILD
  // ==========================================================================

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    // =========================================================================
    // THÈME
    // =========================================================================

    final GlassThemeState theme =
        ref.watch(glassThemeProvider);

    final display =
        theme.display.normalized();

    // =========================================================================
    // DIMENSIONS ÉCRAN
    // =========================================================================

    final Size screenSize =
        MediaQuery.sizeOf(context);

    final double screenWidth =
        screenSize.width;

    // =========================================================================
    // BREAKPOINT TABLETTE
    // =========================================================================

    final double effectiveTabletBreakpoint =
        (tabletBreakpoint ?? display.tabletBreakpoint)
            .clamp(
              400.0,
              1200.0,
            )
            .toDouble();

    // =========================================================================
    // ADAPTATION DU ZOOM
    // =========================================================================

    final bool isVerySmallMobile =
        screenWidth < 375.0;

    final bool isMobile =
        screenWidth < effectiveTabletBreakpoint;

    double effectiveZoom =
        (zoom ?? display.zoom)
            .clamp(
              GlassScaleEngine.minScale,
              GlassScaleEngine.maxScale,
            )
            .toDouble();

    if (adaptiveZoom) {
      if (isVerySmallMobile) {
        effectiveZoom *= 0.90;
      } else if (isMobile) {
        effectiveZoom *= 0.95;
      }

      effectiveZoom =
          effectiveZoom
              .clamp(
                GlassScaleEngine.minScale,
                GlassScaleEngine.maxScale,
              )
              .toDouble();
    }

    // =========================================================================
    // EFFETS APP BAR
    // =========================================================================

    final double currentBlur =
        blur ?? theme.effectiveBlur;

    final double currentNoise =
        noise ?? theme.effectiveNoise;

    // =========================================================================
    // BODY
    // =========================================================================
    //
    // Le body ne reçoit pas le blur de l'AppBar.
    //
    const double bodyBlur = 0.0;

    // =========================================================================
    // MODE COMPACT EFFECTIF
    // =========================================================================

    final bool effectiveCompactMode =
        compactMode ?? false;

    // =========================================================================
    // HAUTEUR APP BAR
    // =========================================================================
    //
    // Priorité :
    //
    // 1. appBarHeight explicite
    // 2. compactMode
    // 3. hauteur responsive automatique
    //
    // La valeur explicite reste bornée afin d'éviter des dimensions
    // incohérentes dans le Scaffold.
    //
    // =========================================================================

    final double? normalizedAppBarHeight =
        appBarHeight != null && appBarHeight!.isFinite
            ? appBarHeight!
                .clamp(
                  kToolbarHeight,
                  200.0,
                )
                .toDouble()
            : null;

    final double effectiveAppBarHeight =
        normalizedAppBarHeight ??
        (
          effectiveCompactMode
              ? kToolbarHeight
              : UniversalAppBar.getAppBarHeight(
                  screenWidth,
                )
        );

    // =========================================================================
    // ARBRE PRINCIPAL
    // =========================================================================
    //
    // IMPORTANT :
    //
    // _GlassScaffoldContent est créé SOUS GlassLayoutScope.
    //
    // Il peut donc utiliser :
    //
    //     context.glassLayout
    //
    // Le GlassStyle effectif est résolu à cet endroit.
    //
    // =========================================================================

    return GlassScaleScope(
      scale: effectiveZoom,
      child: GlassLayoutScope(
        maxWidth: maxWidth,
        desktopBreakpoint: desktopBreakpoint,
        tabletBreakpoint: tabletBreakpoint,
        desktopPadding: desktopHorizontalPadding,
        tabletPadding: tabletHorizontalPadding,
        mobilePadding: mobileHorizontalPadding,
        smallMobilePadding:
            smallMobileHorizontalPadding,
        child: _GlassScaffoldContent(
          // ignore: sort_child_properties_last
          child: child,
          title: title,
          subtitle: subtitle,
          showLogo: showLogo,
          showBackButton: showBackButton,
          appBarEnabled: appBarEnabled,
          useGradientBackground:
              useGradientBackground,
          currentBlur: currentBlur,
          currentNoise: currentNoise,
          compactMode: effectiveCompactMode,
          hideNavigation: hideNavigation,
          actions: actions,

          // AppBar appearance
          actionBackgroundOpacity:
              actionBackgroundOpacity,
          actionAccentOpacity:
              actionAccentOpacity,
          actionBorderOpacity:
              actionBorderOpacity,
          actionBorderWidth:
              actionBorderWidth,
          actionShadowOpacity:
              actionShadowOpacity,
          actionShadowBlur:
              actionShadowBlur,
          actionShadowOffsetY:
              actionShadowOffsetY,
          shadowOpacity:
              shadowOpacity,

          padding: padding,
          enableScroll: enableScroll,
          bodyBlur: bodyBlur,
          appBarHeight: effectiveAppBarHeight,
          effectiveZoom: effectiveZoom,
        ),
      ),
    );
  }
}

// =============================================================================
// GLASS SCAFFOLD CONTENT
// =============================================================================

class _GlassScaffoldContent extends ConsumerWidget {
  final Widget child;

  final String? title;
  final String? subtitle;

  final bool showLogo;
  final bool showBackButton;

  final bool appBarEnabled;

  final bool? useGradientBackground;

  final double currentBlur;
  final double currentNoise;

  final bool compactMode;
  final bool hideNavigation;

  final List<Widget>? actions;

  // ==========================================================================
  // APP BAR APPEARANCE
  // ==========================================================================

  final double? actionBackgroundOpacity;
  final double? actionAccentOpacity;
  final double? actionBorderOpacity;
  final double? actionBorderWidth;
  final double? actionShadowOpacity;
  final double? actionShadowBlur;
  final double? actionShadowOffsetY;
  final double? shadowOpacity;

  final EdgeInsetsGeometry? padding;

  final bool enableScroll;

  final double bodyBlur;
  final double appBarHeight;

  final double effectiveZoom;

  const _GlassScaffoldContent({
    required this.child,
    required this.title,
    required this.subtitle,
    required this.showLogo,
    required this.showBackButton,
    required this.appBarEnabled,
    required this.useGradientBackground,
    required this.currentBlur,
    required this.currentNoise,
    required this.compactMode,
    required this.hideNavigation,
    required this.actions,

    // AppBar appearance
    required this.actionBackgroundOpacity,
    required this.actionAccentOpacity,
    required this.actionBorderOpacity,
    required this.actionBorderWidth,
    required this.actionShadowOpacity,
    required this.actionShadowBlur,
    required this.actionShadowOffsetY,
    required this.shadowOpacity,

    required this.padding,
    required this.enableScroll,
    required this.bodyBlur,
    required this.appBarHeight,
    required this.effectiveZoom,
  });

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    // =========================================================================
    // LAYOUT CENTRAL
    // =========================================================================

    final layout =
        context.glassLayout;

    // =========================================================================
    // STYLE GLOBAL
    // =========================================================================
    //
    // SOURCE DE VÉRITÉ UNIQUE
    //
    // L'AppBar utilise exactement le même GlassStyle que les autres surfaces.
    //
    // Exemple :
    //
    //     gradientOpaque
    //          ↓
    //     opaqueMat
    //
    // L'AppBar suit automatiquement.
    //
    // =========================================================================

    final GlassStyle appBarStyle =
        layout.effectiveGlassStyle;

    // =========================================================================
    // GRADIENT ACTIF DU THÈME
    // =========================================================================
    //
    // Le gradient n'est PAS injecté comme customGradient.
    //
    // Il reste sous le contrôle de GlassSurfaceGradient.
    //
    // GlassSurfaceRenderer peut ainsi décider du rendu correct selon
    // le GlassStyle courant.
    //

    final List<Color> activeGradient =
        List<Color>.unmodifiable(
      layout.theme.activeGradient,
    );

    // =========================================================================
    // PADDING
    // =========================================================================

    final EdgeInsetsGeometry basePadding =
        padding ??
        layout.dynamicPadding;

    final EdgeInsetsGeometry contentPadding =
        basePadding.add(
      EdgeInsets.only(
        top: appBarEnabled
            ? appBarHeight + 8.0
            : 8.0,
      ),
    );

    // =========================================================================
    // CONTENU
    // =========================================================================

    Widget content =
        Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth:
              layout.effectiveMaxWidth,
        ),
        child: child,
      ),
    );

    // =========================================================================
    // SCROLL
    // =========================================================================

    if (enableScroll) {
      content =
          SingleChildScrollView(
        physics:
            const BouncingScrollPhysics(),
        padding:
            contentPadding,
        child:
            content,
      );
    } else {
      content =
          Padding(
        padding:
            contentPadding,
        child:
            content,
      );
    }

    // =========================================================================
    // APP BAR
    // =========================================================================

    final PreferredSizeWidget? appBar = appBarEnabled
        ? PreferredSize(
            preferredSize:
                Size.fromHeight(appBarHeight),
            child:
                GlassSurfaceContainer(
              // ===============================================================
              // KEY
              // ===============================================================
              //
              // La clé dépend du style global et des effets.
              //
              // Le gradient n'est pas utilisé pour déterminer le style.
              //
              key: ValueKey(
                '${appBarStyle.name}_'
                '${layout.theme.useAquaStyle}_'
                '${activeGradient.hashCode}_'
                '${currentBlur}_'
                '${currentNoise}_'
                '${effectiveZoom}_'
                '${appBarHeight}_'
                // ignore: unnecessary_brace_in_string_interps
                '${compactMode}',
              ),

              // ===============================================================
              // STYLE GLOBAL
              // ===============================================================
              //
              // SOURCE DE VÉRITÉ UNIQUE.
              //
              style:
                  appBarStyle,

              // ===============================================================
              // ROLE APP BAR
              // ===============================================================

              role:
                  GlassSurfaceRole.appBar,

              // ===============================================================
              // GRADIENT PERSONNALISÉ
              // ===============================================================
              //
              // VOLONTAIREMENT NULL.
              //
              // Cela est essentiel.
              //
              // Si on envoyait activeGradient ici comme customGradient,
              // GlassSurfaceGradient lui donnerait priorité sur le
              // GlassStyle.
              //
              // Nous voulons au contraire :
              //
              //     GlassStyle
              //          ↓
              //     GlassSurfaceGradient
              //
              // Ainsi opaqueMat reste opaqueMat.
              //
              customGradient:
                  null,

              customKey:
                  null,

              // ===============================================================
              // EFFETS
              // ===============================================================

              effects:
                  GlassEffects(
                bgGradient:
                    activeGradient,
                bgBlur:
                    currentBlur,
                bgNoise:
                    currentNoise,
              ),

              // ===============================================================
              // DIMENSIONS
              // ===============================================================

              borderRadius:
                  BorderRadius.zero,

              width:
                  double.infinity,

              height:
                  appBarHeight,

              padding:
                  EdgeInsets.zero,

              liftOnHover:
                  false,

              clipBehavior:
                  Clip.antiAlias,

              // ===============================================================
              // CONTENU
              // ===============================================================
              //
              // UniversalAppBar ne crée plus de GlassSurfaceContainer.
              //
              // Il construit uniquement le contenu visuel.
              //
              // ===============================================================

              child:
                  UniversalAppBar(
                height:
                    appBarHeight,

                title:
                    title,

                subtitle:
                    subtitle,

                showLogo:
                    showLogo,

                showBackButton:
                    showBackButton,

                // -------------------------------------------------------------
                // CONTENU APP BAR
                // -------------------------------------------------------------
                //
                // Ce booléen n'a aucun rôle dans la sélection du
                // GlassStyle.
                //
                // Le style de la surface est déjà défini par appBarStyle.
                //
                useGradientBackground:
                    useGradientBackground ??
                        _isGradientStyle(
                          appBarStyle,
                        ),

                compactMode:
                    compactMode,

                hideNavigation:
                    hideNavigation,

                actions:
                    actions,

                // -------------------------------------------------------------
                // APP BAR APPEARANCE
                // -------------------------------------------------------------

                actionBackgroundOpacity:
                    actionBackgroundOpacity,

                actionAccentOpacity:
                    actionAccentOpacity,

                actionBorderOpacity:
                    actionBorderOpacity,

                actionBorderWidth:
                    actionBorderWidth,

                actionShadowOpacity:
                    actionShadowOpacity,

                actionShadowBlur:
                    actionShadowBlur,

                actionShadowOffsetY:
                    actionShadowOffsetY,

                shadowOpacity:
                    shadowOpacity,
              ),
            ),
          )
        : null;

    // =========================================================================
    // SCAFFOLD
    // =========================================================================

    return Scaffold(
      backgroundColor:
          Colors.transparent,

      extendBodyBehindAppBar:
          true,

      // =========================================================================
      // APP BAR
      // =========================================================================

      appBar:
          appBar,

      // =========================================================================
      // BODY
      // =========================================================================

      body:
          Stack(
        fit:
            StackFit.expand,
        children: [
          GlassBackground(
            blur:
                bodyBlur,
            noise:
                currentNoise,
          ),

          SafeArea(
            top:
                false,
            child:
                content,
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // GRADIENT STYLE
  // ===========================================================================

  bool _isGradientStyle(
    GlassStyle style,
  ) {
    switch (style) {
      case GlassStyle.gradientOpaque:
      case GlassStyle.customGradient:
      case GlassStyle.custom:
      case GlassStyle.classicSb:
        return true;

      default:
        return false;
    }
  }
}
