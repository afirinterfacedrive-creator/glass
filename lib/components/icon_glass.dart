import 'dart:ui';
import 'package:flutter/material.dart';

class IconGlass extends StatefulWidget {
  final IconData icon;
  final Color baseColor;
  final double size;
  final VoidCallback onTap;
  final bool isActive;

  /// Taille de l'icône uniquement.
  final double? iconSize;

  const IconGlass({
    super.key,
    required this.icon,
    required this.baseColor,
    required this.onTap,
    this.isActive = false,
    this.size = 42,
    this.iconSize,
  });

  @override
  State<IconGlass> createState() => _IconGlassState();
}

class _IconGlassState extends State<IconGlass> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final double containerSize = widget.size.clamp(24.0, 100.0);

    final double computedIconSize =
        widget.iconSize ?? (containerSize * 0.58).clamp(14.0, 38.0);

    // ==========================================================
    // COULEUR DE L'ICÔNE
    // ==========================================================

    final Color iconColor = widget.isActive
        ? Colors.white
        : Colors.white.withValues(alpha: 0.82);

    // ==========================================================
    // GLOW TRÈS DISCRET
    //
    // Important :
    // aucun spreadRadius important afin d'éviter
    // l'effet "oreilles" autour de l'icône.
    // ==========================================================

    final List<BoxShadow> shadows = widget.isActive
        ? [
            BoxShadow(
              color: widget.baseColor.withValues(alpha: 0.30),
              blurRadius: containerSize * 0.16,
              spreadRadius: 0,
            ),
          ]
        : [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.10),
              blurRadius: containerSize * 0.08,
              spreadRadius: 0,
              offset: Offset(0, containerSize * 0.025),
            ),
          ];

    // ==========================================================
    // PETIT FOND GLASS
    //
    // Pas de cercle.
    // Simple surface transparente.
    // ==========================================================

    final Color glassColor = widget.isActive
        ? widget.baseColor.withValues(alpha: 0.18)
        : Colors.white.withValues(alpha: 0.045);

    // ==========================================================
    // SCALE PRESSION
    // ==========================================================

    final double pressedScale = _isPressed ? 0.88 : 1.0;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,

      onTapDown: (_) {
        if (!mounted) return;

        setState(() {
          _isPressed = true;
        });
      },

      onTapUp: (_) {
        if (!mounted) return;

        setState(() {
          _isPressed = false;
        });
      },

      onTapCancel: () {
        if (!mounted) return;

        setState(() {
          _isPressed = false;
        });
      },

      onTap: widget.onTap,

      child: AnimatedScale(
        scale: pressedScale,
        duration: const Duration(milliseconds: 110),
        curve: Curves.easeOutCubic,

        child: SizedBox(
          width: containerSize,
          height: containerSize,

          child: Stack(
            alignment: Alignment.center,

            children: [
              // ==================================================
              // 1. SURFACE GLASS TRÈS LÉGÈRE
              // ==================================================
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(containerSize * 0.22),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      decoration: BoxDecoration(
                        color: glassColor,

                        borderRadius: BorderRadius.circular(
                          containerSize * 0.22,
                        ),

                        border: Border.all(
                          color: widget.isActive
                              ? Colors.white.withValues(alpha: 0.38)
                              : Colors.white.withValues(alpha: 0.12),
                          width: 0.8,
                        ),

                        boxShadow: shadows,
                      ),
                    ),
                  ),
                ),
              ),

              // ==================================================
              // 2. REFLET GLASS
              //
              // Très discret.
              // Aucun débordement.
              // ==================================================
              Positioned(
                top: containerSize * 0.14,
                left: containerSize * 0.27,
                right: containerSize * 0.27,

                child: IgnorePointer(
                  child: Container(
                    height: containerSize * 0.045,

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(containerSize),

                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withValues(
                            alpha: widget.isActive ? 0.42 : 0.20,
                          ),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // ==================================================
              // 3. ICÔNE
              // ==================================================
              Center(
                child: AnimatedRotation(
                  turns: widget.isActive ? 0.25 : 0.0,

                  duration: const Duration(milliseconds: 240),

                  curve: Curves.easeInOut,

                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 160),

                    child: Icon(
                      widget.icon,
                      key: ValueKey(widget.icon),
                      color: iconColor,
                      size: computedIconSize,
                      shadows: widget.isActive
                          ? [
                              Shadow(
                                color: widget.baseColor.withValues(alpha: 0.65),
                                blurRadius: 8,
                              ),
                            ]
                          : null,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
