// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:universal_glass/glass.dart';
import 'appearance_controller.dart';
import 'appearance_settings.dart';

import 'widgets/appearance_color_picker.dart';
import 'widgets/appearance_live_preview.dart';



class AppearanceSection extends ConsumerStatefulWidget {
  final VoidCallback? onThemeChanged;
  const AppearanceSection({super.key, this.onThemeChanged});
  @override
  ConsumerState<AppearanceSection> createState() => _AppearanceSectionState();
}

class _AppearanceSectionState extends ConsumerState<AppearanceSection> {
  late final AppearanceController _controller;
  AppearanceSettings? _settings;
  bool _loading = true, _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _controller = AppearanceController(ref);
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final s = await _controller.load();
      if (!mounted) return;
      setState(() {
        _settings = s;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = e.toString();
      });
    }
  }

  Future<void> _update(
    AppearanceSettings Function(AppearanceSettings) change,
  ) async {
    final cur = _settings;
    if (cur == null || _saving) return;
    final updated = change(cur);
    setState(() {
      _settings = updated;
      _saving = true;
      _error = null;
    });
    try {
      await _controller.apply(updated);
      if (!mounted) return;
      setState(() => _saving = false);
      widget.onThemeChanged?.call();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _saving = false;
        _error = e.toString();
      });
    }
  }

  Future<void> _applyPreset(GlassPreset preset) async {
    AppearanceSettings newSettings;
    switch (preset) {
      case GlassPreset.aquaFrost:
        newSettings = AppearanceSettings.defaults().copyWith(
          themeMode: AppThemeMode.aqua,
          glassStyle: GlassStyle.transparentAqua,
          enableBlur: true,
          blur: 20,
          enableNoise: true,
          noise: 0.3,
          enableGlow: true,
          glowOpacity: 0.25,
          glowBlur: 30,
          surfaceOpacity: 0.85,
        );
        break;
      case GlassPreset.classicDark:
        newSettings = AppearanceSettings.defaults().copyWith(
          themeMode: AppThemeMode.classic,
          glassStyle: GlassStyle.opaqueMat,
          enableBlur: false,
          enableNoise: false,
          enableBorder: true,
          borderOpacity: 0.3,
          surfaceOpacity: 0.95,
        );
        break;
      case GlassPreset.classicSb:
        newSettings = AppearanceSettings.defaults().copyWith(
          themeMode: AppThemeMode.dark,
          glassStyle: GlassStyle.classicSb,
          enableBlur: false,
          enableNoise: false,
          enableGlow: false,
          enableShadow: true,
          shadowBlur: 24,
          shadowOpacity: 0.25,
          shadowOffsetY: 12,
          surfaceOpacity: 1.0,
          borderRadius: 26,
          enableBorder: true,
          borderWidth: 1.0,
          borderOpacity: 0.3,
          gradientOpacity: 1.0,
        );
        break;
    
      case GlassPreset.sagePro:
        newSettings = AppearanceSettings.defaults().copyWith(
          themeMode: AppThemeMode.sagePro,
          glassStyle: GlassStyle.sagePro,
          enableBlur: true,
          blur: 15,
          enableShadow: true,
          shadowBlur: 20,
          enableGlow: true,
          glowOpacity: 0.2,
          glowBlur: 25,
        );
        break;
      case GlassPreset.sageOled:
        newSettings = AppearanceSettings.defaults().copyWith(
          themeMode: AppThemeMode.sageOled,
          glassStyle: GlassStyle.sageOled,
          enableBlur: false,
          surfaceOpacity: 1.0,
          enableGlow: false,
          enableShadow: false,
        );
        break;
      case GlassPreset.sageGlass:
        newSettings = AppearanceSettings.defaults().copyWith(
          themeMode: AppThemeMode.sageGlass,
          glassStyle: GlassStyle.sageGlass,
          enableBlur: true,
          blur: 25,
          enableNoise: true,
          noise: 0.2,
          surfaceOpacity: 0.05,
        );
        break;
      case GlassPreset.light:
        newSettings = AppearanceSettings.defaults().copyWith(
          themeMode: AppThemeMode.light,
          glassStyle: GlassStyle.solidClassic,
          surfaceOpacity: 0.9,
          enableShadow: true,
          enableBlur: false,
        );
        break;
      case GlassPreset.dark:
        newSettings = AppearanceSettings.defaults().copyWith(
          themeMode: AppThemeMode.dark,
          glassStyle: GlassStyle.opaqueMat,
          surfaceOpacity: 0.95,
          enableShadow: true,
          enableBlur: true,
          blur: 10,
        );
        break;
    }
    await _update((_) => newSettings);
  }




  Future<void> _changeThemeMode(AppThemeMode mode) =>
      _update((s) => s.copyWith(themeMode: mode));

  Future<void> _changeGlassStyle(GlassStyle style) =>
      _update((s) => s.copyWith(glassStyle: style));

  Future<void> _changeColor({
    required int index,
    required Color color,
    required bool aqua,
  }) async {
    final cur = _settings;
    if (cur == null) return;
    final colors = List<Color>.from(aqua? cur.aquaColors : cur.classicColors);
    if (index < 0 || index >= colors.length) return;
    colors[index] = color;
    await _update(
      (s) => aqua
         ? s.copyWith(aquaColors: colors)
          : s.copyWith(classicColors: colors),
    );
  }

  Future<void> _reset() async {
    if (_saving) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      final s = await _controller.reset();
      if (!mounted) return;
      setState(() {
        _settings = s;
        _saving = false;
      });
      widget.onThemeChanged?.call();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _saving = false;
        _error = e.toString();
      });
    }
  }

  Future<void> _pickColor(int index, bool aqua) async {
    final s = _settings;
    if (s == null) return;
    final colors = aqua? s.aquaColors : s.classicColors;
    if (index < 0 || index >= colors.length) return;
    final c = await AppearanceColorPicker.show(
      context,
      initialColor: colors[index],
    );
    if (c == null ||!mounted) return;
    await _changeColor(index: index, color: c, aqua: aqua);
  }

  static const Map<GlassStyle, String> glassStyleLabels = {
    GlassStyle.transparentAqua: 'Transparent Aqua',
    GlassStyle.solidAqua: 'Solid Aqua',
    GlassStyle.solidClassic: 'Solid Classic',
    GlassStyle.opaqueHeavy: 'Opaque Heavy',
    GlassStyle.opaqueMat: 'Opaque Mat',
    GlassStyle.gradientOpaque: 'Gradient Opaque',
    GlassStyle.customGradient: 'Custom Gradient',
    GlassStyle.ghost: 'Ghost',
    GlassStyle.sage: 'Sage',
    GlassStyle.sagePro: 'Sage Pro',
    GlassStyle.sageOled: 'Sage OLED',
    GlassStyle.sageGlass: 'Sage Glass',
    GlassStyle.appBar: 'AppBar',
    GlassStyle.classicSb: 'Classic Subtle',
   
  };

  Widget _buildSwitchSlider({
    required String label,
    required bool enabled,
    required ValueChanged<bool> onToggle,
    required double value,
    required ValueChanged<double> onChanged,
    required double min,
    required double max,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _title(label, Colors.white.withOpacity(0.7)),
            Switch(
              value: enabled,
              onChanged: onToggle,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ],
        ),
        const SizedBox(height: 4),
        Opacity(
          opacity: enabled? 1.0 : 0.4,
          child: Slider(
            value: value,
            min: min,
            max: max,
            onChanged: enabled? onChanged : null,
          ),
        ),
      ],
    );
  }

  Widget _buildSlider({
    required String label,
    required double value,
    required ValueChanged<double> onChanged,
    required double min,
    required double max,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _title(label, Colors.white.withOpacity(0.7)),
        const SizedBox(height: 4),
        Slider(value: value, min: min, max: max, onChanged: onChanged),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading)
      // ignore: curly_braces_in_flow_control_structures
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: CircularProgressIndicator(),
        ),
      );
    if (_settings == null) return _buildError();

    final s = _settings!;
    final p = GlassColorPalette.fromMode(s.themeMode);
    final screenWidth = MediaQuery.sizeOf(context).width;
    final bool isSmallMobile = screenWidth < 375;
    final EdgeInsets dynamicPadding = EdgeInsets.all(isSmallMobile? 12 : 18);
    final Color accent = s.isAqua? s.activeColors.first : p.accent;
    final bool isClassicSb = s.glassStyle == GlassStyle.classicSb;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // CARTE 0: PRESETS
        _sectionCard(
          title: 'Presets Rapides',
          padding: dynamicPadding,
          children: [
            GlassResponsiveGrid(
              spacing: 10,
              runSpacing: 10,
              desktopColumns: 4,
              tabletColumns: 3,
              children: [
                GlassModeChip<GlassPreset>(
                  label: 'Aqua Frost',
                  icon: Icons.water_drop_outlined,
                  mode: GlassPreset.aquaFrost,
                  selected: _getCurrentPreset(s),
                  onSelected: _applyPreset,
                  accent: const Color(0xFF00BCD4),
                ),
                GlassModeChip<GlassPreset>(
                  label: 'Classic',
                  icon: Icons.layers_outlined,
                  mode: GlassPreset.classicDark,
                  selected: _getCurrentPreset(s),
                  onSelected: _applyPreset,
                  accent: const Color(0xFF9E9E9E),
                ),
                GlassModeChip<GlassPreset>(
                  label: 'Classic Sb',
                  icon: Icons.rectangle_outlined,
                  mode: GlassPreset.classicSb,
                  selected: _getCurrentPreset(s),
                  onSelected: _applyPreset,
                  accent: const Color(0xFFD4AF37),
                ),
                
                GlassModeChip<GlassPreset>(
                  label: 'Sage Pro',
                  icon: Icons.spa_outlined,
                  mode: GlassPreset.sagePro,
                  selected: _getCurrentPreset(s),
                  onSelected: _applyPreset,
                  accent: const Color(0xFF4CAF50),
                ),
                GlassModeChip<GlassPreset>(
                  label: 'Sage OLED',
                  icon: Icons.phone_android,
                  mode: GlassPreset.sageOled,
                  selected: _getCurrentPreset(s),
                  onSelected: _applyPreset,
                  accent: Colors.black,
                ),
                GlassModeChip<GlassPreset>(
                  label: 'Sage Glass',
                  icon: Icons.blur_on,
                  mode: GlassPreset.sageGlass,
                  selected: _getCurrentPreset(s),
                  onSelected: _applyPreset,
                  accent: const Color(0xFF2E7D32),
                ),
                GlassModeChip<GlassPreset>(
                  label: 'Light',
                  icon: Icons.light_mode,
                  mode: GlassPreset.light,
                  selected: _getCurrentPreset(s),
                  onSelected: _applyPreset,
                  accent: const Color(0xFFFFC107),
                ),
                GlassModeChip<GlassPreset>(
                  label: 'Dark',
                  icon: Icons.nightlight,
                  mode: GlassPreset.dark,
                  selected: _getCurrentPreset(s),
                  onSelected: _applyPreset,
                  accent: const Color(0xFF673AB7),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),

        // CARTE 1: MODE VISUEL
        _sectionCard(
          title: 'Mode Visuel',
          padding: dynamicPadding,
          children: [
            GlassResponsiveGrid(
              spacing: 10,
              runSpacing: 10,
              desktopColumns: 4,
              tabletColumns: 3,
              children: AppThemeMode.values
                 .where((e) => e!= AppThemeMode.system)
                 .map((mode) {
                    return GlassModeChip<AppThemeMode>(
                      label: _modeLabel(mode),
                      icon: _modeIcon(mode),
                      mode: mode,
                      selected: s.themeMode,
                      onSelected: _changeThemeMode,
                      accent: accent,
                    );
                  })
                 .toList(),
            ),
            if (!s.isSage &&!isClassicSb)...[
              const SizedBox(height: 20),
              _title('Couleurs Gradient', p.textSecondary),
              const SizedBox(height: 10),
              AppearanceColorPicker(
                colors: s.activeColors,
                onTap: (i) => _pickColor(i, s.isAqua),
              ),
              const SizedBox(height: 16),
              GlassResponsiveGrid(
                spacing: 16,
                runSpacing: 16,
                desktopColumns: 2,
                children: [
                  _buildSlider(
                    label: 'Opacité Gradient',
                    value: s.gradientOpacity,
                    onChanged: (v) =>
                        _update((x) => x.copyWith(gradientOpacity: v)),
                    min: 0,
                    max: 1,
                  ),
                  _buildSlider(
                    label: 'Densité Gradient',
                    value: s.gradientDensity.toDouble(),
                    onChanged: (v) =>
                        _update((x) => x.copyWith(gradientDensity: v.round())),
                    min: 1,
                    max: 10,
                  ),
                ],
              ),
            ],
            if (isClassicSb)...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFD4AF37).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFFD4AF37).withOpacity(0.3),
                  ),
                ),
                child: Text(
                  'Mode Classic Subtle: Gradient fixe #1A1A1A -> #121212, Bordure Or 1px',
                  style: TextStyle(color: p.textSecondary, fontSize: 12),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 16),

        // CARTE 2: SURFACE & EFFETS
        if (!isClassicSb)...[
          _sectionCard(
            title: 'Surface & Effets',
            padding: dynamicPadding,
            children: [
              GlassResponsiveGrid(
                spacing: 16,
                runSpacing: 16,
                desktopColumns: 3,
                children: [
                  _buildSwitchSlider(
                    label: 'Blur',
                    enabled: s.enableBlur,
                    onToggle: (v) => _update((x) => x.copyWith(enableBlur: v)),
                    value: s.blur,
                    onChanged: (v) => _update((x) => x.copyWith(blur: v)),
                    min: 0,
                    max: 50,
                  ),
                  _buildSwitchSlider(
                    label: 'Noise',
                    enabled: s.enableNoise,
                    onToggle: (v) => _update((x) => x.copyWith(enableNoise: v)),
                    value: s.noise,
                    onChanged: (v) => _update((x) => x.copyWith(noise: v)),
                    min: 0,
                    max: 1,
                  ),
                  _buildSlider(
                    label: 'Opacité Surface',
                    value: s.surfaceOpacity,
                    onChanged: (v) =>
                        _update((x) => x.copyWith(surfaceOpacity: v)),
                    min: 0,
                    max: 1,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              GlassResponsiveGrid(
                spacing: 16,
                runSpacing: 16,
                desktopColumns: 2,
                children: [
                  _buildSwitchSlider(
                    label: 'Hover',
                    enabled: s.enableHover,
                    onToggle: (v) => _update((x) => x.copyWith(enableHover: v)),
                    value: s.hoverLift,
                    onChanged: (v) => _update((x) => x.copyWith(hoverLift: v)),
                    min: 0,
                    max: 20,
                  ),
                  _buildSlider(
                    label: 'Border Radius',
                    value: s.borderRadius,
                    onChanged: (v) =>
                        _update((x) => x.copyWith(borderRadius: v)),
                    min: 0,
                    max: 40,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],

        // CARTE 3: STYLE DE SURFACE
        _sectionCard(
          title: 'Style de Surface',
          padding: const EdgeInsets.all(20),
          children: [
            DropdownButtonFormField<GlassStyle>(
              value: s.glassStyle,
              dropdownColor: const Color(0xFF1E1E1E),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
              items: GlassStyle.values.map((style) {
                return DropdownMenuItem(
                  value: style,
                  child: Text(
                    glassStyleLabels[style]?? style.name,
                    style: TextStyle(color: p.textPrimary),
                  ),
                );
              }).toList(),
              onChanged: (val) {
                if (val!= null) _changeGlassStyle(val);
              },
            ),
          ],
        ),
        const SizedBox(height: 16),

        // CARTE 4: BORDURE & OMBRE & GLOW
        _sectionCard(
          title: 'Bordure & Ombre & Glow',
          padding: dynamicPadding,
          children: [
            GlassResponsiveGrid(
              spacing: 16,
              runSpacing: 16,
              desktopColumns: 3,
              children: [
                _buildSwitchSlider(
                  label: 'Bordure',
                  enabled: s.enableBorder,
                  onToggle: (v) => _update((x) => x.copyWith(enableBorder: v)),
                  value: s.borderWidth,
                  onChanged: (v) => _update((x) => x.copyWith(borderWidth: v)),
                  min: 0,
                  max: 5,
                ),
                _buildSlider(
                  label: 'Opacité Bordure',
                  value: s.borderOpacity,
                  onChanged: (v) =>
                      _update((x) => x.copyWith(borderOpacity: v)),
                  min: 0,
                  max: 1,
                ),
                if (!isClassicSb)
                  _buildSwitchSlider(
                    label: 'Glow',
                    enabled: s.enableGlow,
                    onToggle: (v) => _update((x) => x.copyWith(enableGlow: v)),
                    value: s.glowBlur,
                    onChanged: (v) => _update((x) => x.copyWith(glowBlur: v)),
                    min: 0,
                    max: 50,
                  ),
              ],
            ),
            const SizedBox(height: 16),
            GlassResponsiveGrid(
              spacing: 16,
              runSpacing: 16,
              desktopColumns: 3,
              children: [
                if (!isClassicSb)
                  _buildSlider(
                    label: 'Opacité Glow',
                    value: s.glowOpacity,
                    onChanged: (v) =>
                        _update((x) => x.copyWith(glowOpacity: v)),
                    min: 0,
                    max: 1,
                  ),
                _buildSwitchSlider(
                  label: 'Ombre',
                  enabled: s.enableShadow,
                  onToggle: (v) => _update((x) => x.copyWith(enableShadow: v)),
                  value: s.shadowBlur,
                  onChanged: (v) => _update((x) => x.copyWith(shadowBlur: v)),
                  min: 0,
                  max: 50,
                ),
                _buildSlider(
                  label: 'Opacité Ombre',
                  value: s.shadowOpacity,
                  onChanged: (v) =>
                      _update((x) => x.copyWith(shadowOpacity: v)),
                  min: 0,
                  max: 1,
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildSlider(
              label: 'Offset Y Ombre',
              value: s.shadowOffsetY,
              onChanged: (v) => _update((x) => x.copyWith(shadowOffsetY: v)),
              min: -20,
              max: 20,
            ),
          ],
        ),
        const SizedBox(height: 16),

        // CARTE 5: APERCU LIVE
        GlassSurfaceContainer(
          style: s.glassStyle,
          customGradient: isClassicSb
             ? null
              : (s.isSage? const [] : s.activeColors),
          padding: dynamicPadding,
          borderRadius: BorderRadius.circular(isSmallMobile? 14 : 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(p),
              const SizedBox(height: 12),
              AppearanceLivePreview(
                mode: s.themeMode,
                palette: p,
                aquaColors: s.aquaColors,
                classicColors: s.classicColors,
              ),
              const SizedBox(height: 20),
              _buildResetButton(p),
              if (_saving)...[
                const SizedBox(height: 8),
                _buildSavingIndicator(p),
              ],
              if (_error!= null)...[
                const SizedBox(height: 12),
                _buildInlineError(),
              ],
            ],
          ),
        ),
        const SizedBox(height: 16),

        // CARTE 6: APERCU BIENVENUE
        GlassSurfaceContainer(
          style: s.glassStyle,
          customGradient: null,
          padding: dynamicPadding,
          borderRadius: BorderRadius.circular(
            s.glassStyle == GlassStyle.classicSb
               ? 26
                : (isSmallMobile? 14 : 20),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'BIENVENUE',
                      style: TextStyle(
                        color: accent,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.6,
                      ),
                    ),
                    const SizedBox(height: 9),
                    Text(
                      'Votre espace de contrôle Glass',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        height: 1.15,
                      ),
                    ),
                    const SizedBox(height: 9),
                    Text(
                      'Accédez rapidement à vos contrôles, réglages et outils.',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 13,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
              if (!isSmallMobile)...[
                const SizedBox(width: 30),
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: accent.withValues(alpha:.045),
                  ),
                  child: Icon(
                    Icons.dashboard_customize_outlined,
                    size: 62,
                    color: accent.withValues(alpha:.32),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  GlassPreset _getCurrentPreset(AppearanceSettings s) {
    if (s.glassStyle == GlassStyle.classicSb) return GlassPreset.classicSb;
    if (s.themeMode == AppThemeMode.aqua && s.blur > 15)
      // ignore: curly_braces_in_flow_control_structures
      return GlassPreset.aquaFrost;
    if (s.themeMode == AppThemeMode.classic) return GlassPreset.classicDark;
    if (s.themeMode == AppThemeMode.sagePro) return GlassPreset.sagePro;
    if (s.themeMode == AppThemeMode.sageOled) return GlassPreset.sageOled;
    if (s.themeMode == AppThemeMode.sageGlass) return GlassPreset.sageGlass;
    if (s.themeMode == AppThemeMode.light) return GlassPreset.light;
    return GlassPreset.dark;
  }

  String _modeLabel(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.aqua: return 'Aqua';
      case AppThemeMode.classic: return 'Classic';
      case AppThemeMode.sage: return 'Sage';
      case AppThemeMode.sagePro: return 'Sage Pro';
      case AppThemeMode.sageOled: return 'Sage OLED';
      case AppThemeMode.sageGlass: return 'Sage Glass';
      case AppThemeMode.light: return 'Light';
      case AppThemeMode.dark: return 'Dark';
      case AppThemeMode.system: return 'System';
    }
  }

  IconData _modeIcon(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.aqua: return Icons.water_drop;
      case AppThemeMode.classic: return Icons.layers;
      case AppThemeMode.sage: return Icons.spa;
      case AppThemeMode.sagePro: return Icons.verified;
      case AppThemeMode.sageOled: return Icons.phone_android;
      case AppThemeMode.sageGlass: return Icons.blur_on;
      case AppThemeMode.light: return Icons.light_mode;
      case AppThemeMode.dark: return Icons.dark_mode;
      case AppThemeMode.system: return Icons.settings_system_daydream;
    }
  }

  Widget _sectionCard({
    required String title,
    required EdgeInsets padding,
    required List<Widget> children,
  }) {
    return GlassSurfaceContainer(
      style: GlassStyle.opaqueMat,
      padding: padding,
      borderRadius: BorderRadius.circular(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _title(title, Colors.white, bold: true),
          const SizedBox(height: 16),
         ...children,
        ],
      ),
    );
  }

  Widget _buildHeader(GlassColorPalette p) => Row(
    children: [
      Expanded(
        child: Text(
          'Aperçu en direct',
          style: TextStyle(
            color: p.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      if (_saving)
        const SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
    ],
  );

  Widget _title(String t, Color c, {bool bold = false}) => Text(
    t,
    style: TextStyle(
      color: c,
      fontSize: bold? 15 : 13,
      fontWeight: bold? FontWeight.w700 : FontWeight.w600,
    ),
  );

  Widget _buildResetButton(GlassColorPalette p) => Align(
    alignment: Alignment.centerRight,
    child: TextButton.icon(
      onPressed: _saving? null : _reset,
      icon: const Icon(Icons.restore, size: 18),
      label: const Text('Réinitialiser'),
      style: TextButton.styleFrom(foregroundColor: p.textSecondary),
    ),
  );

  Widget _buildSavingIndicator(GlassColorPalette p) {
    final mode = _settings?.themeMode?? AppThemeMode.aqua;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 12,
          height: 12,
          child: CircularProgressIndicator(
            strokeWidth: 1.5,
            color: p.primaryForMode(mode),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          'Enregistrement...',
          style: TextStyle(color: p.textSecondary, fontSize: 11),
        ),
      ],
    );
  }

  Widget _buildError() => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(20),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.error_outline, size: 32),
        const SizedBox(height: 10),
        const Text(
          'Impossible de charger les paramètres.',
          textAlign: TextAlign.center,
        ),
        if (_error!= null)...[
          const SizedBox(height: 6),
          Text(
            _error!,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 11),
          ),
        ],
        const SizedBox(height: 12),
        FilledButton.icon(
          onPressed: _load,
          icon: const Icon(Icons.refresh),
          label: const Text('Réessayer'),
        ),
      ],
    ),
  );

  Widget _buildInlineError() => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Icon(Icons.warning_amber_rounded, size: 16),
      const SizedBox(width: 8),
      Expanded(child: Text(_error!, style: const TextStyle(fontSize: 11))),
    ],
  );
}