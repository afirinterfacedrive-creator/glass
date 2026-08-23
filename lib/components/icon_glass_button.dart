import 'dart:ui';

import 'package:flutter/material.dart';

/// ================================================================
/// ICON GLASS BUTTON
///
/// Version sans bulle/cercle.
/// L'effet glass est appliqué directement autour de l'icône.
///
/// Utilisation :
///
/// IconGlassButton(
///   icon: Icons.dark_mode,
///   baseColor: Colors.indigo,
///   isActive: true,
///   onTap: () {},
/// )
/// ================================================================

class IconGlassButton extends StatefulWidget {
  final IconData icon;
  final Color baseColor;
  final VoidCallback onTap;

  /// État actif
  final bool isActive;

  /// Taille globale de la zone de l'icône
  final double size;

  /// Taille de l'icône.
  /// null = calcul automatique
  final double? iconSize;

  /// Intensité du verre
  final double glassOpacity;

  /// Intensité du glow
  final double glowOpacity;

  /// Rayon du flou
  final double blur;

  /// Active/désactive la rotation lors de l'activation
  final bool rotateOnActive;

  const IconGlassButton({
    super.key,
    required this.icon,
    required this.baseColor,
    required this.onTap,

    this.isActive = false,

    this.size = 42.0,
    this.iconSize,

    this.glassOpacity = 0.18,
    this.glowOpacity = 0.30,
    this.blur = 5.0,

    this.rotateOnActive = true,
  });

  @override
  State<IconGlassButton> createState() => _IconGlassButtonState();
}

class _IconGlassButtonState extends State<IconGlassButton> {
  bool _isPressed = false;

  // ==============================================================
  // TAILLE ICÔNE
  // ==============================================================

  double _getIconSize() {
    return widget.iconSize ?? (widget.size * 0.58).clamp(16.0, 36.0);
  }

  // ==============================================================
  // OPACITÉ DU VERRE
  // ==============================================================

  List<Color> _getGradientColors() {
    if (widget.isActive) {
      return [
        widget.baseColor.withValues(alpha: 0.32),
        widget.baseColor.withValues(alpha: 0.12),
      ];
    }

    return [
      Colors.white.withValues(alpha: widget.glassOpacity),
      Colors.white.withValues(alpha: 0.035),
    ];
  }

  // ==============================================================
  // GLOW
  // ==============================================================

  List<BoxShadow> _getShadows() {
    if (widget.isActive) {
      return [
        BoxShadow(
          color: widget.baseColor.withValues(alpha: widget.glowOpacity),
          blurRadius: widget.size * 0.28,
          spreadRadius: 0,
        ),

        BoxShadow(
          color: Colors.black.withValues(alpha: 0.12),
          blurRadius: widget.size * 0.10,
          offset: Offset(0, widget.size * 0.05),
        ),
      ];
    }

    return [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.10),
        blurRadius: widget.size * 0.10,
        offset: Offset(0, widget.size * 0.04),
      ),
    ];
  }

  // ==============================================================
  // BUILD
  // ==============================================================

  @override
  Widget build(BuildContext context) {
    final double iconSize = _getIconSize();

    final double pressedScale = _isPressed ? 0.88 : 1.0;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,

      // ------------------------------------------------------------
      // PRESSION
      // ------------------------------------------------------------
      onTapDown: (_) {
        if (!mounted) return;

        setState(() {
          _isPressed = true;
        });
      },

      // ------------------------------------------------------------
      // RELÂCHEMENT
      // ------------------------------------------------------------
      onTapUp: (_) {
        if (!mounted) return;

        setState(() {
          _isPressed = false;
        });
      },

      // ------------------------------------------------------------
      // ANNULATION
      // ------------------------------------------------------------
      onTapCancel: () {
        if (!mounted) return;

        setState(() {
          _isPressed = false;
        });
      },

      // ------------------------------------------------------------
      // ACTION
      // ------------------------------------------------------------
      onTap: widget.onTap,

      child: AnimatedScale(
        scale: pressedScale,

        duration: const Duration(milliseconds: 120),

        curve: Curves.easeOutCubic,

        child: SizedBox(
          width: widget.size,
          height: widget.size,

          child: Stack(
            alignment: Alignment.center,

            // Très important :
            // aucune partie du glass ne déborde
            // latéralement.
            clipBehavior: Clip.hardEdge,

            children: [
              // ====================================================
              // 1. GLASS DISCRET AUTOUR DE L'ICÔNE
              // ====================================================
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(widget.size * 0.28),

                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: widget.blur,
                      sigmaY: widget.blur,
                    ),

                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),

                      curve: Curves.easeOut,

                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(widget.size * 0.28),

                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,

                          colors: _getGradientColors(),
                        ),

                        border: Border.all(
                          color: widget.isActive
                              ? Colors.white.withValues(alpha: 0.48)
                              : Colors.white.withValues(alpha: 0.16),

                          width: widget.isActive ? 1.2 : 0.8,
                        ),

                        boxShadow: _getShadows(),
                      ),
                    ),
                  ),
                ),
              ),

              // ====================================================
              // 2. REFLET GLASS
              // ====================================================
              Positioned(
                top: widget.size * 0.14,
                left: widget.size * 0.25,
                right: widget.size * 0.25,

                child: IgnorePointer(
                  child: Container(
                    height: widget.size * 0.08,

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(widget.size),

                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,

                        colors: [
                          Colors.white.withValues(
                            alpha: widget.isActive ? 0.30 : 0.18,
                          ),

                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // ====================================================
              // 3. PETIT REFLET
              // ====================================================
              Positioned(
                top: widget.size * 0.20,
                left: widget.size * 0.28,

                child: IgnorePointer(
                  child: Container(
                    width: widget.size * 0.07,
                    height: widget.size * 0.045,

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(widget.size),

                      color: Colors.white.withValues(alpha: 0.18),
                    ),
                  ),
                ),
              ),

              // ====================================================
              // 4. ICÔNE
              // ====================================================
              Center(
                child: AnimatedRotation(
                  turns: widget.rotateOnActive && widget.isActive ? 0.25 : 0.0,

                  duration: const Duration(milliseconds: 250),

                  curve: Curves.easeInOut,

                  child: AnimatedOpacity(
                    opacity: widget.isActive ? 1.0 : 0.88,

                    duration: const Duration(milliseconds: 180),

                    child: Icon(
                      widget.icon,

                      color: Colors.white,

                      size: iconSize,

                      shadows: [
                        Shadow(
                          color: widget.baseColor.withValues(
                            alpha: widget.isActive ? 0.45 : 0.18,
                          ),

                          blurRadius: widget.isActive ? 5.0 : 2.0,
                        ),
                      ],
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
