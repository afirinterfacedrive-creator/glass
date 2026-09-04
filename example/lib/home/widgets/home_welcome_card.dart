import 'package:flutter/material.dart';
import 'package:universal_glass/glass.dart';


// ============================================================================
// HOME WELCOME CARD
// ============================================================================

class HomeWelcomeCard extends StatelessWidget {
  final GlassThemeState theme;
  final bool compact;

  const HomeWelcomeCard({
    super.key,
    required this.theme,
    required this.compact,
  });

  @override
  Widget build(BuildContext context) {
    final Color accent = theme.useAquaStyle
        ? Colors.cyanAccent
        : Colors.orangeAccent;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: double.infinity,
      padding: EdgeInsets.all(compact ? 20 : 28),
      
      // UTILISATION DE LA CLASSE UTILE EXTRAITE :
      decoration: GlassClassicSbDecoration.resolve(
        useAquaStyle: theme.useAquaStyle,
        borderRadius: 26.0,
      ),

      child: Row(
        children: [
          // ==================================================================
          // TEXTE
          // ==================================================================
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'BIENVENUE',
                  style: TextStyle(
                    color: accent,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.6,
                  ),
                ),
                const SizedBox(height: 9),
                Text(
                  'Votre espace de contrôle Glass',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: compact ? 20 : 23,
                    fontWeight: FontWeight.bold,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 9),
                const Text(
                  'Accédez rapidement à vos contrôles, '
                  'réglages et outils.',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 13,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),

          // ==================================================================
          // ICÔNE
          // ==================================================================
          if (!compact) ...[
            const SizedBox(width: 30),
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: accent.withValues(alpha: .045),
              ),
              child: Icon(
                Icons.dashboard_customize_outlined,
                size: 62,
                color: accent.withValues(alpha: .32),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
