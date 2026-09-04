import 'package:flutter/material.dart';
import 'package:universal_glass_example/home/widgets/glass_gradient_animation_demo.dart';
import 'package:universal_glass_example/home/widgets/glass_preset_export_import_demo.dart';
import 'package:universal_glass_example/home/widgets/glass_preset_picker_demo.dart';
import 'package:universal_glass_example/home/widgets/glass_style_gallery/glass_style_gallery.dart';




import 'app_routes.dart';

import '../home/home_page.dart';
import '../settings/settings_page.dart';
import '../views/control_panel/control_panel_page.dart';
import '../views/physical_toggles/physical_toggles_page.dart';
import '../demos/universal_glass_phone_input_demo.dart';

abstract final class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      // ======================================================================
      // HOME
      // ======================================================================
      case AppRoutes.home:
        return MaterialPageRoute(settings: settings, builder: (_) => const HomePage());

      // ======================================================================
      // CONTROL PANEL
      // ======================================================================
      case AppRoutes.controlPanel:
        return MaterialPageRoute(settings: settings, builder: (_) => const ControlPanelPage());

      // ======================================================================
      // SETTINGS
      // ======================================================================
      case AppRoutes.settings:
        return MaterialPageRoute(settings: settings, builder: (_) => const SettingsPage());

      // ======================================================================
      // PHYSICAL TOGGLES
      // ======================================================================
      case AppRoutes.physicalToggles:
        return MaterialPageRoute(settings: settings, builder: (_) => const PhysicalTogglesPage());

      // ======================================================================
      // APPEARANCE
      // ======================================================================
      case AppRoutes.appearance:
        return MaterialPageRoute(settings: settings, builder: (_) => const SettingsPage());

      // ======================================================================
      // GLASS PHONE INPUT
      // ======================================================================
      case AppRoutes.phoneInput:
        return MaterialPageRoute(settings: settings, builder: (_) => const UniversalGlassPhoneInputDemo());

      

      // ======================================================================
      // NOUVELLES DEMOS - TEST DES 3 OPTIONS
      // ======================================================================
      case AppRoutes.gradientAnimationDemo:
        return MaterialPageRoute(settings: settings, builder: (_) => const GlassGradientAnimationDemo());

      case AppRoutes.presetExportImportDemo:
        return MaterialPageRoute(settings: settings, builder: (_) => const GlassPresetExportImportDemo());

      case AppRoutes.presetPickerDemo:
        return MaterialPageRoute(settings: settings, builder: (_) => const GlassPresetPickerDemo());

      // ======================================================================
      // GALERIE DES 21 STYLES GLASS
      // ======================================================================
      case AppRoutes.styleGallery:
        return MaterialPageRoute(settings: settings, builder: (_) => const GlassStyleGallery());

      // ======================================================================
      // UNKNOWN
      // ======================================================================
      default:
        return MaterialPageRoute(settings: settings, builder: (_) => const _UnknownRoutePage());
    }
  }
}

class _UnknownRoutePage extends StatelessWidget {
  const _UnknownRoutePage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 60),
            const SizedBox(height: 16),
            const Text('Page introuvable', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.home, (_) => false);
              },
              child: const Text('Retour à l’accueil'),
            ),
          ],
        ),
      ),
    );
  }
}