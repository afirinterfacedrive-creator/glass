import 'package:flutter/material.dart';

import '../enums/glass_enums.dart';
import '../theme/glass_effects.dart';

import 'glass_button.dart';

import 'glass_icon.dart';

class ThemeSelectorGlassCard extends StatefulWidget {
  final GlassEffects effects;
  final GlassShapeType shape;
  final GlassStyle style;

  final double width;
  final double height;

  /// Pourcentage de la hauteur du bouton utilisé pour calculer
  /// la taille réelle de chaque GlassIcon.
  final double iconSizePercent;

  final double horizontalPadding;
  final double spacing;

  const ThemeSelectorGlassCard({
    super.key,
    required this.effects,
    required this.shape,
    required this.style,
    this.width = 210,
    this.height = 75,
    this.iconSizePercent = 60,
    this.horizontalPadding = 2,
    this.spacing = 3,
  }) : assert(
         iconSizePercent >= 0 && iconSizePercent <= 100,
         'iconSizePercent doit être compris entre 0 et 100.',
       );

  @override
  State<ThemeSelectorGlassCard> createState() => _ThemeSelectorGlassCardState();
}

class _ThemeSelectorGlassCardState extends State<ThemeSelectorGlassCard> {
  int _selectedModeIndex = 0;

  double get _realIconSize {
    return widget.height * widget.iconSizePercent / 100.0;
  }

  @override
  Widget build(BuildContext context) {
    return GlassButton(
      width: widget.width,
      height: widget.height,
      shape: widget.shape,
      effects: widget.effects,
      style: widget.style,
      onTap: () {},
      // ========================================================
      // On supprime le Padding pour laisser Stack gérer
      // ========================================================
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: widget.horizontalPadding),
        child: Stack(
          alignment: Alignment.center, // <-- FORCE LE CENTRE VERTICAL
          fit: StackFit.expand,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment:
                  CrossAxisAlignment.center, // <-- CENTRE LA ROW
              children: [
                _buildIcon(
                  icon: Icons.brightness_auto,
                  color: Colors.blueGrey.shade600,
                  index: 0,
                  label: 'Système',
                ),
                SizedBox(width: widget.spacing),
                _buildIcon(
                  icon: Icons.dark_mode,
                  color: Colors.indigo.shade900,
                  index: 1,
                  label: 'Sombre',
                ),
                SizedBox(width: widget.spacing),
                _buildIcon(
                  icon: Icons.light_mode,
                  color: Colors.orange.shade600,
                  index: 2,
                  label: 'Clair',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon({
    required IconData icon,
    required Color color,
    required int index,
    required String label,
  }) {
    return Expanded(
      child: Center(
        // <-- TRIPLE SÉCURITÉ: Centre dans l'Expanded
        child: SizedBox(
          width: _realIconSize,
          height: _realIconSize,
          child: Center(
            // <-- QUADRUPLE SÉCURITÉ: Centre dans le SizedBox
            child: GlassIcon(
              icon: icon,
              baseColor: color,
              size: _realIconSize,
              isActive: _selectedModeIndex == index,
              onTap: () {
                if (!mounted) return;
                setState(() {
                  _selectedModeIndex = index;
                });
                debugPrint('Mode $label appliqué');
              },
            ),
          ),
        ),
      ),
    );
  }
}
