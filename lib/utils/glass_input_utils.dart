import 'package:flutter/material.dart';

import 'package:universal_glass/components/glass_action_icon.dart';
import 'package:universal_glass/core/layout/glass_layout_context.dart';
import 'package:universal_glass/core/layout/glass_layout_scope.dart';

class GlassInputUtils {
  GlassInputUtils._();

  // ---------------------------------------------------------------------------
  // DIMENSIONS
  // ---------------------------------------------------------------------------

  static double bubbleSize({
    required double fieldHeight,
    double ratio = 0.6,
    double min = 28.0,
    double max = 54.0,
  }) {
    return (fieldHeight * ratio).clamp(min, max);
  }

  static double iconSize({
    required double bubbleSize,
    double ratio = 0.66,
    double min = 16.0,
    double max = 32.0,
  }) {
    return (bubbleSize * ratio).clamp(min, max);
  }

  static double verticalPadding(
    double fieldHeight, {
    double textHeight = 24.0,
  }) {
    return ((fieldHeight - textHeight) / 2).clamp(2.0, 12.0);
  }

  static double separatorHeight(double bubbleSize) {
    return bubbleSize * 0.6;
  }

  // ---------------------------------------------------------------------------
  // LAYOUT
  // ---------------------------------------------------------------------------

  static GlassLayoutContext _resolveLayout({
    required BuildContext context,
    GlassLayoutContext? layout,
  }) {
    return layout ?? GlassLayoutScope.of(context);
  }

  // ---------------------------------------------------------------------------
  // SEPARATOR
  // ---------------------------------------------------------------------------

  static Widget buildSeparator({
    required BuildContext context,
    GlassLayoutContext? layout,
    required double bubbleSize,
    required bool isActive,
    required bool enabled,
  }) {
    final GlassLayoutContext glass = _resolveLayout(
      context: context,
      layout: layout,
    );

    final bool useAqua = glass.theme.useAquaStyle;

    final Color focusColor =
        useAqua ? Colors.cyanAccent : Colors.orangeAccent;

    final Color separatorColor;

    if (!enabled) {
      separatorColor =
          glass.palette.border.withValues(alpha: 0.20);
    } else if (isActive) {
      separatorColor =
          focusColor.withValues(alpha: 0.40);
    } else {
      separatorColor =
          glass.palette.border.withValues(alpha: 0.30);
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      width: 1.0,
      height: separatorHeight(bubbleSize),
      color: separatorColor,
    );
  }

  // ---------------------------------------------------------------------------
  // INPUT ICON
  // ---------------------------------------------------------------------------

  static Widget buildInputIcon({
    required BuildContext context,
    GlassLayoutContext? layout,
    required IconData icon,
    required bool isActive,
    required bool enabled,
    required VoidCallback? onTap,
    double fieldHeight = 58.0,
    double bubbleRatio = 0.6,
    double iconRatio = 0.66,
    Color? color,
    Color? glowColor,
    bool showGlow = true,
    bool hasError = false,
    bool hasSuccess = false,
    bool onlyIcon = false,
    bool isLoading = false,
  }) {
    final GlassLayoutContext glass = _resolveLayout(
      context: context,
      layout: layout,
    );

    final bool useAqua = glass.theme.useAquaStyle;

    final Color focusColor =
        useAqua ? Colors.cyanAccent : Colors.orangeAccent;

    final double bubble = bubbleSize(
      fieldHeight: fieldHeight,
      ratio: bubbleRatio,
    );

    final double iconS = iconSize(
      bubbleSize: bubble,
      ratio: iconRatio,
    );

    // -------------------------------------------------------------------------
    // ETATS
    //
    // Priorité :
    //   ERROR > FOCUS > SUCCESS > NORMAL
    //
    // SUCCESS ne doit jamais devenir un état actif.
    // -------------------------------------------------------------------------

    final bool isInErrorState = hasError;

    final bool isInFocusState =
        isActive && !hasError && !hasSuccess;

    final bool isInSuccessState =
        hasSuccess && !hasError && !isActive;

    // -------------------------------------------------------------------------
    // GLOW
    //
    // Glow uniquement pour :
    //   - focus
    //   - erreur
    //
    // Le succès n'a volontairement aucun glow.
    // -------------------------------------------------------------------------

    final bool shouldGlow =
        showGlow && (isInFocusState || isInErrorState);

    final Color effectiveGlowColor;

    if (isInErrorState) {
      effectiveGlowColor = Colors.redAccent;
    } else if (isInFocusState) {
      effectiveGlowColor = glowColor ?? focusColor;
    } else {
      effectiveGlowColor = Colors.transparent;
    }

    // -------------------------------------------------------------------------
    // COULEUR DE L'ICONE
    // -------------------------------------------------------------------------

    final Color defaultIconColor;

    if (isInErrorState) {
      defaultIconColor = Colors.redAccent;
    } else if (isInSuccessState) {
      defaultIconColor = Colors.greenAccent;
    } else if (!enabled) {
      defaultIconColor =
          Colors.white.withValues(alpha: 0.40);
    } else if (isInFocusState) {
      defaultIconColor = Colors.white;
    } else {
      defaultIconColor =
          Colors.white.withValues(alpha: 0.75);
    }

    final Color finalColor = _resolveIconColor(
      color: color,
      fallback: defaultIconColor,
    );

    // -------------------------------------------------------------------------
    // CONTENU
    // -------------------------------------------------------------------------

    final Widget innerContent;

    if (isLoading) {
      innerContent = SizedBox(
        width: iconS,
        height: iconS,
        child: CircularProgressIndicator(
          strokeWidth: 2.0,
          color: finalColor,
        ),
      );
    } else {
      innerContent = Icon(
        icon,
        size: iconS,
        color: finalColor,
      );
    }

    // -------------------------------------------------------------------------
    // MODE ICON SEUL
    // -------------------------------------------------------------------------

    if (onlyIcon) {
      return _buildOnlyIcon(
        child: innerContent,
        enabled: enabled && !isLoading,
        onTap: onTap,
        shouldGlow: shouldGlow,
        glowColor: effectiveGlowColor,
      );
    }

    // -------------------------------------------------------------------------
    // MODE BULLE
    // -------------------------------------------------------------------------

    return GlassActionIcon(
      size: bubble,
      isInputFieldStyle: true,
      enabled: enabled && !isLoading,
      isActive: isInFocusState || isInErrorState,
      color: finalColor,
      glowColor:
          shouldGlow ? effectiveGlowColor : Colors.transparent,
      onTap: enabled && !isLoading ? onTap : null,
      child: innerContent,
    );
  }

  // ---------------------------------------------------------------------------
  // ICON SEUL
  // ---------------------------------------------------------------------------

  static Widget _buildOnlyIcon({
    required Widget child,
    required bool enabled,
    required VoidCallback? onTap,
    required bool shouldGlow,
    required Color glowColor,
  }) {
    bool isHovered = false;

    return StatefulBuilder(
      builder: (
        BuildContext context,
        StateSetter setState,
      ) {
        final bool showHoverEffect =
            isHovered && enabled;

        final bool applyGlow =
            enabled && (shouldGlow || showHoverEffect);

        final bool canTap =
            enabled && onTap != null;

        final List<BoxShadow> shadows;

        if (applyGlow &&
            glowColor != Colors.transparent) {
          shadows = [
            BoxShadow(
              color: glowColor.withValues(alpha: 0.50),
              blurRadius: 18.0,
              spreadRadius: 2.0,
            ),
            BoxShadow(
              color: glowColor.withValues(alpha: 0.25),
              blurRadius: 8.0,
            ),
          ];
        } else {
          shadows = const [];
        }

        return MouseRegion(
          onEnter: (_) {
            if (!enabled) {
              return;
            }

            setState(() {
              isHovered = true;
            });
          },
          onExit: (_) {
            if (!enabled) {
              return;
            }

            setState(() {
              isHovered = false;
            });
          },
          cursor: canTap
              ? SystemMouseCursors.click
              : SystemMouseCursors.basic,
          child: GestureDetector(
            onTap: canTap ? onTap : null,
            child: AnimatedScale(
              scale: showHoverEffect ? 1.05 : 1.0,
              duration:
                  const Duration(milliseconds: 120),
              child: AnimatedContainer(
                duration:
                    const Duration(milliseconds: 180),
                padding:
                    const EdgeInsets.all(6.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: shadows,
                ),
                child: child,
              ),
            ),
          ),
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // INPUT BUBBLE AVEC CHILD
  // ---------------------------------------------------------------------------

  static Widget buildInputBubbleWithChild({
    required BuildContext context,
    GlassLayoutContext? layout,
    required Widget child,
    required bool isActive,
    required bool enabled,
    required VoidCallback? onTap,
    double fieldHeight = 58.0,
    double bubbleRatio = 0.6,
    Color? color,
    Color? glowColor,
    bool showGlow = true,
    bool hasError = false,
    bool hasSuccess = false,
    bool onlyIcon = false,
  }) {
    final GlassLayoutContext glass = _resolveLayout(
      context: context,
      layout: layout,
    );

    final bool useAqua =
        glass.theme.useAquaStyle;

    final Color focusColor =
        useAqua
            ? Colors.cyanAccent
            : Colors.orangeAccent;

    final double bubble = bubbleSize(
      fieldHeight: fieldHeight,
      ratio: bubbleRatio,
    );

    // -------------------------------------------------------------------------
    // ETATS
    // -------------------------------------------------------------------------

    final bool isInErrorState = hasError;

    final bool isInFocusState =
        isActive && !hasError && !hasSuccess;

    // -------------------------------------------------------------------------
    // GLOW
    // -------------------------------------------------------------------------

    final bool shouldGlow =
        showGlow &&
        (isInFocusState || isInErrorState);

    final Color effectiveGlowColor;

    if (isInErrorState) {
      effectiveGlowColor =
          Colors.redAccent;
    } else if (isInFocusState) {
      effectiveGlowColor =
          glowColor ?? focusColor;
    } else {
      effectiveGlowColor =
          Colors.transparent;
    }

    // -------------------------------------------------------------------------
    // MODE ICON SEUL
    // -------------------------------------------------------------------------

    if (onlyIcon) {
      return _buildOnlyIcon(
        child: child,
        enabled: enabled,
        onTap: onTap,
        shouldGlow: shouldGlow,
        glowColor: effectiveGlowColor,
      );
    }

    // -------------------------------------------------------------------------
    // BULLE GLASS
    // -------------------------------------------------------------------------

    return GlassActionIcon(
      size: bubble,
      isInputFieldStyle: true,
      enabled: enabled,
      isActive:
          isInFocusState || isInErrorState,
      color: color,
      glowColor:
          shouldGlow
              ? effectiveGlowColor
              : Colors.transparent,
      onTap: enabled ? onTap : null,
      child: child,
    );
  }

  // ---------------------------------------------------------------------------
  // COULEUR D'ICONE
  // ---------------------------------------------------------------------------

  static Color _resolveIconColor({
    required Color? color,
    required Color fallback,
  }) {
    if (color == null) {
      return fallback;
    }

    final bool isTooDark =
        color.computeLuminance() < 0.30;

    return isTooDark ? fallback : color;
  }
}

// ============================================================================
// BUILD CONTEXT EXTENSIONS
// ============================================================================

extension GlassInputUtilsExtension on BuildContext {
  // --------------------------------------------------------------------------
  // INPUT ICON
  // --------------------------------------------------------------------------

  Widget buildInputIcon({
    GlassLayoutContext? layout,
    required IconData icon,
    required bool isActive,
    required bool enabled,
    required VoidCallback? onTap,
    double fieldHeight = 58.0,
    double bubbleRatio = 0.6,
    double iconRatio = 0.66,
    Color? color,
    Color? glowColor,
    bool showGlow = true,
    bool hasError = false,
    bool hasSuccess = false,
    bool onlyIcon = false,
    bool isLoading = false,
  }) {
    return GlassInputUtils.buildInputIcon(
      context: this,
      layout: layout,
      icon: icon,
      isActive: isActive,
      enabled: enabled,
      onTap: onTap,
      fieldHeight: fieldHeight,
      bubbleRatio: bubbleRatio,
      iconRatio: iconRatio,
      color: color,
      glowColor: glowColor,
      showGlow: showGlow,
      hasError: hasError,
      hasSuccess: hasSuccess,
      onlyIcon: onlyIcon,
      isLoading: isLoading,
    );
  }

  // --------------------------------------------------------------------------
  // INPUT BUBBLE AVEC CHILD
  // --------------------------------------------------------------------------

  Widget buildInputBubbleWithChild({
    GlassLayoutContext? layout,
    required Widget child,
    required bool isActive,
    required bool enabled,
    required VoidCallback? onTap,
    double fieldHeight = 58.0,
    double bubbleRatio = 0.6,
    Color? color,
    Color? glowColor,
    bool showGlow = true,
    bool hasError = false,
    bool hasSuccess = false,
    bool onlyIcon = false,
  }) {
    return GlassInputUtils.buildInputBubbleWithChild(
      context: this,
      layout: layout,
      child: child,
      isActive: isActive,
      enabled: enabled,
      onTap: onTap,
      fieldHeight: fieldHeight,
      bubbleRatio: bubbleRatio,
      color: color,
      glowColor: glowColor,
      showGlow: showGlow,
      hasError: hasError,
      hasSuccess: hasSuccess,
      onlyIcon: onlyIcon,
    );
  }

  // --------------------------------------------------------------------------
  // SEPARATOR
  // --------------------------------------------------------------------------

  Widget buildInputSeparator({
    GlassLayoutContext? layout,
    required double bubbleSize,
    required bool isActive,
    required bool enabled,
  }) {
    return GlassInputUtils.buildSeparator(
      context: this,
      layout: layout,
      bubbleSize: bubbleSize,
      isActive: isActive,
      enabled: enabled,
    );
  }
}