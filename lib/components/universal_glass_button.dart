// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:universal_glass/components/surface/glass_surface_container.dart';
import 'package:universal_glass/core/layout/glass_layout_context.dart';
import 'package:universal_glass/core/layout/glass_layout_scope.dart';

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
  final double? iconSize;

  final SpinnerPosition spinnerPosition;

  /// Callback synchrone.
  ///
  /// Utilisé pour une action immédiate qui ne nécessite
  /// pas d'état de chargement.
  final VoidCallback? simpleOnTap;

  /// Callback asynchrone.
  ///
  /// Lorsqu'il est fourni, le bouton passe automatiquement
  /// en état de chargement pendant l'exécution de l'action.
  final Future<void> Function()? futureOnTap;

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
    this.iconSize,
    this.spinnerPosition = SpinnerPosition.left,
    this.simpleOnTap,
    this.futureOnTap,
  });

  @override
  ConsumerState<UniversalGlassButton> createState() =>
      _UniversalGlassButtonState();
}

class _UniversalGlassButtonState
    extends ConsumerState<UniversalGlassButton> {
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      if (!mounted) return;

      ref
          .read(glassButtonProvider.notifier)
          .initButton(
            widget.buttonId,
            widget.defaultActive,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    final GlassLayoutContext glass =
        GlassLayoutScope.of(context);

    final GlassButtonState state = ref.watch(
      glassButtonProvider.select(
        (states) =>
            states[widget.buttonId] ??
            const GlassButtonState(),
      ),
    );

    final bool isLoading = state.isLoading;
    final bool isActive = state.isActive;

    /*
     * Le bouton est désactivé :
     * - si enabled == false ;
     * - ou pendant une action asynchrone.
     */
    final bool isDisabled =
        !widget.enabled || isLoading;

    final double scale =
        _isPressed ? 0.94 : 1.0;

    final bool isCircle =
        widget.shape == GlassShapeType.circle;

    final bool isRoundShape =
        isCircle ||
        widget.shape == GlassShapeType.stadium ||
        widget.shape == GlassShapeType.pill;

    final BorderRadius radius =
        isRoundShape
            ? BorderRadius.circular(
                widget.height / 2,
              )
            : BorderRadius.circular(
                widget.borderRadius,
              );

    final double? effectiveWidth =
        isCircle
            ? widget.height
            : widget.width;

    final GlassStyle effectiveStyle =
        widget.style;

    final GlassEffects effectiveEffects =
        isActive
            ? widget.effects.copyWith(
                glowOpacity:
                    (widget.effects.glowOpacity + 0.20)
                        .clamp(0.0, 1.0),
              )
            : widget.effects;

    final double bubbleSize =
        widget.height * 0.60;

    final double iconSize =
        (widget.iconSize ??
                bubbleSize * 0.66)
            .clamp(16.0, 28.0);

    final double fontSize =
        (widget.height * 0.32)
            .clamp(11.0, 18.0);

    final Color finalIconColor =
        isDisabled
            ? widget.iconColor.withValues(
                alpha: 0.40,
              )
            : isActive
                ? glass.focusColor
                : widget.iconColor;

    final Color textColor =
        isDisabled
            ? Colors.white.withValues(
                alpha: 0.40,
              )
            : Colors.white;

    return Semantics(
      button: true,
      enabled: !isDisabled,
      label: widget.label,
      child: AnimatedScale(
        scale: scale,
        duration: const Duration(
          milliseconds: 140,
        ),
        curve: Curves.easeOutCubic,
        child: SizedBox(
          width: effectiveWidth,
          height: widget.height,
          child: GlassSurfaceContainer(
            role: GlassSurfaceRole.card,
            style: effectiveStyle,
            effects: effectiveEffects,
            shape: widget.shape,
            borderRadius: radius,
            padding: EdgeInsets.zero,
            enabled: !isDisabled,
            liftOnHover: true,
            onTap: isDisabled
                ? null
                : _handleTap,
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal:
                      isCircle ? 0.0 : 12.0,
                ),
                child: _content(
                  isLoading,
                  isActive,
                  state.customText,
                  isCircle,
                  iconSize,
                  fontSize,
                  finalIconColor,
                  textColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Gère l'appui sur le bouton.
  ///
  /// Priorité :
  /// 1. [futureOnTap] si fourni.
  /// 2. [simpleOnTap] sinon.
  ///
  /// Cela garantit qu'un bouton ne déclenche jamais
  /// deux actions différentes pour une seule pression.
  Future<void> _handleTap() async {
    if (_isPressed) return;

    /*
     * ------------------------------------------------------------
     * 1. Animation de pression
     * ------------------------------------------------------------
     */

    setState(() {
      _isPressed = true;
    });

    await Future.delayed(
      const Duration(
        milliseconds: 100,
      ),
    );

    if (!mounted) return;

    setState(() {
      _isPressed = false;
    });

    /*
     * ------------------------------------------------------------
     * 2. Action asynchrone
     * ------------------------------------------------------------
     *
     * futureOnTap est prioritaire.
     */
    final Future<void> Function()? futureAction =
        widget.futureOnTap;

    if (futureAction != null) {
      final notifier =
          ref.read(
            glassButtonProvider.notifier,
          );

      /*
       * Active le loading AVANT de lancer l'action.
       */
      notifier.setLoading(
        widget.buttonId,
        true,
      );

      try {
        await futureAction();
      } catch (error, stackTrace) {
        debugPrint(
          '❌ UniversalGlassButton '
          '[${widget.buttonId}] : $error',
        );

        debugPrintStack(
          stackTrace: stackTrace,
        );
      } finally {
  if (mounted) {
    notifier.setLoading(
      widget.buttonId,
      false,
      clearCustomText: true,
    );
  }
}

      return;
    }

    /*
     * ------------------------------------------------------------
     * 3. Action synchrone
     * ------------------------------------------------------------
     *
     * Elle n'est appelée que lorsqu'il n'y a
     * aucune action asynchrone.
     */
    final VoidCallback? simpleAction =
        widget.simpleOnTap;

    if (simpleAction != null) {
      simpleAction();
    }
  }

  Widget _content(
    bool isLoading,
    bool isActive,
    String? customText,
    bool isCircle,
    double iconSize,
    double fontSize,
    Color iconColor,
    Color textColor,
  ) {
    /*
     * ------------------------------------------------------------
     * Bouton circulaire en chargement
     * ------------------------------------------------------------
     */

    if (isLoading && isCircle) {
      return _Spinner(
        color: iconColor,
      );
    }

    /*
     * ------------------------------------------------------------
     * Bouton circulaire / icône seule
     * ------------------------------------------------------------
     */

    if ((widget.label == null &&
            widget.icon != null &&
            !isLoading) ||
        (isCircle &&
            widget.icon != null)) {
      return Center(
        child: AnimatedRotation(
          turns: isActive ? 0.25 : 0.0,
          duration: const Duration(
            milliseconds: 250,
          ),
          curve: Curves.easeInOut,
          child: Icon(
            widget.icon,
            color: iconColor,
            size: iconSize,
          ),
        ),
      );
    }

    /*
     * ------------------------------------------------------------
     * Contenu standard
     * ------------------------------------------------------------
     */

    final List<Widget> children =
        <Widget>[];

    /*
     * Spinner à gauche
     */

    if (isLoading &&
        widget.spinnerPosition ==
            SpinnerPosition.left) {
      children.add(
        _Spinner(
          color: iconColor,
        ),
      );

      children.add(
        const SizedBox(
          width: 8,
        ),
      );
    }

    /*
     * Icône
     */

    if (widget.icon != null &&
        (!isLoading ||
            widget.spinnerPosition ==
                SpinnerPosition.right)) {
      children.add(
        AnimatedRotation(
          turns: isActive ? 0.25 : 0.0,
          duration: const Duration(
            milliseconds: 250,
          ),
          curve: Curves.easeInOut,
          child: Icon(
            widget.icon,
            color: iconColor,
            size: iconSize,
          ),
        ),
      );

      if (widget.label != null) {
        children.add(
          const SizedBox(
            width: 8,
          ),
        );
      }
    }

    /*
     * Label
     */

    if (widget.label != null) {
      final String text =
          isLoading
              ? (customText ??
                  'Chargement...')
              : widget.label!;

      children.add(
        Flexible(
          fit: FlexFit.loose,
          child: AnimatedSwitcher(
            duration: const Duration(
              milliseconds: 180,
            ),
            transitionBuilder:
                (
                  Widget child,
                  Animation<double> animation,
                ) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position:
                      Tween<Offset>(
                    begin:
                        const Offset(
                          0,
                          0.12,
                        ),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              );
            },
            child: Text(
              text,
              key: ValueKey<String>(
                text,
              ),
              maxLines: 1,
              overflow:
                  TextOverflow.ellipsis,
              style: TextStyle(
                color: textColor,
                fontWeight:
                    FontWeight.w900,
                fontSize: fontSize,
                letterSpacing: 0.2,
              ),
            ),
          ),
        ),
      );
    }

    /*
     * Spinner à droite
     */

    if (isLoading &&
        widget.spinnerPosition ==
            SpinnerPosition.right) {
      children.add(
        const SizedBox(
          width: 8,
        ),
      );

      children.add(
        _Spinner(
          color: iconColor,
        ),
      );
    }

    return Row(
      mainAxisSize:
          MainAxisSize.min,
      mainAxisAlignment:
          MainAxisAlignment.center,
      children: children,
    );
  }
}

class _Spinner extends StatelessWidget {
  final Color color;

  const _Spinner({
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 18,
      height: 18,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        color: color,
      ),
    );
  }
}