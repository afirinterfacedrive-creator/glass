import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:universal_glass/components/glass_button.dart';
import 'package:universal_glass/components/glass_icon.dart';
import 'package:universal_glass/enums/glass_enums.dart';
import 'package:universal_glass/theme/glass_effects.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // ==========================================================================
  // HELPERS
  // ==========================================================================

  GlassEffects createEffects() {
    return const GlassEffects(
      bgGradient: [Colors.blue, Colors.black],
      blur: 20.0,
    );
  }

  Widget buildButton({
    GlassShapeType shape = GlassShapeType.squareRounded,
    GlassStyle style = GlassStyle.transparentAqua,
    double width = 200.0,
    double height = 60.0,
    String? label,
    IconData? leadingIcon,
    Color? leadingIconColor,
    double leadingIconScale = 60.0,
    bool leadingIconIsActive = false,
    VoidCallback? onLeadingIconTap,
    double? fontSize,
    bool showSpinner = false,
    bool replaceIcon = false,
    SpinnerPosition spinnerPosition = SpinnerPosition.left,
    double borderRadius = 35.0,
    String? subLabel,
    TextStyle? subLabelStyle,
    double subLabelSpacing = 6.0,
    VoidCallback? onTap,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: GlassButton(
            effects: createEffects(),
            shape: shape,
            style: style,
            width: width,
            height: height,
            label: label,
            leadingIcon: leadingIcon,
            leadingIconColor: leadingIconColor,
            leadingIconScale: leadingIconScale,
            leadingIconIsActive: leadingIconIsActive,
            onLeadingIconTap: onLeadingIconTap,
            fontSize: fontSize,
            showSpinner: showSpinner,
            replaceIcon: replaceIcon,
            spinnerPosition: spinnerPosition,
            borderRadius: borderRadius,
            subLabel: subLabel,
            subLabelStyle: subLabelStyle,
            subLabelSpacing: subLabelSpacing,
            onTap: onTap ?? () {},
          ),
        ),
      ),
    );
  }

  // ==========================================================================
  // 1. CONSTRUCTION
  // ==========================================================================

  testWidgets('GlassButton peut être construit sans erreur', (tester) async {
    await tester.pumpWidget(buildButton());

    await tester.pump();

    expect(find.byType(GlassButton), findsOneWidget);
  });

  // ==========================================================================
  // 2. LABEL
  // ==========================================================================

  testWidgets('GlassButton affiche correctement son label', (tester) async {
    await tester.pumpWidget(buildButton(label: 'TEST'));

    await tester.pump();

    expect(find.text('TEST'), findsOneWidget);
  });

  // ==========================================================================
  // 3. ICON
  // ==========================================================================

  testWidgets('GlassButton accepte une icône', (tester) async {
    await tester.pumpWidget(buildButton(leadingIcon: Icons.wifi));

    await tester.pump();

    expect(find.byIcon(Icons.wifi), findsOneWidget);
  });

  // ==========================================================================
  // 4. ICON + LABEL
  // ==========================================================================

  testWidgets('GlassButton affiche icône et label ensemble', (tester) async {
    await tester.pumpWidget(
      buildButton(leadingIcon: Icons.wifi, label: 'WiFi'),
    );

    await tester.pump();

    expect(find.byIcon(Icons.wifi), findsOneWidget);

    expect(find.text('WiFi'), findsOneWidget);
  });

  // ==========================================================================
  // 5. CIRCLE
  // ==========================================================================

  testWidgets('GlassButton fonctionne avec la forme circle', (tester) async {
    await tester.pumpWidget(
      buildButton(
        shape: GlassShapeType.circle,
        width: 70,
        height: 70,
        leadingIcon: Icons.home,
      ),
    );

    await tester.pump();

    expect(find.byType(GlassButton), findsOneWidget);

    expect(find.byIcon(Icons.home), findsOneWidget);
  });

  // ==========================================================================
  // 6. SQUARE ROUNDED
  // ==========================================================================

  testWidgets('GlassButton fonctionne avec squareRounded', (tester) async {
    await tester.pumpWidget(
      buildButton(
        shape: GlassShapeType.squareRounded,
        leadingIcon: Icons.settings,
      ),
    );

    await tester.pump();

    expect(find.byIcon(Icons.settings), findsOneWidget);
  });

  // ==========================================================================
  // 7. CAPSULE VERTICAL
  // ==========================================================================

  testWidgets('GlassButton fonctionne avec capsuleVertical', (tester) async {
    await tester.pumpWidget(
      buildButton(
        shape: GlassShapeType.capsuleVertical,
        width: 60,
        height: 120,
        leadingIcon: Icons.volume_up,
      ),
    );

    await tester.pump();

    expect(find.byIcon(Icons.volume_up), findsOneWidget);
  });

  // ==========================================================================
  // 8. PILL HORIZONTAL
  // ==========================================================================

  testWidgets('GlassButton fonctionne avec pillHorizontal', (tester) async {
    await tester.pumpWidget(
      buildButton(
        shape: GlassShapeType.pillHorizontal,
        width: 220,
        height: 60,
        label: 'Volume',
      ),
    );

    await tester.pump();

    expect(find.text('Volume'), findsOneWidget);
  });

  // ==========================================================================
  // 9. STYLE AQUA
  // ==========================================================================

  testWidgets('GlassButton accepte le style transparentAqua', (tester) async {
    await tester.pumpWidget(
      buildButton(style: GlassStyle.transparentAqua, label: 'Aqua'),
    );

    await tester.pump();

    expect(find.text('Aqua'), findsOneWidget);
  });

  // ==========================================================================
  // 10. STYLE OPAQUE
  // ==========================================================================

  testWidgets('GlassButton accepte le style opaqueMat', (tester) async {
    await tester.pumpWidget(
      buildButton(style: GlassStyle.opaqueMat, label: 'Opaque'),
    );

    await tester.pump();

    expect(find.text('Opaque'), findsOneWidget);
  });

  // ==========================================================================
  // 11. TAP
  // ==========================================================================

  testWidgets('onTap est appelé lorsque le bouton est pressé', (tester) async {
    int tapCount = 0;

    await tester.pumpWidget(
      buildButton(
        label: 'Action',
        onTap: () {
          tapCount++;
        },
      ),
    );

    await tester.pump();

    await tester.tap(find.byType(GlassButton));

    await tester.pump();

    expect(tapCount, 1);
  });

  // ==========================================================================
  // 12. MULTIPLE TAPS
  // ==========================================================================

  testWidgets('onTap peut être appelé plusieurs fois', (tester) async {
    int tapCount = 0;

    await tester.pumpWidget(
      buildButton(
        label: 'Action',
        onTap: () {
          tapCount++;
        },
      ),
    );

    await tester.pump();

    final button = find.byType(GlassButton);

    await tester.tap(button);
    await tester.pump();

    await tester.tap(button);
    await tester.pump();

    await tester.tap(button);
    await tester.pump();

    expect(tapCount, 3);
  });

  // ==========================================================================
  // 13. SUB LABEL
  // ==========================================================================

  testWidgets('subLabel est affiché sous le bouton', (tester) async {
    await tester.pumpWidget(buildButton(label: 'WiFi', subLabel: 'Connexion'));

    await tester.pump();

    expect(find.text('WiFi'), findsOneWidget);

    expect(find.text('Connexion'), findsOneWidget);
  });

  // ==========================================================================
  // 14. SUB LABEL ABSENT
  // ==========================================================================

  testWidgets('subLabel ne produit aucun texte lorsqu il est null', (
    tester,
  ) async {
    await tester.pumpWidget(buildButton(label: 'WiFi'));

    await tester.pump();

    expect(find.text('WiFi'), findsOneWidget);

    expect(find.text('Connexion'), findsNothing);
  });

  // ==========================================================================
  // 15. SUB LABEL STYLE
  // ==========================================================================

  testWidgets('subLabel accepte un style personnalisé', (tester) async {
    const customStyle = TextStyle(fontSize: 18, fontWeight: FontWeight.bold);

    await tester.pumpWidget(
      buildButton(label: 'WiFi', subLabel: 'Actif', subLabelStyle: customStyle),
    );

    await tester.pump();

    final textFinder = find.text('Actif');

    expect(textFinder, findsOneWidget);

    final textWidget = tester.widget<Text>(textFinder);

    expect(textWidget.style?.fontSize, 18);

    expect(textWidget.style?.fontWeight, FontWeight.bold);
  });

  // ==========================================================================
  // 16. SUB LABEL SPACING
  // ==========================================================================

  testWidgets('subLabelSpacing est accepté', (tester) async {
    await tester.pumpWidget(
      buildButton(label: 'WiFi', subLabel: 'Actif', subLabelSpacing: 12),
    );

    await tester.pump();

    expect(find.text('WiFi'), findsOneWidget);

    expect(find.text('Actif'), findsOneWidget);
  });

  // ==========================================================================
  // 17. SPINNER
  // ==========================================================================

  testWidgets('showSpinner affiche un CircularProgressIndicator', (
    tester,
  ) async {
    await tester.pumpWidget(buildButton(label: 'Connexion', showSpinner: true));

    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  // ==========================================================================
  // 18. SPINNER LEFT
  // ==========================================================================

  testWidgets('spinnerPosition left est accepté', (tester) async {
    await tester.pumpWidget(
      buildButton(
        label: 'Connexion',
        showSpinner: true,
        spinnerPosition: SpinnerPosition.left,
      ),
    );

    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    expect(find.text('Connexion'), findsOneWidget);
  });

  // ==========================================================================
  // 19. SPINNER RIGHT
  // ==========================================================================

  testWidgets('spinnerPosition right est accepté', (tester) async {
    await tester.pumpWidget(
      buildButton(
        label: 'Connexion',
        showSpinner: true,
        spinnerPosition: SpinnerPosition.right,
      ),
    );

    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    expect(find.text('Connexion'), findsOneWidget);
  });

  // ==========================================================================
  // 20. REPLACE ICON
  // ==========================================================================

  testWidgets('replaceIcon masque l icône lorsque le spinner est actif', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildButton(
        label: 'Connexion',
        leadingIcon: Icons.wifi,
        showSpinner: true,
        replaceIcon: true,
      ),
    );

    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    expect(find.byIcon(Icons.wifi), findsNothing);
  });

  // ==========================================================================
  // 21. SPINNER + ICON
  // ==========================================================================

  testWidgets('spinner et icône peuvent être affichés ensemble', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildButton(
        label: 'Connexion',
        leadingIcon: Icons.wifi,
        showSpinner: true,
        replaceIcon: false,
      ),
    );

    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    expect(find.byIcon(Icons.wifi), findsOneWidget);
  });

  // ==========================================================================
  // 22. ICON COLOR
  // ==========================================================================

  testWidgets('leadingIconColor est accepté', (tester) async {
    await tester.pumpWidget(
      buildButton(leadingIcon: Icons.favorite, leadingIconColor: Colors.red),
    );

    await tester.pump();

    expect(find.byIcon(Icons.favorite), findsOneWidget);
  });

  // ==========================================================================
  // 23. ICON SCALE
  // ==========================================================================

  testWidgets('leadingIconScale est accepté', (tester) async {
    await tester.pumpWidget(
      buildButton(
        shape: GlassShapeType.circle,
        width: 80,
        height: 80,
        leadingIcon: Icons.home,
        leadingIconScale: 80,
      ),
    );

    await tester.pump();

    expect(find.byIcon(Icons.home), findsOneWidget);
  });

  // ==========================================================================
  // 24. ACTIVE ICON
  // ==========================================================================
  // ==========================================================================
  // 24. ACTIVE ICON
  // ==========================================================================

  testWidgets('leadingIconIsActive est accepté', (tester) async {
    await tester.pumpWidget(
      buildButton(leadingIcon: Icons.wifi, leadingIconIsActive: true),
    );

    await tester.pump();

    // GlassIcon peut utiliser plusieurs couches Icon
    // pour produire l'effet lumineux actif.
    expect(find.byType(GlassIcon), findsOneWidget);

    expect(find.byIcon(Icons.wifi), findsWidgets);
  });

  // ==========================================================================
  // 25. LEADING ICON TAP
  // ==========================================================================

  testWidgets('onLeadingIconTap peut être fourni séparément', (tester) async {
    int iconTapCount = 0;
    int buttonTapCount = 0;

    await tester.pumpWidget(
      buildButton(
        leadingIcon: Icons.settings,
        onTap: () {
          buttonTapCount++;
        },
        onLeadingIconTap: () {
          iconTapCount++;
        },
      ),
    );

    await tester.pump();

    await tester.tap(find.byIcon(Icons.settings));

    await tester.pump();

    expect(iconTapCount, 1);

    expect(buttonTapCount, 0);
  });

  // ==========================================================================
  // 26. FONT SIZE
  // ==========================================================================

  testWidgets('fontSize personnalisé est appliqué au label', (tester) async {
    await tester.pumpWidget(buildButton(label: 'Test', fontSize: 20));

    await tester.pump();

    final text = tester.widget<Text>(find.text('Test'));

    expect(text.style?.fontSize, 20);
  });

  // ==========================================================================
  // 27. BORDER RADIUS
  // ==========================================================================

  testWidgets('borderRadius personnalisé est accepté', (tester) async {
    await tester.pumpWidget(buildButton(borderRadius: 15, label: 'Rounded'));

    await tester.pump();

    expect(find.text('Rounded'), findsOneWidget);
  });

  // ==========================================================================
  // 28. CUSTOM EFFECTS
  // ==========================================================================

  testWidgets('GlassButton accepte des effets personnalisés', (tester) async {
    const effects = GlassEffects(
      bgGradient: [Colors.red, Colors.black],
      borderGradient: [Colors.white, Colors.red],
      blur: 30,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: GlassButton(
              effects: effects,
              shape: GlassShapeType.squareRounded,
              style: GlassStyle.opaqueMat,
              label: 'Custom',
              onTap: () {},
            ),
          ),
        ),
      ),
    );

    await tester.pump();

    expect(find.text('Custom'), findsOneWidget);
  });

  // ==========================================================================
  // 29. DEFAULT HEIGHT
  // ==========================================================================

  testWidgets('la hauteur par défaut est de 60 pixels', (tester) async {
    await tester.pumpWidget(buildButton(width: 200, label: 'Test'));

    await tester.pump();

    final size = tester.getSize(find.byType(GlassButton));

    expect(size.height, 60);
  });

  // ==========================================================================
  // 30. CUSTOM HEIGHT
  // ==========================================================================

  testWidgets('la hauteur personnalisée est respectée', (tester) async {
    await tester.pumpWidget(buildButton(width: 200, height: 80, label: 'Test'));

    await tester.pump();

    final size = tester.getSize(find.byType(GlassButton));

    expect(size.height, 80);
  });

  // ==========================================================================
  // 31. CUSTOM WIDTH
  // ==========================================================================

  testWidgets('la largeur personnalisée est respectée', (tester) async {
    await tester.pumpWidget(buildButton(width: 280, label: 'Test'));

    await tester.pump();

    final size = tester.getSize(find.byType(GlassButton));

    expect(size.width, 280);
  });

  // ==========================================================================
  // 32. LONG LABEL
  // ==========================================================================

  testWidgets('un label long est géré sans erreur', (tester) async {
    await tester.pumpWidget(
      buildButton(width: 180, label: 'Connexion réseau très longue'),
    );

    await tester.pump();

    expect(find.byType(GlassButton), findsOneWidget);
  });

  // ==========================================================================
  // 33. ICON ONLY CIRCLE
  // ==========================================================================

  testWidgets(
    'un bouton circle avec uniquement une icône affiche correctement celle-ci',
    (tester) async {
      await tester.pumpWidget(
        buildButton(
          shape: GlassShapeType.circle,
          width: 80,
          height: 80,
          leadingIcon: Icons.bluetooth,
        ),
      );

      await tester.pump();

      expect(find.byIcon(Icons.bluetooth), findsOneWidget);

      expect(find.byType(CircularProgressIndicator), findsNothing);
    },
  );

  // ==========================================================================
  // 34. EMPTY BUTTON
  // ==========================================================================

  testWidgets('un bouton sans label ni icône reste constructible', (
    tester,
  ) async {
    await tester.pumpWidget(buildButton());

    await tester.pump();

    expect(find.byType(GlassButton), findsOneWidget);
  });

  // ==========================================================================
  // 35. SUBLABEL WITH ICON
  // ==========================================================================

  testWidgets('subLabel fonctionne avec une icône', (tester) async {
    await tester.pumpWidget(
      buildButton(leadingIcon: Icons.wifi, subLabel: 'Réseau'),
    );

    await tester.pump();

    expect(find.byIcon(Icons.wifi), findsOneWidget);

    expect(find.text('Réseau'), findsOneWidget);
  });

  // ==========================================================================
  // 36. SUBLABEL WITH CIRCLE
  // ==========================================================================

  testWidgets('subLabel fonctionne avec un bouton circulaire', (tester) async {
    await tester.pumpWidget(
      buildButton(
        shape: GlassShapeType.circle,
        width: 80,
        height: 80,
        leadingIcon: Icons.home,
        subLabel: 'Accueil',
      ),
    );

    await tester.pump();

    expect(find.byIcon(Icons.home), findsOneWidget);

    expect(find.text('Accueil'), findsOneWidget);
  });

  // ==========================================================================
  // 37. ALL SHAPES
  // ==========================================================================

  testWidgets('toutes les formes GlassShapeType sont constructibles', (
    tester,
  ) async {
    const shapes = [
      GlassShapeType.circle,
      GlassShapeType.squareRounded,
      GlassShapeType.capsuleVertical,
      GlassShapeType.pillHorizontal,
    ];

    for (final shape in shapes) {
      await tester.pumpWidget(
        buildButton(shape: shape, width: 200, height: 80, label: 'Shape'),
      );

      await tester.pump();

      expect(find.byType(GlassButton), findsOneWidget);

      expect(find.text('Shape'), findsOneWidget);
    }
  });

  // ==========================================================================
  // 38. SPINNER + SUBLABEL
  // ==========================================================================

  testWidgets('spinner et subLabel fonctionnent ensemble', (tester) async {
    await tester.pumpWidget(
      buildButton(
        label: 'Connexion',
        showSpinner: true,
        subLabel: 'Veuillez patienter',
      ),
    );

    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    expect(find.text('Connexion'), findsOneWidget);

    expect(find.text('Veuillez patienter'), findsOneWidget);
  });

  // ==========================================================================
  // 39. ICON TAP FALLBACK
  // ==========================================================================

  testWidgets('sans onLeadingIconTap, le tap de l icône utilise onTap', (
    tester,
  ) async {
    int tapCount = 0;

    await tester.pumpWidget(
      buildButton(
        leadingIcon: Icons.power,
        onTap: () {
          tapCount++;
        },
      ),
    );

    await tester.pump();

    await tester.tap(find.byIcon(Icons.power));

    await tester.pump();

    expect(tapCount, 1);
  });

  // ==========================================================================
  // 40. EFFECTS LIQUID BLUE
  // ==========================================================================

  testWidgets('GlassButton fonctionne avec GlassEffects.liquidBlue', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: GlassButton(
              effects: GlassEffects.liquidBlue,
              shape: GlassShapeType.squareRounded,
              style: GlassStyle.transparentAqua,
              label: 'Liquid Blue',
              onTap: () {},
            ),
          ),
        ),
      ),
    );

    await tester.pump();

    expect(find.text('Liquid Blue'), findsOneWidget);
  });

  // ==========================================================================
  // 41. EFFECTS LIQUID RED
  // ==========================================================================

  testWidgets('GlassButton fonctionne avec GlassEffects.liquidRed', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: GlassButton(
              effects: GlassEffects.liquidRed,
              shape: GlassShapeType.squareRounded,
              style: GlassStyle.opaqueMat,
              label: 'Liquid Red',
              onTap: () {},
            ),
          ),
        ),
      ),
    );

    await tester.pump();

    expect(find.text('Liquid Red'), findsOneWidget);
  });

  // ==========================================================================
  // 42. EFFECTS LIQUID GREEN
  // ==========================================================================

  testWidgets('GlassButton fonctionne avec GlassEffects.liquidGreen', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: GlassButton(
              effects: GlassEffects.liquidGreen,
              shape: GlassShapeType.squareRounded,
              style: GlassStyle.transparentAqua,
              label: 'Liquid Green',
              onTap: () {},
            ),
          ),
        ),
      ),
    );

    await tester.pump();

    expect(find.text('Liquid Green'), findsOneWidget);
  });
}
