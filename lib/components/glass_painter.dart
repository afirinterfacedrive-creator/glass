import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../enums/glass_enums.dart';
import '../theme/glass_effects.dart';

class GlassPainter extends CustomPainter {
  final GlassEffects effects;
  final GlassShapeType shapeType;
  final bool useAquaReflect;
  final double customRadius;

  GlassPainter({
    required this.effects,
    required this.shapeType,
    required this.useAquaReflect,
    required this.customRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;

    // ==========================================================
    // FORME
    // ==========================================================
    late Path shapePath;

    switch (shapeType) {
      // ========================================================
      // CERCLE
      // ========================================================
      case GlassShapeType.circle:
        final double diameter = math.min(size.width, size.height);
        final double left = (size.width - diameter) / 2;
        final double top = (size.height - diameter) / 2;
        shapePath = Path()..addOval(Rect.fromLTWH(left, top, diameter, diameter));
        break;

      // ========================================================
      // RECTANGLE ARRONDI
      // ========================================================
      case GlassShapeType.squareRounded:
        final double maxRadius = math.min(size.width, size.height) / 2;
        final double safeRadius = customRadius.clamp(0.0, maxRadius);
        shapePath = Path()..addRRect(RRect.fromRectAndRadius(rect, Radius.circular(safeRadius)));
        break;

      // ========================================================
      // CAPSULE VERTICALE
      // ========================================================
      case GlassShapeType.capsuleVertical:
        final double radius = size.width / 2; // basé sur largeur
        shapePath = Path()..addRRect(RRect.fromRectAndRadius(rect, Radius.circular(radius)));
        break;

      // ========================================================
      // PILL HORIZONTALE / STADIUM / PILL
      // ========================================================
      case GlassShapeType.pillHorizontal:
      case GlassShapeType.pill:
      case GlassShapeType.stadium:
        final double radius = size.height / 2; // basé sur hauteur
        shapePath = Path()..addRRect(RRect.fromRectAndRadius(rect, Radius.circular(radius)));
        break;
    }

    // ==========================================================
    // 1. OMBRE EXTÉRIEURE
    // ==========================================================
    final Paint shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.35)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);

    canvas.drawPath(shapePath.shift(const Offset(0, 8)), shadowPaint);

    // ==========================================================
    // 2. FOND GLASS
    // ==========================================================
    final Paint bgPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: effects.bgGradient,
      ).createShader(rect)
      ..style = PaintingStyle.fill;

    canvas.drawPath(shapePath, bgPaint);

    // ==========================================================
    // 3. REFLET AQUA
    // ==========================================================
    if (useAquaReflect) {
      canvas.save();
      canvas.clipPath(shapePath);

      final Rect reflectionRect = Rect.fromLTWH(0, 0, size.width, size.height * 0.60);

      final Paint reflectionPaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white.withValues(alpha: 0.10),
            Colors.white.withValues(alpha: 0.035),
            Colors.transparent,
          ],
          stops: const [0.0, 0.25, 0.60],
        ).createShader(reflectionRect);

      canvas.drawRect(reflectionRect, reflectionPaint);
      canvas.restore();
    }

    // ==========================================================
    // 4. CONTOUR CRISTALLIN
    // ==========================================================
    final List<Color> borderColors = effects.borderGradient.isEmpty
        ? [
            Colors.white.withValues(alpha: 0.85),
            Colors.white.withValues(alpha: 0.20),
            Colors.white.withValues(alpha: 0.40),
          ]
        : effects.borderGradient;

    final Paint borderPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: borderColors,
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    canvas.drawPath(shapePath, borderPaint);
  }

  @override
  bool shouldRepaint(covariant GlassPainter oldDelegate) {
    return oldDelegate.effects != effects ||
        oldDelegate.shapeType != shapeType ||
        oldDelegate.useAquaReflect != useAquaReflect ||
        oldDelegate.customRadius != customRadius;
  }
}