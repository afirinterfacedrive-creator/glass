
import 'package:flutter/material.dart';

import 'package:universal_glass/utils/glass_input_decoration.dart';

/// Applique le style visuel au contenu d'une surface Glass.
///
/// Responsabilités :
/// - appliquer la couleur du contenu ;
/// - transmettre les paramètres typographiques ;
/// - appliquer la couleur aux icônes ;
/// - conserver le widget enfant intact.
///
/// Cette classe ne gère volontairement pas :
/// - le blur ;
/// - le gradient ;
/// - le bruit ;
/// - les bordures ;
/// - les ombres ;
/// - le thème global ;
/// - le comportement hover/focus.
class GlassContentStyle extends StatelessWidget {
  final Widget child;
  final GlassInputDecoration decoration;
  final Color contentColor;

  const GlassContentStyle({
    super.key,
    required this.child,
    required this.decoration,
    required this.contentColor,
  });

  @override
  Widget build(BuildContext context) {
    final double fontSize = decoration.fontSize;

    return DefaultTextStyle(
      style: TextStyle(
        color: contentColor,
        fontSize: fontSize,
        fontWeight: decoration.fontWeight,
        letterSpacing: decoration.letterSpacing,
      ),
      child: IconTheme(
        data: IconThemeData(
          color: contentColor,
          size: fontSize * 1.2,
        ),
        child: child,
      ),
    );
  }
}
