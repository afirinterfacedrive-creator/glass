import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glass/provider/glass_theme_provider.dart';

/// ============================================================================
/// GLASS BACKGROUND
///
/// Fond global commun à toutes les pages Glass.
///
/// Le composant récupère automatiquement le thème depuis
/// glassThemeProvider.
///
/// Utilisation :
///
/// const GlassBackground()
///
/// Aucun besoin de transmettre :
/// - useAquaStyle
/// - GlassStyle
/// - GlassEffects
///
/// Le changement de thème est automatiquement répercuté.
/// ============================================================================

class GlassBackground extends ConsumerWidget {
  /// Contenu éventuellement placé au-dessus du fond.
  final Widget? child;

  /// Afficher les halos lumineux.
  final bool showGlow;

  /// Afficher la lumière diffuse.
  final bool showLight;

  /// Opacité générale du fond.
  final double opacity;

  const GlassBackground({
    super.key,
    this.child,
    this.showGlow = true,
    this.showLight = true,
    this.opacity = 1.0,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(glassThemeProvider);

    return SizedBox.expand(
      child: Stack(
        fit: StackFit.expand,
        children: [
          // ================================================================
          // FOND PRINCIPAL
          // ================================================================
          _GlassGradientBackground(
            useAquaStyle: theme.useAquaStyle,
            opacity: opacity,
          ),

          // ================================================================
          // HALOS
          // ================================================================
          if (showGlow) _GlassGlow(useAquaStyle: theme.useAquaStyle),

          // ================================================================
          // LUMIÈRE DIFFUSE
          // ================================================================
          if (showLight) _GlassLight(useAquaStyle: theme.useAquaStyle),

          // ================================================================
          // CONTENU
          // ================================================================
          if (child != null) child!,
        ],
      ),
    );
  }
}

/// ============================================================================
/// FOND DÉGRADÉ
/// ============================================================================

class _GlassGradientBackground extends StatelessWidget {
  final bool useAquaStyle;
  final double opacity;

  const _GlassGradientBackground({
    required this.useAquaStyle,
    required this.opacity,
  });

  @override
  Widget build(BuildContext context) {
    final List<Color> colors = useAquaStyle
        ? const [Color(0xFFB1755D), Color(0xFF02315A), Color(0xFF0D0D17)]
        : const [Color(0xFF242424), Color(0xFF111111), Color(0xFF050505)];

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: colors
              .map((color) => color.withValues(alpha: opacity))
              .toList(),
        ),
      ),
    );
  }
}

/// ============================================================================
/// HALOS LUMINEUX
/// ============================================================================

class _GlassGlow extends StatelessWidget {
  final bool useAquaStyle;

  const _GlassGlow({required this.useAquaStyle});

  @override
  Widget build(BuildContext context) {
    final Color primaryGlow = useAquaStyle ? Colors.cyanAccent : Colors.white;

    final Color secondaryGlow = useAquaStyle ? Colors.blueAccent : Colors.grey;

    return IgnorePointer(
      child: Stack(
        fit: StackFit.expand,
        children: [
          // ==============================================================
          // HALO SUPÉRIEUR DROIT
          // ==============================================================
          Positioned(
            top: -120,
            right: -100,
            child: _GlowCircle(
              size: 300,
              color: primaryGlow,
              opacity: useAquaStyle ? .12 : .045,
            ),
          ),

          // ==============================================================
          // HALO INFÉRIEUR GAUCHE
          // ==============================================================
          Positioned(
            bottom: -160,
            left: -120,
            child: _GlowCircle(
              size: 340,
              color: secondaryGlow,
              opacity: useAquaStyle ? .10 : .035,
            ),
          ),
        ],
      ),
    );
  }
}

/// ============================================================================
/// CERCLE DE LUMIÈRE
/// ============================================================================

class _GlowCircle extends StatelessWidget {
  final double size;
  final Color color;
  final double opacity;

  const _GlowCircle({
    required this.size,
    required this.color,
    required this.opacity,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              color.withValues(alpha: opacity),
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }
}

/// ============================================================================
/// LUMIÈRE DIFFUSE
/// ============================================================================

class _GlassLight extends StatelessWidget {
  final bool useAquaStyle;

  const _GlassLight({required this.useAquaStyle});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: const Alignment(-0.8, -0.9),
            radius: 1.2,
            colors: [
              Colors.white.withValues(alpha: useAquaStyle ? .045 : .018),
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }
}
