
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:universal_glass/glass.dart';
import 'package:universal_glass_example/home/widgets/glass_style_gallery/glass_style_grid_item.dart';
import 'package:universal_glass_example/home/widgets/glass_style_gallery/glass_style_live_preview.dart';

import 'glass_style_gallery_helpers.dart';
import 'glass_style_settings_panel.dart';

class GlassStyleGallery extends ConsumerWidget {
  const GlassStyleGallery({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final GlassThemeState theme = ref.watch(
      glassThemeProvider,
    );

    final GlassColorProvider colorProvider = ref.watch(
      glassColorProvider,
    );

    final GlassColorPalette palette =
        colorProvider.palette;

    final GlassThemeNotifier notifier = ref.read(
      glassThemeProvider.notifier,
    );

    return GlassScaffold(
      title: 'Glass Style Gallery',
      subtitle: 'GLASS STYLE SYSTEM',
      showLogo: true,
      showBackButton: true,
      hideNavigation: true,
      blur: theme.effectiveBlur,
      noise: theme.effectiveNoise,
      maxWidth: 1400.0,
      child: Builder(
        builder: (BuildContext context) {
          final GlassLayoutContext glass =
              GlassLayoutScope.of(context);

          // ==============================================================
          // COULEURS
          // ==============================================================

          final Color textColor =
              palette.textPrimary;

          final Color accentColor =
              palette.aqua;

          // ==============================================================
          // RESPONSIVE
          // ==============================================================

          final bool isMobile =
              glass.isSmallMobile ||
              glass.isMobile;

          final int columns;

          if (glass.isDesktop ||
              glass.isLargeDesktop) {
            columns = 3;
          } else if (glass.isTablet) {
            columns = 2;
          } else {
            columns = 1;
          }

          return SingleChildScrollView(
            physics:
                const BouncingScrollPhysics(),
            padding:
                glass.dynamicPadding,
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.stretch,
              children: [
                // ========================================================
                // ACTION RESET
                // ========================================================

                Align(
                  alignment:
                      Alignment.centerRight,
                  child:
                      UniversalGlassButton(
  buttonId: 'glass_style_gallery_reset',
  height: glass.controlHeight(44.0),
  effects: glass.effects,
  shape: GlassShapeType.pill,
  style: GlassStyle.transparentAqua,
  label: 'Réinitialiser',
  icon: Icons.restart_alt_rounded,
  iconSize: glass.size(20.0),
  futureOnTap: () async { // <- ENLEVE (ref)
    await notifier.reset();
  },
),
                ),

                SizedBox(
                  height:
                      glass.spacing(16.0),
                ),

                // ========================================================
                // LIVE PREVIEW
                // ========================================================

                _buildLivePreview(
                  glass: glass,
                  theme: theme,
                  isMobile: isMobile,
                ),

                SizedBox(
                  height:
                      glass.spacing(24.0),
                ),

                Divider(
                  color:
                      palette.border.withValues(
                    alpha: 0.20,
                  ),
                  height:
                      glass.size(1.0),
                  thickness:
                      glass.size(1.0),
                ),

                SizedBox(
                  height:
                      glass.spacing(24.0),
                ),

                // ========================================================
                // TITRE
                // ========================================================

                Text(
                  'Styles disponibles',
                  style: TextStyle(
                    fontSize:
                        glass.fontSize(
                      18.0,
                    ),
                    fontWeight:
                        FontWeight.w700,
                    color:
                        palette.textPrimary,
                  ),
                ),

                SizedBox(
                  height:
                      glass.spacing(6.0),
                ),

                Text(
                  'Sélectionnez un style pour modifier '
                  'le rendu Glass en temps réel.',
                  style: TextStyle(
                    fontSize:
                        glass.fontSize(
                      13.0,
                    ),
                    color:
                        palette.textSecondary,
                  ),
                ),

                SizedBox(
                  height:
                      glass.spacing(16.0),
                ),

                // ========================================================
                // STYLE GRID
                // ========================================================

                _buildPresetGrid(
                  glass: glass,
                  theme: theme,
                  palette: palette,
                  notifier: notifier,
                  columns: columns,
                ),

                SizedBox(
                  height:
                      glass.spacing(28.0),
                ),

                // ========================================================
                // SETTINGS PANEL
                // ========================================================

                GlassStyleSettingsPanel(
                  theme: theme,
                  notifier: notifier,
                  textColor: textColor,
                  accentColor: accentColor,
                  isMobile: isMobile,
                ),

                SizedBox(
                  height:
                      glass.spacing(36.0),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ==========================================================================
// LIVE PREVIEW
// ==========================================================================

Widget _buildLivePreview({
  required GlassLayoutContext glass,
  required GlassThemeState theme,
  required bool isMobile,
}) {
  final GlassStyle style =
      theme.glassStyle;

  final String description =
      'Blur: ${theme.effectiveBlur.toInt()}'
      '  •  Opacité: '
      '${theme.surfaceOpacity.toStringAsFixed(2)}'
      '  •  '
      '${theme.enableBlur ? "Blur actif" : "Blur désactivé"}';

  final IconData icon =
      theme.breakerOn
          ? Icons.power_off_rounded
          : GlassStyleGalleryHelpers
              .getStyleIcon(style);

  return Padding(
    padding: EdgeInsets.symmetric(
      horizontal:
          isMobile
              ? glass.spacing(4.0)
              : glass.spacing(8.0),
      vertical:
          glass.spacing(8.0),
    ),
    child: GlassStyleLivePreview(
      theme: theme,
      isMobile: isMobile,
      title:
          GlassStyleGalleryHelpers
              .getStyleNameFormatted(
        style,
      ),
      description:
          description,
      icon: icon,
    ),
  );
}

// ==========================================================================
// STYLE GRID
// ==========================================================================

Widget _buildPresetGrid({
  required GlassLayoutContext glass,
  required GlassThemeState theme,
  required GlassColorPalette palette,
  required GlassThemeNotifier notifier,
  required int columns,
}) {
  // =========================================================================
  // IMPORTANT :
  //
  // La hauteur des éléments est centralisée ici.
  //
  // GlassStyleGridItem ne définit PAS de hauteur concurrente.
  //
  // La grille impose :
  //
  //     mainAxisExtent = 184 px
  //
  // =========================================================================

  final double itemHeight =
      glass.size(184.0);

  final double spacing =
      glass.spacing(16.0);

  return GridView.builder(
    shrinkWrap: true,
    physics:
        const NeverScrollableScrollPhysics(),
    itemCount:
        GlassStyle.values.length,
    gridDelegate:
        SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount:
          columns,
      crossAxisSpacing:
          spacing,
      mainAxisSpacing:
          spacing,
      mainAxisExtent:
          itemHeight,
    ),
    itemBuilder: (
      BuildContext context,
      int index,
    ) {
      final GlassStyle style =
          GlassStyle.values[index];

      final bool isActive =
          theme.glassStyle == style;

      // ================================================================
      // STYLE → COULEUR D'ACCENT
      // ================================================================

      final Color accentColor =
          _getStyleAccentColor(
        style: style,
        palette: palette,
      );

      return GlassStyleGridItem(
        style: style,
        isActive: isActive,
        enableHover:
            theme.enableHover,

        title:
            GlassStyleGalleryHelpers
                .getStyleNameFormatted(
          style,
        ),

        description:
            GlassStyleGalleryHelpers
                .getStyleDescription(
          style,
        ),

        icon:
            GlassStyleGalleryHelpers
                .getStyleIcon(
          style,
        ),

        index: index,

        // ==============================================================
        // COULEUR SÉMANTIQUE DU STYLE
        // ==============================================================

        accentColor:
            accentColor,

        // ==============================================================
        // COULEURS NEUTRES DE LA PALETTE
        //
        // Ces couleurs sont fournies par GlassColorProvider
        // via GlassColorPalette.
        // ==============================================================

        textPrimary:
            palette.textPrimary,

        textSecondary:
            palette.textSecondary,

        textTertiary:
            palette.textTertiary,

        border:
            palette.border,

        // ==============================================================
        // ACTION
        // ==============================================================

        onTap: () {
          if (isActive) {
            return;
          }

          notifier.setGlassStyle(
            style,
          );
        },
      );
    },
  );
}

// ==========================================================================
// STYLE → PALETTE
// ==========================================================================
//
// Cette méthode est le point central de correspondance entre le style
// graphique et la palette utilisateur.
//
// IMPORTANT :
// GlassStyleGridItem ne connaît PAS GlassColorProvider.
//
// Il reçoit uniquement la couleur dont il a besoin.
//
// ==========================================================================

Color _getStyleAccentColor({
  required GlassStyle style,
  required GlassColorPalette palette,
}) {
  switch (style) {
    // ----------------------------------------------------------------------
    // AQUA
    // ----------------------------------------------------------------------

    case GlassStyle.transparentAqua:
    case GlassStyle.solidAqua:
    case GlassStyle.gradientOpaque:
    case GlassStyle.customGradient:
      return palette.aqua;

    // ----------------------------------------------------------------------
    // COULEURS SÉMANTIQUES
    // ----------------------------------------------------------------------

    case GlassStyle.transparentRed:
      return palette.error;

    case GlassStyle.transparentGreen:
      return palette.success;

    // ----------------------------------------------------------------------
    // CLASSIC
    // ----------------------------------------------------------------------

    case GlassStyle.classicSb:
    case GlassStyle.solidClassic:
    case GlassStyle.opaqueMat:
    case GlassStyle.opaqueHeavy:
    case GlassStyle.custom:
      return palette.classic;
  }
}
