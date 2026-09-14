import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:universal_glass/glass.dart';
import 'package:universal_glass_example/settings/widgets/appearance/appearance_profiles_provider.dart';
import 'package:universal_glass_example/settings/widgets/appearance/appearance_settings.dart';
part 'appearance_component_settings_panels.dart';
part 'appearance_component_settings_widgets.dart';

class AppearanceComponentSettingsSection extends ConsumerStatefulWidget {
  const AppearanceComponentSettingsSection({super.key, required this.mode});
  final AppThemeMode mode;
  @override
  ConsumerState<AppearanceComponentSettingsSection> createState() =>
      _AppearanceComponentSettingsSectionState();
}

class _AppearanceComponentSettingsSectionState
    extends ConsumerState<AppearanceComponentSettingsSection>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  static const List<_ComponentTab> _tabs = <_ComponentTab>[
    _ComponentTab(
      type: ComponentType.form,
      label: 'Form',
      icon: Icons.article_outlined,
    ),
    _ComponentTab(
      type: ComponentType.input,
      label: 'Input',
      icon: Icons.text_fields_rounded,
    ),
    _ComponentTab(
      type: ComponentType.modalDialog,
      label: 'Modal / Dialog',
      icon: Icons.open_in_new_rounded,
    ),
    _ComponentTab(
      type: ComponentType.toast,
      label: 'Toast',
      icon: Icons.notifications_none_rounded,
    ),
    _ComponentTab(
      type: ComponentType.tooltip,
      label: 'Tooltip',
      icon: Icons.info_outline_rounded,
    ),
  ];
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _resetCurrent() async {
    final ComponentType currentType = _tabs[_tabController.index].type;
    final String currentLabel = _tabs[_tabController.index].label;
    switch (currentType) {
      case ComponentType.form:
        await ref.read(appearanceProfilesProvider.notifier).updateProfile(
          widget.mode,
          (AppearanceSettings value) {
            return value.copyWith(form: const AppearanceFormSettings());
          },
        );
        break;
      case ComponentType.input:
        await ref.read(appearanceProfilesProvider.notifier).updateProfile(
          widget.mode,
          (AppearanceSettings value) {
            return value.copyWith(input: const AppearanceInputSettings());
          },
        );
        break;
      case ComponentType.modalDialog:
        await ref.read(appearanceProfilesProvider.notifier).updateProfile(
          widget.mode,
          (AppearanceSettings value) {
            return value.copyWith(
              component: const AppearanceComponentSettings(),
            );
          },
        );
        break;
      case ComponentType.toast:
        await ref.read(appearanceProfilesProvider.notifier).updateProfile(
          widget.mode,
          (AppearanceSettings value) {
            return value.copyWith(toast: const AppearanceToastSettings());
          },
        );
        break;
      case ComponentType.tooltip:
        await ref.read(appearanceProfilesProvider.notifier).updateProfile(
          widget.mode,
          (AppearanceSettings value) {
            return value.copyWith(tooltip: const AppearanceTooltipSettings());
          },
        );
        break;
    }
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$currentLabel réinitialisé'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppearanceSettings settings = ref.watch(
      appearanceProfileProvider(widget.mode),
    );
    final GlassColorPalette palette = GlassColorPalette.fromMode(widget.mode);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        SectionHeader(
          palette: palette,
          title: 'Component settings',
          subtitle: 'Paramétrage détaillé des composants Glass',
          trailing: ResetButton(
            onPressed: _resetCurrent,
            palette: palette,
            mode: widget.mode,
          ),
        ),
        const SizedBox(height: 16),
        ComponentTabBar(
          controller: _tabController,
          tabs: _tabs,
          palette: palette,
          mode: widget.mode,
        ),
        const SizedBox(height: 20),
        AnimatedBuilder(
          animation: _tabController,
          builder: (BuildContext context, Widget? child) {
            switch (_tabs[_tabController.index].type) {
              case ComponentType.form:
                return _FormPanel(
                  mode: widget.mode,
                  settings: settings.form,
                  palette: palette,
                );
              case ComponentType.input:
                return _InputPanel(
                  mode: widget.mode,
                  settings: settings.input,
                  palette: palette,
                );
              case ComponentType.modalDialog:
                return _ModalDialogPanel(
                  mode: widget.mode,
                  settings: settings.component,
                  palette: palette,
                );
              case ComponentType.toast:
                return _ToastPanel(
                  mode: widget.mode,
                  settings: settings.toast,
                  palette: palette,
                );
              case ComponentType.tooltip:
                return _TooltipPanel(
                  mode: widget.mode,
                  settings: settings.tooltip,
                  palette: palette,
                );
            }
          },
        ),
      ],
    );
  }
}

class _ComponentTab {
  const _ComponentTab({
    required this.type,
    required this.label,
    required this.icon,
  });
  final ComponentType type;
  final String label;
  final IconData icon;
}
