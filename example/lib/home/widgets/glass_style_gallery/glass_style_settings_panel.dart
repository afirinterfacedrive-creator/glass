import 'package:flutter/material.dart';
import 'package:universal_glass/glass.dart';

import 'glass_style_controls.dart';

class GlassStyleSettingsPanel extends StatelessWidget {
  final GlassThemeState theme;
  final GlassThemeNotifier notifier;
  final Color textColor;
  final Color accentColor;
  final bool isMobile;

  const GlassStyleSettingsPanel({
    super.key,
    required this.theme,
    required this.notifier,
    required this.textColor,
    required this.accentColor,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    final GlassLayoutContext? layout = context.maybeGlassLayout;

    final double horizontalPadding =
        isMobile
            ? 16.0
            : 22.0;

    final double verticalSpacing =
        layout?.spacing(20.0) ??
        (isMobile ? 16.0 : 20.0);

    return GlassSurfaceContainer(
      style: GlassStyle.opaqueHeavy,
      padding: EdgeInsets.all(horizontalPadding),
      borderRadius: BorderRadius.circular(22),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),

          SizedBox(height: verticalSpacing),

          _buildSectionTitle(
            icon: Icons.auto_awesome_rounded,
            title: 'Effets visuels',
            subtitle: 'Activez ou désactivez les effets du rendu',
          ),

          const SizedBox(height: 12),

          GlassStyleControls.buildSwitches(
            theme: theme,
            notifier: notifier,
            textColor: textColor,
            accentColor: accentColor,
          ),

          SizedBox(height: verticalSpacing),

          _buildDivider(),

          SizedBox(height: verticalSpacing),

          _buildSectionTitle(
            icon: Icons.tune_rounded,
            title: 'Paramètres du rendu',
            subtitle: 'Ajustez précisément chaque effet',
          ),

          const SizedBox(height: 14),

          _buildSliders(context),
        ],
      ),
    );
  }

  // ==========================================================================
  // HEADER
  // ==========================================================================

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildHeaderIcon(),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Paramètres avancés',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: textColor,
                  fontSize: isMobile ? 17.0 : 18.0,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.2,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                'Ajustez le rendu du style en temps réel',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: textColor.withValues(alpha: 0.52),
                  fontSize: 11.0,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),

        if (!isMobile) ...[
          const SizedBox(width: 10),
          _buildStyleIndicator(),
        ],
      ],
    );
  }

  // ==========================================================================
  // HEADER ICON
  // ==========================================================================

  Widget _buildHeaderIcon() {
    final double size = isMobile ? 40.0 : 42.0;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(13),
        color: accentColor.withValues(alpha: 0.10),
        border: Border.all(
          color: accentColor.withValues(alpha: 0.22),
          width: 0.8,
        ),
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha: 0.08),
            blurRadius: 16,
            spreadRadius: -3,
          ),
        ],
      ),
      child: Icon(
        Icons.tune_rounded,
        size: isMobile ? 19.0 : 20.0,
        color: accentColor,
      ),
    );
  }

  // ==========================================================================
  // STYLE INDICATOR
  // ==========================================================================

  Widget _buildStyleIndicator() {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 125,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 9,
          vertical: 6,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: accentColor.withValues(alpha: 0.06),
          border: Border.all(
            color: accentColor.withValues(alpha: 0.14),
            width: 0.7,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 5,
              height: 5,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: accentColor,
                boxShadow: [
                  BoxShadow(
                    color: accentColor.withValues(alpha: 0.45),
                    blurRadius: 6,
                  ),
                ],
              ),
            ),

            const SizedBox(width: 6),

            Flexible(
              child: Text(
                _formatStyleName(theme.glassStyle),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: accentColor.withValues(alpha: 0.82),
                  fontSize: 8.0,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.6,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================================
  // SECTION TITLE
  // ==========================================================================

  Widget _buildSectionTitle({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(9),
            color: textColor.withValues(alpha: 0.045),
            border: Border.all(
              color: textColor.withValues(alpha: 0.08),
              width: 0.7,
            ),
          ),
          child: Icon(
            icon,
            size: 15,
            color: accentColor.withValues(alpha: 0.80),
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: textColor.withValues(alpha: 0.88),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 2),

              Text(
                subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: textColor.withValues(alpha: 0.42),
                  fontSize: 9.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ==========================================================================
  // DIVIDER
  // ==========================================================================

  Widget _buildDivider() {
    return Container(
      height: 1,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            textColor.withValues(alpha: 0.10),
            textColor.withValues(alpha: 0.04),
            Colors.transparent,
          ],
        ),
      ),
    );
  }

  // ==========================================================================
  // SLIDERS
  // ==========================================================================

  Widget _buildSliders(BuildContext context) {
    return GlassResponsiveGrid(
      mobileColumns: 1,
      tabletColumns: 2,
      desktopColumns: 4,
      
      spacing: isMobile ? 14 : 18,
      runSpacing: isMobile ? 12 : 14,
      expandItems: true,
      children: [
        // ----------------------------------------------------------------------
        // BLUR
        // ----------------------------------------------------------------------

        GlassStyleControls.slider(
          context: context,
          label: 'Blur',
          value: theme.blur,
          min: 0,
          max: 100,
          onChanged: notifier.setBlur,
          textColor: textColor,
          accentColor: accentColor,
          enabled: theme.enableBlur,
          suffix: 'px',
          decimals: 0,
        ),

        // ----------------------------------------------------------------------
        // NOISE
        // ----------------------------------------------------------------------

        GlassStyleControls.slider(
          context: context,
          label: 'Noise',
          value: theme.noise,
          min: 0,
          max: 1,
          onChanged: notifier.setNoise,
          textColor: textColor,
          accentColor: accentColor,
          enabled: theme.enableNoise,
          suffix: '',
          decimals: 2,
        ),

        // ----------------------------------------------------------------------
        // SURFACE OPACITY
        // ----------------------------------------------------------------------

        GlassStyleControls.slider(
          context: context,
          label: 'Surface Opacity',
          value: theme.surfaceOpacity,
          min: 0,
          max: 1,
          onChanged: notifier.setSurfaceOpacity,
          textColor: textColor,
          accentColor: accentColor,
          suffix: '%',
          decimals: 0,
          displayMultiplier: 100,
        ),

        // ----------------------------------------------------------------------
        // BORDER RADIUS
        // ----------------------------------------------------------------------

        GlassStyleControls.slider(
          context: context,
          label: 'Border Radius',
          value: theme.borderRadius,
          min: 0,
          max: 160,
          onChanged: notifier.setBorderRadius,
          textColor: textColor,
          accentColor: accentColor,
          suffix: 'px',
          decimals: 0,
        ),

        // ----------------------------------------------------------------------
        // GLOW BLUR
        // ----------------------------------------------------------------------

        GlassStyleControls.slider(
          context: context,
          label: 'Glow Blur',
          value: theme.glowBlur,
          min: 0,
          max: 100,
          onChanged: notifier.setGlowBlur,
          textColor: textColor,
          accentColor: accentColor,
          enabled: theme.enableGlow,
          suffix: 'px',
          decimals: 0,
        ),

        // ----------------------------------------------------------------------
        // GLOW OPACITY
        // ----------------------------------------------------------------------

        GlassStyleControls.slider(
          context: context,
          label: 'Glow Opacity',
          value: theme.glowOpacity,
          min: 0,
          max: 1,
          onChanged: notifier.setGlowOpacity,
          textColor: textColor,
          accentColor: accentColor,
          enabled: theme.enableGlow,
          suffix: '%',
          decimals: 0,
          displayMultiplier: 100,
        ),

        // ----------------------------------------------------------------------
        // SHADOW BLUR
        // ----------------------------------------------------------------------

        GlassStyleControls.slider(
          context: context,
          label: 'Shadow Blur',
          value: theme.shadowBlur,
          min: 0,
          max: 100,
          onChanged: notifier.setShadowBlur,
          textColor: textColor,
          accentColor: accentColor,
          enabled: theme.enableShadow,
          suffix: 'px',
          decimals: 0,
        ),

        // ----------------------------------------------------------------------
        // SHADOW OPACITY
        // ----------------------------------------------------------------------

        GlassStyleControls.slider(
          context: context,
          label: 'Shadow Opacity',
          value: theme.shadowOpacity,
          min: 0,
          max: 1,
          onChanged: notifier.setShadowOpacity,
          textColor: textColor,
          accentColor: accentColor,
          enabled: theme.enableShadow,
          suffix: '%',
          decimals: 0,
          displayMultiplier: 100,
        ),

        // ----------------------------------------------------------------------
        // SHADOW OFFSET Y
        // ----------------------------------------------------------------------

        GlassStyleControls.slider(
          context: context,
          label: 'Shadow Offset Y',
          value: theme.shadowOffsetY,
          min: -100,
          max: 100,
          onChanged: notifier.setShadowOffsetY,
          textColor: textColor,
          accentColor: accentColor,
          enabled: theme.enableShadow,
          suffix: 'px',
          decimals: 0,
        ),

        // ----------------------------------------------------------------------
        // BORDER WIDTH
        // ----------------------------------------------------------------------

        GlassStyleControls.slider(
          context: context,
          label: 'Border Width',
          value: theme.borderWidth,
          min: 0,
          max: 12,
          onChanged: notifier.setBorderWidth,
          textColor: textColor,
          accentColor: accentColor,
          enabled: theme.enableBorder,
          suffix: 'px',
          decimals: 1,
        ),

        // ----------------------------------------------------------------------
        // BORDER OPACITY
        // ----------------------------------------------------------------------

        GlassStyleControls.slider(
          context: context,
          label: 'Border Opacity',
          value: theme.borderOpacity,
          min: 0,
          max: 1,
          onChanged: notifier.setBorderOpacity,
          textColor: textColor,
          accentColor: accentColor,
          enabled: theme.enableBorder,
          suffix: '%',
          decimals: 0,
          displayMultiplier: 100,
        ),
      ],
    );
  }

  // ==========================================================================
  // STYLE NAME
  // ==========================================================================

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