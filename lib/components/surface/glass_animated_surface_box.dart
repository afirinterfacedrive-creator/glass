import 'package:flutter/material.dart';
import 'package:universal_glass/components/surface/glass_surface_gradient_resolver.dart';

class GlassAnimatedSurfaceBox extends StatelessWidget {
  final Widget child;
  final bool animateHover;
  final bool isHovered;
  final double? width;
  final double? height;
  final BoxConstraints? constraints;
  final EdgeInsetsGeometry padding;
  final BorderRadius radius;
  final GlassGradientResolution animatedGradient;
  final Color animatedBorderColor;
  final double animatedBorderWidth;
  final List<BoxShadow> cardGlow;
  final bool isClassicSb;
  final bool isGhost;

  const GlassAnimatedSurfaceBox({
    super.key,
    required this.child,
    required this.animateHover,
    required this.isHovered,
    required this.width,
    required this.height,
    required this.constraints,
    required this.padding,
    required this.radius,
    required this.animatedGradient,
    required this.animatedBorderColor,
    required this.animatedBorderWidth,
    required this.cardGlow,
    required this.isClassicSb,
    required this.isGhost,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: animateHover ? const Duration(milliseconds: 180) : Duration.zero,
      curve: Curves.easeOut,
      width: width,
      height: height,
      constraints: constraints,
      transform: Matrix4.translationValues(0, animateHover && isHovered ? -3 : 0, 0),
      padding: padding,
      decoration: BoxDecoration(
        gradient: animatedGradient.colors.isNotEmpty
            ? LinearGradient(
                begin: isClassicSb ? Alignment.topLeft : Alignment.topCenter,
                end: isClassicSb ? Alignment.bottomRight : Alignment.bottomCenter,
                colors: animatedGradient.colors,
                stops: animatedGradient.stops,
              )
            : null,
        borderRadius: radius,
        border: isGhost ? null : Border.all(color: animatedBorderColor, width: animatedBorderWidth),
        boxShadow: cardGlow,
      ),
      child: child,
    );
  }
}
