import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:glass/glass.dart';
import 'package:glass_example/main/app.dart';

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

  // ==========================================================================
  // APPLICATION
  // ==========================================================================

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      ],
      child: const GlassExampleApp(),
    ),
  );
}
