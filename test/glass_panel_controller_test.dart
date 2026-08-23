import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:universal_glass/enums/glass_enums.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:universal_glass/controllers/glass_panel_controller.dart';
import 'package:universal_glass/provider/glass_button_provider.dart';
import 'package:universal_glass/provider/glass_theme_provider.dart';
import 'package:universal_glass/providers/shared_preferences_provider.dart';
import 'package:universal_glass/theme/glass_effects.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // ==========================================================================
  // HELPER
  // ==========================================================================

  Future<GlassPanelController> createController(WidgetTester tester) async {
    late GlassPanelController controller;

    // ------------------------------------------------------------------------
    // SharedPreferences mock
    // ------------------------------------------------------------------------
    //
    // Le provider sharedPreferencesProvider est volontairement non implémenté
    // par défaut et doit être override dans l'application.
    //
    // Ici, on fournit une instance mock pour les tests.
    // ------------------------------------------------------------------------

    SharedPreferences.setMockInitialValues({});

    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
        child: MaterialApp(
          home: Consumer(
            builder: (BuildContext context, WidgetRef ref, Widget? child) {
              controller = GlassPanelController(ref);

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

  testWidgets('GlassPanelController peut être créé avec un WidgetRef', (
    tester,
  ) async {
    final controller = await createController(tester);

    expect(controller, isA<GlassPanelController>());
  });

  // ==========================================================================
  // 2. NOTIFIER
  // ==========================================================================

  testWidgets('GlassPanelController expose le notifier GlassButton', (
    tester,
  ) async {
    final controller = await createController(tester);

    expect(controller.notifier, isA<GlassButtonNotifier>());
  });

  // ==========================================================================
  // 3. THÈME
  // ==========================================================================

  testWidgets('GlassPanelController expose le thème Glass', (tester) async {
    final controller = await createController(tester);

    expect(controller.theme, isA<GlassThemeState>());
  });

  // ==========================================================================
  // 4. STYLE AQUA
  // ==========================================================================

  testWidgets('useAquaStyle correspond au thème actuel', (tester) async {
    final controller = await createController(tester);

    expect(controller.useAquaStyle, controller.theme.useAquaStyle);
  });

  // ==========================================================================
  // 5. STYLE GLASS
  // ==========================================================================

  testWidgets('currentStyle retourne le style Glass actuel', (tester) async {
    final controller = await createController(tester);

    expect(controller.currentStyle, controller.theme.style);

    expect(controller.currentStyle, isA<GlassStyle>());
  });

  // ==========================================================================
  // 6. EFFETS GLASS
  // ==========================================================================

  testWidgets('containerEffect retourne les effets Glass actuels', (
    tester,
  ) async {
    final controller = await createController(tester);

    expect(controller.containerEffect, controller.theme.effects);

    expect(controller.containerEffect, isA<GlassEffects>());
  });

  // ==========================================================================
  // 7. COULEUR APP BAR
  // ==========================================================================

  testWidgets('appBarBackgroundColor correspond au thème', (tester) async {
    final controller = await createController(tester);

    expect(
      controller.appBarBackgroundColor,
      controller.theme.appBarBackgroundColor,
    );

    expect(controller.appBarBackgroundColor, isA<Color>());
  });

  // ==========================================================================
  // 8. COULEUR BORDURE APP BAR
  // ==========================================================================

  testWidgets('appBarBorderColor correspond au thème', (tester) async {
    final controller = await createController(tester);

    expect(controller.appBarBorderColor, controller.theme.appBarBorderColor);

    expect(controller.appBarBorderColor, isA<Color>());
  });

  // ==========================================================================
  // 9. COULEUR ICÔNE APP BAR
  // ==========================================================================

  testWidgets('appBarIconColor correspond au thème', (tester) async {
    final controller = await createController(tester);

    expect(controller.appBarIconColor, controller.theme.appBarIconColor);

    expect(controller.appBarIconColor, isA<Color>());
  });

  // ==========================================================================
  // 10. INITIALISATION
  // ==========================================================================

  testWidgets('initialize crée tous les boutons Glass par défaut', (
    tester,
  ) async {
    final controller = await createController(tester);

    controller.initialize();

    await tester.pump();

    for (final id in defaultGlassButtonIds) {
      expect(
        controller.isActive(id),
        isFalse,
        reason: 'Le bouton "$id" doit être OFF après initialize().',
      );

      expect(
        controller.isLoading(id),
        isFalse,
        reason: 'Le bouton "$id" ne doit pas être en loading.',
      );
    }
  });

  // ==========================================================================
  // 11. CHANGE STYLE
  // ==========================================================================

  testWidgets('changeStyle modifie le style Aqua', (tester) async {
    final controller = await createController(tester);

    await controller.changeStyle(true);

    await tester.pump();

    expect(controller.useAquaStyle, isTrue);

    await controller.changeStyle(false);

    await tester.pump();

    expect(controller.useAquaStyle, isFalse);
  });

  // ==========================================================================
  // 12. TOGGLE STYLE
  // ==========================================================================

  testWidgets('toggleStyle inverse le style Aqua', (tester) async {
    final controller = await createController(tester);

    final bool initialValue = controller.useAquaStyle;

    await controller.toggleStyle();

    await tester.pump();

    expect(controller.useAquaStyle, isNot(initialValue));

    await controller.toggleStyle();

    await tester.pump();

    expect(controller.useAquaStyle, initialValue);
  });

  // ==========================================================================
  // 13. RESET THÈME
  // ==========================================================================

  testWidgets('resetTheme restaure le thème par défaut', (tester) async {
    final controller = await createController(tester);

    await controller.changeStyle(!controller.useAquaStyle);

    await tester.pump();

    await controller.resetTheme();

    await tester.pump();

    expect(controller.theme, isA<GlassThemeState>());
  });

  // ==========================================================================
  // 14. ÉTAT D'UN BOUTON INCONNU
  // ==========================================================================

  testWidgets('stateOf retourne un état par défaut pour un bouton inconnu', (
    tester,
  ) async {
    final controller = await createController(tester);

    final state = controller.stateOf('unknown');

    expect(state, isA<GlassButtonState>());

    expect(state.isActive, isFalse);

    expect(state.isLoading, isFalse);

    expect(state.customText, isNull);
  });

  // ==========================================================================
  // 15. BOUTON ACTIF
  // ==========================================================================

  testWidgets('activate active réellement un bouton', (tester) async {
    final controller = await createController(tester);

    controller.initialize();

    controller.activate('rotation');

    await tester.pump();

    expect(controller.isActive('rotation'), isTrue);
  });

  // ==========================================================================
  // 16. DÉSACTIVATION
  // ==========================================================================

  testWidgets('deactivate désactive réellement un bouton', (tester) async {
    final controller = await createController(tester);

    controller.initialize();

    controller.activate('rotation');

    await tester.pump();

    expect(controller.isActive('rotation'), isTrue);

    controller.deactivate('rotation');

    await tester.pump();

    expect(controller.isActive('rotation'), isFalse);
  });

  // ==========================================================================
  // 17. TOGGLE
  // ==========================================================================

  testWidgets('toggle inverse réellement l’état du bouton', (tester) async {
    final controller = await createController(tester);

    controller.initialize();

    expect(controller.isActive('volume'), isFalse);

    controller.toggle('volume');

    await tester.pump();

    expect(controller.isActive('volume'), isTrue);

    controller.toggle('volume');

    await tester.pump();

    expect(controller.isActive('volume'), isFalse);
  });

  // ==========================================================================
  // 18. RESET BOUTON
  // ==========================================================================

  testWidgets('resetButton remet un bouton à OFF', (tester) async {
    final controller = await createController(tester);

    controller.initialize();

    controller.activate('brightness');

    await tester.pump();

    expect(controller.isActive('brightness'), isTrue);

    controller.resetButton('brightness');

    await tester.pump();

    expect(controller.isActive('brightness'), isFalse);
  });

  // ==========================================================================
  // 19. RESET BOUTON ACTIF
  // ==========================================================================

  testWidgets('resetButton peut restaurer un bouton à ON', (tester) async {
    final controller = await createController(tester);

    controller.initialize();

    controller.resetButton('notification', active: true);

    await tester.pump();

    expect(controller.isActive('notification'), isTrue);
  });

  // ==========================================================================
  // 20. CUSTOM TEXT
  // ==========================================================================

  testWidgets(
    'customText retourne null lorsqu’aucun texte personnalisé n’existe',
    (tester) async {
      final controller = await createController(tester);

      controller.initialize();

      expect(controller.customText('custom_unique'), isNull);
    },
  );
}
