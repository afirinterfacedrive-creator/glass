import 'package:flutter/material.dart';
import 'package:universal_glass/components/glass_action_icon.dart';
import 'package:universal_glass/utils/glass_theme_extension.dart';

/// Utils pour calculer la taille des icones/bulles dans les inputs glass
class GlassInputUtils {
  GlassInputUtils._();

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

  static double separatorHeight(double bubbleSize) {
    return bubbleSize * 0.6;
  }

  static double verticalPadding(double fieldHeight, {double textHeight = 24.0}) {
    return ((fieldHeight - textHeight) / 2).clamp(2.0, 12.0);
  }

  /// Génère un séparateur vertical standardisé et synchronisé
  static Widget buildSeparator({
    required BuildContext context,
    required double bubbleSize,
    required bool isActive,
    required bool enabled,
  }) {
    final glass = context.watchGlassContext;
    final bool useAqua = glass.theme.useAquaStyle;
    final Color focusColor = useAqua ? Colors.cyanAccent : Colors.orangeAccent;

    final Color separatorColor = !enabled
        ? glass.palette.border.withValues(alpha: 0.2)
        : isActive 
            ? focusColor.withValues(alpha: 0.4) 
            : glass.palette.border.withValues(alpha: 0.3);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      width: 1,
      height: separatorHeight(bubbleSize),
      color: separatorColor,
    );
  }

  /// Build direct d'un GlassActionIcon pour input
  static Widget buildInputIcon({
    required BuildContext context,
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
    bool onlyIcon = false,
    bool isLoading = false,
  }) {
    final glass = context.watchGlassContext;
    final bool useAqua = glass.theme.useAquaStyle;
    final Color focusColor = useAqua ? Colors.cyanAccent : Colors.orangeAccent;

    final double bubble = bubbleSize(fieldHeight: fieldHeight, ratio: bubbleRatio);
    final double iconS = iconSize(bubbleSize: bubble, ratio: iconRatio);

    final Color finalColor = color ?? 
      (hasError 
        ? Colors.redAccent 
        : (enabled ? (isActive ? focusColor : glass.palette.textSecondary.withValues(alpha: 0.7)) : glass.palette.textSecondary.withValues(alpha: 0.4)));

    final Widget innerContent = isLoading
        ? SizedBox(
            width: iconS,
            height: iconS,
            child: CircularProgressIndicator(strokeWidth: 2, color: finalColor),
          )
        : Icon(icon, size: iconS, color: finalColor);

    if (onlyIcon) {
      final Color effectiveGlowColor = glowColor ?? finalColor;
      final bool applyGlow = showGlow && (isActive || hasError);
      bool isHovered = false;

      return StatefulBuilder(
        builder: (context, setState) {
          return MouseRegion(
            onEnter: (_) => setState(() => isHovered = true),
            onExit: (_) => setState(() => isHovered = false),
            cursor: enabled && onTap != null ? SystemMouseCursors.click : SystemMouseCursors.basic,
            child: GestureDetector(
              onTap: enabled ? onTap : null,
              child: AnimatedScale(
                scale: isHovered && enabled ? 1.1 : 1.0,
                duration: const Duration(milliseconds: 120),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: applyGlow || (isHovered && enabled)
                        ? [BoxShadow(color: effectiveGlowColor.withValues(alpha: 0.30), blurRadius: 12, spreadRadius: 1)]
                        : [],
                  ),
                  child: innerContent,
                ),
              ),
            ),
          );
        },
      );
    }

    return GlassActionIcon(
      size: bubble,
      isInputFieldStyle: false,
      enabled: enabled && !isLoading,
      isActive: isActive,
      color: finalColor,
      glowColor: showGlow ? (glowColor ?? focusColor) : Colors.transparent,
      onTap: onTap,
      child: innerContent,
    );
  }

  /// Build pour drapeau/child custom
  static Widget buildInputBubbleWithChild({
    required BuildContext context,
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
    bool onlyIcon = false,
  }) {
    final glass = context.watchGlassContext;
    final bool useAqua = glass.theme.useAquaStyle;
    final Color focusColor = useAqua ? Colors.cyanAccent : Colors.orangeAccent;

    final double bubble = bubbleSize(fieldHeight: fieldHeight, ratio: bubbleRatio);

    final Color finalColor = color ?? 
      (hasError 
        ? Colors.redAccent 
        : (enabled ? (isActive ? focusColor : glass.palette.textSecondary.withValues(alpha: 0.7)) : glass.palette.textSecondary.withValues(alpha: 0.4)));

    if (onlyIcon) {
      final Color effectiveGlowColor = glowColor ?? (hasError ? Colors.redAccent : focusColor);
      final bool applyGlow = showGlow && (isActive || hasError);
      bool isHovered = false;

      return StatefulBuilder(
        builder: (context, setState) {
          return MouseRegion(
            onEnter: (_) => setState(() => isHovered = true),
            onExit: (_) => setState(() => isHovered = false),
            cursor: enabled && onTap != null ? SystemMouseCursors.click : SystemMouseCursors.basic,
            child: GestureDetector(
              onTap: enabled ? onTap : null,
              child: AnimatedScale(
                scale: isHovered && enabled ? 1.05 : 1.0,
                duration: const Duration(milliseconds: 120),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: applyGlow || (isHovered && enabled)
                        ? [BoxShadow(color: effectiveGlowColor.withValues(alpha: 0.30), blurRadius: 12, spreadRadius: 1)]
                        : [],
                  ),
                  child: child,
                ),
              ),
            ),
          );
        },
      );
    }

    return GlassActionIcon(
      size: bubble,
      isInputFieldStyle: false,
      enabled: enabled,
      isActive: isActive,
      color: finalColor,
      glowColor: showGlow ? (glowColor ?? focusColor) : Colors.transparent,
      onTap: onTap,
      child: child,
    );
  }
}

/// NOUVEAU : Raccourcis d'extensions pour simplifier l'écriture dans l'UI
extension GlassInputUtilsExtension on BuildContext {
  Widget buildInputIcon({
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
    bool onlyIcon = false,
    bool isLoading = false,
  }) {
    return GlassInputUtils.buildInputIcon(
      context: this,
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
      onlyIcon: onlyIcon,
      isLoading: isLoading,
    );
  }

  Widget buildInputBubbleWithChild({
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
    bool onlyIcon = false,
  }) {
    return GlassInputUtils.buildInputBubbleWithChild(
      context: this,
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
      onlyIcon: onlyIcon,
    );
  }

  Widget buildInputSeparator({
    required double bubbleSize,
    required bool isActive,
    required bool enabled,
  }) {
    return GlassInputUtils.buildSeparator(
      context: this,
      bubbleSize: bubbleSize,
      isActive: isActive,
      enabled: enabled,
    );
  }
}
