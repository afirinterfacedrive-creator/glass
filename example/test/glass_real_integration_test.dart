import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:universal_glass/glass.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Glass - vrai test API publique', () {
    late SharedPreferences prefs;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});

      prefs = await SharedPreferences.getInstance();
    });

    // =========================================================================
    // TEST 1 — API PUBLIQUE
    // =========================================================================

    test('Glass expose correctement ses providers publics', () {
      final container = ProviderContainer(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      );

      addTearDown(container.dispose);

      final buttonState = container.read(glassButtonProvider);

      expect(buttonState, isEmpty);

      final themeState = container.read(themeProvider);

      expect(themeState.mode, AppThemeMode.system);
    });

    // =========================================================================
    // TEST 2 — INITIALISATION D'UN BOUTON
    // =========================================================================

    test('GlassButton initialise correctement un bouton', () {
      final container = ProviderContainer(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      );

      addTearDown(container.dispose);

      final notifier = container.read(glassButtonProvider.notifier);

      notifier.initButton('wifi', false);

      final button = container.read(glassButtonProvider)['wifi'];

      expect(button, isNotNull);
      expect(button!.isActive, isFalse);
      expect(button.isLoading, isFalse);
      expect(button.customText, isNull);
    });

    // =========================================================================
    // TEST 3 — ACTIVATION
    // =========================================================================

    test('GlassButton peut être activé et désactivé', () {
      final container = ProviderContainer(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      );

      addTearDown(container.dispose);

      final notifier = container.read(glassButtonProvider.notifier);

      notifier.initButton('wifi', false);

      notifier.setActive('wifi', true);

      expect(container.read(glassButtonProvider)['wifi']!.isActive, isTrue);

      notifier.setActive('wifi', false);

      expect(container.read(glassButtonProvider)['wifi']!.isActive, isFalse);
    });

    // =========================================================================
    // TEST 4 — PERSISTANCE
    // =========================================================================

    test('GlassButton persiste son état avec SharedPreferences', () async {
      final container = ProviderContainer(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      );

      addTearDown(container.dispose);

      final notifier = container.read(glassButtonProvider.notifier);

      notifier.initButton('wifi', false);

      notifier.setActive('wifi', true);

      await Future<void>.delayed(Duration.zero);

      expect(prefs.getBool('glass_btn_wifi'), isTrue);
    });

    // =========================================================================
    // TEST 5 — TOGGLE
    // =========================================================================

    test('GlassButton toggle fonctionne correctement', () {
      final container = ProviderContainer(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      );

      addTearDown(container.dispose);

      final notifier = container.read(glassButtonProvider.notifier);

      notifier.initButton('wifi', false);

      expect(container.read(glassButtonProvider)['wifi']!.isActive, isFalse);

      notifier.toggleActive('wifi');

      expect(container.read(glassButtonProvider)['wifi']!.isActive, isTrue);

      notifier.toggleActive('wifi');

      expect(container.read(glassButtonProvider)['wifi']!.isActive, isFalse);
    });

    // =========================================================================
    // TEST 6 — LOADING
    // =========================================================================

    test('GlassButton gère correctement le loading', () {
      final container = ProviderContainer(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      );

      addTearDown(container.dispose);

      final notifier = container.read(glassButtonProvider.notifier);

      notifier.initButton('wifi', false);

      notifier.setLoading('wifi', true, customText: 'Connexion...');

      final button = container.read(glassButtonProvider)['wifi']!;

      expect(button.isLoading, isTrue);
      expect(button.customText, 'Connexion...');

      notifier.setLoading('wifi', false);

      final finalButton = container.read(glassButtonProvider)['wifi']!;

      expect(finalButton.isLoading, isFalse);
    });

    // =========================================================================
    // TEST 7 — TEXTE PERSONNALISÉ
    // =========================================================================

    test('GlassButton gère son texte personnalisé', () {
      final container = ProviderContainer(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      );

      addTearDown(container.dispose);

      final notifier = container.read(glassButtonProvider.notifier);

      notifier.initButton('wifi', false);

      notifier.setCustomText('wifi', 'Connecté');

      expect(
        container.read(glassButtonProvider)['wifi']!.customText,
        'Connecté',
      );

      notifier.clearCustomText('wifi');

      expect(container.read(glassButtonProvider)['wifi']!.customText, isNull);
    });

    // =========================================================================
    // TEST 8 — RESET
    // =========================================================================

    test('GlassButton reset remet correctement son état à zéro', () async {
      final container = ProviderContainer(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      );

      addTearDown(container.dispose);

      final notifier = container.read(glassButtonProvider.notifier);

      notifier.initButton('wifi', false);

      notifier.setActive('wifi', true);

      notifier.setLoading('wifi', true, customText: 'Test');

      notifier.resetButton('wifi');

      final button = container.read(glassButtonProvider)['wifi']!;

      expect(button.isActive, isFalse);
      expect(button.isLoading, isFalse);
      expect(button.customText, isNull);

      await Future<void>.delayed(Duration.zero);

      expect(prefs.getBool('glass_btn_wifi'), isFalse);
    });

    // =========================================================================
    // TEST 9 — THEME
    // =========================================================================

    test('ThemeProvider fonctionne avec SharedPreferences', () async {
      final container = ProviderContainer(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      );

      addTearDown(container.dispose);

      final initialTheme = container.read(themeProvider);

      expect(initialTheme.mode, AppThemeMode.system);

      await container.read(themeProvider.notifier).setDarkTheme();

      expect(container.read(themeProvider).mode, AppThemeMode.dark);

      expect(container.read(themeProvider).materialThemeMode, ThemeMode.dark);

      await container.read(themeProvider.notifier).setLightTheme();

      expect(container.read(themeProvider).mode, AppThemeMode.light);

      expect(container.read(themeProvider).materialThemeMode, ThemeMode.light);
    });

    // =========================================================================
    // TEST 10 — THEME PERSISTANCE
    // =========================================================================

    test('ThemeProvider persiste le thème sélectionné', () async {
      final container = ProviderContainer(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      );

      addTearDown(container.dispose);

      await container.read(themeProvider.notifier).setDarkTheme();

      expect(prefs.getInt('app_theme_mode'), AppThemeMode.dark.index);

      await container.read(themeProvider.notifier).setLightTheme();

      expect(prefs.getInt('app_theme_mode'), AppThemeMode.light.index);
    });

    // =========================================================================
    // TEST 11 — MATERIAL THEME MODE PROVIDER
    // =========================================================================

    test('materialThemeModeProvider suit themeProvider', () async {
      final container = ProviderContainer(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      );

      addTearDown(container.dispose);

      expect(container.read(materialThemeModeProvider), ThemeMode.system);

      await container.read(themeProvider.notifier).setDarkTheme();

      expect(container.read(materialThemeModeProvider), ThemeMode.dark);

      await container.read(themeProvider.notifier).setLightTheme();

      expect(container.read(materialThemeModeProvider), ThemeMode.light);
    });

    // =========================================================================
    // TEST 12 — SCÉNARIO COMPLET
    // =========================================================================

    test(
      'Glass scénario complet : init → activation → loading → succès → reset',
      () async {
        final container = ProviderContainer(
          overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
        );

        addTearDown(container.dispose);

        final notifier = container.read(glassButtonProvider.notifier);

        // ---------------------------------------------------------------------
        // 1. INITIALISATION
        // ---------------------------------------------------------------------

        notifier.initButton('wifi', false);

        expect(container.read(glassButtonProvider)['wifi']!.isActive, isFalse);

        // ---------------------------------------------------------------------
        // 2. ACTIVATION
        // ---------------------------------------------------------------------

        notifier.setActive('wifi', true);

        expect(container.read(glassButtonProvider)['wifi']!.isActive, isTrue);

        // ---------------------------------------------------------------------
        // 3. LOADING
        // ---------------------------------------------------------------------

        notifier.setLoading('wifi', true, customText: 'Connexion...');

        var button = container.read(glassButtonProvider)['wifi']!;

        expect(button.isLoading, isTrue);
        expect(button.customText, 'Connexion...');

        // ---------------------------------------------------------------------
        // 4. SUCCÈS
        // ---------------------------------------------------------------------

        notifier.setLoading('wifi', false, customText: 'SUCCÈS!');

        button = container.read(glassButtonProvider)['wifi']!;

        expect(button.isLoading, isFalse);
        expect(button.customText, 'SUCCÈS!');

        // ---------------------------------------------------------------------
        // 5. NETTOYAGE
        // ---------------------------------------------------------------------

        notifier.setLoading('wifi', false, clearCustomText: true);

        button = container.read(glassButtonProvider)['wifi']!;

        expect(button.isLoading, isFalse);
        expect(button.customText, isNull);

        // ---------------------------------------------------------------------
        // 6. RESET
        // ---------------------------------------------------------------------

        notifier.resetButton('wifi');

        button = container.read(glassButtonProvider)['wifi']!;

        expect(button.isActive, isFalse);
        expect(button.isLoading, isFalse);
        expect(button.customText, isNull);
      },
    );
  });
}
