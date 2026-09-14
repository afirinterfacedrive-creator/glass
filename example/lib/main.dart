import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:universal_glass/glass.dart';
import 'package:universal_glass_example/main/app.dart';
import 'package:universal_glass_example/routes/app_router.dart';

// ============================================================================
// MAIN
// ============================================================================
//
// Application de démonstration du package Glass.
//
// Le dossier example est uniquement un client du package Glass.
// Il ne contient aucune implémentation interne du package.
//
// ============================================================================

Future<void> main() async {
  // ==========================================================================
  // FLUTTER
  // ==========================================================================

  WidgetsFlutterBinding.ensureInitialized();

  // ==========================================================================
  // SHARED PREFERENCES
  // ==========================================================================

  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();


  // 🟢 2. INITIALISE LE CONTROLLER ICI AVANT runApp
  AppRouter.init(sharedPreferences);
  // ==========================================================================
  // APPLICATION
  // ==========================================================================

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(
          sharedPreferences,
        ),
      ],
      child: const GlassExampleApp(),
    ),
  );
}