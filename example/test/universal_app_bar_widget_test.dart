import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:glass/glass.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late SharedPreferences prefs;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
  });

  // ==========================================================================
  // OUTILS DE TEST
  // ==========================================================================

  /// Configure une largeur réelle pour le WidgetTester.
  ///
  /// UniversalAppBar utilise MediaQuery.sizeOf(context).width pour déterminer
  /// son mode responsive.
  void setTestSize(
    WidgetTester tester, {
    required double width,
    double height = 800,
  }) {
    tester.view.physicalSize = Size(width, height);

    tester.view.devicePixelRatio = 1.0;
  }

  /// Restaure la taille normale du WidgetTester.
  void resetTestSize(WidgetTester tester) {
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  }

  // ==========================================================================
  // APPLICATION DE TEST
  // ==========================================================================

  Widget buildTestApp({
    Widget? child,
    ThemeMode themeMode = ThemeMode.light,
    Map<String, WidgetBuilder> routes = const {},
    String? initialRoute,
  }) {
    return ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        themeMode: themeMode,
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        initialRoute: initialRoute,
        routes: routes,
        home: initialRoute == null ? child ?? const _BasicAppBarPage() : null,
      ),
    );
  }

  // ==========================================================================
  // 1. AFFICHAGE DE BASE
  // ==========================================================================

  testWidgets('UniversalAppBar affiche correctement son titre', (tester) async {
    await tester.pumpWidget(
      buildTestApp(
        child: const Scaffold(
          appBar: UniversalAppBar(title: 'KDTV', showLogo: false),
          body: SizedBox(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(UniversalAppBar), findsOneWidget);

    expect(find.text('KDTV'), findsOneWidget);
  });

  // ==========================================================================
  // 2. SOUS-TITRE
  // ==========================================================================

  testWidgets('UniversalAppBar affiche le titre et le sous-titre', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildTestApp(
        child: const Scaffold(
          appBar: UniversalAppBar(
            title: 'KDTV',
            subtitle: 'Télévision numérique',
            showLogo: false,
          ),
          body: SizedBox(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('KDTV'), findsOneWidget);

    expect(find.text('Télévision numérique'), findsOneWidget);
  });

  // ==========================================================================
  // 3. LOGO
  // ==========================================================================

  testWidgets('UniversalAppBar affiche son logo lorsque showLogo est activé', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildTestApp(
        child: const Scaffold(
          appBar: UniversalAppBar(title: 'KDTV', showLogo: true),
          body: SizedBox(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.blur_on), findsOneWidget);
  });

  // ==========================================================================
  // 4. MODE COMPACT
  // ==========================================================================

  testWidgets('UniversalAppBar respecte compactMode', (tester) async {
    await tester.pumpWidget(
      buildTestApp(
        child: const Scaffold(
          appBar: UniversalAppBar(
            title: 'KDTV',
            showLogo: false,
            compactMode: true,
          ),
          body: SizedBox(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    final appBar = tester.widget<UniversalAppBar>(find.byType(UniversalAppBar));

    expect(appBar.compactMode, isTrue);

    expect(appBar.preferredSize.height, kToolbarHeight);
  });

  // ==========================================================================
  // 5. FORCE MOBILE LAYOUT
  // ==========================================================================

  testWidgets('UniversalAppBar accepte forceMobileLayout', (tester) async {
    setTestSize(tester, width: 1600);

    addTearDown(() => resetTestSize(tester));

    await tester.pumpWidget(
      buildTestApp(
        child: const Scaffold(
          appBar: UniversalAppBar(
            title: 'KDTV',
            showLogo: false,
            forceMobileLayout: true,
          ),
          body: SizedBox(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    final appBar = tester.widget<UniversalAppBar>(find.byType(UniversalAppBar));

    expect(appBar.forceMobileLayout, isTrue);
  });

  // ==========================================================================
  // 6. BOUTON RETOUR
  // ==========================================================================

  testWidgets('UniversalAppBar déclenche réellement onBack', (tester) async {
    bool backCalled = false;

    await tester.pumpWidget(
      buildTestApp(
        child: Scaffold(
          appBar: UniversalAppBar(
            title: 'KDTV',
            showLogo: false,
            showBackButton: true,
            onBack: () {
              backCalled = true;
            },
          ),
          body: const SizedBox(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.arrow_back), findsOneWidget);

    await tester.tap(find.byIcon(Icons.arrow_back));

    await tester.pump();

    expect(backCalled, isTrue);
  });

  // ==========================================================================
  // 7. ACTION PERSONNALISÉE
  // ==========================================================================

  testWidgets('UniversalAppBar affiche et déclenche une action personnalisée', (
    tester,
  ) async {
    bool actionCalled = false;

    await tester.pumpWidget(
      buildTestApp(
        child: Scaffold(
          appBar: UniversalAppBar(
            title: 'KDTV',
            showLogo: false,
            actions: [
              IconButton(
                key: const ValueKey('test-action'),
                icon: const Icon(Icons.settings),
                onPressed: () {
                  actionCalled = true;
                },
              ),
            ],
          ),
          body: const SizedBox(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('test-action')), findsOneWidget);

    expect(find.byIcon(Icons.settings), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('test-action')));

    await tester.pump();

    expect(actionCalled, isTrue);
  });

  // ==========================================================================
  // 8. ONGLETS DESKTOP — TEST RÉEL
  // ==========================================================================

  testWidgets('UniversalAppBar affiche réellement ses onglets sur desktop', (
    tester,
  ) async {
    // ----------------------------------------------------------------------
    // IMPORTANT :
    //
    // UniversalAppBar considère :
    //
    // >= 950 px = desktop
    //
    // Le WidgetTester n'est pas forcément à 950 px.
    // On force donc une vraie largeur desktop.
    // ----------------------------------------------------------------------

    setTestSize(tester, width: 1200, height: 800);

    addTearDown(() => resetTestSize(tester));

    const tabs = [
      UniversalTabItem(label: 'Accueil', route: '/home', icon: Icons.home),
      UniversalTabItem(
        label: 'Vidéos',
        route: '/videos',
        icon: Icons.video_library,
      ),
      UniversalTabItem(label: 'Direct', route: '/live', icon: Icons.live_tv),
    ];

    await tester.pumpWidget(
      buildTestApp(
        initialRoute: '/home',
        routes: {
          '/home': (_) => const Scaffold(
            appBar: UniversalAppBar(title: 'KDTV', showLogo: false, tabs: tabs),
            body: Center(child: Text('HOME PAGE')),
          ),
          '/videos': (_) =>
              const Scaffold(body: Center(child: Text('VIDEOS PAGE'))),
          '/live': (_) =>
              const Scaffold(body: Center(child: Text('LIVE PAGE'))),
        },
      ),
    );

    await tester.pumpAndSettle();

    // ----------------------------------------------------------------------
    // APP BAR
    // ----------------------------------------------------------------------

    expect(find.byType(UniversalAppBar), findsOneWidget);

    // ----------------------------------------------------------------------
    // TITRE
    // ----------------------------------------------------------------------

    expect(find.text('KDTV'), findsOneWidget);

    // ----------------------------------------------------------------------
    // ONGLETS
    // ----------------------------------------------------------------------

    expect(find.text('Accueil'), findsOneWidget);

    expect(find.text('Vidéos'), findsOneWidget);

    expect(find.text('Direct'), findsOneWidget);

    // ----------------------------------------------------------------------
    // ICÔNES
    // ----------------------------------------------------------------------

    expect(find.byIcon(Icons.home), findsOneWidget);

    expect(find.byIcon(Icons.video_library), findsOneWidget);

    expect(find.byIcon(Icons.live_tv), findsOneWidget);
  });

  // ==========================================================================
  // 9. NAVIGATION RÉELLE
  // ==========================================================================

  testWidgets('UniversalAppBar navigue réellement vers une route', (
    tester,
  ) async {
    setTestSize(tester, width: 1200, height: 800);

    addTearDown(() => resetTestSize(tester));

    const tabs = [
      UniversalTabItem(label: 'Accueil', route: '/home', icon: Icons.home),
      UniversalTabItem(
        label: 'Vidéos',
        route: '/videos',
        icon: Icons.video_library,
      ),
    ];

    await tester.pumpWidget(
      buildTestApp(
        initialRoute: '/home',
        routes: {
          '/home': (_) => const Scaffold(
            appBar: UniversalAppBar(title: 'KDTV', showLogo: false, tabs: tabs),
            body: Center(child: Text('HOME PAGE')),
          ),
          '/videos': (_) =>
              const Scaffold(body: Center(child: Text('VIDEOS PAGE'))),
        },
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('HOME PAGE'), findsOneWidget);

    expect(find.text('Vidéos'), findsOneWidget);

    // ----------------------------------------------------------------------
    // VRAI CLIC
    // ----------------------------------------------------------------------

    await tester.tap(find.text('Vidéos'));

    await tester.pumpAndSettle();

    // ----------------------------------------------------------------------
    // NOUVELLE PAGE
    // ----------------------------------------------------------------------

    expect(find.text('VIDEOS PAGE'), findsOneWidget);
  });

  // ==========================================================================
  // 10. HIDE NAVIGATION
  // ==========================================================================

  testWidgets('UniversalAppBar masque réellement la navigation', (
    tester,
  ) async {
    setTestSize(tester, width: 1200, height: 800);

    addTearDown(() => resetTestSize(tester));

    const tabs = [
      UniversalTabItem(label: 'Accueil', route: '/home', icon: Icons.home),
      UniversalTabItem(
        label: 'Vidéos',
        route: '/videos',
        icon: Icons.video_library,
      ),
    ];

    await tester.pumpWidget(
      buildTestApp(
        child: const Scaffold(
          appBar: UniversalAppBar(
            title: 'KDTV',
            showLogo: false,
            tabs: tabs,
            hideNavigation: true,
          ),
          body: SizedBox(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Accueil'), findsNothing);

    expect(find.text('Vidéos'), findsNothing);

    expect(find.byIcon(Icons.home), findsNothing);

    expect(find.byIcon(Icons.video_library), findsNothing);
  });

  // ==========================================================================
  // 11. FORCE MOBILE SUR DESKTOP
  // ==========================================================================

  testWidgets(
    'UniversalAppBar masque les onglets avec forceMobileLayout sur desktop',
    (tester) async {
      setTestSize(tester, width: 1600, height: 900);

      addTearDown(() => resetTestSize(tester));

      const tabs = [
        UniversalTabItem(label: 'Accueil', route: '/home', icon: Icons.home),
        UniversalTabItem(
          label: 'Vidéos',
          route: '/videos',
          icon: Icons.video_library,
        ),
      ];

      await tester.pumpWidget(
        buildTestApp(
          child: const Scaffold(
            appBar: UniversalAppBar(
              title: 'KDTV',
              showLogo: false,
              tabs: tabs,
              forceMobileLayout: true,
            ),
            body: SizedBox(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Accueil'), findsNothing);

      expect(find.text('Vidéos'), findsNothing);
    },
  );

  // ==========================================================================
  // 12. RESPONSIVE MOBILE
  // ==========================================================================

  testWidgets('UniversalAppBar masque la navigation sur mobile', (
    tester,
  ) async {
    setTestSize(tester, width: 390, height: 844);

    addTearDown(() => resetTestSize(tester));

    const tabs = [
      UniversalTabItem(label: 'Accueil', route: '/home', icon: Icons.home),
    ];

    await tester.pumpWidget(
      buildTestApp(
        child: const Scaffold(
          appBar: UniversalAppBar(title: 'KDTV', showLogo: false, tabs: tabs),
          body: SizedBox(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('KDTV'), findsOneWidget);

    expect(find.text('Accueil'), findsNothing);
  });

  // ==========================================================================
  // 13. RESPONSIVE TABLETTE
  // ==========================================================================

  testWidgets('UniversalAppBar masque la navigation sur tablette', (
    tester,
  ) async {
    setTestSize(tester, width: 800, height: 1280);

    addTearDown(() => resetTestSize(tester));

    const tabs = [
      UniversalTabItem(label: 'Accueil', route: '/home', icon: Icons.home),
    ];

    await tester.pumpWidget(
      buildTestApp(
        child: const Scaffold(
          appBar: UniversalAppBar(title: 'KDTV', showLogo: false, tabs: tabs),
          body: SizedBox(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('KDTV'), findsOneWidget);

    expect(find.text('Accueil'), findsNothing);
  });

  // ==========================================================================
  // 14. RESPONSIVE DESKTOP
  // ==========================================================================

  testWidgets('UniversalAppBar affiche la navigation sur desktop', (
    tester,
  ) async {
    setTestSize(tester, width: 1200, height: 800);

    addTearDown(() => resetTestSize(tester));

    const tabs = [
      UniversalTabItem(label: 'Accueil', route: '/home', icon: Icons.home),
    ];

    await tester.pumpWidget(
      buildTestApp(
        child: const Scaffold(
          appBar: UniversalAppBar(title: 'KDTV', showLogo: false, tabs: tabs),
          body: SizedBox(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Accueil'), findsOneWidget);
  });

  // ==========================================================================
  // 15. RESPONSIVE TV
  // ==========================================================================

  testWidgets('UniversalAppBar fonctionne en mode TV', (tester) async {
    setTestSize(tester, width: 1920, height: 1080);

    addTearDown(() => resetTestSize(tester));

    const tabs = [
      UniversalTabItem(label: 'Accueil', route: '/home', icon: Icons.home),
    ];

    await tester.pumpWidget(
      buildTestApp(
        child: const Scaffold(
          appBar: UniversalAppBar(title: 'KDTV', showLogo: false, tabs: tabs),
          body: SizedBox(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('KDTV'), findsOneWidget);

    expect(find.text('Accueil'), findsOneWidget);
  });

  // ==========================================================================
  // 16. GET APP BAR HEIGHT
  // ==========================================================================

  test('UniversalAppBar.getAppBarHeight retourne les bonnes hauteurs', () {
    expect(UniversalAppBar.getAppBarHeight(400), kToolbarHeight);

    expect(UniversalAppBar.getAppBarHeight(600), kToolbarHeight);

    expect(UniversalAppBar.getAppBarHeight(949), kToolbarHeight);

    expect(UniversalAppBar.getAppBarHeight(950), 80.0);

    expect(UniversalAppBar.getAppBarHeight(1200), 90.0);

    expect(UniversalAppBar.getAppBarHeight(1600), 100.0);
  });

  // ==========================================================================
  // 17. GET SCALE
  // ==========================================================================

  test('UniversalAppBar.getScale retourne les bons facteurs', () {
    expect(UniversalAppBar.getScale(400), 0.90);

    expect(UniversalAppBar.getScale(599), 0.90);

    expect(UniversalAppBar.getScale(600), 1.00);

    expect(UniversalAppBar.getScale(949), 1.00);

    expect(UniversalAppBar.getScale(950), 1.15);

    expect(UniversalAppBar.getScale(1200), 1.30);

    expect(UniversalAppBar.getScale(1400), 1.50);

    expect(UniversalAppBar.getScale(1600), 1.70);
  });

  // ==========================================================================
  // 18. THÈME CLAIR
  // ==========================================================================

  testWidgets('UniversalAppBar fonctionne avec MaterialApp en thème clair', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildTestApp(
        themeMode: ThemeMode.light,
        child: const Scaffold(
          appBar: UniversalAppBar(title: 'KDTV', showLogo: false),
          body: SizedBox(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));

    expect(materialApp.themeMode, ThemeMode.light);

    expect(find.text('KDTV'), findsOneWidget);
  });

  // ==========================================================================
  // 19. THÈME SOMBRE
  // ==========================================================================

  testWidgets('UniversalAppBar fonctionne avec MaterialApp en thème sombre', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildTestApp(
        themeMode: ThemeMode.dark,
        child: const Scaffold(
          appBar: UniversalAppBar(title: 'KDTV', showLogo: false),
          body: SizedBox(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));

    expect(materialApp.themeMode, ThemeMode.dark);

    expect(find.text('KDTV'), findsOneWidget);
  });
}

// ============================================================================
// PAGE DE TEST BASIQUE
// ============================================================================

class _BasicAppBarPage extends StatelessWidget {
  const _BasicAppBarPage();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: UniversalAppBar(title: 'KDTV', showLogo: false),
      body: Center(child: Text('CONTENU')),
    );
  }
}
