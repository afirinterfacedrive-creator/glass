import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:universal_glass/components/surface/glass_surface_container.dart';
import 'package:universal_glass/utils/glass_theme_extension.dart'; // <- AJOUT

import '../enums/glass_enums.dart';
import '../provider/glass_button_provider.dart';
import '../theme/glass_effects.dart';

class UniversalGlassButton extends ConsumerStatefulWidget {
  final String buttonId;
  final double? width;
  final double height;
  final double borderRadius;
  final GlassEffects effects;
  final GlassShapeType shape;
  final GlassStyle style;
  final bool defaultActive;
  final bool enabled;
  final String? label;
  final IconData? icon;
  final Color iconColor;
  final double? iconSize; // <- AJOUTE ÇA
  final SpinnerPosition spinnerPosition;
  final Future<void> Function(WidgetRef ref)? futureOnTap;
  final VoidCallback? simpleOnTap;

  const UniversalGlassButton({
    super.key,
    required this.buttonId,
    this.width,
    required this.height,
    this.borderRadius = 20.0,
    required this.effects,
    required this.shape,
    this.style = GlassStyle.transparentAqua,
    this.defaultActive = false,
    this.enabled = true,
    this.label,
    this.icon,
    this.iconColor = Colors.white,
    this.iconSize, // <- AJOUTE ÇA
    this.spinnerPosition = SpinnerPosition.left,
    this.futureOnTap,
    this.simpleOnTap,
  });

  @override
  ConsumerState<UniversalGlassButton> createState() => _UniversalGlassButtonState();
}

class _UniversalGlassButtonState extends ConsumerState<UniversalGlassButton> {
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) ref.read(glassButtonProvider.notifier).initButton(widget.buttonId, widget.defaultActive);
    });
  }

  @override
  Widget build(BuildContext context) {
    final glass = ref.watchGlassContext(context); // <- CENTRALISE
    final state = ref.watch(glassButtonProvider.select((s) => s[widget.buttonId] ?? const GlassButtonState()));
    final bool isLoading = state.isLoading, isActive = state.isActive;
    final bool isDisabled = !widget.enabled || isLoading;
    final double scale = _isPressed ? 0.94 : 1.0;

    final bool useAqua = glass.theme.useAquaStyle;
    final Color focusColor = useAqua ? Colors.cyanAccent : Colors.orangeAccent;

    // FIX 1: Gestion stricte des formes géométriques
    final bool isCircle = widget.shape == GlassShapeType.circle;
    final BorderRadius radius = isCircle || widget.shape == GlassShapeType.stadium || widget.shape == GlassShapeType.pill
        ? BorderRadius.circular(widget.height / 2)
        : BorderRadius.circular(widget.borderRadius);

    // Si c'est un cercle, on force un aspect carré
    final double? effectiveWidth = isCircle ? widget.height : widget.width;

    // Style actif: on utilise le contexte
    final GlassStyle effectiveStyle = isActive ? GlassStyle.solidAqua : widget.style;
    final GlassEffects effectiveEffects = isActive 
        ? glass.effects.copyWith(glowOpacity: glass.effects.glowOpacity + 0.2) // boost glow quand actif
        : glass.effects;

    // TAILLE ICONE = 60% DE LA HAUTEUR * 0.66 pour rester dans la bulle
    final double bubbleSize = widget.height * 0.6;
    final double iconSize = (widget.iconSize ?? bubbleSize * 0.66).clamp(16.0, 28.0);
    final double fontSize = (widget.height * 0.32).clamp(11.0, 18.0);

    final Color finalIconColor = isDisabled 
        ? widget.iconColor.withValues(alpha: 0.4) 
        : (isActive ? focusColor : widget.iconColor);

    return Semantics(
      button: true, enabled: !isDisabled, label: widget.label,
      child: AnimatedScale(
        scale: scale, duration: const Duration(milliseconds: 140), curve: Curves.easeOutCubic,
        child: SizedBox(
          width: effectiveWidth,
          height: widget.height,
          child: GlassSurfaceContainer(
            style: effectiveStyle,
            effects: effectiveEffects, // <- UTILISE CEUX DU CONTEXTE
            shape: widget.shape,
            borderRadius: radius,
            padding: EdgeInsets.zero,
            enabled: !isDisabled,
            liftOnHover: true,
            onTap: isDisabled ? null : _handleTap,
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: isCircle ? 0 : 12),
                child: _content(isLoading, isActive, state.customText, isCircle, iconSize, fontSize, finalIconColor, focusColor),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleTap() async {
    final notifier = ref.read(glassButtonProvider.notifier);
    setState(() => _isPressed = true);
    await Future.delayed(const Duration(milliseconds: 100));
    if (mounted) setState(() => _isPressed = false);

    widget.simpleOnTap?.call();
    if (widget.futureOnTap != null) {
      notifier.setLoading(widget.buttonId, true);
      try {
        await widget.futureOnTap!(ref);
      } catch (e, s) {
        debugPrint('❌ UniversalGlassButton [${widget.buttonId}] : $e');
        debugPrintStack(stackTrace: s);
        rethrow;
      } finally {
        if (mounted) notifier.setLoading(widget.buttonId, false, clearCustomText: true);
      }
    }
  }

  Widget _content(bool isLoading, bool isActive, String? customText, bool isCircle, double iconSize, double fontSize, Color iconColor, Color focusColor) {
    // FIX 2: Loader pour les boutons circulaires purs
    if (isLoading && isCircle) {
      return _Spinner(color: iconColor);
    }

    // CAS 1: ICONE SEUL
    if ((widget.label == null && widget.icon != null && !isLoading) || (isCircle && widget.icon != null)) {
      return Center(
        child: AnimatedRotation(
          turns: isActive ? 0.25 : 0.0,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          child: Icon(widget.icon, color: iconColor, size: iconSize),
        ),
      );
    }

    // CAS 2: AVEC TEXTE
    final List<Widget> children = [];

    if (isLoading && widget.spinnerPosition == SpinnerPosition.left) {
      children.add(_Spinner(color: iconColor));
      children.add(const SizedBox(width: 8));
    }

    if (widget.icon != null && (!isLoading || widget.spinnerPosition == SpinnerPosition.right)) {
      children.add(
        AnimatedRotation(
          turns: isActive ? 0.25 : 0.0,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          child: Icon(widget.icon, color: iconColor, size: iconSize),
        ),
      );
      if (widget.label != null) children.add(const SizedBox(width: 8));
    }

    if (widget.label != null) {
      final text = isLoading ? (customText ?? 'Chargement...') : widget.label!;
      children.add(
        Expanded(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 180),
            transitionBuilder: (child, anim) => FadeTransition(
              opacity: anim,
              child: SlideTransition(position: Tween<Offset>(begin: const Offset(0, 0.12), end: Offset.zero).animate(anim), child: child),
            ),
            child: Text(
              text,
              key: ValueKey(text),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: fontSize, letterSpacing: 0.2),
            ),
          ),
        ),
      );
    }

    if (isLoading && widget.spinnerPosition == SpinnerPosition.right) {
      children.add(const SizedBox(width: 8));
      children.add(_Spinner(color: iconColor));
    }

    return Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center, children: children);
  }
}

class _Spinner extends StatelessWidget {
  final Color color;
  const _Spinner({required this.color});
  
  @override
  Widget build(BuildContext context) => SizedBox(
    width: 18, 
    height: 18, 
    child: CircularProgressIndicator(strokeWidth: 2, color: color)
  );
}