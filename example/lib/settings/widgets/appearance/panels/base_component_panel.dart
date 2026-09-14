import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:universal_glass/glass.dart';
import 'package:universal_glass_example/settings/widgets/appearance/appearance_component_settings_section.dart';
import 'package:universal_glass_example/settings/widgets/appearance/appearance_profiles_provider.dart';
import 'package:universal_glass_example/settings/widgets/appearance/appearance_settings.dart';

typedef SettingsSelector<T extends AppearanceComponentSettings> = T Function(AppearanceSettings settings);
typedef SettingsUpdater<T extends AppearanceComponentSettings> = AppearanceSettings Function(AppearanceSettings settings, T value);
typedef PreviewBuilder<T extends AppearanceComponentSettings> = Widget Function(T settings, GlassColorPalette palette);

class BaseComponentPanel<T extends AppearanceComponentSettings> extends ConsumerWidget {
  const BaseComponentPanel({
    super.key,
    required this.mode,
    required this.selector,
    required this.updater,
    required this.previewBuilder,
    this.title = 'Component',
    this.showLayout = true,
    this.extraLayout,
  });

  final AppThemeMode mode;
  final SettingsSelector<T> selector;
  final SettingsUpdater<T> updater;
  final PreviewBuilder<T> previewBuilder;
  final String title;
  final bool showLayout;
  final Widget Function(T s, WidgetRef ref, void Function(T Function(T) fn) update)? extraLayout;

  Future<void> _update(WidgetRef ref, T Function(T value) fn) {
    return ref.read(appearanceProfilesProvider.notifier).updateProfile(mode, (AppearanceSettings current) {
      final T currentValue = selector(current);
      final T newValue = fn(currentValue);
      return updater(current, newValue);
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppearanceSettings profile = ref.watch(appearanceProfileProvider(mode));
    final T settings = selector(profile);
    final GlassColorPalette palette = GlassColorPalette.fromMode(mode);

    // WRAPPER: on capture ref ici
    void handleUpdate(T Function(T) fn) => _update(ref, fn);

    return ComponentLayout(
      controls: <Widget>[
        ControlSection(
          title: 'Activation',
          icon: Icons.power_settings_new_rounded,
          child: SwitchRow(
            title: 'Enable $title',
            value: settings.enabled,
            palette: palette,
            onChanged: (bool value) => handleUpdate((c) => c.copyWith(enabled: value) as T),
          ),
        ),
        const SizedBox(height: 12),
        _buildSurfaceControls(settings, palette, handleUpdate),
        const SizedBox(height: 12),
        _buildBorderControls(settings, palette, handleUpdate),
        const SizedBox(height: 12),
        _buildShadowControls(settings, palette, handleUpdate),
        const SizedBox(height: 12),
        _buildInteractionControls(settings, palette, handleUpdate),
        if (showLayout) ...[
          const SizedBox(height: 12),
          _buildLayoutControls(settings, palette, handleUpdate),
        ],
        if (extraLayout != null) ...[
          const SizedBox(height: 12),
          extraLayout!(settings, ref, handleUpdate), // <- MAINTENANT OK
        ],
      ],
      preview: previewBuilder(settings, palette),
    );
  }

  Widget _buildSurfaceControls(T s, GlassColorPalette palette, void Function(T Function(T)) update) => ControlSection(
        title: 'Surface', icon: Icons.layers_outlined,
        child: Column(children: <Widget>[
          SwitchRow(title: 'Enable blur', value: s.enableBlur, palette: palette, enabled: s.enabled, onChanged: (v) => update((c) => c.copyWith(enableBlur: v) as T)),
          SliderRow(label: 'Blur', value: s.blur, min: 0, max: 40, divisions: 80, enabled: s.enabled && s.enableBlur, valueLabel: s.blur.toStringAsFixed(1), onChanged: (v) => update((c) => c.copyWith(blur: v) as T)),
          SliderRow(label: 'Background opacity', value: s.backgroundOpacity, min: 0, max: 1, divisions: 100, enabled: s.enabled, valueLabel: '${(s.backgroundOpacity * 100).round()}%', onChanged: (v) => update((c) => c.copyWith(backgroundOpacity: v) as T)),
        ]),
      );

  Widget _buildBorderControls(T s, GlassColorPalette palette, void Function(T Function(T)) update) => ControlSection(
        title: 'Border', icon: Icons.crop_square_rounded,
        child: Column(children: <Widget>[
          SwitchRow(title: 'Enable border', value: s.enableBorder, palette: palette, enabled: s.enabled, onChanged: (v) => update((c) => c.copyWith(enableBorder: v) as T)),
          SliderRow(label: 'Border opacity', value: s.borderOpacity, min: 0, max: 1, divisions: 100, enabled: s.enabled && s.enableBorder, valueLabel: '${(s.borderOpacity * 100).round()}%', onChanged: (v) => update((c) => c.copyWith(borderOpacity: v) as T)),
          SliderRow(label: 'Border width', value: s.borderWidth, min: 0, max: 4, divisions: 80, enabled: s.enabled && s.enableBorder, valueLabel: s.borderWidth.toStringAsFixed(2), onChanged: (v) => update((c) => c.copyWith(borderWidth: v) as T)),
          SliderRow(label: 'Border radius', value: s.borderRadius, min: 0, max: 48, divisions: 96, enabled: s.enabled, valueLabel: s.borderRadius.toStringAsFixed(0), onChanged: (v) => update((c) => c.copyWith(borderRadius: v) as T)),
        ]),
      );

  Widget _buildShadowControls(T s, GlassColorPalette palette, void Function(T Function(T)) update) => ControlSection(
        title: 'Shadow', icon: Icons.blur_on_rounded,
        child: Column(children: <Widget>[
          SwitchRow(title: 'Enable shadow', value: s.enableShadow, palette: palette, enabled: s.enabled, onChanged: (v) => update((c) => c.copyWith(enableShadow: v) as T)),
          SliderRow(label: 'Shadow opacity', value: s.shadowOpacity, min: 0, max: 1, divisions: 100, enabled: s.enabled && s.enableShadow, valueLabel: '${(s.shadowOpacity * 100).round()}%', onChanged: (v) => update((c) => c.copyWith(shadowOpacity: v) as T)),
          SliderRow(label: 'Shadow blur', value: s.shadowBlur, min: 0, max: 40, divisions: 80, enabled: s.enabled && s.enableShadow, valueLabel: s.shadowBlur.toStringAsFixed(1), onChanged: (v) => update((c) => c.copyWith(shadowBlur: v) as T)),
          SliderRow(label: 'Shadow offset Y', value: s.shadowOffsetY, min: -30, max: 30, divisions: 120, enabled: s.enabled && s.enableShadow, valueLabel: s.shadowOffsetY.toStringAsFixed(1), onChanged: (v) => update((c) => c.copyWith(shadowOffsetY: v) as T)),
        ]),
      );

  Widget _buildInteractionControls(T s, GlassColorPalette palette, void Function(T Function(T)) update) => ControlSection(
        title: 'Interaction', icon: Icons.touch_app_outlined,
        child: Column(children: <Widget>[
          SwitchRow(title: 'Enable hover', value: s.enableHover, palette: palette, enabled: s.enabled, onChanged: (v) => update((c) => c.copyWith(enableHover: v) as T)),
          SliderRow(label: 'Hover lift', value: s.hoverLift, min: 0, max: 12, divisions: 48, enabled: s.enabled && s.enableHover, valueLabel: s.hoverLift.toStringAsFixed(1), onChanged: (v) => update((c) => c.copyWith(hoverLift: v) as T)),
        ]),
      );

  Widget _buildLayoutControls(T s, GlassColorPalette palette, void Function(T Function(T)) update) => ControlSection(
        title: 'Layout', icon: Icons.space_bar_rounded,
        child: Column(children: <Widget>[
          SliderRow(label: 'Horizontal padding', value: s.horizontalPadding, min: 0, max: 40, divisions: 80, enabled: s.enabled, valueLabel: s.horizontalPadding.toStringAsFixed(1), onChanged: (v) => update((c) => c.copyWith(horizontalPadding: v) as T)),
          SliderRow(label: 'Vertical padding', value: s.verticalPadding, min: 0, max: 32, divisions: 64, enabled: s.enabled, valueLabel: s.verticalPadding.toStringAsFixed(1), onChanged: (v) => update((c) => c.copyWith(verticalPadding: v) as T)),
        ]),
      );
}