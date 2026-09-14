
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:universal_glass/components/surface/glass_surface_config.dart';
import 'package:universal_glass/components/surface/glass_surface_renderer.dart';
import 'package:universal_glass/enums/glass_enums.dart';
import 'package:universal_glass/provider/glass_theme_provider.dart';
import 'package:universal_glass/provider/glass_theme_state.dart';
import 'package:universal_glass/settings/widgets/glass_color_storage.dart';
import 'package:universal_glass/theme/glass_effects.dart';
import 'package:universal_glass/utils/glass_input_decoration.dart';

/// Conteneur principal d'une surface Universal Glass.
///
/// Cette classe orchestre la surface sans gérer directement son rendu.
///
/// Responsabilités :
///
/// - récupérer le thème global ;
/// - résoudre le [GlassStyle] effectif ;
/// - charger les gradients persistés ;
/// - fusionner les effets locaux et globaux ;
/// - transmettre le [GlassSurfaceRole] ;
/// - gérer l'état de hover ;
/// - construire le [GlassSurfaceConfig] ;
/// - déléguer le rendu à [GlassSurfaceRenderer].
///
/// Le rendu visuel réel est volontairement délégué au renderer.
class GlassSurfaceContainer extends ConsumerStatefulWidget {
  final Widget child;

  final GlassInputDecoration decoration;

  /// Style local de la surface.
  ///
  /// Si `null`, le style du thème global est utilisé.
  final GlassStyle? style;

  final GlassShapeType shape;

  /// Effets locaux éventuels.
  ///
  /// Les paramètres globaux du thème restent prioritaires
  /// pour les valeurs contrôlées globalement.
  final GlassEffects? effects;

  /// Rôle fonctionnel de la surface.
  ///
  /// Permet au moteur Glass d'adapter automatiquement :
  ///
  /// - la densité ;
  /// - la transparence ;
  /// - le blur ;
  /// - le noise ;
  /// - la profondeur ;
  /// - le contraste.
  ///
  /// Exemples :
  ///
  /// - [GlassSurfaceRole.card]
  /// - [GlassSurfaceRole.field]
  /// - [GlassSurfaceRole.panel]
  /// - [GlassSurfaceRole.dialog]
  /// - [GlassSurfaceRole.modal]
  /// - [GlassSurfaceRole.header]
  /// - [GlassSurfaceRole.body]
  /// - [GlassSurfaceRole.footer]
  final GlassSurfaceRole role;

  final bool isFocused;
  final bool hasError;
  final String? errorText;
  final bool enabled;

  final VoidCallback? onTap;

  final double? width;
  final double? height;

  final BoxConstraints? constraints;

  final EdgeInsetsGeometry? padding;

  final BorderRadius? borderRadius;

  /// Autorise le déplacement léger au survol.
  final bool liftOnHover;

  final Clip clipBehavior;

  /// Couleurs personnalisées Aqua.
  final List<Color>? customColorsAqua;

  /// Couleurs personnalisées Classic.
  final List<Color>? customColorsClassic;

  /// Gradient personnalisé fourni directement.
  final List<Color>? customGradient;

  /// Clé utilisée pour récupérer un gradient sauvegardé.
  final String? customKey;

  /// Désactive le blur et le noise de la surface.
  final bool disableBackdropEffects;

  /// Désactive les ombres de la surface.
  final bool disableShadow;

  /// Couleur de fond locale éventuelle.
  final Color? backgroundColor;

  /// Opacité locale du fond.
  final double backgroundOpacity;

  const GlassSurfaceContainer({
    super.key,
    required this.child,
    this.decoration = const GlassInputDecoration(),
    this.style,
    this.shape = GlassShapeType.squareRounded,
    this.effects,
    this.role = GlassSurfaceRole.card,
    this.isFocused = false,
    this.hasError = false,
    this.errorText,
    this.enabled = true,
    this.onTap,
    this.width,
    this.height,
    this.constraints,
    this.padding,
    this.borderRadius,
    this.liftOnHover = true,
    this.clipBehavior = Clip.antiAlias,
    this.customColorsAqua,
    this.customColorsClassic,
    this.customGradient,
    this.customKey,
    this.disableBackdropEffects = false,
    this.disableShadow = false,
    this.backgroundColor,
    this.backgroundOpacity = 1.0,
  });

  @override
  ConsumerState<GlassSurfaceContainer> createState() =>
      _GlassSurfaceContainerState();
}

class _GlassSurfaceContainerState
    extends ConsumerState<GlassSurfaceContainer> {
  bool _isHovered = false;

  List<Color>? _loadedGradient;

  bool _loading = false;

  bool _lastUseAqua = true;

  GlassStyle? _lastStyle;

  String? _lastCustomKey;

  List<Color>? _lastCustomGradient;

  @override
  void initState() {
    super.initState();

    final GlassThemeState theme =
        ref.read(glassThemeProvider);

    _lastUseAqua = theme.useAquaStyle;
    _lastStyle = widget.style ?? theme.glassStyle;
    _lastCustomKey = widget.customKey;
    _lastCustomGradient = widget.customGradient;

    _loadIfNeeded();
  }

  @override
  void didUpdateWidget(
    covariant GlassSurfaceContainer oldWidget,
  ) {
    super.didUpdateWidget(oldWidget);

    final GlassThemeState theme =
        ref.read(glassThemeProvider);

    final GlassStyle currentStyle =
        widget.style ?? theme.glassStyle;

    final bool customGradientChanged =
        !_areColorsEqual(
      widget.customGradient,
      _lastCustomGradient,
    );

    final bool customKeyChanged =
        widget.customKey != _lastCustomKey;

    final bool aquaChanged =
        theme.useAquaStyle != _lastUseAqua;

    final bool styleChanged =
        currentStyle != _lastStyle;

    if (!customGradientChanged &&
        !customKeyChanged &&
        !aquaChanged &&
        !styleChanged) {
      return;
    }

    _lastUseAqua = theme.useAquaStyle;
    _lastStyle = currentStyle;
    _lastCustomKey = widget.customKey;
    _lastCustomGradient = widget.customGradient;

    _loadIfNeeded();
  }

  // ===========================================================================
  // GRADIENT
  // ===========================================================================

  /// Détermine si le gradient doit être chargé depuis le stockage.
  bool _needsStoredGradient(GlassStyle style) {
    return widget.customKey != null ||
        style == GlassStyle.customGradient;
  }

  /// Charge le gradient uniquement lorsqu'il est nécessaire.
  Future<void> _loadIfNeeded() async {
    final GlassThemeState theme =
        ref.read(glassThemeProvider);

    final GlassStyle effectiveStyle =
        widget.style ?? theme.glassStyle;

    final bool needsStoredGradient =
        _needsStoredGradient(effectiveStyle);

    // -------------------------------------------------------------------------
    // Aucun gradient persistant à charger.
    // -------------------------------------------------------------------------

    if (!needsStoredGradient) {
      if (!mounted) {
        return;
      }

      setState(() {
        _loadedGradient = widget.customGradient;
        _loading = false;
      });

      return;
    }

    // -------------------------------------------------------------------------
    // Un gradient personnalisé fourni directement est prioritaire.
    // -------------------------------------------------------------------------

    if (widget.customGradient != null) {
      if (!mounted) {
        return;
      }

      setState(() {
        _loadedGradient = widget.customGradient;
        _loading = false;
      });

      return;
    }

    if (mounted) {
      setState(() {
        _loading = true;
      });
    }

    await _loadCustomGradient(effectiveStyle);
  }

  /// Charge un gradient utilisateur ou un gradient prédéfini.
  Future<void> _loadCustomGradient(
    GlassStyle effectiveStyle,
  ) async {
    final GlassThemeState theme =
        ref.read(glassThemeProvider);

    List<Color>? loaded;

    // -------------------------------------------------------------------------
    // 1. Gradient utilisateur.
    // -------------------------------------------------------------------------

    if (widget.customKey != null) {
      loaded = await GlassColorStorage.loadUserGradient(
        widget.customKey!,
        useAqua: theme.useAquaStyle,
      );
    }

    // -------------------------------------------------------------------------
    // 2. Gradient prédéfini.
    // -------------------------------------------------------------------------

    if (loaded == null &&
        effectiveStyle == GlassStyle.customGradient) {
      loaded = await GlassColorStorage.loadPresetGradient(
        effectiveStyle,
        useAqua: theme.useAquaStyle,
      );
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _loadedGradient = loaded;
      _loading = false;
    });
  }

  // ===========================================================================
  // COMPARAISON DES COULEURS
  // ===========================================================================

  /// Compare deux listes de couleurs sans dépendre de leur identité objet.
  bool _areColorsEqual(
    List<Color>? first,
    List<Color>? second,
  ) {
    if (identical(first, second)) {
      return true;
    }

    if (first == null || second == null) {
      return false;
    }

    if (first.length != second.length) {
      return false;
    }

    for (int i = 0; i < first.length; i++) {
      if (first[i] != second[i]) {
        return false;
      }
    }

    return true;
  }

  // ===========================================================================
  // BUILD
  // ===========================================================================

  @override
  Widget build(BuildContext context) {
    final GlassThemeState theme =
        ref.watch(glassThemeProvider);

    final GlassStyle effectiveStyle =
        widget.style ?? theme.glassStyle;

    final bool needsStoredGradient =
        _needsStoredGradient(effectiveStyle);

    // Pendant le chargement d'un gradient persistant, on évite
    // d'afficher une surface dans un état intermédiaire.
    if (_loading && needsStoredGradient) {
      return const SizedBox.shrink();
    }

    // =========================================================================
    // EFFETS DE BASE
    // =========================================================================




    final GlassEffects baseEffects =
        widget.effects ?? GlassEffects.defaults();

    // =========================================================================
    // BLUR / NOISE
    // =========================================================================
    //
    // Le thème reste la source globale.
    //
    // disableBackdropEffects constitue une exception locale explicite.
    // =========================================================================

    final double effectiveBlur =
        widget.disableBackdropEffects
            ? 0.0
            : theme.effectiveBlur;

    final double effectiveNoise =
        widget.disableBackdropEffects
            ? 0.0
            : theme.effectiveNoise;

    // =========================================================================
    // EFFETS EFFECTIFS
    // =========================================================================

const double appBarOpacity = 0.94;

final double requestedSurfaceOpacity =
    widget.backgroundOpacity.clamp(0.0, 1.0);

final double effectiveSurfaceOpacity =
    widget.role == GlassSurfaceRole.appBar
        ? requestedSurfaceOpacity.clamp(
            appBarOpacity,
            1.0,
          )
        : requestedSurfaceOpacity;

final GlassEffects effectiveEffects =
    baseEffects.copyWith(
  bgBlur: effectiveBlur,
  bgNoise: effectiveNoise,

  blur: effectiveBlur,
  noise: effectiveNoise,

  surfaceOpacity: effectiveSurfaceOpacity,

      enableBorder:
          theme.enableBorder,

      borderRadius:
          theme.borderRadius,

      borderOpacity:
          theme.borderOpacity,

      borderWidth:
          theme.borderWidth,

      enableGlow:
          theme.enableGlow,

      glowOpacity:
          theme.glowOpacity,

      glowBlur:
          theme.glowBlur,

      enableShadow:
          widget.disableShadow
              ? false
              : theme.enableShadow,

      shadowOpacity:
          theme.shadowOpacity,

      shadowBlur:
          theme.shadowBlur,

      shadowOffsetY:
          theme.shadowOffsetY,
    );

    // =========================================================================
    // HOVER
    // =========================================================================

    final bool effectiveLiftOnHover =
        widget.liftOnHover &&
        theme.enableHover;

    // =========================================================================
    // CONFIGURATION DU RENDERER
    // =========================================================================

    final GlassSurfaceConfig config =
        GlassSurfaceConfig(
      style: effectiveStyle,

      shape: widget.shape,

      effects: effectiveEffects,

      theme: theme,

      role: widget.role,

      isFocused: widget.isFocused,

      hasError: widget.hasError,

      enabled: widget.enabled,

      isHovered: _isHovered,

      liftOnHover: effectiveLiftOnHover,

      borderColor:
          widget.decoration.borderColor,

      focusBorderColor:
          widget.decoration.focusBorderColor,

      borderWidth:
          widget.decoration.borderWidth,

      focusBorderWidth:
          widget.decoration.focusBorderWidth,

      errorBorderWidth:
          widget.decoration.errorBorderWidth,

      customColorsAqua:
          widget.customColorsAqua,

      customColorsClassic:
          widget.customColorsClassic,

      customGradient:
          widget.customGradient,

      loadedGradient:
          _loadedGradient,

      customKey:
          widget.customKey,

      backgroundColor:
          widget.backgroundColor,
    );

    // =========================================================================
    // BORDER RADIUS
    // =========================================================================

    final BorderRadius effectiveRadius =
        widget.borderRadius ??
        BorderRadius.circular(
          theme.borderRadius.clamp(
            0.0,
            160.0,
          ),
        );

    // =========================================================================
    // RENDERER
    // =========================================================================

    return GlassSurfaceRenderer(
      width: widget.width,

      height: widget.height,

      constraints: widget.constraints,

      padding: widget.padding,

      borderRadius: effectiveRadius,

      clipBehavior: widget.clipBehavior,

      errorText: widget.errorText,

      onTap: widget.onTap,

      decoration: widget.decoration,

      config: config,

      onHoverChanged: (bool value) {
        if (!mounted) {
          return;
        }

        if (_isHovered == value) {
          return;
        }

        setState(() {
          _isHovered = value;
        });
      },

      child: widget.child,
    );
  }
}
