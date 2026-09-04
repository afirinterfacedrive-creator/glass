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

  static const List<Map<String, dynamic>> _presets = [
    {'style': GlassStyle.classicSb, 'name': 'Classic', 'desc': 'Neutre léger'},
    {'style': GlassStyle.customGradient, 'name': 'Frosted', 'desc': 'Verre dépoli'},
    {'style': GlassStyle.sageOled, 'name': 'Sage OLED', 'desc': 'Noir profond'},
    {'style': GlassStyle.sageGlass, 'name': 'Sage Glass', 'desc': 'Glass subtil'},
  ];

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
        final preset = _presets[index];
        final GlassStyle style = preset['style'];
        final bool isSelected = selectedStyle == style;

        return GestureDetector(
          onTap: () => onSelected(style),
          child: GlassSurfaceContainer(
            style: style,
            liftOnHover: true,
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected? Colors.white.withValues(alpha: 0.6) : Colors.transparent,
                  width: 2,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    preset['name'],
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    preset['desc'],
                    style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.7)),
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