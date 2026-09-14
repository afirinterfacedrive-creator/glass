import 'package:flutter/material.dart';

import 'package:universal_glass/enums/glass_enums.dart';
import 'package:universal_glass/provider/glass_theme_state.dart';
import 'package:universal_glass/theme/glass_color_palette.dart';
import 'package:universal_glass/theme/glass_display_settings.dart';
import 'package:universal_glass/theme/glass_effects.dart';
import 'package:universal_glass/theme/glass_scale_engine.dart';
import 'package:universal_glass/utils/glass_input_decoration.dart';

enum GlassScreenSize {
  smallMobile,
  mobile,
  tablet,
  desktop,
  largeDesktop,
}

@immutable
class GlassLayoutContext {
  final GlassThemeState theme;
  final GlassColorPalette palette;
  final GlassEffects effects;

  final GlassDisplaySettings display;

  /// Largeur physique réelle de l'écran.
  final double screenWidth;

  /// Hauteur physique réelle de l'écran.
  final double screenHeight;

  final GlassScreenSize screenSize;

  /// Padding responsive déjà adapté au zoom.
  final EdgeInsets dynamicPadding;

  final bool isSmallMobile;
  final bool isMobile;
  final bool isTablet;
  final bool isDesktop;
  final bool isLargeDesktop;

  /// Largeur maximale du contenu dans l'espace logique.
  final double maxContentWidth;

  /// Données du moteur de scaling global.
  final GlassScaleData scale;

  final GlassStyle effectiveGlassStyle;

  final BoxDecoration? customDecoration;

  const GlassLayoutContext({
    required this.theme,
    required this.palette,
    required this.effects,
    required this.display,
    required this.screenWidth,
    required this.screenHeight,
    required this.screenSize,
    required this.dynamicPadding,
    required this.isSmallMobile,
    required this.isMobile,
    required this.isTablet,
    required this.isDesktop,
    required this.isLargeDesktop,
    required this.maxContentWidth,
    required this.scale,
    required this.effectiveGlassStyle,
    this.customDecoration,
  });

  // ===========================================================================
  // THEME
  // ===========================================================================

  /// Couleur de focus adaptée au style courant.
  Color get focusColor {
    return theme.useAquaStyle
        ? Colors.cyanAccent
        : Colors.orangeAccent;
  }

/// ==========================================================================
/// INPUT DECORATION
/// ==========================================================================
///
/// Résout la décoration visuelle commune aux champs Glass.
///
/// Le composant de champ reste responsable de son comportement
/// (FocusNode, controller, validation, etc.).
///
/// Le contexte reste responsable de la résolution visuelle :
///
/// - couleur de focus ;
/// - opacité ;
/// - bordure ;
/// - rayon ;
/// - typographie.
///
/// Ainsi tous les champs utilisent la même source de vérité.
/// ==========================================================================

GlassInputDecoration inputDecoration({
  bool hasError = false,
  bool isFocused = false,
}) {
  // ------------------------------------------------------------------------
  // COULEUR DE FOCUS
  // ------------------------------------------------------------------------

  final Color focus = focusColor;

  // ------------------------------------------------------------------------
  // OPACITÉ DE BASE
  // ------------------------------------------------------------------------

  final double baseOpacity =
      theme.effectiveBlur > 25.0
          ? 0.12
          : 0.18;

  final double backgroundOpacity =
      isFocused
          ? (baseOpacity + 0.10).clamp(0.0, 1.0).toDouble()
          : baseOpacity;

  // ------------------------------------------------------------------------
  // BORDURE NORMALE / ERREUR
  // ------------------------------------------------------------------------

  final Color borderColor =
      hasError
          ? Colors.redAccent.withValues(alpha: 0.60)
          : Colors.white.withValues(alpha: 0.12);

  // ------------------------------------------------------------------------
  // BORDURE FOCUS / ERREUR
  // ------------------------------------------------------------------------

  final Color focusBorderColor =
      hasError
          ? Colors.redAccent
          : focus.withValues(alpha: 0.80);

  // ------------------------------------------------------------------------
  // DÉCORATION
  // ------------------------------------------------------------------------

  return GlassInputDecoration(
    color: theme.useAquaStyle
        ? focus.withValues(alpha: 0.06)
        : Colors.white.withValues(alpha: 0.04),
    backgroundOpacity: backgroundOpacity,
    focusOpacity:
        (baseOpacity + 0.14).clamp(0.0, 1.0).toDouble(),
    borderColor: borderColor,
    focusBorderColor: focusBorderColor,
    errorColor: Colors.redAccent,
    borderWidth: 1.0,
    focusBorderWidth: 1.3,
    errorBorderWidth: 1.6,
    borderRadius: isSmallMobile
        ? 14.0
        : 16.0,
    fontSize: 15.0,
    fontWeight: FontWeight.w600,
  );
}

  // ===========================================================================
  // DENSITY
  // ===========================================================================

  /// Facteur général de densité.
  double get densityFactor {
    return display.spacingFactor;
  }

  /// Facteur de hauteur des contrôles.
  double get controlHeightFactor {
    return display.controlHeightFactor;
  }

  /// Facteur des rayons.
  double get borderRadiusFactor {
    return display.borderRadiusFactor;
  }

  /// Facteur des textes.
  double get fontSizeFactor {
    return display.fontSizeFactor;
  }

  // ===========================================================================
  // DIMENSIONS
  // ===========================================================================

  /// Convertit une dimension visuelle en dimension logique.
  ///
  /// Exemple avec zoom 125 % :
  ///
  /// 100 px visuels -> 80 px logiques.
  double size(double value) {
    return scale.size(value);
  }

  /// Dimension visuelle.
  double visual(double value) {
    return scale.visual(value);
  }

  /// Espacement responsive + scaling.
  double spacing(double value) {
    return scale.size(
      value * display.spacingFactor,
    );
  }

  /// Hauteur responsive d'un contrôle.
  double controlHeight(double value) {
    return scale.size(
      value * display.controlHeightFactor,
    );
  }

  /// Rayon responsive.
  double radius(double value) {
    return scale.radius(
      value * display.borderRadiusFactor,
    );
  }

  /// Taille de police responsive.
  double fontSize(double value) {
    return scale.font(
      value * display.fontSizeFactor,
    );
  }

  // ===========================================================================
  // PADDING
  // ===========================================================================

  /// Padding horizontal + vertical adapté à la densité et au zoom.
  EdgeInsets padding({
    double horizontal = 0.0,
    double vertical = 0.0,
  }) {
    return EdgeInsets.symmetric(
      horizontal: scale.size(
        horizontal * display.spacingFactor,
      ),
      vertical: scale.size(
        vertical * display.spacingFactor,
      ),
    );
  }

  /// Padding complet.
  EdgeInsets paddingOnly({
    double left = 0.0,
    double top = 0.0,
    double right = 0.0,
    double bottom = 0.0,
  }) {
    return EdgeInsets.only(
      left: scale.size(
        left * display.spacingFactor,
      ),
      top: scale.size(
        top * display.spacingFactor,
      ),
      right: scale.size(
        right * display.spacingFactor,
      ),
      bottom: scale.size(
        bottom * display.spacingFactor,
      ),
    );
  }

  /// Padding horizontal uniquement.
  EdgeInsets horizontalPadding(double value) {
    final double scaled = scale.size(
      value * display.spacingFactor,
    );

    return EdgeInsets.symmetric(
      horizontal: scaled,
    );
  }

  /// Padding vertical uniquement.
  EdgeInsets verticalPadding(double value) {
    final double scaled = scale.size(
      value * display.spacingFactor,
    );

    return EdgeInsets.symmetric(
      vertical: scaled,
    );
  }

  // ===========================================================================
  // WIDTH
  // ===========================================================================

  /// Largeur logique maximale du contenu.
  double get effectiveMaxWidth {
    if (maxContentWidth <= 0 ||
        maxContentWidth == double.infinity) {
      return double.infinity;
    }

    return maxContentWidth;
  }

  /// Largeur logique disponible correspondant à l'écran physique.
  double get logicalScreenWidth {
    return scale.logicalWidth(
      screenWidth,
    );
  }

  /// Hauteur logique disponible correspondant à l'écran physique.
  double get logicalScreenHeight {
    return scale.logicalHeight(
      screenHeight,
    );
  }

  // ===========================================================================
  // SCREEN
  // ===========================================================================

  bool get isSmallScreen {
    return isSmallMobile || isMobile;
  }

  bool get isTouchLayout {
    return isMobile || isTablet;
  }

  bool get isWideScreen {
    return isDesktop || isLargeDesktop;
  }

  // ===========================================================================
  // RESOLUTION
  // ===========================================================================

  /// Construit le contexte responsive complet.
  ///
  /// Les paramètres `...Override` permettent à un parent comme
  /// [GlassScaffold] de remplacer localement les valeurs globales
  /// provenant de [GlassDisplaySettings].
  ///
  /// Les breakpoints sont toujours calculés à partir de la largeur
  /// physique de l'écran. Le zoom global ne change donc pas la catégorie
  /// mobile / tablette / desktop.
  static GlassLayoutContext resolve({
    required BuildContext context,
    required GlassThemeState theme,
    GlassScaleData? scale,

    // -------------------------------------------------------------------------
    // OVERRIDES LOCAUX
    // -------------------------------------------------------------------------

    double? maxWidthOverride,
    double? desktopBreakpointOverride,
    double? tabletBreakpointOverride,
    double? desktopPaddingOverride,
    double? tabletPaddingOverride,
    double? mobilePaddingOverride,
    double? smallMobilePaddingOverride,
  }) {
    // -------------------------------------------------------------------------
    // SCREEN
    // -------------------------------------------------------------------------

    final Size screen = MediaQuery.sizeOf(context);

    final double width = screen.width;
    final double height = screen.height;

    // -------------------------------------------------------------------------
    // DISPLAY
    // -------------------------------------------------------------------------

    final GlassDisplaySettings display =
        theme.display.normalized();

    // -------------------------------------------------------------------------
    // SCALE
    // -------------------------------------------------------------------------

    final GlassScaleData effectiveScale =
        scale ??
        GlassScaleData(
          scale: display.zoom,
        );

    // -------------------------------------------------------------------------
    // BREAKPOINTS
    //
    // Les overrides locaux ont priorité sur les réglages globaux.
    // -------------------------------------------------------------------------

    final double tabletBreakpoint =
        (tabletBreakpointOverride ??
                display.tabletBreakpoint)
            .clamp(
              400.0,
              1200.0,
            )
            .toDouble();

    double desktopBreakpoint =
        (desktopBreakpointOverride ??
                display.desktopBreakpoint)
            .clamp(
              800.0,
              2000.0,
            )
            .toDouble();

    // Le breakpoint desktop doit toujours être supérieur
    // au breakpoint tablette.
    if (desktopBreakpoint <= tabletBreakpoint) {
      desktopBreakpoint =
          tabletBreakpoint + 100.0;
    }

    // -------------------------------------------------------------------------
    // SCREEN SIZE
    // -------------------------------------------------------------------------

    final bool smallMobile =
        width < 375.0;

    final bool mobile =
        width < tabletBreakpoint;

    final bool tablet =
        width >= tabletBreakpoint &&
        width < desktopBreakpoint;

    final bool desktop =
        width >= desktopBreakpoint;

    final bool largeDesktop =
        width >= desktopBreakpoint + 500.0;

    late final GlassScreenSize screenSize;

    if (smallMobile) {
      screenSize =
          GlassScreenSize.smallMobile;
    } else if (mobile) {
      screenSize =
          GlassScreenSize.mobile;
    } else if (tablet) {
      screenSize =
          GlassScreenSize.tablet;
    } else if (largeDesktop) {
      screenSize =
          GlassScreenSize.largeDesktop;
    } else {
      screenSize =
          GlassScreenSize.desktop;
    }

    // -------------------------------------------------------------------------
    // RESPONSIVE PADDING
    // -------------------------------------------------------------------------

    final double effectiveSmallMobilePadding =
        (smallMobilePaddingOverride ??
                display.smallMobilePadding)
            .clamp(
              0.0,
              100.0,
            )
            .toDouble();

    final double effectiveMobilePadding =
        (mobilePaddingOverride ??
                display.mobilePadding)
            .clamp(
              0.0,
              100.0,
            )
            .toDouble();

    final double effectiveTabletPadding =
        (tabletPaddingOverride ??
                display.tabletPadding)
            .clamp(
              0.0,
              100.0,
            )
            .toDouble();

    final double effectiveDesktopPadding =
        (desktopPaddingOverride ??
                display.desktopPadding)
            .clamp(
              0.0,
              100.0,
            )
            .toDouble();

    late final double horizontalPadding;

    if (smallMobile) {
      horizontalPadding =
          effectiveSmallMobilePadding;
    } else if (mobile) {
      horizontalPadding =
          effectiveMobilePadding;
    } else if (tablet) {
      horizontalPadding =
          effectiveTabletPadding;
    } else {
      horizontalPadding =
          effectiveDesktopPadding;
    }

    // -------------------------------------------------------------------------
    // SCALE DU PADDING
    //
    // Une seule conversion vers l'espace logique.
    // -------------------------------------------------------------------------

    final double scaledHorizontalPadding =
        GlassScaleEngine.size(
      horizontalPadding *
          display.spacingFactor,
      effectiveScale.value,
    );

    final EdgeInsets dynamicPadding =
        EdgeInsets.symmetric(
      horizontal:
          scaledHorizontalPadding,
    );

    // -------------------------------------------------------------------------
    // MAX WIDTH
    //
    // L'ordre de priorité est :
    //
    // 1. maxWidthOverride
    // 2. display.maxWidth
    //
    // La valeur finale est convertie une seule fois vers l'espace logique.
    // -------------------------------------------------------------------------

    final double configuredMaxWidth =
        maxWidthOverride ??
            display.maxWidth;

    final double maxWidth;

    if (configuredMaxWidth <= 0) {
      maxWidth =
          double.infinity;
    } else {
      maxWidth =
          GlassScaleEngine.logicalWidth(
        configuredMaxWidth,
        effectiveScale.value,
      );
    }

    // -------------------------------------------------------------------------
    // EFFECTS
    // -------------------------------------------------------------------------

    final GlassEffects effects =
        theme.effects;

    // -------------------------------------------------------------------------
    // RESULT
    // -------------------------------------------------------------------------

    return GlassLayoutContext(
      theme: theme,
      palette: theme.palette,
      effects: effects,
      display: display,
      screenWidth: width,
      screenHeight: height,
      screenSize: screenSize,
      dynamicPadding: dynamicPadding,
      isSmallMobile: smallMobile,
      isMobile: mobile,
      isTablet: tablet,
      isDesktop: desktop,
      isLargeDesktop: largeDesktop,
      maxContentWidth: maxWidth,
      scale: effectiveScale,
      effectiveGlassStyle:
          theme.effectiveGlassStyle,
    );
  }
}