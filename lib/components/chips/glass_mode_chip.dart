import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:universal_glass/components/surface/glass_surface_container.dart';
import 'package:universal_glass/theme/glass_effects.dart';
import 'package:universal_glass/core/layout/glass_layout_context.dart';
import 'package:universal_glass/core/layout/glass_layout_scope.dart';

import '../../enums/glass_enums.dart';

class GlassModeChip<T> extends ConsumerStatefulWidget {
  final String label;
  final IconData icon;

  final T mode;
  final T selected;

  final ValueChanged<T> onSelected;

  /// Couleur d'accent explicite.
  ///
  /// Si elle n'est pas fournie, la couleur active
  /// du GlassLayoutContext est utilisée.
  final Color? accent;

  final double height;
  final double horizontalPadding;
  final double borderRadius;

  final double iconSize;
  final double iconContainerSize;

  /// Conservé pour compatibilité avec l'ancienne API.
  final Color? backgroundColor;
  final double backgroundOpacity;

  /// Conservé pour compatibilité avec l'ancienne API.
  final Color? borderColor;
  final double borderOpacity;

  final Color? textColor;
  final Color? selectedTextColor;

  final bool enableBlur;
  final double blurSigmaX;
  final double blurSigmaY;

  final bool enableGlow;
  final double glowRadius;

  final bool enabled;

  final VoidCallback? onHover;

  const GlassModeChip({
    super.key,
    required this.label,
    required this.icon,
    required this.mode,
    required this.selected,
    required this.onSelected,
    this.accent,
    this.height = 48.0,
    this.horizontalPadding = 8.0,
    this.borderRadius = 16.0,
    this.iconSize = 18.0,
    this.iconContainerSize = 32.0,
    this.backgroundColor,
    this.backgroundOpacity = 0.055,
    this.borderColor,
    this.borderOpacity = 0.16,
    this.textColor,
    this.selectedTextColor,
    this.enableBlur = true,
    this.blurSigmaX = 12.0,
    this.blurSigmaY = 12.0,
    this.enableGlow = true,
    this.glowRadius = 14.0,
    this.enabled = true,
    this.onHover,
  });

  @override
  ConsumerState<GlassModeChip<T>> createState() => _GlassModeChipState<T>();
}

class _GlassModeChipState<T> extends ConsumerState<GlassModeChip<T>> {
  bool _hovered = false;
  bool _pressed = false;

  bool get _isSelected => widget.mode == widget.selected;

  void _handleTap() {
    if (!widget.enabled) return;

    widget.onSelected(widget.mode);
  }

  @override
  Widget build(BuildContext context) {
    final GlassLayoutContext glass = GlassLayoutScope.of(context);

    final bool selected = _isSelected;
    final bool enabled = widget.enabled;

    /*
     * ------------------------------------------------------------
     * COULEURS
     * ------------------------------------------------------------
     *
     * Le thème global fournit la couleur active.
     *
     * Un accent explicitement fourni par le composant
     * reste prioritaire.
     */
    final Color accent = widget.accent ?? glass.focusColor;

    final Color resolvedTextColor = widget.textColor ?? Colors.white70;

    final Color resolvedSelectedTextColor =
        widget.selectedTextColor ?? Colors.white;

    final Color effectiveTextColor = selected
        ? resolvedSelectedTextColor
        : resolvedTextColor;

    final Color iconColor = selected ? accent : resolvedTextColor;

    /*
     * ------------------------------------------------------------
     * EFFETS
     * ------------------------------------------------------------
     *
     * Les effets sont construits à partir du contexte.
     *
     * Le Chip ne recrée pas son propre BackdropFilter.
     */
    final GlassEffects chipEffects = glass.effects.copyWith(
      bgBlur: widget.enableBlur ? widget.blurSigmaX : 0.0,
      blur: widget.enableBlur ? widget.blurSigmaY : 0.0,
      surfaceOpacity: widget.backgroundOpacity,
      enableGlow: widget.enableGlow && selected,
      glowOpacity: selected ? glass.effects.glowOpacity : 0.0,
      glowBlur: widget.glowRadius,
      borderOpacity: selected ? 0.72 : widget.borderOpacity,
      borderWidth: selected ? 1.2 : 1.0,
    );

    /*
     * ------------------------------------------------------------
     * ANIMATION
     * ------------------------------------------------------------
     */
    final double scale = !enabled
        ? 1.0
        : _pressed
        ? 0.97
        : _hovered
        ? 1.01
        : 1.0;

    /*
     * ------------------------------------------------------------
     * CONTENU
     * ------------------------------------------------------------
     */
    final Widget content = AnimatedScale(
      scale: scale,
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOutCubic,
      child: SizedBox(
        height: widget.height,
        child: GlassSurfaceContainer(
          role: GlassSurfaceRole.card,
          style: glass.effectiveGlassStyle,
          effects: chipEffects,
          shape: GlassShapeType.squareRounded,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          padding: EdgeInsets.symmetric(horizontal: widget.horizontalPadding),
          enabled: enabled,
          liftOnHover: enabled,
          onTap: enabled ? _handleTap : null,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              /*
               * --------------------------------------------------
               * ICON CONTAINER
               * --------------------------------------------------
               */
              AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                width: widget.iconContainerSize,
                height: widget.iconContainerSize,
                decoration: BoxDecoration(
                  color: selected
                      ? accent.withValues(alpha: 0.15)
                      : Colors.white.withValues(alpha: 0.045),
                  borderRadius: BorderRadius.circular(
                    widget.borderRadius * 0.65,
                  ),
                  border: Border.all(
                    color: selected
                        ? accent.withValues(alpha: 0.30)
                        : Colors.white.withValues(alpha: 0.08),
                  ),
                ),
                child: Icon(
                  widget.icon,
                  size: widget.iconSize,
                  color: enabled
                      ? iconColor
                      : iconColor.withValues(alpha: 0.40),
                ),
              ),

              const SizedBox(width: 9),

              /*
               * --------------------------------------------------
               * LABEL
               * --------------------------------------------------
               */
              Flexible(
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeOut,
                  style: TextStyle(
                    color: enabled
                        ? effectiveTextColor
                        : effectiveTextColor.withValues(alpha: 0.40),
                    fontSize: 13.5,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    letterSpacing: 0.05,
                  ),
                  child: Text(
                    widget.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),

              /*
               * --------------------------------------------------
               * INDICATEUR SELECTED
               * --------------------------------------------------
               */
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                transitionBuilder: (child, animation) {
                  return ScaleTransition(
                    scale: animation,
                    child: FadeTransition(opacity: animation, child: child),
                  );
                },
                child: selected
                    ? Padding(
                        key: const ValueKey('selected'),
                        padding: const EdgeInsets.only(left: 8),
                        child: Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: accent,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: accent.withValues(alpha: 0.65),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                        ),
                      )
                    : const SizedBox(key: ValueKey('unselected')),
              ),
            ],
          ),
        ),
      ),
    );

    /*
     * ------------------------------------------------------------
     * INTERACTION
     * ------------------------------------------------------------
     */
    return MouseRegion(
      cursor: enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      onEnter: enabled
          ? (_) {
              setState(() {
                _hovered = true;
              });

              widget.onHover?.call();
            }
          : null,
      onExit: enabled
          ? (_) {
              setState(() {
                _hovered = false;
              });
            }
          : null,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: enabled
            ? (_) {
                setState(() {
                  _pressed = true;
                });
              }
            : null,
        onTapUp: enabled
            ? (_) {
                setState(() {
                  _pressed = false;
                });
              }
            : null,
        onTapCancel: enabled
            ? () {
                setState(() {
                  _pressed = false;
                });
              }
            : null,
        onTap: enabled ? _handleTap : null,
        child: content,
      ),
    );
  }
}
