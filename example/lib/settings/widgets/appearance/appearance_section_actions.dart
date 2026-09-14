import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:universal_glass/glass.dart';
import 'package:universal_glass_example/settings/widgets/appearance/appearance_profiles_provider.dart';

import 'appearance_controller.dart';
import 'appearance_settings.dart';
import 'widgets/appearance_color_picker.dart';

typedef AppearanceSettingsUpdater = AppearanceSettings Function(
  AppearanceSettings settings,
);

class AppearanceSectionActions {
  AppearanceSectionActions({
    required this.ref,
    required this.controller,
    required this.getSelectedAppearance,
    required this.isMounted,
    required this.onSavingChanged,
    required this.onError,
    this.onThemeChanged,
  });

  final Ref ref;
  final AppearanceController controller;

  final AppThemeMode Function() getSelectedAppearance;
  final bool Function() isMounted;

  final void Function(bool value) onSavingChanged;
  final void Function(String? value) onError;

  final VoidCallback? onThemeChanged;

  Future<void> _saveQueue = Future<void>.value();
  int _pendingUpdates = 0;

  AppearanceSettings get _settings {
    final profiles = ref.read(
      appearanceProfilesProvider,
    );

    return profiles.forMode(
      getSelectedAppearance(),
    );
  }

  void dispose() {}

   // ===========================================================================
  // PERSISTENCE
  // ===========================================================================

  /// Profil réellement sélectionné pour les modifications.
  ///
  /// [AppThemeMode.system] n'est pas un profil personnalisable.
  /// Dans ce cas, on utilise le profil Aqua comme profil de référence.
  AppThemeMode get _editableProfileMode {
    final AppThemeMode selectedMode =
        getSelectedAppearance();

    if (selectedMode == AppThemeMode.system) {
      return AppThemeMode.aqua;
    }

    return selectedMode;
  }

  /// Ajoute une modification à la file de sauvegarde.
  ///
  /// Les modifications rapides effectuées depuis l'interface sont sérialisées
  /// afin d'éviter que plusieurs écritures SharedPreferences se chevauchent.
  Future<void> update(
    AppearanceSettingsUpdater change,
  ) async {
    if (!isMounted()) {
      return;
    }

    _pendingUpdates++;

    if (_pendingUpdates == 1) {
      onSavingChanged(true);
    }

    onError(null);

    final AppThemeMode profileMode =
        _editableProfileMode;

    _saveQueue = _saveQueue.then(
      (_) async {
        try {
          await ref
              .read(
                appearanceProfilesProvider.notifier,
              )
              .updateProfile(
                profileMode,
                change,
              );

          if (isMounted()) {
            onThemeChanged?.call();
          }
        } catch (e) {
          if (isMounted()) {
            onError(
              e.toString(),
            );
          }
        } finally {
          _pendingUpdates--;

          if (_pendingUpdates <= 0) {
            _pendingUpdates = 0;

            if (isMounted()) {
              onSavingChanged(false);
            }
          }
        }
      },
    );

    await _saveQueue;
  }

  // ===========================================================================
  // THEME MODE
  // ===========================================================================

  /// Change uniquement le mode actif de l'application.
  ///
  /// IMPORTANT :
  ///
  /// Cette opération ne modifie aucun des quatre profils :
  ///
  /// - Aqua
  /// - Classic
  /// - Light
  /// - Dark
  ///
  /// Elle change uniquement le mode actif et applique le profil correspondant.
  Future<void> changeThemeMode(
    AppThemeMode mode, {
    VoidCallback? onCompleted,
  }) async {
    if (!isMounted()) {
      return;
    }

    onSavingChanged(true);
    onError(null);

    try {
      await controller.changeThemeMode(
        mode,
      );

      if (!isMounted()) {
        return;
      }

      onCompleted?.call();
      onSavingChanged(false);
      onThemeChanged?.call();
    } catch (e) {
      if (!isMounted()) {
        return;
      }

      onSavingChanged(false);
      onError(
        e.toString(),
      );
    }
  }

  // ===========================================================================
  // PRESETS
  // ===========================================================================

  /// Applique un preset complet au profil correspondant.
  ///
  /// IMPORTANT :
  ///
  /// Un preset ne modifie pas arbitrairement le profil actuellement affiché.
  /// Il possède son propre [AppThemeMode] cible.
  ///
  /// Exemple :
  ///
  /// [GlassPreset.aquaFrost]
  ///     -> profil Aqua
  ///
  /// [GlassPreset.classicDark]
  ///     -> profil Classic
  ///
  /// [GlassPreset.classicSb]
  ///     -> profil Dark
  ///
  /// [GlassPreset.light]
  ///     -> profil Light
  ///
  /// [GlassPreset.dark]
  ///     -> profil Dark
 
 
Future<void> applyPreset(
  GlassPreset preset,
) async {
  if (!isMounted()) {
    return;
  }

  final AppThemeMode targetMode;

  switch (preset) {
    case GlassPreset.aquaFrost:
      targetMode = AppThemeMode.aqua;
      break;

    case GlassPreset.classicDark:
      targetMode = AppThemeMode.classic;
      break;

    case GlassPreset.classicSb:
      targetMode = AppThemeMode.dark;
      break;

    case GlassPreset.light:
      targetMode = AppThemeMode.light;
      break;

    case GlassPreset.dark:
      targetMode = AppThemeMode.dark;
      break;
  }

  // ---------------------------------------------------------------------------
  // Récupère le profil CIBLE du preset.
  //
  // Important :
  // On ne part pas du profil actuellement actif.
  // ---------------------------------------------------------------------------

  final AppearanceSettings targetSettings =
      ref
          .read(
            appearanceProfilesProvider,
          )
          .forMode(
            targetMode,
          );

  late final AppearanceSettings settings;

  switch (preset) {
    // -------------------------------------------------------------------------
    // AQUA
    // -------------------------------------------------------------------------

    case GlassPreset.aquaFrost:
      settings = targetSettings.copyWith(
        themeMode: AppThemeMode.aqua.name,
        glassStyle:
            GlassStyle.transparentAqua.name,
        enableBlur: true,
        blur: 20,
        enableNoise: true,
        noise: .3,
        enableGlow: true,
        glowOpacity: .25,
        glowBlur: 30,
        surfaceOpacity: .85,
      );
      break;

    // -------------------------------------------------------------------------
    // CLASSIC
    // -------------------------------------------------------------------------

    case GlassPreset.classicDark:
      settings = targetSettings.copyWith(
        themeMode: AppThemeMode.classic.name,
        glassStyle:
            GlassStyle.opaqueMat.name,
        enableBlur: false,
        enableNoise: false,
        enableBorder: true,
        borderOpacity: .3,
        surfaceOpacity: .95,
      );
      break;

    // -------------------------------------------------------------------------
    // DARK — CLASSIC SUBTLE
    // -------------------------------------------------------------------------

    case GlassPreset.classicSb:
      settings = targetSettings.copyWith(
        themeMode: AppThemeMode.dark.name,
        glassStyle:
            GlassStyle.classicSb.name,
        enableBlur: false,
        enableNoise: false,
        enableGlow: false,
        enableShadow: true,
        shadowBlur: 24,
        shadowOpacity: .25,
        shadowOffsetY: 12,
        surfaceOpacity: 1,
        borderRadius: 26,
        enableBorder: true,
        borderWidth: 1,
        borderOpacity: .3,
        gradientOpacity: 1,
      );
      break;

    // -------------------------------------------------------------------------
    // LIGHT
    // -------------------------------------------------------------------------

    case GlassPreset.light:
      settings = targetSettings.copyWith(
        themeMode: AppThemeMode.light.name,
        glassStyle:
            GlassStyle.solidClassic.name,
        surfaceOpacity: .9,
        enableShadow: true,
        enableBlur: false,
      );
      break;

    // -------------------------------------------------------------------------
    // DARK
    // -------------------------------------------------------------------------

    case GlassPreset.dark:
      settings = targetSettings.copyWith(
        themeMode: AppThemeMode.dark.name,
        glassStyle:
            GlassStyle.opaqueMat.name,
        surfaceOpacity: .95,
        enableShadow: true,
        enableBlur: true,
        blur: 10,
      );
      break;
  }

  if (!isMounted()) {
    return;
  }

  onSavingChanged(true);
  onError(null);

  try {
    // -------------------------------------------------------------------------
    // 1. Sauvegarde dans le profil correspondant au preset.
    // -------------------------------------------------------------------------

    await ref
        .read(
          appearanceProfilesProvider.notifier,
        )
        .updateProfile(
          targetMode,
          (_) => settings,
        );

    if (!isMounted()) {
      return;
    }

    // -------------------------------------------------------------------------
    // 2. Le preset ne change PAS automatiquement le mode actif.
    //
    // Si le preset concerne déjà le mode actif, on applique simplement
    // les nouveaux réglages immédiatement.
    // -------------------------------------------------------------------------

    final AppThemeMode activeMode =
        getSelectedAppearance();

    if (activeMode == targetMode) {
      await controller.changeThemeMode(
        targetMode,
      );
    }

    if (!isMounted()) {
      return;
    }

    onSavingChanged(false);
    onThemeChanged?.call();
  } catch (e) {
    if (!isMounted()) {
      return;
    }

    onSavingChanged(false);
    onError(
      e.toString(),
    );
  }
}

  // ===========================================================================
  // GLASS STYLE
  // ===========================================================================

  Future<void> changeGlassStyle(
    GlassStyle style,
  ) async {
    await update(
      (settings) => settings.copyWith(
        glassStyle: style.name,
      ),
    );
  }
 
  // ===========================================================================
  // COLORS
  // ===========================================================================

  Future<void> changeColor(
    int index,
    Color color,
    bool aqua,
  ) async {
    final AppearanceSettings settings =
        _settings;

    final List<int> colors = List<int>.from(
      aqua
          ? settings.aquaColors
          : settings.classicColors,
    );

    if (index < 0 ||
        index >= colors.length) {
      return;
    }

    colors[index] = color.value;

    await update(
      (current) {
        if (aqua) {
          return current.copyWith(
            aquaColors: colors,
          );
        }

        return current.copyWith(
          classicColors: colors,
        );
      },
    );
  }

  Future<void> pickColor(
    BuildContext context,
    int index,
    bool aqua,
  ) async {
    final AppearanceSettings settings =
        _settings;

    final List<int> values = aqua
        ? settings.aquaColors
        : settings.classicColors;

    if (index < 0 ||
        index >= values.length) {
      return;
    }

    final Color? color =
        await AppearanceColorPicker.show(
      context,
      initialColor: Color(values[index]),
    );

    if (color == null ||
        !isMounted()) {
      return;
    }

    await changeColor(
      index,
      color,
      aqua,
    );
  }

  // ===========================================================================
  // APP BAR
  // ===========================================================================

  /// Met à jour les réglages visuels de l'AppBar du profil actif.
  ///
  /// Les paramètres contextuels de [UniversalAppBar] tels que :
  /// - showLogo
  /// - title
  /// - subtitle
  /// - showBackButton
  /// - onBack
  /// - actions
  /// - tabs
  /// - hideNavigation
  ///
  /// restent volontairement exclus.
  ///
  /// Ici, seuls les paramètres d'apparence et de layout global de l'AppBar
  /// sont persistés dans [AppearanceAppBarSettings].
  Future<void> updateAppBar({
    bool? enabled,
    bool? useGradientBackground,
    bool? compactMode,
    double? height,
    bool clearHeight = false,
    double? actionBackgroundOpacity,
    double? actionAccentOpacity,
    double? actionBorderOpacity,
    double? actionBorderWidth,
    double? actionShadowOpacity,
    double? actionShadowBlur,
    double? actionShadowOffsetY,
    double? shadowOpacity,
  }) async {
    await update(
      (settings) {
        return settings.copyWith(
          appBar: settings.appBar.copyWith(
            enabled: enabled,
            useGradientBackground:
                useGradientBackground,
            compactMode: compactMode,
            height: height,
            clearHeight: clearHeight,
            actionBackgroundOpacity:
                actionBackgroundOpacity,
            actionAccentOpacity:
                actionAccentOpacity,
            actionBorderOpacity:
                actionBorderOpacity,
            actionBorderWidth:
                actionBorderWidth,
            actionShadowOpacity:
                actionShadowOpacity,
            actionShadowBlur:
                actionShadowBlur,
            actionShadowOffsetY:
                actionShadowOffsetY,
            shadowOpacity:
                shadowOpacity,
          ),
        );
      },
    );
  }

  /// Active ou désactive l'AppBar pour le profil actif.
  Future<void> setAppBarEnabled(
    bool value,
  ) async {
    await updateAppBar(
      enabled: value,
    );
  }

  /// Active ou désactive le fond gradient de l'AppBar.
  Future<void> setAppBarGradientBackground(
    bool value,
  ) async {
    await updateAppBar(
      useGradientBackground: value,
    );
  }

  /// Active ou désactive le mode compact de l'AppBar.
  Future<void> setAppBarCompactMode(
    bool value,
  ) async {
    await updateAppBar(
      compactMode: value,
    );
  }

  /// Définit une hauteur personnalisée.
  ///
  /// Passe [null] ou [clearHeight] pour revenir à la hauteur responsive.
  Future<void> setAppBarHeight(
    double? value,
  ) async {
    await updateAppBar(
      height: value,
      clearHeight: value == null,
    );
  }

  /// Restaure la hauteur responsive automatique.
  Future<void> resetAppBarHeight() async {
    await updateAppBar(
      clearHeight: true,
    );
  }

  /// Modifie les paramètres visuels des boutons d'action.
  Future<void> updateAppBarActions({
    double? backgroundOpacity,
    double? accentOpacity,
    double? borderOpacity,
    double? borderWidth,
    double? shadowOpacity,
    double? shadowBlur,
    double? shadowOffsetY,
  }) async {
    await updateAppBar(
      actionBackgroundOpacity:
          backgroundOpacity,
      actionAccentOpacity:
          accentOpacity,
      actionBorderOpacity:
          borderOpacity,
      actionBorderWidth:
          borderWidth,
      actionShadowOpacity:
          shadowOpacity,
      actionShadowBlur:
          shadowBlur,
      actionShadowOffsetY:
          shadowOffsetY,
    );
  }

  /// Modifie l'opacité de l'ombre générale de l'AppBar.
  Future<void> setAppBarShadowOpacity(
    double value,
  ) async {
    await updateAppBar(
      shadowOpacity: value,
    );
  }
  // ===========================================================================
  // RESET
  // ===========================================================================

  Future<void> reset() async {
    if (!isMounted()) {
      return;
    }

    onSavingChanged(true);
    onError(null);

    try {
      await ref
          .read(
            appearanceProfilesProvider.notifier,
          )
          .resetProfiles();

      if (!isMounted()) {
        return;
      }

      onSavingChanged(false);
      onThemeChanged?.call();
    } catch (e) {
      if (!isMounted()) {
        return;
      }

      onSavingChanged(false);
      onError(e.toString());
    }
  }
}