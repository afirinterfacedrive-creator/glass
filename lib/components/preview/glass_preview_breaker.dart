import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:universal_glass/components/glass_breaker_switch.dart';
import 'package:universal_glass/components/surface/glass_surface_container.dart';
import 'package:universal_glass/controllers/glass_panel_controller.dart';
import 'package:universal_glass/enums/glass_enums.dart';
import 'package:universal_glass/utils/glass_theme_extension.dart';

class GlassPreviewBreaker extends ConsumerWidget {
  final String label;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final IconData? icon;
  final double? height;
  final GlassStyle? style;
  final GlassShapeType? shape;

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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final glass = ref.watchGlassContext(context);
    final panel = GlassPanelController(ref);
    final bool isSmall = glass.isSmallMobile;
    final bool useAqua = glass.theme.useAquaStyle;

    final double pillHeight = height ?? (isSmall ? 40 : 45);
    final GlassStyle effectiveStyle = style ?? glass.effectiveGlassStyle;
    final GlassShapeType effectiveShape = shape ?? GlassShapeType.stadium;

    final Color iconColor = value 
        ? (useAqua ? Colors.cyanAccent : Colors.orangeAccent)
        : panel.textSecondaryColor;
    
    final List<BoxShadow>? iconShadow = value ? [
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
    ] : null;

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
                Text(
                  subtitle ?? (value ? 'ON' : 'OFF'),
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
          const SizedBox(width: 10),
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