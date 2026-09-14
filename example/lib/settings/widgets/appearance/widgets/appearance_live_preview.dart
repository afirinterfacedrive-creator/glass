
import 'package:flutter/material.dart';

import 'package:universal_glass/glass.dart';

import '../appearance_mode_config.dart';

/// ============================================================================
/// APPEARANCE LIVE PREVIEW
/// ============================================================================
///
/// Aperçu en direct du mode d'apparence sélectionné.
///
/// Responsabilités :
///
/// - afficher le fond correspondant au mode ;
/// - afficher un AppBar Glass ;
/// - afficher un champ de recherche ;
/// - afficher une carte Glass ;
/// - utiliser la palette correspondant au mode.
///
/// Ce widget :
///
/// - ne connaît pas Riverpod ;
/// - ne sauvegarde rien ;
/// - ne modifie pas AppearanceSettings ;
/// - ne contient aucune logique de persistance.
///
/// Flux :
///
/// AppearanceSection
///       ↓
/// AppearanceLivePreview
///       ↓
/// AppearanceModeConfig
///       ↓
/// GlassContainer
///
/// ============================================================================

class AppearanceLivePreview extends StatelessWidget {
  // ==========================================================================
  // PROPRIÉTÉS
  // ==========================================================================

  /// Mode actuellement sélectionné.
  final AppThemeMode mode;

  /// Palette de couleurs du thème.
  final GlassColorPalette palette;

  /// Couleurs personnalisées du mode Aqua.
  final List<Color> aquaColors;

  /// Couleurs personnalisées du mode Classic.
  final List<Color> classicColors;

  // ==========================================================================
  // CONSTRUCTEUR
  // ==========================================================================

  const AppearanceLivePreview({
    super.key,
    required this.mode,
    required this.palette,
    required this.aquaColors,
    required this.classicColors,
  });

  // ==========================================================================
  // CONFIGURATION DU MODE
  // ==========================================================================

  AppearanceModeConfig get config {
    return AppearanceModeConfig.fromMode(mode);
  }

  // ==========================================================================
  // STYLE GLASS
  // ==========================================================================

  GlassStyle get glassStyle {
    return config.glassStyle;
  }

  // ==========================================================================
  // COULEURS DU FOND
  // ==========================================================================

  List<Color> get background {
    switch (mode) {
      // ----------------------------------------------------------------------
      // AQUA
      // ----------------------------------------------------------------------

      case AppThemeMode.aqua:
        return aquaColors.isNotEmpty
            ? aquaColors
            : config.defaultBackground;

      // ----------------------------------------------------------------------
      // CLASSIC
      // ----------------------------------------------------------------------

      case AppThemeMode.classic:
        return classicColors.isNotEmpty
            ? classicColors
            : config.defaultBackground;

      // ----------------------------------------------------------------------
      // LIGHT / DARK / SYSTEM
      // ----------------------------------------------------------------------

      case AppThemeMode.light:
      case AppThemeMode.dark:
      case AppThemeMode.system:
        return config.defaultBackground;
    }
  }

  // ==========================================================================
  // GRADIENT DU FOND
  // ==========================================================================

  Gradient get backgroundGradient {
    final colors = background;

    if (colors.length == 1) {
      return LinearGradient(
        colors: [
          colors.first,
          colors.first,
        ],
      );
    }

    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: colors,
    );
  }

  // ==========================================================================
  // BUILD
  // ==========================================================================

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          gradient: backgroundGradient,
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildAppBarPreview(),

            const SizedBox(height: 12),

            _buildSearchPreview(),

            const SizedBox(height: 12),

            _buildCardPreview(),
          ],
        ),
      ),
    );
  }

  // ==========================================================================
  // APP BAR PREVIEW
  // ==========================================================================

  Widget _buildAppBarPreview() {
    return GlassContainer(
      style: glassStyle,
      borderRadius: BorderRadius.circular(16),
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 12,
      ),
      child: Row(
        children: [
          Icon(
            Icons.arrow_back_rounded,
            color: palette.textPrimary,
            size: 20,
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              'Titre AppBar',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: palette.textPrimary,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ),

          const SizedBox(width: 8),

          Icon(
            Icons.more_vert_rounded,
            color: palette.textPrimary,
            size: 20,
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // SEARCH PREVIEW
  // ==========================================================================

  Widget _buildSearchPreview() {
    return GlassContainer(
      style: GlassStyle.transparentAqua,
      borderRadius: BorderRadius.circular(14),
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 14,
      ),
      child: Row(
        children: [
          Icon(
            Icons.search_rounded,
            color: palette.textSecondary,
            size: 18,
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Text(
              'Rechercher...',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: palette.textSecondary.withOpacity(0.7),
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // CARD PREVIEW
  // ==========================================================================

  Widget _buildCardPreview() {
    return GlassContainer(
      style: glassStyle,
      borderRadius: BorderRadius.circular(14),
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Icon(
            config.icon,
            color: palette.textPrimary,
            size: 18,
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Text(
              'Carte Glass — ${config.label}',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: palette.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
