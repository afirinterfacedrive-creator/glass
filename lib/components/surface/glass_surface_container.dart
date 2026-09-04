import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:universal_glass/components/inputs/glass_input_decoration.dart';
import 'package:universal_glass/components/surface/glass_surface_config.dart';
import 'package:universal_glass/components/surface/glass_surface_renderer.dart';
import 'package:universal_glass/enums/glass_enums.dart';
import 'package:universal_glass/provider/glass_theme_provider.dart';
import 'package:universal_glass/settings/widgets/glass_color_storage.dart';
import 'package:universal_glass/theme/glass_effects.dart';

class GlassSurfaceContainer extends ConsumerStatefulWidget {
  // ===========================================================================
  // CONTENU
  // ===========================================================================
  final Widget child;
  final GlassInputDecoration decoration;

  // ===========================================================================
  // STYLE
  // ===========================================================================
  final GlassStyle? style;
  final GlassShapeType shape;
  final GlassEffects? effects;

  // ===========================================================================
  // ETATS
  // ===========================================================================
  final bool isFocused;
  final bool hasError;
  final String? errorText;
  final bool enabled;
  final VoidCallback? onTap;

  // ===========================================================================
  // DIMENSIONS
  // ===========================================================================
  final double? width;
  final double? height;
  final BoxConstraints? constraints;
  final EdgeInsetsGeometry? padding;

  // ===========================================================================
  // RAYON
  // ===========================================================================
  final BorderRadius? borderRadius;

  // ===========================================================================
  // INTERACTION
  // ===========================================================================
  final bool liftOnHover;
  final Clip clipBehavior;

  // ===========================================================================
  // COULEURS / GRADIENTS
  // ===========================================================================
  final List<Color>? customColorsAqua;
  final List<Color>? customColorsClassic;
  final List<Color>? customGradient;
  final String? customKey;

  // ===========================================================================
  // BACKDROP
  // ===========================================================================
  final bool disableBackdropEffects;
  // ===========================================================================
// BACKDROP / OMBRE

final bool disableShadow;

  // ===========================================================================
  // CONSTRUCTEUR
  // ===========================================================================
  const GlassSurfaceContainer({
    super.key,
    required this.child,
    this.decoration = const GlassInputDecoration(),
    this.style,
    this.shape = GlassShapeType.squareRounded,
    this.effects,
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
  });

  @override
  ConsumerState<GlassSurfaceContainer> createState() =>
      _GlassSurfaceContainerState();
}

// =============================================================================
// STATE
// =============================================================================
class _GlassSurfaceContainerState
    extends ConsumerState<GlassSurfaceContainer> {
  bool _isHovered = false;
  List<Color>? _loadedGradient;
  bool _loading = true;
  bool _lastUseAqua = true;
  GlassStyle? _lastStyle;

  @override
  void initState() {
    super.initState();
    final GlassThemeState theme = ref.read(glassThemeProvider);
    _lastUseAqua = theme.useAquaStyle;
    _lastStyle = widget.style ?? theme.glassStyle;
    _loadIfNeeded();
  }

  @override
  void didUpdateWidget(covariant GlassSurfaceContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    final GlassThemeState theme = ref.read(glassThemeProvider);
    final GlassStyle currentStyle = widget.style ?? theme.glassStyle;
    final bool customGradientChanged = widget.customGradient != oldWidget.customGradient;
    final bool customKeyChanged = widget.customKey != oldWidget.customKey;
    final bool aquaChanged = theme.useAquaStyle != _lastUseAqua;
    final bool styleChanged = currentStyle != _lastStyle;

    if (customGradientChanged || customKeyChanged || aquaChanged || styleChanged) {
      _lastUseAqua = theme.useAquaStyle;
      _lastStyle = currentStyle;
      _loadIfNeeded();
    }
  }

  Future<void> _loadIfNeeded() async {
    final GlassThemeState theme = ref.read(glassThemeProvider);
    final GlassStyle effectiveStyle = widget.style ?? theme.glassStyle;
    final bool needsStoredGradient = widget.customKey != null || effectiveStyle == GlassStyle.customGradient;

    if (!needsStoredGradient) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _loadedGradient = widget.customGradient;
      });
      return;
    }

    if (mounted) {
      setState(() => _loading = true);
    }
    await _loadCustomGradient(effectiveStyle);
  }

  Future<void> _loadCustomGradient(GlassStyle effectiveStyle) async {
    final GlassThemeState theme = ref.read(glassThemeProvider);
    List<Color>? loaded;

    if (widget.customKey != null) {
      loaded = await GlassColorStorage.loadUserGradient(
        widget.customKey!,
        useAqua: theme.useAquaStyle,
      );
    }

    if (loaded == null && effectiveStyle == GlassStyle.customGradient) {
      loaded = await GlassColorStorage.loadPresetGradient(
        theme.glassStyle,
        useAqua: theme.useAquaStyle,
      );
    }

    if (!mounted) return;
    setState(() {
      _loadedGradient = loaded;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final GlassThemeState theme = ref.watch(glassThemeProvider);
    final GlassStyle effectiveStyle = widget.style ?? theme.glassStyle;
    final bool needsStoredGradient = widget.customKey != null || effectiveStyle == GlassStyle.customGradient;

    if (_loading && needsStoredGradient) {
      return const SizedBox.shrink();
    }

    final GlassEffects baseEffects = widget.effects ?? GlassEffects.defaults();

    final double effectiveBlur = widget.disableBackdropEffects ? 0.0 : theme.effectiveBlur;
    final double effectiveNoise = widget.disableBackdropEffects ? 0.0 : theme.effectiveNoise;

    final GlassEffects effectiveEffects = baseEffects.copyWith(
  bgBlur: effectiveBlur,
  bgNoise: effectiveNoise,
  blur: effectiveBlur,
  noise: effectiveNoise,
  surfaceOpacity: theme.surfaceOpacity,
  enableBorder: theme.enableBorder,
  borderRadius: theme.borderRadius,
  borderOpacity: theme.borderOpacity,
  borderWidth: theme.borderWidth,
  enableGlow: theme.enableGlow,
  glowOpacity: theme.glowOpacity,
  glowBlur: theme.glowBlur,

  // IMPORTANT :
  // permet au PhoneInput de supprimer uniquement
  // l'ombre rectangulaire du SurfaceContainer.
  enableShadow: widget.disableShadow
      ? false
      : theme.enableShadow,

  shadowOpacity: theme.shadowOpacity,
  shadowBlur: theme.shadowBlur,
  shadowOffsetY: theme.shadowOffsetY,
);

    final bool effectiveLiftOnHover = widget.liftOnHover && theme.enableHover;

    final GlassSurfaceConfig config = GlassSurfaceConfig(
      style: effectiveStyle,
      shape: widget.shape,
      effects: effectiveEffects,
      theme: theme,
      isFocused: widget.isFocused,
      hasError: widget.hasError,
      enabled: widget.enabled,
      isHovered: _isHovered,
      liftOnHover: effectiveLiftOnHover,
      borderColor: widget.decoration.borderColor,
      focusBorderColor: widget.decoration.focusBorderColor,
      borderWidth: widget.decoration.borderWidth,
      focusBorderWidth: widget.decoration.focusBorderWidth,
      customColorsAqua: widget.customColorsAqua,
      customColorsClassic: widget.customColorsClassic,
      customGradient: widget.customGradient,
      loadedGradient: _loadedGradient,
      customKey: widget.customKey,
    );

    final BorderRadius effectiveRadius = widget.borderRadius ??
        BorderRadius.circular(theme.borderRadius.clamp(0.0, 160.0));

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
      onHoverChanged: (value) {
        if (!mounted) return;
        if (_isHovered == value) return;
        setState(() => _isHovered = value);
      },
      child: widget.child,
    );
  }
}