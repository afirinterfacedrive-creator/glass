import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:universal_glass/components/inputs/glass_search_auto_complete_internal.dart';

class GlassSearchAutoCompleteTextField<T> extends ConsumerWidget {
  final double fieldHeight;
  final double width;
  final String label; // <-- NOUVEAU : Déclaration du label public
  final String hintText;
  final List<T> suggestions;
  final String Function(T item) stringExtractor;
  final void Function(T selectedItem)? onSelected;
  final Widget Function(BuildContext context, T item, bool isHovered)? itemBuilder;
  final TextEditingController? controller;
  
  final Color? overlayIconColor;
  final Color? overlayHighlightColor;

  const GlassSearchAutoCompleteTextField({
    super.key,
    this.fieldHeight = 56.0,
    this.width = double.infinity,
    this.label = 'Recherche', // <-- NOUVEAU : Valeur par défaut
    this.hintText = 'Rechercher...',
    required this.suggestions,
    required this.stringExtractor,
    this.onSelected,
    this.itemBuilder,
    this.controller,
    this.overlayIconColor,
    this.overlayHighlightColor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GlassSearchAutoCompleteInternal<T>(
      fieldHeight: fieldHeight,
      width: width,
      label: label, // <-- TRANSMISSION : Ajout ici pour le donner à l'internal
      hintText: hintText,
      suggestions: suggestions,
      stringExtractor: stringExtractor,
      onSelected: onSelected,
      itemBuilder: itemBuilder,
      controller: controller,
      overlayIconColor: overlayIconColor, 
      overlayHighlightColor: overlayHighlightColor, 
      ref: ref,
    );
  }
}
