import 'package:flutter/material.dart';
import 'package:universal_glass/glass.dart';
import 'package:universal_glass_example/settings/widgets/appearance/glass_style_adapter.dart';

import 'appearance_settings.dart';
import 'widgets/appearance_color_picker.dart';
import 'widgets/appearance_live_preview.dart';

class AppearanceSectionBuilders {
  const AppearanceSectionBuilders({
    required this.saving,
    required this.error,
    required this.activeMode,
    required this.selectedAppearance,
    required this.onPreset,
    required this.onThemeMode,
    required this.onSelectAppearance,
    required this.onPickColor,
    required this.onUpdate,
    required this.onGlassStyle,
    required this.onReset,
    required this.onImport,
    required this.onExport,
  });

  final bool saving;
  final String? error;

  final AppThemeMode activeMode;
  final AppThemeMode selectedAppearance;

  final Future<void> Function(GlassPreset preset) onPreset;

  final Future<void> Function(AppThemeMode mode) onThemeMode;

  final void Function(AppThemeMode mode) onSelectAppearance;

  final Future<void> Function(BuildContext context, int index, bool aqua)
  onPickColor;

  final Future<void> Function(
    AppearanceSettings Function(AppearanceSettings settings),
  )
  onUpdate;

  final Future<void> Function(GlassStyle style) onGlassStyle;

  final Future<void> Function() onReset;

  /// Importe l'apparence gérée par Universal Glass.
  final Future<void> Function() onImport;

  /// Exporte l'apparence gérée par Universal Glass.
  final Future<void> Function() onExport;

  // ===========================================================================
  // LABELS
  // ===========================================================================

  static const Map<GlassStyle, String> glassStyleLabels = {
    GlassStyle.opaqueMat: 'Opaque Mat',
    GlassStyle.gradientOpaque: 'Gradient Opaque',
    GlassStyle.customGradient: 'Custom Gradient',
    GlassStyle.solidAqua: 'Solid Aqua',
    GlassStyle.solidClassic: 'Solid Classic',
    GlassStyle.opaqueHeavy: 'Opaque Heavy',
    GlassStyle.transparentAqua: 'Transparent Aqua',
    GlassStyle.transparentRed: 'Transparent Red',
    GlassStyle.transparentGreen: 'Transparent Green',
    GlassStyle.classicSb: 'Classic Subtle',
    GlassStyle.custom: 'Custom',
  };

  String _modeLabel(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.system:
        return 'System';

      case AppThemeMode.dark:
        return 'Dark';

      case AppThemeMode.light:
        return 'Light';

      case AppThemeMode.aqua:
        return 'Aqua';

      case AppThemeMode.classic:
        return 'Classic';
    }
  }

  IconData _modeIcon(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.system:
        return Icons.brightness_auto;

      case AppThemeMode.dark:
        return Icons.dark_mode;

      case AppThemeMode.light:
        return Icons.light_mode;

      case AppThemeMode.aqua:
        return Icons.water_drop;

      case AppThemeMode.classic:
        return Icons.layers;
    }
  }

  // ===========================================================================
  // PARSING
  // ===========================================================================

  AppThemeMode _parseThemeMode(String value) {
    switch (value.toLowerCase()) {
      case 'dark':
        return AppThemeMode.dark;

      case 'light':
        return AppThemeMode.light;

      case 'aqua':
        return AppThemeMode.aqua;

      case 'classic':
        return AppThemeMode.classic;

      case 'system':
      default:
        return AppThemeMode.system;
    }
  }

  GlassStyle _parseGlassStyle(String value) {
    switch (value.toLowerCase()) {
      case 'opaquemat':
      case 'opaque_mat':
      case 'opaque mat':
        return GlassStyle.opaqueMat;

      case 'gradientopaque':
      case 'gradient_opaque':
      case 'gradient opaque':
        return GlassStyle.gradientOpaque;

      case 'customgradient':
      case 'custom_gradient':
      case 'custom gradient':
        return GlassStyle.customGradient;

      case 'solidaqua':
      case 'solid_aqua':
      case 'solid aqua':
        return GlassStyle.solidAqua;

      case 'solidclassic':
      case 'solid_classic':
      case 'solid classic':
        return GlassStyle.solidClassic;

      case 'opaqueheavy':
      case 'opaque_heavy':
      case 'opaque heavy':
        return GlassStyle.opaqueHeavy;

      case 'transparentaqua':
      case 'transparent_aqua':
      case 'transparent aqua':
      case 'ghost':
        return GlassStyle.transparentAqua;

      case 'transparentred':
      case 'transparent_red':
      case 'transparent red':
        return GlassStyle.transparentRed;

      case 'transparentgreen':
      case 'transparent_green':
      case 'transparent green':
        return GlassStyle.transparentGreen;

      case 'classicsb':
      case 'classic_sb':
      case 'classic subtle':
        return GlassStyle.classicSb;

      case 'custom':
        return GlassStyle.custom;

      default:
        return GlassStyle.opaqueMat;
    }
  }

  // ===========================================================================
  // COLORS
  // ===========================================================================

  List<Color> _toColors(List<int> values) {
    return values.map(Color.new).toList(growable: false);
  }

  bool _isAqua(AppearanceSettings settings) {
    final AppThemeMode mode = _parseThemeMode(settings.themeMode);

    if (mode == AppThemeMode.aqua) {
      return true;
    }

    final GlassStyle style = _parseGlassStyle(settings.glassStyle);

    switch (style) {
      case GlassStyle.solidAqua:
      case GlassStyle.transparentAqua:
        return true;

      default:
        return false;
    }
  }

  List<Color> _activeColors(AppearanceSettings settings) {
    return _isAqua(settings)
        ? _toColors(settings.aquaColors)
        : _toColors(settings.classicColors);
  }

  // ===========================================================================
  // PRESET
  // ===========================================================================

  GlassPreset _getCurrentPreset(AppearanceSettings settings) {
    final GlassStyle style = _parseGlassStyle(settings.glassStyle);

    if (style == GlassStyle.classicSb) {
      return GlassPreset.classicSb;
    }

    if (selectedAppearance == AppThemeMode.aqua && settings.blur > 15) {
      return GlassPreset.aquaFrost;
    }

    if (selectedAppearance == AppThemeMode.classic) {
      return GlassPreset.classicDark;
    }

    if (selectedAppearance == AppThemeMode.light) {
      return GlassPreset.light;
    }

    return GlassPreset.dark;
  }

  // ===========================================================================
  // MAIN BUILD
  // ===========================================================================

  Widget build(BuildContext context, AppearanceSettings settings) {
    final GlassColorPalette palette = GlassColorPalette.fromMode(
      selectedAppearance,
    );

    final double screenWidth = MediaQuery.sizeOf(context).width;

    final bool isSmallMobile = screenWidth < 375;

    final EdgeInsets dynamicPadding = EdgeInsets.all(isSmallMobile ? 12 : 18);

    final bool isAqua = _isAqua(settings);

    final List<Color> activeColors = _activeColors(settings);

    final Color accent = activeColors.isNotEmpty
        ? activeColors.first
        : palette.accent;

    final GlassStyle currentGlassStyle = _parseGlassStyle(settings.glassStyle);

    final bool isClassicSb = currentGlassStyle == GlassStyle.classicSb;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // =====================================================================
        // 1. PRESETS RAPIDES
        // =====================================================================
        _sectionCard(
          palette: palette,
          title: 'Presets Rapides',
          children: [
            GlassResponsiveGrid(
              spacing: 10,
              runSpacing: 10,
              desktopColumns: 4,
              tabletColumns: 3,
              children: [
                GlassModeChip<GlassPreset>(
                  mode: GlassPreset.aquaFrost,
                  selected: _getCurrentPreset(settings),
                  icon: Icons.water_drop_outlined,
                  label: 'Aqua Frost',
                  accent: accent,
                  onSelected: saving
                      ? (_) {}
                      : (preset) {
                          onPreset(preset);
                        },
                ),
                GlassModeChip<GlassPreset>(
                  mode: GlassPreset.classicDark,
                  selected: _getCurrentPreset(settings),
                  icon: Icons.layers_outlined,
                  label: 'Classic',
                  accent: palette.textSecondary,
                  onSelected: saving
                      ? (_) {}
                      : (preset) {
                          onPreset(preset);
                        },
                ),
                GlassModeChip<GlassPreset>(
                  mode: GlassPreset.classicSb,
                  selected: _getCurrentPreset(settings),
                  icon: Icons.rectangle_outlined,
                  label: 'Classic Sb',
                  accent: palette.textSecondary,
                  onSelected: saving
                      ? (_) {}
                      : (preset) {
                          onPreset(preset);
                        },
                ),
                GlassModeChip<GlassPreset>(
                  mode: GlassPreset.light,
                  selected: _getCurrentPreset(settings),
                  icon: Icons.light_mode,
                  label: 'Light',
                  accent: palette.textSecondary,
                  onSelected: saving
                      ? (_) {}
                      : (preset) {
                          onPreset(preset);
                        },
                ),
                GlassModeChip<GlassPreset>(
                  mode: GlassPreset.dark,
                  selected: _getCurrentPreset(settings),
                  icon: Icons.nightlight,
                  label: 'Dark',
                  accent: palette.textSecondary,
                  onSelected: saving
                      ? (_) {}
                      : (preset) {
                          onPreset(preset);
                        },
                ),
              ],
            ),
          ],
        ),

        const SizedBox(height: 16),

        // =====================================================================
        // 2. MODE ACTIF
        // =====================================================================
        _sectionCard(
          palette: palette,
          title: 'Mode Actif',
          children: [
            GlassResponsiveGrid(
              spacing: 10,
              runSpacing: 10,
              desktopColumns: 4,
              tabletColumns: 3,
              children: AppThemeMode.values.map((mode) {
                return GlassModeChip<AppThemeMode>(
                  mode: mode,
                  selected: activeMode,
                  icon: _modeIcon(mode),
                  label: _modeLabel(mode),
                  accent: GlassColorPalette.fromMode(mode).accent,
                  onSelected: saving
                      ? (_) {}
                      : (selectedMode) {
                          onThemeMode(selectedMode);
                        },
                );
              }).toList(),
            ),
            Text(
              activeMode == AppThemeMode.system
                  ? 'Le mode System utilise automatiquement le profil Aqua comme configuration de secours.'
                  : 'Le mode ${_modeLabel(activeMode)} est actuellement actif.',
              style: TextStyle(
                color: palette.textSecondary,
                fontSize: 12,
                height: 1.4,
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // =====================================================================
        // 3. APPARENCE À PERSONNALISER
        // =====================================================================
        _sectionCard(
          palette: palette,
          title: 'Apparence à personnaliser',
          children: [
            GlassResponsiveGrid(
              spacing: 10,
              runSpacing: 10,
              desktopColumns: 4,
              tabletColumns: 3,
              children: AppThemeMode.values
                  .where((mode) => mode != AppThemeMode.system)
                  .map((mode) {
                    final GlassColorPalette modePalette =
                        GlassColorPalette.fromMode(mode);

                    return GlassModeChip<AppThemeMode>(
                      mode: mode,
                      selected: selectedAppearance,
                      icon: _modeIcon(mode),
                      label: _modeLabel(mode),
                      accent: modePalette.accent,
                      onSelected: saving ? (_) {} : onSelectAppearance,
                    );
                  })
                  .toList(),
            ),
            Text(
              'Les réglages ci-dessous sont enregistrés indépendamment pour chaque apparence.',
              style: TextStyle(
                color: palette.textSecondary,
                fontSize: 12,
                height: 1.4,
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // =====================================================================
        // 4. IMPORT / EXPORT
        // =====================================================================
        _buildImportExportSection(palette: palette),

        const SizedBox(height: 16),

        // =====================================================================
        // 5. COULEURS
        // =====================================================================
        _sectionCard(
          palette: palette,
          title: 'Couleurs — ${_modeLabel(selectedAppearance)}',
          children: [
            if (!isClassicSb) ...[
              _title('Couleurs Gradient', palette),
              AppearanceColorPicker(
                colors: activeColors,
                onTap: (index) {
                  onPickColor(context, index, isAqua);
                },
              ),
              _buildSlider(
                label: 'Opacité du gradient',
                value: settings.gradientOpacity,
                min: 0,
                max: 1,
                onChanged: (value) {
                  onUpdate(
                    (current) => current.copyWith(gradientOpacity: value),
                  );
                },
              ),
              _buildSlider(
                label: 'Densité du gradient',
                value: settings.gradientDensity.toDouble(),
                min: 2,
                max: 4,
                divisions: 2,
                onChanged: (value) {
                  onUpdate(
                    (current) => current.copyWith(gradientDensity: value),
                  );
                },
              ),
            ] else
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: palette.surface.withValues(alpha: .08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: palette.textSecondary.withValues(alpha: .12),
                  ),
                ),
                child: Text(
                  'Mode Classic Subtle : Gradient fixe #1A1A1A → #121212, bordure subtile 1px.',
                  style: TextStyle(
                    color: palette.textSecondary,
                    fontSize: 12,
                    height: 1.45,
                  ),
                ),
              ),
          ],
        ),

        // =====================================================================
        // 6. SURFACE & EFFETS
        // =====================================================================
        if (!isClassicSb) ...[
          const SizedBox(height: 16),
          _sectionCard(
            palette: palette,
            title: 'Surface & Effets',
            children: [
              GlassResponsiveGrid(
                spacing: 10,
                runSpacing: 10,
                desktopColumns: 3,
                tabletColumns: 2,
                children: [
                  _buildSwitchSlider(
                    label: 'Blur',
                    enabled: settings.enableBlur,
                    value: settings.blur,
                    min: 0,
                    max: 50,
                    onToggle: (value) {
                      onUpdate(
                        (current) => current.copyWith(enableBlur: value),
                      );
                    },
                    onChanged: (value) {
                      onUpdate((current) => current.copyWith(blur: value));
                    },
                  ),
                  _buildSwitchSlider(
                    label: 'Noise',
                    enabled: settings.enableNoise,
                    value: settings.noise,
                    min: 0,
                    max: 1,
                    onToggle: (value) {
                      onUpdate(
                        (current) => current.copyWith(enableNoise: value),
                      );
                    },
                    onChanged: (value) {
                      onUpdate((current) => current.copyWith(noise: value));
                    },
                  ),
                  _buildSlider(
                    label: 'Opacité de surface',
                    value: settings.surfaceOpacity,
                    min: 0,
                    max: 1,
                    onChanged: (value) {
                      onUpdate(
                        (current) => current.copyWith(surfaceOpacity: value),
                      );
                    },
                  ),
                ],
              ),
              GlassResponsiveGrid(
                spacing: 10,
                runSpacing: 10,
                desktopColumns: 2,
                tabletColumns: 2,
                children: [
                  _buildSwitchSlider(
                    label: 'Hover',
                    enabled: settings.enableHover,
                    value: settings.hoverLift,
                    min: 0,
                    max: 20,
                    onToggle: (value) {
                      onUpdate(
                        (current) => current.copyWith(enableHover: value),
                      );
                    },
                    onChanged: (value) {
                      onUpdate((current) => current.copyWith(hoverLift: value));
                    },
                  ),
                  _buildSlider(
                    label: 'Rayon des bordures',
                    value: settings.borderRadius,
                    min: 0,
                    max: 40,
                    onChanged: (value) {
                      onUpdate(
                        (current) => current.copyWith(borderRadius: value),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ],

        // =====================================================================
        // 7. STYLE DE SURFACE
        // =====================================================================
        const SizedBox(height: 16),

        _sectionCard(
          palette: palette,
          title: 'Style de Surface',
          children: [
            GlassDropdownTextField<GlassStyle>(
              style: settings.input.toGlassStyle().copyWith(
                // <- tout vient de settings.input
                enabled: !saving,
              ),
              label: 'Style de Surface',
              hintText: 'Choisir un style...',
              value: currentGlassStyle,
              items: GlassStyle.values,
              itemLabelExtractor: (style) =>
                  glassStyleLabels[style] ?? style.name,
              onChanged: saving
                  ? null
                  : (style) {
                      if (style == null) return;
                      onGlassStyle(style);
                    },
              prefixIcon: Icons.layers_rounded,
            )
          ],
        ),

        // =====================================================================
        // 8. APP BAR
        // =====================================================================
        const SizedBox(height: 16),

        _buildAppBarSection(palette: palette, settings: settings),

        const SizedBox(height: 16),

        // =====================================================================
        // 9. BORDURE & OMBRE & GLOW
        // =====================================================================
        _sectionCard(
          palette: palette,
          title: 'Bordure & Ombre & Glow',
          children: [
            GlassResponsiveGrid(
              spacing: 10,
              runSpacing: 10,
              desktopColumns: 3,
              tabletColumns: 2,
              children: [
                _buildSwitchSlider(
                  label: 'Bordure',
                  enabled: settings.enableBorder,
                  value: settings.borderWidth,
                  min: 0,
                  max: 5,
                  onToggle: (value) {
                    onUpdate(
                      (current) => current.copyWith(enableBorder: value),
                    );
                  },
                  onChanged: (value) {
                    onUpdate((current) => current.copyWith(borderWidth: value));
                  },
                ),
                _buildSlider(
                  label: 'Opacité bordure',
                  value: settings.borderOpacity,
                  min: 0,
                  max: 1,
                  onChanged: (value) {
                    onUpdate(
                      (current) => current.copyWith(borderOpacity: value),
                    );
                  },
                ),
                if (!isClassicSb)
                  _buildSwitchSlider(
                    label: 'Glow',
                    enabled: settings.enableGlow,
                    value: settings.glowBlur,
                    min: 0,
                    max: 50,
                    onToggle: (value) {
                      onUpdate(
                        (current) => current.copyWith(enableGlow: value),
                      );
                    },
                    onChanged: (value) {
                      onUpdate((current) => current.copyWith(glowBlur: value));
                    },
                  ),
              ],
            ),
            GlassResponsiveGrid(
              spacing: 10,
              runSpacing: 10,
              desktopColumns: 3,
              tabletColumns: 2,
              children: [
                if (!isClassicSb)
                  _buildSlider(
                    label: 'Opacité Glow',
                    value: settings.glowOpacity,
                    min: 0,
                    max: 1,
                    onChanged: (value) {
                      onUpdate(
                        (current) => current.copyWith(glowOpacity: value),
                      );
                    },
                  ),
                _buildSwitchSlider(
                  label: 'Ombre',
                  enabled: settings.enableShadow,
                  value: settings.shadowBlur,
                  min: 0,
                  max: 50,
                  onToggle: (value) {
                    onUpdate(
                      (current) => current.copyWith(enableShadow: value),
                    );
                  },
                  onChanged: (value) {
                    onUpdate((current) => current.copyWith(shadowBlur: value));
                  },
                ),
                _buildSlider(
                  label: 'Opacité ombre',
                  value: settings.shadowOpacity,
                  min: 0,
                  max: 1,
                  onChanged: (value) {
                    onUpdate(
                      (current) => current.copyWith(shadowOpacity: value),
                    );
                  },
                ),
              ],
            ),
            _buildSlider(
              label: 'Décalage vertical ombre',
              value: settings.shadowOffsetY,
              min: -20,
              max: 20,
              onChanged: (value) {
                onUpdate((current) => current.copyWith(shadowOffsetY: value));
              },
            ),
          ],
        ),

        const SizedBox(height: 16),

        // =====================================================================
        // 10. APERÇU LIVE
        // =====================================================================
        GlassSurfaceContainer(
          style: currentGlassStyle,
          customGradient: isClassicSb ? null : activeColors,
          padding: dynamicPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(palette),

              const SizedBox(height: 16),

              AppearanceLivePreview(
                mode: selectedAppearance,
                palette: palette,
                aquaColors: _toColors(settings.aquaColors),
                classicColors: _toColors(settings.classicColors),
              ),

              const SizedBox(height: 16),

              _buildResetButton(palette),

              if (saving) ...[
                const SizedBox(height: 10),
                _buildSavingIndicator(palette),
              ],

              if (error != null) ...[
                const SizedBox(height: 10),
                _buildInlineError(palette),
              ],
            ],
          ),
        ),

        const SizedBox(height: 16),

        // =====================================================================
        // 11. APERÇU BIENVENUE
        // =====================================================================
        GlassSurfaceContainer(
          style: currentGlassStyle,
          customGradient: null,
          padding: dynamicPadding,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Bienvenue dans Universal Glass',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Personnalisez votre apparence et visualisez instantanément les changements.',
                      style: TextStyle(
                        color: palette.textSecondary,
                        fontSize: 12,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
              if (!isSmallMobile) ...[
                const SizedBox(width: 18),
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: activeColors.isNotEmpty
                          ? activeColors
                          : [palette.accent, palette.primary],
                    ),
                  ),
                  child: Icon(
                    _modeIcon(selectedAppearance),
                    color: Colors.white,
                    size: 38,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // IMPORT / EXPORT
  // ===========================================================================

  Widget _buildImportExportSection({required GlassColorPalette palette}) {
    return _sectionCard(
      palette: palette,
      title: 'Importer / Exporter',
      children: [
        Text(
          'Sauvegardez ou restaurez les réglages d’apparence gérés par Universal Glass.',
          style: TextStyle(
            color: palette.textSecondary,
            fontSize: 12,
            height: 1.45,
          ),
        ),
        const SizedBox(height: 14),
        GlassResponsiveGrid(
          spacing: 10,
          runSpacing: 10,
          desktopColumns: 2,
          tabletColumns: 2,
          children: [
            _buildAppearanceAction(
              icon: Icons.file_upload_outlined,
              label: 'Importer',
              accent: palette.accent,
              onPressed: saving ? null : onImport,
            ),
            _buildAppearanceAction(
              icon: Icons.file_download_outlined,
              label: 'Exporter',
              accent: palette.primary,
              onPressed: saving ? null : onExport,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAppearanceAction({
    required IconData icon,
    required String label,
    required Color accent,
    required VoidCallback? onPressed,
  }) {
    return SizedBox(
      height: 48,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 18),
        label: Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: accent,
          side: BorderSide(color: accent.withValues(alpha: .28)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // APP BAR SECTION
  // ===========================================================================

  Widget _buildAppBarSection({
    required GlassColorPalette palette,
    required AppearanceSettings settings,
  }) {
    final AppearanceAppBarSettings appBar = settings.appBar;

    final bool hasCustomHeight = appBar.height != null;

    return _sectionCard(
      palette: palette,
      title: 'AppBar',
      children: [
        GlassResponsiveGrid(
          spacing: 10,
          runSpacing: 10,
          desktopColumns: 3,
          tabletColumns: 2,
          children: [
            _buildSwitch(
              label: 'Personnalisation AppBar',
              value: appBar.enabled,
              onChanged: (value) {
                onUpdate(
                  (current) => current.copyWith(
                    appBar: current.appBar.copyWith(enabled: value),
                  ),
                );
              },
            ),
            _buildSwitch(
              label: 'Fond avec gradient',
              value: appBar.useGradientBackground,
              onChanged: (value) {
                onUpdate(
                  (current) => current.copyWith(
                    appBar: current.appBar.copyWith(
                      useGradientBackground: value,
                    ),
                  ),
                );
              },
            ),
            _buildSwitch(
              label: 'Mode compact',
              value: appBar.compactMode,
              onChanged: (value) {
                onUpdate(
                  (current) => current.copyWith(
                    appBar: current.appBar.copyWith(compactMode: value),
                  ),
                );
              },
            ),
          ],
        ),

        const SizedBox(height: 12),

        _buildSwitch(
          label: 'Hauteur personnalisée',
          value: hasCustomHeight,
          onChanged: (value) {
            onUpdate(
              (current) => current.copyWith(
                appBar: current.appBar.copyWith(
                  height: value
                      ? (current.appBar.height ?? AppConstants.minAppBarHeight)
                      : null,
                  clearHeight: !value,
                ),
              ),
            );
          },
        ),

        if (hasCustomHeight) ...[
          const SizedBox(height: 4),
          _buildSlider(
            label: 'Hauteur de l’AppBar',
            value: appBar.effectiveHeight ?? AppConstants.minAppBarHeight,
            min: AppConstants.minAppBarHeight,
            max: AppConstants.maxAppBarHeight,
            onChanged: (value) {
              onUpdate(
                (current) => current.copyWith(
                  appBar: current.appBar.copyWith(height: value),
                ),
              );
            },
          ),
        ] else
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              'Hauteur automatique : UniversalAppBar conserve son comportement responsive.',
              style: TextStyle(
                color: palette.textSecondary,
                fontSize: 11,
                height: 1.4,
              ),
            ),
          ),

        const SizedBox(height: 16),

        _title('Boutons d’action', palette),

        const SizedBox(height: 8),

        GlassResponsiveGrid(
          spacing: 10,
          runSpacing: 10,
          desktopColumns: 3,
          tabletColumns: 2,
          children: [
            _buildSlider(
              label: 'Opacité fond des actions',
              value: appBar.effectiveActionBackgroundOpacity,
              min: 0,
              max: 1,
              onChanged: (value) {
                onUpdate(
                  (current) => current.copyWith(
                    appBar: current.appBar.copyWith(
                      actionBackgroundOpacity: value,
                    ),
                  ),
                );
              },
            ),
            _buildSlider(
              label: 'Opacité accent des actions',
              value: appBar.effectiveActionAccentOpacity,
              min: 0,
              max: 1,
              onChanged: (value) {
                onUpdate(
                  (current) => current.copyWith(
                    appBar: current.appBar.copyWith(actionAccentOpacity: value),
                  ),
                );
              },
            ),
            _buildSlider(
              label: 'Opacité bordure des actions',
              value: appBar.effectiveActionBorderOpacity,
              min: 0,
              max: 1,
              onChanged: (value) {
                onUpdate(
                  (current) => current.copyWith(
                    appBar: current.appBar.copyWith(actionBorderOpacity: value),
                  ),
                );
              },
            ),
            _buildSlider(
              label: 'Épaisseur bordure des actions',
              value: appBar.effectiveActionBorderWidth,
              min: AppConstants.minAppBarActionBorderWidth,
              max: AppConstants.maxAppBarActionBorderWidth,
              onChanged: (value) {
                onUpdate(
                  (current) => current.copyWith(
                    appBar: current.appBar.copyWith(actionBorderWidth: value),
                  ),
                );
              },
            ),
            _buildSlider(
              label: 'Opacité ombre des actions',
              value: appBar.effectiveActionShadowOpacity,
              min: 0,
              max: 1,
              onChanged: (value) {
                onUpdate(
                  (current) => current.copyWith(
                    appBar: current.appBar.copyWith(actionShadowOpacity: value),
                  ),
                );
              },
            ),
            _buildSlider(
              label: 'Flou ombre des actions',
              value: appBar.effectiveActionShadowBlur,
              min: AppConstants.minAppBarActionShadowBlur,
              max: AppConstants.maxAppBarActionShadowBlur,
              onChanged: (value) {
                onUpdate(
                  (current) => current.copyWith(
                    appBar: current.appBar.copyWith(actionShadowBlur: value),
                  ),
                );
              },
            ),
          ],
        ),

        _buildSlider(
          label: 'Décalage vertical ombre des actions',
          value: appBar.effectiveActionShadowOffsetY,
          min: AppConstants.minAppBarActionShadowOffsetY,
          max: AppConstants.maxAppBarActionShadowOffsetY,
          onChanged: (value) {
            onUpdate(
              (current) => current.copyWith(
                appBar: current.appBar.copyWith(actionShadowOffsetY: value),
              ),
            );
          },
        ),

        const SizedBox(height: 12),

        _title('Ombre globale', palette),

        const SizedBox(height: 8),

        _buildSlider(
          label: 'Opacité ombre de l’AppBar',
          value: appBar.effectiveShadowOpacity,
          min: 0,
          max: 1,
          onChanged: (value) {
            onUpdate(
              (current) => current.copyWith(
                appBar: current.appBar.copyWith(shadowOpacity: value),
              ),
            );
          },
        ),
      ],
    );
  }

  // ===========================================================================
  // SWITCH
  // ===========================================================================

  Widget _buildSwitch({
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Switch(value: value, onChanged: saving ? null : onChanged),
      ],
    );
  }

  // ===========================================================================
  // SECTION CARD
  // ===========================================================================

  Widget _sectionCard({
    required GlassColorPalette palette,
    required String title,
    required List<Widget> children,
  }) {
    return GlassSurfaceContainer(
      style: GlassStyle.opaqueMat,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  // ===========================================================================
  // HEADER
  // ===========================================================================

  Widget _buildHeader(GlassColorPalette palette) {
    return Row(
      children: [
        const Expanded(
          child: Text(
            'Aperçu en direct',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        if (saving)
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 1.5,
              color: palette.primaryForMode(selectedAppearance),
            ),
          ),
      ],
    );
  }

  // ===========================================================================
  // TITLE
  // ===========================================================================

  Widget _title(String text, GlassColorPalette palette) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 13,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  // ===========================================================================
  // SWITCH + SLIDER
  // ===========================================================================

  Widget _buildSwitchSlider({
    required String label,
    required bool enabled,
    required double value,
    required double min,
    required double max,
    required ValueChanged<bool> onToggle,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Switch(value: enabled, onChanged: saving ? null : onToggle),
          ],
        ),
        Opacity(
          opacity: enabled ? 1 : .4,
          child: Slider(
            value: value.clamp(min, max),
            min: min,
            max: max,
            onChanged: enabled && !saving ? onChanged : null,
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // SLIDER
  // ===========================================================================

  Widget _buildSlider({
    required String label,
    required double value,
    required double min,
    required double max,
    int? divisions,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        Slider(
          value: value.clamp(min, max),
          min: min,
          max: max,
          divisions: divisions,
          onChanged: saving ? null : onChanged,
        ),
      ],
    );
  }

  // ===========================================================================
  // RESET
  // ===========================================================================

  Widget _buildResetButton(GlassColorPalette palette) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton.icon(
        onPressed: saving ? null : onReset,
        icon: const Icon(Icons.restore, size: 16),
        label: const Text('Réinitialiser'),
      ),
    );
  }

  // ===========================================================================
  // SAVING
  // ===========================================================================

  Widget _buildSavingIndicator(GlassColorPalette palette) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 12,
          height: 12,
          child: CircularProgressIndicator(
            strokeWidth: 1.5,
            color: palette.primaryForMode(selectedAppearance),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          'Enregistrement...',
          style: TextStyle(color: palette.textSecondary, fontSize: 11),
        ),
      ],
    );
  }

  // ===========================================================================
  // INLINE ERROR
  // ===========================================================================

  Widget _buildInlineError(GlassColorPalette palette) {
    if (error == null) {
      return const SizedBox.shrink();
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.warning_amber_rounded, size: 16, color: Colors.orange),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            error!,
            style: const TextStyle(
              color: Colors.orange,
              fontSize: 11,
              height: 1.35,
            ),
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // LOAD ERROR
  // ===========================================================================

  static Widget buildError({
    required String? error,
    required VoidCallback onRetry,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: Colors.orange, size: 32),
            const SizedBox(height: 12),
            const Text(
              'Impossible de charger les réglages d’apparence.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (error != null) ...[
              const SizedBox(height: 8),
              Text(
                error,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white54, fontSize: 11),
              ),
            ],
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Réessayer'),
            ),
          ],
        ),
      ),
    );
  }
}
