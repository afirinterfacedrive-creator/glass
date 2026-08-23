import 'dart:ui';

import 'package:flutter/material.dart';

/// ===============================================================
/// GLASS ICON
/// ===============================================================
///
/// Icône avec effet glass directement appliqué à l'icône.
///
/// IMPORTANT :
/// - AUCUNE bulle
/// - AUCUN cercle
/// - AUCUN cadre
/// - AUCUN fond
/// - AUCUN border
///
/// `size` correspond à la taille RÉELLE de l'icône.
///
/// La zone tactile est légèrement plus grande que l'icône
/// afin de faciliter l'utilisation sur écran tactile.
/// ===============================================================

class GlassIcon extends StatefulWidget {
  // ===============================================================
  // ICÔNE
  // ===============================================================

  final IconData icon;

  // ===============================================================
  // COULEUR DE BASE
  // ===============================================================

  final Color baseColor;

  // ===============================================================
  // TAILLE RÉELLE DE L'ICÔNE
  // ===============================================================

  final double size;

  // ===============================================================
  // ÉTAT
  // ===============================================================

  final bool isActive;

  // ===============================================================
  // ACTION
  // ===============================================================

  final VoidCallback onTap;

  final TextSpan themetext;

  const GlassIcon({
    super.key,
    required this.icon,
    required this.baseColor,
    required this.onTap,

    this.size = 28.0,
    this.isActive = false,
    this.themetext = const TextSpan(
      text: 'Hello world!',
      style: TextStyle(color: Colors.black),
    ),
  });

  @override
  State<GlassIcon> createState() => _GlassIconState();
}

class _GlassIconState extends State<GlassIcon> {
  bool _isPressed = false;

  // ===============================================================
  // BUILD
  // ===============================================================

  @override
  Widget build(BuildContext context) {
    // -------------------------------------------------------------
    // TAILLE DE L'ICÔNE
    // -------------------------------------------------------------

    final double iconSize = widget.size.clamp(16.0, 60.0);

    // -------------------------------------------------------------
    // COULEUR
    // -------------------------------------------------------------

    final Color iconColor = widget.isActive
        ? widget.baseColor
        : Colors.white.withValues(alpha: 0.72);

    // -------------------------------------------------------------
    // GLOW
    // -------------------------------------------------------------

    final double glowRadius = widget.isActive
        ? iconSize * 0.22
        : iconSize * 0.08;

    // -------------------------------------------------------------
    // ZONE TACTILE
    //
    // L'icône fait par exemple 26 px.
    // La zone tactile fait environ 38 px.
    //
    // MAIS :
    // aucun fond n'est dessiné.
    // -------------------------------------------------------------

    final double touchSize = iconSize + 12.0;

    // =============================================================
    // GESTURE
    // =============================================================

    return GestureDetector(
      behavior: HitTestBehavior.opaque,

      // -----------------------------------------------------------
      // PRESSION
      // -----------------------------------------------------------
      onTapDown: (_) {
        if (!mounted) return;

        setState(() {
          _isPressed = true;
        });
      },

      // -----------------------------------------------------------
      // RELÂCHEMENT
      // -----------------------------------------------------------
      onTapUp: (_) {
        if (!mounted) return;

        setState(() {
          _isPressed = false;
        });
      },

      // -----------------------------------------------------------
      // ANNULATION
      // -----------------------------------------------------------
      onTapCancel: () {
        if (!mounted) return;

        setState(() {
          _isPressed = false;
        });
      },

      // -----------------------------------------------------------
      // ACTION
      // -----------------------------------------------------------
      onTap: widget.onTap,

      // ===========================================================
      // ANIMATION DE PRESSION
      // ===========================================================
      child: AnimatedScale(
        scale: _isPressed ? 0.88 : 1.0,

        duration: const Duration(milliseconds: 100),

        curve: Curves.easeOut,

        // =========================================================
        // ZONE TACTILE
        // =========================================================
        child: SizedBox(
          width: touchSize,
          height: touchSize,

          // =======================================================
          // CENTRAGE
          // =======================================================
          child: Center(
            child: Stack(
              alignment: Alignment.center,

              children: [
                // =================================================
                // GLOW ACTIF
                // =================================================
                //
                // Cette couche est uniquement une icône floutée.
                //
                // Elle ne crée :
                // - aucun cercle
                // - aucun cadre
                // - aucun fond
                // =================================================
                if (widget.isActive)
                  ImageFiltered(
                    imageFilter: ImageFilter.blur(
                      sigmaX: glowRadius,
                      sigmaY: glowRadius,
                    ),

                    child: Icon(
                      widget.icon,

                      size: iconSize,

                      color: widget.baseColor.withValues(alpha: 0.55),
                    ),
                  ),

                // =================================================
                // ICÔNE PRINCIPALE
                // =================================================
                Icon(
                  widget.icon,

                  size: iconSize,

                  color: iconColor,

                  // ------------------------------------------------
                  // LÉGER REFLET GLASS
                  // ------------------------------------------------
                  shadows: [
                    Shadow(
                      color: widget.isActive
                          ? widget.baseColor.withValues(alpha: 0.45)
                          : Colors.white.withValues(alpha: 0.18),

                      blurRadius: widget.isActive ? 5.0 : 3.0,

                      offset: Offset.zero,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
