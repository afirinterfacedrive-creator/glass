
import 'package:flutter/material.dart';

class GlassDropdownOverlay<T> extends StatefulWidget {
  final LayerLink layerLink;
  final double? width;
  final List<T> items;
  final String Function(T item) itemLabelExtractor;
  final void Function(T item) onSelected;
  final dynamic glass;
  final T? selectedValue;
  final bool enableSearch;

  const GlassDropdownOverlay({
    super.key,
    required this.layerLink,
    required this.width,
    required this.items,
    required this.itemLabelExtractor,
    required this.onSelected,
    required this.glass,
    this.selectedValue,
    this.enableSearch = true,
  });

  @override
  State<GlassDropdownOverlay<T>> createState() =>
      _GlassDropdownOverlayState<T>();
}

class _GlassDropdownOverlayState<T>
    extends State<GlassDropdownOverlay<T>> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<T> _filteredItems = [];

  @override
  void initState() {
    super.initState();

    _filteredItems = widget.items;

    _searchController.addListener(_filterItems);

    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _scrollToSelected(),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _filterItems() {
    final query = _searchController.text.toLowerCase();

    setState(() {
      _filteredItems = widget.items
          .where(
            (item) => widget.itemLabelExtractor(item)
                .toLowerCase()
                .contains(query),
          )
          .toList();
    });

    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _scrollToSelected(),
    );
  }

  void _scrollToSelected() {
    if (widget.selectedValue == null ||
        _filteredItems.isEmpty ||
        !_scrollController.hasClients) {
      return;
    }

    final index = _filteredItems.indexOf(widget.selectedValue as T);

    if (index != -1) {
      final offset = (index * 52.0)
          .clamp(
            0.0,
            _scrollController.position.maxScrollExtent,
          )
          .toDouble();

      _scrollController.jumpTo(offset);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double calculatedWidth =
        (widget.width == null || widget.width == double.infinity)
            ? (widget.layerLink.leaderSize?.width ?? 300.0)
            : widget.width!;

    final bool useAqua = widget.glass.theme.useAquaStyle;

    final Color bgColor =
        widget.glass.palette.darkForStyle(useAqua);

    final Color borderColor =
        widget.glass.palette.border.withValues(alpha: 0.25);

    final Color hoverColor =
        widget.glass.palette.accent.withValues(alpha: 0.12);

    final Color selectedColor =
        widget.glass.palette.accent.withValues(alpha: 0.18);

    return CompositedTransformFollower(
      link: widget.layerLink,
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
            elevation: 16.0,
            color: bgColor.withValues(alpha: 0.98),
            borderRadius: BorderRadius.circular(14),
            shadowColor: Colors.black.withValues(alpha: 0.5),
            clipBehavior: Clip.antiAlias,
            child: Container(
              constraints: const BoxConstraints(
                maxHeight: 320,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: borderColor,
                  width: 0.8,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.enableSearch)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _searchController,
                        autofocus: true,
                        style: TextStyle(
                          color: widget.glass.palette.textPrimary,
                          fontSize: 14,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Recher...',
                          hintStyle: TextStyle(
                            color: widget.glass.palette.textSecondary
                                .withValues(alpha: 0.6),
                          ),
                          prefixIcon: Icon(
                            Icons.search_rounded,
                            size: 18,
                            color: widget.glass.palette.textSecondary,
                          ),
                          filled: true,
                          fillColor: widget.glass.palette.surface
                              .withValues(alpha: 0.3),
                          contentPadding:
                              const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onSubmitted: (_) {
                          if (_filteredItems.isNotEmpty) {
                            widget.onSelected(
                              _filteredItems.first,
                            );
                          }
                        },
                      ),
                    ),
                  Flexible(
                    child: ListView.separated(
                      controller: _scrollController,
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: _filteredItems.length,
                      separatorBuilder: (context, index) =>
                          Divider(
                        height: 1,
                        color: widget.glass.palette.border
                            .withValues(alpha: 0.15),
                      ),
                      itemBuilder: (context, index) {
                        final item = _filteredItems[index];
                        final label =
                            widget.itemLabelExtractor(item);

                        final bool isSelected =
                            widget.selectedValue == item;

                        return _GlassDropdownItem<T>(
                          label: label,
                          isSelected: isSelected,
                          accentColor:
                              widget.glass.palette.accent,
                          textPrimaryColor:
                              widget.glass.palette.textPrimary,
                          selectedColor: selectedColor,
                          hoverColor: hoverColor,
                          onTap: () =>
                              widget.onSelected(item),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GlassDropdownItem<T> extends StatefulWidget {
  final String label;
  final bool isSelected;

  final Color accentColor;
  final Color textPrimaryColor;
  final Color selectedColor;
  final Color hoverColor;

  final VoidCallback onTap;

  const _GlassDropdownItem({
    required this.label,
    required this.isSelected,
    required this.accentColor,
    required this.textPrimaryColor,
    required this.selectedColor,
    required this.hoverColor,
    required this.onTap,
  });

  @override
  State<_GlassDropdownItem<T>> createState() =>
      _GlassDropdownItemState<T>();
}

class _GlassDropdownItemState<T>
    extends State<_GlassDropdownItem<T>> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final bool useAccent =
        widget.isSelected || _isHovered;

    final Color textColor = useAccent
        ? widget.accentColor
        : widget.textPrimaryColor;

    final FontWeight fontWeight = widget.isSelected
        ? FontWeight.w700
        : _isHovered
            ? FontWeight.w600
            : FontWeight.w400;

    final Color backgroundColor = widget.isSelected
        ? widget.selectedColor
        : _isHovered
            ? widget.hoverColor
            : Colors.transparent;

    return MouseRegion(
      onEnter: (_) {
        setState(() {
          _isHovered = true;
        });
      },
      onExit: (_) {
        setState(() {
          _isHovered = false;
        });
      },
      child: InkWell(
        onTap: widget.onTap,
        splashColor:
            widget.accentColor.withValues(alpha: 0.1),
        highlightColor: Colors.transparent,
        child: Container(
          height: 52,
          color: backgroundColor,
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  widget.label,
                  style: TextStyle(
                    color: textColor,
                    fontWeight: fontWeight,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (widget.isSelected)
                Icon(
                  Icons.check_rounded,
                  size: 18,
                  color: widget.accentColor,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
