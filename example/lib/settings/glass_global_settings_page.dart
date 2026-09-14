import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:universal_glass/glass.dart';

class GlassGlobalSettingsPage extends ConsumerWidget {
  const GlassGlobalSettingsPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GlassThemeState theme = ref.watch(glassThemeProvider);
    final GlassThemeNotifier notifier = ref.read(glassThemeProvider.notifier);
    return GlassScaffold(
      title: 'Glass Settings',
      subtitle: 'GLOBAL GLASS CONFIGURATION',
      showLogo: true,
      showBackButton: true,
      hideNavigation: true,
      blur: theme.effectiveBlur,
      noise: theme.effectiveNoise,
      maxWidth: 1400.0,
      child: Builder(
        builder: (BuildContext context) {
          final GlassLayoutContext glass = GlassLayoutScope.of(context);
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: glass.dynamicPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _GlassGlobalHeader(theme: theme, glass: glass),
                SizedBox(height: glass.spacing(20.0)),
                _GlassAppearanceSection(
                  theme: theme,
                  notifier: notifier,
                  glass: glass,
                ),
                SizedBox(height: glass.spacing(20.0)),
                _GlassGlobalInfoSection(theme: theme, glass: glass),
                SizedBox(height: glass.spacing(28.0)),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ============================================================================
// GLOBAL HEADER
// ============================================================================
class _GlassGlobalHeader extends StatelessWidget {
  const _GlassGlobalHeader({required this.theme, required this.glass});
  final GlassThemeState theme;
  final GlassLayoutContext glass;
  @override
  Widget build(BuildContext context) {
    final Color accentColor = theme.useAquaStyle
        ? Colors.cyanAccent
        : Colors.pinkAccent;
    return GlassSurfaceContainer(
      style: theme.glassStyle,
      effects: theme.effects,
      borderRadius: BorderRadius.circular(glass.isSmallMobile ? 16.0 : 20.0),
      padding: EdgeInsets.all(glass.isSmallMobile ? 16.0 : 20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _HeaderIcon(
            color: accentColor,
            size: glass.isSmallMobile ? 42.0 : 46.0,
          ),
          SizedBox(width: glass.spacing(14.0)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Glass Settings',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: glass.fontSize(glass.isSmallMobile ? 18.0 : 20.0),
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.3,
                  ),
                ),
                SizedBox(height: glass.spacing(5.0)),
                Text(
                  'Configuration globale du système Glass',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.55),
                    fontSize: glass.fontSize(11.0),
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          if (!glass.isSmallMobile) ...[
            SizedBox(width: glass.spacing(12.0)),
            _StyleBadge(style: theme.glassStyle, color: accentColor),
          ],
        ],
      ),
    );
  }
}

// ============================================================================
// HEADER ICON
// ============================================================================
class _HeaderIcon extends StatelessWidget {
  const _HeaderIcon({required this.color, required this.size});
  final Color color;
  final double size;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14.0),
        color: color.withValues(alpha: 0.09),
        border: Border.all(color: color.withValues(alpha: 0.20), width: 0.8),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.08),
            blurRadius: 18.0,
            spreadRadius: -3.0,
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Icon(Icons.tune_rounded, color: color, size: size * 0.46),
    );
  }
}

// ============================================================================
// STYLE BADGE
// ============================================================================
class _StyleBadge extends StatelessWidget {
  const _StyleBadge({required this.style, required this.color});
  final GlassStyle style;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 135.0),
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 7.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: color.withValues(alpha: 0.06),
        border: Border.all(color: color.withValues(alpha: 0.14), width: 0.7),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6.0,
            height: 6.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.45),
                  blurRadius: 6.0,
                ),
              ],
            ),
          ),
          const SizedBox(width: 7.0),
          Flexible(
            child: Text(
              _formatStyleName(style),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: color.withValues(alpha: 0.82),
                fontSize: 8.0,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.55,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatStyleName(GlassStyle style) {
    switch (style) {
      case GlassStyle.opaqueMat:
        return 'OPAQUE MAT';
      case GlassStyle.gradientOpaque:
        return 'GRADIENT';
      case GlassStyle.customGradient:
        return 'CUSTOM GRADIENT';
      case GlassStyle.solidAqua:
        return 'SOLID AQUA';
      case GlassStyle.solidClassic:
        return 'SOLID CLASSIC';
      case GlassStyle.opaqueHeavy:
        return 'OPAQUE HEAVY';
      case GlassStyle.transparentAqua:
        return 'TRANSPARENT AQUA';
      case GlassStyle.transparentRed:
        return 'TRANSPARENT RED';
      case GlassStyle.transparentGreen:
        return 'TRANSPARENT GREEN';
      case GlassStyle.classicSb:
        return 'CLASSIC SB';
      case GlassStyle.custom:
        return 'CUSTOM';
    }
  }
}

// ============================================================================
// APPEARANCE / STYLE
// ============================================================================
class _GlassAppearanceSection extends StatelessWidget {
  const _GlassAppearanceSection({
    required this.theme,
    required this.notifier,
    required this.glass,
  });
  final GlassThemeState theme;
  final GlassThemeNotifier notifier;
  final GlassLayoutContext glass;
  @override
  Widget build(BuildContext context) {
    return GlassSurfaceContainer(
      style: theme.glassStyle,
      effects: theme.effects,
      borderRadius: BorderRadius.circular(glass.isSmallMobile ? 16.0 : 20.0),
      padding: EdgeInsets.all(glass.isSmallMobile ? 14.0 : 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const GlassSectionHeader(
            title: 'Appearance',
            subtitle: 'Style global de l’interface Glass',
            icon: Icons.palette_rounded,
          ),
          SizedBox(height: glass.spacing(18.0)),
          _GlassStyleSelector(theme: theme, notifier: notifier, glass: glass),
        ],
      ),
    );
  }
}

// ============================================================================
// STYLE SELECTOR
// ============================================================================
class _GlassStyleSelector extends StatelessWidget {
  const _GlassStyleSelector({
    required this.theme,
    required this.notifier,
    required this.glass,
  });
  final GlassThemeState theme;
  final GlassThemeNotifier notifier;
  final GlassLayoutContext glass;
  @override
  Widget build(BuildContext context) {
    final Color accentColor = theme.useAquaStyle
        ? Colors.cyanAccent
        : Colors.pinkAccent;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Glass Style',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.88),
            fontSize: glass.fontSize(12.0),
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: glass.spacing(8.0)),
        GlassResponsiveGrid(
          mobileColumns: 1,
          tabletColumns: 2,
          desktopColumns: 4,
          spacing: 8.0,
          runSpacing: 8.0,
          expandItems: true,
          children: [
            for (final GlassStyle style in GlassStyle.values)
              _GlassStyleOption(
                style: style,
                selected: theme.glassStyle == style,
                accentColor: accentColor,
                onTap: () {
                  if (theme.glassStyle == style) {
                    return;
                  }
                  notifier.setGlassStyle(style);
                },
              ),
          ],
        ),
      ],
    );
  }
}

// ============================================================================
// STYLE OPTION
// ============================================================================
class _GlassStyleOption extends StatelessWidget {
  const _GlassStyleOption({
    required this.style,
    required this.selected,
    required this.accentColor,
    required this.onTap,
  });
  final GlassStyle style;
  final bool selected;
  final Color accentColor;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(13.0),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          constraints: const BoxConstraints(minHeight: 52.0),
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(13.0),
            color: selected
                ? accentColor.withValues(alpha: 0.075)
                : Colors.white.withValues(alpha: 0.025),
            border: Border.all(
              color: selected
                  ? accentColor.withValues(alpha: 0.20)
                  : Colors.white.withValues(alpha: 0.065),
              width: selected ? 0.9 : 0.7,
            ),
          ),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 27.0,
                height: 27.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: selected
                      ? accentColor.withValues(alpha: 0.13)
                      : Colors.white.withValues(alpha: 0.045),
                ),
                child: Icon(
                  _styleIcon(style),
                  size: 14.0,
                  color: selected
                      ? accentColor
                      : Colors.white.withValues(alpha: 0.42),
                ),
              ),
              const SizedBox(width: 9.0),
              Expanded(
                child: Text(
                  _styleName(style),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: selected
                        ? Colors.white.withValues(alpha: 0.94)
                        : Colors.white.withValues(alpha: 0.58),
                    fontSize: 10.5,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ),
              if (selected) ...[
                const SizedBox(width: 6.0),
                Icon(
                  Icons.check_circle_rounded,
                  size: 14.0,
                  color: accentColor,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _styleName(GlassStyle style) {
    switch (style) {
      case GlassStyle.opaqueMat:
        return 'Opaque Mat';
      case GlassStyle.gradientOpaque:
        return 'Gradient';
      case GlassStyle.customGradient:
        return 'Custom Gradient';
      case GlassStyle.solidAqua:
        return 'Solid Aqua';
      case GlassStyle.solidClassic:
        return 'Solid Classic';
      case GlassStyle.opaqueHeavy:
        return 'Opaque Heavy';
      case GlassStyle.transparentAqua:
        return 'Transparent Aqua';
      case GlassStyle.transparentRed:
        return 'Transparent Red';
      case GlassStyle.transparentGreen:
        return 'Transparent Green';
      case GlassStyle.classicSb:
        return 'Classic SB';
      case GlassStyle.custom:
        return 'Custom';
    }
  }

  IconData _styleIcon(GlassStyle style) {
    switch (style) {
      case GlassStyle.opaqueMat:
        return Icons.blur_on_rounded;
      case GlassStyle.gradientOpaque:
        return Icons.gradient_rounded;
      case GlassStyle.customGradient:
        return Icons.colorize_rounded;
      case GlassStyle.solidAqua:
        return Icons.water_drop_rounded;
      case GlassStyle.solidClassic:
        return Icons.dark_mode_rounded;
      case GlassStyle.opaqueHeavy:
        return Icons.layers_rounded;
      case GlassStyle.transparentAqua:
        return Icons.water_rounded;
      case GlassStyle.transparentRed:
        return Icons.local_fire_department_rounded;
      case GlassStyle.transparentGreen:
        return Icons.eco_rounded;
      case GlassStyle.classicSb:
        return Icons.crop_square_rounded;
      case GlassStyle.custom:
        return Icons.tune_rounded;
    }
  }
}

// ============================================================================
// GLOBAL INFORMATION
// ============================================================================
class _GlassGlobalInfoSection extends StatelessWidget {
  const _GlassGlobalInfoSection({required this.theme, required this.glass});
  final GlassThemeState theme;
  final GlassLayoutContext glass;
  @override
  Widget build(BuildContext context) {
    final Color accentColor = theme.useAquaStyle
        ? Colors.cyanAccent
        : Colors.pinkAccent;
    return GlassSurfaceContainer(
      style: theme.glassStyle,
      effects: theme.effects,
      borderRadius: BorderRadius.circular(glass.isSmallMobile ? 16.0 : 20.0),
      padding: EdgeInsets.all(glass.isSmallMobile ? 14.0 : 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const GlassSectionHeader(
            title: 'Configuration',
            subtitle: 'État global actuel du système Glass',
            icon: Icons.settings_rounded,
          ),
          SizedBox(height: glass.spacing(16.0)),
          GlassResponsiveGrid(
            mobileColumns: 1,
            tabletColumns: 2,
            desktopColumns: 4,
            spacing: 10.0,
            runSpacing: 10.0,
            expandItems: true,
            children: [
              _InfoItem(
                label: 'Style',
                value: _formatStyleName(theme.glassStyle),
                icon: Icons.layers_rounded,
                accentColor: accentColor,
              ),
              _InfoItem(
                label: 'Blur',
                value: theme.enableBlur ? 'ACTIF' : 'OFF',
                icon: Icons.blur_on_rounded,
                accentColor: accentColor,
              ),
              _InfoItem(
                label: 'Gradient',
                value: theme.enableGradient ? 'ACTIF' : 'OFF',
                icon: Icons.gradient_rounded,
                accentColor: accentColor,
              ),
              _InfoItem(
                label: 'Border',
                value: theme.enableBorder ? 'ACTIF' : 'OFF',
                icon: Icons.border_style_rounded,
                accentColor: accentColor,
              ),
            ],
          ),
          SizedBox(height: glass.spacing(14.0)),
          Text(
            'Les réglages détaillés des effets visuels sont disponibles dans la Glass Style Gallery.',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.42),
              fontSize: glass.fontSize(10.5),
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }

  String _formatStyleName(GlassStyle style) {
    switch (style) {
      case GlassStyle.opaqueMat:
        return 'Opaque Mat';
      case GlassStyle.gradientOpaque:
        return 'Gradient';
      case GlassStyle.customGradient:
        return 'Custom Gradient';
      case GlassStyle.solidAqua:
        return 'Solid Aqua';
      case GlassStyle.solidClassic:
        return 'Solid Classic';
      case GlassStyle.opaqueHeavy:
        return 'Opaque Heavy';
      case GlassStyle.transparentAqua:
        return 'Transparent Aqua';
      case GlassStyle.transparentRed:
        return 'Transparent Red';
      case GlassStyle.transparentGreen:
        return 'Transparent Green';
      case GlassStyle.classicSb:
        return 'Classic SB';
      case GlassStyle.custom:
        return 'Custom';
    }
  }
}

// ============================================================================
// INFORMATION ITEM
// ============================================================================
class _InfoItem extends StatelessWidget {
  const _InfoItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.accentColor,
  });
  final String label;
  final String value;
  final IconData icon;
  final Color accentColor;
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 56.0),
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: Colors.white.withValues(alpha: 0.025),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.06),
          width: 0.7,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 28.0,
            height: 28.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: accentColor.withValues(alpha: 0.08),
            ),
            child: Icon(
              icon,
              size: 14.0,
              color: accentColor.withValues(alpha: 0.80),
            ),
          ),
          const SizedBox(width: 9.0),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.42),
                    fontSize: 8.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2.0),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.84),
                    fontSize: 10.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
