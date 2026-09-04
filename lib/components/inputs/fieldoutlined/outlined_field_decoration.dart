
import 'package:flutter/material.dart';

class NotchClipper extends CustomClipper<Path> {
  final double notchStart;
  final double notchWidth;

  const NotchClipper({
    required this.notchStart,
    required this.notchWidth,
  });

  @override
  Path getClip(Size size) {
    // ==============================================================
    // TEST 14
    //
    // On conserve NotchClipper mais on retourne volontairement
    // un rectangle complet.
    //
    // Aucun notch.
    // Aucune courbe Bézier.
    // Aucune zone exclue du Path.
    // ==============================================================

    return Path()
      ..addRect(
        Rect.fromLTWH(
          0,
          0,
          size.width,
          size.height,
        ),
      );
  }

  @override
  bool shouldReclip(
    covariant NotchClipper oldClipper,
  ) {
    return oldClipper.notchStart != notchStart ||
        oldClipper.notchWidth != notchWidth;
  }
}
