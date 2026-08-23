import 'package:flutter/material.dart';

import 'package:universal_glass/glass_exports.dart';

// ============================================================================
// CONTROL PANEL THEME CARD
// ============================================================================
//
// Carte de visualisation du thème Glass actuellement actif.
//
// RESPONSABILITÉS
//
// - recevoir GlassThemeState
// - afficher visuellement le style actif
// - transmettre les effets à ThemeGlassCard
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
// - logique des effets
//
// Le changement du thème est centralisé dans SettingsPage.
//
// ============================================================================

class ControlPanelThemeCard extends StatelessWidget {
  final GlassThemeState theme;

  const ControlPanelThemeCard({super.key, required this.theme});

  @override
  Widget build(BuildContext context) {
    return ThemeGlassCard(
      // ======================================================================
      // EFFETS GLASS
      // ======================================================================
      effects: theme.effects,

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
