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
    final double effectiveBlur = blur.clamp(0.0, 100.0);
    final double effectiveNoise = noise.clamp(0.0, 1.0);

    final bool hasBlur = effectiveBlur > 0.0;
    final bool hasNoise = effectiveNoise > 0.0;

    // ================================================================
    // TEST 26
    // ================================================================
    // Blur + Noise
    //
    // Le Blur du TEST 25 reste inchangé.
    // Le Noise est maintenant réactivé.
    // ================================================================

    Widget buildLayers() {
      if (!hasBlur && !hasNoise) {
        return surface;
      }

      return Stack(
        fit: StackFit.loose,
        children: [
          // ============================================================
          // BACKDROP BLUR
          // ============================================================

          if (hasBlur)
            Positioned.fill(
              child: IgnorePointer(
                ignoring: true,
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: effectiveBlur,
                    sigmaY: effectiveBlur,
                  ),
                  child: const SizedBox.expand(),
                ),
              ),
            ),

          // ============================================================
          // SURFACE
          // ============================================================

          surface,

          // ============================================================
          // NOISE
          // ============================================================

          if (hasNoise)
            Positioned.fill(
              child: IgnorePointer(
                ignoring: true,
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
      );
    }

    final Widget layers = buildLayers();

    // ================================================================
    // IMPORTANT POUR LE PHONE INPUT
    // ================================================================

    if (clipBehavior == Clip.none) {
      return layers;
    }

    return ClipRRect(
      borderRadius: radius,
      clipBehavior: clipBehavior,
      child: layers,
    );
  }
}