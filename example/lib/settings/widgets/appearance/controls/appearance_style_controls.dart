
import 'package:flutter/material.dart';

import '../appearance_settings.dart';

import 'appearance_slider.dart';
import 'appearance_switch.dart';

/// ============================================================================
/// APPEARANCE STYLE CONTROLS
/// ============================================================================
///
/// Centre de contrôle de l'apparence Universal Glass.
///
/// Organisation :
///
/// GLOBAL
///   - Blur
///   - Noise
///   - Gradient
///   - Surface
///   - Border
///   - Glow
///   - Shadow
///   - Hover
///
/// COMPOSANTS
///   - Composants Glass génériques
///   - Inputs
///   - Forms
///   - Toast / Snackbar
///   - Tooltip
///
/// IMPORTANT
/// - Ce widget ne sauvegarde rien.
/// - Ce widget ne connaît pas Riverpod.
/// - Les couleurs ne sont pas gérées ici.
/// - Les couleurs restent sous la responsabilité de
///   GlassColorProvider / GlassColorPalette.
/// - Toutes les modifications passent par onChanged.
/// - Les réglages spécialisés restent indépendants des réglages globaux.
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

  void _update(AppearanceSettings newSettings) {
    onChanged(newSettings);
  }

  Widget _sectionTitle(String title) {
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

  Widget _componentDivider() {
    return const SizedBox(
      height: 18,
    );
  }

  // ==========================================================================
  // COMPONENT CONTROLS
  // ==========================================================================

  Widget _componentControls({
    required AppearanceComponentSettings component,
    required ValueChanged<AppearanceComponentSettings> onChanged,
    bool showHover = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ----------------------------------------------------------------------
        // ENABLED
        // ----------------------------------------------------------------------

        AppearanceSwitch(
          label: 'Actif',
          description: 'Active les réglages spécifiques du composant',
          icon: Icons.tune_rounded,
          value: component.enabled,
          onChanged: (value) {
            onChanged(
              component.copyWith(
                enabled: value,
              ),
            );
          },
        ),

        // ----------------------------------------------------------------------
        // BLUR
        // ----------------------------------------------------------------------

        AppearanceSwitch(
          label: 'Blur',
          description: 'Flou de l’arrière-plan du composant',
          icon: Icons.blur_on,
          value: component.enableBlur,
          onChanged: (value) {
            onChanged(
              component.copyWith(
                enableBlur: value,
              ),
            );
          },
        ),

        AppearanceSlider(
          label: 'Intensité du blur',
          value: component.blur,
          min: 0,
          max: 40,
          divisions: 40,
          suffix: ' px',
          decimalPlaces: 0,
          enabled: component.enabled && component.enableBlur,
          onChanged: (value) {
            onChanged(
              component.copyWith(
                blur: value,
              ),
            );
          },
        ),

        // ----------------------------------------------------------------------
        // SURFACE
        // ----------------------------------------------------------------------

        AppearanceSlider(
          label: 'Opacité de surface',
          value: component.backgroundOpacity,
          min: 0.40,
          max: 1.0,
          divisions: 60,
          decimalPlaces: 2,
          enabled: component.enabled,
          onChanged: (value) {
            onChanged(
              component.copyWith(
                backgroundOpacity: value,
              ),
            );
          },
        ),

        AppearanceSlider(
          label: 'Rayon',
          value: component.borderRadius,
          min: 0,
          max: 40,
          divisions: 40,
          suffix: ' px',
          decimalPlaces: 0,
          enabled: component.enabled,
          onChanged: (value) {
            onChanged(
              component.copyWith(
                borderRadius: value,
              ),
            );
          },
        ),

        // ----------------------------------------------------------------------
        // BORDER
        // ----------------------------------------------------------------------

        AppearanceSwitch(
          label: 'Bordure',
          description: 'Affiche le contour du composant',
          icon: Icons.border_style_rounded,
          value: component.enableBorder,
          onChanged: (value) {
            onChanged(
              component.copyWith(
                enableBorder: value,
              ),
            );
          },
        ),

        AppearanceSlider(
          label: 'Opacité bordure',
          value: component.borderOpacity,
          min: 0,
          max: 1,
          divisions: 100,
          decimalPlaces: 2,
          enabled: component.enabled && component.enableBorder,
          onChanged: (value) {
            onChanged(
              component.copyWith(
                borderOpacity: value,
              ),
            );
          },
        ),

        AppearanceSlider(
          label: 'Épaisseur bordure',
          value: component.borderWidth,
          min: 0,
          max: 3,
          divisions: 30,
          suffix: ' px',
          decimalPlaces: 1,
          enabled: component.enabled && component.enableBorder,
          onChanged: (value) {
            onChanged(
              component.copyWith(
                borderWidth: value,
              ),
            );
          },
        ),

        // ----------------------------------------------------------------------
        // SHADOW
        // ----------------------------------------------------------------------

        AppearanceSwitch(
          label: 'Ombre',
          description: 'Ajoute une profondeur discrète',
          icon: Icons.layers_rounded,
          value: component.enableShadow,
          onChanged: (value) {
            onChanged(
              component.copyWith(
                enableShadow: value,
              ),
            );
          },
        ),

        AppearanceSlider(
          label: 'Opacité de l’ombre',
          value: component.shadowOpacity,
          min: 0,
          max: 0.40,
          divisions: 40,
          decimalPlaces: 2,
          enabled: component.enabled && component.enableShadow,
          onChanged: (value) {
            onChanged(
              component.copyWith(
                shadowOpacity: value,
              ),
            );
          },
        ),

        AppearanceSlider(
          label: 'Diffusion de l’ombre',
          value: component.shadowBlur,
          min: 0,
          max: 50,
          divisions: 50,
          suffix: ' px',
          decimalPlaces: 0,
          enabled: component.enabled && component.enableShadow,
          onChanged: (value) {
            onChanged(
              component.copyWith(
                shadowBlur: value,
              ),
            );
          },
        ),

        AppearanceSlider(
          label: 'Décalage vertical',
          value: component.shadowOffsetY,
          min: -20,
          max: 30,
          divisions: 50,
          suffix: ' px',
          decimalPlaces: 0,
          enabled: component.enabled && component.enableShadow,
          onChanged: (value) {
            onChanged(
              component.copyWith(
                shadowOffsetY: value,
              ),
            );
          },
        ),

        // ----------------------------------------------------------------------
        // HOVER
        // ----------------------------------------------------------------------

        if (showHover) ...[
          AppearanceSwitch(
            label: 'Survol',
            description: 'Active une élévation discrète au survol',
            icon: Icons.mouse_rounded,
            value: component.enableHover,
            onChanged: (value) {
              onChanged(
                component.copyWith(
                  enableHover: value,
                ),
              );
            },
          ),

          AppearanceSlider(
            label: 'Élévation au survol',
            value: component.hoverLift,
            min: 0,
            max: 10,
            divisions: 20,
            suffix: ' px',
            decimalPlaces: 1,
            enabled: component.enabled && component.enableHover,
            onChanged: (value) {
              onChanged(
                component.copyWith(
                  hoverLift: value,
                ),
              );
            },
          ),
        ],
      ],
    );
  }

  // ==========================================================================
  // INPUT CONTROLS
  // ==========================================================================

  Widget _inputControls() {
    final AppearanceInputSettings input = settings.input;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppearanceSwitch(
          label: 'Inputs actifs',
          description: 'Active les réglages spécifiques des champs',
          icon: Icons.input_rounded,
          value: input.enabled,
          onChanged: (value) {
            _update(
              settings.copyWith(
                input: input.copyWith(
                  enabled: value,
                ),
              ),
            );
          },
        ),

        AppearanceSwitch(
          label: 'Blur',
          description: 'Flou appliqué aux champs',
          icon: Icons.blur_on,
          value: input.enableBlur,
          onChanged: (value) {
            _update(
              settings.copyWith(
                input: input.copyWith(
                  enableBlur: value,
                ),
              ),
            );
          },
        ),

        AppearanceSlider(
          label: 'Blur',
          value: input.blur,
          min: 0,
          max: 40,
          divisions: 40,
          suffix: ' px',
          decimalPlaces: 0,
          enabled: input.enabled && input.enableBlur,
          onChanged: (value) {
            _update(
              settings.copyWith(
                input: input.copyWith(
                  blur: value,
                ),
              ),
            );
          },
        ),

        AppearanceSlider(
          label: 'Opacité',
          value: input.backgroundOpacity,
          min: 0.40,
          max: 1.0,
          divisions: 60,
          decimalPlaces: 2,
          enabled: input.enabled,
          onChanged: (value) {
            _update(
              settings.copyWith(
                input: input.copyWith(
                  backgroundOpacity: value,
                ),
              ),
            );
          },
        ),

        AppearanceSlider(
          label: 'Rayon',
          value: input.borderRadius,
          min: 0,
          max: 40,
          divisions: 40,
          suffix: ' px',
          decimalPlaces: 0,
          enabled: input.enabled,
          onChanged: (value) {
            _update(
              settings.copyWith(
                input: input.copyWith(
                  borderRadius: value,
                ),
              ),
            );
          },
        ),

        // ----------------------------------------------------------------------
        // BORDER
        // ----------------------------------------------------------------------

        AppearanceSwitch(
          label: 'Bordure',
          description: 'Contour des champs',
          icon: Icons.border_style_rounded,
          value: input.enableBorder,
          onChanged: (value) {
            _update(
              settings.copyWith(
                input: input.copyWith(
                  enableBorder: value,
                ),
              ),
            );
          },
        ),

        AppearanceSlider(
          label: 'Opacité bordure',
          value: input.borderOpacity,
          min: 0,
          max: 1,
          divisions: 100,
          decimalPlaces: 2,
          enabled: input.enabled && input.enableBorder,
          onChanged: (value) {
            _update(
              settings.copyWith(
                input: input.copyWith(
                  borderOpacity: value,
                ),
              ),
            );
          },
        ),

        AppearanceSlider(
          label: 'Épaisseur bordure',
          value: input.borderWidth,
          min: 0,
          max: 3,
          divisions: 30,
          suffix: ' px',
          decimalPlaces: 1,
          enabled: input.enabled && input.enableBorder,
          onChanged: (value) {
            _update(
              settings.copyWith(
                input: input.copyWith(
                  borderWidth: value,
                ),
              ),
            );
          },
        ),

        // ----------------------------------------------------------------------
        // SHADOW
        // ----------------------------------------------------------------------

        AppearanceSwitch(
          label: 'Ombre',
          description: 'Profondeur discrète des champs',
          icon: Icons.layers_rounded,
          value: input.enableShadow,
          onChanged: (value) {
            _update(
              settings.copyWith(
                input: input.copyWith(
                  enableShadow: value,
                ),
              ),
            );
          },
        ),

        AppearanceSlider(
          label: 'Opacité ombre',
          value: input.shadowOpacity,
          min: 0,
          max: 0.40,
          divisions: 40,
          decimalPlaces: 2,
          enabled: input.enabled && input.enableShadow,
          onChanged: (value) {
            _update(
              settings.copyWith(
                input: input.copyWith(
                  shadowOpacity: value,
                ),
              ),
            );
          },
        ),

        AppearanceSlider(
          label: 'Diffusion ombre',
          value: input.shadowBlur,
          min: 0,
          max: 50,
          divisions: 50,
          suffix: ' px',
          decimalPlaces: 0,
          enabled: input.enabled && input.enableShadow,
          onChanged: (value) {
            _update(
              settings.copyWith(
                input: input.copyWith(
                  shadowBlur: value,
                ),
              ),
            );
          },
        ),

        AppearanceSlider(
          label: 'Décalage vertical',
          value: input.shadowOffsetY,
          min: -20,
          max: 30,
          divisions: 50,
          suffix: ' px',
          decimalPlaces: 0,
          enabled: input.enabled && input.enableShadow,
          onChanged: (value) {
            _update(
              settings.copyWith(
                input: input.copyWith(
                  shadowOffsetY: value,
                ),
              ),
            );
          },
        ),

        // ----------------------------------------------------------------------
        // DIMENSIONS
        // ----------------------------------------------------------------------

        AppearanceSlider(
          label: 'Hauteur du champ',
          value: input.fieldHeight,
          min: 40,
          max: 80,
          divisions: 40,
          suffix: ' px',
          decimalPlaces: 0,
          enabled: input.enabled,
          onChanged: (value) {
            _update(
              settings.copyWith(
                input: input.copyWith(
                  fieldHeight: value,
                ),
              ),
            );
          },
        ),

        AppearanceSlider(
          label: 'Padding horizontal',
          value: input.horizontalPadding,
          min: 4,
          max: 32,
          divisions: 28,
          suffix: ' px',
          decimalPlaces: 0,
          enabled: input.enabled,
          onChanged: (value) {
            _update(
              settings.copyWith(
                input: input.copyWith(
                  horizontalPadding: value,
                ),
              ),
            );
          },
        ),

        AppearanceSlider(
          label: 'Padding vertical',
          value: input.verticalPadding,
          min: 2,
          max: 24,
          divisions: 22,
          suffix: ' px',
          decimalPlaces: 0,
          enabled: input.enabled,
          onChanged: (value) {
            _update(
              settings.copyWith(
                input: input.copyWith(
                  verticalPadding: value,
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  // ==========================================================================
  // FORM CONTROLS
  // ==========================================================================

  Widget _formControls() {
    final AppearanceFormSettings form = settings.form;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppearanceSwitch(
          label: 'Formulaire actif',
          description: 'Active les réglages spécifiques des formulaires',
          icon: Icons.assignment_rounded,
          value: form.enabled,
          onChanged: (value) {
            _update(
              settings.copyWith(
                form: form.copyWith(
                  enabled: value,
                ),
              ),
            );
          },
        ),

        AppearanceSwitch(
          label: 'Blur',
          description: 'Flou de la surface du formulaire',
          icon: Icons.blur_on,
          value: form.enableBlur,
          onChanged: (value) {
            _update(
              settings.copyWith(
                form: form.copyWith(
                  enableBlur: value,
                ),
              ),
            );
          },
        ),

        AppearanceSlider(
          label: 'Blur',
          value: form.blur,
          min: 0,
          max: 40,
          divisions: 40,
          suffix: ' px',
          decimalPlaces: 0,
          enabled: form.enabled && form.enableBlur,
          onChanged: (value) {
            _update(
              settings.copyWith(
                form: form.copyWith(
                  blur: value,
                ),
              ),
            );
          },
        ),

        AppearanceSlider(
          label: 'Opacité',
          value: form.backgroundOpacity,
          min: 0.40,
          max: 1.0,
          divisions: 60,
          decimalPlaces: 2,
          enabled: form.enabled,
          onChanged: (value) {
            _update(
              settings.copyWith(
                form: form.copyWith(
                  backgroundOpacity: value,
                ),
              ),
            );
          },
        ),

        AppearanceSlider(
          label: 'Rayon',
          value: form.borderRadius,
          min: 0,
          max: 40,
          divisions: 40,
          suffix: ' px',
          decimalPlaces: 0,
          enabled: form.enabled,
          onChanged: (value) {
            _update(
              settings.copyWith(
                form: form.copyWith(
                  borderRadius: value,
                ),
              ),
            );
          },
        ),

        AppearanceSwitch(
          label: 'Bordure',
          description: 'Contour du formulaire',
          icon: Icons.border_style_rounded,
          value: form.enableBorder,
          onChanged: (value) {
            _update(
              settings.copyWith(
                form: form.copyWith(
                  enableBorder: value,
                ),
              ),
            );
          },
        ),

        AppearanceSlider(
          label: 'Opacité bordure',
          value: form.borderOpacity,
          min: 0,
          max: 1,
          divisions: 100,
          decimalPlaces: 2,
          enabled: form.enabled && form.enableBorder,
          onChanged: (value) {
            _update(
              settings.copyWith(
                form: form.copyWith(
                  borderOpacity: value,
                ),
              ),
            );
          },
        ),

        AppearanceSlider(
          label: 'Épaisseur bordure',
          value: form.borderWidth,
          min: 0,
          max: 3,
          divisions: 30,
          suffix: ' px',
          decimalPlaces: 1,
          enabled: form.enabled && form.enableBorder,
          onChanged: (value) {
            _update(
              settings.copyWith(
                form: form.copyWith(
                  borderWidth: value,
                ),
              ),
            );
          },
        ),

        AppearanceSwitch(
          label: 'Ombre',
          description: 'Profondeur discrète du formulaire',
          icon: Icons.layers_rounded,
          value: form.enableShadow,
          onChanged: (value) {
            _update(
              settings.copyWith(
                form: form.copyWith(
                  enableShadow: value,
                ),
              ),
            );
          },
        ),

        AppearanceSlider(
          label: 'Opacité ombre',
          value: form.shadowOpacity,
          min: 0,
          max: 0.40,
          divisions: 40,
          decimalPlaces: 2,
          enabled: form.enabled && form.enableShadow,
          onChanged: (value) {
            _update(
              settings.copyWith(
                form: form.copyWith(
                  shadowOpacity: value,
                ),
              ),
            );
          },
        ),

        AppearanceSlider(
          label: 'Diffusion ombre',
          value: form.shadowBlur,
          min: 0,
          max: 50,
          divisions: 50,
          suffix: ' px',
          decimalPlaces: 0,
          enabled: form.enabled && form.enableShadow,
          onChanged: (value) {
            _update(
              settings.copyWith(
                form: form.copyWith(
                  shadowBlur: value,
                ),
              ),
            );
          },
        ),

        AppearanceSlider(
          label: 'Espacement des champs',
          value: form.fieldSpacing,
          min: 0,
          max: 40,
          divisions: 40,
          suffix: ' px',
          decimalPlaces: 0,
          enabled: form.enabled,
          onChanged: (value) {
            _update(
              settings.copyWith(
                form: form.copyWith(
                  fieldSpacing: value,
                ),
              ),
            );
          },
        ),

        AppearanceSlider(
          label: 'Espacement des sections',
          value: form.sectionSpacing,
          min: 0,
          max: 60,
          divisions: 60,
          suffix: ' px',
          decimalPlaces: 0,
          enabled: form.enabled,
          onChanged: (value) {
            _update(
              settings.copyWith(
                form: form.copyWith(
                  sectionSpacing: value,
                ),
              ),
            );
          },
        ),

        AppearanceSlider(
          label: 'Espacement des actions',
          value: form.actionsSpacing,
          min: 0,
          max: 40,
          divisions: 40,
          suffix: ' px',
          decimalPlaces: 0,
          enabled: form.enabled,
          onChanged: (value) {
            _update(
              settings.copyWith(
                form: form.copyWith(
                  actionsSpacing: value,
                ),
              ),
            );
          },
        ),

        AppearanceSlider(
          label: 'Padding horizontal',
          value: form.horizontalPadding,
          min: 0,
          max: 40,
          divisions: 40,
          suffix: ' px',
          decimalPlaces: 0,
          enabled: form.enabled,
          onChanged: (value) {
            _update(
              settings.copyWith(
                form: form.copyWith(
                  horizontalPadding: value,
                ),
              ),
            );
          },
        ),

        AppearanceSlider(
          label: 'Padding vertical',
          value: form.verticalPadding,
          min: 0,
          max: 40,
          divisions: 40,
          suffix: ' px',
          decimalPlaces: 0,
          enabled: form.enabled,
          onChanged: (value) {
            _update(
              settings.copyWith(
                form: form.copyWith(
                  verticalPadding: value,
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  // ==========================================================================
  // TOAST CONTROLS
  // ==========================================================================

  Widget _toastControls() {
    final AppearanceToastSettings toast = settings.toast;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppearanceSwitch(
          label: 'Toast actif',
          description: 'Active les réglages spécifiques des notifications',
          icon: Icons.notifications_none_rounded,
          value: toast.enabled,
          onChanged: (value) {
            _update(
              settings.copyWith(
                toast: toast.copyWith(
                  enabled: value,
                ),
              ),
            );
          },
        ),

        AppearanceSwitch(
          label: 'Blur',
          description: 'Flou de l’arrière-plan du toast',
          icon: Icons.blur_on,
          value: toast.enableBlur,
          onChanged: (value) {
            _update(
              settings.copyWith(
                toast: toast.copyWith(
                  enableBlur: value,
                ),
              ),
            );
          },
        ),

        AppearanceSlider(
          label: 'Blur',
          value: toast.blur,
          min: 0,
          max: 40,
          divisions: 40,
          suffix: ' px',
          decimalPlaces: 0,
          enabled: toast.enabled && toast.enableBlur,
          onChanged: (value) {
            _update(
              settings.copyWith(
                toast: toast.copyWith(
                  blur: value,
                ),
              ),
            );
          },
        ),

        AppearanceSlider(
          label: 'Opacité',
          value: toast.backgroundOpacity,
          min: 0.50,
          max: 1.0,
          divisions: 50,
          decimalPlaces: 2,
          enabled: toast.enabled,
          onChanged: (value) {
            _update(
              settings.copyWith(
                toast: toast.copyWith(
                  backgroundOpacity: value,
                ),
              ),
            );
          },
        ),

        AppearanceSlider(
          label: 'Rayon',
          value: toast.borderRadius,
          min: 0,
          max: 40,
          divisions: 40,
          suffix: ' px',
          decimalPlaces: 0,
          enabled: toast.enabled,
          onChanged: (value) {
            _update(
              settings.copyWith(
                toast: toast.copyWith(
                  borderRadius: value,
                ),
              ),
            );
          },
        ),

        AppearanceSwitch(
          label: 'Bordure',
          description: 'Contour du toast',
          icon: Icons.border_style_rounded,
          value: toast.enableBorder,
          onChanged: (value) {
            _update(
              settings.copyWith(
                toast: toast.copyWith(
                  enableBorder: value,
                ),
              ),
            );
          },
        ),

        AppearanceSlider(
          label: 'Opacité bordure',
          value: toast.borderOpacity,
          min: 0,
          max: 1,
          divisions: 100,
          decimalPlaces: 2,
          enabled: toast.enabled && toast.enableBorder,
          onChanged: (value) {
            _update(
              settings.copyWith(
                toast: toast.copyWith(
                  borderOpacity: value,
                ),
              ),
            );
          },
        ),

        AppearanceSlider(
          label: 'Épaisseur bordure',
          value: toast.borderWidth,
          min: 0,
          max: 3,
          divisions: 30,
          suffix: ' px',
          decimalPlaces: 1,
          enabled: toast.enabled && toast.enableBorder,
          onChanged: (value) {
            _update(
              settings.copyWith(
                toast: toast.copyWith(
                  borderWidth: value,
                ),
              ),
            );
          },
        ),

        AppearanceSwitch(
          label: 'Ombre',
          description: 'Profondeur du toast',
          icon: Icons.layers_rounded,
          value: toast.enableShadow,
          onChanged: (value) {
            _update(
              settings.copyWith(
                toast: toast.copyWith(
                  enableShadow: value,
                ),
              ),
            );
          },
        ),

        AppearanceSlider(
          label: 'Opacité ombre',
          value: toast.shadowOpacity,
          min: 0,
          max: 0.40,
          divisions: 40,
          decimalPlaces: 2,
          enabled: toast.enabled && toast.enableShadow,
          onChanged: (value) {
            _update(
              settings.copyWith(
                toast: toast.copyWith(
                  shadowOpacity: value,
                ),
              ),
            );
          },
        ),

        AppearanceSlider(
          label: 'Diffusion ombre',
          value: toast.shadowBlur,
          min: 0,
          max: 50,
          divisions: 50,
          suffix: ' px',
          decimalPlaces: 0,
          enabled: toast.enabled && toast.enableShadow,
          onChanged: (value) {
            _update(
              settings.copyWith(
                toast: toast.copyWith(
                  shadowBlur: value,
                ),
              ),
            );
          },
        ),

        AppearanceSlider(
          label: 'Durée',
          value: toast.duration,
          min: 0.5,
          max: 10,
          divisions: 19,
          suffix: ' s',
          decimalPlaces: 1,
          enabled: toast.enabled,
          onChanged: (value) {
            _update(
              settings.copyWith(
                toast: toast.copyWith(
                  duration: value,
                ),
              ),
            );
          },
        ),

        AppearanceSlider(
          label: 'Largeur maximale',
          value: toast.maxWidth,
          min: 200,
          max: 700,
          divisions: 50,
          suffix: ' px',
          decimalPlaces: 0,
          enabled: toast.enabled,
          onChanged: (value) {
            _update(
              settings.copyWith(
                toast: toast.copyWith(
                  maxWidth: value,
                ),
              ),
            );
          },
        ),

        AppearanceSlider(
          label: 'Padding horizontal',
          value: toast.horizontalPadding,
          min: 4,
          max: 32,
          divisions: 28,
          suffix: ' px',
          decimalPlaces: 0,
          enabled: toast.enabled,
          onChanged: (value) {
            _update(
              settings.copyWith(
                toast: toast.copyWith(
                  horizontalPadding: value,
                ),
              ),
            );
          },
        ),

        AppearanceSlider(
          label: 'Padding vertical',
          value: toast.verticalPadding,
          min: 4,
          max: 24,
          divisions: 20,
          suffix: ' px',
          decimalPlaces: 0,
          enabled: toast.enabled,
          onChanged: (value) {
            _update(
              settings.copyWith(
                toast: toast.copyWith(
                  verticalPadding: value,
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  // ==========================================================================
  // TOOLTIP CONTROLS
  // ==========================================================================

  Widget _tooltipControls() {
    final AppearanceTooltipSettings tooltip = settings.tooltip;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppearanceSwitch(
          label: 'Tooltip actif',
          description: 'Active les réglages spécifiques des tooltips',
          icon: Icons.info_outline_rounded,
          value: tooltip.enabled,
          onChanged: (value) {
            _update(
              settings.copyWith(
                tooltip: tooltip.copyWith(
                  enabled: value,
                ),
              ),
            );
          },
        ),

        AppearanceSwitch(
          label: 'Blur',
          description: 'Flou de l’arrière-plan du tooltip',
          icon: Icons.blur_on,
          value: tooltip.enableBlur,
          onChanged: (value) {
            _update(
              settings.copyWith(
                tooltip: tooltip.copyWith(
                  enableBlur: value,
                ),
              ),
            );
          },
        ),

        AppearanceSlider(
          label: 'Blur',
          value: tooltip.blur,
          min: 0,
          max: 40,
          divisions: 40,
          suffix: ' px',
          decimalPlaces: 0,
          enabled: tooltip.enabled && tooltip.enableBlur,
          onChanged: (value) {
            _update(
              settings.copyWith(
                tooltip: tooltip.copyWith(
                  blur: value,
                ),
              ),
            );
          },
        ),

        AppearanceSlider(
          label: 'Opacité',
          value: tooltip.backgroundOpacity,
          min: 0.50,
          max: 1.0,
          divisions: 50,
          decimalPlaces: 2,
          enabled: tooltip.enabled,
          onChanged: (value) {
            _update(
              settings.copyWith(
                tooltip: tooltip.copyWith(
                  backgroundOpacity: value,
                ),
              ),
            );
          },
        ),

        AppearanceSlider(
          label: 'Rayon',
          value: tooltip.borderRadius,
          min: 0,
          max: 30,
          divisions: 30,
          suffix: ' px',
          decimalPlaces: 0,
          enabled: tooltip.enabled,
          onChanged: (value) {
            _update(
              settings.copyWith(
                tooltip: tooltip.copyWith(
                  borderRadius: value,
                ),
              ),
            );
          },
        ),

        AppearanceSwitch(
          label: 'Bordure',
          description: 'Contour du tooltip',
          icon: Icons.border_style_rounded,
          value: tooltip.enableBorder,
          onChanged: (value) {
            _update(
              settings.copyWith(
                tooltip: tooltip.copyWith(
                  enableBorder: value,
                ),
              ),
            );
          },
        ),

        AppearanceSlider(
          label: 'Opacité bordure',
          value: tooltip.borderOpacity,
          min: 0,
          max: 1,
          divisions: 100,
          decimalPlaces: 2,
          enabled: tooltip.enabled && tooltip.enableBorder,
          onChanged: (value) {
            _update(
              settings.copyWith(
                tooltip: tooltip.copyWith(
                  borderOpacity: value,
                ),
              ),
            );
          },
        ),

        AppearanceSlider(
          label: 'Épaisseur bordure',
          value: tooltip.borderWidth,
          min: 0,
          max: 3,
          divisions: 30,
          suffix: ' px',
          decimalPlaces: 1,
          enabled: tooltip.enabled && tooltip.enableBorder,
          onChanged: (value) {
            _update(
              settings.copyWith(
                tooltip: tooltip.copyWith(
                  borderWidth: value,
                ),
              ),
            );
          },
        ),

        AppearanceSwitch(
          label: 'Ombre',
          description: 'Profondeur du tooltip',
          icon: Icons.layers_rounded,
          value: tooltip.enableShadow,
          onChanged: (value) {
            _update(
              settings.copyWith(
                tooltip: tooltip.copyWith(
                  enableShadow: value,
                ),
              ),
            );
          },
        ),

        AppearanceSlider(
          label: 'Opacité ombre',
          value: tooltip.shadowOpacity,
          min: 0,
          max: 0.40,
          divisions: 40,
          decimalPlaces: 2,
          enabled: tooltip.enabled && tooltip.enableShadow,
          onChanged: (value) {
            _update(
              settings.copyWith(
                tooltip: tooltip.copyWith(
                  shadowOpacity: value,
                ),
              ),
            );
          },
        ),

        AppearanceSlider(
          label: 'Diffusion ombre',
          value: tooltip.shadowBlur,
          min: 0,
          max: 50,
          divisions: 50,
          suffix: ' px',
          decimalPlaces: 0,
          enabled: tooltip.enabled && tooltip.enableShadow,
          onChanged: (value) {
            _update(
              settings.copyWith(
                tooltip: tooltip.copyWith(
                  shadowBlur: value,
                ),
              ),
            );
          },
        ),

        AppearanceSlider(
          label: 'Durée d’affichage',
          value: tooltip.showDuration,
          min: 0.5,
          max: 10,
          divisions: 19,
          suffix: ' s',
          decimalPlaces: 1,
          enabled: tooltip.enabled,
          onChanged: (value) {
            _update(
              settings.copyWith(
                tooltip: tooltip.copyWith(
                  showDuration: value,
                ),
              ),
            );
          },
        ),

        AppearanceSlider(
          label: 'Délai d’apparition',
          value: tooltip.waitDuration,
          min: 0,
          max: 3,
          divisions: 30,
          suffix: ' s',
          decimalPlaces: 1,
          enabled: tooltip.enabled,
          onChanged: (value) {
            _update(
              settings.copyWith(
                tooltip: tooltip.copyWith(
                  waitDuration: value,
                ),
              ),
            );
          },
        ),

        AppearanceSlider(
          label: 'Largeur maximale',
          value: tooltip.maxWidth,
          min: 150,
          max: 600,
          divisions: 45,
          suffix: ' px',
          decimalPlaces: 0,
          enabled: tooltip.enabled,
          onChanged: (value) {
            _update(
              settings.copyWith(
                tooltip: tooltip.copyWith(
                  maxWidth: value,
                ),
              ),
            );
          },
        ),

        AppearanceSlider(
          label: 'Padding horizontal',
          value: tooltip.horizontalPadding,
          min: 4,
          max: 32,
          divisions: 28,
          suffix: ' px',
          decimalPlaces: 0,
          enabled: tooltip.enabled,
          onChanged: (value) {
            _update(
              settings.copyWith(
                tooltip: tooltip.copyWith(
                  horizontalPadding: value,
                ),
              ),
            );
          },
        ),

        AppearanceSlider(
          label: 'Padding vertical',
          value: tooltip.verticalPadding,
          min: 2,
          max: 24,
          divisions: 22,
          suffix: ' px',
          decimalPlaces: 0,
          enabled: tooltip.enabled,
          onChanged: (value) {
            _update(
              settings.copyWith(
                tooltip: tooltip.copyWith(
                  verticalPadding: value,
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  // ==========================================================================
  // BUILD
  // ==========================================================================

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ======================================================================
        // GLOBAL
        // ======================================================================

        _sectionTitle('Effets globaux'),

        // ----------------------------------------------------------------------
        // BLUR
        // ----------------------------------------------------------------------

        AppearanceSwitch(
          label: 'Blur',
          description: 'Flou de l’arrière-plan',
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
          decimalPlaces: 0,
          enabled: settings.enableBlur,
          onChanged: (value) {
            _update(
              settings.copyWith(
                blur: value,
              ),
            );
          },
        ),

        // ----------------------------------------------------------------------
        // NOISE
        // ----------------------------------------------------------------------

        AppearanceSwitch(
          label: 'Noise',
          description: 'Texture très subtile du verre',
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
          max: 0.15,
          divisions: 30,
          decimalPlaces: 2,
          enabled: settings.enableNoise,
          onChanged: (value) {
            _update(
              settings.copyWith(
                noise: value,
              ),
            );
          },
        ),

        // ----------------------------------------------------------------------
        // GRADIENT
        // ----------------------------------------------------------------------

        AppearanceSwitch(
          label: 'Gradient',
          description: 'Variation douce de la surface',
          icon: Icons.gradient,
          value: settings.enableGradient,
          onChanged: (value) {
            _update(
              settings.copyWith(
                enableGradient: value,
              ),
            );
          },
        ),

        AppearanceSlider(
          label: 'Opacité du gradient',
          value: settings.gradientOpacity,
          min: 0,
          max: 1,
          divisions: 100,
          decimalPlaces: 2,
          enabled: settings.enableGradient,
          onChanged: (value) {
            _update(
              settings.copyWith(
                gradientOpacity: value,
              ),
            );
          },
        ),

        AppearanceSlider(
          label: 'Densité du gradient',
          value: settings.gradientDensity,
          min: 1,
          max: 10,
          divisions: 9,
          decimalPlaces: 0,
          enabled: settings.enableGradient,
          onChanged: (value) {
            _update(
              settings.copyWith(
                gradientDensity: value,
              ),
            );
          },
        ),

        _componentDivider(),

        // ======================================================================
        // SURFACE
        // ======================================================================

        _sectionTitle('Surface'),

        AppearanceSlider(
          label: 'Opacité',
          value: settings.surfaceOpacity,
          min: 0.70,
          max: 1,
          divisions: 30,
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

        _componentDivider(),

        // ======================================================================
        // BORDER
        // ======================================================================

        _sectionTitle('Bordure'),

        AppearanceSwitch(
          label: 'Bordure',
          description: 'Affiche le contour de la surface',
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

        _componentDivider(),

        // ======================================================================
        // GLOW
        // ======================================================================

        _sectionTitle('Glow'),

        AppearanceSwitch(
          label: 'Glow',
          description: 'Halo lumineux très discret',
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
          max: 0.30,
          divisions: 30,
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

        _componentDivider(),

        // ======================================================================
        // SHADOW
        // ======================================================================

        _sectionTitle('Ombre'),

        AppearanceSwitch(
          label: 'Ombre',
          description: 'Ajoute une profondeur sous la surface',
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
          max: 0.40,
          divisions: 40,
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

        _componentDivider(),

        // ======================================================================
        // INTERACTION
        // ======================================================================

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

        _componentDivider(),

        // ======================================================================
        // COMPONENTS
        // ======================================================================

        _sectionTitle('Composants Glass'),

        _componentControls(
          component: settings.component,
          showHover: true,
          onChanged: (value) {
            _update(
              settings.copyWith(
                component: value,
              ),
            );
          },
        ),

        _componentDivider(),

        // ======================================================================
        // INPUTS
        // ======================================================================

        _sectionTitle('Inputs'),

        _inputControls(),

        _componentDivider(),

        // ======================================================================
        // FORMS
        // ======================================================================

        _sectionTitle('Forms'),

        _formControls(),

        _componentDivider(),

        // ======================================================================
        // TOAST
        // ======================================================================

        _sectionTitle('Toast / Snackbar'),

        _toastControls(),

        _componentDivider(),

        // ======================================================================
        // TOOLTIP
        // ======================================================================

        _sectionTitle('Tooltip'),

        _tooltipControls(),

        const SizedBox(
          height: 12,
        ),
      ],
    );
  }
}
