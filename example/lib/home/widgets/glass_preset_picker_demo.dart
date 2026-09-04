import 'package:flutter/material.dart';
import 'package:universal_glass/components/surface/glass_surface_container.dart';
import 'package:universal_glass/enums/glass_enums.dart';
import 'package:universal_glass_example/home/widgets/glass_preset_preview.dart';

// ============================================================================
// DEMO: PICKER ANIMÉ - OPTION C
// ============================================================================
//
// Affiche la grille des 6 presets signature
// Permet de sélectionner et voir le rendu en temps réel
//
// ============================================================================

class GlassPresetPickerDemo extends StatefulWidget {
  const GlassPresetPickerDemo({super.key});

  @override
  State<GlassPresetPickerDemo> createState() => _GlassPresetPickerDemoState();
}

class _GlassPresetPickerDemoState extends State<GlassPresetPickerDemo> {
  GlassStyle _selected = GlassStyle.sagePro; // Default sur Sage Pro

  // Données des 6 presets signature
  final List<Map<String, dynamic>> _presets = [
    {'style': GlassStyle.transparentAqua, 'label': 'Aqua Frost', 'accent': Color(0xFF00BCD4)},
    {'style': GlassStyle.opaqueMat, 'label': 'Classic Dark', 'accent': Color(0xFF9E9E9E)},
    {'style': GlassStyle.sagePro, 'label': 'Sage Pro', 'accent': Color(0xFFE91E63)}, // Rouge KDTV
    {'style': GlassStyle.sageOled, 'label': 'Sage OLED', 'accent': Colors.white},
    {'style': GlassStyle.sageGlass, 'label': 'Sage Glass', 'accent': Color(0xFFE91E63)},
    {'style': GlassStyle.classicSb, 'label': 'Classic Subtle', 'accent': Color(0xFFD4AF37)}, // Or
  ];

  bool get _isAnimated {
    return _selected == GlassStyle.sagePro ||
           _selected == GlassStyle.sageGlass ||
           _selected == GlassStyle.transparentAqua;
  }

  @override
  Widget build(BuildContext context) {
    final currentPreset = _presets.firstWhere((p) => p['style'] == _selected);

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Picker Animé - Signature Pack'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // 1. PREVIEW DU STYLE SELECTIONNE
          Padding(
            padding: const EdgeInsets.all(20),
            child: GlassSurfaceContainer(
              style: _selected,
              liftOnHover: true,
              padding: const EdgeInsets.all(24),
              borderRadius: BorderRadius.circular(24),
              child: Column(
                children: [
                  Icon(
                    _isAnimated? Icons.blur_on_rounded : Icons.layers_rounded,
                    size: 48,
                    color: currentPreset['accent'] as Color,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Style: ${currentPreset['label']}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isAnimated
                    ? 'Gradient animé actif'
                      : 'Style statique premium',
                    style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha:.7)),
                  ),
                ],
              ),
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Choisissez un preset signature',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // 2. GRILLE DES PRESETS
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.3,
              ),
              itemCount: _presets.length,
              itemBuilder: (context, index) {
                final preset = _presets[index];
                return GlassPresetPreview(
                  style: preset['style'] as GlassStyle,
                  label: preset['label'] as String,
                  accent: preset['accent'] as Color,
                  selected: _selected == preset['style'],
                  onTap: () {
                    setState(() {
                      _selected = preset['style'] as GlassStyle;
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}