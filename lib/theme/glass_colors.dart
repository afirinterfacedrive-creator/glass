import 'package:flutter/material.dart';

import 'glass_color_theme.dart';

/// ============================================================================
/// GLASS COLORS
/// ============================================================================
///
/// Centralisation des palettes Glass.
///
/// IMPORTANT
///
/// Les composants ne doivent pas utiliser directement :
///
///     Colors.cyanAccent
///     Colors.orangeAccent
///     Colors.white54
///
/// Ils doivent utiliser la palette active.
///
/// ============================================================================

class GlassColors {
  GlassColors._();

  // ==========================================================================
  // AQUA
  // ==========================================================================

  static const GlassColorTheme aqua =
      GlassColorTheme(
    name: 'Aqua',

    // ------------------------------------------------------------------------
    // ACCENT
    // ------------------------------------------------------------------------

    accent:
        Color(0xFF64E8FF),

    accentBright:
        Color(0xFFB8F7FF),

    accentDark:
        Color(0xFF0097B2),

    // ------------------------------------------------------------------------
    // TEXTE
    // ------------------------------------------------------------------------

    textPrimary:
        Color(0xFFF5FCFF),

    textSecondary:
        Color(0xFFC5DCE2),

    textMuted:
        Color(0xFF8EAAB2),

    textDisabled:
        Color(0xFF64777C),

    // ------------------------------------------------------------------------
    // GLASS
    // ------------------------------------------------------------------------

    glassLight:
        Color(0x1FFFFFFF),

    glassDark:
        Color(0x14000000),

    glassBorder:
        Color(0x2AFFFFFF),

    glassBorderActive:
        Color(0x9964E8FF),

    glassBorderHover:
        Color(0x6664E8FF),

    // ------------------------------------------------------------------------
    // INPUT
    // ------------------------------------------------------------------------

    inputBackground:
        Color(0x0DFFFFFF),

    inputBackgroundFocus:
        Color(0x1464E8FF),

    inputBorder:
        Color(0x26FFFFFF),

    inputBorderFocus:
        Color(0xB364E8FF),

    inputHint:
        Color(0x8095B8BF),

    inputIcon:
        Color(0xFF9DDDE8),

    // ------------------------------------------------------------------------
    // CARD
    // ------------------------------------------------------------------------

    cardBackground:
        Color(0x14FFFFFF),

    cardBackgroundSecondary:
        Color(0x0964E8FF),

    cardBorder:
        Color(0x2AFFFFFF),

    // ------------------------------------------------------------------------
    // STATES
    // ------------------------------------------------------------------------

    success:
        Color(0xFF5FE3A1),

    warning:
        Color(0xFFFFC857),

    error:
        Color(0xFFFF6B81),

    info:
        Color(0xFF64C7FF),

    // ------------------------------------------------------------------------
    // SHADOW
    // ------------------------------------------------------------------------

    shadow:
        Color(0x66000000),
  );

  // ==========================================================================
  // CLASSIC
  // ==========================================================================

  static const GlassColorTheme classic =
      GlassColorTheme(
    name: 'Classic',

    // ------------------------------------------------------------------------
    // ACCENT
    // ------------------------------------------------------------------------

    accent:
        Color(0xFFFFB45C),

    accentBright:
        Color(0xFFFFD59A),

    accentDark:
        Color(0xFFD97918),

    // ------------------------------------------------------------------------
    // TEXTE
    // ------------------------------------------------------------------------

    textPrimary:
        Color(0xFFFFFAF4),

    textSecondary:
        Color(0xFFE1D4C5),

    textMuted:
        Color(0xFFA89B8E),

    textDisabled:
        Color(0xFF6D655D),

    // ------------------------------------------------------------------------
    // GLASS
    // ------------------------------------------------------------------------

    glassLight:
        Color(0x1AFFFFFF),

    glassDark:
        Color(0x18000000),

    glassBorder:
        Color(0x2BFFFFFF),

    glassBorderActive:
        Color(0x99FFB45C),

    glassBorderHover:
        Color(0x66FFB45C),

    // ------------------------------------------------------------------------
    // INPUT
    // ------------------------------------------------------------------------

    inputBackground:
        Color(0x10FFFFFF),

    inputBackgroundFocus:
        Color(0x14FFB45C),

    inputBorder:
        Color(0x2AFFFFFF),

    inputBorderFocus:
        Color(0xB3FFB45C),

    inputHint:
        Color(0x809F9183),

    inputIcon:
        Color(0xFFFFC987),

    // ------------------------------------------------------------------------
    // CARD
    // ------------------------------------------------------------------------

    cardBackground:
        Color(0x16FFFFFF),

    cardBackgroundSecondary:
        Color(0x0BFFB45C),

    cardBorder:
        Color(0x2BFFFFFF),

    // ------------------------------------------------------------------------
    // STATES
    // ------------------------------------------------------------------------

    success:
        Color(0xFF62D99B),

    warning:
        Color(0xFFFFC857),

    error:
        Color(0xFFFF7082),

    info:
        Color(0xFF70BFFF),

    // ------------------------------------------------------------------------
    // SHADOW
    // ------------------------------------------------------------------------

    shadow:
        Color(0x70000000),
  );

  // ==========================================================================
  // DARK
  // ==========================================================================

  static const GlassColorTheme dark =
      GlassColorTheme(
    name: 'Dark',

    accent:
        Color(0xFFB39DFF),

    accentBright:
        Color(0xFFD4C8FF),

    accentDark:
        Color(0xFF7259C9),

    textPrimary:
        Color(0xFFF6F3FF),

    textSecondary:
        Color(0xFFD0CADB),

    textMuted:
        Color(0xFF928A9F),

    textDisabled:
        Color(0xFF625C68),

    glassLight:
        Color(0x18FFFFFF),

    glassDark:
        Color(0x24000000),

    glassBorder:
        Color(0x29FFFFFF),

    glassBorderActive:
        Color(0x99B39DFF),

    glassBorderHover:
        Color(0x66B39DFF),

    inputBackground:
        Color(0x0CFFFFFF),

    inputBackgroundFocus:
        Color(0x14B39DFF),

    inputBorder:
        Color(0x26FFFFFF),

    inputBorderFocus:
        Color(0xB3B39DFF),

    inputHint:
        Color(0x809A91A4),

    inputIcon:
        Color(0xFFC5B8FF),

    cardBackground:
        Color(0x12FFFFFF),

    cardBackgroundSecondary:
        Color(0x0BB39DFF),

    cardBorder:
        Color(0x29FFFFFF),

    success:
        Color(0xFF63DDA2),

    warning:
        Color(0xFFFFC857),

    error:
        Color(0xFFFF7082),

    info:
        Color(0xFF78BFFF),

    shadow:
        Color(0x80000000),
  );
}