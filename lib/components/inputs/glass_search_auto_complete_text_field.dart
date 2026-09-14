import 'package:flutter/material.dart';

import 'package:universal_glass/components/inputs/glass_search_auto_complete_internal.dart';

/// ============================================================================
/// GLASS SEARCH AUTO COMPLETE TEXT FIELD
/// ============================================================================
///
/// API publique du champ de recherche avec autocomplétion.
///
/// Responsabilités :
/// - exposer une API simple et stable ;
/// - fournir les valeurs par défaut ;
/// - transmettre les paramètres à l'implémentation interne.
///
/// Le rendu et la logique d'état sont gérés par :
///
///     GlassSearchAutoCompleteInternal
///
/// Le contexte Glass est récupéré directement par l'implémentation interne
/// via GlassLayoutScope.
/// ============================================================================
class GlassSearchAutoCompleteTextField<T>
    extends StatelessWidget {
  // ==========================================================================
  // DIMENSIONS
  // ==========================================================================

  /// Hauteur du champ.
  final double fieldHeight;

  /// Largeur du champ.
  ///
  /// `double.infinity` utilise toute la largeur disponible.
  final double width;

  // ==========================================================================
  // TEXTES
  // ==========================================================================

  /// Label flottant du champ.
  final String label;

  /// Texte d'aide affiché lorsque le label est flottant.
  final String hintText;

  // ==========================================================================
  // AUTOCOMPLÉTION
  // ==========================================================================

  /// Liste complète des éléments pouvant être proposés.
  final List<T> suggestions;

  /// Transforme un élément en texte searchable/affichable.
  final String Function(T item) stringExtractor;

  /// Callback appelé lorsqu'un élément est sélectionné.
  final void Function(T selectedItem)? onSelected;

  /// Permet de personnaliser entièrement le rendu d'une suggestion.
  final Widget Function(
    BuildContext context,
    T item,
    bool isHovered,
  )? itemBuilder;

  // ==========================================================================
  // CONTROLLER
  // ==========================================================================

  /// Controller externe optionnel.
  ///
  /// Si aucun controller n'est fourni, l'implémentation interne en crée un.
  final TextEditingController? controller;

  // ==========================================================================
  // OVERLAY
  // ==========================================================================

  /// Couleur de l'icône dans l'overlay.
  final Color? overlayIconColor;

  /// Couleur utilisée pour la sélection et la mise en évidence
  /// des correspondances dans l'overlay.
  final Color? overlayHighlightColor;

  // ==========================================================================
  // CONSTRUCTOR
  // ==========================================================================

  const GlassSearchAutoCompleteTextField({
    super.key,
    this.fieldHeight = 56.0,
    this.width = double.infinity,
    this.label = 'Recherche',
    this.hintText = 'Rechercher...',
    required this.suggestions,
    required this.stringExtractor,
    this.onSelected,
    this.itemBuilder,
    this.controller,
    this.overlayIconColor,
    this.overlayHighlightColor,
  });

  // ==========================================================================
  // BUILD
  // ==========================================================================

  @override
  Widget build(BuildContext context) {
    return GlassSearchAutoCompleteInternal<T>(
      fieldHeight: fieldHeight,
      width: width,
      label: label,
      hintText: hintText,
      suggestions: suggestions,
      stringExtractor: stringExtractor,
      onSelected: onSelected,
      itemBuilder: itemBuilder,
      controller: controller,
      overlayIconColor: overlayIconColor,
      overlayHighlightColor: overlayHighlightColor,
    );
  }
}