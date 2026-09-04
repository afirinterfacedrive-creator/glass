
import 'dart:ui';

import 'package:flutter/material.dart';

/// ============================================================================
/// ICON GLASS BUBBLE
///
/// Bulle Glass lumineuse universelle.
///
/// UTILISATIONS
///
/// 1. Icône classique
///
/// IconGlassBubble(
///   icon: Icons.phone,
///   baseColor: Colors.cyanAccent,
///   onTap: () {},
/// )
///
/// 2. Contenu personnalisé
///
/// IconGlassBubble(
///   child: Text(
///     'BF',
///     style: TextStyle(
///       color: Colors.white,
///       fontWeight: FontWeight.w800,
///     ),
///   ),
///   baseColor: Colors.cyanAccent,
///   onTap: () {},
/// )
///
/// 3. Drapeau réel
///
/// IconGlassBubble(
///   child: Image.asset(
///     'assets/flags/bf.png',
///   ),
///   baseColor: Colors.cyanAccent,
///   onTap: () {},
/// )
///
/// IMPORTANT
///
/// `icon` reste compatible avec l'ancien fonctionnement.
///
/// `child` permet maintenant d'afficher n'importe quel contenu :
///
/// • BF
/// • drapeau
/// • image
/// • logo
/// • texte
/// • autre Widget
///
/// Si `child` est fourni, il remplace automatiquement `icon`.
/// ============================================================================

class IconGlassBubble extends StatefulWidget {
  // ==========================================================================
  // ICÔNE CLASSIQUE
  // ==========================================================================

  final IconData? icon;

  // ==========================================================================
  // CONTENU PERSONNALISÉ
  // ==========================================================================

  /// Contenu affiché au centre de la bulle.
  ///
  /// Si `child` est défini, il est prioritaire sur `icon`.
  final Widget? child;

  // ==========================================================================
  // COULEUR
  // ==========================================================================

  final Color baseColor;

  // ==========================================================================
  // TAILLE
  // ==========================================================================

  final double size;

  // ==========================================================================
  // ACTION
  // ==========================================================================

  final VoidCallback onTap;

  // ==========================================================================
  // ÉTAT
  // ==========================================================================

  final bool isActive;

  // ==========================================================================
  // CONSTRUCTEUR
  // ==========================================================================

  const IconGlassBubble({
    super.key,

    this.icon,

    this.child,

    required this.baseColor,

    required this.onTap,

    this.isActive = false,

    this.size = 42,
  }) : assert(
          icon != null || child != null,
          'IconGlassBubble nécessite soit icon, soit child.',
        );

  @override
  State<IconGlassBubble> createState() =>
      _IconGlassBubbleState();
}

// ============================================================================
// STATE
// ============================================================================

class _IconGlassBubbleState
    extends State<IconGlassBubble> {
  bool _isPressed = false;

  bool _isHovered = false;

  // ==========================================================================
  // BUILD
  // ==========================================================================

  @override
  Widget build(BuildContext context) {
    // =========================================================================
    // TAILLE
    // =========================================================================

    final double bubbleSize =
        widget.size.clamp(
      24.0,
      100.0,
    );

    // =========================================================================
    // TAILLE ICÔNE
    // =========================================================================

    final double iconSize =
        (bubbleSize * 0.56).clamp(
      13.0,
      36.0,
    );

    // =========================================================================
    // TAILLE CONTENU PERSONNALISÉ
    // =========================================================================

    final double contentSize =
        (bubbleSize * 0.58).clamp(
      14.0,
      58.0,
    );

    // =========================================================================
    // BORDURE
    // =========================================================================

    final double borderWidth =
        (bubbleSize * 0.035).clamp(
      1.0,
      2.2,
    );

    // =========================================================================
    // REFLET
    // =========================================================================

    final double reflectionTop =
        bubbleSize * 0.09;

    final double reflectionHorizontal =
        bubbleSize * 0.22;

    final double reflectionHeight =
        bubbleSize * 0.13;

    // =========================================================================
    // COULEUR
    // =========================================================================

    final Color color =
        widget.baseColor;

    // =========================================================================
    // GLOW
    // =========================================================================

    final List<BoxShadow> glowShadow =
        widget.isActive
            ? [
                BoxShadow(
                  color: color.withValues(
                    alpha:
                        _isHovered
                            ? 0.52
                            : 0.38,
                  ),
                  blurRadius:
                      bubbleSize *
                          (_isHovered
                              ? 0.25
                              : 0.20),
                  spreadRadius:
                      _isHovered
                          ? 1.0
                          : 0.0,
                ),

                BoxShadow(
                  color:
                      Colors.black.withValues(
                    alpha: 0.18,
                  ),
                  blurRadius:
                      bubbleSize * 0.08,
                  offset: Offset(
                    0,
                    bubbleSize * 0.055,
                  ),
                ),
              ]
            : _isHovered
                ? [
                    BoxShadow(
                      color:
                          color.withValues(
                        alpha: 0.28,
                      ),
                      blurRadius:
                          bubbleSize * 0.18,
                      spreadRadius: -1,
                    ),

                    BoxShadow(
                      color:
                          Colors.black.withValues(
                        alpha: 0.14,
                      ),
                      blurRadius:
                          bubbleSize * 0.08,
                      offset: Offset(
                        0,
                        bubbleSize * 0.045,
                      ),
                    ),
                  ]
                : [
                    BoxShadow(
                      color:
                          Colors.black.withValues(
                        alpha: 0.12,
                      ),
                      blurRadius:
                          bubbleSize * 0.08,
                      offset: Offset(
                        0,
                        bubbleSize * 0.045,
                      ),
                    ),
                  ];

    // =========================================================================
    // GRADIENT
    // =========================================================================

    final List<Color> gradientColors =
        widget.isActive
            ? [
                color.withValues(
                  alpha: 0.92,
                ),
                color.withValues(
                  alpha: 0.52,
                ),
              ]
            : _isHovered
                ? [
                    color.withValues(
                      alpha: 0.48,
                    ),
                    color.withValues(
                      alpha: 0.16,
                    ),
                  ]
                : [
                    color.withValues(
                      alpha: 0.38,
                    ),
                    color.withValues(
                      alpha: 0.10,
                    ),
                  ];

    // =========================================================================
    // SCALE
    //
    // PRESS > HOVER > NORMAL
    // =========================================================================

    final double scale =
        _isPressed
            ? 0.90
            : _isHovered
                ? 1.045
                : 1.0;

    // =========================================================================
    // BOUTON
    // =========================================================================

    return MouseRegion(
      cursor:
          SystemMouseCursors.click,

      onEnter: (_) {
        if (!mounted) {
          return;
        }

        setState(() {
          _isHovered = true;
        });
      },

      onExit: (_) {
        if (!mounted) {
          return;
        }

        setState(() {
          _isHovered = false;
          _isPressed = false;
        });
      },

      child: GestureDetector(
        behavior:
            HitTestBehavior.opaque,

        // =====================================================================
        // PRESSION
        // =====================================================================

        onTapDown: (_) {
          if (!mounted) {
            return;
          }

          setState(() {
            _isPressed = true;
          });
        },

        // =====================================================================
        // RELÂCHEMENT
        // =====================================================================

        onTapUp: (_) {
          if (!mounted) {
            return;
          }

          setState(() {
            _isPressed = false;
          });
        },

        // =====================================================================
        // ANNULATION
        // =====================================================================

        onTapCancel: () {
          if (!mounted) {
            return;
          }

          setState(() {
            _isPressed = false;
          });
        },

        // =====================================================================
        // CLIC
        // =====================================================================

        onTap:
            widget.onTap,

        // =====================================================================
        // SCALE
        // =====================================================================

        child: AnimatedScale(
          scale: scale,

          duration:
              const Duration(
            milliseconds: 140,
          ),

          curve:
              Curves.easeOutCubic,

          child: SizedBox(
            width: bubbleSize,
            height: bubbleSize,

            child: Stack(
              alignment:
                  Alignment.center,

              clipBehavior:
                  Clip.hardEdge,

              children: [
                // =============================================================
                // 1. VERRE DÉPOLI
                // =============================================================

                Positioned.fill(
                  child: ClipOval(
                    child:
                        BackdropFilter(
                      filter:
                          ImageFilter.blur(
                        sigmaX: 5.0,
                        sigmaY: 5.0,
                      ),

                      child:
                          const SizedBox.expand(),
                    ),
                  ),
                ),

                // =============================================================
                // 2. CORPS
                // =============================================================

                Positioned.fill(
                  child:
                      AnimatedContainer(
                    duration:
                        const Duration(
                      milliseconds: 200,
                    ),

                    curve:
                        Curves.easeOut,

                    decoration:
                        BoxDecoration(
                      shape:
                          BoxShape.circle,

                      gradient:
                          LinearGradient(
                        begin:
                            Alignment.topLeft,

                        end:
                            Alignment.bottomRight,

                        colors:
                            gradientColors,
                      ),

                      border:
                          Border.all(
                        color:
                            widget.isActive
                                ? Colors.white
                                    .withValues(
                                    alpha: 0.82,
                                  )
                                : _isHovered
                                    ? Colors.white
                                        .withValues(
                                        alpha: 0.58,
                                      )
                                    : Colors.white
                                        .withValues(
                                        alpha: 0.38,
                                      ),

                        width:
                            widget.isActive
                                ? borderWidth *
                                    1.25
                                : _isHovered
                                    ? borderWidth *
                                        1.15
                                    : borderWidth,
                      ),

                      boxShadow:
                          glowShadow,
                    ),
                  ),
                ),

                // =============================================================
                // 3. REFLET SUPÉRIEUR
                // =============================================================

                Positioned(
                  top:
                      reflectionTop,

                  left:
                      reflectionHorizontal,

                  right:
                      reflectionHorizontal,

                  child:
                      IgnorePointer(
                    child:
                        Container(
                      height:
                          reflectionHeight,

                      decoration:
                          BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(
                          bubbleSize,
                        ),

                        gradient:
                            LinearGradient(
                          begin:
                              Alignment.topCenter,

                          end:
                              Alignment.bottomCenter,

                          colors: [
                            Colors.white
                                .withValues(
                              alpha:
                                  _isHovered
                                      ? 0.58
                                      : 0.48,
                            ),

                            Colors.white
                                .withValues(
                              alpha: 0.08,
                            ),

                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // =============================================================
                // 4. PETIT REFLET CENTRAL
                // =============================================================

                Positioned(
                  top:
                      bubbleSize * 0.16,

                  left:
                      bubbleSize * 0.28,

                  child:
                      IgnorePointer(
                    child:
                        Container(
                      width:
                          bubbleSize * 0.10,

                      height:
                          bubbleSize * 0.06,

                      decoration:
                          BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(
                          bubbleSize,
                        ),

                        color:
                            Colors.white
                                .withValues(
                          alpha:
                              _isHovered
                                  ? 0.28
                                  : 0.20,
                        ),
                      ),
                    ),
                  ),
                ),

                // =============================================================
                // 5. CONTENU
                //
                // Si child existe :
                //     → contenu personnalisé
                //
                // Sinon :
                //     → icône classique
                // =============================================================

                Center(
                  child:
                      widget.child != null
                          ? SizedBox(
                              width:
                                  contentSize,

                              height:
                                  contentSize,

                              child:
                                  Center(
                                child:
                                    widget.child!,
                              ),
                            )
                          : AnimatedRotation(
                              turns:
                                  widget.isActive
                                      ? 0.25
                                      : 0.0,

                              duration:
                                  const Duration(
                                milliseconds: 250,
                              ),

                              curve:
                                  Curves.easeInOut,

                              child:
                                  AnimatedScale(
                                scale:
                                    _isHovered
                                        ? 1.06
                                        : 1.0,

                                duration:
                                    const Duration(
                                  milliseconds: 140,
                                ),

                                curve:
                                    Curves.easeOut,

                                child:
                                    Icon(
                                  widget.icon,

                                  color:
                                      Colors.white,

                                  size:
                                      iconSize,
                                ),
                              ),
                            ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

