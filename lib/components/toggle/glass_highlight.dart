import 'package:flutter/material.dart';

class GlassHighlight extends StatelessWidget {
  final double height;
  final double opacity;

  const GlassHighlight({super.key, this.height = 8, this.opacity = 0.32});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white.withValues(alpha: opacity),
              Colors.white.withValues(alpha: opacity * 0.35),
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }
}
