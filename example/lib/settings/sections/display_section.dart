import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:universal_glass/glass.dart';


// ============================================================================
// DISPLAY SECTION
// ============================================================================
//
// RESPONSABILITÉ
// -----------------------------------------------------------------------------
// Gestion des paramètres globaux d'affichage de Universal Glass.
//
// Paramètres :
//
//   • Zoom
//   • Largeur maximale
//   • Breakpoint tablette
//   • Breakpoint desktop
//   • Padding desktop
//   • Padding tablette
//   • Padding mobile
//   • Padding petit mobile
//   • Densité
//
// Les paramètres sont stockés dans GlassThemeState.display.
//
// Architecture :
//
// DisplaySection
//      ↓
// glassThemeProvider
//      ↓
// GlassThemeState.display
//      ↓
// GlassDisplaySettings
//      ↓
// GlassLayoutContext
//      ↓
// composants
//
// ============================================================================

class DisplaySection extends ConsumerWidget {
  const DisplaySection({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final GlassThemeState theme =
        ref.watch(glassThemeProvider);

    final GlassDisplaySettings display =
        theme.display;

    final GlassLayoutContext glass =
        context.glassLayout;

    return GlassSurfaceContainer(
      style: theme.glassStyle,
      effects: glass.effects,
      borderRadius: BorderRadius.circular(
        glass.radius(20.0),
      ),
      padding: EdgeInsets.all(
        glass.spacing(20.0),
      ),
      liftOnHover:
          theme.enableHover,
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          // ==================================================================
          // HEADER
          // ==================================================================

          _DisplayHeader(
            glass: glass,
          ),

          SizedBox(
            height: glass.spacing(20.0),
          ),

          // ==================================================================
          // ZOOM
          // ==================================================================

          _DisplaySlider(
            glass: glass,
            title: 'Zoom',
            value: display.zoom,
            min: GlassScaleEngine.minScale,
            max: GlassScaleEngine.maxScale,
            divisions: 30,
            valueLabel: display.zoomLabel,
            description:
                'Ajuste la taille générale de l’interface.',
            onChanged: (double value) {
              ref
                  .read(
                    glassThemeProvider.notifier,
                  )
                  .updateDisplayZoom(value);
            },
          ),

          SizedBox(
            height: glass.spacing(22.0),
          ),

          // ==================================================================
          // LARGEUR MAXIMALE
          // ==================================================================

          _DisplaySlider(
            glass: glass,
            title: 'Largeur maximale',
            value: display.maxWidth <= 0
                ? 1440.0
                : display.maxWidth,
            min: 600.0,
            max: 3000.0,
            divisions: 24,
            valueLabel:
                display.maxWidthLabel,
            description:
                'Largeur maximale du contenu sur les grands écrans.',
            onChanged: (double value) {
              ref
                  .read(
                    glassThemeProvider.notifier,
                  )
                  .updateDisplayMaxWidth(value);
            },
          ),

          SizedBox(
            height: glass.spacing(22.0),
          ),

          // ==================================================================
          // BREAKPOINTS
          // ==================================================================

          _DisplaySlider(
            glass: glass,
            title: 'Breakpoint tablette',
            value:
                display.tabletBreakpoint,
            min: 400.0,
            max: 1200.0,
            divisions: 80,
            valueLabel:
                '${display.tabletBreakpoint.round()} px',
            description:
                'Largeur à partir de laquelle le layout passe en mode tablette.',
            onChanged: (double value) {
              final double desktop =
                  display.desktopBreakpoint <= value
                      ? value + 100.0
                      : display.desktopBreakpoint;

              ref
                  .read(
                    glassThemeProvider.notifier,
                  )
                  .updateDisplaySettings(
                display.copyWith(
                  tabletBreakpoint: value,
                  desktopBreakpoint: desktop,
                ),
              );
            },
          ),

          SizedBox(
            height: glass.spacing(18.0),
          ),

          _DisplaySlider(
            glass: glass,
            title: 'Breakpoint desktop',
            value:
                display.desktopBreakpoint,
            min: 800.0,
            max: 2000.0,
            divisions: 120,
            valueLabel:
                '${display.desktopBreakpoint.round()} px',
            description:
                'Largeur à partir de laquelle le layout passe en mode desktop.',
            onChanged: (double value) {
              ref
                  .read(
                    glassThemeProvider.notifier,
                  )
                  .updateDisplaySettings(
                display.copyWith(
                  desktopBreakpoint:
                      value <=
                              display.tabletBreakpoint
                          ? display.tabletBreakpoint +
                              100.0
                          : value,
                ),
              );
            },
          ),

          SizedBox(
            height: glass.spacing(22.0),
          ),

          // ==================================================================
          // PADDINGS
          // ==================================================================

          _DisplaySlider(
            glass: glass,
            title: 'Padding desktop',
            value:
                display.desktopPadding,
            min: 0.0,
            max: 50.0,
            divisions: 50,
            valueLabel:
                '${display.desktopPadding.round()} px',
            description:
                'Marge horizontale utilisée sur les écrans desktop.',
            onChanged: (double value) {
              ref
                  .read(
                    glassThemeProvider.notifier,
                  )
                  .updateDisplaySettings(
                display.copyWith(
                  desktopPadding: value,
                ),
              );
            },
          ),

          SizedBox(
            height: glass.spacing(18.0),
          ),

          _DisplaySlider(
            glass: glass,
            title: 'Padding tablette',
            value:
                display.tabletPadding,
            min: 0.0,
            max: 50.0,
            divisions: 50,
            valueLabel:
                '${display.tabletPadding.round()} px',
            description:
                'Marge horizontale utilisée sur les tablettes.',
            onChanged: (double value) {
              ref
                  .read(
                    glassThemeProvider.notifier,
                  )
                  .updateDisplaySettings(
                display.copyWith(
                  tabletPadding: value,
                ),
              );
            },
          ),

          SizedBox(
            height: glass.spacing(18.0),
          ),

          _DisplaySlider(
            glass: glass,
            title: 'Padding mobile',
            value:
                display.mobilePadding,
            min: 0.0,
            max: 40.0,
            divisions: 40,
            valueLabel:
                '${display.mobilePadding.round()} px',
            description:
                'Marge horizontale utilisée sur les mobiles.',
            onChanged: (double value) {
              ref
                  .read(
                    glassThemeProvider.notifier,
                  )
                  .updateDisplaySettings(
                display.copyWith(
                  mobilePadding: value,
                ),
              );
            },
          ),

          SizedBox(
            height: glass.spacing(18.0),
          ),

          _DisplaySlider(
            glass: glass,
            title: 'Padding petit mobile',
            value:
                display.smallMobilePadding,
            min: 0.0,
            max: 30.0,
            divisions: 30,
            valueLabel:
                '${display.smallMobilePadding.round()} px',
            description:
                'Marge horizontale utilisée sur les très petits écrans.',
            onChanged: (double value) {
              ref
                  .read(
                    glassThemeProvider.notifier,
                  )
                  .updateDisplaySettings(
                display.copyWith(
                  smallMobilePadding: value,
                ),
              );
            },
          ),

          SizedBox(
            height: glass.spacing(22.0),
          ),

          // ==================================================================
          // DENSITÉ
          // ==================================================================

          _DisplayDensitySelector(
            glass: glass,
            density: display.density,
            onChanged: (GlassDensity value) {
              ref
                  .read(
                    glassThemeProvider.notifier,
                  )
                  .updateDisplayDensity(value);
            },
          ),

          SizedBox(
            height: glass.spacing(22.0),
          ),

          // ==================================================================
          // RÉINITIALISATION
          // ==================================================================

          Align(
            alignment:
                Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () {
                ref
                    .read(
                      glassThemeProvider.notifier,
                    )
                    .resetDisplaySettings();
              },
              icon: const Icon(
                Icons.restore,
              ),
              label: const Text(
                'Réinitialiser l’affichage',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// HEADER
// ============================================================================

class _DisplayHeader extends StatelessWidget {
  final GlassLayoutContext glass;

  const _DisplayHeader({
    required this.glass,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: glass.size(42.0),
          height: glass.size(42.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: glass.focusColor.withValues(
              alpha: 0.08,
            ),
          ),
          child: Icon(
            Icons.display_settings_outlined,
            color: glass.focusColor,
            size: glass.size(22.0),
          ),
        ),

        SizedBox(
          width: glass.spacing(12.0),
        ),

        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                'Display',
                style: TextStyle(
                  color: Colors.white,
                  fontSize:
                      glass.fontSize(18.0),
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              SizedBox(
                height: glass.spacing(3.0),
              ),

              Text(
                'Configuration globale de l’affichage',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize:
                      glass.fontSize(12.0),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// SLIDER
// ============================================================================

class _DisplaySlider extends StatelessWidget {
  final GlassLayoutContext glass;
  final String title;
  final double value;
  final double min;
  final double max;
  final int divisions;
  final String valueLabel;
  final String description;
  final ValueChanged<double> onChanged;

  const _DisplaySlider({
    required this.glass,
    required this.title,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.valueLabel,
    required this.description,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize:
                      glass.fontSize(14.0),
                  fontWeight:
                      FontWeight.w600,
                ),
              ),
            ),

            Text(
              valueLabel,
              style: TextStyle(
                color: glass.focusColor,
                fontSize:
                    glass.fontSize(13.0),
                fontWeight:
                    FontWeight.bold,
              ),
            ),
          ],
        ),

        SizedBox(
          height: glass.spacing(4.0),
        ),

        Text(
          description,
          style: TextStyle(
            color: Colors.white54,
            fontSize:
                glass.fontSize(11.0),
            height: 1.35,
          ),
        ),

        SizedBox(
          height: glass.spacing(5.0),
        ),

        Slider(
          value: value.clamp(
            min,
            max,
          ),
          min: min,
          max: max,
          divisions: divisions,
          label: valueLabel,
          onChanged: onChanged,
        ),
      ],
    );
  }
}

// ============================================================================
// DENSITY SELECTOR
// ============================================================================

class _DisplayDensitySelector
    extends StatelessWidget {
  final GlassLayoutContext glass;
  final GlassDensity density;
  final ValueChanged<GlassDensity> onChanged;

  const _DisplayDensitySelector({
    required this.glass,
    required this.density,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          'Densité',
          style: TextStyle(
            color: Colors.white,
            fontSize:
                glass.fontSize(14.0),
            fontWeight:
                FontWeight.w600,
          ),
        ),

        SizedBox(
          height: glass.spacing(4.0),
        ),

        Text(
          'Contrôle l’espacement, la hauteur des contrôles, '
          'les rayons et les tailles de texte.',
          style: TextStyle(
            color: Colors.white54,
            fontSize:
                glass.fontSize(11.0),
            height: 1.35,
          ),
        ),

        SizedBox(
          height: glass.spacing(10.0),
        ),

        SegmentedButton<GlassDensity>(
          segments: const [
            ButtonSegment<GlassDensity>(
              value: GlassDensity.compact,
              icon: Icon(
                Icons.compress,
              ),
              label: Text(
                'Compacte',
              ),
            ),
            ButtonSegment<GlassDensity>(
              value:
                  GlassDensity.comfortable,
              icon: Icon(
                Icons.view_agenda_outlined,
              ),
              label: Text(
                'Confortable',
              ),
            ),
            ButtonSegment<GlassDensity>(
              value: GlassDensity.spacious,
              icon: Icon(
                Icons.expand,
              ),
              label: Text(
                'Spacieuse',
              ),
            ),
          ],
          selected: <GlassDensity>{
            density,
          },
          onSelectionChanged:
              (Set<GlassDensity> selection) {
            if (selection.isNotEmpty) {
              onChanged(
                selection.first,
              );
            }
          },
        ),
      ],
    );
  }
}