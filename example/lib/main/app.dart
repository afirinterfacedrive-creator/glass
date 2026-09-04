import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:universal_glass/glass.dart';

import 'package:universal_glass_example/routes/app_router.dart';
import 'package:universal_glass_example/routes/app_routes.dart';


// ============================================================================
// GLASS EXAMPLE APP
// ============================================================================
//
// Application de démonstration du package Universal Glass.
//
// RESPONSABILITÉS
//
// Cette classe gère uniquement :
//
// • MaterialApp
// • ThemeMode Material
// • Routing
//
// UniversalGlassTheme gère :
//
// • Aqua / Classic global
// • GlassThemeProvider
// • GlassColorProvider
// • diffusion du style aux composants Glass
//
// ============================================================================

class GlassExampleApp extends ConsumerWidget {

  const GlassExampleApp({
    super.key,
  });



  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {


    // =========================================================================
    // THÈME MATERIAL
    // =========================================================================

    final ThemeMode themeMode =
        ref.watch(
          themeProvider.select(
            (state) =>
                state.materialThemeMode,
          ),
        );



    // =========================================================================
    // MATERIAL APP
    // =========================================================================

    return MaterialApp(

      title:
          'Glass UI Showcase',


      debugShowCheckedModeBanner:
          false,



      // =========================================================================
      // THÈME CLAIR
      // =========================================================================

      theme:
          ThemeData(

        useMaterial3:
            true,

        brightness:
            Brightness.light,

      ),



      // =========================================================================
      // THÈME SOMBRE
      // =========================================================================

      darkTheme:
          ThemeData(

        useMaterial3:
            true,

        brightness:
            Brightness.dark,

      ),



      // =========================================================================
      // MODE MATERIAL
      // =========================================================================

      themeMode:
          themeMode,



      // =========================================================================
      // ROUTES
      // =========================================================================

      initialRoute:
          AppRoutes.home,


      onGenerateRoute:
          AppRouter.generateRoute,

    );
  }
}