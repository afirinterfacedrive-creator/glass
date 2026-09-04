
import 'package:flutter/material.dart';

import 'package:universal_glass/glass_exports.dart';
import 'package:universal_glass/theme/glass_color_palette.dart';

// ============================================================================
// CONTROL PANEL THEME CARD
// ============================================================================
//
// Carte de visualisation du thème Glass actuellement actif.
//
// RESPONSABILITÉS
//
// - recevoir GlassThemeState
// - recevoir GlassColorPalette
// - afficher visuellement le style actif
// - construire les effets Glass à partir de la palette
// - transmettre thème + palette + effets à ThemeGlassCard
// - afficher la forme Glass choisie
//
// NE GÈRE PAS
//
// - Riverpod
// - modification du thème
// - toggle Aqua
// - navigation
// - Scaffold
// - AppBar
// - persistance
//
// ============================================================================

class ControlPanelThemeCard extends StatelessWidget {
  // ==========================================================================
  // ÉTAT DU THÈME
  // ==========================================================================

  final GlassThemeState theme;

  // ==========================================================================
  // PALETTE
  // ==========================================================================

  final GlassColorPalette palette;

  // ==========================================================================
  // CONSTRUCTEUR
  // ==========================================================================

  const ControlPanelThemeCard({
    super.key,
    required this.theme,
    required this.palette,
  });

  // ==========================================================================
  // EFFETS GLASS
  // ==========================================================================
  //
  // Les effets utilisent maintenant la palette centrale.
  //
  // Aqua    → liquidWhite
  // Classic → liquidDark
  //
  // ==========================================================================

  GlassEffects get _effects {
    return theme.useAquaStyle
        ? GlassEffects.liquidWhite(palette)
        : GlassEffects.liquidDark(palette);
  }

  // ==========================================================================
  // BUILD
  // ==========================================================================

  @override
  Widget build(BuildContext context) {
    return ThemeGlassCard(
      // ======================================================================
      // PALETTE
      // ======================================================================

      palette: palette,

      // ======================================================================
      // EFFETS GLASS
      // ======================================================================

      effects: _effects,

      // ======================================================================
      // FORME
      // ======================================================================

      shape: GlassShapeType.pillHorizontal,

      // ======================================================================
      // STYLE
      // ======================================================================

      style: theme.style,

      // ======================================================================
      // DIMENSIONS
      // ======================================================================

      width: 260,
      height: 45,

      // ======================================================================
      // ICÔNE
      // ======================================================================

      iconSizePercent: 60,

      // ======================================================================
      // ESPACEMENT
      // ======================================================================

      horizontalPadding: 8,
      spacing: 6,
    );
  }
}

