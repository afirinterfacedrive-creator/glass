
import 'package:flutter/material.dart';

/// Couche visuelle destinée à dessiner l'ombre d'une encoche
/// sans interférer avec les interactions du widget placé devant.
///
/// IMPORTANT :
/// Le widget [child] n'est volontairement PAS placé dans un
/// [ClipPath]. Cela permet aux TextField/TextFormField de conserver
/// leur hit-test natif et leur positionnement précis du curseur.
class GlassNotchShadowWrapper extends StatelessWidget {
  final Widget child;
  final CustomClipper<Path>? clipper;

  final bool isShadowEnabled;
  final double shadowOpacity;
  final double elevation;

  /// Conservé dans l'API pour compatibilité avec les appels existants.
  ///
  /// Le rayon est actuellement géré par le composant de surface lui-même.
  final BorderRadius borderRadius;

  const GlassNotchShadowWrapper({
    super.key,
    required this.child,
    required this.clipper,
    required this.isShadowEnabled,
    required this.shadowOpacity,
    required this.borderRadius,
    this.elevation = 6.0,
  });

  @override
  Widget build(BuildContext context) {
    // -----------------------------------------------------------------------
    // Aucun clipper = aucune couche supplémentaire.
    // -----------------------------------------------------------------------

    if (clipper == null) {
      return child;
    }

    // -----------------------------------------------------------------------
    // On utilise un Stack uniquement pour placer l'ombre derrière.
    //
    // La couche d'ombre est totalement passive grâce à IgnorePointer.
    // -----------------------------------------------------------------------

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned.fill(
          child: IgnorePointer(
            child: CustomPaint(
              painter: _GlassNotchShadowPainter(
                clipper: clipper!,
                shadowOpacity: shadowOpacity,
                elevation: elevation,
                enabled: isShadowEnabled,
              ),
            ),
          ),
        ),

        // -------------------------------------------------------------------
        // IMPORTANT :
        //
        // Le child interactif reste complètement indépendant du ClipPath.
        //
        // Cela permet au TextFormField de recevoir directement :
        // - le premier clic ;
        // - la position exacte du curseur ;
        // - les clics à l'intérieur du texte ;
        // - les sélections ;
        // - les déplacements du curseur.
        // -------------------------------------------------------------------
        child,
      ],
    );
  }
}

/// Peint uniquement l'ombre correspondant à la forme du notch.
///
/// Ce painter ne reçoit aucun événement tactile.
class _GlassNotchShadowPainter extends CustomPainter {
  final CustomClipper<Path> clipper;
  final double shadowOpacity;
  final double elevation;
  final bool enabled;

  const _GlassNotchShadowPainter({
    required this.clipper,
    required this.shadowOpacity,
    required this.elevation,
    required this.enabled,
  });

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    if (!enabled) {
      return;
    }

    final double opacity = shadowOpacity.clamp(
      0.0,
      1.0,
    );

    final double elevationValue = elevation.clamp(
      0.0,
      100.0,
    );

    if (opacity <= 0.0 || elevationValue <= 0.0) {
      return;
    }

    // -----------------------------------------------------------------------
    // Récupération de la forme du notch.
    // -----------------------------------------------------------------------

    final Path path = clipper.getClip(size);

    // -----------------------------------------------------------------------
    // Dessin de l'ombre.
    // -----------------------------------------------------------------------

    canvas.drawShadow(
      path,
      Colors.black.withValues(
        alpha: opacity,
      ),
      elevationValue,
      true,
    );
  }

  @override
  bool shouldRepaint(
    covariant _GlassNotchShadowPainter oldDelegate,
  ) {
    return oldDelegate.clipper != clipper ||
        oldDelegate.shadowOpacity != shadowOpacity ||
        oldDelegate.elevation != elevation ||
        oldDelegate.enabled != enabled;
  }

  @override
  bool shouldRebuildSemantics(
    covariant _GlassNotchShadowPainter oldDelegate,
  ) {
    return false;
  }
}
