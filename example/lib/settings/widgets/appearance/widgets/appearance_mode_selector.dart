import 'package:flutter/material.dart';

import 'package:universal_glass/glass.dart';

import '../appearance_mode_config.dart';

class AppearanceModeSelector extends StatelessWidget {
  final AppThemeMode selected;
  final ValueChanged<AppThemeMode> onSelected;

  const AppearanceModeSelector({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: AppearanceModeConfig.all.map(
        (config) {
          return GlassModeChip<AppThemeMode>(
            label: config.label,
            icon: config.icon,
            mode: config.mode,
            selected: selected,
            onSelected: onSelected,
          );
        },
      ).toList(),
    );
  }
}