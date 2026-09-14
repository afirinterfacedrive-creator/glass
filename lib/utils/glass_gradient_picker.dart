
import 'package:flutter/material.dart';
import 'package:universal_glass/enums/glass_enums.dart';
import 'package:universal_glass/components/surface/glass_surface_container.dart';

class GlassGradientPicker extends StatelessWidget {
  final GlassStyle selectedStyle;
  final ValueChanged<GlassStyle> onSelected;

  const GlassGradientPicker({
    super.key,
    required this.selectedStyle,
    required this.onSelected,
  });

  // ==========================================================================
  // PRESETS
  // ==========================================================================

  static const List<_GradientPreset> _presets = [
    _GradientPreset(
      style: GlassStyle.classicSb,
      name: 'Classic',
      description: 'Neutre léger',
    ),
    _GradientPreset(
      style: GlassStyle.customGradient,
      name: 'Frosted',
      description: 'Verre dépoli',
    ),
    _GradientPreset(
      style: GlassStyle.transparentAqua,
      name: 'Aqua Glass',
      description: 'Verre transparent',
    ),
    _GradientPreset(
      style: GlassStyle.gradientOpaque,
      name: 'Gradient',
      description: 'Gradient opaque',
    ),
  ];

  // ==========================================================================
  // BUILD
  // ==========================================================================

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2.2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: _presets.length,
      itemBuilder: (context, index) {
        final _GradientPreset preset = _presets[index];

        final bool isSelected =
            selectedStyle == preset.style;

        return GestureDetector(
          onTap: () => onSelected(preset.style),
          child: GlassSurfaceContainer(
            style: preset.style,
            liftOnHover: true,
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected
                      ? Colors.white.withValues(alpha: 0.6)
                      : Colors.transparent,
                  width: 2,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    preset.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    preset.description,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.white.withValues(alpha: 0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ============================================================================
// MODÈLE INTERNE DES PRESETS
// ============================================================================

class _GradientPreset {
  final GlassStyle style;
  final String name;
  final String description;

  const _GradientPreset({
    required this.style,
    required this.name,
    required this.description,
  });
}
