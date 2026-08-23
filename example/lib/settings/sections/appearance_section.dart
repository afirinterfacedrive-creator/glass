import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:universal_glass/glass.dart';

import '../widgets/aqua_glass_switch.dart';
import '../widgets/setting_section.dart';
import '../widgets/setting_tile.dart';

// ============================================================================
// APPEARANCE SECTION
// ============================================================================
//
// Section consacrée à l'apparence.
//
// Responsabilités :
//
// - lire le thème Glass
// - modifier le style Aqua
// - construire les réglages d'apparence
//
// ============================================================================

class AppearanceSection extends ConsumerWidget {
  const AppearanceSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(glassThemeProvider);

    final Color accent = theme.useAquaStyle
        ? Colors.cyanAccent
        : Colors.orangeAccent;

    return SettingSection(
      title: 'Appearance',

      accent: accent,

      children: [
        SettingTile(
          icon: Icons.opacity,

          iconColor: accent,

          title: 'Aqua Glass',

          subtitle: theme.useAquaStyle
              ? 'Style Aqua activé'
              : 'Style classique activé',

          trailing: AquaGlassSwitch(
            value: theme.useAquaStyle,

            accent: accent,

            onChanged: (bool value) {
              ref.read(glassThemeProvider.notifier).setAquaStyle(value);
            },
          ),
        ),
      ],
    );
  }
}
