// ignore: unnecessary_library_name
library universal_glass_theme;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:universal_glass/components/glass_action_icon.dart';
import 'package:universal_glass/components/inputs/glass_input_decoration.dart';
import 'package:universal_glass/provider/glass_theme_provider.dart';
import 'package:universal_glass/theme/glass_color_palette.dart';
import 'package:universal_glass/theme/glass_effects.dart';

import '../enums/glass_enums.dart';

/// ============================================================================
/// CONTEXTE DE LAYOUT GLASS
/// ============================================================================
///
/// Centralise les paramètres visuels utilisés par les composants d'interface.
///
/// Responsabilités :
/// - thème courant ;
/// - palette ;
/// - effets glass ;
/// - padding dynamique ;
/// - style glass effectif ;
/// - décoration personnalisée ;
/// - construction des éléments visuels des champs.
///
/// IMPORTANT :
/// Ce contexte ne contient aucune logique métier et ne gère aucun controller
/// ou FocusNode.
/// ============================================================================
class GlassLayoutContext {
  final GlassThemeState theme;
  final GlassColorPalette palette;
  final GlassEffects effects;
  final EdgeInsets dynamicPadding;
  final bool isSmallMobile;
  final GlassStyle effectiveGlassStyle;
  final BoxDecoration? customDecoration;

  const GlassLayoutContext({
    required this.theme,
    required this.palette,
    required this.effects,
    required this.dynamicPadding,
    required this.isSmallMobile,
    required this.effectiveGlassStyle,
    this.customDecoration,
  });

  // ==========================================================================
  // INPUT DECORATION
  // ==========================================================================

  GlassInputDecoration inputDecoration({
    bool hasError = false,
    bool isFocused = false,
  }) {
    final bool useAqua = theme.useAquaStyle;

    final Color focusColor =
        useAqua ? Colors.cyanAccent : Colors.orangeAccent;

    final double baseOpacity =
        theme.effectiveBlur > 25 ? 0.12 : 0.18;

    final double backgroundOpacity =
        isFocused ? baseOpacity + 0.1 : baseOpacity;

    final Color borderColor = hasError
        ? Colors.redAccent.withValues(alpha: 0.6)
        : Colors.white.withValues(alpha: 0.12);

    final Color focusBorderColor = hasError
        ? Colors.redAccent
        : focusColor.withValues(alpha: 0.8);

    return GlassInputDecoration(
      color: useAqua
          ? focusColor.withValues(alpha: 0.06)
          : Colors.white.withValues(alpha: 0.04),
      backgroundOpacity: backgroundOpacity,
      focusOpacity: baseOpacity + 0.14,
      borderColor: borderColor,
      focusBorderColor: focusBorderColor,
      errorColor: Colors.redAccent,
      borderWidth: 1.0,
      focusBorderWidth: 1.3,
      borderRadius: isSmallMobile ? 14 : 16,
      fontSize: 15,
      fontWeight: FontWeight.w600,
    );
  }

  // ==========================================================================
  // INPUT BUBBLE
  // ==========================================================================

  Widget buildInputBubble({
    required Widget child,
    required double fieldHeight,
    required bool isFocused,
    required bool enabled,
    required VoidCallback? onTap,
    Color? iconColor,
  }) {
    final bool useAqua = theme.useAquaStyle;

    final Color focusColor =
        useAqua ? Colors.cyanAccent : Colors.orangeAccent;

    // Bubble = 60 % de la hauteur du champ.
    final double bubbleSize =
        (fieldHeight * 0.60).clamp(36.0, 48.0);

    final Color finalIconColor = iconColor ??
        (isFocused
            ? focusColor
            : palette.textSecondary.withValues(alpha: 0.7));

    return SizedBox(
      width: bubbleSize,
      height: bubbleSize,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // ------------------------------------------------------------------
          // GLOW
          // ------------------------------------------------------------------

          AnimatedOpacity(
            duration: const Duration(milliseconds: 180),
            opacity: isFocused && enabled ? 1.0 : 0.0,
            child: Container(
              width: bubbleSize + 16,
              height: bubbleSize + 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: focusColor.withValues(alpha: 0.45),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
          ),

          // ------------------------------------------------------------------
          // GLASS ACTION ICON
          // ------------------------------------------------------------------

          GlassActionIcon(
            isHovered: isFocused,
            isActive: isFocused,
            enabled: enabled,
            onTap: onTap,
            size: bubbleSize,
            isInputFieldStyle: true,
            color: finalIconColor,
            glowColor: focusColor,
            child: child,
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // INPUT ACTION ICON
  // ==========================================================================

  Widget buildInputActionIcon({
    required IconData icon,
    required bool isFocused,
    required bool enabled,
    required VoidCallback? onTap,
    bool hasError = false,
    Color? customColor,

    /// Hauteur disponible dans le Row du champ.
    double availableHeight = 58.0,

    /// Proportion de la hauteur du Row utilisée par la bubble.
    double bubbleRatio = 0.92,

    /// Ratio icône / bubble.
    double iconRatio = 0.66,

    bool showGlow = true,
  }) {
    final bool useAqua = theme.useAquaStyle;

    final Color focusColor =
        useAqua ? Colors.cyanAccent : Colors.orangeAccent;

    final Color iconColor = customColor ??
        (hasError
            ? Colors.redAccent
            : enabled
                ? isFocused
                    ? focusColor
                    : palette.textSecondary.withValues(alpha: 0.7)
                : palette.textSecondary.withValues(alpha: 0.4));

    // ------------------------------------------------------------------------
    // TAILLE AUTOMATIQUE
    // ------------------------------------------------------------------------

    final double bubbleSize =
        (availableHeight * bubbleRatio).clamp(28.0, 54.0);

    final double iconSize =
        (bubbleSize * iconRatio).clamp(16.0, 32.0);

    // ------------------------------------------------------------------------
    // GLASS ACTION ICON
    // ------------------------------------------------------------------------

    return SizedBox(
      width: bubbleSize,
      height: bubbleSize,
      child: Center(
        child: GlassActionIcon(
          icon: icon,
          enabled: enabled,
          isActive: isFocused,
          size: iconSize,
          color: iconColor,
          glowColor:
              showGlow ? focusColor : Colors.transparent,
          onTap: onTap,
        ),
      ),
    );
  }
}

// ============================================================================
// WIDGET REF EXTENSION
// ============================================================================

extension GlassThemeRefExtension on WidgetRef {
  /// Retourne le contexte Glass en écoutant les changements du thème.
  ///
  /// À utiliser dans un ConsumerWidget / ConsumerState :
  ///
  ///     final glass = ref.watchGlassContext(context);
  ///
  GlassLayoutContext watchGlassContext(
    BuildContext context,
  ) {
    final GlassThemeState theme =
        watch(glassThemeProvider);

    final GlassColorPalette palette =
        GlassColorPalette.fromMode(
      theme.useAquaStyle
          ? AppThemeMode.aqua
          : AppThemeMode.classic,
    );

    final double screenWidth =
        MediaQuery.sizeOf(context).width;

    final bool isSmallMobile =
        screenWidth < 375;

    final EdgeInsets dynamicPadding =
        EdgeInsets.all(
      isSmallMobile ? 12 : 18,
    );

    final GlassStyle effectiveGlassStyle =
        theme.glassStyle;

    final GlassEffects effects =
        GlassEffects.fromTheme(
      palette,
      blur: theme.effectiveBlur,
      noise: theme.effectiveNoise,
      surfaceOpacity: theme.surfaceOpacity,
      borderRadius: theme.borderRadius,
      enableBorder: theme.enableBorder,
      borderOpacity: theme.borderOpacity,
      borderWidth: theme.borderWidth,
      enableGlow: theme.enableGlow,
      glowOpacity: theme.glowOpacity,
      glowBlur: theme.glowBlur,
      enableShadow: theme.enableShadow,
      shadowOpacity: theme.shadowOpacity,
      shadowBlur: theme.shadowBlur,
      shadowOffsetY: theme.shadowOffsetY,
    );

    final BoxDecoration? customDecoration =
        theme.glassStyle == GlassStyle.classicSb
            ? theme.effectiveDecoration
            : null;

    return GlassLayoutContext(
      theme: theme,
      palette: palette,
      effects: effects,
      dynamicPadding: dynamicPadding,
      isSmallMobile: isSmallMobile,
      effectiveGlassStyle: effectiveGlassStyle,
      customDecoration: customDecoration,
    );
  }
}

// ============================================================================
// BUILD CONTEXT EXTENSION
// ============================================================================

extension GlassThemeContextExtension on BuildContext {
  /// Retourne le contexte Glass sans écouter les changements de provider.
  ///
  /// À utiliser lorsque le contexte est déjà construit dans une zone
  /// contrôlée, ou lorsque l'on veut simplement lire l'état courant :
  ///
  ///     final glass = context.watchGlassContext;
  ///
  /// IMPORTANT :
  /// Ceci est un GETTER.
  ///
  /// Correct :
  ///
  ///     context.watchGlassContext
  ///
  /// Incorrect :
  ///
  ///     context.watchGlassContext()
  ///
  GlassLayoutContext get watchGlassContext {
    final ProviderContainer container =
        ProviderScope.containerOf(
      this,
      listen: false,
    );

    final GlassThemeState theme =
        container.read(glassThemeProvider);

    final GlassColorPalette palette =
        GlassColorPalette.fromMode(
      theme.useAquaStyle
          ? AppThemeMode.aqua
          : AppThemeMode.classic,
    );

    final double screenWidth =
        MediaQuery.sizeOf(this).width;

    final bool isSmallMobile =
        screenWidth < 375;

    final EdgeInsets dynamicPadding =
        EdgeInsets.all(
      isSmallMobile ? 12 : 18,
    );

    final GlassStyle effectiveGlassStyle =
        theme.glassStyle;

    final GlassEffects effects =
        GlassEffects.fromTheme(
      palette,
      blur: theme.effectiveBlur,
      noise: theme.effectiveNoise,
      surfaceOpacity: theme.surfaceOpacity,
      borderRadius: theme.borderRadius,
      enableBorder: theme.enableBorder,
      borderOpacity: theme.borderOpacity,
      borderWidth: theme.borderWidth,
      enableGlow: theme.enableGlow,
      glowOpacity: theme.glowOpacity,
      glowBlur: theme.glowBlur,
      enableShadow: theme.enableShadow,
      shadowOpacity: theme.shadowOpacity,
      shadowBlur: theme.shadowBlur,
      shadowOffsetY: theme.shadowOffsetY,
    );

    final BoxDecoration? customDecoration =
        theme.glassStyle == GlassStyle.classicSb
            ? theme.effectiveDecoration
            : null;

    return GlassLayoutContext(
      theme: theme,
      palette: palette,
      effects: effects,
      dynamicPadding: dynamicPadding,
      isSmallMobile: isSmallMobile,
      effectiveGlassStyle: effectiveGlassStyle,
      customDecoration: customDecoration,
    );
  }
}