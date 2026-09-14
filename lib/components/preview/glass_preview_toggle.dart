import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:universal_glass/components/surface/glass_surface_container.dart';
import 'package:universal_glass/components/toggle/glass_toggle.dart';
import 'package:universal_glass/enums/glass_enums.dart';
import 'package:universal_glass/core/layout/glass_layout_context.dart';
import 'package:universal_glass/core/layout/glass_layout_scope.dart';

/// ============================================================================
/// GLASS PREVIEW TOGGLE
/// ============================================================================
///
/// Présentation d'un GlassToggle dans une surface Glass.
///
/// Le widget utilise le GlassLayoutContext pour récupérer :
///
/// - la palette de couleurs
/// - le style Glass effectif
/// - les effets du thème
/// - les dimensions responsive
/// - l'état du hover
///
/// Il ne contient aucune logique Aqua / Classic.
///
class GlassPreviewToggle extends ConsumerWidget {
  // ==========================================================================
  // PROPRIÉTÉS
  // ==========================================================================

  final String label;
  final String? subtitle;

  final bool value;

  final ValueChanged<bool> onChanged;

  final IconData? icon;

  /// Hauteur personnalisée de la surface.
  final double? height;

  /// Style Glass personnalisé.
  final GlassStyle? style;

  /// Forme personnalisée de la surface.
  final GlassShapeType? shape;

  // ==========================================================================
  // CONSTRUCTEUR
  // ==========================================================================

  const GlassPreviewToggle({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.subtitle,
    this.icon,
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

    // =========================================================================
    // DIMENSIONS
    // =========================================================================

    final double pillHeight = height ?? (isSmall ? 40 : 45);

    // =========================================================================
    // STYLE
    // =========================================================================

    final GlassStyle effectiveStyle = style ?? glass.effectiveGlassStyle;

    final GlassShapeType effectiveShape = shape ?? GlassShapeType.stadium;

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
            Icon(
              icon,
              color: glass.palette.textSecondary,
              size: isSmall ? 15 : 17,
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
                    color: glass.palette.textPrimary,
                    fontSize: isSmall ? 11.5 : 12.5,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.1,
                    height: 1.0,
                  ),
                ),

                if (subtitle != null)
                  Text(
                    subtitle!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: glass.palette.textTertiary,
                      fontSize: isSmall ? 9.5 : 10.5,
                      height: 1.1,
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // ===================================================================
          // TOGGLE
          // ===================================================================
          GlassToggle(
            value: value,
            onChanged: onChanged,
            size: isSmall ? GlassToggleSize.small : GlassToggleSize.medium,
            style: GlassToggleStyle.breaker,
            label: null,
            subtitle: null,
            enabled: true,
          ),
        ],
      ),
    );
  }
}
