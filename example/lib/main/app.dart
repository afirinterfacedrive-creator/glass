import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:universal_glass/glass.dart';

import 'package:universal_glass_example/routes/app_router.dart';
import 'package:universal_glass_example/routes/app_routes.dart';

// ============================================================================
// GLASS EXAMPLE APP
// ============================================================================
//
// Application de démonstration du package Glass.
//
// IMPORTANT :
//
// Cette classe appartient uniquement au dossier example.
//
// Le package Glass fournit les composants, thèmes et providers réutilisables.
// Le projet example reste responsable de MaterialApp, des routes et des pages.
//
// ============================================================================

class GlassExampleApp extends ConsumerWidget {
  const GlassExampleApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // =========================================================================
    // THÈME DE L'APPLICATION
    // =========================================================================

    final ThemeMode themeMode = ref.watch(
      themeProvider.select((state) => state.materialThemeMode),
    );

    // =========================================================================
    // MATERIAL APP
    // =========================================================================

    return MaterialApp(
      title: 'Glass UI Showcase',

      debugShowCheckedModeBanner: false,

      // =======================================================================
      // THÈME CLAIR
      // =======================================================================
      theme: ThemeData(useMaterial3: true, brightness: Brightness.light),

      // =======================================================================
      // THÈME SOMBRE
      // =======================================================================
      darkTheme: ThemeData(useMaterial3: true, brightness: Brightness.dark),

      // =======================================================================
      // MODE DU THÈME
      // =======================================================================
      themeMode: themeMode,

      // =======================================================================
      // ROUTING
      // =======================================================================
      initialRoute: AppRoutes.home,

      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
