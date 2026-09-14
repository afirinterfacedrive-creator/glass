part of 'appearance_component_settings_section.dart';

class _FormPanel extends ConsumerWidget {
  const _FormPanel({
    required this.mode,
    required this.settings,
    required this.palette,
  });
  final AppThemeMode mode;
  final AppearanceFormSettings settings;
  final GlassColorPalette palette;
  Future<void> _update(
    WidgetRef ref,
    AppearanceFormSettings Function(AppearanceFormSettings value) updater,
  ) {
    return ref.read(appearanceProfilesProvider.notifier).updateProfile(mode, (
      AppearanceSettings value,
    ) {
      return value.copyWith(form: updater(value.form));
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ComponentLayout(
      controls: <Widget>[
        ControlSection(
          title: 'Activation',
          icon: Icons.power_settings_new_rounded,
          child: SwitchRow(
            title: 'Enable form',
            subtitle: 'Cliquez sur switch pour activer/désactiver',
            value: settings.enabled,
            palette: palette,
            onChanged: (bool value) {
              _update(ref, (AppearanceFormSettings current) {
                return current.copyWith(enabled: value);
              });
            },
          ),
        ),
        const SizedBox(height: 12),
        ControlSection(
          title: 'Surface',
          icon: Icons.layers_outlined,
          child: Column(
            children: <Widget>[
              SwitchRow(
                title: 'Enable blur',
                value: settings.enableBlur,
                palette: palette,
                enabled: settings.enabled,
                onChanged: (bool value) {
                  _update(ref, (AppearanceFormSettings current) {
                    return current.copyWith(enableBlur: value);
                  });
                },
              ),
              SliderRow(
                label: 'Blur',
                value: settings.blur,
                min: 0,
                max: 40,
                divisions: 80,
                enabled: settings.enabled && settings.enableBlur,
                valueLabel: settings.blur.toStringAsFixed(1),
                onChanged: (double value) {
                  _update(ref, (AppearanceFormSettings current) {
                    return current.copyWith(blur: value);
                  });
                },
              ),
              SliderRow(
                label: 'Background opacity',
                value: settings.backgroundOpacity,
                min: 0,
                max: 1,
                divisions: 100,
                enabled: settings.enabled,
                valueLabel: '${(settings.backgroundOpacity * 100).round()}%',
                onChanged: (double value) {
                  _update(ref, (AppearanceFormSettings current) {
                    return current.copyWith(backgroundOpacity: value);
                  });
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        ControlSection(
          title: 'Border',
          icon: Icons.crop_square_rounded,
          child: Column(
            children: <Widget>[
              SwitchRow(
                title: 'Enable border',
                value: settings.enableBorder,
                palette: palette,
                enabled: settings.enabled,
                onChanged: (bool value) {
                  _update(ref, (AppearanceFormSettings current) {
                    return current.copyWith(enableBorder: value);
                  });
                },
              ),
              SliderRow(
                label: 'Border opacity',
                value: settings.borderOpacity,
                min: 0,
                max: 1,
                divisions: 100,
                enabled: settings.enabled && settings.enableBorder,
                valueLabel: '${(settings.borderOpacity * 100).round()}%',
                onChanged: (double value) {
                  _update(ref, (AppearanceFormSettings current) {
                    return current.copyWith(borderOpacity: value);
                  });
                },
              ),
              SliderRow(
                label: 'Border width',
                value: settings.borderWidth,
                min: 0,
                max: 4,
                divisions: 80,
                enabled: settings.enabled && settings.enableBorder,
                valueLabel: settings.borderWidth.toStringAsFixed(2),
                onChanged: (double value) {
                  _update(ref, (AppearanceFormSettings current) {
                    return current.copyWith(borderWidth: value);
                  });
                },
              ),
              SliderRow(
                label: 'Border radius',
                value: settings.borderRadius,
                min: 0,
                max: 48,
                divisions: 96,
                enabled: settings.enabled,
                valueLabel: settings.borderRadius.toStringAsFixed(0),
                onChanged: (double value) {
                  _update(ref, (AppearanceFormSettings current) {
                    return current.copyWith(borderRadius: value);
                  });
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        ControlSection(
          title: 'Shadow',
          icon: Icons.blur_on_rounded,
          child: Column(
            children: <Widget>[
              SwitchRow(
                title: 'Enable shadow',
                value: settings.enableShadow,
                palette: palette,
                enabled: settings.enabled,
                onChanged: (bool value) {
                  _update(ref, (AppearanceFormSettings current) {
                    return current.copyWith(enableShadow: value);
                  });
                },
              ),
              SliderRow(
                label: 'Shadow opacity',
                value: settings.shadowOpacity,
                min: 0,
                max: 1,
                divisions: 100,
                enabled: settings.enabled && settings.enableShadow,
                valueLabel: '${(settings.shadowOpacity * 100).round()}%',
                onChanged: (double value) {
                  _update(ref, (AppearanceFormSettings current) {
                    return current.copyWith(shadowOpacity: value);
                  });
                },
              ),
              SliderRow(
                label: 'Shadow blur',
                value: settings.shadowBlur,
                min: 0,
                max: 40,
                divisions: 80,
                enabled: settings.enabled && settings.enableShadow,
                valueLabel: settings.shadowBlur.toStringAsFixed(1),
                onChanged: (double value) {
                  _update(ref, (AppearanceFormSettings current) {
                    return current.copyWith(shadowBlur: value);
                  });
                },
              ),
              SliderRow(
                label: 'Shadow offset Y',
                value: settings.shadowOffsetY,
                min: -30,
                max: 30,
                divisions: 120,
                enabled: settings.enabled && settings.enableShadow,
                valueLabel: settings.shadowOffsetY.toStringAsFixed(1),
                onChanged: (double value) {
                  _update(ref, (AppearanceFormSettings current) {
                    return current.copyWith(shadowOffsetY: value);
                  });
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        ControlSection(
          title: 'Layout',
          icon: Icons.space_bar_rounded,
          child: Column(
            children: <Widget>[
              SliderRow(
                label: 'Field spacing',
                value: settings.fieldSpacing,
                min: 0,
                max: 40,
                divisions: 80,
                enabled: settings.enabled,
                valueLabel: settings.fieldSpacing.toStringAsFixed(1),
                onChanged: (double value) {
                  _update(ref, (AppearanceFormSettings current) {
                    return current.copyWith(fieldSpacing: value);
                  });
                },
              ),
              SliderRow(
                label: 'Section spacing',
                value: settings.sectionSpacing,
                min: 0,
                max: 60,
                divisions: 120,
                enabled: settings.enabled,
                valueLabel: settings.sectionSpacing.toStringAsFixed(1),
                onChanged: (double value) {
                  _update(ref, (AppearanceFormSettings current) {
                    return current.copyWith(sectionSpacing: value);
                  });
                },
              ),
              SliderRow(
                label: 'Actions spacing',
                value: settings.actionsSpacing,
                min: 0,
                max: 40,
                divisions: 80,
                enabled: settings.enabled,
                valueLabel: settings.actionsSpacing.toStringAsFixed(1),
                onChanged: (double value) {
                  _update(ref, (AppearanceFormSettings current) {
                    return current.copyWith(actionsSpacing: value);
                  });
                },
              ),
              SliderRow(
                label: 'Horizontal padding',
                value: settings.horizontalPadding,
                min: 0,
                max: 40,
                divisions: 80,
                enabled: settings.enabled,
                valueLabel: settings.horizontalPadding.toStringAsFixed(1),
                onChanged: (double value) {
                  _update(ref, (AppearanceFormSettings current) {
                    return current.copyWith(horizontalPadding: value);
                  });
                },
              ),
              SliderRow(
                label: 'Vertical padding',
                value: settings.verticalPadding,
                min: 0,
                max: 40,
                divisions: 80,
                enabled: settings.enabled,
                valueLabel: settings.verticalPadding.toStringAsFixed(1),
                onChanged: (double value) {
                  _update(ref, (AppearanceFormSettings current) {
                    return current.copyWith(verticalPadding: value);
                  });
                },
              ),
            ],
          ),
        ),
      ],
      preview: _FormPreview(mode: mode, settings: settings, palette: palette),
    );
  }
}

class _InputPanel extends ConsumerWidget {
  const _InputPanel({
    required this.mode,
    required this.settings,
    required this.palette,
  });
  final AppThemeMode mode;
  final AppearanceInputSettings settings;
  final GlassColorPalette palette;
  Future<void> _update(
    WidgetRef ref,
    AppearanceInputSettings Function(AppearanceInputSettings value) updater,
  ) {
    return ref.read(appearanceProfilesProvider.notifier).updateProfile(mode, (
      AppearanceSettings value,
    ) {
      return value.copyWith(input: updater(value.input));
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ComponentLayout(
      controls: <Widget>[
        ControlSection(
          title: 'Activation',
          icon: Icons.power_settings_new_rounded,
          child: SwitchRow(
            title: 'Enable input',
            value: settings.enabled,
            palette: palette,
            onChanged: (bool value) {
              _update(ref, (AppearanceInputSettings current) {
                return current.copyWith(enabled: value);
              });
            },
          ),
        ),
        const SizedBox(height: 12),
        ControlSection(
          title: 'Surface',
          icon: Icons.layers_outlined,
          child: Column(
            children: <Widget>[
              SwitchRow(
                title: 'Enable blur',
                value: settings.enableBlur,
                palette: palette,
                enabled: settings.enabled,
                onChanged: (bool value) {
                  _update(ref, (AppearanceInputSettings current) {
                    return current.copyWith(enableBlur: value);
                  });
                },
              ),
              SliderRow(
                label: 'Blur',
                value: settings.blur,
                min: 0,
                max: 40,
                divisions: 80,
                enabled: settings.enabled && settings.enableBlur,
                valueLabel: settings.blur.toStringAsFixed(1),
                onChanged: (double value) {
                  _update(ref, (AppearanceInputSettings current) {
                    return current.copyWith(blur: value);
                  });
                },
              ),
              SliderRow(
                label: 'Background opacity',
                value: settings.backgroundOpacity,
                min: 0,
                max: 1,
                divisions: 100,
                enabled: settings.enabled,
                valueLabel: '${(settings.backgroundOpacity * 100).round()}%',
                onChanged: (double value) {
                  _update(ref, (AppearanceInputSettings current) {
                    return current.copyWith(backgroundOpacity: value);
                  });
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        ControlSection(
          title: 'Border',
          icon: Icons.crop_square_rounded,
          child: Column(
            children: <Widget>[
              SwitchRow(
                title: 'Enable border',
                value: settings.enableBorder,
                palette: palette,
                enabled: settings.enabled,
                onChanged: (bool value) {
                  _update(ref, (AppearanceInputSettings current) {
                    return current.copyWith(enableBorder: value);
                  });
                },
              ),
              SliderRow(
                label: 'Border opacity',
                value: settings.borderOpacity,
                min: 0,
                max: 1,
                divisions: 100,
                enabled: settings.enabled && settings.enableBorder,
                valueLabel: '${(settings.borderOpacity * 100).round()}%',
                onChanged: (double value) {
                  _update(ref, (AppearanceInputSettings current) {
                    return current.copyWith(borderOpacity: value);
                  });
                },
              ),
              SliderRow(
                label: 'Border width',
                value: settings.borderWidth,
                min: 0,
                max: 4,
                divisions: 80,
                enabled: settings.enabled && settings.enableBorder,
                valueLabel: settings.borderWidth.toStringAsFixed(2),
                onChanged: (double value) {
                  _update(ref, (AppearanceInputSettings current) {
                    return current.copyWith(borderWidth: value);
                  });
                },
              ),
              SliderRow(
                label: 'Border radius',
                value: settings.borderRadius,
                min: 0,
                max: 48,
                divisions: 96,
                enabled: settings.enabled,
                valueLabel: settings.borderRadius.toStringAsFixed(0),
                onChanged: (double value) {
                  _update(ref, (AppearanceInputSettings current) {
                    return current.copyWith(borderRadius: value);
                  });
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        ControlSection(
          title: 'Shadow',
          icon: Icons.blur_on_rounded,
          child: Column(
            children: <Widget>[
              SwitchRow(
                title: 'Enable shadow',
                value: settings.enableShadow,
                palette: palette,
                enabled: settings.enabled,
                onChanged: (bool value) {
                  _update(ref, (AppearanceInputSettings current) {
                    return current.copyWith(enableShadow: value);
                  });
                },
              ),
              SliderRow(
                label: 'Shadow opacity',
                value: settings.shadowOpacity,
                min: 0,
                max: 1,
                divisions: 100,
                enabled: settings.enabled && settings.enableShadow,
                valueLabel: '${(settings.shadowOpacity * 100).round()}%',
                onChanged: (double value) {
                  _update(ref, (AppearanceInputSettings current) {
                    return current.copyWith(shadowOpacity: value);
                  });
                },
              ),
              SliderRow(
                label: 'Shadow blur',
                value: settings.shadowBlur,
                min: 0,
                max: 40,
                divisions: 80,
                enabled: settings.enabled && settings.enableShadow,
                valueLabel: settings.shadowBlur.toStringAsFixed(1),
                onChanged: (double value) {
                  _update(ref, (AppearanceInputSettings current) {
                    return current.copyWith(shadowBlur: value);
                  });
                },
              ),
              SliderRow(
                label: 'Shadow offset Y',
                value: settings.shadowOffsetY,
                min: -30,
                max: 30,
                divisions: 120,
                enabled: settings.enabled && settings.enableShadow,
                valueLabel: settings.shadowOffsetY.toStringAsFixed(1),
                onChanged: (double value) {
                  _update(ref, (AppearanceInputSettings current) {
                    return current.copyWith(shadowOffsetY: value);
                  });
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        ControlSection(
          title: 'Interaction',
          icon: Icons.touch_app_outlined,
          child: Column(
            children: <Widget>[
              SwitchRow(
                title: 'Enable hover',
                value: settings.enableHover,
                palette: palette,
                enabled: settings.enabled,
                onChanged: (bool value) {
                  _update(ref, (AppearanceInputSettings current) {
                    return current.copyWith(enableHover: value);
                  });
                },
              ),
              SliderRow(
                label: 'Hover lift',
                value: settings.hoverLift,
                min: 0,
                max: 12,
                divisions: 48,
                enabled: settings.enabled && settings.enableHover,
                valueLabel: settings.hoverLift.toStringAsFixed(1),
                onChanged: (double value) {
                  _update(ref, (AppearanceInputSettings current) {
                    return current.copyWith(hoverLift: value);
                  });
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        ControlSection(
          title: 'Layout',
          icon: Icons.straighten_rounded,
          child: Column(
            children: <Widget>[
              SliderRow(
                label: 'Field height',
                value: settings.fieldHeight,
                min: 36,
                max: 80,
                divisions: 88,
                enabled: settings.enabled,
                valueLabel: settings.fieldHeight.toStringAsFixed(1),
                onChanged: (double value) {
                  _update(ref, (AppearanceInputSettings current) {
                    return current.copyWith(fieldHeight: value);
                  });
                },
              ),
              SliderRow(
                label: 'Horizontal padding',
                value: settings.horizontalPadding,
                min: 0,
                max: 40,
                divisions: 80,
                enabled: settings.enabled,
                valueLabel: settings.horizontalPadding.toStringAsFixed(1),
                onChanged: (double value) {
                  _update(ref, (AppearanceInputSettings current) {
                    return current.copyWith(horizontalPadding: value);
                  });
                },
              ),
              SliderRow(
                label: 'Vertical padding',
                value: settings.verticalPadding,
                min: 0,
                max: 32,
                divisions: 64,
                enabled: settings.enabled,
                valueLabel: settings.verticalPadding.toStringAsFixed(1),
                onChanged: (double value) {
                  _update(ref, (AppearanceInputSettings current) {
                    return current.copyWith(verticalPadding: value);
                  });
                },
              ),
            ],
          ),
        ),
      ],
      preview: _InputPreview(mode: mode, settings: settings, palette: palette),
    );
  }
}

class _ModalDialogPanel extends ConsumerWidget {
  const _ModalDialogPanel({
    required this.mode,
    required this.settings,
    required this.palette,
  });
  final AppThemeMode mode;
  final AppearanceComponentSettings settings;
  final GlassColorPalette palette;
  Future<void> _update(
    WidgetRef ref,
    AppearanceComponentSettings Function(AppearanceComponentSettings value)
    updater,
  ) {
    return ref.read(appearanceProfilesProvider.notifier).updateProfile(mode, (
      AppearanceSettings value,
    ) {
      return value.copyWith(component: updater(value.component));
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ComponentLayout(
      controls: <Widget>[
        ControlSection(
          title: 'Activation',
          icon: Icons.power_settings_new_rounded,
          child: Column(
            children: <Widget>[
              SwitchRow(
                title: 'Enable modal/dialog',
                value: settings.enabled,
                palette: palette,
                onChanged: (bool value) {
                  _update(ref, (AppearanceComponentSettings current) {
                    return current.copyWith(enabled: value);
                  });
                },
              ),
              const SizedBox(height: 4),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Les Modal et Dialog partagent ce même paramétrage.',
                  style: TextStyle(
                    fontSize: 11,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.52),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        ControlSection(
          title: 'Surface',
          icon: Icons.layers_outlined,
          child: Column(
            children: <Widget>[
              SwitchRow(
                title: 'Enable blur',
                value: settings.enableBlur,
                palette: palette,
                enabled: settings.enabled,
                onChanged: (bool value) {
                  _update(ref, (AppearanceComponentSettings current) {
                    return current.copyWith(enableBlur: value);
                  });
                },
              ),
              SliderRow(
                label: 'Blur',
                value: settings.blur,
                min: 0,
                max: 40,
                divisions: 80,
                enabled: settings.enabled && settings.enableBlur,
                valueLabel: settings.blur.toStringAsFixed(1),
                onChanged: (double value) {
                  _update(ref, (AppearanceComponentSettings current) {
                    return current.copyWith(blur: value);
                  });
                },
              ),
              SliderRow(
                label: 'Background opacity',
                value: settings.backgroundOpacity,
                min: 0,
                max: 1,
                divisions: 100,
                enabled: settings.enabled,
                valueLabel: '${(settings.backgroundOpacity * 100).round()}%',
                onChanged: (double value) {
                  _update(ref, (AppearanceComponentSettings current) {
                    return current.copyWith(backgroundOpacity: value);
                  });
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        ControlSection(
          title: 'Border',
          icon: Icons.crop_square_rounded,
          child: Column(
            children: <Widget>[
              SwitchRow(
                title: 'Enable border',
                value: settings.enableBorder,
                palette: palette,
                enabled: settings.enabled,
                onChanged: (bool value) {
                  _update(ref, (AppearanceComponentSettings current) {
                    return current.copyWith(enableBorder: value);
                  });
                },
              ),
              SliderRow(
                label: 'Border opacity',
                value: settings.borderOpacity,
                min: 0,
                max: 1,
                divisions: 100,
                enabled: settings.enabled && settings.enableBorder,
                valueLabel: '${(settings.borderOpacity * 100).round()}%',
                onChanged: (double value) {
                  _update(ref, (AppearanceComponentSettings current) {
                    return current.copyWith(borderOpacity: value);
                  });
                },
              ),
              SliderRow(
                label: 'Border width',
                value: settings.borderWidth,
                min: 0,
                max: 4,
                divisions: 80,
                enabled: settings.enabled && settings.enableBorder,
                valueLabel: settings.borderWidth.toStringAsFixed(2),
                onChanged: (double value) {
                  _update(ref, (AppearanceComponentSettings current) {
                    return current.copyWith(borderWidth: value);
                  });
                },
              ),
              SliderRow(
                label: 'Border radius',
                value: settings.borderRadius,
                min: 0,
                max: 48,
                divisions: 96,
                enabled: settings.enabled,
                valueLabel: settings.borderRadius.toStringAsFixed(0),
                onChanged: (double value) {
                  _update(ref, (AppearanceComponentSettings current) {
                    return current.copyWith(borderRadius: value);
                  });
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        ControlSection(
          title: 'Shadow',
          icon: Icons.blur_on_rounded,
          child: Column(
            children: <Widget>[
              SwitchRow(
                title: 'Enable shadow',
                value: settings.enableShadow,
                palette: palette,
                enabled: settings.enabled,
                onChanged: (bool value) {
                  _update(ref, (AppearanceComponentSettings current) {
                    return current.copyWith(enableShadow: value);
                  });
                },
              ),
              SliderRow(
                label: 'Shadow opacity',
                value: settings.shadowOpacity,
                min: 0,
                max: 1,
                divisions: 100,
                enabled: settings.enabled && settings.enableShadow,
                valueLabel: '${(settings.shadowOpacity * 100).round()}%',
                onChanged: (double value) {
                  _update(ref, (AppearanceComponentSettings current) {
                    return current.copyWith(shadowOpacity: value);
                  });
                },
              ),
              SliderRow(
                label: 'Shadow blur',
                value: settings.shadowBlur,
                min: 0,
                max: 40,
                divisions: 80,
                enabled: settings.enabled && settings.enableShadow,
                valueLabel: settings.shadowBlur.toStringAsFixed(1),
                onChanged: (double value) {
                  _update(ref, (AppearanceComponentSettings current) {
                    return current.copyWith(shadowBlur: value);
                  });
                },
              ),
              SliderRow(
                label: 'Shadow offset Y',
                value: settings.shadowOffsetY,
                min: -30,
                max: 30,
                divisions: 120,
                enabled: settings.enabled && settings.enableShadow,
                valueLabel: settings.shadowOffsetY.toStringAsFixed(1),
                onChanged: (double value) {
                  _update(ref, (AppearanceComponentSettings current) {
                    return current.copyWith(shadowOffsetY: value);
                  });
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        ControlSection(
          title: 'Interaction',
          icon: Icons.touch_app_outlined,
          child: Column(
            children: <Widget>[
              SwitchRow(
                title: 'Enable hover',
                value: settings.enableHover,
                palette: palette,
                enabled: settings.enabled,
                onChanged: (bool value) {
                  _update(ref, (AppearanceComponentSettings current) {
                    return current.copyWith(enableHover: value);
                  });
                },
              ),
              SliderRow(
                label: 'Hover lift',
                value: settings.hoverLift,
                min: 0,
                max: 12,
                divisions: 48,
                enabled: settings.enabled && settings.enableHover,
                valueLabel: settings.hoverLift.toStringAsFixed(1),
                onChanged: (double value) {
                  _update(ref, (AppearanceComponentSettings current) {
                    return current.copyWith(hoverLift: value);
                  });
                },
              ),
            ],
          ),
        ),
      ],
      preview: _ModalDialogPreview(
        mode: mode,
        settings: settings,
        palette: palette,
      ),
    );
  }
}

class _ToastPanel extends ConsumerWidget {
  const _ToastPanel({
    required this.mode,
    required this.settings,
    required this.palette,
  });
  final AppThemeMode mode;
  final AppearanceToastSettings settings;
  final GlassColorPalette palette;
  Future<void> _update(
    WidgetRef ref,
    AppearanceToastSettings Function(AppearanceToastSettings value) updater,
  ) {
    return ref.read(appearanceProfilesProvider.notifier).updateProfile(mode, (
      AppearanceSettings value,
    ) {
      return value.copyWith(toast: updater(value.toast));
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ComponentLayout(
      controls: <Widget>[
        ControlSection(
          title: 'Activation',
          icon: Icons.power_settings_new_rounded,
          child: SwitchRow(
            title: 'Enable toast',
            value: settings.enabled,
            palette: palette,
            onChanged: (bool value) {
              _update(ref, (AppearanceToastSettings current) {
                return current.copyWith(enabled: value);
              });
            },
          ),
        ),
        const SizedBox(height: 12),
        ControlSection(
          title: 'Surface',
          icon: Icons.layers_outlined,
          child: Column(
            children: <Widget>[
              SwitchRow(
                title: 'Enable blur',
                value: settings.enableBlur,
                palette: palette,
                enabled: settings.enabled,
                onChanged: (bool value) {
                  _update(ref, (AppearanceToastSettings current) {
                    return current.copyWith(enableBlur: value);
                  });
                },
              ),
              SliderRow(
                label: 'Blur',
                value: settings.blur,
                min: 0,
                max: 40,
                divisions: 80,
                enabled: settings.enabled && settings.enableBlur,
                valueLabel: settings.blur.toStringAsFixed(1),
                onChanged: (double value) {
                  _update(ref, (AppearanceToastSettings current) {
                    return current.copyWith(blur: value);
                  });
                },
              ),
              SliderRow(
                label: 'Background opacity',
                value: settings.backgroundOpacity,
                min: 0,
                max: 1,
                divisions: 100,
                enabled: settings.enabled,
                valueLabel: '${(settings.backgroundOpacity * 100).round()}%',
                onChanged: (double value) {
                  _update(ref, (AppearanceToastSettings current) {
                    return current.copyWith(backgroundOpacity: value);
                  });
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        ControlSection(
          title: 'Border',
          icon: Icons.crop_square_rounded,
          child: Column(
            children: <Widget>[
              SwitchRow(
                title: 'Enable border',
                value: settings.enableBorder,
                palette: palette,
                enabled: settings.enabled,
                onChanged: (bool value) {
                  _update(ref, (AppearanceToastSettings current) {
                    return current.copyWith(enableBorder: value);
                  });
                },
              ),
              SliderRow(
                label: 'Border opacity',
                value: settings.borderOpacity,
                min: 0,
                max: 1,
                divisions: 100,
                enabled: settings.enabled && settings.enableBorder,
                valueLabel: '${(settings.borderOpacity * 100).round()}%',
                onChanged: (double value) {
                  _update(ref, (AppearanceToastSettings current) {
                    return current.copyWith(borderOpacity: value);
                  });
                },
              ),
              SliderRow(
                label: 'Border width',
                value: settings.borderWidth,
                min: 0,
                max: 4,
                divisions: 80,
                enabled: settings.enabled && settings.enableBorder,
                valueLabel: settings.borderWidth.toStringAsFixed(2),
                onChanged: (double value) {
                  _update(ref, (AppearanceToastSettings current) {
                    return current.copyWith(borderWidth: value);
                  });
                },
              ),
              SliderRow(
                label: 'Border radius',
                value: settings.borderRadius,
                min: 0,
                max: 48,
                divisions: 96,
                enabled: settings.enabled,
                valueLabel: settings.borderRadius.toStringAsFixed(0),
                onChanged: (double value) {
                  _update(ref, (AppearanceToastSettings current) {
                    return current.copyWith(borderRadius: value);
                  });
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        ControlSection(
          title: 'Shadow',
          icon: Icons.blur_on_rounded,
          child: Column(
            children: <Widget>[
              SwitchRow(
                title: 'Enable shadow',
                value: settings.enableShadow,
                palette: palette,
                enabled: settings.enabled,
                onChanged: (bool value) {
                  _update(ref, (AppearanceToastSettings current) {
                    return current.copyWith(enableShadow: value);
                  });
                },
              ),
              SliderRow(
                label: 'Shadow opacity',
                value: settings.shadowOpacity,
                min: 0,
                max: 1,
                divisions: 100,
                enabled: settings.enabled && settings.enableShadow,
                valueLabel: '${(settings.shadowOpacity * 100).round()}%',
                onChanged: (double value) {
                  _update(ref, (AppearanceToastSettings current) {
                    return current.copyWith(shadowOpacity: value);
                  });
                },
              ),
              SliderRow(
                label: 'Shadow blur',
                value: settings.shadowBlur,
                min: 0,
                max: 40,
                divisions: 80,
                enabled: settings.enabled && settings.enableShadow,
                valueLabel: settings.shadowBlur.toStringAsFixed(1),
                onChanged: (double value) {
                  _update(ref, (AppearanceToastSettings current) {
                    return current.copyWith(shadowBlur: value);
                  });
                },
              ),
              SliderRow(
                label: 'Shadow offset Y',
                value: settings.shadowOffsetY,
                min: -30,
                max: 30,
                divisions: 120,
                enabled: settings.enabled && settings.enableShadow,
                valueLabel: settings.shadowOffsetY.toStringAsFixed(1),
                onChanged: (double value) {
                  _update(ref, (AppearanceToastSettings current) {
                    return current.copyWith(shadowOffsetY: value);
                  });
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        ControlSection(
          title: 'Layout',
          icon: Icons.space_bar_rounded,
          child: Column(
            children: <Widget>[
              SliderRow(
                label: 'Horizontal padding',
                value: settings.horizontalPadding,
                min: 0,
                max: 48,
                divisions: 96,
                enabled: settings.enabled,
                valueLabel: settings.horizontalPadding.toStringAsFixed(1),
                onChanged: (double value) {
                  _update(ref, (AppearanceToastSettings current) {
                    return current.copyWith(horizontalPadding: value);
                  });
                },
              ),
              SliderRow(
                label: 'Vertical padding',
                value: settings.verticalPadding,
                min: 0,
                max: 32,
                divisions: 64,
                enabled: settings.enabled,
                valueLabel: settings.verticalPadding.toStringAsFixed(1),
                onChanged: (double value) {
                  _update(ref, (AppearanceToastSettings current) {
                    return current.copyWith(verticalPadding: value);
                  });
                },
              ),
              SliderRow(
                label: 'Maximum width',
                value: settings.maxWidth,
                min: 160,
                max: 800,
                divisions: 128,
                enabled: settings.enabled,
                valueLabel: settings.maxWidth.toStringAsFixed(0),
                onChanged: (double value) {
                  _update(ref, (AppearanceToastSettings current) {
                    return current.copyWith(maxWidth: value);
                  });
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        ControlSection(
          title: 'Behavior',
          icon: Icons.timer_outlined,
          child: SliderRow(
            label: 'Duration',
            value: settings.duration,
            min: 0.5,
            max: 10,
            divisions: 95,
            enabled: settings.enabled,
            valueLabel: '${settings.duration.toStringAsFixed(1)} s',
            onChanged: (double value) {
              _update(ref, (AppearanceToastSettings current) {
                return current.copyWith(duration: value);
              });
            },
          ),
        ),
      ],
      preview: _ToastPreview(mode: mode, settings: settings, palette: palette),
    );
  }
}

class _TooltipPanel extends ConsumerWidget {
  const _TooltipPanel({
    required this.mode,
    required this.settings,
    required this.palette,
  });
  final AppThemeMode mode;
  final AppearanceTooltipSettings settings;
  final GlassColorPalette palette;
  Future<void> _update(
    WidgetRef ref,
    AppearanceTooltipSettings Function(AppearanceTooltipSettings value) updater,
  ) {
    return ref.read(appearanceProfilesProvider.notifier).updateProfile(mode, (
      AppearanceSettings value,
    ) {
      return value.copyWith(tooltip: updater(value.tooltip));
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ComponentLayout(
      controls: <Widget>[
        ControlSection(
          title: 'Activation',
          icon: Icons.power_settings_new_rounded,
          child: SwitchRow(
            title: 'Enable tooltip',
            value: settings.enabled,
            palette: palette,
            onChanged: (bool value) {
              _update(ref, (AppearanceTooltipSettings current) {
                return current.copyWith(enabled: value);
              });
            },
          ),
        ),
        const SizedBox(height: 12),
        ControlSection(
          title: 'Surface',
          icon: Icons.layers_outlined,
          child: Column(
            children: <Widget>[
              SwitchRow(
                title: 'Enable blur',
                value: settings.enableBlur,
                palette: palette,
                enabled: settings.enabled,
                onChanged: (bool value) {
                  _update(ref, (AppearanceTooltipSettings current) {
                    return current.copyWith(enableBlur: value);
                  });
                },
              ),
              SliderRow(
                label: 'Blur',
                value: settings.blur,
                min: 0,
                max: 40,
                divisions: 80,
                enabled: settings.enabled && settings.enableBlur,
                valueLabel: settings.blur.toStringAsFixed(1),
                onChanged: (double value) {
                  _update(ref, (AppearanceTooltipSettings current) {
                    return current.copyWith(blur: value);
                  });
                },
              ),
              SliderRow(
                label: 'Background opacity',
                value: settings.backgroundOpacity,
                min: 0,
                max: 1,
                divisions: 100,
                enabled: settings.enabled,
                valueLabel: '${(settings.backgroundOpacity * 100).round()}%',
                onChanged: (double value) {
                  _update(ref, (AppearanceTooltipSettings current) {
                    return current.copyWith(backgroundOpacity: value);
                  });
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        ControlSection(
          title: 'Border',
          icon: Icons.crop_square_rounded,
          child: Column(
            children: <Widget>[
              SwitchRow(
                title: 'Enable border',
                value: settings.enableBorder,
                palette: palette,
                enabled: settings.enabled,
                onChanged: (bool value) {
                  _update(ref, (AppearanceTooltipSettings current) {
                    return current.copyWith(enableBorder: value);
                  });
                },
              ),
              SliderRow(
                label: 'Border opacity',
                value: settings.borderOpacity,
                min: 0,
                max: 1,
                divisions: 100,
                enabled: settings.enabled && settings.enableBorder,
                valueLabel: '${(settings.borderOpacity * 100).round()}%',
                onChanged: (double value) {
                  _update(ref, (AppearanceTooltipSettings current) {
                    return current.copyWith(borderOpacity: value);
                  });
                },
              ),
              SliderRow(
                label: 'Border width',
                value: settings.borderWidth,
                min: 0,
                max: 4,
                divisions: 80,
                enabled: settings.enabled && settings.enableBorder,
                valueLabel: settings.borderWidth.toStringAsFixed(2),
                onChanged: (double value) {
                  _update(ref, (AppearanceTooltipSettings current) {
                    return current.copyWith(borderWidth: value);
                  });
                },
              ),
              SliderRow(
                label: 'Border radius',
                value: settings.borderRadius,
                min: 0,
                max: 48,
                divisions: 96,
                enabled: settings.enabled,
                valueLabel: settings.borderRadius.toStringAsFixed(0),
                onChanged: (double value) {
                  _update(ref, (AppearanceTooltipSettings current) {
                    return current.copyWith(borderRadius: value);
                  });
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        ControlSection(
          title: 'Shadow',
          icon: Icons.blur_on_rounded,
          child: Column(
            children: <Widget>[
              SwitchRow(
                title: 'Enable shadow',
                value: settings.enableShadow,
                palette: palette,
                enabled: settings.enabled,
                onChanged: (bool value) {
                  _update(ref, (AppearanceTooltipSettings current) {
                    return current.copyWith(enableShadow: value);
                  });
                },
              ),
              SliderRow(
                label: 'Shadow opacity',
                value: settings.shadowOpacity,
                min: 0,
                max: 1,
                divisions: 100,
                enabled: settings.enabled && settings.enableShadow,
                valueLabel: '${(settings.shadowOpacity * 100).round()}%',
                onChanged: (double value) {
                  _update(ref, (AppearanceTooltipSettings current) {
                    return current.copyWith(shadowOpacity: value);
                  });
                },
              ),
              SliderRow(
                label: 'Shadow blur',
                value: settings.shadowBlur,
                min: 0,
                max: 40,
                divisions: 80,
                enabled: settings.enabled && settings.enableShadow,
                valueLabel: settings.shadowBlur.toStringAsFixed(1),
                onChanged: (double value) {
                  _update(ref, (AppearanceTooltipSettings current) {
                    return current.copyWith(shadowBlur: value);
                  });
                },
              ),
              SliderRow(
                label: 'Shadow offset Y',
                value: settings.shadowOffsetY,
                min: -30,
                max: 30,
                divisions: 120,
                enabled: settings.enabled && settings.enableShadow,
                valueLabel: settings.shadowOffsetY.toStringAsFixed(1),
                onChanged: (double value) {
                  _update(ref, (AppearanceTooltipSettings current) {
                    return current.copyWith(shadowOffsetY: value);
                  });
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        ControlSection(
          title: 'Layout',
          icon: Icons.space_bar_rounded,
          child: Column(
            children: <Widget>[
              SliderRow(
                label: 'Horizontal padding',
                value: settings.horizontalPadding,
                min: 0,
                max: 48,
                divisions: 96,
                enabled: settings.enabled,
                valueLabel: settings.horizontalPadding.toStringAsFixed(1),
                onChanged: (double value) {
                  _update(ref, (AppearanceTooltipSettings current) {
                    return current.copyWith(horizontalPadding: value);
                  });
                },
              ),
              SliderRow(
                label: 'Vertical padding',
                value: settings.verticalPadding,
                min: 0,
                max: 32,
                divisions: 64,
                enabled: settings.enabled,
                valueLabel: settings.verticalPadding.toStringAsFixed(1),
                onChanged: (double value) {
                  _update(ref, (AppearanceTooltipSettings current) {
                    return current.copyWith(verticalPadding: value);
                  });
                },
              ),
              SliderRow(
                label: 'Maximum width',
                value: settings.maxWidth,
                min: 120,
                max: 800,
                divisions: 136,
                enabled: settings.enabled,
                valueLabel: settings.maxWidth.toStringAsFixed(0),
                onChanged: (double value) {
                  _update(ref, (AppearanceTooltipSettings current) {
                    return current.copyWith(maxWidth: value);
                  });
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        ControlSection(
          title: 'Behavior',
          icon: Icons.timer_outlined,
          child: Column(
            children: <Widget>[
              SliderRow(
                label: 'Wait duration',
                value: settings.waitDuration,
                min: 0,
                max: 5,
                divisions: 50,
                enabled: settings.enabled,
                valueLabel: '${settings.waitDuration.toStringAsFixed(2)} s',
                onChanged: (double value) {
                  _update(ref, (AppearanceTooltipSettings current) {
                    return current.copyWith(waitDuration: value);
                  });
                },
              ),
              SliderRow(
                label: 'Show duration',
                value: settings.showDuration,
                min: 0,
                max: 15,
                divisions: 60,
                enabled: settings.enabled,
                valueLabel: '${settings.showDuration.toStringAsFixed(1)} s',
                onChanged: (double value) {
                  _update(ref, (AppearanceTooltipSettings current) {
                    return current.copyWith(showDuration: value);
                  });
                },
              ),
            ],
          ),
        ),
      ],
      preview: _TooltipPreview(
        mode: mode,
        settings: settings,
        palette: palette,
      ),
    );
  }
}
