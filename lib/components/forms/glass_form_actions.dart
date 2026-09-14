
import 'package:flutter/material.dart';

/// ============================================================================
/// GLASS FORM ACTIONS
/// ============================================================================
///
/// Barre d'actions pour les formulaires Glass.
///
/// Exemple :
///
/// ```dart
/// GlassFormActions(
///   children: [
///     TextButton(...),
///     UniversalGlassButton(...),
///   ],
/// )
/// ```
///
/// Ce widget est volontairement indépendant du thème Glass.
/// Il gère uniquement la disposition des actions.
///
class GlassFormActions extends StatelessWidget {
  // ==========================================================================
  // PROPRIÉTÉS
  // ==========================================================================

  final List<Widget> children;

  final MainAxisAlignment alignment;

  final double spacing;

  final double runSpacing;

  final EdgeInsetsGeometry padding;

  // ==========================================================================
  // CONSTRUCTEUR
  // ==========================================================================

  const GlassFormActions({
    super.key,
    required this.children,
    this.alignment = MainAxisAlignment.end,
    this.spacing = 10,
    this.runSpacing = 8,
    this.padding = EdgeInsets.zero,
  });

  // ==========================================================================
  // BUILD
  // ==========================================================================

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Wrap(
        alignment: _wrapAlignment,
        spacing: spacing,
        runSpacing: runSpacing,
        children: children,
      ),
    );
  }

  // ==========================================================================
  // WRAP ALIGNMENT
  // ==========================================================================

  WrapAlignment get _wrapAlignment {
    switch (alignment) {
      case MainAxisAlignment.start:
        return WrapAlignment.start;

      case MainAxisAlignment.center:
        return WrapAlignment.center;

      case MainAxisAlignment.end:
        return WrapAlignment.end;

      case MainAxisAlignment.spaceBetween:
        return WrapAlignment.spaceBetween;

      case MainAxisAlignment.spaceAround:
        return WrapAlignment.spaceAround;

      case MainAxisAlignment.spaceEvenly:
        return WrapAlignment.spaceEvenly;
    }
  }
}
