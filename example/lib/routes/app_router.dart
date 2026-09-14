
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:universal_glass/glass.dart';

import 'package:universal_glass_example/home/home_page.dart';
import 'package:universal_glass_example/home/widgets/glass_gradient_animation_demo.dart';

import 'package:universal_glass_example/home/widgets/glass_preset_picker_demo.dart';
import 'package:universal_glass_example/home/widgets/glass_style_gallery/glass_style_gallery.dart';
import 'package:universal_glass_example/home/widgets/home_phone_input_preview.dart';
import 'package:universal_glass_example/home/widgets/phone_country_crud_screen.dart';
import 'package:universal_glass_example/previews/dialog/glass_dialog_preview_page.dart';
import 'package:universal_glass_example/previews/form/glass_form_preview_page.dart';
import 'package:universal_glass_example/previews/modal/glass_modal_preview_page.dart';
import 'package:universal_glass_example/settings/glass_global_settings_page.dart';
import 'package:universal_glass_example/settings/settings_page.dart';
import 'package:universal_glass_example/settings/widgets/appearance/appearance_settings.dart';



import 'package:universal_glass_example/views/control_panel/control_panel_page.dart';
import 'package:universal_glass_example/views/physical_toggles/physical_toggles_page.dart';

import 'app_route_definition.dart';
import 'app_routes.dart';

/// ============================================================================
/// APP ROUTER
/// ============================================================================
///
/// Registre central de navigation de l'application.
///
/// Cette classe :
///
/// - initialise les dépendances partagées du routeur ;
/// - centralise toutes les routes ;
/// - expose les routes du Quick Access ;
/// - génère automatiquement les routes Flutter.
///
/// Les métadonnées de navigation sont définies une seule fois dans [routes].
///
/// [AppRoutes.appearance] ouvre la section Appearance de [SettingsPage]
/// directement, sans dupliquer l'interface de configuration.
abstract final class AppRouter {
  // ===========================================================================
  // DÉPENDANCES PARTAGÉES
  // ===========================================================================

  /// Contrôleur téléphone partagé par les différentes pages de démonstration.
  static late final PhoneInputController sharedPhoneController;
 static late final SharedPreferences _prefs; // <- AJOUT
  /// Indique si les dépendances du routeur ont déjà été initialisées.
  static bool _initialized = false;

  /// Initialise les dépendances partagées du routeur.
  ///
  /// Cette méthode doit être appelée une seule fois au démarrage de
  /// l'application, après la création de [SharedPreferences].
  ///
  /// Les appels suivants sont ignorés.
  static void init(SharedPreferences prefs) {
    if (_initialized) {
      return;
    }

    sharedPhoneController = PhoneInputController(
      preferences: prefs,
    );

     _prefs = prefs; // <- SAUVEGARDE

    _initialized = true;
  }


static AppearanceSettings _loadAppearanceSettings() { // <- AJOUT
    final jsonString = _prefs.getString('appearance_settings');
    if (jsonString == null) return const AppearanceSettings();
    return AppearanceSettings.fromJson(
      Map<String, dynamic>.from(json.decode(jsonString)),
    );
  }

  // ===========================================================================
  // REGISTRE DES ROUTES
  // ===========================================================================

  /// Toutes les routes de l'application.
  ///
  /// Cette liste constitue la source unique des métadonnées de navigation.
  static List<AppRouteDefinition> get routes => [
        // ---------------------------------------------------------------------
        // HOME
        // ---------------------------------------------------------------------

        AppRouteDefinition(
          route: AppRoutes.home,
          title: 'Home',
          subtitle: 'Accueil de l’application',
          icon: Icons.home_rounded,
          builder: (_) => const HomePage(),
        ),

        // ---------------------------------------------------------------------
        // CONTROL PANEL
        // ---------------------------------------------------------------------

        AppRouteDefinition(
          route: AppRoutes.controlPanel,
          title: 'Control Panel',
          subtitle: 'Contrôler les composants',
          icon: Icons.tune_rounded,
          showInQuickAccess: true,
          builder: (_) => const ControlPanelPage(),
        ),

        // ---------------------------------------------------------------------
        // SETTINGS
        // ---------------------------------------------------------------------

        AppRouteDefinition(
          route: AppRoutes.settings,
          title: 'Settings',
          subtitle: 'Configurer l’application',
          icon: Icons.settings_rounded,
          showInQuickAccess: true,
          builder: (_) => const SettingsPage(),
        ),

        // ---------------------------------------------------------------------
        // GLASS GLOBAL SETTINGS
        // ---------------------------------------------------------------------

        AppRouteDefinition(
          route: AppRoutes.glassGlobalSettings,
          title: 'Glass Settings',
          subtitle: 'Configurer le Glass global',
          icon: Icons.design_services_rounded,
          showInQuickAccess: true,
          builder: (_) => const GlassGlobalSettingsPage(),
        ),

        // ---------------------------------------------------------------------
        // PHYSICAL TOGGLES
        // ---------------------------------------------------------------------

        AppRouteDefinition(
          route: AppRoutes.physicalToggles,
          title: 'Physical Toggles',
          subtitle: 'Tester les interrupteurs',
          icon: Icons.toggle_on_rounded,
          showInQuickAccess: true,
          builder: (_) => const PhysicalTogglesPage(),
        ),

        // ---------------------------------------------------------------------
        // APPEARANCE
        // ---------------------------------------------------------------------

        AppRouteDefinition(
          route: AppRoutes.appearance,
          title: 'Appearance',
          subtitle: 'Personnaliser les profils',
          icon: Icons.palette_rounded,
          showInQuickAccess: true,
          builder: (_) => const SettingsPage(
            initialSection: SettingsSection.appearance,
          ),
        ),
  // ---------------------------------------------------------------------
    // PHONE INPUT
    // ---------------------------------------------------------------------
    AppRouteDefinition(
      route: AppRoutes.phoneInput,
      title: 'Phone Input',
      subtitle: 'Tester le champ téléphone',
      icon: Icons.phone_rounded,
      builder: (_) {
        final settings = _loadAppearanceSettings(); // <- LIT DEPUIS PREFS
        return HomePhoneInputPreview(
          phoneController: sharedPhoneController,
          settings: settings,
        );
      },
    ),

        // ---------------------------------------------------------------------
        // PHONE CRUD
        // ---------------------------------------------------------------------

        AppRouteDefinition(
          route: AppRoutes.phoneCrud,
          title: 'Phone CRUD',
          subtitle: 'Gérer les préfixes réseau',
          icon: Icons.phonelink_setup_rounded,
          showInQuickAccess: true,
          builder: (_) => const PhoneCountryCrudPage(),
        ),

        // ---------------------------------------------------------------------
        // GRADIENT ANIMATION
        // ---------------------------------------------------------------------

        AppRouteDefinition(
          route: AppRoutes.gradientAnimationDemo,
          title: 'Gradient Animation',
          subtitle: 'Tester les animations de gradient',
          icon: Icons.gradient_rounded,
          builder: (_) => const GlassGradientAnimationDemo(),
        ),

        // ---------------------------------------------------------------------
        // PRESET EXPORT / IMPORT
        // ---------------------------------------------------------------------

        

        // ---------------------------------------------------------------------
        // PRESET PICKER
        // ---------------------------------------------------------------------

        AppRouteDefinition(
          route: AppRoutes.presetPickerDemo,
          title: 'Preset Picker',
          subtitle: 'Choisir un preset Glass',
          icon: Icons.auto_awesome_rounded,
          builder: (_) => const GlassPresetPickerDemo(),
        ),

        // ---------------------------------------------------------------------
        // STYLE GALLERY
        // ---------------------------------------------------------------------

        AppRouteDefinition(
          route: AppRoutes.styleGallery,
          title: 'Style Gallery',
          subtitle: 'Tester les ${GlassStyle.values.length} presets',
          icon: Icons.layers_rounded,
          showInQuickAccess: true,
          builder: (_) => const GlassStyleGallery(),
        ),

        // ---------------------------------------------------------------------
        // DIALOG
        // ---------------------------------------------------------------------

        AppRouteDefinition(
          route: AppRoutes.dialog,
          title: 'Dialog',
          subtitle: 'Tester les dialogues Glass',
          icon: Icons.chat_bubble_outline_rounded,
          showInQuickAccess: true,
          builder: (_) => const GlassDialogPreviewPage(),
        ),

        // ---------------------------------------------------------------------
        // MODAL
        // ---------------------------------------------------------------------

        AppRouteDefinition(
          route: AppRoutes.modal,
          title: 'Modal',
          subtitle: 'Tester les fenêtres modales',
          icon: Icons.open_in_new_rounded,
          showInQuickAccess: true,
          builder: (_) => const GlassModalPreviewPage(),
        ),

        // ---------------------------------------------------------------------
        // FORM
        // ---------------------------------------------------------------------

        AppRouteDefinition(
          route: AppRoutes.form,
          title: 'Form',
          subtitle: 'Tester les formulaires Glass',
          icon: Icons.dynamic_form_rounded,
          showInQuickAccess: true,
          builder: (_) => const GlassFormPreviewPage(),
        ),
      ];

  // ===========================================================================
  // QUICK ACCESS
  // ===========================================================================

  /// Routes affichées automatiquement dans [HomeQuickAccess].
  static List<AppRouteDefinition> get quickAccessRoutes {
    return routes
        .where(
          (AppRouteDefinition route) =>
              route.showInQuickAccess,
        )
        .toList(growable: false);
  }

  // ===========================================================================
  // ROUTING
  // ===========================================================================

  /// Génère automatiquement une route à partir du registre.
  static Route<dynamic> generateRoute(
    RouteSettings settings,
  ) {
    for (final AppRouteDefinition route in routes) {
      if (route.route == settings.name) {
        return MaterialPageRoute<dynamic>(
          settings: settings,
          builder: route.builder,
        );
      }
    }

    return MaterialPageRoute<dynamic>(
      settings: settings,
      builder: (_) => const _UnknownRoutePage(),
    );
  }
}

/// ============================================================================
/// UNKNOWN ROUTE PAGE
/// ============================================================================
///
/// Page affichée lorsqu'une route inconnue est demandée.
class _UnknownRoutePage extends StatelessWidget {
  const _UnknownRoutePage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              size: 60,
            ),
            const SizedBox(height: 16),
            const Text(
              'Page introuvable',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  AppRoutes.home,
                  (_) => false,
                );
              },
              child: const Text(
                'Retour à l’accueil',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
