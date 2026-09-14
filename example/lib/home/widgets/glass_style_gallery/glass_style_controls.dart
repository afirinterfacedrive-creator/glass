import 'package:flutter/material.dart';
import 'package:universal_glass/glass.dart';

class GlassStyleControls {
  const GlassStyleControls._();

  // ==========================================================================
  // CONSTANTES
  // ==========================================================================

  static const Duration _switchAnimationDuration =
      Duration(milliseconds: 180);

  static const Duration _badgeAnimationDuration =
      Duration(milliseconds: 160);

  static const Curve _switchAnimationCurve =
      Curves.easeOutCubic;

  static const double _switchHeight = 42.0;
  static const double _switchRadius = 12.0;

  // ==========================================================================
  // SWITCHES
  // ==========================================================================

  static Widget buildSwitches({
    required GlassThemeState theme,
    required GlassThemeNotifier notifier,
    required Color textColor,
    required Color accentColor,
  }) {
    return GlassResponsiveGrid(
      mobileColumns: 1,
      tabletColumns: 2,
      desktopColumns: 4,
      spacing: 8,
      runSpacing: 8,
      expandItems: true,
      children: [
        _switch(
          label: 'Breaker',
          value: theme.breakerOn,
          onChanged: notifier.setBreakerOn,
          textColor: textColor,
          accentColor: accentColor,
        ),
        _switch(
          label: 'Blur',
          value: theme.enableBlur,
          onChanged: notifier.setEnableBlur,
          textColor: textColor,
          accentColor: accentColor,
        ),
        _switch(
          label: 'Noise',
          value: theme.enableNoise,
          onChanged: notifier.setEnableNoise,
          textColor: textColor,
          accentColor: accentColor,
        ),
        _switch(
          label: 'Glow',
          value: theme.enableGlow,
          onChanged: notifier.setEnableGlow,
          textColor: textColor,
          accentColor: accentColor,
        ),
        _switch(
          label: 'Shadow',
          value: theme.enableShadow,
          onChanged: notifier.setEnableShadow,
          textColor: textColor,
          accentColor: accentColor,
        ),
        _switch(
          label: 'Border',
          value: theme.enableBorder,
          onChanged: notifier.setEnableBorder,
          textColor: textColor,
          accentColor: accentColor,
        ),
        _switch(
          label: 'Gradient',
          value: theme.enableGradient,
          onChanged: notifier.setEnableGradient,
          textColor: textColor,
          accentColor: accentColor,
        ),
        _switch(
          label: 'Hover',
          value: theme.enableHover,
          onChanged: notifier.setEnableHover,
          textColor: textColor,
          accentColor: accentColor,
        ),
      ],
    );
  }

  // ==========================================================================
  // SWITCH
  // ==========================================================================

  static Widget _switch({
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
    required Color textColor,
    required Color accentColor,
  }) {
    return SizedBox(
      height: _switchHeight,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: BorderRadius.circular(_switchRadius),
          onTap: () => onChanged(!value),
          child: AnimatedContainer(
            duration: _switchAnimationDuration,
            curve: _switchAnimationCurve,
            padding: const EdgeInsets.symmetric(
              horizontal: 9,
              vertical: 5,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(_switchRadius),
              color: value
                  ? accentColor.withValues(alpha: 0.075)
                  : textColor.withValues(alpha: 0.025),
              border: Border.all(
                color: value
                    ? accentColor.withValues(alpha: 0.18)
                    : textColor.withValues(alpha: 0.065),
                width: 0.7,
              ),
            ),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: _switchAnimationDuration,
                  curve: _switchAnimationCurve,
                  width: 25,
                  height: 25,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: value
                        ? accentColor.withValues(alpha: 0.13)
                        : textColor.withValues(alpha: 0.045),
                  ),
                  child: Icon(
                    _switchIcon(label),
                    size: 13,
                    color: value
                        ? accentColor
                        : textColor.withValues(alpha: 0.40),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: value
                          ? textColor.withValues(alpha: 0.92)
                          : textColor.withValues(alpha: 0.58),
                      fontSize: 11,
                      fontWeight:
                          value ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                _SwitchIndicator(
                  value: value,
                  accentColor: accentColor,
                  textColor: textColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================================================
  // SWITCH ICON
  // ==========================================================================

  static IconData _switchIcon(String label) {
    switch (label) {
      case 'Breaker':
        return Icons.power_settings_new_rounded;

      case 'Blur':
        return Icons.blur_on_rounded;

      case 'Noise':
        return Icons.grain_rounded;

      case 'Glow':
        return Icons.wb_sunny_rounded;

      case 'Shadow':
        return Icons.layers_rounded;

      case 'Border':
        return Icons.border_style_rounded;

      case 'Gradient':
        return Icons.gradient_rounded;

      case 'Hover':
        return Icons.mouse_rounded;

      default:
        return Icons.tune_rounded;
    }
  }

  // ==========================================================================
  // SLIDER
  // ==========================================================================

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
    // ------------------------------------------------------------------------
    // Sécurisation de la plage
    // ------------------------------------------------------------------------

    final double safeMin = min <= max ? min : max;
    final double safeMax = max >= min ? max : min;

    // ------------------------------------------------------------------------
    // IMPORTANT :
    // clamp() conserve explicitement 0 lorsque 0 est une valeur valide.
    //
    // Il ne faut surtout pas remplacer ici une valeur 0 par une valeur
    // par défaut comme 12, 0.18, etc.
    // ------------------------------------------------------------------------

    final double safeValue = value
        .clamp(safeMin, safeMax)
        .toDouble();

    final double displayedValue =
        safeValue * displayMultiplier;

    final String valueText =
        '${displayedValue.toStringAsFixed(decimals)}$suffix';

    final Color mutedColor =
        textColor.withValues(alpha: 0.42);

    return Opacity(
      opacity: enabled ? 1.0 : 0.38,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ------------------------------------------------------------------
          // HEADER
          // ------------------------------------------------------------------

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
                      color: textColor.withValues(alpha: 0.88),
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                _ValueBadge(
                  valueText: valueText,
                  accentColor: accentColor,
                  textColor: mutedColor,
                  enabled: enabled,
                ),
              ],
            ),
          ),

          const SizedBox(height: 2),

          // ------------------------------------------------------------------
          // SLIDER
          // ------------------------------------------------------------------
          //
          // IMPORTANT :
          // Aucun Expanded ici.
          //
          // Ce widget est utilisé dans GlassResponsiveGrid. Le grid peut
          // fournir une largeur contrainte mais pas nécessairement une hauteur
          // bornée. Expanded provoquerait alors des contraintes verticales
          // invalides.
          // ------------------------------------------------------------------

          SizedBox(
            height: 28,
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 3,

                // ------------------------------------------------------------
                // TRACK
                // ------------------------------------------------------------

                activeTrackColor: enabled
                    ? accentColor
                    : accentColor.withValues(alpha: 0.28),

                inactiveTrackColor:
                    textColor.withValues(alpha: 0.10),

                disabledActiveTrackColor:
                    accentColor.withValues(alpha: 0.22),

                disabledInactiveTrackColor:
                    textColor.withValues(alpha: 0.07),

                // ------------------------------------------------------------
                // THUMB
                // ------------------------------------------------------------

                thumbColor: enabled
                    ? accentColor
                    : accentColor.withValues(alpha: 0.28),

                disabledThumbColor:
                    accentColor.withValues(alpha: 0.24),

                // ------------------------------------------------------------
                // OVERLAY
                // ------------------------------------------------------------

                overlayColor:
                    accentColor.withValues(alpha: 0.10),

                // ------------------------------------------------------------
                // FORMES
                // ------------------------------------------------------------

                thumbShape: const RoundSliderThumbShape(
                  enabledThumbRadius: 6,
                  disabledThumbRadius: 5,
                  elevation: 1,
                ),

                overlayShape:
                    const RoundSliderOverlayShape(
                  overlayRadius: 14,
                ),

                trackShape:
                    const RoundedRectSliderTrackShape(),

                // ------------------------------------------------------------
                // TICKS
                // ------------------------------------------------------------

                tickMarkShape: divisions != null
                    ? const RoundSliderTickMarkShape(
                        tickMarkRadius: 1.5,
                      )
                    : SliderTickMarkShape.noTickMark,

                activeTickMarkColor:
                    accentColor.withValues(alpha: 0.70),

                inactiveTickMarkColor:
                    textColor.withValues(alpha: 0.15),
              ),
              child: Slider(
                value: safeValue,
                min: safeMin,
                max: safeMax,
                divisions: divisions,
                onChanged: enabled ? onChanged : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// SWITCH INDICATOR
// ============================================================================

class _SwitchIndicator extends StatelessWidget {
  final bool value;
  final Color accentColor;
  final Color textColor;

  const _SwitchIndicator({
    required this.value,
    required this.accentColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: GlassStyleControls._switchAnimationDuration,
      curve: GlassStyleControls._switchAnimationCurve,
      width: 27,
      height: 15,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: value
            ? accentColor.withValues(alpha: 0.22)
            : textColor.withValues(alpha: 0.10),
        border: Border.all(
          color: value
              ? accentColor.withValues(alpha: 0.32)
              : textColor.withValues(alpha: 0.12),
          width: 0.6,
        ),
      ),
      alignment:
          value ? Alignment.centerRight : Alignment.centerLeft,
      child: AnimatedContainer(
        duration: GlassStyleControls._switchAnimationDuration,
        curve: GlassStyleControls._switchAnimationCurve,
        width: 9,
        height: 9,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: value
              ? accentColor
              : textColor.withValues(alpha: 0.40),
          boxShadow: value
              ? [
                  BoxShadow(
                    color:
                        accentColor.withValues(alpha: 0.35),
                    blurRadius: 5,
                  ),
                ]
              : null,
        ),
      ),
    );
  }
}

// ============================================================================
// VALUE BADGE
// ============================================================================

class _ValueBadge extends StatelessWidget {
  final String valueText;
  final Color accentColor;
  final Color textColor;
  final bool enabled;

  const _ValueBadge({
    required this.valueText,
    required this.accentColor,
    required this.textColor,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: GlassStyleControls._badgeAnimationDuration,
      curve: GlassStyleControls._switchAnimationCurve,
      padding: const EdgeInsets.symmetric(
        horizontal: 7,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: enabled
            ? accentColor.withValues(alpha: 0.075)
            : textColor.withValues(alpha: 0.045),
        borderRadius: BorderRadius.circular(7),
        border: Border.all(
          color: enabled
              ? accentColor.withValues(alpha: 0.12)
              : textColor.withValues(alpha: 0.06),
          width: 0.6,
        ),
      ),
      child: Text(
        valueText,
        style: TextStyle(
          color: enabled ? accentColor : textColor,
          fontSize: 9.5,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.15,
        ),
      ),
    );
  }
}