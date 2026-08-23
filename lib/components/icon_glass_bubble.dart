import 'dart:ui';
import 'package:flutter/material.dart';

class IconGlassBubble extends StatefulWidget {
  final IconData icon;
  final Color baseColor;
  final double size;
  final VoidCallback onTap;
  final bool isActive;

  const IconGlassBubble({
    super.key,
    required this.icon,
    required this.baseColor,
    required this.onTap,
    this.isActive = false,
    this.size = 42,
  });

  @override
  State<IconGlassBubble> createState() => _IconGlassBubbleState();
}

class _IconGlassBubbleState extends State<IconGlassBubble> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    // ============================================================
    // TAILLE RÉELLE DE LA BULLE
    // ============================================================

    final double bubbleSize = widget.size.clamp(24.0, 100.0);

    // ============================================================
    // ICÔNE
    //
    // 56 % de la bulle.
    //
    // 42 px → environ 23.5 px
    // ============================================================

    final double iconSize = (bubbleSize * 0.56).clamp(13.0, 36.0);

    // ============================================================
    // BORDURE
    // ============================================================

    final double borderWidth = (bubbleSize * 0.035).clamp(1.0, 2.2);

    // ============================================================
    // REFLET SUPÉRIEUR
    //
    // Plus fin et plus court pour éviter l'effet "oreille".
    // ============================================================

    final double reflectionTop = bubbleSize * 0.09;

    final double reflectionHorizontal = bubbleSize * 0.22;

    final double reflectionHeight = bubbleSize * 0.13;

    // ============================================================
    // GLOW
    //
    // Glow plus contrôlé.
    // Il reste autour de la bulle sans créer de volume latéral.
    // ============================================================

    final List<BoxShadow> glowShadow = widget.isActive
        ? [
            BoxShadow(
              color: widget.baseColor.withValues(alpha: 0.38),
              blurRadius: bubbleSize * 0.20,
              spreadRadius: 0.0,
            ),

            BoxShadow(
              color: Colors.black.withValues(alpha: 0.18),
              blurRadius: bubbleSize * 0.08,
              spreadRadius: 0.0,
              offset: Offset(0, bubbleSize * 0.055),
            ),
          ]
        : [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: bubbleSize * 0.08,
              spreadRadius: 0.0,
              offset: Offset(0, bubbleSize * 0.045),
            ),
          ];

    // ============================================================
    // COULEURS DU VERRE
    // ============================================================

    final List<Color> gradientColors = widget.isActive
        ? [
            widget.baseColor.withValues(alpha: 0.92),
            widget.baseColor.withValues(alpha: 0.52),
          ]
        : [
            widget.baseColor.withValues(alpha: 0.38),
            widget.baseColor.withValues(alpha: 0.10),
          ];

    // ============================================================
    // PRESSION
    // ============================================================

    final double pressedScale = _isPressed ? 0.90 : 1.0;

    // ============================================================
    // BOUTON
    // ============================================================

    return GestureDetector(
      behavior: HitTestBehavior.opaque,

      onTapDown: (_) {
        setState(() {
          _isPressed = true;
        });
      },

      onTapUp: (_) {
        setState(() {
          _isPressed = false;
        });
      },

      onTapCancel: () {
        setState(() {
          _isPressed = false;
        });
      },

      onTap: widget.onTap,

      child: AnimatedScale(
        scale: pressedScale,

        duration: const Duration(milliseconds: 120),

        curve: Curves.easeOutCubic,

        child: SizedBox(
          width: bubbleSize,
          height: bubbleSize,

          child: Stack(
            alignment: Alignment.center,

            // IMPORTANT :
            // On garde le contenu de la bulle strictement
            // circulaire.
            clipBehavior: Clip.hardEdge,

            children: [
              // ==================================================
              // 1. VERRE DÉPOLI
              // ==================================================
              Positioned.fill(
                child: ClipOval(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),

                    child: const SizedBox.expand(),
                  ),
                ),
              ),

              // ==================================================
              // 2. CORPS DE LA BULLE
              // ==================================================
              Positioned.fill(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),

                  curve: Curves.easeOut,

                  decoration: BoxDecoration(
                    shape: BoxShape.circle,

                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: gradientColors,
                    ),

                    border: Border.all(
                      color: widget.isActive
                          ? Colors.white.withValues(alpha: 0.82)
                          : Colors.white.withValues(alpha: 0.38),

                      width: widget.isActive ? borderWidth * 1.25 : borderWidth,
                    ),

                    boxShadow: glowShadow,
                  ),
                ),
              ),

              // ==================================================
              // 3. REFLET SUPÉRIEUR
              // ==================================================
              Positioned(
                top: reflectionTop,
                left: reflectionHorizontal,
                right: reflectionHorizontal,

                child: IgnorePointer(
                  child: Container(
                    height: reflectionHeight,

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(bubbleSize),

                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,

                        colors: [
                          Colors.white.withValues(alpha: 0.48),
                          Colors.white.withValues(alpha: 0.08),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // ==================================================
              // 4. PETIT REFLET CENTRAL
              // ==================================================
              Positioned(
                top: bubbleSize * 0.16,
                left: bubbleSize * 0.28,

                child: IgnorePointer(
                  child: Container(
                    width: bubbleSize * 0.10,
                    height: bubbleSize * 0.06,

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(bubbleSize),

                      color: Colors.white.withValues(alpha: 0.20),
                    ),
                  ),
                ),
              ),

              // ==================================================
              // 5. ICÔNE
              // ==================================================
              Center(
                child: AnimatedRotation(
                  turns: widget.isActive ? 0.25 : 0.0,

                  duration: const Duration(milliseconds: 250),

                  curve: Curves.easeInOut,

                  child: Icon(widget.icon, color: Colors.white, size: iconSize),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
