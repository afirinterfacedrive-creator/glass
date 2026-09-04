import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:universal_glass/glass.dart';

class GlassActionIcon extends ConsumerWidget {
  final Widget? child;
  final IconData? icon;
  final bool isHovered;
  final bool isActive;
  final bool enabled;
  final VoidCallback? onTap;
  final GlassColorPalette? palette; 
  final bool useAquaStyle; 
  final double size;
  final bool useTintedIcon; 
  final bool isInputFieldStyle; 
  final Color? color; // <- NOUVEAU: force la couleur de l'icone
  final Color? glowColor; // <- NOUVEAU: force la couleur du glow

  const GlassActionIcon({
    super.key,
    this.child,
    this.icon,
    this.isHovered = false,
    this.isActive = false,
    this.enabled = true,
    this.onTap,
    this.palette,
    this.useAquaStyle = true,
    this.size = 44,
    this.useTintedIcon = true, 
    this.isInputFieldStyle = false, 
    this.color, // <- NOUVEAU
    this.glowColor, // <- NOUVEAU
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GlassThemeState theme = ref.watch(glassThemeProvider);
    final bool useAqua = theme.useAquaStyle;
    final GlassColorPalette effectivePalette = palette ?? (useAqua ? GlassColorPalette.aquaPreset() : GlassColorPalette.classicPreset());

    final Color primary = effectivePalette.primaryForStyle(useAqua);
    final Color light = effectivePalette.lightForStyle(useAqua);
    final Color dark = effectivePalette.darkForStyle(useAqua);

    final bool highlighted = isHovered || isActive;
    final double surfaceAlpha = highlighted ? 0.34 : 0.20;
    
    // Bordure
    final Color borderColor = highlighted 
        ? light.withValues(alpha: 0.50) 
        : primary.withValues(alpha: 0.20);
    
    final double borderWidth = highlighted ? 0.95 : 0.72;

    // GLOW PROJETE: utilise glowColor si fourni
    final Color effectiveGlowColor = glowColor ?? primary;
    final List<BoxShadow> glow = isInputFieldStyle
        ? []
        : highlighted
            ? [
                BoxShadow(color: effectiveGlowColor.withValues(alpha: useAqua ? 0.25 : 0.32), blurRadius: 20, offset: Offset.zero),
                BoxShadow(color: dark.withValues(alpha: 0.15), blurRadius: 14, offset: const Offset(0, 5)),
              ]
            : [BoxShadow(color: effectivePalette.black.withValues(alpha: 0.14), blurRadius: 12, offset: const Offset(0, 5))];

    // COULEUR ICONE: priorite a color > useTintedIcon > default
    final Color iconColor = !enabled 
        ? effectivePalette.textPrimary.withValues(alpha: 0.4)
        : color ?? (useTintedIcon ? (highlighted ? light : primary) : effectivePalette.textPrimary);

    final double effectiveSize = isInputFieldStyle ? 36.0 : size;

    return MouseRegion(
      cursor: enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: enabled ? onTap : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          width: effectiveSize,
          height: effectiveSize,
          transform: Matrix4.translationValues(0, (highlighted && !isInputFieldStyle) ? -2 : 0, 0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                effectivePalette.white.withValues(alpha: surfaceAlpha),
                primary.withValues(alpha: surfaceAlpha * 0.65), 
              ],
            ),
            border: Border.all(color: borderColor, width: borderWidth),
            boxShadow: glow,
          ),
          child: Center(
            child: child ??
                Icon(
                  icon,
                  size: effectiveSize * 0.60, 
                  color: iconColor,
                  weight: isInputFieldStyle ? 150.0 : null, // Finesse glyphe
                ),
          ),
        ),
      ),
    );
  }
}