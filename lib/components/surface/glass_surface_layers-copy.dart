
import 'dart:ui';

import 'package:flutter/material.dart';

class GlassSurfaceLayers extends StatelessWidget {
  final Widget surface;
  final BorderRadius radius;
  final double blur;
  final double noise;
  final Clip clipBehavior;

  const GlassSurfaceLayers({
    super.key,
    required this.surface,
    required this.radius,
    required this.blur,
    required this.noise,
    this.clipBehavior = Clip.antiAlias,
  });

  @override
  Widget build(BuildContext context) {
    final double effectiveBlur =
        blur.clamp(0.0, 100.0);

    final double effectiveNoise =
        noise.clamp(0.0, 1.0);

    final bool hasBlur =
        effectiveBlur > 0.0;

    final bool hasNoise =
        effectiveNoise > 0.0;

    // -------------------------------------------------------------------------
    // Aucun effet
    // -------------------------------------------------------------------------
    //
    // On retourne directement la surface afin d'éviter tout Stack inutile.
    //
    if (!hasBlur && !hasNoise) {
      return ClipRRect(
        borderRadius: radius,
        clipBehavior: clipBehavior,
        child: surface,
      );
    }

    // -------------------------------------------------------------------------
    // GLASS STACK
    // -------------------------------------------------------------------------
    //
    // IMPORTANT :
    // Le Stack doit laisser la surface déterminer sa taille.
    //
    // Le BackdropFilter est positionné derrière la surface.
    //
    return ClipRRect(
      borderRadius: radius,
      clipBehavior: clipBehavior,
      child: Stack(
        fit: StackFit.loose,
        children: [
          // ===================================================================
          // BACKDROP BLUR
          // ===================================================================

          if (hasBlur)
            Positioned.fill(
              child: IgnorePointer(
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: effectiveBlur,
                    sigmaY: effectiveBlur,
                  ),
                  child: const SizedBox.expand(),
                ),
              ),
            ),

          // ===================================================================
          // SURFACE
          // ===================================================================

          surface,

          // ===================================================================
          // NOISE
          // ===================================================================

          if (hasNoise)
            Positioned.fill(
              child: IgnorePointer(
                child: Opacity(
                  opacity: effectiveNoise,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: radius,
                      image: const DecorationImage(
                        image: AssetImage(
                          'packages/universal_glass/assets/noise.png',
                        ),
                        repeat: ImageRepeat.repeat,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
