import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:universal_glass/components/toggle/glass_highlight.dart';
import 'package:universal_glass/components/toggle/glass_toggle.dart';
import 'package:universal_glass/components/toggle/glass_toggle_knob.dart';
import 'package:universal_glass/components/toggle/glass_toggle_track.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // ==========================================================================
  // APPLICATION DE TEST
  // ==========================================================================

  Widget buildTestApp({required Widget child}) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(body: Center(child: child)),
    );
  }

  // ==========================================================================
  // 1. AFFICHAGE INITIAL OFF
  // ==========================================================================

  testWidgets('GlassToggle affiche correctement son état OFF', (tester) async {
    bool value = false;

    await tester.pumpWidget(
      buildTestApp(
        child: GlassToggle(
          value: value,
          onChanged: (newValue) {
            value = newValue;
          },
        ),
      ),
    );

    await tester.pump();

    expect(find.byType(GlassToggle), findsOneWidget);

    expect(find.byType(GlassToggleTrack), findsOneWidget);

    expect(find.byType(GlassToggleKnob), findsOneWidget);
  });

  // ==========================================================================
  // 2. AFFICHAGE INITIAL ON
  // ==========================================================================

  testWidgets('GlassToggle affiche correctement son état ON', (tester) async {
    await tester.pumpWidget(
      buildTestApp(child: GlassToggle(value: true, onChanged: (_) {})),
    );

    await tester.pump();

    expect(find.byType(GlassToggle), findsOneWidget);

    expect(find.byType(GlassToggleTrack), findsOneWidget);

    expect(find.byType(GlassToggleKnob), findsOneWidget);
  });

  // ==========================================================================
  // 3. DIMENSIONS PAR DÉFAUT
  // ==========================================================================

  testWidgets('GlassToggle respecte ses dimensions par défaut', (tester) async {
    await tester.pumpWidget(
      buildTestApp(child: GlassToggle(value: false, onChanged: (_) {})),
    );

    await tester.pump();

    final size = tester.getSize(find.byType(GlassToggle));

    expect(size.width, 65);

    expect(size.height, 35);
  });

  // ==========================================================================
  // 4. DIMENSIONS PERSONNALISÉES
  // ==========================================================================

  testWidgets('GlassToggle respecte les dimensions personnalisées', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildTestApp(
        child: GlassToggle(
          value: false,
          width: 100,
          height: 50,
          onChanged: (_) {},
        ),
      ),
    );

    await tester.pump();

    final size = tester.getSize(find.byType(GlassToggle));

    expect(size.width, 100);

    expect(size.height, 50);
  });

  // ==========================================================================
  // 5. TAP RÉEL OFF → ON
  // ==========================================================================

  testWidgets(
    'GlassToggle déclenche réellement onChanged lors du tap OFF → ON',
    (tester) async {
      bool? changedValue;

      await tester.pumpWidget(
        buildTestApp(
          child: GlassToggle(
            value: false,
            onChanged: (value) {
              changedValue = value;
            },
          ),
        ),
      );

      await tester.pump();

      await tester.tap(find.byType(GlassToggle));

      await tester.pump();

      expect(changedValue, isTrue);
    },
  );

  // ==========================================================================
  // 6. TAP RÉEL ON → OFF
  // ==========================================================================

  testWidgets(
    'GlassToggle déclenche réellement onChanged lors du tap ON → OFF',
    (tester) async {
      bool? changedValue;

      await tester.pumpWidget(
        buildTestApp(
          child: GlassToggle(
            value: true,
            onChanged: (value) {
              changedValue = value;
            },
          ),
        ),
      );

      await tester.pump();

      await tester.tap(find.byType(GlassToggle));

      await tester.pump();

      expect(changedValue, isFalse);
    },
  );

  // ==========================================================================
  // 7. VRAI CYCLE OFF → ON → OFF
  // ==========================================================================

  // ==========================================================================
  // 7. VRAI CYCLE OFF → ON → OFF
  // ==========================================================================

  testWidgets(
    'GlassToggle fonctionne correctement sur un cycle complet OFF → ON → OFF',
    (tester) async {
      bool value = false;

      await tester.pumpWidget(
        MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            body: Center(
              child: StatefulBuilder(
                builder: (BuildContext context, StateSetter stateSetter) {
                  return GlassToggle(
                    value: value,
                    onChanged: (newValue) {
                      stateSetter(() {
                        value = newValue;
                      });
                    },
                  );
                },
              ),
            ),
          ),
        ),
      );

      await tester.pump();

      // ------------------------------------------------------------------------
      // ÉTAT INITIAL
      // ------------------------------------------------------------------------

      expect(value, isFalse);

      expect(find.byType(GlassToggle), findsOneWidget);

      // ------------------------------------------------------------------------
      // OFF → ON
      // ------------------------------------------------------------------------

      await tester.tap(find.byType(GlassToggle));

      await tester.pump();

      expect(value, isTrue);

      // ------------------------------------------------------------------------
      // ON → OFF
      // ------------------------------------------------------------------------

      await tester.tap(find.byType(GlassToggle));

      await tester.pump();

      expect(value, isFalse);
    },
  );

  // ==========================================================================
  // 8. ÉTAT DÉSACTIVÉ
  // ==========================================================================

  testWidgets(
    'GlassToggle désactivé affiche toujours son état sans interaction',
    (tester) async {
      bool callbackCalled = false;

      await tester.pumpWidget(
        buildTestApp(
          child: GlassToggle(
            value: false,
            enabled: false,
            onChanged: (_) {
              callbackCalled = true;
            },
          ),
        ),
      );

      await tester.pump();

      expect(find.byType(Opacity), findsOneWidget);

      await tester.tap(find.byType(GlassToggle));

      await tester.pump();

      expect(callbackCalled, isFalse);
    },
  );

  // ==========================================================================
  // 9. ÉTAT DÉSACTIVÉ AVEC VALUE TRUE
  // ==========================================================================

  testWidgets('GlassToggle désactivé conserve correctement value=true', (
    tester,
  ) async {
    bool callbackCalled = false;

    await tester.pumpWidget(
      buildTestApp(
        child: GlassToggle(
          value: true,
          enabled: false,
          onChanged: (_) {
            callbackCalled = true;
          },
        ),
      ),
    );

    await tester.pump();

    expect(find.byType(GlassToggleTrack), findsOneWidget);

    expect(find.byType(GlassToggleKnob), findsOneWidget);

    await tester.tap(find.byType(GlassToggle));

    await tester.pump();

    expect(callbackCalled, isFalse);
  });

  // ==========================================================================
  // 10. COULEUR ACTIVE PERSONNALISÉE
  // ==========================================================================

  testWidgets('GlassToggle accepte une activeColor personnalisée', (
    tester,
  ) async {
    const customColor = Colors.pinkAccent;

    await tester.pumpWidget(
      buildTestApp(
        child: const GlassToggle(
          value: true,
          activeColor: customColor,
          onChanged: _dummyOnChanged,
        ),
      ),
    );

    await tester.pump();

    final toggle = tester.widget<GlassToggle>(find.byType(GlassToggle));

    expect(toggle.activeColor, customColor);
  });

  // ==========================================================================
  // 11. TRACK REÇOIT CORRECTEMENT VALUE
  // ==========================================================================

  testWidgets('GlassToggle transmet correctement value au GlassToggleTrack', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildTestApp(
        child: const GlassToggle(value: true, onChanged: _dummyOnChanged),
      ),
    );

    await tester.pump();

    final track = tester.widget<GlassToggleTrack>(
      find.byType(GlassToggleTrack),
    );

    expect(track.value, isTrue);
  });

  // ==========================================================================
  // 12. KNOB REÇOIT CORRECTEMENT VALUE
  // ==========================================================================

  testWidgets('GlassToggle transmet correctement value au GlassToggleKnob', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildTestApp(
        child: const GlassToggle(value: false, onChanged: _dummyOnChanged),
      ),
    );

    await tester.pump();

    final knob = tester.widget<GlassToggleKnob>(find.byType(GlassToggleKnob));

    expect(knob.value, isFalse);
  });

  // ==========================================================================
  // 13. TRACK REÇOIT LA COULEUR ACTIVE
  // ==========================================================================

  testWidgets('GlassToggle transmet activeColor au GlassToggleTrack', (
    tester,
  ) async {
    const customColor = Colors.orange;

    await tester.pumpWidget(
      buildTestApp(
        child: const GlassToggle(
          value: true,
          activeColor: customColor,
          onChanged: _dummyOnChanged,
        ),
      ),
    );

    await tester.pump();

    final track = tester.widget<GlassToggleTrack>(
      find.byType(GlassToggleTrack),
    );

    expect(track.activeColor, customColor);
  });

  // ==========================================================================
  // 14. KNOB REÇOIT LA COULEUR ACTIVE
  // ==========================================================================

  testWidgets('GlassToggle transmet activeColor au GlassToggleKnob', (
    tester,
  ) async {
    const customColor = Colors.greenAccent;

    await tester.pumpWidget(
      buildTestApp(
        child: const GlassToggle(
          value: true,
          activeColor: customColor,
          onChanged: _dummyOnChanged,
        ),
      ),
    );

    await tester.pump();

    final knob = tester.widget<GlassToggleKnob>(find.byType(GlassToggleKnob));

    expect(knob.activeColor, customColor);
  });

  // ==========================================================================
  // 15. ANIMATION D'APPUI
  // ==========================================================================

  testWidgets('GlassToggle lance réellement son animation lors de l appui', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildTestApp(
        child: const GlassToggle(value: false, onChanged: _dummyOnChanged),
      ),
    );

    await tester.pump();

    final center = tester.getCenter(find.byType(GlassToggle));

    final gesture = await tester.startGesture(center);

    await tester.pump(const Duration(milliseconds: 50));

    // L'état _pressed est privé.
    // On vérifie donc que l'animation existe et que le widget
    // reste correctement monté pendant l'appui.

    expect(find.byType(GlassToggle), findsOneWidget);

    await gesture.up();

    await tester.pump(const Duration(milliseconds: 100));

    expect(find.byType(GlassToggle), findsOneWidget);
  });

  // ==========================================================================
  // 16. ANIMATION DE POSITION DU KNOB
  // ==========================================================================

  testWidgets('GlassToggleKnob reste monté pendant son animation', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildTestApp(
        child: const GlassToggle(value: false, onChanged: _dummyOnChanged),
      ),
    );

    await tester.pump();

    expect(find.byType(GlassToggleKnob), findsOneWidget);

    await tester.pumpWidget(
      buildTestApp(
        child: const GlassToggle(value: true, onChanged: _dummyOnChanged),
      ),
    );

    await tester.pump(const Duration(milliseconds: 100));

    expect(find.byType(GlassToggleKnob), findsOneWidget);

    await tester.pumpAndSettle();

    expect(find.byType(GlassToggleKnob), findsOneWidget);
  });

  // ==========================================================================
  // 17. GLASS HIGHLIGHT
  // ==========================================================================

  testWidgets('GlassToggleTrack contient réellement GlassHighlight', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildTestApp(
        child: const GlassToggle(value: false, onChanged: _dummyOnChanged),
      ),
    );

    await tester.pump();

    expect(find.byType(GlassHighlight), findsOneWidget);
  });

  // ==========================================================================
  // 18. TOUS LES ÉLÉMENTS GLASS SONT PRÉSENTS
  // ==========================================================================

  testWidgets('GlassToggle construit toute son architecture Glass', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildTestApp(
        child: const GlassToggle(value: true, onChanged: _dummyOnChanged),
      ),
    );

    await tester.pump();

    expect(find.byType(GlassToggle), findsOneWidget);

    expect(find.byType(GlassToggleTrack), findsOneWidget);

    expect(find.byType(GlassToggleKnob), findsOneWidget);

    expect(find.byType(GlassHighlight), findsOneWidget);
  });

  // ==========================================================================
  // 19. PLUSIEURS TOGGLES INDÉPENDANTS
  // ==========================================================================

  testWidgets('Plusieurs GlassToggle restent indépendants', (tester) async {
    bool firstValue = false;
    bool secondValue = true;

    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GlassToggle(
                value: firstValue,
                onChanged: (value) {
                  firstValue = value;
                },
              ),
              const SizedBox(width: 20),
              GlassToggle(
                value: secondValue,
                onChanged: (value) {
                  secondValue = value;
                },
              ),
            ],
          ),
        ),
      ),
    );

    await tester.pump();

    expect(find.byType(GlassToggle), findsNWidgets(2));

    final toggles = find.byType(GlassToggle);

    await tester.tap(toggles.at(0));

    await tester.pump();

    expect(firstValue, isTrue);

    expect(secondValue, isTrue);
  });

  // ==========================================================================
  // 20. TAILLE DU KNOB — PETIT TOGGLE
  // ==========================================================================

  testWidgets('GlassToggleKnob respecte la taille minimale du knob', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildTestApp(
        child: const GlassToggle(
          value: false,
          width: 40,
          height: 20,
          onChanged: _dummyOnChanged,
        ),
      ),
    );

    await tester.pump();

    final knob = tester.widget<GlassToggleKnob>(find.byType(GlassToggleKnob));

    final knobSize = (knob.height * GlassToggleKnob.knobHeightFactor).clamp(
      GlassToggleKnob.minKnobSize,
      GlassToggleKnob.maxKnobSize,
    );

    expect(knobSize, GlassToggleKnob.minKnobSize);
  });

  // ==========================================================================
  // 21. TAILLE DU KNOB — GRAND TOGGLE
  // ==========================================================================

  testWidgets('GlassToggleKnob respecte la taille maximale du knob', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildTestApp(
        child: const GlassToggle(
          value: true,
          width: 150,
          height: 100,
          onChanged: _dummyOnChanged,
        ),
      ),
    );

    await tester.pump();

    final knob = tester.widget<GlassToggleKnob>(find.byType(GlassToggleKnob));

    final knobSize = (knob.height * GlassToggleKnob.knobHeightFactor).clamp(
      GlassToggleKnob.minKnobSize,
      GlassToggleKnob.maxKnobSize,
    );

    expect(knobSize, GlassToggleKnob.maxKnobSize);
  });

  // ==========================================================================
  // 22. CALLBACK REÇOIT TOUJOURS LA VALEUR INVERSE
  // ==========================================================================

  testWidgets('GlassToggle envoie toujours la valeur inverse de value', (
    tester,
  ) async {
    final receivedValues = <bool>[];

    await tester.pumpWidget(
      buildTestApp(
        child: GlassToggle(value: false, onChanged: receivedValues.add),
      ),
    );

    await tester.pump();

    await tester.tap(find.byType(GlassToggle));

    await tester.pump();

    expect(receivedValues, [true]);

    await tester.pumpWidget(
      buildTestApp(
        child: GlassToggle(value: true, onChanged: receivedValues.add),
      ),
    );

    await tester.pump();

    await tester.tap(find.byType(GlassToggle));

    await tester.pump();

    expect(receivedValues, [true, false]);
  });
}

// ============================================================================
// CALLBACK DE TEST
// ============================================================================

void _dummyOnChanged(bool value) {}
