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
///
/// Fournit l'instance centrale de [AppearanceController].
///
/// Le controller reste responsable :
///
/// - du chargement ;
/// - de la sauvegarde ;
/// - de la migration ;
/// - de l'application au GlassThemeProvider ;
/// - de la modification des profils.
///
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
/// Source de vérité Riverpod des profils d'apparence.
///
/// Profils disponibles :
///
/// - Aqua
/// - Classic
/// - Light
/// - Dark
///
/// [AppThemeMode.system] n'est pas un profil personnalisable.
///
class AppearanceProfilesNotifier
    extends Notifier<AppearanceProfiles> {
  late final AppearanceController _controller;

  @override
  AppearanceProfiles build() {
    _controller = ref.read(
      appearanceControllerProvider,
    );

    return _controller.loadProfiles();
  }

  /// --------------------------------------------------------------------------
  /// UPDATE PROFILE
  /// --------------------------------------------------------------------------

  /// Modifie un profil précis puis synchronise immédiatement
  /// l'état Riverpod avec la valeur persistée.
  Future<AppearanceSettings> updateProfile(
    AppThemeMode mode,
    AppearanceSettings Function(
      AppearanceSettings settings,
    ) updater,
  ) async {
    // System n'est pas un profil personnalisable.
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

  /// --------------------------------------------------------------------------
  /// REFRESH
  /// --------------------------------------------------------------------------

  /// Recharge les profils depuis le stockage.
  void refresh() {
    state = _controller.loadProfiles();
  }

  /// --------------------------------------------------------------------------
  /// IMPORT
  /// --------------------------------------------------------------------------

  /// Importe les quatre profils depuis un fichier JSON.
  ///
  /// Retourne `null` lorsque l'utilisateur annule la sélection du fichier.
  ///
  /// Le controller reste responsable de la logique d'import et de persistance.
  Future<AppearanceProfilesDocument?> importProfiles() async {
    final AppearanceProfilesDocument? imported =
        await _controller.importProfiles();

    if (imported == null) {
      return null;
    }

    // Synchronise immédiatement Riverpod avec les profils importés.
    state = imported.profiles;

    return imported;
  }

  /// --------------------------------------------------------------------------
  /// EXPORT
  /// --------------------------------------------------------------------------

  /// Exporte les quatre profils actuels vers un fichier JSON.
  ///
  /// Le controller reste responsable de la génération et de l'export
  /// multiplateforme.
  Future<String?> exportProfiles({
    String? fileName,
    bool pretty = true,
  }) {
    return _controller.exportProfiles(
      fileName: fileName,
      pretty: pretty,
    );
  }

  /// --------------------------------------------------------------------------
  /// RESET
  /// --------------------------------------------------------------------------

  /// Réinitialise les quatre profils à leurs valeurs par défaut,
  /// puis synchronise l'état Riverpod.
  Future<void> resetProfiles() async {
    final AppearanceProfiles profiles =
        await _controller.resetProfiles();

    state = profiles;
  }
}

/// ============================================================================
/// APPEARANCE PROFILES PROVIDER
/// ============================================================================
///
/// Source globale des quatre profils personnalisables.
final appearanceProfilesProvider =
    NotifierProvider<
        AppearanceProfilesNotifier,
        AppearanceProfiles>(
  AppearanceProfilesNotifier.new,
);

/// ============================================================================
/// SINGLE APPEARANCE PROFILE PROVIDER
/// ============================================================================
///
/// Permet d'obtenir directement le profil correspondant au mode demandé.
///
/// Exemple :
///
/// ```dart
/// final AppearanceSettings aqua = ref.watch(
///   appearanceProfileProvider(
///     AppThemeMode.aqua,
///   ),
/// );
/// ```
final appearanceProfileProvider =
    Provider.family<
        AppearanceSettings,
        AppThemeMode>(
  (
    Ref ref,
    AppThemeMode mode,
  ) {
    final AppearanceProfiles profiles =
        ref.watch(
      appearanceProfilesProvider,
    );

    return profiles.forMode(mode);
  },
);