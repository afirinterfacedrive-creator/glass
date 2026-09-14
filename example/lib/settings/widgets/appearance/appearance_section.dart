
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:universal_glass/glass.dart';
import 'package:universal_glass_example/settings/widgets/appearance/appearance_profiles.dart';

import 'package:universal_glass_example/settings/widgets/appearance/appearance_profiles_provider.dart';
import 'package:universal_glass_example/settings/widgets/appearance/widgets/appearance_color_picker.dart';

import 'appearance_controller.dart';
import 'appearance_profiles_codec.dart';
import 'appearance_section_builders.dart';
import 'appearance_settings.dart';

class AppearanceSection extends ConsumerStatefulWidget {
  final VoidCallback? onThemeChanged;

  const AppearanceSection({
    super.key,
    this.onThemeChanged,
  });

  @override
  ConsumerState<AppearanceSection> createState() =>
      _AppearanceSectionState();
}

class _AppearanceSectionState
    extends ConsumerState<AppearanceSection> {
  late final AppearanceController _controller;

  // ===========================================================================
  // STATE
  // ===========================================================================

  /// Mode réellement actif.
  ///
  /// Peut être [AppThemeMode.system].
  AppThemeMode _activeMode = AppThemeMode.aqua;

  /// Profil actuellement sélectionné pour être personnalisé.
  ///
  /// [AppThemeMode.system] n'est jamais un profil éditable.
  AppThemeMode _selectedAppearance = AppThemeMode.aqua;

  bool _loading = true;
  bool _saving = false;

  String? _error;

  /// Permet de distinguer une erreur de chargement
  /// d'une erreur de sauvegarde.
  bool _loadFailed = false;

  /// File d'attente des sauvegardes.
  ///
  /// Les sliders peuvent générer énormément d'événements successifs.
  /// Toutes les modifications sont donc exécutées dans l'ordre.
  Future<void> _saveQueue = Future<void>.value();

  int _pendingUpdates = 0;

  // ===========================================================================
  // INIT
  // ===========================================================================

  @override
  void initState() {
    super.initState();

    _controller = ref.read(
      appearanceControllerProvider,
    );

    _load();
  }

  // ===========================================================================
  // LOAD
  // ===========================================================================

  Future<void> _load() async {
    try {
      final AppThemeMode activeMode =
          _controller.activeMode;

      final AppThemeMode selectedAppearance =
          activeMode == AppThemeMode.system
              ? AppThemeMode.aqua
              : activeMode;

      if (!mounted) {
        return;
      }

      setState(() {
        _activeMode = activeMode;
        _selectedAppearance = selectedAppearance;
        _loading = false;
        _loadFailed = false;
        _error = null;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        _loading = false;
        _loadFailed = true;
        _error = e.toString();
      });
    }
  }

  // ===========================================================================
  // UPDATE PROFILE
  // ===========================================================================

  Future<void> _update(
    AppearanceSettings Function(
      AppearanceSettings settings,
    ) change,
  ) async {
    if (!mounted) {
      return;
    }

    _pendingUpdates++;

    if (!_saving) {
      setState(() {
        _saving = true;
        _error = null;
      });
    } else if (_error != null) {
      setState(() {
        _error = null;
      });
    }

    /// Le profil est capturé au moment où la modification
    /// est déclenchée.
    ///
    /// Ainsi, si l'utilisateur change de profil pendant
    /// qu'une sauvegarde est en cours, la modification
    /// reste appliquée au profil d'origine.
    final AppThemeMode profileMode =
        _selectedAppearance;

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

          if (!mounted) {
            return;
          }

          widget.onThemeChanged?.call();
        } catch (e) {
          if (!mounted) {
            return;
          }

          setState(() {
            _error = e.toString();
          });
        } finally {
          _pendingUpdates--;

          if (_pendingUpdates <= 0 && mounted) {
            _pendingUpdates = 0;

            setState(() {
              _saving = false;
            });
          }
        }
      },
    );

    await _saveQueue;
  }

  // ===========================================================================
  // APPEARANCE PROFILE
  // ===========================================================================

  void _selectAppearance(
    AppThemeMode mode,
  ) {
    /// system n'est pas un profil éditable.
    if (mode == AppThemeMode.system) {
      return;
    }

    if (_saving) {
      return;
    }

    setState(() {
      _selectedAppearance = mode;
      _error = null;
    });
  }

  // ===========================================================================
  // THEME MODE
  // ===========================================================================

  Future<void> _changeThemeMode(
    AppThemeMode mode,
  ) async {
    if (_saving) {
      return;
    }

    setState(() {
      _saving = true;
      _error = null;
    });

    try {
      /// IMPORTANT :
      /// le controller reçoit directement AppThemeMode.
      ///
      /// Ne jamais envoyer mode.name ici.
      await _controller.changeThemeMode(
        mode,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _activeMode = mode;

        /// system n'est pas éditable.
        ///
        /// On conserve donc le dernier profil sélectionné.
        if (mode != AppThemeMode.system) {
          _selectedAppearance = mode;
        }

        _saving = false;
      });

      widget.onThemeChanged?.call();
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        _saving = false;
        _error = e.toString();
      });
    }
  }

  // ===========================================================================
  // PRESET
  // ===========================================================================

  Future<void> _applyPreset(
    GlassPreset preset,
  ) async {
    if (_saving) {
      return;
    }

    // -------------------------------------------------------------------------
    // Déterminer le profil auquel appartient le preset.
    // -------------------------------------------------------------------------

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

    // -------------------------------------------------------------------------
    // Lire le profil cible.
    // -------------------------------------------------------------------------

    final AppearanceSettings targetSettings =
        ref
            .read(
              appearanceProfilesProvider,
            )
            .forMode(
              targetMode,
            );

    late final AppearanceSettings settings;

    // -------------------------------------------------------------------------
    // Construire le preset à partir du profil cible.
    //
    // IMPORTANT :
    // On ne part PAS de _settings, car _settings représente
    // le profil actuellement sélectionné.
    // -------------------------------------------------------------------------

    switch (preset) {
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

      case GlassPreset.classicDark:
        settings = targetSettings.copyWith(
          themeMode: AppThemeMode.classic.name,
          glassStyle:
              GlassStyle.opaqueMat.name,
          enableBlur: false,
          blur: 0,
          enableNoise: false,
          noise: 0,
          enableBorder: true,
          borderOpacity: .3,
          surfaceOpacity: .95,
        );
        break;

      case GlassPreset.classicSb:
        settings = targetSettings.copyWith(
          themeMode: AppThemeMode.dark.name,
          glassStyle:
              GlassStyle.classicSb.name,
          enableBlur: false,
          blur: 0,
          enableNoise: false,
          noise: 0,
          enableGlow: false,
          glowOpacity: 0,
          glowBlur: 0,
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

      case GlassPreset.light:
        settings = targetSettings.copyWith(
          themeMode: AppThemeMode.light.name,
          glassStyle:
              GlassStyle.solidClassic.name,
          surfaceOpacity: .9,
          enableShadow: true,
          shadowBlur: 12,
          shadowOpacity: .18,
          enableBlur: false,
          blur: 0,
        );
        break;

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

    if (!mounted) {
      return;
    }

    setState(() {
      _saving = true;
      _error = null;
    });

    try {
      // -----------------------------------------------------------------------
      // Modifier UNIQUEMENT le profil cible.
      // -----------------------------------------------------------------------

      await ref
          .read(
            appearanceProfilesProvider.notifier,
          )
          .updateProfile(
            targetMode,
            (_) => settings,
          );

      if (!mounted) {
        return;
      }

      // -----------------------------------------------------------------------
      // Le preset ne change PAS automatiquement le mode actif.
      //
      // Si le profil ciblé est déjà actif, on le réapplique visuellement.
      // -----------------------------------------------------------------------

      if (_activeMode == targetMode) {
        await _controller.changeThemeMode(
          targetMode,
        );
      }

      if (!mounted) {
        return;
      }

      setState(() {
        _saving = false;
      });

      widget.onThemeChanged?.call();
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        _saving = false;
        _error = e.toString();
      });
    }
  }

  // ===========================================================================
  // GLASS STYLE
  // ===========================================================================

  Future<void> _changeGlassStyle(
    GlassStyle style,
  ) async {
    await _update(
      (settings) => settings.copyWith(
        glassStyle: style.name,
      ),
    );
  }

  // ===========================================================================
  // COLOR
  // ===========================================================================

  Future<void> _changeColor(
    int index,
    Color color,
    bool aqua,
  ) async {
    final AppearanceSettings settings =
        _settings;

    final List<int> colors =
        List<int>.from(
      aqua
          ? settings.aquaColors
          : settings.classicColors,
    );

    if (index < 0 ||
        index >= colors.length) {
      return;
    }

    colors[index] = color.value;

    await _update(
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

  Future<void> _pickColor(
    BuildContext context,
    int index,
    bool aqua,
  ) async {
    final AppearanceSettings settings =
        _settings;

    final List<Color> colors =
        aqua
            ? _toColors(
                settings.aquaColors,
              )
            : _toColors(
                settings.classicColors,
              );

    if (index < 0 ||
        index >= colors.length) {
      return;
    }

    final Color? color =
        await AppearanceColorPicker.show(
      context,
      initialColor: colors[index],
    );

    if (color == null ||
        !mounted) {
      return;
    }

    await _changeColor(
      index,
      color,
      aqua,
    );
  }

  // ===========================================================================
  // IMPORT
  // ===========================================================================
// ===========================================================================
// IMPORT
// ===========================================================================

Future<void> _importAppearance() async {
  if (_saving) {
    return;
  }

  setState(() {
    _saving = true;
    _error = null;
  });

  try {
    /// Le notifier est la porte d'entrée de l'import.
    ///
    /// Il délègue au controller/service, puis met à jour
    /// son propre state avec les profils importés.
    final AppearanceProfilesDocument? imported =
        await ref
            .read
            (
              appearanceProfilesProvider.notifier,
            )
            .importProfiles();

    if (!mounted) {
      return;
    }

    /// null = utilisateur a annulé la sélection du fichier.
    if (imported == null) {
      setState(() {
        _saving = false;
      });
      return;
    }

    final AppThemeMode activeMode =
        imported.activeMode;

    /// Le mode System n'est pas un profil personnalisable.
    /// L'interface utilise donc Aqua comme représentation visuelle
    /// lorsque le mode actif est System.
    final AppThemeMode selectedAppearance =
        activeMode == AppThemeMode.system
            ? AppThemeMode.aqua
            : activeMode;

    setState(() {
      _activeMode = activeMode;
      _selectedAppearance = selectedAppearance;
      _saving = false;
      _error = null;
    });

    widget.onThemeChanged?.call();
  } catch (e) {
    if (!mounted) {
      return;
    }

    setState(() {
      _saving = false;
      _error = e.toString();
    });
  }
}

// ===========================================================================
// EXPORT
// ===========================================================================

Future<void> _exportAppearance() async {
  if (_saving) {
    return;
  }

  setState(() {
    _saving = true;
    _error = null;
  });

  try {
    /// Le notifier est la porte d'entrée de l'export.
    ///
    /// Cela garde import/export cohérents et évite que cette
    /// section manipule directement AppearanceProfilesService.
    final String? result =
        await ref
            .read(
              appearanceProfilesProvider.notifier,
            )
            .exportProfiles();

    if (!mounted) {
      return;
    }

    setState(() {
      _saving = false;
    });

    /// Une valeur non vide signifie que l'export a été effectué.
    ///
    /// null ou chaîne vide peut simplement correspondre à une
    /// annulation ou à une plateforme qui ne retourne pas de chemin.
    if (result != null && result.trim().isNotEmpty) {
      return;
    }
  } catch (e) {
    if (!mounted) {
      return;
    }

    setState(() {
      _saving = false;
      _error = e.toString();
    });
  }
}
  // ===========================================================================
  // RESET
  // ===========================================================================

  Future<void> _reset() async {
    if (_saving) {
      return;
    }

    setState(() {
      _saving = true;
      _error = null;
    });

    try {
      await ref
          .read(
            appearanceProfilesProvider.notifier,
          )
          .resetProfiles();

      final AppThemeMode activeMode =
          _controller.activeMode;

      final AppThemeMode selectedAppearance =
          activeMode == AppThemeMode.system
              ? AppThemeMode.aqua
              : activeMode;

      if (!mounted) {
        return;
      }

      setState(() {
        _activeMode = activeMode;
        _selectedAppearance = selectedAppearance;
        _saving = false;
        _error = null;
      });

      widget.onThemeChanged?.call();
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        _saving = false;
        _error = e.toString();
      });
    }
  }

  // ===========================================================================
  // SETTINGS
  // ===========================================================================

  AppearanceSettings get _settings {
    final AppearanceProfiles profiles =
        ref.read(
      appearanceProfilesProvider,
    );

    return profiles.forMode(
      _selectedAppearance,
    );
  }

  // ===========================================================================
  // HELPERS
  // ===========================================================================

  List<Color> _toColors(
    List<int> values,
  ) {
    return values
        .map(Color.new)
        .toList(
          growable: false,
        );
  }

  // ===========================================================================
  // BUILD
  // ===========================================================================

  @override
  Widget build(
    BuildContext context,
  ) {
    if (_loading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_loadFailed) {
      return AppearanceSectionBuilders.buildError(
        error: _error,
        onRetry: _load,
      );
    }

    final AppearanceSettings settings =
        ref.watch(
      appearanceProfileProvider(
        _selectedAppearance,
      ),
    );

    final AppearanceSectionBuilders builders =
        AppearanceSectionBuilders(
      saving: _saving,
      error: _error,
      activeMode: _activeMode,
      selectedAppearance: _selectedAppearance,
      onPreset: _applyPreset,
      onThemeMode: _changeThemeMode,
      onSelectAppearance: _selectAppearance,
      onPickColor: _pickColor,
      onUpdate: _update,
      onGlassStyle: _changeGlassStyle,
      onReset: _reset,

      // Import / Export
      onImport: _importAppearance,
      onExport: _exportAppearance,
    );

    return builders.build(
      context,
      settings,
    );
  }
}
