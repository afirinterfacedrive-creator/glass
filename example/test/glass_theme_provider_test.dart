import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:glass/glass.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('GlassThemeProvider', () {
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

    test('default style is Aqua', () {
      final state = container.read(glassThemeProvider);

      expect(state.useAquaStyle, isTrue);
    });

    test('default style is transparent Aqua', () {
      final state = container.read(glassThemeProvider);

      expect(state.style, GlassStyle.transparentAqua);
    });

    test('default effects are liquid white', () {
      final state = container.read(glassThemeProvider);

      expect(state.effects, GlassEffects.liquidWhite);
    });

    test('Aqua app bar background is correct', () {
      final state = container.read(glassThemeProvider);

      expect(state.appBarBackgroundColor, const Color(0xE610242A));
    });

    test('Aqua app bar icon color is cyan', () {
      final state = container.read(glassThemeProvider);

      expect(state.appBarIconColor, Colors.cyanAccent);
    });

    test('setAquaStyle disables Aqua style', () async {
      final notifier = container.read(glassThemeProvider.notifier);

      await notifier.setAquaStyle(false);

      final state = container.read(glassThemeProvider);

      expect(state.useAquaStyle, isFalse);

      expect(state.style, GlassStyle.opaqueMat);

      expect(state.effects, GlassEffects.liquidDark);
    });

    test('setAquaStyle persists value', () async {
      final notifier = container.read(glassThemeProvider.notifier);

      await notifier.setAquaStyle(false);

      expect(prefs.getBool('glass_use_aqua_style'), isFalse);
    });

    test('setAquaStyle does nothing when value is unchanged', () async {
      final notifier = container.read(glassThemeProvider.notifier);

      await notifier.setAquaStyle(true);

      expect(container.read(glassThemeProvider).useAquaStyle, isTrue);
    });

    test('toggleAquaStyle switches the style', () async {
      final notifier = container.read(glassThemeProvider.notifier);

      expect(container.read(glassThemeProvider).useAquaStyle, isTrue);

      await notifier.toggleAquaStyle();

      expect(container.read(glassThemeProvider).useAquaStyle, isFalse);

      await notifier.toggleAquaStyle();

      expect(container.read(glassThemeProvider).useAquaStyle, isTrue);
    });

    test('theme is restored from SharedPreferences', () async {
      await prefs.setBool('glass_use_aqua_style', false);

      container.dispose();

      container = ProviderContainer(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      );

      final state = container.read(glassThemeProvider);

      expect(state.useAquaStyle, isFalse);

      expect(state.style, GlassStyle.opaqueMat);
    });

    test('reset restores Aqua style', () async {
      final notifier = container.read(glassThemeProvider.notifier);

      await notifier.setAquaStyle(false);

      expect(container.read(glassThemeProvider).useAquaStyle, isFalse);

      await notifier.reset();

      expect(container.read(glassThemeProvider).useAquaStyle, isTrue);

      expect(prefs.getBool('glass_use_aqua_style'), isTrue);
    });

    test('dark app bar values are correct', () async {
      final notifier = container.read(glassThemeProvider.notifier);

      await notifier.setAquaStyle(false);

      final state = container.read(glassThemeProvider);

      expect(state.appBarBackgroundColor, const Color(0xE6171717));

      expect(state.appBarIconColor, Colors.white);
    });
  });

  group('GlassThemeState', () {
    test('copyWith changes Aqua state', () {
      const original = GlassThemeState(useAquaStyle: true);

      final result = original.copyWith(useAquaStyle: false);

      expect(result.useAquaStyle, isFalse);
    });

    test('copyWith preserves existing value', () {
      const original = GlassThemeState(useAquaStyle: true);

      final result = original.copyWith();

      expect(result.useAquaStyle, isTrue);
    });
  });
}
