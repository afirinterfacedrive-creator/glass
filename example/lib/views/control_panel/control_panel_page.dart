import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:universal_glass/glass.dart';

import 'sections/control_panel_section.dart';

class ControlPanelPage extends ConsumerWidget {
  const ControlPanelPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // =========================================================================
    // THÈME GLASS - WATCH POUR REBUILD LIVE
    // =========================================================================
    final GlassThemeState theme = ref.watch(glassThemeProvider);

    // =========================================================================
    // GLASS COLOR PROVIDER
    // =========================================================================
    final GlassColorProvider colorProvider = ref.watch(glassColorProvider);

    // =========================================================================
    // PALETTE GLASS
    // =========================================================================
    final GlassColorPalette palette = colorProvider.palette;

    // =========================================================================
    // GLASS SCAFFOLD
    // =========================================================================
    return GlassScaffold(
      // =======================================================================
      // APP BAR
      // =======================================================================
      title: 'Control Panel',
      subtitle: 'GLASS CONTROLS',
      showLogo: true,
      showBackButton: true,

      // ACTIVE LE MODE CUSTOM GRADIENT + BLUR + NOISE LIVE
      useCustomGradient: true,
      customGradientKey: 'appbar_gradient',
      blur: theme.blur,   // <-- AJOUT 1: Passe le blur du provider
      noise: theme.noise, // <-- AJOUT 2: Passe le noise du provider

      hideNavigation: true,

      // =======================================================================
      // CONTENU
      // =======================================================================
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PanelHeader(
            title: 'Aesthetic Panel',
            subtitle: 'GLASS CONTROLS',
          ),
          const SizedBox(height: 28),
          ControlPanelSection(theme: theme, palette: palette),
          const SizedBox(height: 36),
        ],
      ),
    );
  }
}