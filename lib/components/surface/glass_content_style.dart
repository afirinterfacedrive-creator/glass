import 'package:flutter/material.dart';
import 'package:universal_glass/components/inputs/glass_input_decoration.dart';

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
    return DefaultTextStyle(
      style: TextStyle(
        color: contentColor,
        fontSize: decoration.fontSize, // Changé suite à la correction précédente
        fontWeight: decoration.fontWeight,
        letterSpacing: decoration.letterSpacing,
      ),
      child: IconTheme(
        data: IconThemeData(
          color: contentColor, 
          size: decoration.fontSize * 1.2,
        ),
        child: child,
      ),
    );
  }
}
