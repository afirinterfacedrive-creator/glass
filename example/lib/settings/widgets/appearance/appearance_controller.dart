import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:universal_glass/glass.dart';
import 'package:universal_glass_example/settings/widgets/appearance/appearance_profiles_codec.dart';
import 'package:universal_glass_example/settings/widgets/appearance/appearance_profiles_service.dart';

import 'appearance_profiles.dart';
import 'appearance_settings.dart';

/// ============================================================================
/// APPEARANCE CONTROLLER
/// ============================================================================
///
/// Contrôleur central des réglages d'apparence.
///
/// Responsabilités :
///
/// - charger les quatre profils ;
/// - migrer les anciennes préférences ;
/// - sauvegarder les quatre profils en JSON ;
/// - gérer séparément le mode actif de l'application ;
/// - appliquer un profil au GlassThemeProvider ;
/// - modifier uniquement le profil sélectionné ;
/// - importer/exporter les profils globaux ;
/// - réinitialiser les profils.
///
/// Les quatre apparences personnalisables sont indépendantes :
///
/// - Aqua
/// - Classic
/// - Light
/// - Dark
///
/// [AppThemeMode.system] n'est pas un profil personnalisable.
///
/// Le mode actif est stocké séparément des profils.
///
/// Architecture :
///
///     activeMode
///         │
///         ├── system
///         ├── aqua
///         ├── classic
///         ├── light
///         └── dark
///
///     AppearanceProfiles
///         ├── aqua
///         ├── classic
///         ├── light
///         └── dark
///
/// Ainsi, changer de mode actif ne modifie jamais les réglages des profils.
class AppearanceController {
  final Ref ref;
  final SharedPreferences preferences;

  AppearanceController(
    this.ref,
    this.preferences,
  );

  // ===========================================================================
  // STORAGE
  // ===========================================================================

  /// Clé principale contenant les quatre profils.
  ///
  /// On utilise la clé AppearanceSettings existante afin de conserver la
  /// compatibilité avec le stockage actuel.
  String get _profilesKey {
    return AppConstants.appearanceSettingsKey;
  }

  /// Clé contenant uniquement le mode actuellement actif.
  ///
  /// Cette valeur est volontairement indépendante des quatre profils.
  String get _activeModeKey {
    return 'appearance_active_mode';
  }

  // ===========================================================================
  // ACTIVE MODE
  // ===========================================================================

  /// Mode actuellement actif dans l'application.
  ///
  /// Le mode actif est indépendant des profils personnalisables.
  ///
  /// Si aucune valeur n'est enregistrée, Aqua est utilisé par défaut.
  AppThemeMode get activeMode {
    return _getActiveThemeMode();
  }

  /// Retourne le mode actuellement actif.
  ///
  /// Méthode publique conservée en complément du getter [activeMode] afin de
  /// faciliter l'utilisation depuis les écrans de réglages.
  AppThemeMode getActiveThemeMode() {
    return _getActiveThemeMode();
  }

  // ===========================================================================
  // DEFAULT PROFILES
  // ===========================================================================

  /// Construit les quatre profils par défaut.
  ///
  /// Chaque profil est une instance indépendante de [AppearanceSettings].
  AppearanceProfiles defaultProfiles() {
    const AppearanceSettings defaults = AppearanceSettings();

    return AppearanceProfiles(
      aqua: defaults.copyWith(
        themeMode: 'aqua',
      ),
      classic: defaults.copyWith(
        themeMode: 'classic',
      ),
      light: defaults.copyWith(
        themeMode: 'light',
      ),
      dark: defaults.copyWith(
        themeMode: 'dark',
      ),
    );
  }

  // ===========================================================================
  // LOAD PROFILES
  // ===========================================================================

  /// Charge les quatre profils.
  ///
  /// Priorité :
  ///
  /// 1. nouveau stockage contenant AppearanceProfiles ;
  /// 2. ancien stockage contenant un seul AppearanceSettings ;
  /// 3. anciennes clés individuelles ;
  /// 4. valeurs par défaut.
  ///
  /// Lorsqu'un ancien stockage est détecté, son ancien [themeMode] devient
  /// également le nouveau mode actif.
  AppearanceProfiles loadProfiles() {
    final String? storedJson = preferences.getString(
      _profilesKey,
    );

    if (storedJson != null && storedJson.isNotEmpty) {
      try {
        final dynamic decoded = jsonDecode(
          storedJson,
        );

        if (decoded is Map) {
          final Map<String, dynamic> map =
              Map<String, dynamic>.from(decoded);

          // -------------------------------------------------------------------
          // Nouveau format : quatre profils
          // -------------------------------------------------------------------

          if (_isProfilesJson(map)) {
            return AppearanceProfiles.fromJson(
              map,
              fallback: defaultProfiles(),
            );
          }

          // -------------------------------------------------------------------
          // Ancien format : un seul AppearanceSettings
          // -------------------------------------------------------------------

          final AppearanceSettings legacySettings =
              AppearanceSettings.fromJson(
            map,
          );

          final AppearanceProfiles migrated =
              _migrateSingleSettings(
            legacySettings,
          );

          // Le mode de l'ancien stockage devient le mode actif.
          _saveMigratedActiveMode(
            legacySettings.themeMode,
          );

          return migrated;
        }
      } catch (_) {
        // JSON invalide : poursuivre avec le stockage legacy.
      }
    }

    // =========================================================================
    // LEGACY
    // =========================================================================

    final AppearanceSettings legacySettings = _loadLegacySettings();

    final AppearanceProfiles migrated = _migrateSingleSettings(
      legacySettings,
    );

    // Le mode historique devient le nouveau mode actif.
    _saveMigratedActiveMode(
      legacySettings.themeMode,
    );

    return migrated;
  }

  // ===========================================================================
  // LOAD ACTIVE PROFILE
  // ===========================================================================

  /// Charge le profil correspondant au mode demandé.
  ///
  /// [AppThemeMode.system] utilise le profil Aqua comme fallback.
  AppearanceSettings loadForMode(
    AppThemeMode mode,
  ) {
    final AppearanceProfiles profiles = loadProfiles();

    return profiles.forMode(
      mode,
    );
  }

  // ===========================================================================
  // COMPATIBILITY LOAD
  // ===========================================================================

  /// Compatibilité avec l'ancien controller.
  ///
  /// Retourne maintenant le profil correspondant au mode réellement actif,
  /// stocké séparément des profils.
  AppearanceSettings load() {
    final AppearanceProfiles profiles = loadProfiles();

    final AppThemeMode mode = _getActiveThemeMode();

    return profiles.forMode(
      mode,
    );
  }

  // ===========================================================================
  // APPLY
  // ===========================================================================

  /// Applique les réglages au GlassThemeProvider puis les sauvegarde.
  ///
  /// Cette méthode conserve volontairement la signature historique afin de
  /// ne pas casser les appels existants.
  Future<AppearanceSettings> apply(
    AppearanceSettings settings,
  ) async {
    final GlassThemeNotifier notifier =
        ref.read(glassThemeProvider.notifier);

    // -------------------------------------------------------------------------
    // THEME MODE
    // -------------------------------------------------------------------------

    final AppThemeMode themeMode = _parseThemeMode(
      settings.themeMode,
    );

    notifier.setThemeMode(
      themeMode,
    );

    // -------------------------------------------------------------------------
    // GLASS STYLE
    // -------------------------------------------------------------------------

    final GlassStyle glassStyle = _parseGlassStyle(
      settings.glassStyle,
    );

    await notifier.setGlassStyle(
      glassStyle,
    );

    // -------------------------------------------------------------------------
    // AQUA / CLASSIC
    // -------------------------------------------------------------------------

    final bool useAquaStyle = _usesAquaStyle(
      glassStyle,
    );

    await notifier.setAquaStyle(
      useAquaStyle,
    );

    // -------------------------------------------------------------------------
    // GRADIENT ENABLE
    // -------------------------------------------------------------------------

    await notifier.setEnableGradient(
      settings.enableGradient,
    );

    // -------------------------------------------------------------------------
    // GRADIENT COLORS
    // -------------------------------------------------------------------------

    final List<Color> aquaColors = _toColors(
      settings.aquaColors,
    );

    final List<Color> classicColors = _toColors(
      settings.classicColors,
    );

    if (aquaColors.isNotEmpty) {
      await notifier.setAquaGradient(
        aquaColors,
      );
    }

    if (classicColors.isNotEmpty) {
      await notifier.setClassicGradient(
        classicColors,
      );
    }

    // -------------------------------------------------------------------------
    // GRADIENT DENSITY
    // -------------------------------------------------------------------------

    final double gradientDensity = settings.gradientDensity
        .round()
        .clamp(2, 4)
        .toDouble();

    await notifier.setGradientDensity(
      gradientDensity,
    );

    // -------------------------------------------------------------------------
    // GRADIENT OPACITY
    // -------------------------------------------------------------------------

    await notifier.setGradientOpacity(
      settings.effectiveGradientOpacity,
    );

    // -------------------------------------------------------------------------
    // BLUR
    // -------------------------------------------------------------------------

    await notifier.setEnableBlur(
      settings.enableBlur,
    );

    await notifier.setBlur(
      settings.effectiveBlur,
    );

    // -------------------------------------------------------------------------
    // NOISE
    // -------------------------------------------------------------------------

    await notifier.setEnableNoise(
      settings.enableNoise,
    );

    await notifier.setNoise(
      settings.effectiveNoise,
    );

    // -------------------------------------------------------------------------
    // SAVE
    // -------------------------------------------------------------------------

    await _saveActiveSettings(
      settings,
    );

    return settings;
  }

  // ===========================================================================
  // APPLY PROFILE
  // ===========================================================================

  /// Applique directement le profil [mode].
  Future<AppearanceSettings> applyProfile(
    AppThemeMode mode,
  ) async {
    final AppearanceProfiles profiles = loadProfiles();

    final AppearanceSettings settings = profiles.forMode(
      mode,
    );

    return apply(
      settings,
    );
  }

  // ===========================================================================
  // APPLY AND RETURN
  // ===========================================================================

  Future<AppearanceSettings> applyAndReturn(
    AppearanceSettings settings,
  ) async {
    return apply(
      settings,
    );
  }

  // ===========================================================================
  // UPDATE PROFILE
  // ===========================================================================

  /// Modifie uniquement le profil [mode].
  ///
  /// Les trois autres profils restent inchangés.
  Future<AppearanceSettings> updateProfile(
    AppThemeMode mode,
    AppearanceSettings Function(
      AppearanceSettings settings,
    ) updater,
  ) async {
    if (mode == AppThemeMode.system) {
      return loadForMode(
        AppThemeMode.aqua,
      );
    }

    final AppearanceProfiles profiles = loadProfiles();

    final AppearanceSettings current = profiles.forMode(
      mode,
    );

    final AppearanceSettings updated = updater(
      current,
    );

    final AppearanceProfiles updatedProfiles =
        profiles.updateMode(
      mode,
      updated.copyWith(
        themeMode: mode.name,
      ),
    );

    await _saveProfiles(
      updatedProfiles,
    );

    // -------------------------------------------------------------------------
    // Si le profil modifié est le mode actuellement actif, on l'applique.
    //
    // IMPORTANT :
    // Le profil est déjà sauvegardé. On ne réécrit donc pas les profils ici.
    // -------------------------------------------------------------------------

    final AppThemeMode currentActiveMode =
        _getActiveThemeMode();

    if (currentActiveMode == mode) {
      await _applyWithoutSaving(
        updated.copyWith(
          themeMode: mode.name,
        ),
      );
    }

    return updated.copyWith(
      themeMode: mode.name,
    );
  }

  // ===========================================================================
  // UPDATE
  // ===========================================================================

  /// Compatibilité avec l'ancien API.
  ///
  /// Met à jour le profil actuellement actif.
  Future<AppearanceSettings> update(
    AppearanceSettings Function(
      AppearanceSettings settings,
    ) updater,
  ) async {
    final AppThemeMode currentActiveMode =
        _getActiveThemeMode();

    return updateProfile(
      currentActiveMode,
      updater,
    );
  }

  // ===========================================================================
  // THEME MODE
  // ===========================================================================

  /// Change uniquement le mode actif de l'application.
  ///
  /// IMPORTANT :
  ///
  /// Cette méthode ne modifie aucun des quatre profils.
  ///
  /// Exemple :
  ///
  /// - Aqua est personnalisé avec un blur de 20 ;
  /// - Dark est personnalisé avec un blur de 5 ;
  /// - on passe de Aqua à Dark ;
  ///
  /// Le profil Dark est simplement activé avec ses propres réglages.
  /// 
/// Change uniquement le mode actif de l'application.
///
/// IMPORTANT :
///
/// Cette opération ne modifie aucun des quatre profils.
/// Elle change uniquement le mode actif et applique son profil.
///
/// Exemple :
///
/// - Aqua possède ses propres réglages.
/// - Dark possède ses propres réglages.
/// - passer de Aqua à Dark ne modifie ni Aqua ni Dark.
/// - le profil Dark existant est simplement activé et appliqué.
Future<AppearanceSettings> changeThemeMode(
  AppThemeMode mode,
) async {
  // ---------------------------------------------------------------------------
  // AppThemeMode.system
  // ---------------------------------------------------------------------------
  //
  // System n'est pas un profil personnalisable.
  // Il reste toutefois autorisé comme mode actif.
  //
  // Le profil Aqua est utilisé comme fallback pour l'application.
  // ---------------------------------------------------------------------------

  final AppThemeMode activeMode =
      mode == AppThemeMode.system
          ? AppThemeMode.system
          : mode;

  // ---------------------------------------------------------------------------
  // Sauvegarder UNIQUEMENT le mode actif.
  //
  // IMPORTANT :
  // Aucun des quatre profils n'est modifié ici.
  // ---------------------------------------------------------------------------

  await preferences.setString(
    _activeModeKey,
    activeMode.name,
  );

  // ---------------------------------------------------------------------------
  // Charger les profils existants.
  // ---------------------------------------------------------------------------

  final AppearanceProfiles profiles =
      loadProfiles();

  // ---------------------------------------------------------------------------
  // Sélectionner le profil correspondant.
  //
  // AppearanceProfiles.forMode() utilise Aqua comme fallback pour system.
  // ---------------------------------------------------------------------------

  final AppearanceSettings selected =
      profiles.forMode(
    activeMode,
  );

  // ---------------------------------------------------------------------------
  // Appliquer le profil sélectionné sans sauvegarder les profils.
  //
  // IMPORTANT :
  // _applyWithoutSaving() ne touche pas au JSON des quatre profils.
  // ---------------------------------------------------------------------------

  await _applyWithoutSaving(
    selected,
  );

  return selected;
}

  // ===========================================================================
  // GLASS STYLE
  // ===========================================================================

  Future<AppearanceSettings> changeGlassStyle(
    String glassStyle,
  ) {
    return update(
      (AppearanceSettings settings) {
        return settings.copyWith(
          glassStyle: glassStyle,
        );
      },
    );
  }

  /// Modifie le style du profil demandé.
  Future<AppearanceSettings> changeGlassStyleForMode(
    AppThemeMode mode,
    String glassStyle,
  ) {
    return updateProfile(
      mode,
      (AppearanceSettings settings) {
        return settings.copyWith(
          glassStyle: glassStyle,
        );
      },
    );
  }

  // ===========================================================================
  // AQUA COLORS
  // ===========================================================================

  Future<AppearanceSettings> setAquaColors(
    List<int> colors,
  ) {
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

  // ===========================================================================
  // CLASSIC COLORS
  // ===========================================================================

  Future<AppearanceSettings> setClassicColors(
    List<int> colors,
  ) {
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

  // ===========================================================================
  // COLORS FOR PROFILE
  // ===========================================================================

  Future<AppearanceSettings> setAquaColorsForMode(
    AppThemeMode mode,
    List<int> colors,
  ) {
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

  Future<AppearanceSettings> setClassicColorsForMode(
    AppThemeMode mode,
    List<int> colors,
  ) {
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

  // ===========================================================================
  // SINGLE COLOR
  // ===========================================================================

  Future<AppearanceSettings> setColor({
    required bool aqua,
    required int index,
    required int color,
  }) {
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

  // ===========================================================================
  // SINGLE COLOR FOR PROFILE
  // ===========================================================================

  Future<AppearanceSettings> setColorForMode({
    required AppThemeMode mode,
    required bool aqua,
    required int index,
    required int color,
  }) {
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

  // ===========================================================================
  // RESET
  // ===========================================================================

  /// Réinitialise les quatre profils.
  ///
  /// Le mode actif est volontairement conservé.
  Future<AppearanceProfiles> resetProfiles() async {
    // -------------------------------------------------------------------------
    // Nouveau stockage
    // -------------------------------------------------------------------------

    await preferences.remove(
      _profilesKey,
    );

    // -------------------------------------------------------------------------
    // Anciennes clés
    // -------------------------------------------------------------------------

    await _removeLegacyKeys();

    // -------------------------------------------------------------------------
    // Defaults
    // -------------------------------------------------------------------------

    final AppearanceProfiles profiles =
        defaultProfiles();

    await _saveProfiles(
      profiles,
    );

    // -------------------------------------------------------------------------
    // Appliquer le mode actif
    //
    // IMPORTANT :
    // _activeModeKey n'est pas supprimée.
    // -------------------------------------------------------------------------

    final AppThemeMode currentActiveMode =
        _getActiveThemeMode();

    await _applyWithoutSaving(
      profiles.forMode(
        currentActiveMode,
      ),
    );

    return profiles;
  }

  // ===========================================================================
  // RESET COMPATIBILITY
  // ===========================================================================

  /// Compatibilité avec l'ancien API.
  Future<AppearanceSettings> reset() async {
    final AppearanceProfiles profiles =
        await resetProfiles();

    final AppThemeMode currentActiveMode =
        _getActiveThemeMode();

    return profiles.forMode(
      currentActiveMode,
    );
  }

  // ===========================================================================
  // SAVE PROFILES
  // ===========================================================================

  Future<void> _saveProfiles(
    AppearanceProfiles profiles,
  ) async {
    await preferences.setString(
      _profilesKey,
      profiles.encode(),
    );
  }

  // ===========================================================================
  // IMPORT PROFILES
  // ===========================================================================

  /// Importe les quatre profils depuis un fichier JSON.
  ///
  /// Le fichier peut contenir :
  ///
  /// - Aqua
  /// - Classic
  /// - Light
  /// - Dark
  /// - le mode actif
  ///
  /// Après import :
  ///
  /// 1. les quatre profils sont sauvegardés ;
  /// 2. le mode actif importé est sauvegardé séparément ;
  /// 3. le profil actif est appliqué au GlassThemeNotifier.
  ///
  /// Les réglages spécifiques aux composants ne sont pas concernés.
  ///
  /// Retourne `null` si l'utilisateur annule la sélection du fichier.
  Future<AppearanceProfilesDocument?> importProfiles() async {
    // -------------------------------------------------------------------------
    // État actuel utilisé comme fallback.
    // -------------------------------------------------------------------------

    final AppearanceProfiles currentProfiles =
        loadProfiles();

    final AppThemeMode currentActiveMode =
        _getActiveThemeMode();

    // -------------------------------------------------------------------------
    // Import brut.
    //
    // On utilise importJson() directement afin de pouvoir distinguer :
    //
    // - annulation utilisateur → null ;
    // - fichier sélectionné mais invalide → décodage avec fallback.
    // -------------------------------------------------------------------------

    final String? jsonString =
        await AppearanceProfilesService.importJson();

    if (jsonString == null ||
        jsonString.trim().isEmpty) {
      return null;
    }

    // -------------------------------------------------------------------------
    // Décodage du document.
    // -------------------------------------------------------------------------

    final AppearanceProfilesDocument imported =
        AppearanceProfilesService.decode(
      source: jsonString,
      fallback: currentProfiles,
      fallbackActiveMode: currentActiveMode,
    );

    final AppearanceProfiles profiles =
        imported.profiles;

    final AppThemeMode activeMode =
        imported.activeMode;

    // -------------------------------------------------------------------------
    // Sauvegarder les quatre profils.
    // -------------------------------------------------------------------------

    await _saveProfiles(
      profiles,
    );

    // -------------------------------------------------------------------------
    // Sauvegarder séparément le mode actif.
    // -------------------------------------------------------------------------

    await preferences.setString(
      _activeModeKey,
      activeMode.name,
    );

    // -------------------------------------------------------------------------
    // Appliquer uniquement le profil actif.
    //
    // Aucun appel à _saveActiveSettings() ici afin de ne pas réécrire
    // inutilement le document des profils.
    // -------------------------------------------------------------------------

    final AppearanceSettings activeSettings =
        profiles.forMode(
      activeMode,
    );

    await _applyWithoutSaving(
      activeSettings,
    );

    return imported;
  }

  // ===========================================================================
  // EXPORT PROFILES
  // ===========================================================================

  /// Exporte les quatre profils et le mode actif.
  ///
  /// Le fichier exporté est géré par [AppearanceProfilesService].
  Future<String?> exportProfiles({
    String? fileName,
    bool pretty = true,
  }) async {
    final AppearanceProfiles profiles =
        loadProfiles();

    final AppThemeMode activeMode =
        _getActiveThemeMode();

    return AppearanceProfilesService.exportProfiles(
      profiles: profiles,
      activeMode: activeMode,
      fileName: fileName,
      pretty: pretty,
    );
  }

  // ===========================================================================
  // SAVE ACTIVE SETTINGS
  // ===========================================================================

  /// Remplace uniquement le profil correspondant au mode contenu dans
  /// [settings].
  ///
  /// Cette méthode est conservée pour la compatibilité de [apply].
  ///
  /// Le nouveau fonctionnement des écrans de réglages passe de préférence
  /// par [updateProfile], qui sait explicitement quel profil est modifié.
  Future<void> _saveActiveSettings(
    AppearanceSettings settings,
  ) async {
    final AppearanceProfiles profiles =
        loadProfiles();

    final AppThemeMode mode =
        _parseThemeMode(
      settings.themeMode,
    );

    if (mode == AppThemeMode.system) {
      return;
    }

    final AppearanceProfiles updatedProfiles =
        profiles.updateMode(
      mode,
      settings.copyWith(
        themeMode: mode.name,
      ),
    );

    await _saveProfiles(
      updatedProfiles,
    );
  }

  // ===========================================================================
  // APPLY WITHOUT SAVE
  // ===========================================================================

  /// Applique les réglages au provider sans réécrire les profils.
  ///
  /// Cette méthode évite la boucle :
  ///
  /// updateProfile()
  /// → save
  /// → apply
  /// → save
  Future<void> _applyWithoutSaving(
    AppearanceSettings settings,
  ) async {
    final GlassThemeNotifier notifier =
        ref.read(glassThemeProvider.notifier);

    // -------------------------------------------------------------------------
    // THEME MODE
    // -------------------------------------------------------------------------

    final AppThemeMode themeMode =
        _parseThemeMode(
      settings.themeMode,
    );

    notifier.setThemeMode(
      themeMode,
    );

    // -------------------------------------------------------------------------
    // GLASS STYLE
    // -------------------------------------------------------------------------

    final GlassStyle glassStyle =
        _parseGlassStyle(
      settings.glassStyle,
    );

    await notifier.setGlassStyle(
      glassStyle,
    );

    // -------------------------------------------------------------------------
    // AQUA / CLASSIC
    // -------------------------------------------------------------------------

    await notifier.setAquaStyle(
      _usesAquaStyle(
        glassStyle,
      ),
    );

    // -------------------------------------------------------------------------
    // GRADIENT
    // -------------------------------------------------------------------------

    await notifier.setEnableGradient(
      settings.enableGradient,
    );

    // -------------------------------------------------------------------------
    // COLORS
    // -------------------------------------------------------------------------

    final List<Color> aquaColors =
        _toColors(
      settings.aquaColors,
    );

    final List<Color> classicColors =
        _toColors(
      settings.classicColors,
    );

    if (aquaColors.isNotEmpty) {
      await notifier.setAquaGradient(
        aquaColors,
      );
    }

    if (classicColors.isNotEmpty) {
      await notifier.setClassicGradient(
        classicColors,
      );
    }

    // -------------------------------------------------------------------------
    // GRADIENT DENSITY
    // -------------------------------------------------------------------------

    final double gradientDensity =
        settings.gradientDensity
            .round()
            .clamp(2, 4)
            .toDouble();

    await notifier.setGradientDensity(
      gradientDensity,
    );

    // -------------------------------------------------------------------------
    // GRADIENT OPACITY
    // -------------------------------------------------------------------------

    await notifier.setGradientOpacity(
      settings.effectiveGradientOpacity,
    );

    // -------------------------------------------------------------------------
    // BLUR
    // -------------------------------------------------------------------------

    await notifier.setEnableBlur(
      settings.enableBlur,
    );

    await notifier.setBlur(
      settings.effectiveBlur,
    );

    // -------------------------------------------------------------------------
    // NOISE
    // -------------------------------------------------------------------------

    await notifier.setEnableNoise(
      settings.enableNoise,
    );

    await notifier.setNoise(
      settings.effectiveNoise,
    );
  }

  // ===========================================================================
  // ACTIVE MODE
  // ===========================================================================

  /// Retourne le mode actif enregistré.
  ///
  /// Le mode actif est désormais complètement indépendant des profils.
  ///
  /// Valeur par défaut : Aqua.
  AppThemeMode _getActiveThemeMode() {
    final String? value =
        preferences.getString(
      _activeModeKey,
    );

    if (value == null || value.isEmpty) {
      return AppThemeMode.aqua;
    }

    final AppThemeMode parsed =
        _parseThemeMode(
      value,
    );

    // Le mode system n'est pas un profil personnalisable.
    // Il reste néanmoins autorisé comme mode actif.
    return parsed;
  }

  // ===========================================================================
  // MIGRATED ACTIVE MODE
  // ===========================================================================

  /// Enregistre le mode actif lors d'une migration legacy.
  ///
  /// Cette opération est volontairement tolérante :
  /// une erreur éventuelle ne doit pas empêcher le chargement des profils.
  void _saveMigratedActiveMode(
    String value,
  ) {
    try {
      final AppThemeMode mode =
          _parseThemeMode(
        value,
      );

      preferences.setString(
        _activeModeKey,
        mode.name,
      );
    } catch (_) {
      preferences.setString(
        _activeModeKey,
        AppThemeMode.aqua.name,
      );
    }
  }

  // ===========================================================================
  // MIGRATION
  // ===========================================================================

  /// Transforme un ancien AppearanceSettings unique en quatre profils.
  ///
  /// Le profil existant est conservé dans son mode d'origine.
  /// Les autres profils partent des valeurs par défaut.
  AppearanceProfiles _migrateSingleSettings(
    AppearanceSettings settings,
  ) {
    final AppearanceProfiles defaults =
        defaultProfiles();

    final AppThemeMode mode =
        _parseThemeMode(
      settings.themeMode,
    );

    switch (mode) {
      case AppThemeMode.aqua:
        return defaults.copyWith(
          aqua: settings.copyWith(
            themeMode: 'aqua',
          ),
        );

      case AppThemeMode.classic:
        return defaults.copyWith(
          classic: settings.copyWith(
            themeMode: 'classic',
          ),
        );

      case AppThemeMode.light:
        return defaults.copyWith(
          light: settings.copyWith(
            themeMode: 'light',
          ),
        );

      case AppThemeMode.dark:
        return defaults.copyWith(
          dark: settings.copyWith(
            themeMode: 'dark',
          ),
        );

      case AppThemeMode.system:
        return defaults.copyWith(
          aqua: settings.copyWith(
            themeMode: 'aqua',
          ),
        );
    }
  }

  // ===========================================================================
  // JSON FORMAT DETECTION
  // ===========================================================================

  bool _isProfilesJson(
    Map<String, dynamic> json,
  ) {
    return json.containsKey('aqua') ||
        json.containsKey('classic') ||
        json.containsKey('light') ||
        json.containsKey('dark');
  }

  // ===========================================================================
  // LEGACY LOAD
  // ===========================================================================

  AppearanceSettings _loadLegacySettings() {
    const AppearanceSettings defaults =
        AppearanceSettings();

    return defaults.copyWith(
      // -----------------------------------------------------------------------
      // Theme
      // -----------------------------------------------------------------------

      themeMode: _loadString(
        AppConstants.appearanceThemeModeKey,
        defaults.themeMode,
      ),

      glassStyle: _loadString(
        AppConstants.appearanceGlassStyleKey,
        defaults.glassStyle,
      ),

      // -----------------------------------------------------------------------
      // Colors
      // -----------------------------------------------------------------------

      aquaColors: _loadIntList(
        AppConstants.appearanceAquaColorsKey,
        defaults.aquaColors,
      ),

      classicColors: _loadIntList(
        AppConstants.appearanceClassicColorsKey,
        defaults.classicColors,
      ),

      // -----------------------------------------------------------------------
      // Blur
      // -----------------------------------------------------------------------

      enableBlur: _loadBool(
        AppConstants.appearanceEnableBlurKey,
        defaults.enableBlur,
      ),

      blur: _loadDouble(
        AppConstants.appearanceBlurKey,
        defaults.blur,
      ),

      // -----------------------------------------------------------------------
      // Noise
      // -----------------------------------------------------------------------

      enableNoise: _loadBool(
        AppConstants.appearanceEnableNoiseKey,
        defaults.enableNoise,
      ),

      noise: _loadDouble(
        AppConstants.appearanceNoiseKey,
        defaults.noise,
      ),

      // -----------------------------------------------------------------------
      // Gradient
      // -----------------------------------------------------------------------

      enableGradient: _loadBool(
        AppConstants.appearanceEnableGradientKey,
        defaults.enableGradient,
      ),

      gradientOpacity: _loadDouble(
        AppConstants.appearanceGradientOpacityKey,
        defaults.gradientOpacity,
      ),

      gradientDensity: _loadDouble(
        AppConstants.appearanceGradientDensityKey,
        defaults.gradientDensity,
      ),

      // -----------------------------------------------------------------------
      // Surface
      // -----------------------------------------------------------------------

      surfaceOpacity: _loadDouble(
        AppConstants.appearanceSurfaceOpacityKey,
        defaults.surfaceOpacity,
      ),

      borderRadius: _loadDouble(
        AppConstants.appearanceBorderRadiusKey,
        defaults.borderRadius,
      ),

      // -----------------------------------------------------------------------
      // Border
      // -----------------------------------------------------------------------

      enableBorder: _loadBool(
        AppConstants.appearanceEnableBorderKey,
        defaults.enableBorder,
      ),

      borderOpacity: _loadDouble(
        AppConstants.appearanceBorderOpacityKey,
        defaults.borderOpacity,
      ),

      borderWidth: _loadDouble(
        AppConstants.appearanceBorderWidthKey,
        defaults.borderWidth,
      ),

      // -----------------------------------------------------------------------
      // Glow
      // -----------------------------------------------------------------------

      enableGlow: _loadBool(
        AppConstants.appearanceEnableGlowKey,
        defaults.enableGlow,
      ),

      glowOpacity: _loadDouble(
        AppConstants.appearanceGlowOpacityKey,
        defaults.glowOpacity,
      ),

      glowBlur: _loadDouble(
        AppConstants.appearanceGlowBlurKey,
        defaults.glowBlur,
      ),

      // -----------------------------------------------------------------------
      // Hover
      // -----------------------------------------------------------------------

      enableHover: _loadBool(
        AppConstants.appearanceEnableHoverKey,
        defaults.enableHover,
      ),

      hoverLift: _loadDouble(
        AppConstants.appearanceHoverLiftKey,
        defaults.hoverLift,
      ),

      // -----------------------------------------------------------------------
      // Shadow
      // -----------------------------------------------------------------------

      enableShadow: _loadBool(
        AppConstants.appearanceEnableShadowKey,
        defaults.enableShadow,
      ),

      shadowOpacity: _loadDouble(
        AppConstants.appearanceShadowOpacityKey,
        defaults.shadowOpacity,
      ),

      shadowBlur: _loadDouble(
        AppConstants.appearanceShadowBlurKey,
        defaults.shadowBlur,
      ),

      shadowOffsetY: _loadDouble(
        AppConstants.appearanceShadowOffsetYKey,
        defaults.shadowOffsetY,
      ),
    );
  }

  // ===========================================================================
  // LEGACY REMOVE
  // ===========================================================================

  Future<void> _removeLegacyKeys() async {
    const List<String> keys = <String>[
      AppConstants.appearanceThemeModeKey,
      AppConstants.appearanceGlassStyleKey,
      AppConstants.appearanceAquaColorsKey,
      AppConstants.appearanceClassicColorsKey,

      AppConstants.appearanceEnableBlurKey,
      AppConstants.appearanceBlurKey,

      AppConstants.appearanceEnableNoiseKey,
      AppConstants.appearanceNoiseKey,

      AppConstants.appearanceEnableGradientKey,
      AppConstants.appearanceGradientOpacityKey,
      AppConstants.appearanceGradientDensityKey,

      AppConstants.appearanceSurfaceOpacityKey,
      AppConstants.appearanceBorderRadiusKey,

      AppConstants.appearanceEnableBorderKey,
      AppConstants.appearanceBorderOpacityKey,
      AppConstants.appearanceBorderWidthKey,

      AppConstants.appearanceEnableGlowKey,
      AppConstants.appearanceGlowOpacityKey,
      AppConstants.appearanceGlowBlurKey,

      AppConstants.appearanceEnableHoverKey,
      AppConstants.appearanceHoverLiftKey,

      AppConstants.appearanceEnableShadowKey,
      AppConstants.appearanceShadowOpacityKey,
      AppConstants.appearanceShadowBlurKey,
      AppConstants.appearanceShadowOffsetYKey,
    ];

    for (final String key in keys) {
      await preferences.remove(
        key,
      );
    }
  }

  // ===========================================================================
  // COLOR UPDATE
  // ===========================================================================

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

  // ===========================================================================
  // TYPE CONVERSION
  // ===========================================================================

  List<Color> _toColors(
    List<int> values,
  ) {
    return values
        .map(
          Color.new,
        )
        .toList(
          growable: false,
        );
  }

  // ===========================================================================
  // GLASS STYLE
  // ===========================================================================

  GlassStyle _parseGlassStyle(
    String value,
  ) {
    switch (value.toLowerCase()) {
      // -----------------------------------------------------------------------
      // Aqua
      // -----------------------------------------------------------------------

      case 'transparentaqua':
      case 'transparent_aqua':
        return GlassStyle.transparentAqua;

      case 'solidaqua':
      case 'solid_aqua':
        return GlassStyle.solidAqua;

      case 'aqua':
        return GlassStyle.transparentAqua;

      // -----------------------------------------------------------------------
      // Rouge
      // -----------------------------------------------------------------------

      case 'transparentred':
      case 'transparent_red':
        return GlassStyle.transparentRed;

      // -----------------------------------------------------------------------
      // Vert
      // -----------------------------------------------------------------------

      case 'transparentgreen':
      case 'transparent_green':
        return GlassStyle.transparentGreen;

      // -----------------------------------------------------------------------
      // Classic
      // -----------------------------------------------------------------------

      case 'solidclassic':
      case 'solid_classic':
        return GlassStyle.solidClassic;

      case 'classic':
        return GlassStyle.solidClassic;

      case 'opaquemat':
      case 'opaque_mat':
        return GlassStyle.opaqueMat;

      case 'opaqueheavy':
      case 'opaque_heavy':
        return GlassStyle.opaqueHeavy;

      case 'gradientopaque':
      case 'gradient_opaque':
        return GlassStyle.gradientOpaque;

      case 'customgradient':
      case 'custom_gradient':
        return GlassStyle.customGradient;

      case 'classicsb':
      case 'classic_sb':
        return GlassStyle.classicSb;

      // -----------------------------------------------------------------------
      // Custom
      // -----------------------------------------------------------------------

      case 'custom':
        return GlassStyle.custom;

      // -----------------------------------------------------------------------
      // Compatibilité
      // -----------------------------------------------------------------------

      case 'ghost':
        return GlassStyle.transparentAqua;

      case 'welcomeglass':
      case 'welcome_glass':
        return GlassStyle.transparentAqua;

      case 'appbar':
        return GlassStyle.gradientOpaque;

      default:
        return GlassStyle.transparentAqua;
    }
  }

  // ===========================================================================
  // AQUA STYLE DETECTION
  // ===========================================================================

  bool _usesAquaStyle(
    GlassStyle style,
  ) {
    switch (style) {
      case GlassStyle.transparentAqua:
      case GlassStyle.solidAqua:
        return true;

      case GlassStyle.transparentRed:
      case GlassStyle.transparentGreen:
        return false;

      case GlassStyle.opaqueMat:
      case GlassStyle.opaqueHeavy:
      case GlassStyle.gradientOpaque:
      case GlassStyle.customGradient:
      case GlassStyle.solidClassic:
      case GlassStyle.classicSb:
      case GlassStyle.custom:
        return false;
    }
  }

  // ===========================================================================
  // THEME MODE
  // ===========================================================================

  AppThemeMode _parseThemeMode(
    String value,
  ) {
    switch (value.toLowerCase()) {
      case 'dark':
        return AppThemeMode.dark;

      case 'light':
        return AppThemeMode.light;

      case 'aqua':
        return AppThemeMode.aqua;

      case 'classic':
        return AppThemeMode.classic;

      case 'system':
      default:
        return AppThemeMode.system;
    }
  }

  // ===========================================================================
  // LEGACY HELPERS
  // ===========================================================================

  String _loadString(
    String key,
    String fallback,
  ) {
    final String? value =
        preferences.getString(
      key,
    );

    if (value == null || value.isEmpty) {
      return fallback;
    }

    return value;
  }

  bool _loadBool(
    String key,
    bool fallback,
  ) {
    return preferences.getBool(
          key,
        ) ??
        fallback;
  }

  double _loadDouble(
    String key,
    double fallback,
  ) {
    return preferences.getDouble(
          key,
        ) ??
        fallback;
  }

  List<int> _loadIntList(
    String key,
    List<int> fallback,
  ) {
    final List<String>? values =
        preferences.getStringList(
      key,
    );

    if (values == null || values.isEmpty) {
      return List<int>.from(
        fallback,
      );
    }

    final List<int> result = <int>[];

    for (final String value in values) {
      final int? parsed =
          int.tryParse(
        value,
      );

      if (parsed != null) {
        result.add(
          parsed,
        );
      }
    }

    if (result.isEmpty) {
      return List<int>.from(
        fallback,
      );
    }

    return result;
  }
}