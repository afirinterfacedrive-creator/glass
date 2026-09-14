import 'package:flutter/material.dart';

/// ============================================================================
/// GLASS DIALOG ACTION
/// ============================================================================
///
/// Action réutilisable pour [GlassDialog].
///
/// Permet de standardiser les boutons d'action des dialogues.
///
class GlassDialogAction extends StatelessWidget {
  // ==========================================================================
  // PROPRIÉTÉS
  // ==========================================================================

  final String label;

  final VoidCallback? onPressed;

  final Widget? icon;

  final bool isPrimary;
  final bool isDestructive;
  final bool enabled;

  final Color? color;

  // ==========================================================================
  // CONSTRUCTEUR
  // ==========================================================================

  const GlassDialogAction({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.isPrimary = false,
    this.isDestructive = false,
    this.enabled = true,
    this.color,
  });

  // ==========================================================================
  // BUILD
  // ==========================================================================

  @override
  Widget build(BuildContext context) {
    final Color foregroundColor =
        color ??
        (isDestructive
            ? Theme.of(context).colorScheme.error
            : isPrimary
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurface);

    final VoidCallback? callback =
        enabled ? onPressed : null;

    if (isPrimary) {
      return FilledButton.icon(
        onPressed: callback,
        icon: icon ?? const SizedBox.shrink(),
        label: Text(label),
        style: FilledButton.styleFrom(
          foregroundColor: foregroundColor,
        ),
      );
    }

    return TextButton.icon(
      onPressed: callback,
      icon: icon ?? const SizedBox.shrink(),
      label: Text(label),
      style: TextButton.styleFrom(
        foregroundColor: foregroundColor,
      ),
    );
  }
}