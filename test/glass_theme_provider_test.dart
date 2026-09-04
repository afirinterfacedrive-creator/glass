import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:universal_glass/enums/glass_enums.dart';
import 'package:universal_glass/provider/glass_theme_provider.dart';
import 'package:universal_glass/providers/shared_preferences_provider.dart';

/// ============================================================================
/// GLASS THEME PROVIDER TESTS
/// ============================================================================
///
/// Vérifie uniquement la gestion du STYLE global Universal Glass.
///
/// RESPONSABILITÉS TESTÉES
///
/// • style Aqua par défaut
/// • GlassStyle correspondant
/// • changement Aqua / Classic
/// • persistance SharedPreferences
/// • restauration du style
/// • toggle
/// • reset
/// • copyWith
///
/// IMPORTANT
///
/// Les couleurs et effets ne sont volontairement PAS testés ici.
///
/// Ils appartiennent maintenant à :
///
///     GlassColorPalette
///     GlassColorProvider
///     glassColorProvider
///
/// ============================================================================

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // ==========================================================================
  // GLASS THEME PROVIDER
  // ==========================================================================

  group(
    'GlassThemeProvider',
    () {
      late SharedPreferences prefs;
      late ProviderContainer container;

      // ======================================================================
      // SETUP
      // ======================================================================

      setUp(
        () async {
          SharedPreferences.setMockInitialValues({});

          prefs =
              await SharedPreferences.getInstance();

          container =
              ProviderContainer(
            overrides: [
              sharedPreferencesProvider
                  .overrideWithValue(
                prefs,
              ),
            ],
          );
        },
      );

      // ======================================================================
      // TEARDOWN
      // ======================================================================

      tearDown(
        () {
          container.dispose();
        },
      );

      // ======================================================================
      // 1. STYLE PAR DÉFAUT
      // ======================================================================

      test(
        'default style is Aqua',
        () {
          final GlassThemeState state =
              container.read(
            glassThemeProvider,
          );

          expect(
            state.useAquaStyle,
            isTrue,
          );
        },
      );

      // ======================================================================
      // 2. GLASS STYLE PAR DÉFAUT
      // ======================================================================

      test(
        'default GlassStyle is transparent Aqua',
        () {
          final GlassThemeState state =
              container.read(
            glassThemeProvider,
          );

          expect(
            state.style,
            GlassStyle.transparentAqua,
          );
        },
      );

      // ======================================================================
      // 3. SET CLASSIC
      // ======================================================================

      test(
        'setAquaStyle(false) activates Classic',
        () async {
          final GlassThemeNotifier notifier =
              container.read(
            glassThemeProvider.notifier,
          );

          await notifier.setAquaStyle(
            false,
          );

          final GlassThemeState state =
              container.read(
            glassThemeProvider,
          );

          expect(
            state.useAquaStyle,
            isFalse,
          );

          expect(
            state.style,
            GlassStyle.opaqueMat,
          );
        },
      );

      // ======================================================================
      // 4. SET AQUA
      // ======================================================================

      test(
        'setAquaStyle(true) activates Aqua',
        () async {
          final GlassThemeNotifier notifier =
              container.read(
            glassThemeProvider.notifier,
          );

          await notifier.setAquaStyle(
            false,
          );

          await notifier.setAquaStyle(
            true,
          );

          final GlassThemeState state =
              container.read(
            glassThemeProvider,
          );

          expect(
            state.useAquaStyle,
            isTrue,
          );

          expect(
            state.style,
            GlassStyle.transparentAqua,
          );
        },
      );

      // ======================================================================
      // 5. PERSISTANCE
      // ======================================================================

      test(
        'setAquaStyle persists value',
        () async {
          final GlassThemeNotifier notifier =
              container.read(
            glassThemeProvider.notifier,
          );

          await notifier.setAquaStyle(
            false,
          );

          expect(
            prefs.getBool(
              'glass_use_aqua_style',
            ),
            isFalse,
          );
        },
      );

      // ======================================================================
      // 6. PERSISTANCE AQUA
      // ======================================================================

      test(
        'setAquaStyle(true) persists Aqua',
        () async {
          final GlassThemeNotifier notifier =
              container.read(
            glassThemeProvider.notifier,
          );

          await notifier.setAquaStyle(
            true,
          );

          expect(
            prefs.getBool(
              'glass_use_aqua_style',
            ),
            isTrue,
          );
        },
      );

      // ======================================================================
      // 7. PAS DE CHANGEMENT
      // ======================================================================

      test(
        'setAquaStyle does nothing when value is unchanged',
        () async {
          final GlassThemeNotifier notifier =
              container.read(
            glassThemeProvider.notifier,
          );

          expect(
            container
                .read(
                  glassThemeProvider,
                )
                .useAquaStyle,
            isTrue,
          );

          await notifier.setAquaStyle(
            true,
          );

          expect(
            container
                .read(
                  glassThemeProvider,
                )
                .useAquaStyle,
            isTrue,
          );
        },
      );

      // ======================================================================
      // 8. TOGGLE
      // ======================================================================

      test(
        'toggleAquaStyle switches the style',
        () async {
          final GlassThemeNotifier notifier =
              container.read(
            glassThemeProvider.notifier,
          );

          expect(
            container
                .read(
                  glassThemeProvider,
                )
                .useAquaStyle,
            isTrue,
          );

          await notifier.toggleAquaStyle();

          expect(
            container
                .read(
                  glassThemeProvider,
                )
                .useAquaStyle,
            isFalse,
          );

          expect(
            container
                .read(
                  glassThemeProvider,
                )
                .style,
            GlassStyle.opaqueMat,
          );

          await notifier.toggleAquaStyle();

          expect(
            container
                .read(
                  glassThemeProvider,
                )
                .useAquaStyle,
            isTrue,
          );

          expect(
            container
                .read(
                  glassThemeProvider,
                )
                .style,
            GlassStyle.transparentAqua,
          );
        },
      );

      // ======================================================================
      // 9. TOGGLE PERSISTANCE
      // ======================================================================

      test(
        'toggleAquaStyle persists the new value',
        () async {
          final GlassThemeNotifier notifier =
              container.read(
            glassThemeProvider.notifier,
          );

          await notifier.toggleAquaStyle();

          expect(
            prefs.getBool(
              'glass_use_aqua_style',
            ),
            isFalse,
          );

          await notifier.toggleAquaStyle();

          expect(
            prefs.getBool(
              'glass_use_aqua_style',
            ),
            isTrue,
          );
        },
      );

      // ======================================================================
      // 10. RESTAURATION DEPUIS SHARED PREFERENCES
      // ======================================================================

      test(
        'theme is restored from SharedPreferences',
        () async {
          await prefs.setBool(
            'glass_use_aqua_style',
            false,
          );

          container.dispose();

          container =
              ProviderContainer(
            overrides: [
              sharedPreferencesProvider
                  .overrideWithValue(
                prefs,
              ),
            ],
          );

          final GlassThemeState state =
              container.read(
            glassThemeProvider,
          );

          expect(
            state.useAquaStyle,
            isFalse,
          );

          expect(
            state.style,
            GlassStyle.opaqueMat,
          );
        },
      );

      // ======================================================================
      // 11. RESTAURATION AQUA
      // ======================================================================

      test(
        'saved Aqua style is restored',
        () async {
          await prefs.setBool(
            'glass_use_aqua_style',
            true,
          );

          container.dispose();

          container =
              ProviderContainer(
            overrides: [
              sharedPreferencesProvider
                  .overrideWithValue(
                prefs,
              ),
            ],
          );

          final GlassThemeState state =
              container.read(
            glassThemeProvider,
          );

          expect(
            state.useAquaStyle,
            isTrue,
          );

          expect(
            state.style,
            GlassStyle.transparentAqua,
          );
        },
      );

      // ======================================================================
      // 12. ABSENCE DE VALEUR SAUVEGARDÉE
      // ======================================================================

      test(
        'missing saved value defaults to Aqua',
        () {
          final GlassThemeState state =
              container.read(
            glassThemeProvider,
          );

          expect(
            state.useAquaStyle,
            isTrue,
          );

          expect(
            state.style,
            GlassStyle.transparentAqua,
          );
        },
      );

      // ======================================================================
      // 13. RESET
      // ======================================================================

      test(
        'reset restores Aqua style',
        () async {
          final GlassThemeNotifier notifier =
              container.read(
            glassThemeProvider.notifier,
          );

          await notifier.setAquaStyle(
            false,
          );

          expect(
            container
                .read(
                  glassThemeProvider,
                )
                .useAquaStyle,
            isFalse,
          );

          await notifier.reset();

          final GlassThemeState state =
              container.read(
            glassThemeProvider,
          );

          expect(
            state.useAquaStyle,
            isTrue,
          );

          expect(
            state.style,
            GlassStyle.transparentAqua,
          );

          expect(
            prefs.getBool(
              'glass_use_aqua_style',
            ),
            isTrue,
          );
        },
      );

      // ======================================================================
      // 14. RESET DEPUIS AQUA
      // ======================================================================

      test(
        'reset keeps Aqua when already in Aqua',
        () async {
          final GlassThemeNotifier notifier =
              container.read(
            glassThemeProvider.notifier,
          );

          expect(
            container
                .read(
                  glassThemeProvider,
                )
                .useAquaStyle,
            isTrue,
          );

          await notifier.reset();

          expect(
            container
                .read(
                  glassThemeProvider,
                )
                .useAquaStyle,
            isTrue,
          );

          expect(
            prefs.getBool(
              'glass_use_aqua_style',
            ),
            isTrue,
          );
        },
      );
    },
  );

  // ==========================================================================
  // GLASS THEME STATE
  // ==========================================================================

  group(
    'GlassThemeState',
    () {
      // ========================================================================
      // 15. CONSTRUCTEUR PAR DÉFAUT
      // ========================================================================

      test(
        'default constructor uses Aqua',
        () {
          const GlassThemeState state =
              GlassThemeState();

          expect(
            state.useAquaStyle,
            isTrue,
          );

          expect(
            state.style,
            GlassStyle.transparentAqua,
          );
        },
      );

      // ========================================================================
      // 16. CONSTRUCTEUR CLASSIC
      // ========================================================================

      test(
        'constructor can create Classic state',
        () {
          const GlassThemeState state =
              GlassThemeState(
            useAquaStyle: false,
          );

          expect(
            state.useAquaStyle,
            isFalse,
          );

          expect(
            state.style,
            GlassStyle.opaqueMat,
          );
        },
      );

      // ========================================================================
      // 17. COPY WITH
      // ========================================================================

      test(
        'copyWith changes Aqua state',
        () {
          const GlassThemeState original =
              GlassThemeState(
            useAquaStyle: true,
          );

          final GlassThemeState result =
              original.copyWith(
            useAquaStyle: false,
          );

          expect(
            result.useAquaStyle,
            isFalse,
          );

          expect(
            result.style,
            GlassStyle.opaqueMat,
          );
        },
      );

      // ========================================================================
      // 18. COPY WITH SANS MODIFICATION
      // ========================================================================

      test(
        'copyWith preserves existing value',
        () {
          const GlassThemeState original =
              GlassThemeState(
            useAquaStyle: true,
          );

          final GlassThemeState result =
              original.copyWith();

          expect(
            result.useAquaStyle,
            isTrue,
          );

          expect(
            result.style,
            GlassStyle.transparentAqua,
          );
        },
      );

      // ========================================================================
      // 19. COPY WITH CLASSIC
      // ========================================================================

      test(
        'copyWith preserves Classic when no value is provided',
        () {
          const GlassThemeState original =
              GlassThemeState(
            useAquaStyle: false,
          );

          final GlassThemeState result =
              original.copyWith();

          expect(
            result.useAquaStyle,
            isFalse,
          );

          expect(
            result.style,
            GlassStyle.opaqueMat,
          );
        },
      );
    },
  );
}