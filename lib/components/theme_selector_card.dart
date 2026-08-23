import 'package:flutter/material.dart';

import '../enums/glass_enums.dart';
import '../theme/glass_effects.dart';
import '../components/glass_button.dart';
import '../components/icon_glass_bubble.dart';

class ThemeSelectorCard extends StatefulWidget {
  final GlassEffects effects;
  final GlassShapeType shape;
  final GlassStyle style;

  // ============================================================
  // DIMENSIONS DE LA CARTE
  // ============================================================

  final double width;
  final double height;

  // ============================================================
  // TAILLE DES BULLES
  //
  // null = automatique
  // ============================================================

  final double? bubbleSize;

  // ============================================================
  // MARGES EXTÉRIEURES HORIZONTALES
  //
  // Espace entre les bulles et les bords gauche/droit
  // de la carte.
  // ============================================================

  final double horizontalPadding;

  // ============================================================
  // ESPACEMENT ENTRE LES BULLES
  // ============================================================

  final double spacing;

  const ThemeSelectorCard({
    super.key,
    required this.effects,
    required this.shape,
    required this.style,

    this.width = 210,
    this.height = 75,

    this.bubbleSize,

    this.horizontalPadding = 1,
    this.spacing = 3,
  });

  @override
  State<ThemeSelectorCard> createState() => _ThemeSelectorCardState();
}

class _ThemeSelectorCardState extends State<ThemeSelectorCard> {
  // ============================================================
  // MODE SÉLECTIONNÉ
  //
  // 0 = Système
  // 1 = Sombre
  // 2 = Clair
  // ============================================================

  int _selectedModeIndex = 0;

  // ============================================================
  // MARGE VERTICALE EXTÉRIEURE
  //
  // Très faible afin que les bulles occupent presque toute
  // la hauteur disponible.
  // ============================================================

  double _getVerticalPadding() {
    return 1.5;
  }

  // ============================================================
  // TAILLE DES BULLES
  // ============================================================

  double _getBubbleSize() {
    // ----------------------------------------------------------
    // Taille imposée par l'utilisateur
    // ----------------------------------------------------------

    if (widget.bubbleSize != null) {
      return widget.bubbleSize!.clamp(24.0, 80.0);
    }

    // ----------------------------------------------------------
    // Calcul automatique
    // ----------------------------------------------------------

    final double verticalPadding = _getVerticalPadding();

    final double availableHeight = widget.height - (verticalPadding * 2);

    // ----------------------------------------------------------
    // Utilisation de 95 % de l'espace disponible
    // ----------------------------------------------------------

    final double calculated = availableHeight * 0.95;

    return calculated.clamp(28.0, 60.0);
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final double bubbleSize = _getBubbleSize();

    final double verticalPadding = _getVerticalPadding();

    return GlassButton(
      width: widget.width,
      height: widget.height,

      shape: widget.shape,
      effects: widget.effects,
      style: widget.style,

      onTap: () {},

      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: widget.horizontalPadding,

          vertical: verticalPadding,
        ),

        child: Row(
          // ======================================================
          // UTILISATION DE TOUTE LA LARGEUR
          // ======================================================
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,

          mainAxisSize: MainAxisSize.max,

          children: [
            // ==================================================
            // SYSTÈME
            // ==================================================
            _buildBubble(
              icon: Icons.brightness_auto,
              color: Colors.blueGrey.shade600,
              index: 0,
              size: bubbleSize,
              label: 'Système',
            ),

            // ==================================================
            // SOMBRE
            // ==================================================
            _buildBubble(
              icon: Icons.dark_mode,
              color: Colors.indigo.shade900,
              index: 1,
              size: bubbleSize,
              label: 'Sombre',
            ),

            // ==================================================
            // CLAIR
            // ==================================================
            _buildBubble(
              icon: Icons.light_mode,
              color: Colors.orange.shade600,
              index: 2,
              size: bubbleSize,
              label: 'Clair',
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // BULLE
  // ============================================================

  Widget _buildBubble({
    required IconData icon,
    required Color color,
    required int index,
    required double size,
    required String label,
  }) {
    return IconGlassBubble(
      icon: icon,

      baseColor: color,

      size: size,

      isActive: _selectedModeIndex == index,

      onTap: () {
        setState(() {
          _selectedModeIndex = index;
        });

        debugPrint('Mode $label appliqué');
      },
    );
  }
}
