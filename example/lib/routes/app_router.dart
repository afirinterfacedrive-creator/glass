import 'package:flutter/material.dart';

import 'app_routes.dart';

import '../home/home_page.dart';
import '../settings/settings_page.dart';
import '../views/control_panel/control_panel_page.dart';
import '../views/physical_toggles/physical_toggles_page.dart';

// ============================================================================
// APP ROUTER
// ============================================================================
//
// Point central de construction des routes.
//
// IMPORTANT :
//
// Ce router appartient uniquement à l'application example.
// Il ne fait PAS partie du package Glass.
//
// Les pages de démonstration sont donc importées avec des chemins locaux.
//
// ============================================================================

abstract final class AppRouter {
  // ==========================================================================
  // GENERATE ROUTE
  // ==========================================================================

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      // ======================================================================
      // HOME
      // ======================================================================

      case AppRoutes.home:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const HomePage(),
        );

      // ======================================================================
      // CONTROL PANEL
      // ======================================================================

      case AppRoutes.controlPanel:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const ControlPanelPage(),
        );

      // ======================================================================
      // SETTINGS
      // ======================================================================

      case AppRoutes.settings:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const SettingsPage(),
        );

      // ======================================================================
      // PHYSICAL TOGGLES
      // ======================================================================

      case AppRoutes.physicalToggles:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const PhysicalTogglesPage(),
        );

      // ======================================================================
      // APPEARANCE
      // ======================================================================

      case AppRoutes.appearance:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const SettingsPage(),
        );

      // ======================================================================
      // UNKNOWN
      // ======================================================================

      default:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const _UnknownRoutePage(),
        );
    }
  }
}

// ============================================================================
// UNKNOWN ROUTE
// ============================================================================

class _UnknownRoutePage extends StatelessWidget {
  const _UnknownRoutePage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ==================================================================
            // ICON
            // ==================================================================
            const Icon(Icons.error_outline, size: 60),

            const SizedBox(height: 16),

            // ==================================================================
            // MESSAGE
            // ==================================================================
            const Text(
              'Page introuvable',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            // ==================================================================
            // RETOUR HOME
            // ==================================================================
            ElevatedButton(
              onPressed: () {
                Navigator.of(
                  context,
                ).pushNamedAndRemoveUntil(AppRoutes.home, (_) => false);
              },
              child: const Text('Retour à l’accueil'),
            ),
          ],
        ),
      ),
    );
  }
}
