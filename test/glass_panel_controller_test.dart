import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:universal_glass/controllers/glass_panel_controller.dart';
import 'package:universal_glass/enums/glass_enums.dart';
import 'package:universal_glass/provider/glass_button_provider.dart';
import 'package:universal_glass/provider/glass_theme_provider.dart';
import 'package:universal_glass/providers/shared_preferences_provider.dart';

/// ============================================================================
/// GLASS PANEL CONTROLLER TESTS
/// ============================================================================
///
/// Vérifie :
///
/// • construction du controller
/// • accès au notifier des boutons
/// • accès au thème Glass
/// • lecture du style
/// • gestion Aqua / Classic
/// • persistance du style
/// • initialisation des boutons
/// • activation / désactivation
/// • toggle
/// • reset
/// • custom text
///
/// IMPORTANT
///
/// Les couleurs ne sont volontairement PAS testées ici.
///
/// Elles sont maintenant centralisées dans :
///
///     GlassColorPalette
///     GlassColorProvider
///     glassColorProvider
///
/// ============================================================================

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // ==========================================================================
  // HELPER
  // ==========================================================================

  Future<GlassPanelController> createController(
    WidgetTester tester,
  ) async {
    late GlassPanelController controller;

    // ------------------------------------------------------------------------
    // SharedPreferences mock
    // ------------------------------------------------------------------------

    SharedPreferences.setMockInitialValues({});

    final SharedPreferences prefs =
        await SharedPreferences.getInstance();

    // ------------------------------------------------------------------------
    // APPLICATION DE TEST
    // ------------------------------------------------------------------------

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(
            prefs,
          ),
        ],
        child: MaterialApp(
          home: Consumer(
            builder: (
              BuildContext context,
              WidgetRef ref,
              Widget? child,
            ) {
              controller =
                  GlassPanelController(ref);

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );

    await tester.pump();

    return controller;
  }

  // ==========================================================================
  // 1. CONSTRUCTION
  // ==========================================================================

  testWidgets(
    'GlassPanelController peut être créé avec un WidgetRef',
    (
      tester,
    ) async {
      final GlassPanelController controller =
          await createController(tester);

      expect(
        controller,
        isA<GlassPanelController>(),
      );
    },
  );

  // ==========================================================================
  // 2. NOTIFIER DES BOUTONS
  // ==========================================================================

  testWidgets(
    'GlassPanelController expose le notifier GlassButton',
    (
      tester,
    ) async {
      final GlassPanelController controller =
          await createController(tester);

      expect(
        controller.notifier,
        isA<GlassButtonNotifier>(),
      );
    },
  );

  // ==========================================================================
  // 3. THÈME
  // ==========================================================================

  testWidgets(
    'GlassPanelController expose le thème Glass',
    (
      tester,
    ) async {
      final GlassPanelController controller =
          await createController(tester);

      expect(
        controller.theme,
        isA<GlassThemeState>(),
      );
    },
  );

  // ==========================================================================
  // 4. STYLE AQUA
  // ==========================================================================

  testWidgets(
    'useAquaStyle correspond au thème actuel',
    (
      tester,
    ) async {
      final GlassPanelController controller =
          await createController(tester);

      expect(
        controller.useAquaStyle,
        controller.theme.useAquaStyle,
      );
    },
  );

  // ==========================================================================
  // 5. STYLE GLASS
  // ==========================================================================

  testWidgets(
    'currentStyle retourne le style Glass actuel',
    (
      tester,
    ) async {
      final GlassPanelController controller =
          await createController(tester);

      expect(
        controller.currentStyle,
        controller.theme.style,
      );

      expect(
        controller.currentStyle,
        isA<GlassStyle>(),
      );
    },
  );

  // ==========================================================================
  // 6. STYLE AQUA PAR DÉFAUT
  // ==========================================================================

  testWidgets(
    'le style Aqua est actif par défaut',
    (
      tester,
    ) async {
      final GlassPanelController controller =
          await createController(tester);

      expect(
        controller.useAquaStyle,
        isTrue,
      );

      expect(
        controller.currentStyle,
        GlassStyle.transparentAqua,
      );
    },
  );

  // ==========================================================================
  // 7. CHANGEMENT VERS CLASSIC
  // ==========================================================================

  testWidgets(
    'changeStyle(false) active le style Classic',
    (
      tester,
    ) async {
      final GlassPanelController controller =
          await createController(tester);

      await controller.changeStyle(false);

      await tester.pump();

      expect(
        controller.useAquaStyle,
        isFalse,
      );

      expect(
        controller.currentStyle,
        GlassStyle.opaqueMat,
      );
    },
  );

  // ==========================================================================
  // 8. CHANGEMENT VERS AQUA
  // ==========================================================================

  testWidgets(
    'changeStyle(true) active le style Aqua',
    (
      tester,
    ) async {
      final GlassPanelController controller =
          await createController(tester);

      await controller.changeStyle(false);

      await tester.pump();

      expect(
        controller.useAquaStyle,
        isFalse,
      );

      await controller.changeStyle(true);

      await tester.pump();

      expect(
        controller.useAquaStyle,
        isTrue,
      );

      expect(
        controller.currentStyle,
        GlassStyle.transparentAqua,
      );
    },
  );

  // ==========================================================================
  // 9. TOGGLE STYLE
  // ==========================================================================

  testWidgets(
    'toggleStyle inverse le style Aqua',
    (
      tester,
    ) async {
      final GlassPanelController controller =
          await createController(tester);

      final bool initialValue =
          controller.useAquaStyle;

      await controller.toggleStyle();

      await tester.pump();

      expect(
        controller.useAquaStyle,
        isNot(initialValue),
      );

      await controller.toggleStyle();

      await tester.pump();

      expect(
        controller.useAquaStyle,
        initialValue,
      );
    },
  );

  // ==========================================================================
  // 10. PERSISTANCE DU STYLE
  // ==========================================================================

  testWidgets(
    'le changement de style est persisté',
    (
      tester,
    ) async {
      final GlassPanelController controller =
          await createController(tester);

      await controller.changeStyle(false);

      await tester.pump();

      expect(
        controller.useAquaStyle,
        isFalse,
      );
    },
  );

  // ==========================================================================
  // 11. RESET THÈME
  // ==========================================================================

  testWidgets(
    'resetTheme restaure le style Aqua',
    (
      tester,
    ) async {
      final GlassPanelController controller =
          await createController(tester);

      await controller.changeStyle(false);

      await tester.pump();

      expect(
        controller.useAquaStyle,
        isFalse,
      );

      await controller.resetTheme();

      await tester.pump();

      expect(
        controller.useAquaStyle,
        isTrue,
      );

      expect(
        controller.currentStyle,
        GlassStyle.transparentAqua,
      );
    },
  );

  // ==========================================================================
  // 12. INITIALISATION
  // ==========================================================================

  testWidgets(
    'initialize crée tous les boutons Glass par défaut',
    (
      tester,
    ) async {
      final GlassPanelController controller =
          await createController(tester);

      controller.initialize();

      await tester.pump();

      for (final String id
          in defaultGlassButtonIds) {
        expect(
          controller.isActive(id),
          isFalse,
          reason:
              'Le bouton "$id" doit être OFF après initialize().',
        );

        expect(
          controller.isLoading(id),
          isFalse,
          reason:
              'Le bouton "$id" ne doit pas être en loading.',
        );
      }
    },
  );

  // ==========================================================================
  // 13. ÉTAT D'UN BOUTON INCONNU
  // ==========================================================================

  testWidgets(
    'stateOf retourne un état par défaut pour un bouton inconnu',
    (
      tester,
    ) async {
      final GlassPanelController controller =
          await createController(tester);

      final GlassButtonState state =
          controller.stateOf(
        'unknown',
      );

      expect(
        state,
        isA<GlassButtonState>(),
      );

      expect(
        state.isActive,
        isFalse,
      );

      expect(
        state.isLoading,
        isFalse,
      );

      expect(
        state.customText,
        isNull,
      );
    },
  );

  // ==========================================================================
  // 14. BOUTON ACTIF
  // ==========================================================================

  testWidgets(
    'activate active réellement un bouton',
    (
      tester,
    ) async {
      final GlassPanelController controller =
          await createController(tester);

      controller.initialize();

      controller.activate(
        'rotation',
      );

      await tester.pump();

      expect(
        controller.isActive(
          'rotation',
        ),
        isTrue,
      );
    },
  );

  // ==========================================================================
  // 15. DÉSACTIVATION
  // ==========================================================================

  testWidgets(
    'deactivate désactive réellement un bouton',
    (
      tester,
    ) async {
      final GlassPanelController controller =
          await createController(tester);

      controller.initialize();

      controller.activate(
        'rotation',
      );

      await tester.pump();

      expect(
        controller.isActive(
          'rotation',
        ),
        isTrue,
      );

      controller.deactivate(
        'rotation',
      );

      await tester.pump();

      expect(
        controller.isActive(
          'rotation',
        ),
        isFalse,
      );
    },
  );

  // ==========================================================================
  // 16. TOGGLE BOUTON
  // ==========================================================================

  testWidgets(
    'toggle inverse réellement l’état du bouton',
    (
      tester,
    ) async {
      final GlassPanelController controller =
          await createController(tester);

      controller.initialize();

      expect(
        controller.isActive(
          'volume',
        ),
        isFalse,
      );

      controller.toggle(
        'volume',
      );

      await tester.pump();

      expect(
        controller.isActive(
          'volume',
        ),
        isTrue,
      );

      controller.toggle(
        'volume',
      );

      await tester.pump();

      expect(
        controller.isActive(
          'volume',
        ),
        isFalse,
      );
    },
  );

  // ==========================================================================
  // 17. RESET BOUTON
  // ==========================================================================

  testWidgets(
    'resetButton remet un bouton à OFF',
    (
      tester,
    ) async {
      final GlassPanelController controller =
          await createController(tester);

      controller.initialize();

      controller.activate(
        'brightness',
      );

      await tester.pump();

      expect(
        controller.isActive(
          'brightness',
        ),
        isTrue,
      );

      controller.resetButton(
        'brightness',
      );

      await tester.pump();

      expect(
        controller.isActive(
          'brightness',
        ),
        isFalse,
      );
    },
  );

  // ==========================================================================
  // 18. RESET BOUTON ACTIF
  // ==========================================================================

  testWidgets(
    'resetButton peut restaurer un bouton à ON',
    (
      tester,
    ) async {
      final GlassPanelController controller =
          await createController(tester);

      controller.initialize();

      controller.resetButton(
        'notification',
        active: true,
      );

      await tester.pump();

      expect(
        controller.isActive(
          'notification',
        ),
        isTrue,
      );
    },
  );

  // ==========================================================================
  // 19. CUSTOM TEXT
  // ==========================================================================

  testWidgets(
    'customText retourne null lorsqu’aucun texte personnalisé n’existe',
    (
      tester,
    ) async {
      final GlassPanelController controller =
          await createController(tester);

      controller.initialize();

      expect(
        controller.customText(
          'custom_unique',
        ),
        isNull,
      );
    },
  );

  // ==========================================================================
  // 20. RESET CONSERVE LE TYPE DU THÈME
  // ==========================================================================

  testWidgets(
    'resetTheme conserve un GlassThemeState valide',
    (
      tester,
    ) async {
      final GlassPanelController controller =
          await createController(tester);

      await controller.changeStyle(false);

      await tester.pump();

      await controller.resetTheme();

      await tester.pump();

      expect(
        controller.theme,
        isA<GlassThemeState>(),
      );

      expect(
        controller.theme.useAquaStyle,
        isTrue,
      );
    },
  );
}