import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:glass/providers/theme_provider.dart';
import 'package:glass/providers/shared_preferences_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ThemeProvider', () {
    late SharedPreferences prefs;
    late ProviderContainer container;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});

      prefs = await SharedPreferences.getInstance();

      container = ProviderContainer(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('default theme is system', () {
      final state = container.read(themeProvider);

      expect(state.mode, AppThemeMode.system);
    });

    test('system mode converts to ThemeMode.system', () {
      const state = ThemeState(AppThemeMode.system);

      expect(state.materialThemeMode, ThemeMode.system);
    });

    test('dark mode converts to ThemeMode.dark', () {
      const state = ThemeState(AppThemeMode.dark);

      expect(state.materialThemeMode, ThemeMode.dark);
    });

    test('light mode converts to ThemeMode.light', () {
      const state = ThemeState(AppThemeMode.light);

      expect(state.materialThemeMode, ThemeMode.light);
    });

    test('system helper is correct', () {
      const state = ThemeState(AppThemeMode.system);

      expect(state.isSystem, isTrue);
      expect(state.isDark, isFalse);
      expect(state.isLight, isFalse);
    });

    test('dark helper is correct', () {
      const state = ThemeState(AppThemeMode.dark);

      expect(state.isSystem, isFalse);
      expect(state.isDark, isTrue);
      expect(state.isLight, isFalse);
    });

    test('light helper is correct', () {
      const state = ThemeState(AppThemeMode.light);

      expect(state.isSystem, isFalse);
      expect(state.isDark, isFalse);
      expect(state.isLight, isTrue);
    });

    test('setDarkTheme changes theme to dark', () async {
      final notifier = container.read(themeProvider.notifier);

      await notifier.setDarkTheme();

      final state = container.read(themeProvider);

      expect(state.mode, AppThemeMode.dark);

      expect(state.materialThemeMode, ThemeMode.dark);
    });

    test('setLightTheme changes theme to light', () async {
      final notifier = container.read(themeProvider.notifier);

      await notifier.setLightTheme();

      final state = container.read(themeProvider);

      expect(state.mode, AppThemeMode.light);

      expect(state.materialThemeMode, ThemeMode.light);
    });

    test('setSystemTheme changes theme to system', () async {
      final notifier = container.read(themeProvider.notifier);

      await notifier.setDarkTheme();
      await notifier.setSystemTheme();

      final state = container.read(themeProvider);

      expect(state.mode, AppThemeMode.system);
    });

    test('setTheme persists selected mode', () async {
      final notifier = container.read(themeProvider.notifier);

      await notifier.setTheme(AppThemeMode.dark);

      expect(prefs.getInt('app_theme_mode'), AppThemeMode.dark.index);
    });

    test('dark theme can be toggled to light', () async {
      final notifier = container.read(themeProvider.notifier);

      await notifier.setDarkTheme();

      expect(container.read(themeProvider).mode, AppThemeMode.dark);

      await notifier.toggleDarkLight();

      expect(container.read(themeProvider).mode, AppThemeMode.light);
    });

    test('light theme can be toggled to dark', () async {
      final notifier = container.read(themeProvider.notifier);

      await notifier.setLightTheme();

      expect(container.read(themeProvider).mode, AppThemeMode.light);

      await notifier.toggleDarkLight();

      expect(container.read(themeProvider).mode, AppThemeMode.dark);
    });

    test('toggleDarkLight from system switches to dark', () async {
      final notifier = container.read(themeProvider.notifier);

      await notifier.setSystemTheme();
      await notifier.toggleDarkLight();

      expect(container.read(themeProvider).mode, AppThemeMode.dark);
    });

    test('reset restores system theme', () async {
      final notifier = container.read(themeProvider.notifier);

      await notifier.setDarkTheme();

      expect(container.read(themeProvider).mode, AppThemeMode.dark);

      await notifier.reset();

      expect(container.read(themeProvider).mode, AppThemeMode.system);

      expect(prefs.getInt('app_theme_mode'), AppThemeMode.system.index);
    });

    test('saved dark theme is restored', () async {
      await prefs.setInt('app_theme_mode', AppThemeMode.dark.index);

      container.dispose();

      container = ProviderContainer(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      );

      // ThemeNotifier charge la préférence de façon asynchrone.
      await Future<void>.delayed(const Duration(milliseconds: 20));

      final state = container.read(themeProvider);

      expect(state.mode, AppThemeMode.dark);
    });

    test('saved light theme is restored', () async {
      await prefs.setInt('app_theme_mode', AppThemeMode.light.index);

      container.dispose();

      container = ProviderContainer(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      );

      await Future<void>.delayed(const Duration(milliseconds: 20));

      final state = container.read(themeProvider);

      expect(state.mode, AppThemeMode.light);
    });

    test('invalid saved theme index falls back to system', () async {
      await prefs.setInt('app_theme_mode', 999);

      container.dispose();

      container = ProviderContainer(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      );

      await Future<void>.delayed(const Duration(milliseconds: 20));

      final state = container.read(themeProvider);

      expect(state.mode, AppThemeMode.system);
    });

    test('materialThemeModeProvider returns current ThemeMode', () async {
      final notifier = container.read(themeProvider.notifier);

      await notifier.setDarkTheme();

      final materialMode = container.read(materialThemeModeProvider);

      expect(materialMode, ThemeMode.dark);

      await notifier.setLightTheme();

      expect(container.read(materialThemeModeProvider), ThemeMode.light);
    });
  });

  group('ThemeState', () {
    test('copyWith changes mode', () {
      const original = ThemeState(AppThemeMode.system);

      final result = original.copyWith(mode: AppThemeMode.dark);

      expect(result.mode, AppThemeMode.dark);
    });

    test('copyWith preserves mode', () {
      const original = ThemeState(AppThemeMode.dark);

      final result = original.copyWith();

      expect(result.mode, AppThemeMode.dark);
    });
  });
}
