import 'package:flutter/material.dart';

import 'package:universal_glass/core/layout/glass_layout_context.dart';
import 'package:universal_glass/core/layout/glass_layout_scope.dart';

/// ============================================================================
/// GLASS RESPONSIVE GRID
/// ============================================================================
///
/// Grille responsive basée sur le contexte de layout Glass.
///
/// Responsabilités :
///
/// - déterminer le nombre de colonnes ;
/// - utiliser les breakpoints définis par GlassLayoutContext ;
/// - calculer la largeur réelle disponible ;
/// - distribuer les widgets dans un Wrap.
///
/// Les breakpoints ne sont volontairement PAS configurables directement
/// dans cette grille.
///
/// Ils proviennent de GlassDisplaySettings -> GlassLayoutContext.
///
/// Les colonnes restent configurables par grille, car chaque grille peut
/// avoir un besoin différent.
///
/// Exemple :
///
/// GlassResponsiveGrid(
///   mobileColumns: 1,
///   tabletColumns: 2,
///   desktopColumns: 4,
///   children: [...],
/// )
///
/// ============================================================================

class GlassResponsiveGrid extends StatelessWidget {
  // ==========================================================================
  // PROPRIÉTÉS
  // ==========================================================================

  /// Widgets à afficher dans la grille.
  final List<Widget> children;

  /// Espacement horizontal entre les éléments.
  final double spacing;

  /// Espacement vertical entre les lignes.
  final double runSpacing;

  /// Nombre de colonnes sur mobile.
  final int mobileColumns;

  /// Nombre de colonnes sur tablette.
  final int tabletColumns;

  /// Nombre de colonnes sur desktop.
  final int desktopColumns;

  /// Si true, chaque élément occupe toute la largeur de sa cellule.
  ///
  /// Si false, les éléments conservent leur largeur intrinsèque.
  final bool expandItems;

  // ==========================================================================
  // CONSTRUCTEUR
  // ==========================================================================

  const GlassResponsiveGrid({
    super.key,
    required this.children,
    this.spacing = 16.0,
    this.runSpacing = 16.0,
    this.mobileColumns = 1,
    this.tabletColumns = 2,
    this.desktopColumns = 4,
    this.expandItems = true,
  });

  // ==========================================================================
  // BUILD
  // ==========================================================================

  @override
  Widget build(BuildContext context) {
    final GlassLayoutContext layout =
        GlassLayoutScope.of(context);

    return LayoutBuilder(
      builder: (
        BuildContext context,
        BoxConstraints constraints,
      ) {
        final double availableWidth =
            _resolveAvailableWidth(
          constraints,
          layout,
        );

        final int columns =
            _resolveColumns(layout);

        final double itemWidth =
            _resolveItemWidth(
          availableWidth: availableWidth,
          columns: columns,
        );

        return Wrap(
          spacing: spacing,
          runSpacing: runSpacing,
          alignment: WrapAlignment.start,
          crossAxisAlignment: WrapCrossAlignment.start,
          children: children.map((Widget child) {
            if (expandItems) {
              return SizedBox(
                width: itemWidth,
                child: child,
              );
            }

            return IntrinsicWidth(
              child: child,
            );
          }).toList(),
        );
      },
    );
  }

  // ==========================================================================
  // LARGEUR DISPONIBLE
  // ==========================================================================

  double _resolveAvailableWidth(
    BoxConstraints constraints,
    GlassLayoutContext layout,
  ) {
    double width = constraints.maxWidth;

    if (!width.isFinite || width <= 0.0) {
      width = layout.effectiveMaxWidth;
    }

    if (!width.isFinite || width <= 0.0) {
      width = 500.0;
    }

    return width;
  }

  // ==========================================================================
  // COLONNES
  // ==========================================================================

  int _resolveColumns(
    GlassLayoutContext layout,
  ) {
    if (layout.isLargeDesktop || layout.isDesktop) {
      return _safeColumns(desktopColumns);
    }

    if (layout.isTablet) {
      return _safeColumns(tabletColumns);
    }

    return _safeColumns(mobileColumns);
  }

  // ==========================================================================
  // LARGEUR DES CELLULES
  // ==========================================================================

  double _resolveItemWidth({
    required double availableWidth,
    required int columns,
  }) {
    if (columns <= 1) {
      return availableWidth;
    }

    final double totalSpacing =
        spacing * (columns - 1);

    final double width =
        availableWidth - totalSpacing;

    if (width <= 0.0) {
      return 10.0;
    }

    return width / columns;
  }

  // ==========================================================================
  // SÉCURITÉ
  // ==========================================================================

  int _safeColumns(int value) {
    return value.clamp(1, 100).toInt();
  }
}