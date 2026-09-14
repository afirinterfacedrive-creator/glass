import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:universal_glass/components/surface/glass_surface_container.dart';
import 'package:universal_glass/core/layout/glass_layout_scope.dart';
import 'package:universal_glass/enums/glass_enums.dart';
import 'package:universal_glass/core/layout/glass_layout_context.dart';


/// ============================================================================
/// GLASS PREVIEW SWITCH
/// ============================================================================
///
/// Présentation d'un Switch Material dans une surface Glass.
///
/// Le widget utilise le GlassLayoutContext pour récupérer :
///
/// - la palette de couleurs
/// - la couleur d'accent / focus
/// - le style Glass effectif
/// - les effets du thème
/// - les dimensions responsive
/// - l'état du hover
///
/// Aucune logique Aqua / Classic n'est présente dans ce composant.
///
class GlassPreviewSwitch extends ConsumerWidget {
  // ==========================================================================
  // PROPRIÉTÉS
  // ==========================================================================

  final String label;
  final String? subtitle;

  final bool value;

  final ValueChanged<bool> onChanged;

  final IconData? icon;

  /// Hauteur de la surface.
  final double? height;

  /// Style Glass personnalisé.
  final GlassStyle? style;

  /// Forme personnalisée de la surface.
  final GlassShapeType? shape;

  // ==========================================================================
  // CONSTRUCTEUR
  // ==========================================================================

  const GlassPreviewSwitch({
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
    // COULEURS
    // =========================================================================

    final Color focusColor = glass.focusColor;

    final Color iconColor = glass.palette.textSecondary;

    final Color primaryTextColor = glass.palette.textPrimary;

    final Color tertiaryTextColor = glass.palette.textTertiary;

    final Color inactiveThumbColor = glass.palette.surfaceSecondary;

    final Color inactiveTrackColor = glass.palette.border;

    // =========================================================================
    // SURFACE
    // =========================================================================

    return GlassSurfaceContainer(
      style: effectiveStyle,
      effects: glass.effects,
      shape: effectiveShape,
      isFocused: value,
      enabled: true,
      width: null,
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
            Icon(icon, color: iconColor, size: isSmall ? 15 : 17),
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

                if (subtitle != null)
                  Text(
                    subtitle!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: tertiaryTextColor,
                      fontSize: isSmall ? 9.5 : 10.5,
                      height: 1.1,
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(width: 6),

          // ===================================================================
          // SWITCH
          // ===================================================================
          Transform.scale(
            scale: isSmall ? 0.62 : 0.7,
            child: Switch.adaptive(
              value: value,
              onChanged: onChanged,

              // État actif.
              activeColor: focusColor,
              activeTrackColor: focusColor.withValues(alpha: 0.35),

              // État inactif.
              inactiveThumbColor: inactiveThumbColor,
              inactiveTrackColor: inactiveTrackColor.withValues(alpha: 0.25),

              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,

              trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
            ),
          ),
        ],
      ),
    );
  }
}
