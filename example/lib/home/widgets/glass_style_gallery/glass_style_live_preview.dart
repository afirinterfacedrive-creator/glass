
import 'package:flutter/material.dart';
import 'package:universal_glass/glass.dart';

class GlassStyleLivePreview extends StatelessWidget {
  final GlassThemeState theme;
  final bool isMobile;
  final String title;
  final String description;
  final IconData icon;

  const GlassStyleLivePreview({
    super.key,
    required this.theme,
    required this.isMobile,
    required this.title,
    required this.description,
    required this.icon,
  });

  // ==========================================================================
  // ACCENT
  // ==========================================================================

  Color get _accentColor {
    switch (theme.glassStyle) {
      case GlassStyle.transparentAqua:
      case GlassStyle.solidAqua:
        return Colors.cyanAccent;

      case GlassStyle.transparentRed:
        return Colors.redAccent;

      case GlassStyle.transparentGreen:
        return Colors.greenAccent;

      case GlassStyle.gradientOpaque:
      case GlassStyle.customGradient:
        return Colors.blueAccent;

      case GlassStyle.classicSb:
      case GlassStyle.solidClassic:
      case GlassStyle.opaqueMat:
      case GlassStyle.opaqueHeavy:
      case GlassStyle.custom:
        return Colors.orangeAccent;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color accent = _accentColor;

    return GlassSurfaceContainer(
      style: theme.glassStyle,
      liftOnHover: false,
      borderRadius: BorderRadius.circular(24),
      padding: EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: SizedBox(
          width: double.infinity,
          height: isMobile ? 156 : 190,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // =================================================================
              // ACCENT GLOW
              // =================================================================

              Positioned(
                right: isMobile ? -35 : -20,
                top: isMobile ? -40 : -55,
                child: Container(
                  width: isMobile ? 130 : 180,
                  height: isMobile ? 130 : 180,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: accent.withValues(
                          alpha: 0.10,
                        ),
                        blurRadius: 55,
                        spreadRadius: 8,
                      ),
                    ],
                  ),
                ),
              ),

              // =================================================================
              // ACCENT LINE
              // =================================================================

              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: Container(
                  width: 3,
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.65),
                    boxShadow: [
                      BoxShadow(
                        color: accent.withValues(alpha: 0.35),
                        blurRadius: 12,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
              ),

              // =================================================================
              // CONTENT
              // =================================================================

              Positioned.fill(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 18 : 26,
                    vertical: isMobile ? 18 : 24,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _PreviewContent(
                          theme: theme,
                          accent: accent,
                          title: title,
                          description: description,
                          isMobile: isMobile,
                        ),
                      ),

                      SizedBox(
                        width: isMobile ? 12 : 18,
                      ),

                      // =========================================================
                      // LARGE ICON
                      // =========================================================

                      _PreviewIcon(
                        icon: icon,
                        accent: accent,
                        size: isMobile ? 58 : 76,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// PREVIEW CONTENT
// =============================================================================

class _PreviewContent extends StatelessWidget {
  final GlassThemeState theme;
  final Color accent;
  final String title;
  final String description;
  final bool isMobile;

  const _PreviewContent({
    required this.theme,
    required this.accent,
    required this.title,
    required this.description,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // =========================================================================
        // PREVIEW LABEL
        // =========================================================================

        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: accent,
                boxShadow: [
                  BoxShadow(
                    color: accent.withValues(
                      alpha: 0.55,
                    ),
                    blurRadius: 7,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 7),
            Flexible(
              child: Text(
                'PREVIEW LIVE',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: accent.withValues(alpha: 0.9),
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.6,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 9),

        // =========================================================================
        // TITLE
        // =========================================================================

        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.96),
            fontSize: isMobile ? 22 : 27,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
          ),
        ),

        const SizedBox(height: 7),

        // =========================================================================
        // DESCRIPTION
        // =========================================================================

        Text(
          description,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.60),
            fontSize: isMobile ? 11 : 12.5,
            height: 1.4,
          ),
        ),

        const SizedBox(height: 12),

        // =========================================================================
        // STYLE STATUS
        // =========================================================================

        _StyleStatus(
          theme: theme,
          accent: accent,
        ),
      ],
    );
  }
}

// =============================================================================
// STYLE STATUS
// =============================================================================

class _StyleStatus extends StatelessWidget {
  final GlassThemeState theme;
  final Color accent;

  const _StyleStatus({
    required this.theme,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _StatusChip(
          icon: theme.enableBlur
              ? Icons.blur_on_rounded
              : Icons.blur_off_rounded,
          label: theme.enableBlur ? 'BLUR' : 'NO BLUR',
          accent: accent,
          active: theme.enableBlur,
        ),
        const SizedBox(width: 7),
        _StatusChip(
          icon: Icons.opacity_rounded,
          label: '${(theme.surfaceOpacity * 100).round()}%',
          accent: accent,
          active: true,
        ),
      ],
    );
  }
}

// =============================================================================
// STATUS CHIP
// =============================================================================

class _StatusChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color accent;
  final bool active;

  const _StatusChip({
    required this.icon,
    required this.label,
    required this.accent,
    required this.active,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: accent.withValues(
          alpha: active ? 0.09 : 0.045,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: accent.withValues(
            alpha: active ? 0.22 : 0.10,
          ),
          width: 0.7,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 11,
            color: accent.withValues(
              alpha: active ? 0.85 : 0.45,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              color: accent.withValues(
                alpha: active ? 0.78 : 0.45,
              ),
              fontSize: 8,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// PREVIEW ICON
// =============================================================================

class _PreviewIcon extends StatelessWidget {
  final IconData icon;
  final Color accent;
  final double size;

  const _PreviewIcon({
    required this.icon,
    required this.accent,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final double containerSize = size + 30;

    return SizedBox(
      width: containerSize,
      height: containerSize,
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: accent.withValues(alpha: 0.055),
          border: Border.all(
            color: accent.withValues(alpha: 0.16),
            width: 0.8,
          ),
          boxShadow: [
            BoxShadow(
              color: accent.withValues(alpha: 0.08),
              blurRadius: 28,
              spreadRadius: -4,
            ),
          ],
        ),
        child: Center(
          child: Icon(
            icon,
            size: size,
            color: accent.withValues(alpha: 0.42),
          ),
        ),
      ),
    );
  }
}
