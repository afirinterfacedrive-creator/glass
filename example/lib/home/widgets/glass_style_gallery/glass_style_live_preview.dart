import 'package:flutter/material.dart';
import 'package:universal_glass/glass.dart';

class GlassStyleLivePreview extends StatelessWidget {
  final GlassThemeState theme;
  final bool isMobile;
  final String title;
  final String description;
  final IconData icon;
  final bool isNew; // <-- AJOUTÉ

  const GlassStyleLivePreview({
    super.key,
    required this.theme,
    required this.isMobile,
    required this.title,
    required this.description,
    required this.icon,
    this.isNew = false, // <-- AJOUTÉ
  });

  @override
  Widget build(BuildContext context) {
    final bool isSage = theme.glassStyle.name.contains('sage');
    final Color accentColor = isSage
        ? const Color(0xFFE91E63) // Rouge KDTV pour Sage
        : theme.useAquaStyle
            ? Colors.cyanAccent
            : Colors.orangeAccent;

    return GlassSurfaceContainer(
      style: theme.glassStyle,
      liftOnHover: false,
      borderRadius: BorderRadius.circular(24),
      padding: const EdgeInsets.all(24),
      child: SizedBox(
        width: double.infinity,
        height: isMobile ? 140 : 180,
        child: Stack( // Passé en Stack pour le badge
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row( // Row pour mettre le badge à côté de PREVIEW LIVE
                        children: [
                          Text(
                            'PREVIEW LIVE',
                            style: TextStyle(
                              color: accentColor,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                            ),
                          ),
                          if (isNew) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE91E63),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'NEW',
                                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                            ),
                          ]
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: theme.glassStyle == GlassStyle.sageOled 
                            ? Colors.white // Force blanc sur OLED
                            : null,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        description,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  icon,
                  size: isMobile ? 60 : 80,
                  color: isSage 
                    ? accentColor.withValues(alpha: 0.25) // Glow rouge pour sage
                    : Colors.white.withValues(alpha: 0.15),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}