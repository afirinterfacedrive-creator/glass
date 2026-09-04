import 'package:flutter/material.dart';

/// Un wrapper réutilisable pour les inputs du package Universal Glass.
/// Il applique dynamiquement un [ClipPath] avec une encoche (Notch)
/// et projette une ombre vectorielle parfaite via [PhysicalShape]
/// pour éviter les artefacts de carrés noirs et les crashs de détection de clics.
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
    // 1. Au repos : pas d'encoche = rendu natif pur (l'arbre reste intact, clic fluide)
    if (clipper == null) {
      return child;
    }

    // 2. Shadow désactivée : juste la découpe saine
    if (!isShadowEnabled) {
      return ClipPath(
        clipper: clipper,
        child: child,
      );
    }

    // 3. FIX ABSOLU : Utilisation de PhysicalShape à la place de PhysicalModel.
    // On force l'ombre à suivre la géométrie exacte du NotchClipper.
    return PhysicalShape(
      clipper: clipper!, // Épouse la découpe sémantique
      elevation: elevation,
      color: Colors.transparent, // Préserve la transparence de ton verre dépoli
      shadowColor: Colors.black.withOpacity(shadowOpacity),
      clipBehavior: Clip.none, // Laisse respirer l'ombre portée
      child: ClipPath(
        clipper: clipper,
        child: child,
      ),
    );
  }
}
