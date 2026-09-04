import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:universal_glass/controllers/glass_panel_controller.dart';

/// ============================================================================
/// GLASS PREVIEW LABEL
/// ============================================================================
/// Label de section pour les previews.
/// Style cohérent avec le theme glass actuel.
/// ============================================================================

class GlassPreviewLabel extends ConsumerWidget {
  final String text;
  final IconData? icon;
  final TextStyle? style;

  const GlassPreviewLabel(
    this.text, {
    super.key,
    this.icon,
    this.style,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final panel = GlassPanelController(ref);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(icon, color: panel.accentColor, size: 16),
          const SizedBox(width: 6),
        ],
        Text(
          text,
          style: style ??
              TextStyle(
                color: panel.textPrimaryColor,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
        ),
      ],
    );
  }
}