import 'package:flutter/material.dart';

/// Un wrapper réutilisable pour les inputs du package Universal Glass.
/// Il applique dynamiquement un [ClipPath] avec une encoche (Notch)
/// et projette une ombre vectorielle parfaite via [PhysicalModel]
/// pour éviter les artefacts de carrés noirs.
class GlassNotchShadowWrapper extends StatelessWidget {
  final Widget child;
  final CustomClipper<Path>? clipper;
  final bool isShadowEnabled;
  final double shadowOpacity;
  final double elevation;
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
    // 1. Au repos : pas d'encoche = pas de wrapper
    if (clipper == null) {
      return child;
    }

    // 2. Shadow désactivée : juste le clip
    if (!isShadowEnabled) {
      return ClipPath(
        clipper: clipper,
        child: child,
      );
    }

    // 3. Shadow activée : PhysicalModel avec ShapeBorder
    return PhysicalModel(
      elevation: elevation,
      color: Colors.transparent,
      shadowColor: Colors.black.withOpacity(shadowOpacity),
      shape: BoxShape.rectangle,
      borderRadius: borderRadius, // <- maintenant ça existe
      clipBehavior: Clip.antiAlias,
      child: ClipPath(
        clipper: clipper,
        child: child,
      ),
    );
  }
}