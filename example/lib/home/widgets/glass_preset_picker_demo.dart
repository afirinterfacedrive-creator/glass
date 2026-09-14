import 'package:flutter/material.dart';

import 'package:universal_glass/glass.dart';
import 'package:universal_glass_example/home/widgets/glass_preset_preview.dart';

// ============================================================================
// DEMO : PICKER ANIMÉ - OPTION C
// ============================================================================
//
// Affiche une grille de presets signature.
// Permet de sélectionner un preset et de voir le rendu en temps réel.
//
// ============================================================================

class GlassPresetPickerDemo extends StatefulWidget {
  const GlassPresetPickerDemo({
    super.key,
  });

  @override
  State<GlassPresetPickerDemo> createState() =>
      _GlassPresetPickerDemoState();
}

class _GlassPresetPickerDemoState
    extends State<GlassPresetPickerDemo> {
  // ==========================================================================
  // PRESET SÉLECTIONNÉ
  // ==========================================================================

  GlassStyle _selected =
      GlassStyle.transparentAqua;

  // ==========================================================================
  // PRESETS SIGNATURE
  // ==========================================================================

  final List<Map<String, dynamic>> _presets = [
    {
      'style': GlassStyle.transparentAqua,
      'label': 'Aqua Frost',
      'accent': Colors.cyanAccent,
    },
    {
      'style': GlassStyle.opaqueMat,
      'label': 'Classic Dark',
      'accent': const Color(0xFF9E9E9E),
    },
    {
      'style': GlassStyle.gradientOpaque,
      'label': 'Gradient Premium',
      'accent': const Color(0xFF7C4DFF),
    },
    {
      'style': GlassStyle.solidAqua,
      'label': 'Aqua Solid',
      'accent': const Color(0xFF00BCD4),
    },
    {
      'style': GlassStyle.solidClassic,
      'label': 'Classic Solid',
      'accent': const Color(0xFFBDBDBD),
    },
    {
      'style': GlassStyle.classicSb,
      'label': 'Classic Subtle',
      'accent': const Color(0xFFD4AF37),
    },
  ];

  // ==========================================================================
  // STYLE ANIMÉ
  // ==========================================================================

  bool get _isAnimated {
    return _selected == GlassStyle.transparentAqua ||
        _selected == GlassStyle.gradientOpaque ||
        _selected == GlassStyle.solidAqua;
  }

  // ==========================================================================
  // BUILD
  // ==========================================================================

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> currentPreset =
        _presets.firstWhere(
      (Map<String, dynamic> preset) =>
          preset['style'] == _selected,
    );

    return GlassScaffold(
      title: 'Picker Animé',
      subtitle: 'SIGNATURE PRESET PACK',
      showLogo: true,
      showBackButton: true,
      hideNavigation: true,
      maxWidth: 1200.0,
      child: Builder(
        builder: (BuildContext context) {
          final GlassLayoutContext glass =
              GlassLayoutScope.of(context);

          return SingleChildScrollView(
            padding: glass.dynamicPadding,
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.stretch,
              children: [
                // ============================================================
                // 1. PREVIEW DU STYLE SÉLECTIONNÉ
                // ============================================================

                GlassSurfaceContainer(
                  style: _selected,
                  effects: glass.effects,
                  liftOnHover: true,
                  padding: glass.dynamicPadding,
                  borderRadius: BorderRadius.circular(
                    glass.radius(24.0),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // ======================================================
                      // ICÔNE
                      // ======================================================

                      Container(
                        width: glass.size(56.0),
                        height: glass.size(56.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color:
                              (currentPreset['accent'] as Color)
                                  .withValues(alpha: 0.12),
                          border: Border.all(
                            color:
                                (currentPreset['accent'] as Color)
                                    .withValues(alpha: 0.35),
                            width: glass.size(1.0),
                          ),
                        ),
                        child: Icon(
                          _isAnimated
                              ? Icons.blur_on_rounded
                              : Icons.layers_rounded,
                          size: glass.size(30.0),
                          color:
                              currentPreset['accent'] as Color,
                        ),
                      ),

                      SizedBox(
                        height: glass.spacing(12.0),
                      ),

                      // ======================================================
                      // NOM DU PRESET
                      // ======================================================

                      Text(
                        'Style : ${currentPreset['label']}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: glass.fontSize(18.0),
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),

                      SizedBox(
                        height: glass.spacing(8.0),
                      ),

                      // ======================================================
                      // DESCRIPTION
                      // ======================================================

                      Text(
                        _isAnimated
                            ? 'Effet dynamique actif'
                            : 'Style statique premium',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: glass.fontSize(14.0),
                          color: Colors.white.withValues(
                            alpha: 0.70,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  height: glass.spacing(24.0),
                ),

                // ============================================================
                // TITRE DE LA GRILLE
                // ============================================================

                Text(
                  'Choisissez un preset signature',
                  style: TextStyle(
                    fontSize: glass.fontSize(16.0),
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),

                SizedBox(
                  height: glass.spacing(12.0),
                ),

                // ============================================================
                // 2. GRILLE DES PRESETS
                // ============================================================

                GlassResponsiveGrid(
                  spacing: glass.spacing(16.0),
                  runSpacing: glass.spacing(16.0),
                  mobileColumns: 1,
                  tabletColumns: 2,
                  desktopColumns: 3,
                  children: _presets.map(
                    (Map<String, dynamic> preset) {
                      final GlassStyle presetStyle =
                          preset['style'] as GlassStyle;

                      return GlassPresetPreview(
                        style: presetStyle,
                        label: preset['label'] as String,
                        accent: preset['accent'] as Color,
                        selected:
                            _selected == presetStyle,
                        onTap: () {
                          if (_selected == presetStyle) {
                            return;
                          }

                          setState(() {
                            _selected = presetStyle;
                          });
                        },
                      );
                    },
                  ).toList(),
                ),

                SizedBox(
                  height: glass.spacing(24.0),
                ),

                // ============================================================
                // INDICATEUR DU PRESET ACTUEL
                // ============================================================

                GlassSurfaceContainer(
                  style:
                      GlassStyle.transparentAqua,
                  effects: glass.effects,
                  padding: EdgeInsets.symmetric(
                    horizontal: glass.spacing(16.0),
                    vertical: glass.spacing(12.0),
                  ),
                  borderRadius: BorderRadius.circular(
                    glass.radius(16.0),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle_rounded,
                        size: glass.size(20.0),
                        color: currentPreset['accent']
                            as Color,
                      ),
                      SizedBox(
                        width: glass.spacing(10.0),
                      ),
                      Expanded(
                        child: Text(
                          'Preset actif : '
                          '${currentPreset['label']}',
                          style: TextStyle(
                            fontSize:
                                glass.fontSize(13.0),
                            fontWeight:
                                FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}