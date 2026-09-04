import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:universal_glass/components/surface/glass_surface_container.dart';
import 'package:universal_glass/enums/glass_enums.dart';
import 'package:universal_glass/theme/glass_effects.dart';
import 'package:universal_glass/provider/glass_theme_provider.dart';

class GlassContainer extends ConsumerWidget {
  final Widget child; 
  final GlassEffects? effects; 
  final EdgeInsetsGeometry? padding; 
  final EdgeInsetsGeometry? margin; 
  final BorderRadius? borderRadius; 
  final double? width; 
  final double? height; 
  final GlassStyle style;
  final List<Color>? customGradient; 
  final String? customKey; 
  final Clip clipBehavior;
  final bool liftOnHover; // <- AJOUT 1
  final VoidCallback? onTap; // <- AJOUT 2 au cas où
  final bool isFocused; // <- AJOUT 3
  final bool hasError; // <- AJOUT 4

  const GlassContainer({ 
    super.key, 
    required this.child, 
    this.effects, 
    this.padding, 
    this.margin, 
    this.borderRadius, 
    this.width, 
    this.height, 
    this.style = GlassStyle.transparentAqua,
    this.customGradient, 
    this.customKey, 
    this.clipBehavior = Clip.none,
    this.liftOnHover = false, // <- AJOUT 5 defaut false
    this.onTap,
    this.isFocused = false,
    this.hasError = false,
  }); 

  @override 
  Widget build(BuildContext context, WidgetRef ref) { 
    final theme = ref.watch(glassThemeProvider); 
    final screenWidth = MediaQuery.sizeOf(context).width;
    final bool isSmallScreen = screenWidth < 375;

    final effectivePadding = padding ?? EdgeInsets.all(isSmallScreen ? 10 : 16);

    Widget container = GlassSurfaceContainer( 
      effects: effects, 
      padding: effectivePadding, 
      borderRadius: borderRadius, 
      width: width, 
      height: height, 
      clipBehavior: clipBehavior, 
      style: style,
      customGradient: customGradient ?? theme.activeGradient, 
      customKey: customKey,
      liftOnHover: liftOnHover, // <- AJOUT 6 FORWARD
      onTap: onTap,
      isFocused: isFocused,
      hasError: hasError,
      child: child, 
    ); 
 
    if (margin != null) { 
      container = Padding(padding: margin!, child: container); 
    } 
 
    return container; 
  } 
}