import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:universal_glass/glass.dart';



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
  // 3. DIMENSIONS PAR DÉFAUT - MEDIUM
  // ==========================================================================

  testWidgets('GlassToggle respecte ses dimensions par défaut medium', (tester) async {
    await tester.pumpWidget(
      buildTestApp(child: GlassToggle(value: false, onChanged: (_) {})),
    );

    await tester.pump();

    final size = tester.getSize(find.byType(GlassToggle));
    expect(size.width, 65);
    expect(size.height, 35);
  });

  // ==========================================================================
  // 4. DIMENSIONS PERSONNALISÉES VIA SIZE
  // ==========================================================================

  testWidgets('GlassToggle respecte la taille large', (tester) async {
    await tester.pumpWidget(
      buildTestApp(
        child: GlassToggle(
          value: false,
          size: GlassToggleSize.large,
          onChanged: (_) {},
        ),
      ),
    );

    await tester.pump();

    final size = tester.getSize(find.byType(GlassToggle));
    expect(size.width, 78);
    expect(size.height, 42);
  });

  testWidgets('GlassToggle respecte la taille small', (tester) async {
    await tester.pumpWidget(
      buildTestApp(
        child: GlassToggle(
          value: false,
          size: GlassToggleSize.small,
          onChanged: (_) {},
        ),
      ),
    );

    await tester.pump();

    final size = tester.getSize(find.byType(GlassToggle));
    expect(size.width, 52);
    expect(size.height, 28);
  });

  // ==========================================================================
  // 5. TAP RÉEL OFF → ON
  // ==========================================================================

  testWidgets('GlassToggle déclenche onChanged lors du tap OFF → ON', (tester) async {
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
  });

  // ==========================================================================
  // 6. TAP RÉEL ON → OFF
  // ==========================================================================

  testWidgets('GlassToggle déclenche onChanged lors du tap ON → OFF', (tester) async {
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
  });

  // ==========================================================================
  // 7. VRAI CYCLE OFF → ON → OFF
  // ==========================================================================

  testWidgets('GlassToggle fonctionne sur un cycle complet OFF → ON → OFF', (tester) async {
    bool value = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: StatefulBuilder(
              builder: (context, stateSetter) {
                return GlassToggle(
                  value: value,
                  onChanged: (newValue) {
                    stateSetter(() => value = newValue);
                  },
                );
              },
            ),
          ),
        ),
      ),
    );

    await tester.pump();
    expect(value, isFalse);

    await tester.tap(find.byType(GlassToggle));
    await tester.pump();
    expect(value, isTrue);

    await tester.tap(find.byType(GlassToggle));
    await tester.pump();
    expect(value, isFalse);
  });

  // ==========================================================================
  // 8. ÉTAT DÉSACTIVÉ
  // ==========================================================================

  testWidgets('GlassToggle désactivé n appelle pas onChanged', (tester) async {
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
  });

  // ==========================================================================
  // 9. STYLE BREAKER
  // ==========================================================================

  testWidgets('GlassToggle style breaker affiche O et I', (tester) async {
    await tester.pumpWidget(
      buildTestApp(
        child: GlassToggle(
          style: GlassToggleStyle.breaker,
          value: true,
          onChanged: (_) {},
        ),
      ),
    );

    await tester.pump();
    expect(find.text('O'), findsOneWidget);
    expect(find.text('I'), findsOneWidget);
  });

  testWidgets('GlassToggle breaker respecte dimensions large', (tester) async {
    await tester.pumpWidget(
      buildTestApp(
        child: GlassToggle(
          style: GlassToggleStyle.breaker,
          size: GlassToggleSize.large,
          value: false,
          onChanged: (_) {},
        ),
      ),
    );

    await tester.pump();
    final size = tester.getSize(find.byType(GlassToggle));
    expect(size.width, 86);
    expect(size.height, 48);
  });

  // ==========================================================================
  // 10. COULEUR ACTIVE PERSONNALISÉE
  // ==========================================================================

  testWidgets('GlassToggle accepte activeColor personnalisée', (tester) async {
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
  // 11. TRACK ET KNOB REÇOIVENT VALUE
  // ==========================================================================

  testWidgets('GlassToggle transmet value au Track et Knob', (tester) async {
    await tester.pumpWidget(
      buildTestApp(
        child: const GlassToggle(value: true, onChanged: _dummyOnChanged),
      ),
    );

    await tester.pump();
    final track = tester.widget<GlassToggleTrack>(find.byType(GlassToggleTrack));
    final knob = tester.widget<GlassToggleKnob>(find.byType(GlassToggleKnob));
    expect(track.value, isTrue);
    expect(knob.value, isTrue);
  });

  // ==========================================================================
  // 12. TRACK ET KNOB REÇOIVENT ACTIVE COLOR
  // ==========================================================================

  testWidgets('GlassToggle transmet activeColor au Track et Knob', (tester) async {
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
    final track = tester.widget<GlassToggleTrack>(find.byType(GlassToggleTrack));
    final knob = tester.widget<GlassToggleKnob>(find.byType(GlassToggleKnob));
    expect(track.activeColor, customColor);
    expect(knob.activeColor, customColor);
  });

  // ==========================================================================
  // 13. GLASS HIGHLIGHT PRÉSENT
  // ==========================================================================

  testWidgets('GlassToggleTrack contient GlassHighlight', (tester) async {
    await tester.pumpWidget(
      buildTestApp(child: const GlassToggle(value: false, onChanged: _dummyOnChanged)),
    );
    await tester.pump();
    expect(find.byType(GlassHighlight), findsOneWidget);
  });

  // ==========================================================================
  // 14. PLUSIEURS TOGGLES INDÉPENDANTS
  // ==========================================================================

  testWidgets('Plusieurs GlassToggle restent indépendants', (tester) async {
    bool firstValue = false;
    bool secondValue = true;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Row(
            children: [
              GlassToggle(value: firstValue, onChanged: (v) => firstValue = v),
              const SizedBox(width: 20),
              GlassToggle(value: secondValue, onChanged: (v) => secondValue = v),
            ],
          ),
        ),
      ),
    );

    await tester.pump();
    expect(find.byType(GlassToggle), findsNWidgets(2));

    await tester.tap(find.byType(GlassToggle).first);
    await tester.pump();

    expect(firstValue, isTrue);
    expect(secondValue, isTrue);
  });

  // ==========================================================================
  // 15. CALLBACK REÇOIT TOUJOURS LA VALEUR INVERSE
  // ==========================================================================

  testWidgets('GlassToggle envoie toujours la valeur inverse', (tester) async {
    final receivedValues = <bool>[];

    await tester.pumpWidget(
      buildTestApp(child: GlassToggle(value: false, onChanged: receivedValues.add)),
    );
    await tester.pump();
    await tester.tap(find.byType(GlassToggle));
    await tester.pump();
    expect(receivedValues, [true]);

    await tester.pumpWidget(
      buildTestApp(child: GlassToggle(value: true, onChanged: receivedValues.add)),
    );
    await tester.pump();
    await tester.tap(find.byType(GlassToggle));
    await tester.pump();
    expect(receivedValues, [true, false]);
  });
}

void _dummyOnChanged(bool value) {}