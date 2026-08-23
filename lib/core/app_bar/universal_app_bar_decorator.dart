import 'dart:ui';

import 'package:flutter/material.dart';

// ============================================================================
// UNIVERSAL APP BAR DECORATOR
// ============================================================================
//
// Responsable uniquement du rendu visuel.
//
// - BackdropFilter
// - Blur
// - Glass
// - Gradient
// - Bordure
// - Transparence
//
// Aucune logique de navigation ici.
//
// ============================================================================

class UniversalAppBarDecorator extends StatelessWidget {
  final double height;

  final Widget child;

  final BoxDecoration backgroundDecoration;

  final bool useGradientBackground;

  const UniversalAppBarDecorator({
    super.key,

    required this.height,

    required this.child,

    required this.backgroundDecoration,

    this.useGradientBackground = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,

      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),

          child: Container(
            height: height,

            decoration: backgroundDecoration,

            child: child,
          ),
        ),
      ),
    );
  }
}
