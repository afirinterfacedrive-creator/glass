import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_glass/glass.dart';

import 'appearance_controller.dart';
import 'appearance_profiles.dart';
import 'appearance_profiles_codec.dart';
import 'appearance_settings.dart';

/// ============================================================================
/// APPEARANCE CONTROLLER PROVIDER
/// ============================================================================

final appearanceControllerProvider =
    Provider<AppearanceController>((Ref ref) {
  final SharedPreferences preferences =
      ref.watch(sharedPreferencesProvider);

  return AppearanceController(
    ref,
    preferences,
  );
});

/// ============================================================================
/// APPEARANCE PROFILES NOTIFIER
/// ============================================================================
///
/// Source réactive des quatre profils globaux :
///
/// - Aqua
/// - Classic
/// - Light
/// - Dark
///
/// La persistance et l'application visuelle restent entièrement gérées
/// par [AppearanceController].
///
/// Ce notifier ne contient donc aucune logique SharedPreferences.
///
class AppearanceProfilesNotifier
    extends Notifier<AppearanceProfiles> {
  late final AppearanceController _controller;

  // ==========================================================================
  // BUILD
  // ==========================================================================

  @override
  AppearanceProfiles build() {
    _controller = ref.read(
      appearanceControllerProvider,
    );

    return _controller.loadProfiles();
  }

  // ==========================================================================
  // ACTIVE MODE
  // ==========================================================================

  /// Mode global actuellement actif.
  AppThemeMode get activeMode {
    return _controller.activeMode;
  }

  /// Alias de compatibilité.
  AppThemeMode getActiveThemeMode() {
    return _controller.getActiveThemeMode();
  }

  // ==========================================================================
  // LOAD
  // ==========================================================================

  /// Recharge les quatre profils depuis le stockage.
  void refresh() {
    state = _controller.loadProfiles();
  }

  /// Recharge un profil précis.
  AppearanceSettings loadForMode(
    AppThemeMode mode,
  ) {
    return _controller.loadForMode(
      mode,
    );
  }

  /// Recharge le profil correspondant au mode actif.
  AppearanceSettings loadActive() {
    return _controller.load();
  }

  // ==========================================================================
  // PROFILE ACCESS
  // ==========================================================================

  /// Retourne le profil correspondant au mode demandé.
  ///
  /// [AppThemeMode.system] utilise le profil Aqua comme fallback.
  AppearanceSettings profileForMode(
    AppThemeMode mode,
  ) {
    return state.forMode(
      mode,
    );
  }

  /// Retourne le profil correspondant au mode actuellement actif.
  AppearanceSettings get activeProfile {
    return state.forMode(
      _controller.activeMode,
    );
  }

  // ==========================================================================
  // UPDATE PROFILE
  // ==========================================================================

  /// Modifie uniquement le profil [mode].
  ///
  /// Les trois autres profils restent inchangés.
  ///
  /// Si le profil modifié est actuellement actif, le controller applique
  /// immédiatement la nouvelle apparence.
  Future<AppearanceSettings> updateProfile(
    AppThemeMode mode,
    AppearanceSettings Function(
      AppearanceSettings settings,
    ) updater,
  ) async {
    if (mode == AppThemeMode.system) {
      return state.forMode(
        AppThemeMode.aqua,
      );
    }

    final AppearanceSettings updated =
        await _controller.updateProfile(
      mode,
      updater,
    );

    state = state.updateMode(
      mode,
      updated,
    );

    return updated;
  }

  // ==========================================================================
  // UPDATE ACTIVE PROFILE
  // ==========================================================================

  /// Modifie directement le profil actuellement actif.
  Future<AppearanceSettings> update(
    AppearanceSettings Function(
      AppearanceSettings settings,
    ) updater,
  ) async {
    final AppThemeMode mode =
        _controller.activeMode;

    if (mode == AppThemeMode.system) {
      return updateProfile(
        AppThemeMode.aqua,
        updater,
      );
    }

    return updateProfile(
      mode,
      updater,
    );
  }

  // ==========================================================================
  // CHANGE ACTIVE MODE
  // ==========================================================================

  /// Change le profil global actif.
  ///
  /// Important :
  ///
  /// Cette opération ne modifie aucun des quatre profils.
  /// Elle change uniquement le mode actif et applique son profil.
Future<AppearanceSettings> changeThemeMode(
  AppThemeMode mode,
) async {
  final AppearanceSettings settings =
      await _controller.changeThemeMode(
    mode,
  );

  state = _controller.loadProfiles();

  return settings;
}
  // ==========================================================================
  // GLASS STYLE
  // ==========================================================================

  /// Modifie le GlassStyle du profil actif.
  Future<AppearanceSettings> updateActiveGlassStyle(
    GlassStyle style,
  ) async {
    return update(
      (AppearanceSettings settings) {
        return settings.copyWith(
          glassStyle: style.name,
        );
      },
    );
  }

  /// Modifie le GlassStyle d'un profil précis.
  Future<AppearanceSettings> updateGlassStyle(
    AppThemeMode mode,
    GlassStyle style,
  ) async {
    return updateProfile(
      mode,
      (AppearanceSettings settings) {
        return settings.copyWith(
          glassStyle: style.name,
        );
      },
    );
  }

  /// Alias compatible avec l'ancienne API.
  Future<AppearanceSettings> changeGlassStyle(
    String glassStyle,
  ) async {
    return update(
      (AppearanceSettings settings) {
        return settings.copyWith(
          glassStyle: glassStyle,
        );
      },
    );
  }

  /// Alias compatible avec l'ancienne API.
  Future<AppearanceSettings> changeGlassStyleForMode(
    AppThemeMode mode,
    String glassStyle,
  ) async {
    return updateProfile(
      mode,
      (AppearanceSettings settings) {
        return settings.copyWith(
          glassStyle: glassStyle,
        );
      },
    );
  }

  // ==========================================================================
  // AQUA COLORS
  // ==========================================================================

  /// Remplace les couleurs Aqua du profil actif.
  Future<AppearanceSettings> setAquaColors(
    List<int> colors,
  ) async {
    return update(
      (AppearanceSettings settings) {
        return settings.copyWith(
          aquaColors: List<int>.from(
            colors,
          ),
        );
      },
    );
  }

  /// Remplace les couleurs Aqua d'un profil précis.
  Future<AppearanceSettings> setAquaColorsForMode(
    AppThemeMode mode,
    List<int> colors,
  ) async {
    return updateProfile(
      mode,
      (AppearanceSettings settings) {
        return settings.copyWith(
          aquaColors: List<int>.from(
            colors,
          ),
        );
      },
    );
  }

  /// Alias explicite.
  Future<AppearanceSettings> updateAquaColors(
    AppThemeMode mode,
    List<int> colors,
  ) async {
    return setAquaColorsForMode(
      mode,
      colors,
    );
  }

  // ==========================================================================
  // CLASSIC COLORS
  // ==========================================================================

  /// Remplace les couleurs Classic du profil actif.
  Future<AppearanceSettings> setClassicColors(
    List<int> colors,
  ) async {
    return update(
      (AppearanceSettings settings) {
        return settings.copyWith(
          classicColors: List<int>.from(
            colors,
          ),
        );
      },
    );
  }

  /// Remplace les couleurs Classic d'un profil précis.
  Future<AppearanceSettings> setClassicColorsForMode(
    AppThemeMode mode,
    List<int> colors,
  ) async {
    return updateProfile(
      mode,
      (AppearanceSettings settings) {
        return settings.copyWith(
          classicColors: List<int>.from(
            colors,
          ),
        );
      },
    );
  }

  /// Alias explicite.
  Future<AppearanceSettings> updateClassicColors(
    AppThemeMode mode,
    List<int> colors,
  ) async {
    return setClassicColorsForMode(
      mode,
      colors,
    );
  }

  // ==========================================================================
  // SINGLE COLOR
  // ==========================================================================

  /// Modifie une couleur Aqua ou Classic du profil actif.
  Future<AppearanceSettings> setColor({
    required bool aqua,
    required int index,
    required int color,
  }) async {
    return update(
      (AppearanceSettings settings) {
        return _updateColor(
          settings,
          aqua: aqua,
          index: index,
          color: color,
        );
      },
    );
  }

  /// Modifie une couleur Aqua ou Classic d'un profil précis.
  Future<AppearanceSettings> setColorForMode({
    required AppThemeMode mode,
    required bool aqua,
    required int index,
    required int color,
  }) async {
    return updateProfile(
      mode,
      (AppearanceSettings settings) {
        return _updateColor(
          settings,
          aqua: aqua,
          index: index,
          color: color,
        );
      },
    );
  }

  // ==========================================================================
  // IMPORT
  // ==========================================================================

  /// Importe les quatre profils depuis un fichier JSON.
  ///
  /// Retourne `null` lorsque l'utilisateur annule l'import.
  Future<AppearanceProfilesDocument?> importProfiles() async {
  final AppearanceProfilesDocument? imported =
      await _controller.importProfiles();

  if (imported == null) {
    return null;
  }

  state = imported.profiles;

  return imported;
}

Future<String?> exportProfiles({
  String? fileName,
  bool pretty = true,
}) {
  return _controller.exportProfiles(
    fileName: fileName,
    pretty: pretty,
  );
}
  // ==========================================================================
  // RESET
  // ==========================================================================

  /// Réinitialise les quatre profils avec leurs valeurs par défaut.
  ///
  /// Le mode actif est conservé par le controller.
  Future<void> resetProfiles() async {
    final AppearanceProfiles profiles =
        await _controller.resetProfiles();

    state = profiles;
  }

  /// Alias de compatibilité.
  Future<void> reset() async {
    await resetProfiles();
  }

  // ==========================================================================
  // PRIVATE COLOR HELPER
  // ==========================================================================

  AppearanceSettings _updateColor(
    AppearanceSettings settings, {
    required bool aqua,
    required int index,
    required int color,
  }) {
    if (aqua) {
      final List<int> colors =
          List<int>.from(
        settings.aquaColors,
      );

      if (index >= 0 && index < colors.length) {
        colors[index] = color;
      }

      return settings.copyWith(
        aquaColors: colors,
      );
    }

    final List<int> colors =
        List<int>.from(
      settings.classicColors,
    );

    if (index >= 0 && index < colors.length) {
      colors[index] = color;
    }

    return settings.copyWith(
      classicColors: colors,
    );
  }
}

/// ============================================================================
/// APPEARANCE PROFILES PROVIDER
/// ============================================================================

final appearanceProfilesProvider =
    NotifierProvider<
      AppearanceProfilesNotifier,
      AppearanceProfiles
    >(
      AppearanceProfilesNotifier.new,
    );

/// ============================================================================
/// SINGLE PROFILE PROVIDER
/// ============================================================================
///
/// Permet d'observer uniquement le profil demandé.
final appearanceProfileProvider =
    Provider.family<
      AppearanceSettings,
      AppThemeMode
    >(
      (
        Ref ref,
        AppThemeMode mode,
      ) {
        final AppearanceProfiles profiles =
            ref.watch(
          appearanceProfilesProvider,
        );

        return profiles.forMode(
          mode,
        );
      },
    );

/// ============================================================================
/// ACTIVE PROFILE PROVIDER
/// ============================================================================
///
/// Fournit le profil correspondant au mode global actuellement actif.
///
/// Le mode actif est stocké séparément des quatre profils.
final activeAppearanceProfileProvider =
    Provider<AppearanceSettings>(
      (Ref ref) {
        final AppearanceProfiles profiles =
            ref.watch(
          appearanceProfilesProvider,
        );

        final AppearanceController controller =
            ref.read(
          appearanceControllerProvider,
        );

        return profiles.forMode(
          controller.activeMode,
        );
      },
    );