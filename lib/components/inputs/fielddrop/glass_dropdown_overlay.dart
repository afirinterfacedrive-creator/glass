import 'package:flutter/material.dart';


class GlassDropdownOverlay<T> extends StatelessWidget {
  final LayerLink layerLink;
  final double? width;
  final List<T> items;
  final String Function(T item) itemLabelExtractor;
  final void Function(T item) onSelected;
  final dynamic glass;

  const GlassDropdownOverlay({
    super.key,
    required this.layerLink,
    required this.width,
    required this.items,
    required this.itemLabelExtractor,
    required this.onSelected,
    required this.glass,
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
            type: MaterialType.card,
            elevation: 12.0,
            color: darkBackgroundColor.withValues(alpha: 0.98),
            borderRadius: BorderRadius.circular(14),
            shadowColor: Colors.black.withValues(alpha: 0.5),
            clipBehavior: Clip.antiAlias,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: borderColor, width: 0.8),
              ),
              child: ListView.separated(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemCount: items.length,
                separatorBuilder: (context, index) => Divider(
                  height: 1,
                  color: glass.palette.border.withValues(alpha: 0.15),
                ),
                itemBuilder: (context, index) {
                  final item = items[index];
                  final label = itemLabelExtractor(item);

                  return StatefulBuilder(
                    builder: (context, setItemState) {
                      bool isRowHovered = false;

                      return MouseRegion(
                        onEnter: (_) => setItemState(() => isRowHovered = true),
                        onExit: (_) => setItemState(() => isRowHovered = false),
                        child: InkWell(
                          onTap: () => onSelected(item),
                          // FIX : Extraction de la méthode pour tuer le dead code
                          child: _buildItemTile(label, isRowHovered),
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

  /// Extrait l'arbre de rendu pour isoler les expressions ternaires face à l'analyseur
  Widget _buildItemTile(String label, bool isHovered) {
    final Color activeColor = glass.palette.accent;
    final Color normalColor = glass.palette.textPrimary;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Text(
        label,
        style: TextStyle(
          color: isHovered ? activeColor : normalColor,
          fontWeight: isHovered ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
    );
  }
}
