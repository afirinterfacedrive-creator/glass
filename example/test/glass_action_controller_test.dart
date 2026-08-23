import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:universal_glass/glass.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('GlassActionController', () {
    late SharedPreferences prefs;
    late ProviderContainer container;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});

      prefs = await SharedPreferences.getInstance();

      container = ProviderContainer(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      );

      container.read(glassButtonProvider.notifier).initButton('wifi', false);
    });

    tearDown(() {
      container.dispose();
    });

    test('run activates the button automatically', () async {
      await container
          .read(glassActionControllerProvider.notifier)
          .run(
            'wifi',
            actionDuration: Duration.zero,
            successDuration: Duration.zero,
          );

      final button = container.read(glassButtonProvider)['wifi'];

      expect(button, isNotNull);
      expect(button!.isActive, isFalse);
      expect(button.isLoading, isFalse);
      expect(button.customText, isNull);
    });

    test('run executes custom action', () async {
      bool executed = false;

      await container
          .read(glassActionControllerProvider.notifier)
          .run(
            'wifi',
            action: () async {
              executed = true;
            },
            successDuration: Duration.zero,
          );

      expect(executed, isTrue);
    });

    test('run displays success text before cleanup', () async {
      final future = container
          .read(glassActionControllerProvider.notifier)
          .run(
            'wifi',
            action: () async {},
            successDuration: const Duration(milliseconds: 100),
          );

      await Future<void>.delayed(const Duration(milliseconds: 20));

      final duringSuccess = container.read(glassButtonProvider)['wifi'];

      expect(duringSuccess, isNotNull);
      expect(duringSuccess!.customText, 'SUCCÈS!');

      await future;

      final finalState = container.read(glassButtonProvider)['wifi'];

      expect(finalState!.isLoading, isFalse);
      expect(finalState.customText, isNull);
    });

    test('run auto deactivates the button', () async {
      await container
          .read(glassActionControllerProvider.notifier)
          .run(
            'wifi',
            action: () async {},
            actionDuration: Duration.zero,
            successDuration: Duration.zero,
            autoActivate: true,
            autoDeactivate: true,
          );

      final button = container.read(glassButtonProvider)['wifi'];

      expect(button!.isActive, isFalse);
    });

    test('run can keep button active', () async {
      await container
          .read(glassActionControllerProvider.notifier)
          .run(
            'wifi',
            action: () async {},
            actionDuration: Duration.zero,
            successDuration: Duration.zero,
            autoActivate: true,
            autoDeactivate: false,
          );

      final button = container.read(glassButtonProvider)['wifi'];

      expect(button!.isActive, isTrue);
    });

    test('run can disable automatic activation', () async {
      final notifier = container.read(glassButtonProvider.notifier);

      notifier.setActive('wifi', false);

      await container
          .read(glassActionControllerProvider.notifier)
          .run(
            'wifi',
            action: () async {},
            actionDuration: Duration.zero,
            successDuration: Duration.zero,
            autoActivate: false,
            autoDeactivate: false,
          );

      final button = container.read(glassButtonProvider)['wifi'];

      expect(button!.isActive, isFalse);
    });

    test('run returns immediately for unknown button', () async {
      await container
          .read(glassActionControllerProvider.notifier)
          .run(
            'unknown',
            actionDuration: Duration.zero,
            successDuration: Duration.zero,
          );

      expect(container.read(glassButtonProvider), hasLength(1));
    });

    test('run handles action error', () async {
      final future = container
          .read(glassActionControllerProvider.notifier)
          .run(
            'wifi',
            action: () async {
              throw Exception('Erreur test');
            },
            successDuration: Duration.zero,
          );

      await expectLater(future, throwsA(isA<Exception>()));

      final controllerState = container.read(glassActionControllerProvider);

      expect(controllerState, isA<AsyncError>());
    });

    test('toggle changes button state', () {
      final controller = container.read(glassActionControllerProvider.notifier);

      controller.toggle('wifi');

      expect(container.read(glassButtonProvider)['wifi']!.isActive, isTrue);

      controller.toggle('wifi');

      expect(container.read(glassButtonProvider)['wifi']!.isActive, isFalse);
    });

    test('activate activates button', () {
      final controller = container.read(glassActionControllerProvider.notifier);

      controller.activate('wifi');

      expect(container.read(glassButtonProvider)['wifi']!.isActive, isTrue);
    });

    test('deactivate deactivates button', () {
      final notifier = container.read(glassButtonProvider.notifier);

      notifier.setActive('wifi', true);

      final controller = container.read(glassActionControllerProvider.notifier);

      controller.deactivate('wifi');

      expect(container.read(glassButtonProvider)['wifi']!.isActive, isFalse);
    });

    test('reset resets button', () {
      final notifier = container.read(glassButtonProvider.notifier);

      notifier.setActive('wifi', true);

      notifier.setLoading('wifi', true, customText: 'Test');

      final controller = container.read(glassActionControllerProvider.notifier);

      controller.reset('wifi', active: false);

      final button = container.read(glassButtonProvider)['wifi'];

      expect(button!.isActive, isFalse);
      expect(button.isLoading, isFalse);
      expect(button.customText, isNull);
    });
  });
}
