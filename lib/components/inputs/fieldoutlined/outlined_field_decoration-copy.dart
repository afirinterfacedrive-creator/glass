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
    const double notchDepth = 6.0;
    const double notchRadius = 4.0;

    final double start = notchStart.clamp(
      notchRadius,
      size.width - notchRadius,
    );

    final double end = (start + notchWidth).clamp(
      start + notchRadius,
      size.width - notchRadius,
    );

    final Path path = Path();

    // Départ en haut à gauche.
    path.moveTo(0, 0);

    // Jusqu'au début du notch.
    path.lineTo(start - notchRadius, 0);

    // Entrée du notch.
    path.quadraticBezierTo(
      start,
      0,
      start,
      notchRadius,
    );

    path.lineTo(
      start,
      notchDepth - notchRadius,
    );

    // Fond gauche du notch.
    path.quadraticBezierTo(
      start,
      notchDepth,
      start + notchRadius,
      notchDepth,
    );

    // Fond du notch.
    path.lineTo(
      end - notchRadius,
      notchDepth,
    );

    // Fond droit du notch.
    path.quadraticBezierTo(
      end,
      notchDepth,
      end,
      notchDepth - notchRadius,
    );

    // Sortie du notch.
    path.lineTo(
      end,
      notchRadius,
    );

    path.quadraticBezierTo(
      end,
      0,
      end + notchRadius,
      0,
    );

    // Haut droit.
    path.lineTo(size.width, 0);

    // Côté droit.
    path.lineTo(size.width, size.height);

    // Bas.
    path.lineTo(0, size.height);

    // Fermeture.
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant NotchClipper oldClipper) {
    return oldClipper.notchStart != notchStart ||
        oldClipper.notchWidth != notchWidth;
  }
}