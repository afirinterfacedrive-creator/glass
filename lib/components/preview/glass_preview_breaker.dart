import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:universal_glass/components/glass_breaker_switch.dart';
import 'package:universal_glass/components/surface/glass_surface_container.dart';
import 'package:universal_glass/enums/glass_enums.dart';
import 'package:universal_glass/core/layout/glass_layout_context.dart';
import 'package:universal_glass/core/layout/glass_layout_scope.dart';

/// ============================================================================
/// GLASS PREVIEW BREAKER
/// ============================================================================
///
/// Présentation d'un GlassBreakerSwitch dans une surface Glass.
///
/// Le widget utilise directement le GlassLayoutContext pour récupérer :
///
/// - les couleurs de la palette
/// - la couleur d'accent / focus
/// - le style Glass effectif
/// - les dimensions responsive
/// - les effets du thème
///
/// Il ne contient aucune logique Aqua / Classic.
///
class GlassPreviewBreaker extends ConsumerWidget {
  // ==========================================================================
  // PROPRIÉTÉS
  // ==========================================================================

  final String label;
  final String? subtitle;

  final bool value;

  final ValueChanged<bool> onChanged;

  final IconData? icon;

  final double? height;

  final GlassStyle? style;

  final GlassShapeType? shape;

  // ==========================================================================
  // CONSTRUCTEUR
  // ==========================================================================

  const GlassPreviewBreaker({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.subtitle,
    this.icon = Icons.electric_bolt,
    this.height,
    this.style,
    this.shape,
  });

  // ==========================================================================
  // BUILD
  // ==========================================================================

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GlassLayoutContext glass = GlassLayoutScope.of(context);

    final bool isSmall = glass.isSmallMobile;

    final double pillHeight = height ?? (isSmall ? 40 : 45);

    final GlassStyle effectiveStyle = style ?? glass.effectiveGlassStyle;

    final GlassShapeType effectiveShape = shape ?? GlassShapeType.stadium;

    // =========================================================================
    // COULEURS
    // =========================================================================

    final Color iconColor = value
        ? glass.focusColor
        : glass.palette.textSecondary;

    final Color primaryTextColor = glass.palette.textPrimary;

    final Color secondaryTextColor = glass.palette.textTertiary;

    // =========================================================================
    // OMBRE DE L'ICÔNE
    // =========================================================================

    final List<BoxShadow>? iconShadow = value
        ? [
            BoxShadow(
              color: iconColor.withValues(alpha: 0.9),
              blurRadius: 12,
              spreadRadius: 2,
            ),
            BoxShadow(
              color: iconColor.withValues(alpha: 0.35),
              blurRadius: 24,
              spreadRadius: 6,
            ),
          ]
        : null;

    // =========================================================================
    // SURFACE
    // =========================================================================

    return GlassSurfaceContainer(
      style: effectiveStyle,
      effects: glass.effects,
      shape: effectiveShape,
      isFocused: value,
      enabled: true,
      height: pillHeight,
      onTap: () => onChanged(!value),
      borderRadius: BorderRadius.circular(pillHeight / 2),
      padding: EdgeInsets.symmetric(horizontal: isSmall ? 10 : 12, vertical: 0),
      liftOnHover: glass.theme.enableHover,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ===================================================================
          // ICÔNE
          // ===================================================================
          if (icon != null) ...[
            AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOut,
              child: Icon(
                icon,
                color: iconColor,
                size: isSmall ? 15 : 17,
                shadows: iconShadow,
              ),
            ),
            const SizedBox(width: 6),
          ],

          // ===================================================================
          // TEXTE
          // ===================================================================
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: primaryTextColor,
                    fontSize: isSmall ? 11.5 : 12.5,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.1,
                    height: 1.0,
                  ),
                ),
                Text(
                  subtitle ?? (value ? 'ON' : 'OFF'),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: secondaryTextColor,
                    fontSize: isSmall ? 9.5 : 10.5,
                    height: 1.1,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          // ===================================================================
          // BREAKER SWITCH
          // ===================================================================
          GlassBreakerSwitch(
            value: value,
            onChanged: onChanged,
            width: 70,
            height: pillHeight * 0.8,
          ),
        ],
      ),
    );
  }
}
