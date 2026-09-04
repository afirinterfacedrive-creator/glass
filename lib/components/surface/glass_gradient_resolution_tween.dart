import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:universal_glass/utils/glass_surface_gradient_resolver.dart'; // Import de GlassGradientResolution

/// Tween personnalisé pour interpoler de manière fluide deux dégradés de verre asymétriques.
class GlassGradientResolutionTween extends Tween<GlassGradientResolution> {
  GlassGradientResolutionTween({super.begin, super.end});

  @override
  GlassGradientResolution lerp(double t) {
    if (begin == null && end == null) return const GlassGradientResolution(colors: []);
    if (begin == null) return end!;
    if (end == null) return begin!;

    final List<Color> interpolatedColors = [];
    final int maxColors = begin!.colors.length > end!.colors.length 
        ? begin!.colors.length 
        : end!.colors.length;

    // Interpolation des couleurs
    for (int i = 0; i < maxColors; i++) {
      final Color c1 = i < begin!.colors.length ? begin!.colors[i] : begin!.colors.last;
      final Color c2 = i < end!.colors.length ? end!.colors[i] : end!.colors.last;
      interpolatedColors.add(Color.lerp(c1, c2, t)!);
    }

    // Interpolation des stops
    List<double>? interpolatedStops;
    if (begin!.stops != null || end!.stops != null) {
      interpolatedStops = [];
      final List<double> s1 = begin!.stops ?? List.generate(begin!.colors.length, (idx) => idx / (begin!.colors.length - 1));
      final List<double> s2 = end!.stops ?? List.generate(end!.colors.length, (idx) => idx / (end!.colors.length - 1));
      
      for (int i = 0; i < maxColors; i++) {
        final double stop1 = i < s1.length ? s1[i] : 1.0;
        final double stop2 = i < s2.length ? s2[i] : 1.0;
        interpolatedStops.add(ui.lerpDouble(stop1, stop2, t)!);
      }
    }

    return GlassGradientResolution(colors: interpolatedColors, stops: interpolatedStops);
  }
}
