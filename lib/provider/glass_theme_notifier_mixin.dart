import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:universal_glass/components/surface/glass_surface_container.dart';
import 'package:universal_glass/enums/glass_enums.dart';
import 'package:universal_glass/provider/glass_theme_provider.dart';
import 'package:universal_glass/theme/glass_effects.dart';
import 'package:universal_glass/theme/glass_scaffold.dart';


class GlassGlobalSettingsPage extends ConsumerWidget {
  const GlassGlobalSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GlassThemeState theme = ref.watch(glassThemeProvider);
    final notifier = ref.read(glassThemeProvider.notifier);

    final textColor = theme.useAquaStyle ? Colors.cyanAccent : Colors.white;
    final accentColor = theme.useAquaStyle ? Colors.cyanAccent : Colors.blueAccent;

    return GlassScaffold(
      title: 'Glass Configuration',
      subtitle: 'GLOBAL SETTINGS',
      showLogo: true,
      showBackButton: true,
      actions: [
        IconButton(
          icon: Icon(Icons.restart_alt, color: textColor),
          onPressed: () => notifier.reset(),
          tooltip: 'Reset to Default',
        )
      ],
      useCustomGradient: true,
      customGradientKey: 'settings_gradient',
      blur: theme.enableBlur ? theme.blur : 0,   // <- Important: respecter le toggle
      noise: theme.enableNoise ? theme.noise : 0,

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLivePreview(theme, textColor),
          const SizedBox(height: 24),
          _buildResponsiveWrap(theme, notifier, textColor, accentColor, context),
          const SizedBox(height: 36),
        ],
      ),
    );
  }

  Widget _buildLivePreview(GlassThemeState theme, Color textColor) {
    final bool isOff = theme.breakerOn;
    
    final effects = GlassEffects(
      bgGradient: isOff || !theme.enableGradient ? [] : theme.activeGradient,
      bgBlur: isOff || !theme.enableBlur ? 0 : theme.blur,
      bgNoise: isOff || !theme.enableNoise ? 0 : theme.noise,
      borderRadius: theme.borderRadius,
      borderOpacity: isOff || !theme.enableBorder ? 0 : theme.borderOpacity,
      borderWidth: isOff || !theme.enableBorder ? 0 : theme.borderWidth,
      glowOpacity: isOff || !theme.enableGlow ? 0 : theme.glowOpacity,
      glowBlur: isOff || !theme.enableGlow ? 0 : theme.glowBlur,
      shadowOpacity: isOff || !theme.enableShadow ? 0 : theme.shadowOpacity,
      shadowBlur: isOff || !theme.enableShadow ? 0 : theme.shadowBlur,
      shadowOffsetY: isOff || !theme.enableShadow ? 0 : theme.shadowOffsetY,
      surfaceOpacity: isOff ? 0.95 : theme.surfaceOpacity.clamp(0.05, 0.4),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // FOND POUR VOIR LE BLUR
          AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            height: 160,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(theme.borderRadius + 10),
              gradient: const LinearGradient(
                colors: [Color(0xFFE91E63), Color(0xFF2196F3), Color(0xFF9C27B0)],
              ),
            ),
          ),
          // CARTE
          GlassSurfaceContainer(
            key: ValueKey('${theme.blur}_${theme.noise}_${theme.surfaceOpacity}_${theme.borderRadius}_${theme.glowOpacity}'),
            style: GlassStyle.custom,
            effects: effects,
            height: 160,
            width: double.infinity,
            liftOnHover: theme.enableHover,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(isOff ? Icons.power_off : Icons.visibility_rounded, size: 32, color: textColor),
                  const SizedBox(height: 8),
                  Text(
                    isOff ? 'BREAKER ON' : 'Live Preview',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: textColor),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'B:${theme.blur.toInt()} O:${theme.surfaceOpacity.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 11, color: textColor.withValues(alpha: 0.8)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResponsiveWrap(GlassThemeState theme, GlassThemeNotifier notifier, Color textColor, Color accentColor, BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        double cardWidth = width;
        // ignore: curly_braces_in_flow_control_structures
        if (width >= 1200) cardWidth = (width - 32) / 3;
        // ignore: curly_braces_in_flow_control_structures
        else if (width >= 800) cardWidth = (width - 16) / 2;

        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            SizedBox(width: cardWidth, child: _buildGeneralCard(theme, notifier, textColor, accentColor)),
            SizedBox(width: cardWidth, child: _buildBlurCard(theme, notifier, textColor, accentColor, context)),
            SizedBox(width: cardWidth, child: _buildSurfaceCard(theme, notifier, textColor, accentColor, context)),
            SizedBox(width: cardWidth, child: _buildGradientCard(theme, notifier, textColor, accentColor, context)),
          ],
        );
      },
    );
  }

  Widget _buildCard(String title, List<Widget> children, GlassThemeState theme) {
    return GlassSurfaceContainer(
      style: theme.breakerOn ? GlassStyle.opaqueHeavy : GlassStyle.transparentAqua,
      padding: const EdgeInsets.all(18),
      borderRadius: BorderRadius.circular(20),
      liftOnHover: theme.enableHover,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: theme.useAquaStyle ? Colors.cyanAccent : Colors.white)),
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }

  Widget _buildGeneralCard(GlassThemeState theme, GlassThemeNotifier notifier, Color textColor, Color accentColor) {
    return _buildCard('General', [
      _switch('Breaker Mode', theme.breakerOn, notifier.setBreakerOn, textColor, accentColor),
      _switch('Enable Blur', theme.enableBlur, notifier.setEnableBlur, textColor, accentColor),
      _switch('Enable Noise', theme.enableNoise, notifier.setEnableNoise, textColor, accentColor),
      _switch('Enable Glow', theme.enableGlow, notifier.setEnableGlow, textColor, accentColor),
      _switch('Enable Shadow', theme.enableShadow, notifier.setEnableShadow, textColor, accentColor),
      _switch('Enable Border', theme.enableBorder, notifier.setEnableBorder, textColor, accentColor),
      _switch('Enable Gradient', theme.enableGradient, notifier.setEnableGradient, textColor, accentColor),
      _switch('Enable Hover', theme.enableHover, notifier.setEnableHover, textColor, accentColor),
    ], theme);
  }

  Widget _buildBlurCard(GlassThemeState theme, GlassThemeNotifier notifier, Color textColor, Color accentColor, BuildContext context) {
    return _buildCard('Blur & Effects', [
      _slider('Blur', theme.blur, 0, 100, notifier.setBlur, textColor, accentColor, context, enabled: theme.enableBlur),
      _slider('Noise', theme.noise, 0, 1, notifier.setNoise, textColor, accentColor, context, enabled: theme.enableNoise),
      _slider('Glow Blur', theme.glowBlur, 0, 100, notifier.setGlowBlur, textColor, accentColor, context, enabled: theme.enableGlow),
      _slider('Glow Opacity', theme.glowOpacity, 0, 1, notifier.setGlowOpacity, textColor, accentColor, context, enabled: theme.enableGlow),
      _slider('Shadow Blur', theme.shadowBlur, 0, 100, notifier.setShadowBlur, textColor, accentColor, context, enabled: theme.enableShadow),
      _slider('Shadow Opacity', theme.shadowOpacity, 0, 1, notifier.setShadowOpacity, textColor, accentColor, context, enabled: theme.enableShadow),
      _slider('Shadow Offset Y', theme.shadowOffsetY, 0, 30, notifier.setShadowOffsetY, textColor, accentColor, context, enabled: theme.enableShadow),
      _slider('Hover Lift', theme.hoverLift, 0, 30, notifier.setHoverLift, textColor, accentColor, context, enabled: theme.enableHover),
    ], theme);
  }

  Widget _buildSurfaceCard(GlassThemeState theme, GlassThemeNotifier notifier, Color textColor, Color accentColor, BuildContext context) {
    return _buildCard('Surface', [
      _slider('Border Radius', theme.borderRadius, 0, 160, notifier.setBorderRadius, textColor, accentColor, context),
      _slider('Border Width', theme.borderWidth, 0, 12, notifier.setBorderWidth, textColor, accentColor, context, enabled: theme.enableBorder),
      _slider('Border Opacity', theme.borderOpacity, 0, 1, notifier.setBorderOpacity, textColor, accentColor, context, enabled: theme.enableBorder),
      _slider('Surface Opacity', theme.surfaceOpacity, 0, 1, notifier.setSurfaceOpacity, textColor, accentColor, context),
    ], theme);
  }

  Widget _buildGradientCard(GlassThemeState theme, GlassThemeNotifier notifier, Color textColor, Color accentColor, BuildContext context) {
    return _buildCard('Gradient', [
      _slider('Gradient Density', theme.gradientDensity.toDouble(), 2, 4, (v) => notifier.setGradientDensity(v.toInt()), textColor, accentColor, context, divisions: 2, enabled: theme.enableGradient),
      _slider('Gradient Opacity', theme.gradientOpacity, 0, 1, notifier.setGradientOpacity, textColor, accentColor, context, enabled: theme.enableGradient),
    ], theme);
  }

  Widget _switch(String label, bool value, ValueChanged<bool> onChanged, Color textColor, Color accentColor) =>
      SwitchListTile(
        title: Text(label, style: TextStyle(fontSize: 13, color: textColor)),
        value: value, 
        onChanged: onChanged, 
        dense: true, 
        contentPadding: EdgeInsets.zero,
        activeColor: accentColor,
        activeTrackColor: accentColor.withValues(alpha:0.4),
        inactiveThumbColor: textColor.withValues(alpha:0.7),
        inactiveTrackColor: textColor.withValues(alpha:0.2),
      );

  Widget _slider(String label, double value, double min, double max, ValueChanged<double> onChanged, Color textColor, Color accentColor, BuildContext context, {int? divisions, bool enabled = true}) {
    final opacity = enabled ? 1.0 : 0.4;
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Opacity(
        opacity: opacity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(label, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12, color: textColor)),
                Text(value.toStringAsFixed(2), style: TextStyle(fontSize: 10, color: textColor.withValues(alpha:0.7))),
              ],
            ),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: enabled ? accentColor : accentColor.withValues(alpha:0.3),
                inactiveTrackColor: textColor.withValues(alpha:0.2),
                thumbColor: enabled ? accentColor : accentColor.withValues(alpha:0.3),
              ),
              child: Slider(value: value, min: min, max: max, divisions: divisions, onChanged: enabled ? onChanged : null),
            ),
          ],
        ),
      ),
    );
  }
}