import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:universal_glass/components/glass_painter.dart';

import '../enums/glass_enums.dart';
import '../provider/glass_button_provider.dart';
import '../theme/glass_effects.dart';

class UniversalGlassButton extends ConsumerStatefulWidget {
  // ============================================================
  // IDENTIFIANT UNIQUE
  // ============================================================

  final String buttonId;

  // ============================================================
  // DIMENSIONS
  // ============================================================

  final double? width;
  final double height;
  final double borderRadius;

  // ============================================================
  // STYLE GLASS
  // ============================================================

  final GlassEffects effects;
  final GlassShapeType shape;
  final GlassStyle style;

  // ============================================================
  // ÉTAT INITIAL
  // ============================================================

  final bool defaultActive;

  // ============================================================
  // CONTENU
  // ============================================================

  final String? label;
  final IconData? icon;
  final Color iconColor;

  // ============================================================
  // SPINNER
  // ============================================================

  final SpinnerPosition spinnerPosition;

  // ============================================================
  // ACTIONS
  // ============================================================

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
    this.label,
    this.icon,
    this.iconColor = Colors.white,
    this.spinnerPosition = SpinnerPosition.left,
    this.futureOnTap,
    this.simpleOnTap,
  });

  @override
  ConsumerState<UniversalGlassButton> createState() =>
      _UniversalGlassButtonState();
}

// ============================================================================
// STATE
// ============================================================================

class _UniversalGlassButtonState extends ConsumerState<UniversalGlassButton> {
  bool _isPressed = false;

  // ============================================================
  // INITIALISATION
  // ============================================================

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      if (!mounted) return;

      ref
          .read(glassButtonProvider.notifier)
          .initButton(widget.buttonId, widget.defaultActive);
    });
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    // ==========================================================
    // ÉTAT DU BOUTON
    // ==========================================================

    final GlassButtonState currentButtonState = ref.watch(
      glassButtonProvider.select(
        (state) => state[widget.buttonId] ?? const GlassButtonState(),
      ),
    );

    // ==========================================================
    // SCALE
    // ==========================================================

    final double finalScale = _isPressed
        ? 0.94
        : currentButtonState.isActive
        ? 1.05
        : 1.0;

    // ==========================================================
    // COULEURS
    // ==========================================================

    final List<Color> bgColors = currentButtonState.isActive
        ? [
            widget.iconColor.withValues(alpha: 0.60),
            widget.iconColor.withValues(alpha: 0.20),
          ]
        : widget.effects.bgGradient;

    // ==========================================================
    // EFFECTS MIS À JOUR
    // ==========================================================

    final GlassEffects updatedEffects = GlassEffects(
      bgGradient: bgColors,
      borderGradient: widget.effects.borderGradient,
      blur: widget.effects.blur,
    );

    // ==========================================================
    // BOUTON
    // ==========================================================

    return GestureDetector(
      behavior: HitTestBehavior.opaque,

      // --------------------------------------------------------
      // PRESSION
      // --------------------------------------------------------
      onTapDown: currentButtonState.isLoading
          ? null
          : (_) {
              setState(() {
                _isPressed = true;
              });
            },

      // --------------------------------------------------------
      // RELÂCHEMENT
      // --------------------------------------------------------
      onTapUp: currentButtonState.isLoading
          ? null
          : (_) {
              setState(() {
                _isPressed = false;
              });
            },

      // --------------------------------------------------------
      // ANNULATION
      // --------------------------------------------------------
      onTapCancel: () {
        if (!mounted) return;

        setState(() {
          _isPressed = false;
        });
      },

      // --------------------------------------------------------
      // CLIC
      // --------------------------------------------------------
      onTap: currentButtonState.isLoading ? null : _handleTap,

      // ========================================================
      // ANIMATION SCALE
      // ========================================================
      child: AnimatedScale(
        scale: finalScale,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOutBack,

        child: SizedBox(
          width: widget.width,
          height: widget.height,

          child: ClipRRect(
            borderRadius: BorderRadius.circular(widget.borderRadius),

            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: widget.effects.blur,
                sigmaY: widget.effects.blur,
              ),

              child: CustomPaint(
                painter: GlassPainter(
                  effects: updatedEffects,
                  shapeType: widget.shape,
                  useAquaReflect: widget.style == GlassStyle.transparentAqua,
                  customRadius: widget.borderRadius,
                ),

                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),

                    child: _buildContent(
                      isLoading: currentButtonState.isLoading,
                      isActive: currentButtonState.isActive,
                      customText: currentButtonState.customText,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // GESTION DU CLIC
  // ============================================================

  Future<void> _handleTap() async {
    final GlassButtonNotifier notifier = ref.read(glassButtonProvider.notifier);

    // ==========================================================
    // ACTION SIMPLE
    // ==========================================================

    if (widget.simpleOnTap != null) {
      widget.simpleOnTap!();
    }

    // ==========================================================
    // ACTION ASYNCHRONE
    // ==========================================================

    if (widget.futureOnTap != null) {
      notifier.setLoading(widget.buttonId, true);

      try {
        await widget.futureOnTap!(ref);
      } catch (e, stackTrace) {
        debugPrint(
          '❌ UniversalGlassButton '
          '[${widget.buttonId}] : $e',
        );

        debugPrintStack(stackTrace: stackTrace);

        rethrow;
      } finally {
        if (mounted) {
          notifier.setLoading(widget.buttonId, false, clearCustomText: true);
        }
      }
    }
  }

  // ============================================================
  // CONTENU INTERNE
  // ============================================================

  Widget _buildContent({
    required bool isLoading,
    required bool isActive,
    String? customText,
  }) {
    final List<Widget> children = [];

    // ==========================================================
    // SPINNER À GAUCHE
    // ==========================================================

    if (isLoading && widget.spinnerPosition == SpinnerPosition.left) {
      children.add(
        const SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
        ),
      );

      children.add(const SizedBox(width: 10));
    }

    // ==========================================================
    // ICÔNE
    // ==========================================================

    if (widget.icon != null &&
        (!isLoading || widget.spinnerPosition == SpinnerPosition.right)) {
      children.add(
        AnimatedRotation(
          turns: isActive ? 0.25 : 0.0,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,

          child: Icon(
            widget.icon,
            color: widget.iconColor,
            size: widget.height * 0.40,
          ),
        ),
      );

      if (widget.label != null) {
        children.add(const SizedBox(width: 10));
      }
    }

    // ==========================================================
    // TEXTE
    // ==========================================================

    if (widget.label != null) {
      final String displayedText = isLoading
          ? (customText ?? 'Chargement...')
          : widget.label!;

      children.add(
        Flexible(
          child: Text(
            displayedText,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,

            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: widget.height * 0.32,
              letterSpacing: 0.5,
            ),
          ),
        ),
      );
    }

    // ==========================================================
    // SPINNER À DROITE
    // ==========================================================

    if (isLoading && widget.spinnerPosition == SpinnerPosition.right) {
      children.add(const SizedBox(width: 10));

      children.add(
        const SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
        ),
      );
    }

    // ==========================================================
    // ROW
    // ==========================================================

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }
}
