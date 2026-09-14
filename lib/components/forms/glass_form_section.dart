import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:universal_glass/core/layout/glass_layout_context.dart';
import 'package:universal_glass/core/layout/glass_layout_scope.dart';

/// ============================================================================
/// GLASS FORM SECTION
/// ============================================================================
///
/// Section visuelle d'un formulaire Glass.
///
/// Peut afficher :
///
/// - un titre ;
/// - une description ;
/// - une icône ;
/// - plusieurs champs.
///
class GlassFormSection extends ConsumerWidget {
  // ==========================================================================
  // PROPRIÉTÉS
  // ==========================================================================

  final String? title;
  final String? subtitle;

  final IconData? icon;

  final List<Widget> children;

  final double spacing;

  final EdgeInsetsGeometry padding;

  // ==========================================================================
  // CONSTRUCTEUR
  // ==========================================================================

  const GlassFormSection({
    super.key,
    this.title,
    this.subtitle,
    this.icon,
    required this.children,
    this.spacing = 14,
    this.padding = EdgeInsets.zero,
  });

  // ==========================================================================
  // BUILD
  // ==========================================================================

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GlassLayoutContext glass = GlassLayoutScope.of(context);

    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (title != null || subtitle != null || icon != null)
            _buildHeader(glass),

          if (title != null || subtitle != null || icon != null)
            SizedBox(height: spacing),

          ..._buildChildren(),
        ],
      ),
    );
  }

  // ==========================================================================
  // HEADER
  // ==========================================================================

  Widget _buildHeader(GlassLayoutContext glass) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (icon != null) ...[
          Icon(icon, color: glass.focusColor, size: 21),
          const SizedBox(width: 10),
        ],

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title != null)
                Text(
                  title!,
                  style: TextStyle(
                    color: glass.palette.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),

              if (subtitle != null) ...[
                const SizedBox(height: 3),
                Text(
                  subtitle!,
                  style: TextStyle(
                    color: glass.palette.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  // ==========================================================================
  // CHILDREN
  // ==========================================================================

  List<Widget> _buildChildren() {
    final List<Widget> result = [];

    for (int i = 0; i < children.length; i++) {
      if (i > 0) {
        result.add(SizedBox(height: spacing));
      }

      result.add(children[i]);
    }

    return result;
  }
}
