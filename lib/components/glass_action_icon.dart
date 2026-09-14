
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

  final Color? color;
  final Color? glowColor;

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
    this.size = 44.0,
    this.useTintedIcon = true,
    this.isInputFieldStyle = false,
    this.color,
    this.glowColor,
  });

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final GlassThemeState theme =
        ref.watch(glassThemeProvider);

    final bool useAqua =
        theme.useAquaStyle;

    // -------------------------------------------------------------------------
    // PALETTE
    // -------------------------------------------------------------------------

    final GlassColorPalette effectivePalette =
        palette ??
        (
          useAqua
              ? GlassColorPalette.aquaPreset()
              : GlassColorPalette.classicPreset()
        );

    final Color primary =
        effectivePalette.primaryForStyle(useAqua);

    final Color light =
        effectivePalette.lightForStyle(useAqua);

    final Color dark =
        effectivePalette.darkForStyle(useAqua);

    // -------------------------------------------------------------------------
    // ETAT ACTIF
    //
    // Pour un input :
    //   - seul isActive contrôle le glow
    //   - le hover ne modifie pas l'état
    //
    // Pour une action classique :
    //   - hover OU active déclenche l'état visuel
    // -------------------------------------------------------------------------

    final bool shouldGlow =
        isInputFieldStyle
            ? isActive
            : (isHovered || isActive);

    // -------------------------------------------------------------------------
    // OPACITE DE SURFACE
    // -------------------------------------------------------------------------

    final double surfaceAlpha =
        shouldGlow ? 0.34 : 0.20;

    // -------------------------------------------------------------------------
    // BORDURE
    // -------------------------------------------------------------------------

    final Color borderColor =
        shouldGlow
            ? light.withValues(alpha: 0.50)
            : primary.withValues(alpha: 0.20);

    final double borderWidth =
        shouldGlow ? 0.95 : 0.72;

    // -------------------------------------------------------------------------
    // GLOW
    //
    // Un glow transparent doit réellement désactiver le glow.
    // C'est important notamment pour les états où l'appelant transmet
    // Colors.transparent.
    // -------------------------------------------------------------------------

    final Color effectiveGlowColor =
        glowColor ?? primary;

    final bool hasEffectiveGlow =
        shouldGlow &&
        effectiveGlowColor.a > 0.0;

    // -------------------------------------------------------------------------
    // OMBRES
    // -------------------------------------------------------------------------

    final List<BoxShadow> shadows;

    if (hasEffectiveGlow) {
      shadows = <BoxShadow>[
        BoxShadow(
          color: effectiveGlowColor.withValues(
            alpha: isInputFieldStyle
                ? 0.40
                : (useAqua ? 0.30 : 0.36),
          ),
          blurRadius:
              isInputFieldStyle ? 22.0 : 20.0,
          spreadRadius:
              isInputFieldStyle ? 1.0 : 0.0,
          offset: Offset.zero,
        ),
        BoxShadow(
          color: effectiveGlowColor.withValues(
            alpha: isInputFieldStyle
                ? 0.18
                : (useAqua ? 0.12 : 0.16),
          ),
          blurRadius:
              isInputFieldStyle ? 10.0 : 8.0,
          spreadRadius:
              isInputFieldStyle ? 2.0 : 1.0,
          offset: Offset.zero,
        ),
        BoxShadow(
          color: dark.withValues(
            alpha: 0.15,
          ),
          blurRadius: 14.0,
          spreadRadius: 0.0,
          offset: const Offset(0.0, 5.0),
        ),
      ];
    } else {
      shadows = <BoxShadow>[
        BoxShadow(
          color: effectivePalette.black.withValues(
            alpha: 0.14,
          ),
          blurRadius: 12.0,
          spreadRadius: 0.0,
          offset: const Offset(0.0, 5.0),
        ),
      ];
    }

    // -------------------------------------------------------------------------
    // COULEUR DE L'ICONE
    // -------------------------------------------------------------------------

    final Color iconColor;

    if (!enabled) {
      iconColor =
          effectivePalette.textPrimary.withValues(
        alpha: 0.40,
      );
    } else if (color != null) {
      iconColor = color!;
    } else if (useTintedIcon) {
      iconColor =
          shouldGlow ? light : primary;
    } else {
      iconColor =
          effectivePalette.textPrimary;
    }

    // -------------------------------------------------------------------------
    // DIMENSION
    //
    // Les inputs utilisent volontairement une dimension interne fixe.
    // Cela évite que la taille de la bulle varie selon le composant parent.
    // -------------------------------------------------------------------------

    final double effectiveSize =
        isInputFieldStyle ? 36.0 : size;

    // -------------------------------------------------------------------------
    // MOUVEMENT
    //
    // Aucun déplacement pour les inputs.
    // Les boutons classiques peuvent légèrement monter lorsqu'ils sont actifs.
    // -------------------------------------------------------------------------

    final double verticalOffset =
        shouldGlow && !isInputFieldStyle
            ? -2.0
            : 0.0;

    // -------------------------------------------------------------------------
    // INTERACTION
    // -------------------------------------------------------------------------

    final bool canTap =
        enabled && onTap != null;

    return MouseRegion(
      cursor: canTap
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: canTap ? onTap : null,
        child: AnimatedContainer(
          duration: const Duration(
            milliseconds: 180,
          ),
          curve: Curves.easeOut,
          width: effectiveSize,
          height: effectiveSize,
          transform: Matrix4.translationValues(
            0.0,
            verticalOffset,
            0.0,
          ),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                effectivePalette.white.withValues(
                  alpha: surfaceAlpha,
                ),
                primary.withValues(
                  alpha: surfaceAlpha * 0.65,
                ),
              ],
            ),
            border: Border.all(
              color: borderColor,
              width: borderWidth,
            ),
            boxShadow: shadows,
          ),
          child: Center(
            child: child ??
                Icon(
                  icon,
                  size: effectiveSize * 0.60,
                  color: iconColor,
                  weight:
                      isInputFieldStyle
                          ? 150.0
                          : null,
                ),
          ),
        ),
      ),
    );
  }
}
