import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:universal_glass/components/surface/glass_surface_container.dart'; // <- IMPORTANT
import 'package:universal_glass/components/toggle/glass_toggle.dart';
import 'package:universal_glass/controllers/glass_panel_controller.dart';
import 'package:universal_glass/enums/glass_enums.dart';
import 'package:universal_glass/utils/glass_theme_extension.dart';

class GlassPreviewToggle extends ConsumerWidget {
  final String label;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final IconData? icon;
  final double? height; // <- AJOUT pour uniformiser avec le Switch
  final GlassStyle? style;
  final GlassShapeType? shape;

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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final glass = ref.watchGlassContext(context);
    final panel = GlassPanelController(ref);
    final bool isSmall = glass.isSmallMobile;

    final double pillHeight = height ?? (isSmall ? 40 : 45);
    final GlassStyle effectiveStyle = style ?? glass.effectiveGlassStyle;
    final GlassShapeType effectiveShape = shape ?? GlassShapeType.stadium;

    return GlassSurfaceContainer(
      style: effectiveStyle, // <- suit la surface
      effects: glass.effects, // <- blur/noise de la surface
      shape: effectiveShape, // <- pill
      isFocused: value, // <- glow quand actif
      enabled: true,
      height: pillHeight,
      onTap: () => onChanged(!value), // <- toute la surface cliquable
      borderRadius: BorderRadius.circular(pillHeight / 2),
      padding: EdgeInsets.symmetric(horizontal: isSmall ? 10 : 12, vertical: 0),
      liftOnHover: glass.theme.enableHover,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(icon, color: panel.textSecondaryColor, size: isSmall ? 15 : 17),
            const SizedBox(width: 6),
          ],
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
                    color: panel.textPrimaryColor,
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
                      color: panel.textTertiaryColor,
                      fontSize: isSmall ? 9.5 : 10.5,
                      height: 1.1,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Le GlassToggle sans label, juste le bouton
          GlassToggle(
            value: value,
            onChanged: onChanged,
            size: isSmall ? GlassToggleSize.small : GlassToggleSize.medium,
            style: GlassToggleStyle.breaker,
            label: null, // <- on gère le label nous même
            subtitle: null,
            enabled: true,
          ),
        ],
      ),
    );
  }
}