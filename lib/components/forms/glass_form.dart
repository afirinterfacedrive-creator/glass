import 'package:flutter/material.dart';

/// ============================================================================
/// GLASS FORM
/// ============================================================================
///
/// Formulaire Glass générique.
///
/// Il s'appuie sur le [Form] Flutter tout en fournissant une structure
/// adaptée aux composants Universal Glass.
///
/// Exemple :
///
/// ```dart
/// GlassForm(
///   formKey: formKey,
///   children: [
///     GlassFormSection(
///       title: 'Informations',
///       children: [...],
///     ),
///   ],
/// )
/// ```
///
class GlassForm extends StatelessWidget {
  // ==========================================================================
  // PROPRIÉTÉS
  // ==========================================================================

  final GlobalKey<FormState>? formKey;

  final List<Widget> children;

  final EdgeInsetsGeometry padding;

  final double spacing;

  final CrossAxisAlignment crossAxisAlignment;

  final AutovalidateMode? autovalidateMode;

  final VoidCallback? onChanged;

  final bool shrinkWrap;

  // ==========================================================================
  // CONSTRUCTEUR
  // ==========================================================================

  const GlassForm({
    super.key,
    this.formKey,
    required this.children,
    this.padding = EdgeInsets.zero,
    this.spacing = 16,
    this.crossAxisAlignment = CrossAxisAlignment.stretch,
    this.autovalidateMode,
    this.onChanged,
    this.shrinkWrap = true,
  });

  // ==========================================================================
  // BUILD
  // ==========================================================================

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      autovalidateMode: autovalidateMode,
      onChanged: onChanged,
      child: Padding(
        padding: padding,
        child: Column(
          mainAxisSize:
              shrinkWrap
                  ? MainAxisSize.min
                  : MainAxisSize.max,
          crossAxisAlignment: crossAxisAlignment,
          children: _buildChildren(),
        ),
      ),
    );
  }

  // ==========================================================================
  // CHILDREN
  // ==========================================================================

  List<Widget> _buildChildren() {
    final List<Widget> result = [];

    for (int i = 0; i < children.length; i++) {
      if (i > 0) {
        result.add(SizedBox(height: spacing));
      }

      result.add(children[i]);
    }

    return result;
  }
}