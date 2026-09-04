import 'package:flutter/material.dart';

import '../appearance_settings.dart';

import 'appearance_slider.dart';
import 'appearance_switch.dart';

/// ============================================================================
/// APPEARANCE STYLE CONTROLS
/// ============================================================================
///
/// Contrôles avancés de l'apparence :
///
/// - Blur
/// - Noise
/// - Opacité de surface
/// - Rayon des coins
/// - Bordure
/// - Glow
/// - Ombre
/// - Hover
///
/// Ce widget ne sauvegarde rien et ne connaît pas Riverpod.
///
/// Il reçoit un AppearanceSettings et retourne les modifications via
/// onChanged.
///
/// ============================================================================

class AppearanceStyleControls extends StatelessWidget {
  final AppearanceSettings settings;

  final ValueChanged<AppearanceSettings> onChanged;

  const AppearanceStyleControls({
    super.key,
    required this.settings,
    required this.onChanged,
  });

  // ==========================================================================
  // HELPERS
  // ==========================================================================

  void _update(
    AppearanceSettings newSettings,
  ) {
    onChanged(newSettings);
  }

  Widget _sectionTitle(
    String title,
  ) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 10,
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // ==========================================================================
  // BUILD
  // ==========================================================================

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        // ====================================================================
        // EFFETS
        // ====================================================================

        _sectionTitle('Effets'),

        // --------------------------------------------------------------------
        // BLUR
        // --------------------------------------------------------------------

        AppearanceSwitch(
          label: 'Blur',
          description:
              'Flou de l’arrière-plan',
          icon: Icons.blur_on,
          value: settings.enableBlur,
          onChanged: (value) {
            _update(
              settings.copyWith(
                enableBlur: value,
              ),
            );
          },
        ),

        AppearanceSlider(
          label: 'Intensité du blur',
          value: settings.blur,
          min: 0,
          max: 40,
          divisions: 40,
          suffix: ' px',
          enabled: settings.enableBlur,
          onChanged: (value) {
            _update(
              settings.copyWith(
                blur: value,
              ),
            );
          },
        ),

        // --------------------------------------------------------------------
        // NOISE
        // --------------------------------------------------------------------

        AppearanceSwitch(
          label: 'Noise',
          description:
              'Texture subtile du verre',
          icon: Icons.grain,
          value: settings.enableNoise,
          onChanged: (value) {
            _update(
              settings.copyWith(
                enableNoise: value,
              ),
            );
          },
        ),

        AppearanceSlider(
          label: 'Intensité du noise',
          value: settings.noise,
          min: 0,
          max: 1,
          divisions: 100,
          enabled: settings.enableNoise,
          onChanged: (value) {
            _update(
              settings.copyWith(
                noise: value,
              ),
            );
          },
        ),

        const SizedBox(height: 16),

        // ====================================================================
        // SURFACE
        // ====================================================================

        _sectionTitle('Surface'),

        AppearanceSlider(
          label: 'Opacité',
          value: settings.surfaceOpacity,
          min: 0,
          max: 1,
          divisions: 100,
          decimalPlaces: 2,
          onChanged: (value) {
            _update(
              settings.copyWith(
                surfaceOpacity: value,
              ),
            );
          },
        ),

        AppearanceSlider(
          label: 'Rayon des coins',
          value: settings.borderRadius,
          min: 0,
          max: 40,
          divisions: 40,
          suffix: ' px',
          decimalPlaces: 0,
          onChanged: (value) {
            _update(
              settings.copyWith(
                borderRadius: value,
              ),
            );
          },
        ),

        const SizedBox(height: 16),

        // ====================================================================
        // BORDURE
        // ====================================================================

        _sectionTitle('Bordure'),

        AppearanceSwitch(
          label: 'Bordure',
          description:
              'Affiche le contour de la surface',
          icon: Icons.border_style,
          value: settings.enableBorder,
          onChanged: (value) {
            _update(
              settings.copyWith(
                enableBorder: value,
              ),
            );
          },
        ),

        AppearanceSlider(
          label: 'Opacité bordure',
          value: settings.borderOpacity,
          min: 0,
          max: 1,
          divisions: 100,
          decimalPlaces: 2,
          enabled: settings.enableBorder,
          onChanged: (value) {
            _update(
              settings.copyWith(
                borderOpacity: value,
              ),
            );
          },
        ),

        AppearanceSlider(
          label: 'Épaisseur bordure',
          value: settings.borderWidth,
          min: 0,
          max: 3,
          divisions: 30,
          suffix: ' px',
          decimalPlaces: 1,
          enabled: settings.enableBorder,
          onChanged: (value) {
            _update(
              settings.copyWith(
                borderWidth: value,
              ),
            );
          },
        ),

        const SizedBox(height: 16),

        // ====================================================================
        // GLOW
        // ====================================================================

        _sectionTitle('Glow'),

        AppearanceSwitch(
          label: 'Glow',
          description:
              'Halo lumineux autour de la surface',
          icon: Icons.auto_awesome,
          value: settings.enableGlow,
          onChanged: (value) {
            _update(
              settings.copyWith(
                enableGlow: value,
              ),
            );
          },
        ),

        AppearanceSlider(
          label: 'Intensité du glow',
          value: settings.glowOpacity,
          min: 0,
          max: 1,
          divisions: 100,
          decimalPlaces: 2,
          enabled: settings.enableGlow,
          onChanged: (value) {
            _update(
              settings.copyWith(
                glowOpacity: value,
              ),
            );
          },
        ),

        AppearanceSlider(
          label: 'Diffusion du glow',
          value: settings.glowBlur,
          min: 0,
          max: 50,
          divisions: 50,
          suffix: ' px',
          decimalPlaces: 0,
          enabled: settings.enableGlow,
          onChanged: (value) {
            _update(
              settings.copyWith(
                glowBlur: value,
              ),
            );
          },
        ),

        const SizedBox(height: 16),

        // ====================================================================
        // OMBRE
        // ====================================================================

        _sectionTitle('Ombre'),

        AppearanceSwitch(
          label: 'Ombre',
          description:
              'Ajoute une profondeur sous la surface',
          icon: Icons.layers,
          value: settings.enableShadow,
          onChanged: (value) {
            _update(
              settings.copyWith(
                enableShadow: value,
              ),
            );
          },
        ),

        AppearanceSlider(
          label: 'Opacité de l’ombre',
          value: settings.shadowOpacity,
          min: 0,
          max: 1,
          divisions: 100,
          decimalPlaces: 2,
          enabled: settings.enableShadow,
          onChanged: (value) {
            _update(
              settings.copyWith(
                shadowOpacity: value,
              ),
            );
          },
        ),

        AppearanceSlider(
          label: 'Diffusion de l’ombre',
          value: settings.shadowBlur,
          min: 0,
          max: 50,
          divisions: 50,
          suffix: ' px',
          decimalPlaces: 0,
          enabled: settings.enableShadow,
          onChanged: (value) {
            _update(
              settings.copyWith(
                shadowBlur: value,
              ),
            );
          },
        ),

        AppearanceSlider(
          label: 'Décalage vertical',
          value: settings.shadowOffsetY,
          min: -20,
          max: 30,
          divisions: 50,
          suffix: ' px',
          decimalPlaces: 0,
          enabled: settings.enableShadow,
          onChanged: (value) {
            _update(
              settings.copyWith(
                shadowOffsetY: value,
              ),
            );
          },
        ),

        const SizedBox(height: 16),

        // ====================================================================
        // HOVER
        // ====================================================================

        _sectionTitle('Interaction'),

        AppearanceSwitch(
          label: 'Animation au survol',
          description:
              'Soulève légèrement les surfaces au passage de la souris',
          icon: Icons.mouse,
          value: settings.enableHover,
          onChanged: (value) {
            _update(
              settings.copyWith(
                enableHover: value,
              ),
            );
          },
        ),

        AppearanceSlider(
          label: 'Élévation au survol',
          value: settings.hoverLift,
          min: 0,
          max: 10,
          divisions: 20,
          suffix: ' px',
          decimalPlaces: 1,
          enabled: settings.enableHover,
          onChanged: (value) {
            _update(
              settings.copyWith(
                hoverLift: value,
              ),
            );
          },
        ),
      ],
    );
  }
}