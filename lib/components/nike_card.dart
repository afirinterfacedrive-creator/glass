import 'package:flutter/material.dart';
import '../enums/glass_enums.dart';
import '../theme/glass_effects.dart';
import '../components/glass_button.dart';

class NikeCard extends StatelessWidget {
  final GlassEffects effects;
  final GlassShapeType shape;
  final GlassStyle style;

  const NikeCard({
    super.key,
    required this.effects,
    required this.shape,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    return GlassButton(
      width: 160,
      height: 160,
      shape: shape,
      effects: effects,
      style: style,
      onTap: () => debugPrint("Clic Nike"),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [Colors.purpleAccent, Colors.orangeAccent],
            ).createShader(bounds),
            child: const Text(
              "nike",
              style: TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                color: Colors.white,
              ),
            ),
          ),
          const Text(
            "Just Do It.",
            style: TextStyle(
              fontSize: 12,
              color: Colors.white70,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
