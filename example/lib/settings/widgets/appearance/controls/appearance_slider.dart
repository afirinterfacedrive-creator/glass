import 'package:flutter/material.dart';

class AppearanceSlider extends StatelessWidget {
  final String label;
  final double value;
  final double min;
  final double max;

  /// Nombre de divisions du slider.
  ///
  /// Exemple :
  /// 10 divisions entre 0 et 1 donnent des pas de 0.1.
  final int? divisions;

  final ValueChanged<double> onChanged;

  /// Permet de désactiver le slider sans modifier sa valeur.
  final bool enabled;

  /// Texte affiché après la valeur.
  ///
  /// Exemple :
  /// "12.0 px"
  /// "35 %"
  final String? suffix;

  /// Nombre de décimales affichées.
  final int decimalPlaces;

  /// Affiche ou non la valeur à droite.
  final bool showValue;

  /// Taille verticale du slider.
  final double? height;

  const AppearanceSlider({
    super.key,
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
    this.divisions,
    this.enabled = true,
    this.suffix,
    this.decimalPlaces = 2,
    this.showValue = true,
    this.height,
  });

  double get _safeValue {
    return value.clamp(min, max).toDouble();
  }

  String get _formattedValue {
    final String formatted =
        _safeValue.toStringAsFixed(decimalPlaces);

    if (suffix == null || suffix!.isEmpty) {
      return formatted;
    }

    return '$formatted$suffix';
  }

  @override
  Widget build(BuildContext context) {
    final Color textColor =
        Theme.of(context).colorScheme.onSurface;

    final Color secondaryColor =
        textColor.withValues(alpha: 0.65);

    return Opacity(
      opacity: enabled ? 1.0 : 0.45,
      child: SizedBox(
        height: height,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      color: secondaryColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                if (showValue)
                  Text(
                    _formattedValue,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),

            Slider(
              value: _safeValue,
              min: min,
              max: max,
              divisions: divisions,
              onChanged:
                  enabled ? onChanged : null,
            ),
          ],
        ),
      ),
    );
  }
}