import 'package:flutter/material.dart';

/// ============================================================================
/// UNIVERSAL APP BAR DECORATOR
/// ============================================================================
///
/// Décoration légère du contenu de l'AppBar.
///
/// Les effets Glass principaux ne sont PAS gérés ici.
///
/// Ils sont gérés par GlassSurfaceContainer dans GlassScaffold.
///
/// Cette classe sert uniquement à :
///
/// - imposer la hauteur
/// - imposer la largeur
/// - appliquer une décoration éventuelle
/// - contenir le contenu de l'AppBar
///
class UniversalAppBarDecorator extends StatelessWidget {
  final double height;

  final Widget child;

  final BoxDecoration backgroundDecoration;

  const UniversalAppBarDecorator({
    super.key,
    required this.height,
    required this.child,
    required this.backgroundDecoration,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return SizedBox(
      width:
          double.infinity,

      height:
          height,

      child:
          DecoratedBox(
        decoration:
            backgroundDecoration,

        child:
            SizedBox(
          width:
              double.infinity,

          height:
              height,

          child:
              child,
        ),
      ),
    );
  }
}