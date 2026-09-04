import 'package:flutter/material.dart';
import 'package:universal_glass/glass.dart';

class GlassStyleControls {
  const GlassStyleControls._();

  static Widget buildSwitches({
    required GlassThemeState theme,
    required GlassThemeNotifier notifier,
    required Color textColor,
    required Color accentColor,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;

        final double itemWidth = width < 500
            ? 145
            : width < 800
                ? 155
                : 160;

        return Wrap(
          spacing: 8,
          runSpacing: 4,
          children: [
            _switch(
              label: 'Breaker',
              value: theme.breakerOn,
              onChanged: notifier.setBreakerOn,
              width: itemWidth,
              textColor: textColor,
              accentColor: accentColor,
            ),

            _switch(
              label: 'Blur',
              value: theme.enableBlur,
              onChanged: notifier.setEnableBlur,
              width: itemWidth,
              textColor: textColor,
              accentColor: accentColor,
            ),

            _switch(
              label: 'Noise',
              value: theme.enableNoise,
              onChanged: notifier.setEnableNoise,
              width: itemWidth,
              textColor: textColor,
              accentColor: accentColor,
            ),

            _switch(
              label: 'Glow',
              value: theme.enableGlow,
              onChanged: notifier.setEnableGlow,
              width: itemWidth,
              textColor: textColor,
              accentColor: accentColor,
            ),

            _switch(
              label: 'Shadow',
              value: theme.enableShadow,
              onChanged: notifier.setEnableShadow,
              width: itemWidth,
              textColor: textColor,
              accentColor: accentColor,
            ),

            _switch(
              label: 'Border',
              value: theme.enableBorder,
              onChanged: notifier.setEnableBorder,
              width: itemWidth,
              textColor: textColor,
              accentColor: accentColor,
            ),

            _switch(
              label: 'Gradient',
              value: theme.enableGradient,
              onChanged: notifier.setEnableGradient,
              width: itemWidth,
              textColor: textColor,
              accentColor: accentColor,
            ),

            _switch(
              label: 'Hover',
              value: theme.enableHover,
              onChanged: notifier.setEnableHover,
              width: itemWidth,
              textColor: textColor,
              accentColor: accentColor,
            ),
          ],
        );
      },
    );
  }

  static Widget _switch({
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
    required double width,
    required Color textColor,
    required Color accentColor,
  }) {
    return SizedBox(
      width: width,
      height: 44,
      child: SwitchListTile(
        value: value,
        onChanged: onChanged,
        dense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 4,
        ),
        visualDensity: const VisualDensity(
          horizontal: -3,
          vertical: -3,
        ),
        title: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
        ),
        activeColor: accentColor,
        activeTrackColor: accentColor.withOpacity(0.35),
        inactiveThumbColor: textColor.withOpacity(0.45),
        inactiveTrackColor: textColor.withOpacity(0.12),
      ),
    );
  }

  static Widget slider({
    required BuildContext context,
    required String label,
    required double value,
    required double min,
    required double max,
    required ValueChanged<double> onChanged,
    required Color textColor,
    required Color accentColor,
    bool enabled = true,
    String suffix = '',
    int decimals = 2,
    double displayMultiplier = 1,
    int? divisions,
  }) {
    final double displayedValue =
        value * displayMultiplier;

    final String valueText =
        '${displayedValue.toStringAsFixed(decimals)}$suffix';

    final Color mutedColor =
        textColor.withOpacity(0.50);

    return Opacity(
      opacity: enabled ? 1.0 : 0.38,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 2,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    valueText,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: enabled
                          ? accentColor
                          : mutedColor,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 3,
                activeTrackColor:
                    enabled
                        ? accentColor
                        : accentColor.withOpacity(0.30),
                inactiveTrackColor:
                    textColor.withOpacity(0.12),
                thumbColor:
                    enabled
                        ? accentColor
                        : accentColor.withOpacity(0.30),
                overlayColor:
                    accentColor.withOpacity(0.12),
                thumbShape:
                    const RoundSliderThumbShape(
                  enabledThumbRadius: 6,
                ),
                overlayShape:
                    const RoundSliderOverlayShape(
                  overlayRadius: 14,
                ),
              ),
              child: Slider(
                value: value.clamp(min, max),
                min: min,
                max: max,
                divisions: divisions,
                onChanged:
                    enabled ? onChanged : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}