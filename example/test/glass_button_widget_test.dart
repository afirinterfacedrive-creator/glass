import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:universal_glass/glass.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late SharedPreferences prefs;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
  });

  // ==========================================================================
  // APPLICATION DE TEST
  // ==========================================================================

  Widget buildTestApp() {
    return ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      child: const _ThemeTestApp(),
    );
  }

  // ==========================================================================
  // 1. MODE SYSTÈME PAR DÉFAUT
  // ==========================================================================

  testWidgets('ThemeProvider démarre en mode système', (tester) async {
    await tester.pumpWidget(buildTestApp());

    await tester.pump();

    final container = ProviderScope.containerOf(
      tester.element(find.byType(_ThemeTestApp)),
    );

    final state = container.read(themeProvider);

    expect(state.mode, AppThemeMode.system);

    expect(state.isSystem, isTrue);

    expect(state.isDark, isFalse);

    expect(state.isLight, isFalse);

    expect(container.read(materialThemeModeProvider), ThemeMode.system);
  });

  // ==========================================================================
  // 2. PASSAGE EN MODE SOMBRE
  // ==========================================================================

  testWidgets('ThemeProvider passe réellement en mode sombre', (tester) async {
    await tester.pumpWidget(buildTestApp());

    await tester.pump();

    final container = ProviderScope.containerOf(
      tester.element(find.byType(_ThemeTestApp)),
    );

    final notifier = container.read(themeProvider.notifier);

    await notifier.setDarkTheme();

    await tester.pump();

    final state = container.read(themeProvider);

    expect(state.mode, AppThemeMode.dark);

    expect(state.isDark, isTrue);

    expect(state.isSystem, isFalse);

    expect(state.isLight, isFalse);

    expect(container.read(materialThemeModeProvider), ThemeMode.dark);

    expect(prefs.getInt(ThemeNotifier.themeKey), AppThemeMode.dark.index);
  });

  // ==========================================================================
  // 3. PASSAGE EN MODE CLAIR
  // ==========================================================================

  testWidgets('ThemeProvider passe réellement en mode clair', (tester) async {
    await tester.pumpWidget(buildTestApp());

    await tester.pump();

    final container = ProviderScope.containerOf(
      tester.element(find.byType(_ThemeTestApp)),
    );

    final notifier = container.read(themeProvider.notifier);

    await notifier.setLightTheme();

    await tester.pump();

    final state = container.read(themeProvider);

    expect(state.mode, AppThemeMode.light);

    expect(state.isLight, isTrue);

    expect(state.isDark, isFalse);

    expect(state.isSystem, isFalse);

    expect(container.read(materialThemeModeProvider), ThemeMode.light);

    expect(prefs.getInt(ThemeNotifier.themeKey), AppThemeMode.light.index);
  });

  // ==========================================================================
  // 4. DARK → LIGHT
  // ==========================================================================

  testWidgets('ThemeProvider permet de passer de DARK à LIGHT', (tester) async {
    await tester.pumpWidget(buildTestApp());

    await tester.pump();

    final container = ProviderScope.containerOf(
      tester.element(find.byType(_ThemeTestApp)),
    );

    final notifier = container.read(themeProvider.notifier);

    await notifier.setDarkTheme();
    await tester.pump();

    expect(container.read(themeProvider).mode, AppThemeMode.dark);

    await notifier.setLightTheme();
    await tester.pump();

    expect(container.read(themeProvider).mode, AppThemeMode.light);

    expect(container.read(materialThemeModeProvider), ThemeMode.light);
  });

  // ==========================================================================
  // 5. LIGHT → DARK
  // ==========================================================================

  testWidgets('ThemeProvider permet de passer de LIGHT à DARK', (tester) async {
    await tester.pumpWidget(buildTestApp());

    await tester.pump();

    final container = ProviderScope.containerOf(
      tester.element(find.byType(_ThemeTestApp)),
    );

    final notifier = container.read(themeProvider.notifier);

    await notifier.setLightTheme();
    await tester.pump();

    expect(container.read(themeProvider).mode, AppThemeMode.light);

    await notifier.setDarkTheme();
    await tester.pump();

    expect(container.read(themeProvider).mode, AppThemeMode.dark);

    expect(container.read(materialThemeModeProvider), ThemeMode.dark);
  });

  // ==========================================================================
  // 6. TOGGLE DARK / LIGHT
  // ==========================================================================

  testWidgets('toggleDarkLight bascule correctement DARK et LIGHT', (
    tester,
  ) async {
    await tester.pumpWidget(buildTestApp());

    await tester.pump();

    final container = ProviderScope.containerOf(
      tester.element(find.byType(_ThemeTestApp)),
    );

    final notifier = container.read(themeProvider.notifier);

    // ----------------------------------------------------------------------
    // Départ LIGHT
    // ----------------------------------------------------------------------

    await notifier.setLightTheme();
    await tester.pump();

    expect(container.read(themeProvider).mode, AppThemeMode.light);

    // ----------------------------------------------------------------------
    // LIGHT → DARK
    // ----------------------------------------------------------------------

    await notifier.toggleDarkLight();
    await tester.pump();

    expect(container.read(themeProvider).mode, AppThemeMode.dark);

    // ----------------------------------------------------------------------
    // DARK → LIGHT
    // ----------------------------------------------------------------------

    await notifier.toggleDarkLight();
    await tester.pump();

    expect(container.read(themeProvider).mode, AppThemeMode.light);
  });

  // ==========================================================================
  // 7. RESET → SYSTEM
  // ==========================================================================

  testWidgets('reset remet réellement le thème en mode système', (
    tester,
  ) async {
    await tester.pumpWidget(buildTestApp());

    await tester.pump();

    final container = ProviderScope.containerOf(
      tester.element(find.byType(_ThemeTestApp)),
    );

    final notifier = container.read(themeProvider.notifier);

    await notifier.setDarkTheme();
    await tester.pump();

    expect(container.read(themeProvider).mode, AppThemeMode.dark);

    await notifier.reset();
    await tester.pump();

    final state = container.read(themeProvider);

    expect(state.mode, AppThemeMode.system);

    expect(state.isSystem, isTrue);

    expect(container.read(materialThemeModeProvider), ThemeMode.system);

    expect(prefs.getInt(ThemeNotifier.themeKey), AppThemeMode.system.index);
  });

  // ==========================================================================
  // 8. RESTAURATION RÉELLE DEPUIS SHARED PREFERENCES
  // ==========================================================================

  testWidgets('ThemeProvider restaure réellement le thème sauvegardé', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({
      ThemeNotifier.themeKey: AppThemeMode.dark.index,
    });

    final savedPrefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [sharedPreferencesProvider.overrideWithValue(savedPrefs)],
        child: const _ThemeTestApp(),
      ),
    );

    // _loadTheme() est asynchrone.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    final container = ProviderScope.containerOf(
      tester.element(find.byType(_ThemeTestApp)),
    );

    final state = container.read(themeProvider);

    expect(state.mode, AppThemeMode.dark);

    expect(state.isDark, isTrue);

    expect(container.read(materialThemeModeProvider), ThemeMode.dark);
  });

  // ==========================================================================
  // 9. VRAIE RECONSTRUCTION DE MaterialApp
  // ==========================================================================

  testWidgets('MaterialApp reconstruit réellement son ThemeMode', (
    tester,
  ) async {
    await tester.pumpWidget(buildTestApp());

    await tester.pump();

    // ----------------------------------------------------------------------
    // SYSTEM
    // ----------------------------------------------------------------------

    expect(find.text('SYSTEM'), findsOneWidget);

    // ----------------------------------------------------------------------
    // DARK
    // ----------------------------------------------------------------------

    final container = ProviderScope.containerOf(
      tester.element(find.byType(_ThemeTestApp)),
    );

    await container.read(themeProvider.notifier).setDarkTheme();

    await tester.pump();

    expect(find.text('DARK'), findsOneWidget);

    final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));

    expect(materialApp.themeMode, ThemeMode.dark);

    // ----------------------------------------------------------------------
    // LIGHT
    // ----------------------------------------------------------------------

    await container.read(themeProvider.notifier).setLightTheme();

    await tester.pump();

    expect(find.text('LIGHT'), findsOneWidget);

    final updatedMaterialApp = tester.widget<MaterialApp>(
      find.byType(MaterialApp),
    );

    expect(updatedMaterialApp.themeMode, ThemeMode.light);
  });
}

// ============================================================================
// APPLICATION DE TEST
// ============================================================================

class _ThemeTestApp extends ConsumerWidget {
  const _ThemeTestApp();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(materialThemeModeProvider);

    final state = ref.watch(themeProvider);

    String label;

    switch (state.mode) {
      case AppThemeMode.system:
        label = 'SYSTEM';
        break;

      case AppThemeMode.dark:
        label = 'DARK';
        break;

      case AppThemeMode.light:
        label = 'LIGHT';
        break;
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,

      themeMode: themeMode,

      theme: ThemeData(brightness: Brightness.light),

      darkTheme: ThemeData(brightness: Brightness.dark),

      home: Scaffold(
        body: Center(child: Text(label, key: const ValueKey('theme-label'))),
      ),
    );
  }
}
