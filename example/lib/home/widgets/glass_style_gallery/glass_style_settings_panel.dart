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
    return GlassSurfaceContainer(
      style: GlassStyle.opaqueHeavy,
      padding: EdgeInsets.all(isMobile ? 16 : 20),
      borderRadius: BorderRadius.circular(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),

          const SizedBox(height: 18),

          GlassStyleControls.buildSwitches(
            theme: theme,
            notifier: notifier,
            textColor: textColor,
            accentColor: accentColor,
          ),

          const SizedBox(height: 16),

          Divider(
            color: textColor.withOpacity(0.10),
            height: 1,
          ),

          const SizedBox(height: 18),

          _buildSliders(context),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: accentColor.withOpacity(0.12),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: accentColor.withOpacity(0.22),
            ),
          ),
          child: Icon(
            Icons.tune_rounded,
            size: 20,
            color: accentColor,
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Paramètres avancés',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                'Ajustez le rendu du style en temps réel',
                style: TextStyle(
                  fontSize: 11,
                  color: textColor.withOpacity(0.55),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSliders(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool compact = constraints.maxWidth < 700;

        final int columns = compact ? 1 : 2;

        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: columns,
          crossAxisSpacing: 20,
          mainAxisSpacing: 12,
          childAspectRatio: compact ? 5.8 : 4.7,
          children: [
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
      },
    );
  }
}