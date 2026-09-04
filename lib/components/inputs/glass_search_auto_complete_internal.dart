import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:universal_glass/components/inputs/fieldoutlined/outlined_field_decoration.dart';
import 'package:universal_glass/glass.dart'; 
import '../../utils/glass_input_utils.dart';
import 'glass_suggestions_overlay.dart';

class GlassSearchAutoCompleteInternal<T> extends StatefulWidget {
  final double fieldHeight;
  final double width;
  final String label; 
  final String hintText;
  final List<T> suggestions;
  final String Function(T item) stringExtractor;
  final void Function(T selectedItem)? onSelected;
  final Widget Function(BuildContext context, T item, bool isHovered)? itemBuilder;
  final TextEditingController? controller;
  final Color? overlayIconColor;
  final Color? overlayHighlightColor;
  final WidgetRef ref;

  const GlassSearchAutoCompleteInternal({
    super.key,
    required this.fieldHeight,
    required this.width,
    required this.label, 
    required this.hintText,
    required this.suggestions,
    required this.stringExtractor,
    required this.onSelected,
    required this.itemBuilder,
    required this.controller,
    this.overlayIconColor,
    this.overlayHighlightColor,
    required this.ref,
  });

  @override
  State<GlassSearchAutoCompleteInternal<T>> createState() => _GlassSearchAutoCompleteInternalState<T>();
}

class _GlassSearchAutoCompleteInternalState<T> extends State<GlassSearchAutoCompleteInternal<T>> {
  TextEditingController? _localController;
  final FocusNode _focusNode = FocusNode();
  final LayerLink _layerLink = LayerLink();
  final OverlayPortalController _overlayController = OverlayPortalController();
  
  List<T> _filteredResults = [];
  bool _hasFocus = false;

  TextEditingController get _effectiveController => widget.controller ?? (_localController ??= TextEditingController());

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChanged);
    _effectiveController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChanged);
    _effectiveController.removeListener(_onTextChanged);
    _focusNode.dispose();
    _localController?.dispose();
    super.dispose();
  }

  void _onFocusChanged() {
    setState(() {
      _hasFocus = _focusNode.hasFocus;
    });
    if (_hasFocus && _filteredResults.isNotEmpty) {
      _overlayController.show();
    } else {
      _overlayController.hide();
    }
  }

  void _onTextChanged() {
    setState(() {
      _filteredResults = GlassSearchEngine.filterCustomObjects<T>(
        query: _effectiveController.text,
        candidates: widget.suggestions,
        searchFieldExtractor: widget.stringExtractor,
        maxResults: 6,
      );
    });

    if (_filteredResults.isNotEmpty && _focusNode.hasFocus) {
      if (!_overlayController.isShowing) _overlayController.show();
    } else {
      if (_overlayController.isShowing) _overlayController.hide();
    }
  }

  void _handleSelection(T item) {
    final label = widget.stringExtractor(item);
    _effectiveController.text = label;
    _effectiveController.selection = TextSelection.fromPosition(TextPosition(offset: label.length));
    _overlayController.hide();
    _focusNode.unfocus();
    if (widget.onSelected != null) {
      widget.onSelected!(item);
    }
  }

  @override
  Widget build(BuildContext context) {
    final glass = widget.ref.watchGlassContext(context); 
    final bool useAqua = glass.theme.useAquaStyle;
    final Color focusColor = useAqua ? Colors.cyanAccent : Colors.orangeAccent;
    const double baseFontSize = 15.0; 

    // INITIALISATION DU CALIBRATEUR DE LAYOUT EN MODE PREFIXE (AVEC ICÔNE RECHERCHE)
    final calibrator = GlassLayoutCalibrator(
      fieldHeight: widget.fieldHeight,
      fontSize: baseFontSize,
      hasPrefixIcon: true,
    );

    final bool hasText = _effectiveController.text.isNotEmpty;
    final bool isFloating = _hasFocus || hasText;

    return CompositedTransformTarget(
      link: _layerLink,
      child: OverlayPortal(
        controller: _overlayController,
        overlayChildBuilder: (context) => GlassSuggestionsOverlay<T>(
          layerLink: _layerLink,
          width: widget.width,
          filteredResults: _filteredResults,
          stringExtractor: widget.stringExtractor,
          onSelected: _handleSelection,
          itemBuilder: widget.itemBuilder,
          glass: glass,
          currentQuery: _effectiveController.text,
          iconColor: widget.overlayIconColor, 
          highlightColor: widget.overlayHighlightColor, 
        ),
        child: SizedBox(
          width: widget.width,
          height: widget.fieldHeight,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // 1. CLIPPATH ET NOTCH CLIPPER ALIGNÉS SUR LES AUTRES COMPOSANTS OUTLINED
              ClipPath(
                clipper: isFloating ? NotchClipper(notchStart: calibrator.notchStart, notchWidth: calibrator.getLabelWidth(widget.label)) : null,
                child: GlassSurfaceContainer(
                  isFocused: _hasFocus,
                  height: widget.fieldHeight,
                  style: glass.effectiveGlassStyle,
                  shape: GlassShapeType.squareRounded,
                  effects: glass.effects,
                  enabled: true,
                  decoration: glass.inputDecoration(hasError: false, isFocused: _hasFocus),
                  borderRadius: BorderRadius.circular(glass.isSmallMobile ? 12 : 16),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  clipBehavior: Clip.none, 
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Icône de recherche calibrée dynamiquement
                      context.buildInputIcon(
                        icon: Icons.search_rounded,
                        isActive: _hasFocus,
                        enabled: true,
                        onTap: () => _focusNode.requestFocus(),
                        fieldHeight: widget.fieldHeight,
                        bubbleRatio: calibrator.isVeryCompact ? 0.65 : 0.6,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _effectiveController,
                          focusNode: _focusNode,
                          textAlignVertical: TextAlignVertical.center, 
                          style: TextStyle(
                            color: glass.palette.textPrimary,
                            fontSize: baseFontSize,
                            height: 1.0,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: calibrator.contentPadding, 
                            // Le hintText n'apparaît que lorsque le label monte pour éviter les télescopages
                            hintText: isFloating ? widget.hintText : null,
                            hintStyle: TextStyle(
                              // FIX DÉBOGAGE : Sécurisation de la couleur avec fallback et withOpacity
                              color: (glass.palette.textSecondary as Color?)?.withOpacity(0.5) ?? Colors.white.withOpacity(0.4),
                              fontSize: calibrator.hintFontSize,
                              height: 1.0,
                            ),
                            counterText: '',
                          ),
                          onChanged: (val) {
                            setState(() {}); 
                          },
                        ),
                      ),
                      if (_effectiveController.text.isNotEmpty) ...[
                        const SizedBox(width: 4),
                        // Bouton Clear (icône nue) calibré
                        context.buildInputIcon(
                          icon: Icons.close_rounded,
                          isActive: false,
                          enabled: true,
                          onTap: () {
                            _effectiveController.clear();
                            _focusNode.unfocus();
                            setState(() {});
                          },
                          fieldHeight: widget.fieldHeight,
                          iconRatio: 0.55,
                          bubbleRatio: calibrator.isVeryCompact ? 0.65 : 0.6,
                          onlyIcon: true,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              
              // 2. LE LABEL FLOTTANT ANIMÉ ENTIÈREMENT RESTAURÉ
              AnimatedPositioned(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeInOutQuad,
                top: isFloating ? -8.5 : calibrator.labelTopAtRest,
                left: calibrator.getLabelLeft(isFloating),
                child: IgnorePointer(
                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 180),
                    style: TextStyle(
                      color: _hasFocus 
                          ? focusColor 
                          : Colors.white.withValues(alpha: isFloating ? 0.6 : 0.4),
                      fontSize: isFloating ? 10.5 : (calibrator.isVeryCompact ? 14 : baseFontSize),
                      fontWeight: isFloating ? FontWeight.w700 : FontWeight.w500,
                      letterSpacing: 0.2,
                      backgroundColor: Colors.transparent,
                    ),
                    child: Text(widget.label),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
