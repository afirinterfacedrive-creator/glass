
import 'package:flutter/material.dart';

import 'package:universal_glass/glass.dart';

/// ============================================================================
/// APPEARANCE COLOR PICKER
/// ============================================================================
///
/// Widget utilisé par AppearanceSection pour gérer les couleurs personnalisées.
///
/// Responsabilités :
///
/// - afficher la liste des couleurs ;
/// - notifier lorsqu'une couleur est sélectionnée ;
/// - afficher le ColorPicker dans une boîte de dialogue.
///
/// Ce widget :
///
/// - ne connaît pas Riverpod ;
/// - ne sauvegarde rien ;
/// - ne modifie pas directement AppearanceSettings ;
/// - ne connaît pas AppearanceController.
///
/// Flux :
///
/// AppearanceSection
///       ↓
/// AppearanceColorPicker
///       ↓
/// ColorPicker
///       ↓
/// Color?
///       ↓
/// AppearanceController
///
/// ============================================================================

class AppearanceColorPicker extends StatelessWidget {
  // ==========================================================================
  // PROPRIÉTÉS
  // ==========================================================================

  /// Liste des couleurs actuellement utilisées.
  final List<Color> colors;

  /// Callback appelé lorsqu'une couleur de la liste est sélectionnée.
  final ValueChanged<int> onTap;

  // ==========================================================================
  // CONSTRUCTEUR
  // ==========================================================================

  const AppearanceColorPicker({
    super.key,
    required this.colors,
    required this.onTap,
  });

  // ==========================================================================
  // BUILD
  // ==========================================================================

  @override
  Widget build(BuildContext context) {
    return GlassColorListPicker(
      colors: colors,
      onTap: onTap,
    );
  }

  // ==========================================================================
  // COLOR DIALOG
  // ==========================================================================

  /// Affiche le sélecteur de couleur.
  ///
  /// Retourne :
  ///
  /// - la nouvelle couleur si l'utilisateur valide ;
  /// - `null` si l'utilisateur annule ou ferme le dialogue.
  ///
  static Future<Color?> show(
    BuildContext context, {
    required Color initialColor,
  }) async {
    Color pickerColor = initialColor;

    return showDialog<Color>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          title: const Text(
            'Choisir une couleur',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: pickerColor,
              onColorChanged: (color) {
                pickerColor = color;
              },
              enableAlpha: true,
            ),
          ),
          actions: [
            // ----------------------------------------------------------------
            // ANNULER
            // ----------------------------------------------------------------

            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Annuler'),
            ),

            // ----------------------------------------------------------------
            // VALIDER
            // ----------------------------------------------------------------

            FilledButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(
                  pickerColor,
                );
              },
              child: const Text('Valider'),
            ),
          ],
        );
      },
    );
  }
}

