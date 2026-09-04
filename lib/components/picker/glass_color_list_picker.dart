
import 'package:flutter/material.dart';

/// ============================================================================
/// GLASS COLOR LIST PICKER
/// ============================================================================
///
/// Sélecteur de couleurs sous forme de liste de pastilles.
///
/// Le widget ne connaît pas la logique de l'écran qui l'utilise.
/// Il retourne simplement l'index de la couleur sélectionnée via [onTap].
///
/// Exemple :
///
/// GlassColorListPicker(
///   colors: [
///     Colors.red,
///     Colors.blue,
///     Colors.green,
///   ],
///   onTap: (index) {
///     // Couleur sélectionnée.
///   },
/// );
///
class GlassColorListPicker extends StatelessWidget {
  /// Liste des couleurs disponibles.
  final List<Color> colors;

  /// Callback appelé avec l'index de la couleur sélectionnée.
  final ValueChanged<int> onTap;

  /// Taille d'une pastille.
  final double size;

  /// Espacement horizontal entre les pastilles.
  final double spacing;

  /// Espacement vertical entre les lignes.
  final double runSpacing;

  /// Rayon des coins.
  final double borderRadius;

  /// Couleur de la bordure.
  final Color borderColor;

  /// Épaisseur de la bordure.
  final double borderWidth;

  /// Icône affichée au centre.
  final IconData icon;

  /// Taille de l'icône.
  final double iconSize;

  /// Couleur de l'icône.
  final Color iconColor;

  const GlassColorListPicker({
    super.key,
    required this.colors,
    required this.onTap,
    this.size = 44,
    this.spacing = 10,
    this.runSpacing = 10,
    this.borderRadius = 10,
    this.borderColor = Colors.white24,
    this.borderWidth = 1.5,
    this.icon = Icons.color_lens,
    this.iconSize = 18,
    this.iconColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: spacing,
      runSpacing: runSpacing,
      children: List.generate(
        colors.length,
        (index) {
          return GestureDetector(
            onTap: () => onTap(index),
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: colors[index],
                borderRadius: BorderRadius.circular(borderRadius),
                border: Border.all(
                  color: borderColor,
                  width: borderWidth,
                ),
              ),
              child: Icon(
                icon,
                size: iconSize,
                color: iconColor,
              ),
            ),
          );
        },
      ),
    );
  }
}

