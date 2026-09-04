import 'package:flutter/material.dart';


class GlassSuggestionsOverlay<T> extends StatelessWidget {
  final LayerLink layerLink;
  final double? width;
  final List<T> filteredResults;
  final String Function(T item) stringExtractor;
  final void Function(T item) onSelected;
  final Widget Function(BuildContext context, T item, bool isHovered)? itemBuilder;
  final dynamic glass; 
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

  @override
  Widget build(BuildContext context) {
    final double calculatedWidth = (width == null || width == double.infinity)
        ? (layerLink.leaderSize?.width ?? 300.0)
        : width!;

    final bool useAqua = glass.theme.useAquaStyle;
    final Color darkBackgroundColor = glass.palette.darkForStyle(useAqua);
    final Color borderColor = glass.palette.border.withValues(alpha: 0.25);

    return CompositedTransformFollower(
      link: layerLink,
      showWhenUnlinked: false,
      targetAnchor: Alignment.bottomLeft,
      followerAnchor: Alignment.topLeft,
      offset: const Offset(0, 6),
      child: Align(
        alignment: Alignment.topLeft,
        child: SizedBox(
          width: calculatedWidth,
          child: Material(
            // FIX MAXIMUM : Éléments indispensables pour forcer le Z-Index absolu au-dessus des boutons
            type: MaterialType.card,
            elevation: 12.0, 
            color: darkBackgroundColor.withValues(alpha: 0.98), 
            borderRadius: BorderRadius.circular(14),
            shadowColor: Colors.black.withValues(alpha: 0.5),
            clipBehavior: Clip.antiAlias, // Le clip est confiné ici uniquement pour l'arrondi de la liste
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: borderColor, width: 0.8),
              ),
              child: ListView.separated(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredResults.length,
                separatorBuilder: (context, index) => Divider(
                  height: 1,
                  color: glass.palette.border.withValues(alpha: 0.15),
                ),
                itemBuilder: (context, index) {
                  final item = filteredResults[index];
                  final label = stringExtractor(item);

                  return StatefulBuilder(
                    builder: (context, setItemState) {
                      bool isRowHovered = false;

                      return MouseRegion(
                        onEnter: (_) => setItemState(() => isRowHovered = true),
                        onExit: (_) => setItemState(() => isRowHovered = false),
                        child: InkWell(
                          onTap: () => onSelected(item),
                          child: _buildRowContent(context, item, label, isRowHovered),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRowContent(BuildContext context, T item, String label, bool isHovered) {
    final customBuilder = itemBuilder;
    if (customBuilder != null) {
      return customBuilder(context, item, isHovered);
    }

    final Color activeColor = highlightColor ?? glass.palette.accent;
    final Color normalColor = glass.palette.textPrimary;
    final Color effectiveIconColor = iconColor ?? (isHovered ? activeColor : normalColor.withValues(alpha: 0.5));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Icon(
            Icons.history_rounded, 
            size: 18,
            color: effectiveIconColor, 
          ),
          const SizedBox(width: 12),
          Expanded(
            child: RichText(
              text: _getHighlightedTextSpan(
                text: label,
                query: currentQuery,
                activeColor: activeColor, 
                normalColor: isHovered ? activeColor : normalColor,
                isHovered: isHovered,
              ),
            ),
          ),
        ],
      ),
    );
  }

  TextSpan _getHighlightedTextSpan({
    required String text,
    required String query,
    required Color activeColor,
    required Color normalColor,
    required bool isHovered,
  }) {
    if (query.trim().isEmpty) {
      return TextSpan(
        text: text, 
        style: TextStyle(color: normalColor, fontWeight: isHovered ? FontWeight.w600 : FontWeight.w400)
      );
    }

    final List<TextSpan> spans = [];
    final String cleanQuery = RegExp.escape(query.trim());
    final RegExp regex = RegExp(cleanQuery, caseSensitive: false);
    
    int start = 0;
    
    for (final RegExpMatch match in regex.allMatches(text)) {
      if (match.start > start) {
        spans.add(TextSpan(
          text: text.substring(start, match.start),
          style: TextStyle(color: normalColor, fontWeight: isHovered ? FontWeight.w600 : FontWeight.w400),
        ));
      }
      
      spans.add(TextSpan(
        text: text.substring(match.start, match.end),
        style: TextStyle(
          color: activeColor,
          fontWeight: FontWeight.w700, 
          decoration: TextDecoration.underline, 
          decorationColor: activeColor.withValues(alpha: 0.5),
        ),
      ));
      
      start = match.end;
    }

    if (start < text.length) {
      spans.add(TextSpan(
        text: text.substring(start),
        style: TextStyle(color: normalColor, fontWeight: isHovered ? FontWeight.w600 : FontWeight.w400),
      ));
    }

    return TextSpan(children: spans);
  }
}
