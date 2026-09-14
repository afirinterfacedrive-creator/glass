import 'package:flutter/material.dart';

import 'glass_scale_engine.dart';

/// ============================================================================
/// GLASS SCALE SCOPE
/// ============================================================================
///
/// Fournit le niveau de zoom global à l'arbre Universal Glass.
///
/// IMPORTANT
/// -----------------------------------------------------------------------------
///
/// Ce scope NE transforme PLUS visuellement son child.
///
/// Ancienne architecture :
///
/// GlassScaleScope
///     ↓
/// SizedBox logique
///     ↓
/// Transform.scale
///     ↓
/// Scaffold
///
/// Cette architecture provoquait des conflits entre :
///
/// - contraintes Flutter
/// - MediaQuery
/// - AppBar
/// - hit-test
/// - GlassLayoutContext
/// - contenu scrollable
///
/// Nouvelle architecture :
///
/// GlassScaleScope
///     ↓
/// GlassScaleData
///     ↓
/// GlassLayoutContext
///
/// Le zoom est maintenant consommé explicitement par les composants via :
///
///     context.glassLayout.size(...)
///     context.glassLayout.spacing(...)
///     context.glassLayout.fontSize(...)
///     context.glassLayout.radius(...)
///
/// L'AppBar conserve ainsi un système de coordonnées Flutter normal.
/// ============================================================================

class GlassScaleScope extends StatelessWidget {
  final double scale;
  final Widget child;

  const GlassScaleScope({
    super.key,
    required this.scale,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final double safeScale =
        GlassScaleEngine.normalize(scale);

    final GlassScaleData data =
        GlassScaleData(
      scale: safeScale,
    );

    return GlassScale(
      data: data,
      child: child,
    );
  }
}