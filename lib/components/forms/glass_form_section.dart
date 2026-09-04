
import 'package:flutter/material.dart';

import '../inputs/glass_input_decoration.dart';

/// ============================================================================
/// GLASS FORM SECTION
///
/// Section visuelle réutilisable pour les formulaires Glass.
///
/// Gère :
///
/// • titre
/// • sous-titre
/// • icône / bulle facultative
/// • contenu libre
/// • espacement
/// • alignement
/// • padding
///
/// IMPORTANT
///
/// Ce composant ne contient aucune logique de validation.
/// La validation reste entièrement gérée par les champs et GlassForm.
/// ============================================================================

class GlassFormSection extends StatelessWidget {
  // ==========================================================================
  // TITRE
  // ==========================================================================

  final String? title;

  final String? subtitle;

  // ==========================================================================
  // ICÔNE
  // ==========================================================================

  /// Widget libre affiché à gauche du titre.
  ///
  /// Peut être une icône classique, une GlassInputIconBubble,
  /// ou n'importe quel autre widget.
  final Widget? leading;

  // ==========================================================================
  // CONTENU
  // ==========================================================================

  final List<Widget> children;

  // ==========================================================================
  // ESPACEMENT
  // ==========================================================================

  final double spacing;

  final double titleSpacing;

  final double subtitleSpacing;

  // ==========================================================================
  // ALIGNEMENT
  // ==========================================================================

  final CrossAxisAlignment crossAxisAlignment;

  // ==========================================================================
  // PADDING
  // ==========================================================================

  final EdgeInsetsGeometry padding;

  // ==========================================================================
  // STYLE TEXTE
  // ==========================================================================

  final TextStyle? titleStyle;

  final TextStyle? subtitleStyle;

  // ==========================================================================
  // DECORATION OPTIONNELLE
  // ==========================================================================

  /// Permet d'utiliser les couleurs de GlassInputDecoration
  /// pour garder une cohérence visuelle avec les inputs.
  final GlassInputDecoration? decoration;

  // ==========================================================================
  // CONSTRUCTEUR
  // ==========================================================================

  const GlassFormSection({
    super.key,

    this.title,

    this.subtitle,

    this.leading,

    this.children = const <Widget>[],

    this.spacing = 12.0,

    this.titleSpacing = 8.0,

    this.subtitleSpacing = 4.0,

    this.crossAxisAlignment =
        CrossAxisAlignment.stretch,

    this.padding =
        EdgeInsets.zero,

    this.titleStyle,

    this.subtitleStyle,

    this.decoration,
  });

  // ==========================================================================
  // DEFAULT TITLE STYLE
  // ==========================================================================

  TextStyle _defaultTitleStyle(
    BuildContext context,
  ) {
    final GlassInputDecoration? glass =
        decoration;

    return titleStyle ??
        TextStyle(
          color:
              glass?.effectiveTextColor ??
              Theme.of(context)
                  .colorScheme
                  .onSurface,

          fontSize:
              (glass?.fontSize ?? 15.0) + 1.0,

          fontWeight:
              FontWeight.w700,

          letterSpacing:
              glass?.letterSpacing ?? 0.0,
        );
  }

  // ==========================================================================
  // DEFAULT SUBTITLE STYLE
  // ==========================================================================

  TextStyle _defaultSubtitleStyle(
    BuildContext context,
  ) {
    final GlassInputDecoration? glass =
        decoration;

    return subtitleStyle ??
        TextStyle(
          color:
              glass?.effectiveHintColor ??
              Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(
                    alpha: 0.65,
                  ),

          fontSize:
              (glass?.fontSize ?? 14.0) - 1.0,

          fontWeight:
              FontWeight.w400,

          letterSpacing:
              glass?.letterSpacing ?? 0.0,
        );
  }

  // ==========================================================================
  // HEADER
  // ==========================================================================

  Widget _buildHeader(
    BuildContext context,
  ) {
    final bool hasTitle =
        title != null &&
        title!.trim().isNotEmpty;

    final bool hasSubtitle =
        subtitle != null &&
        subtitle!.trim().isNotEmpty;

    if (!hasTitle &&
        !hasSubtitle &&
        leading == null) {
      return const SizedBox.shrink();
    }

    final Widget textContent =
        Column(
      mainAxisSize:
          MainAxisSize.min,

      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [
        if (hasTitle)
          Text(
            title!,
            style:
                _defaultTitleStyle(
              context,
            ),
          ),

        if (hasTitle &&
            hasSubtitle)
          SizedBox(
            height:
                subtitleSpacing,
          ),

        if (hasSubtitle)
          Text(
            subtitle!,
            style:
                _defaultSubtitleStyle(
              context,
            ),
          ),
      ],
    );

    if (leading == null) {
      return textContent;
    }

    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.center,

      children: [
        leading!,

        const SizedBox(
          width: 10,
        ),

        Expanded(
          child:
              textContent,
        ),
      ],
    );
  }

  // ==========================================================================
  // CONTENT
  // ==========================================================================

  Widget _buildContent() {
    if (children.isEmpty) {
      return const SizedBox.shrink();
    }

    final List<Widget> content =
        <Widget>[];

    for (int i = 0;
        i < children.length;
        i++) {
      content.add(
        children[i],
      );

      if (i <
          children.length - 1) {
        content.add(
          SizedBox(
            height:
                spacing,
          ),
        );
      }
    }

    return Column(
      mainAxisSize:
          MainAxisSize.min,

      crossAxisAlignment:
          crossAxisAlignment,

      children:
          content,
    );
  }

  // ==========================================================================
  // BUILD
  // ==========================================================================

  @override
  Widget build(
    BuildContext context,
  ) {
    final bool hasHeader =
        (title != null &&
            title!.trim().isNotEmpty) ||
        (subtitle != null &&
            subtitle!.trim().isNotEmpty) ||
        leading != null;

    Widget content =
        Column(
      mainAxisSize:
          MainAxisSize.min,

      crossAxisAlignment:
          crossAxisAlignment,

      children: [
        if (hasHeader)
          _buildHeader(
            context,
          ),

        if (hasHeader &&
            children.isNotEmpty)
          SizedBox(
            height:
                titleSpacing,
          ),

        _buildContent(),
      ],
    );

    return Padding(
      padding:
          padding,

      child:
          content,
    );
  }
}

