import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:universal_glass/constants/app_constants.dart';

/// Moteur des couches physiques d'une surface Glass.
///
/// Pipeline :
///
///   arrière-plan réel
///        ↓
///   BackdropFilter
///        ↓
///   matière translucide
///        ↓
///   reflet spéculaire
///        ↓
///   noise
///        ↓
///   contenu
///
/// Le [BackdropFilter] agit uniquement sur ce qui se trouve
/// derrière la surface.
///
/// Important :
/// [surface] contient déjà la matière visuelle et le contenu.
/// Le BackdropFilter doit donc rester derrière cette surface.
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
    final double effectiveBlur = blur.clamp(
      AppConstants.minBlur,
      AppConstants.maxBlur,
    );

    final double effectiveNoise = noise.clamp(
      AppConstants.minNoise,
      AppConstants.maxNoise,
    );

    final bool hasBlur =
        effectiveBlur > AppConstants.minBlur;

    final bool hasNoise =
        effectiveNoise > AppConstants.minNoise;

    // ========================================================================
    // SANS EFFETS
    // ========================================================================

    if (!hasBlur && !hasNoise) {
      return _applyClip(surface);
    }

    // ========================================================================
    // GLASS PIPELINE
    // ========================================================================

    final Widget glassStack = Stack(
      fit: StackFit.passthrough,
      children: [
        // ====================================================================
        // 1. BACKDROP BLUR
        // ====================================================================
        //
        // Le BackdropFilter est placé AVANT la matière.
        //
        // Il agit uniquement sur les pixels déjà présents derrière
        // cette surface.
        //
        // Il ne floute donc pas le contenu de [surface].
        // ====================================================================

        if (hasBlur)
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: effectiveBlur,
                sigmaY: effectiveBlur,
              ),
              child: const SizedBox.expand(),
            ),
          ),

        // ====================================================================
        // 2. MATIÈRE DU VERRE
        // ====================================================================
        //
        // [surface] contient :
        //
        // - teinte
        // - gradient
        // - bordure
        // - ombre
        // - glow
        // - contenu
        //
        // Cette couche est volontairement placée AU-DESSUS du BackdropFilter.
        // ====================================================================

        surface,

        // ====================================================================
        // 3. SPECULAR HIGHLIGHT
        // ====================================================================
        //
        // Reflet très léger sur la partie supérieure.
        //
        // IgnorePointer garantit que cette couche ne perturbe pas
        // les interactions utilisateur.
        // ====================================================================

        if (hasBlur)
          Positioned.fill(
            child: IgnorePointer(
              ignoring: true,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: radius,
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.center,
                    colors: [
                      Color.fromRGBO(
                        255,
                        255,
                        255,
                        0.055,
                      ),
                      Color.fromRGBO(
                        255,
                        255,
                        255,
                        0.0,
                      ),
                    ],
                    stops: [
                      0.0,
                      0.65,
                    ],
                  ),
                ),
              ),
            ),
          ),

        // ====================================================================
        // 4. NOISE
        // ====================================================================
        //
        // Texture extrêmement légère.
        //
        // IgnorePointer garantit que le noise ne perturbe jamais
        // les interactions.
        // ====================================================================

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

    return _applyClip(glassStack);
  }

  // ==========================================================================
  // CLIPPING
  // ==========================================================================

  Widget _applyClip(Widget child) {
    if (clipBehavior == Clip.none) {
      return child;
    }

    return ClipRRect(
      borderRadius: radius,
      clipBehavior: clipBehavior,
      child: child,
    );
  }
}