
import 'dart:ui';

import 'package:flutter/material.dart';

/// ============================================================================
/// GLASS MODE CHIP
/// ============================================================================
///
/// Chip moderne de sélection de mode pour Universal Glass.
///
/// Caractéristiques :
/// - Surface glassmorphism.
/// - Forme capsule moderne.
/// - Bordure subtile.
/// - Icône intégrée dans une capsule secondaire.
/// - État sélectionné avec accent + glow.
/// - Animation fluide lors du changement d'état.
/// - Entièrement générique grâce à [T].
///
/// Le widget ne dépend d'aucune page ou logique externe.
///
/// Exemple :
///
// ignore: unintended_html_in_doc_comment
/// GlassModeChip<AppThemeMode>(
///   label: 'Aqua',
///   icon: Icons.water_drop,
///   mode: AppThemeMode.aqua,
///   selected: currentMode,
///   onSelected: onModeChanged,
/// );
///
/// ============================================================================
class GlassModeChip<T> extends StatefulWidget {
  /// Texte affiché.
  final String label;

  /// Icône du mode.
  final IconData icon;

  /// Valeur représentée par ce chip.
  final T mode;

  /// Valeur actuellement sélectionnée.
  final T selected;

  /// Callback exécuté lors de la sélection.
  final ValueChanged<T> onSelected;

  /// Couleur d'accent utilisée lorsque le chip est sélectionné.
  final Color accent;

  /// Hauteur du chip.
  final double height;

  /// Padding horizontal.
  final double horizontalPadding;

  /// Rayon du chip.
  final double borderRadius;

  /// Taille de l'icône.
  final double iconSize;

  /// Taille de la zone de l'icône.
  final double iconContainerSize;

  /// Couleur de fond non sélectionnée.
  final Color backgroundColor;

  /// Opacité du fond glass.
  final double backgroundOpacity;

  /// Couleur de la bordure non sélectionnée.
  final Color borderColor;

  /// Opacité de la bordure non sélectionnée.
  final double borderOpacity;

  /// Couleur du texte non sélectionné.
  final Color textColor;

  /// Couleur du texte sélectionné.
  final Color selectedTextColor;

  /// Active ou non le blur.
  final bool enableBlur;

  /// Intensité du blur horizontal.
  final double blurSigmaX;

  /// Intensité du blur vertical.
  final double blurSigmaY;

  /// Active ou non le glow de sélection.
  final bool enableGlow;

  /// Rayon du glow.
  final double glowRadius;

  /// Callback optionnel lorsque le pointeur entre dans le chip.
  final VoidCallback? onHover;

  const GlassModeChip({
    super.key,
    required this.label,
    required this.icon,
    required this.mode,
    required this.selected,
    required this.onSelected,
    this.accent = const Color(0xFFE50914),
    this.height = 48,
    this.horizontalPadding = 8,
    this.borderRadius = 16,
    this.iconSize = 18,
    this.iconContainerSize = 32,
    this.backgroundColor = Colors.white,
    this.backgroundOpacity = 0.055,
    this.borderColor = Colors.white,
    this.borderOpacity = 0.16,
    this.textColor = Colors.white70,
    this.selectedTextColor = Colors.white,
    this.enableBlur = true,
    this.blurSigmaX = 12,
    this.blurSigmaY = 12,
    this.enableGlow = true,
    this.glowRadius = 14,
    this.onHover,
  });

  @override
  State<GlassModeChip<T>> createState() => _GlassModeChipState<T>();
}

class _GlassModeChipState<T> extends State<GlassModeChip<T>> {
  bool _hovered = false;
  bool _pressed = false;

  bool get _isSelected => widget.mode == widget.selected;

  void _handleTap() {
    widget.onSelected(widget.mode);
  }

  @override
  Widget build(BuildContext context) {
    final bool selected = _isSelected;

    final Color surfaceColor = selected
        ? Color.alphaBlend(
            widget.accent.withValues(alpha: 0.16),
            widget.backgroundColor.withValues(
              alpha: widget.backgroundOpacity,
            ),
          )
        : widget.backgroundColor.withValues(
            alpha: widget.backgroundOpacity,
          );

    final Color effectiveBorderColor = selected
        ? widget.accent
        : widget.borderColor;

    final double effectiveBorderOpacity = selected
        ? 0.72
        : widget.borderOpacity;

    final Color effectiveTextColor = selected
        ? widget.selectedTextColor
        : widget.textColor;

    final Color effectiveIconColor = selected
        ? widget.accent
        : widget.textColor;

    final Widget content = AnimatedScale(
      scale: _pressed ? 0.97 : (_hovered ? 1.01 : 1.0),
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOutCubic,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        child: BackdropFilter(
          filter: widget.enableBlur
              ? ImageFilter.blur(
                  sigmaX: widget.blurSigmaX,
                  sigmaY: widget.blurSigmaY,
                )
              : ImageFilter.blur(
                  sigmaX: 0,
                  sigmaY: 0,
                ),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            height: widget.height,
            padding: EdgeInsets.symmetric(
              horizontal: widget.horizontalPadding,
            ),
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(
                widget.borderRadius,
              ),
              border: Border.all(
                color: effectiveBorderColor.withValues(
                  alpha: effectiveBorderOpacity,
                ),
                width: selected ? 1.2 : 1.0,
              ),
              boxShadow: [
                if (selected && widget.enableGlow)
                  BoxShadow(
                    color: widget.accent.withValues(
                      alpha: 0.20,
                    ),
                    blurRadius: widget.glowRadius,
                    spreadRadius: 0,
                  ),
                if (_hovered && !selected)
                  BoxShadow(
                    color: Colors.white.withValues(
                      alpha: 0.055,
                    ),
                    blurRadius: 10,
                    spreadRadius: 0,
                  ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ============================================================
                // ICON CONTAINER
                // ============================================================

                AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOutCubic,
                  width: widget.iconContainerSize,
                  height: widget.iconContainerSize,
                  decoration: BoxDecoration(
                    color: selected
                        ? widget.accent.withValues(alpha: 0.15)
                        : Colors.white.withValues(alpha: 0.045),
                    borderRadius: BorderRadius.circular(
                      widget.borderRadius * 0.65,
                    ),
                    border: Border.all(
                      color: selected
                          ? widget.accent.withValues(alpha: 0.30)
                          : Colors.white.withValues(alpha: 0.08),
                    ),
                  ),
                  child: Icon(
                    widget.icon,
                    size: widget.iconSize,
                    color: effectiveIconColor,
                  ),
                ),

                const SizedBox(width: 9),

                // ============================================================
                // LABEL
                // ============================================================

                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeOut,
                  style: TextStyle(
                    color: effectiveTextColor,
                    fontSize: 13.5,
                    fontWeight: selected
                        ? FontWeight.w700
                        : FontWeight.w500,
                    letterSpacing: 0.05,
                  ),
                  child: Text(
                    widget.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                // ============================================================
                // SELECTED INDICATOR
                // ============================================================

                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 180),
                  transitionBuilder: (child, animation) {
                    return ScaleTransition(
                      scale: animation,
                      child: FadeTransition(
                        opacity: animation,
                        child: child,
                      ),
                    );
                  },
                  child: selected
                      ? Padding(
                          key: const ValueKey('selected'),
                          padding: const EdgeInsets.only(
                            left: 8,
                          ),
                          child: Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: widget.accent,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: widget.accent.withValues(
                                    alpha: 0.65,
                                  ),
                                  blurRadius: 6,
                                ),
                              ],
                            ),
                          ),
                        )
                      : const SizedBox(
                          key: ValueKey('unselected'),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) {
        setState(() {
          _hovered = true;
        });

        widget.onHover?.call();
      },
      onExit: (_) {
        setState(() {
          _hovered = false;
        });
      },
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) {
          setState(() {
            _pressed = true;
          });
        },
        onTapUp: (_) {
          setState(() {
            _pressed = false;
          });
        },
        onTapCancel: () {
          setState(() {
            _pressed = false;
          });
        },
        onTap: _handleTap,
        child: content,
      ),
    );
  }
}

