import 'package:flutter/material.dart';

import 'package:universal_glass/theme/glass_color_palette.dart';
import 'package:universal_glass/core/layout/glass_layout_context.dart';


/// ============================================================================
/// GLASS SUGGESTIONS OVERLAY
/// ============================================================================
///
/// Overlay des suggestions utilisé par GlassSearchAutoComplete.
///
/// Principes :
/// - alignement avec le thème Glass ;
/// - couleurs issues de GlassColorPalette ;
/// - lisibilité prioritaire ;
/// - hover uniforme ;
/// - possibilité de fournir un itemBuilder personnalisé ;
/// - mise en évidence de la recherche ;
/// - aucun état métier.
/// ============================================================================
class GlassSuggestionsOverlay<T> extends StatelessWidget {
  final LayerLink layerLink;

  final double? width;

  final List<T> filteredResults;

  final String Function(T item) stringExtractor;

  final void Function(T item) onSelected;

  final Widget Function(BuildContext context, T item, bool isHovered)?
  itemBuilder;

  final GlassLayoutContext glass;

  final String currentQuery;

  final Color? iconColor;
  final Color? highlightColor;

  const GlassSuggestionsOverlay({
    super.key,
    required this.layerLink,
    required this.width,
    required this.filteredResults,
    required this.stringExtractor,
    required this.onSelected,
    required this.itemBuilder,
    required this.glass,
    required this.currentQuery,
    this.iconColor,
    this.highlightColor,
  });

  // ==========================================================================
  // BUILD
  // ==========================================================================

  @override
  Widget build(BuildContext context) {
    final double calculatedWidth = _resolveWidth();

    final bool useAqua = glass.theme.useAquaStyle;

    final GlassColorPalette palette = glass.palette;

    final Color backgroundColor = palette.darkForStyle(useAqua);

    final Color borderColor = palette.border.withValues(alpha: 0.25);

    final Color dividerColor = palette.border.withValues(alpha: 0.15);

    return CompositedTransformFollower(
      link: layerLink,
      showWhenUnlinked: false,
      targetAnchor: Alignment.bottomLeft,
      followerAnchor: Alignment.topLeft,
      offset: const Offset(0.0, 6.0),

      child: Align(
        alignment: Alignment.topLeft,

        child: SizedBox(
          width: calculatedWidth,

          child: Material(
            type: MaterialType.card,

            elevation: 12.0,

            color: backgroundColor.withValues(alpha: 0.98),

            borderRadius: BorderRadius.circular(14.0),

            shadowColor: Colors.black.withValues(alpha: 0.50),

            clipBehavior: Clip.antiAlias,

            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 6.0),

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14.0),

                border: Border.all(color: borderColor, width: 0.8),
              ),

              child: ListView.separated(
                padding: EdgeInsets.zero,

                shrinkWrap: true,

                physics: const NeverScrollableScrollPhysics(),

                itemCount: filteredResults.length,

                separatorBuilder: (BuildContext context, int index) {
                  return Divider(
                    height: 1.0,
                    thickness: 1.0,
                    color: dividerColor,
                  );
                },

                itemBuilder: (BuildContext context, int index) {
                  final T item = filteredResults[index];

                  final String label = stringExtractor(item);

                  return _SuggestionRow<T>(
                    item: item,
                    label: label,
                    currentQuery: currentQuery,
                    glass: glass,
                    itemBuilder: itemBuilder,
                    iconColor: iconColor,
                    highlightColor: highlightColor,
                    onSelected: onSelected,
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================================================
  // WIDTH
  // ==========================================================================

  double _resolveWidth() {
    if (width == null || width == double.infinity) {
      return layerLink.leaderSize?.width ?? 300.0;
    }

    return width!;
  }
}

// ============================================================================
// SUGGESTION ROW
// ============================================================================
//
// Chaque ligne possède son propre état de hover.
// Cela évite le StatefulBuilder directement dans le ListView et rend le
// comportement plus propre et plus facile à maintenir.
// ============================================================================

class _SuggestionRow<T> extends StatefulWidget {
  final T item;

  final String label;

  final String currentQuery;

  final GlassLayoutContext glass;

  final Widget Function(BuildContext context, T item, bool isHovered)?
  itemBuilder;

  final Color? iconColor;
  final Color? highlightColor;

  final void Function(T item) onSelected;

  const _SuggestionRow({
    required this.item,
    required this.label,
    required this.currentQuery,
    required this.glass,
    required this.itemBuilder,
    required this.iconColor,
    required this.highlightColor,
    required this.onSelected,
  });

  @override
  State<_SuggestionRow<T>> createState() => _SuggestionRowState<T>();
}

class _SuggestionRowState<T> extends State<_SuggestionRow<T>> {
  bool _isHovered = false;

  // ==========================================================================
  // BUILD
  // ==========================================================================

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,

      onEnter: (_) {
        if (!_isHovered) {
          setState(() {
            _isHovered = true;
          });
        }
      },

      onExit: (_) {
        if (_isHovered) {
          setState(() {
            _isHovered = false;
          });
        }
      },

      child: Material(
        type: MaterialType.transparency,

        child: InkWell(
          onTap: () {
            widget.onSelected(widget.item);
          },

          borderRadius: BorderRadius.circular(8.0),

          child: AnimatedContainer(
            duration: const Duration(milliseconds: 120),

            curve: Curves.easeOut,

            decoration: BoxDecoration(
              color: _isHovered ? _hoverBackgroundColor : Colors.transparent,

              borderRadius: BorderRadius.circular(8.0),
            ),

            child: _buildContent(context),
          ),
        ),
      ),
    );
  }

  // ==========================================================================
  // CONTENT
  // ==========================================================================

  Widget _buildContent(BuildContext context) {
    final Widget Function(BuildContext, T, bool)? customBuilder =
        widget.itemBuilder;

    if (customBuilder != null) {
      return customBuilder(context, widget.item, _isHovered);
    }

    return _buildDefaultContent();
  }

  // ==========================================================================
  // DEFAULT CONTENT
  // ==========================================================================

  Widget _buildDefaultContent() {
    final Color activeColor =
        widget.highlightColor ?? widget.glass.palette.accent;

    final Color normalColor = widget.glass.palette.textPrimary;

    final Color effectiveIconColor =
        widget.iconColor ??
        (_isHovered ? activeColor : normalColor.withValues(alpha: 0.50));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),

      child: Row(
        children: [
          // ==================================================================
          // HISTORY ICON
          // ==================================================================
          Icon(Icons.history_rounded, size: 18.0, color: effectiveIconColor),

          const SizedBox(width: 12.0),

          // ==================================================================
          // TEXT
          // ==================================================================
          Expanded(
            child: RichText(
              maxLines: 1,
              overflow: TextOverflow.ellipsis,

              text: _getHighlightedTextSpan(
                text: widget.label,
                query: widget.currentQuery,
                activeColor: activeColor,
                normalColor: _isHovered ? activeColor : normalColor,
                isHovered: _isHovered,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // HOVER BACKGROUND
  // ==========================================================================

  Color get _hoverBackgroundColor {
    final Color accent = widget.glass.palette.accent;

    return accent.withValues(alpha: 0.10);
  }

  // ==========================================================================
  // HIGHLIGHT
  // ==========================================================================

  TextSpan _getHighlightedTextSpan({
    required String text,
    required String query,
    required Color activeColor,
    required Color normalColor,
    required bool isHovered,
  }) {
    final String cleanQuery = query.trim();

    // ------------------------------------------------------------------------
    // Aucun texte recherché
    // ------------------------------------------------------------------------

    if (cleanQuery.isEmpty) {
      return TextSpan(
        text: text,

        style: TextStyle(
          color: normalColor,
          fontWeight: isHovered ? FontWeight.w600 : FontWeight.w400,
        ),
      );
    }

    // ------------------------------------------------------------------------
    // Recherche
    // ------------------------------------------------------------------------

    final List<TextSpan> spans = <TextSpan>[];

    final RegExp regex = RegExp(
      RegExp.escape(cleanQuery),
      caseSensitive: false,
    );

    int start = 0;

    for (final RegExpMatch match in regex.allMatches(text)) {
      // Texte avant la correspondance.
      if (match.start > start) {
        spans.add(
          TextSpan(
            text: text.substring(start, match.start),

            style: TextStyle(
              color: normalColor,
              fontWeight: isHovered ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        );
      }

      // Correspondance.
      spans.add(
        TextSpan(
          text: text.substring(match.start, match.end),

          style: TextStyle(
            color: activeColor,
            fontWeight: FontWeight.w700,
            decoration: TextDecoration.underline,
            decorationColor: activeColor.withValues(alpha: 0.50),
          ),
        ),
      );

      start = match.end;
    }

    // ------------------------------------------------------------------------
    // Texte restant.
    // ------------------------------------------------------------------------

    if (start < text.length) {
      spans.add(
        TextSpan(
          text: text.substring(start),

          style: TextStyle(
            color: normalColor,
            fontWeight: isHovered ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      );
    }

    return TextSpan(children: spans);
  }
}
