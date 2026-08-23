import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:glass/provider/glass_button_provider.dart';
import 'package:glass/providers/shared_preferences_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('GlassButtonProvider', () {
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

    test('initial state is empty', () {
      final state = container.read(glassButtonProvider);

      expect(state, isEmpty);
    });

    test('initButton creates a button with default inactive state', () {
      final notifier = container.read(glassButtonProvider.notifier);

      notifier.initButton('wifi', false);

      final button = container.read(glassButtonProvider)['wifi'];

      expect(button, isNotNull);
      expect(button!.isActive, isFalse);
      expect(button.isLoading, isFalse);
      expect(button.customText, isNull);
    });

    test('initButton creates a button with default active state', () {
      final notifier = container.read(glassButtonProvider.notifier);

      notifier.initButton('wifi', true);

      final button = container.read(glassButtonProvider)['wifi'];

      expect(button, isNotNull);
      expect(button!.isActive, isTrue);
    });

    test('initButton restores saved state from SharedPreferences', () async {
      await prefs.setBool('glass_btn_wifi', true);

      final notifier = container.read(glassButtonProvider.notifier);

      notifier.initButton('wifi', false);

      final button = container.read(glassButtonProvider)['wifi'];

      expect(button, isNotNull);
      expect(button!.isActive, isTrue);
    });

    test('initButton does not overwrite an existing button', () {
      final notifier = container.read(glassButtonProvider.notifier);

      notifier.initButton('wifi', true);

      notifier.initButton('wifi', false);

      final button = container.read(glassButtonProvider)['wifi'];

      expect(button!.isActive, isTrue);
    });

    test('setActive changes active state', () {
      final notifier = container.read(glassButtonProvider.notifier);

      notifier.initButton('wifi', false);

      notifier.setActive('wifi', true);

      final button = container.read(glassButtonProvider)['wifi'];

      expect(button!.isActive, isTrue);
    });

    test('setActive persists state', () async {
      final notifier = container.read(glassButtonProvider.notifier);

      notifier.initButton('wifi', false);

      notifier.setActive('wifi', true);

      expect(prefs.getBool('glass_btn_wifi'), isTrue);
    });

    test('toggleActive toggles button state', () {
      final notifier = container.read(glassButtonProvider.notifier);

      notifier.initButton('wifi', false);

      notifier.toggleActive('wifi');

      expect(container.read(glassButtonProvider)['wifi']!.isActive, isTrue);

      notifier.toggleActive('wifi');

      expect(container.read(glassButtonProvider)['wifi']!.isActive, isFalse);
    });

    test('setLoading changes loading state', () {
      final notifier = container.read(glassButtonProvider.notifier);

      notifier.initButton('wifi', false);

      notifier.setLoading('wifi', true, customText: 'Connexion...');

      final button = container.read(glassButtonProvider)['wifi'];

      expect(button!.isLoading, isTrue);
      expect(button.customText, 'Connexion...');
    });

    test('setLoading can clear custom text', () {
      final notifier = container.read(glassButtonProvider.notifier);

      notifier.initButton('wifi', false);

      notifier.setCustomText('wifi', 'Connexion...');

      notifier.setLoading('wifi', false, clearCustomText: true);

      final button = container.read(glassButtonProvider)['wifi'];

      expect(button!.customText, isNull);
    });

    test('setCustomText changes custom text', () {
      final notifier = container.read(glassButtonProvider.notifier);

      notifier.initButton('wifi', false);

      notifier.setCustomText('wifi', 'Activé');

      final button = container.read(glassButtonProvider)['wifi'];

      expect(button!.customText, 'Activé');
    });

    test('clearCustomText removes custom text', () {
      final notifier = container.read(glassButtonProvider.notifier);

      notifier.initButton('wifi', false);

      notifier.setCustomText('wifi', 'Activé');

      notifier.clearCustomText('wifi');

      final button = container.read(glassButtonProvider)['wifi'];

      expect(button!.customText, isNull);
    });

    test('resetButton resets the complete button state', () {
      final notifier = container.read(glassButtonProvider.notifier);

      notifier.initButton('wifi', true);

      notifier.setLoading('wifi', true, customText: 'Connexion...');

      notifier.resetButton('wifi', active: false);

      final button = container.read(glassButtonProvider)['wifi'];

      expect(button!.isActive, isFalse);
      expect(button.isLoading, isFalse);
      expect(button.customText, isNull);
    });

    test('resetButton persists the new active state', () async {
      final notifier = container.read(glassButtonProvider.notifier);

      notifier.initButton('wifi', true);

      notifier.resetButton('wifi', active: false);

      expect(prefs.getBool('glass_btn_wifi'), isFalse);
    });

    test('operations on unknown button do nothing', () {
      final notifier = container.read(glassButtonProvider.notifier);

      notifier.setActive('unknown', true);
      notifier.toggleActive('unknown');

      notifier.setLoading('unknown', true);

      notifier.setCustomText('unknown', 'Test');

      notifier.clearCustomText('unknown');

      notifier.resetButton('unknown');

      expect(container.read(glassButtonProvider), isEmpty);
    });
  });

  group('GlassButtonState', () {
    test('copyWith preserves existing values', () {
      const original = GlassButtonState(
        isActive: true,
        isLoading: true,
        customText: 'Test',
      );

      final result = original.copyWith();

      expect(result.isActive, isTrue);
      expect(result.isLoading, isTrue);
      expect(result.customText, 'Test');
    });

    test('copyWith changes selected values', () {
      const original = GlassButtonState(
        isActive: false,
        isLoading: false,
        customText: 'Test',
      );

      final result = original.copyWith(
        isActive: true,
        isLoading: true,
        customText: 'Nouveau',
      );

      expect(result.isActive, isTrue);
      expect(result.isLoading, isTrue);
      expect(result.customText, 'Nouveau');
    });

    test('copyWith clearCustomText removes text', () {
      const original = GlassButtonState(customText: 'Test');

      final result = original.copyWith(clearCustomText: true);

      expect(result.customText, isNull);
    });
  });
}
