import 'package:flutter/material.dart';

class GlassWelcomeWidget extends StatelessWidget {
  final bool useAquaStyle;
  final double borderRadius;

  const GlassWelcomeWidget({
    super.key,
    required this.useAquaStyle,
    required this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final Color accent = useAquaStyle ? Colors.cyanAccent : Colors.orangeAccent;

    return Container(
      // On applique la base de votre décoration (borderRadius, dégradé de fond, bordure et ombres)
      decoration: GlassWelcomeDecoration.resolve(
        useAquaStyle: useAquaStyle,
        borderRadius: borderRadius,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Stack(
          children: [
            // Couche 1 : Les vagues / formes géométriques en arrière-plan
            Positioned.fill(
              child: CustomPaint(
                painter: _WaveBackgroundPainter(accentColor: accent),
              ),
            ),
            // Couche 2 : Votre contenu (Textes, Icônes, etc.)
            const Padding(
              padding: EdgeInsets.all(24.0),
              child: Row(
                children: [
                  // Ajoutez vos textes "BIENVENUE", "Votre espace..." ici
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Le CustomPainter pour dessiner les formes en arrière-plan ---
class _WaveBackgroundPainter extends CustomPainter {
  final Color accentColor;

  _WaveBackgroundPainter({required this.accentColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = accentColor.withValues(alpha: 0.025) // Opacité extrêmement faible pour rester subtil
      ..style = PaintingStyle.fill;

    final path = Path();
    
    // Dessin des motifs répétitifs en pics / vagues (ajustez les coordonnées selon vos besoins)
    double startX = size.width * 0.3;
    double endX = size.width * 0.8;
    double topY = size.height * 0.2;
    double bottomY = size.height * 0.8;

    path.moveTo(startX, bottomY);
    for (double i = startX; i <= endX; i += 30) {
      path.lineTo(i + 15, topY);
      path.lineTo(i + 30, bottomY);
    }
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// --- Votre classe d'origine légèrement optimisée pour le fond ---
class GlassWelcomeDecoration {
  const GlassWelcomeDecoration._();

  static BoxDecoration resolve({
    required bool useAquaStyle,
    required double borderRadius,
  }) {
    final Color accent = useAquaStyle ? Colors.cyanAccent : Colors.orangeAccent;

    return BoxDecoration(
      borderRadius: BorderRadius.circular(borderRadius),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          const Color(0xFF161616), // Un noir légèrement plus profond pour faire ressortir les contrastes
          useAquaStyle 
            ? const Color(0xFF0A1212) 
            : const Color(0xFF1A140E), // Un orange foncé adouci
        ],
      ),
      border: Border.all(
        color: accent.withValues(alpha: 0.08), // Bordure adoucie pour coller à l'image
        width: 1,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.4),
          blurRadius: 24,
          offset: const Offset(0, 10),
        ),
      ],
    );
  }
}
