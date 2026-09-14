import 'package:flutter/material.dart';

import 'package:universal_glass/components/inputs/fieldoutlined/outlined_field_decoration.dart';
import 'package:universal_glass/components/surface/glass_surface_container.dart';
import 'package:universal_glass/core/layout/glass_layout_context.dart';
import 'package:universal_glass/core/layout/glass_layout_scope.dart';
import 'package:universal_glass/enums/glass_enums.dart';
import 'package:universal_glass/utils/glass_input_decoration.dart';
import 'package:universal_glass/utils/glass_input_utils.dart';
import 'package:universal_glass/utils/glass_layout_calibrator.dart';
import 'package:universal_glass/utils/glass_text_formatter.dart';

import 'glass_suggestions_overlay.dart';



/// ============================================================================
/// GLASS SEARCH AUTO COMPLETE - INTERNAL
/// ============================================================================
///
/// Champ de recherche avec suggestions.
///
/// Architecture visuelle alignée sur :
/// - UniversalGlassTextFieldOutlined
/// - GlassSurfaceContainer
/// - GlassLayoutCalibrator
/// - GlassInputDecoration
/// - GlassInputUtils
///
/// Le composant conserve cependant sa responsabilité spécifique :
/// - filtrage des suggestions ;
/// - affichage de l'overlay ;
/// - sélection d'un élément ;
/// - synchronisation avec le TextEditingController.
/// ============================================================================
class GlassSearchAutoCompleteInternal<T> extends StatefulWidget {
  final double fieldHeight;
  final double width;

  final String label;
  final String hintText;

  final List<T> suggestions;
  final String Function(T item) stringExtractor;

  final void Function(T selectedItem)? onSelected;

  final Widget Function(BuildContext context, T item, bool isHovered)?
  itemBuilder;

  final TextEditingController? controller;

  final Color? overlayIconColor;
  final Color? overlayHighlightColor;

  
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
  });

  @override
  State<GlassSearchAutoCompleteInternal<T>> createState() =>
      _GlassSearchAutoCompleteInternalState<T>();
}

class _GlassSearchAutoCompleteInternalState<T>
    extends State<GlassSearchAutoCompleteInternal<T>> {
  // ==========================================================================
  // CONTROLLER / FOCUS
  // ==========================================================================

  TextEditingController? _localController;

  TextEditingController? _listenedController;

  final FocusNode _focusNode = FocusNode();

  final LayerLink _layerLink = LayerLink();

  final OverlayPortalController _overlayController = OverlayPortalController();

  // ==========================================================================
  // STATE
  // ==========================================================================

  List<T> _filteredResults = <T>[];

  bool _hasFocus = false;

  // ==========================================================================
  // CONTROLLER EFFECTIF
  // ==========================================================================

  TextEditingController get _effectiveController {
    return widget.controller ?? (_localController ??= TextEditingController());
  }

  // ==========================================================================
  // INIT
  // ==========================================================================

  @override
  void initState() {
    super.initState();

    _focusNode.addListener(_onFocusChanged);

    _attachController(_effectiveController);

    _filterResults();
  }

  // ==========================================================================
  // UPDATE WIDGET
  // ==========================================================================

  @override
  void didUpdateWidget(covariant GlassSearchAutoCompleteInternal<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Le controller externe peut changer pendant la durée de vie du widget.
    if (oldWidget.controller != widget.controller) {
      final TextEditingController newController = _effectiveController;

      _detachController();
      _attachController(newController);

      _filterResults();
    } else if (oldWidget.suggestions != widget.suggestions ||
        oldWidget.stringExtractor != widget.stringExtractor) {
      _filterResults();
    }
  }

  // ==========================================================================
  // CONTROLLER LISTENER
  // ==========================================================================

  void _attachController(TextEditingController controller) {
    if (identical(_listenedController, controller)) {
      return;
    }

    _detachController();

    _listenedController = controller;
    _listenedController!.addListener(_onTextChanged);
  }

  void _detachController() {
    _listenedController?.removeListener(_onTextChanged);
    _listenedController = null;
  }

  // ==========================================================================
  // FOCUS
  // ==========================================================================

  void _onFocusChanged() {
    if (!mounted) {
      return;
    }

    final bool hasFocus = _focusNode.hasFocus;

    setState(() {
      _hasFocus = hasFocus;
    });

    if (hasFocus && _filteredResults.isNotEmpty) {
      _showOverlay();
    } else {
      _hideOverlay();
    }
  }

  // ==========================================================================
  // TEXT CHANGED
  // ==========================================================================

  void _onTextChanged() {
    if (!mounted) {
      return;
    }

    _filterResults();
  }

  void _filterResults() {
    final List<T> results = GlassSearchEngine.filterCustomObjects<T>(
      query: _effectiveController.text,
      candidates: widget.suggestions,
      searchFieldExtractor: widget.stringExtractor,
      maxResults: 6,
    );

    if (!mounted) {
      _filteredResults = results;
      return;
    }

    setState(() {
      _filteredResults = results;
    });

    if (_focusNode.hasFocus && results.isNotEmpty) {
      _showOverlay();
    } else {
      _hideOverlay();
    }
  }

  // ==========================================================================
  // OVERLAY
  // ==========================================================================

  void _showOverlay() {
    if (!_overlayController.isShowing) {
      _overlayController.show();
    }
  }

  void _hideOverlay() {
    if (_overlayController.isShowing) {
      _overlayController.hide();
    }
  }

  // ==========================================================================
  // SELECTION
  // ==========================================================================

  void _handleSelection(T item) {
    final String value = widget.stringExtractor(item);

    final TextEditingController controller = _effectiveController;

    controller.value = controller.value.copyWith(
      text: value,
      selection: TextSelection.collapsed(offset: value.length),
      composing: TextRange.empty,
    );

    _hideOverlay();

    _focusNode.unfocus();

    widget.onSelected?.call(item);
  }

  // ==========================================================================
  // DISPOSE
  // ==========================================================================

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChanged);

    _detachController();

    _focusNode.dispose();

    _localController?.dispose();

    super.dispose();
  }

  // ==========================================================================
  // BUILD
  // ==========================================================================

  @override
  Widget build(BuildContext context) {
   final GlassLayoutContext glass =
    GlassLayoutScope.of(context);

    final bool useAqua = glass.theme.useAquaStyle;

    final Color focusColor = useAqua ? Colors.cyanAccent : Colors.orangeAccent;

    const double baseFontSize = 15.0;

    // =========================================================================
    // LAYOUT CALIBRATOR
    // =========================================================================

    final GlassLayoutCalibrator calibrator = GlassLayoutCalibrator(
      fieldHeight: widget.fieldHeight,
      fontSize: baseFontSize,
      hasPrefixIcon: true,
    );

    // =========================================================================
    // FIELD STATE
    // =========================================================================

    final bool hasText = _effectiveController.text.isNotEmpty;

    final bool isFloating = _hasFocus || hasText;

    final GlassInputDecoration decoration = glass.inputDecoration(
      hasError: false,
      isFocused: _hasFocus,
    );

    // =========================================================================
    // FIELD
    // =========================================================================

    return CompositedTransformTarget(
      link: _layerLink,
      child: OverlayPortal(
        controller: _overlayController,

        // =====================================================================
        // SUGGESTIONS OVERLAY
        // =====================================================================
        overlayChildBuilder: (BuildContext overlayContext) {
          return GlassSuggestionsOverlay<T>(
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
          );
        },

        // =====================================================================
        // FIELD
        // =====================================================================
        child: SizedBox(
          width: widget.width,
          height: widget.fieldHeight,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // =================================================================
              // SURFACE + NOTCH
              // =================================================================
              ClipPath(
                clipper: isFloating
                    ? NotchClipper(
                        notchStart: calibrator.notchStart,
                        notchWidth: calibrator.getLabelWidth(widget.label),
                      )
                    : null,
                child: GlassSurfaceContainer(
                  isFocused: _hasFocus,
                  height: widget.fieldHeight,
                  width: widget.width,
                  style: glass.effectiveGlassStyle,
                  shape: GlassShapeType.squareRounded,
                  effects: glass.effects,
                  enabled: true,
                  decoration: decoration,
                  borderRadius: BorderRadius.circular(
                    glass.isSmallMobile ? 12.0 : 16.0,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),

                  // =============================================================
                  // FIELD CONTENT
                  // =============================================================
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // ===========================================================
                      // SEARCH ICON
                      // ===========================================================
                      context.buildInputIcon(
                        icon: Icons.search_rounded,
                        isActive: _hasFocus,
                        enabled: true,
                        onTap: () {
                          _focusNode.requestFocus();
                        },
                        fieldHeight: widget.fieldHeight,
                        bubbleRatio: calibrator.isVeryCompact ? 0.65 : 0.60,
                      ),

                      const SizedBox(width: 8.0),

                      // ===========================================================
                      // TEXT FIELD
                      // ===========================================================
                      Expanded(
                        child: TextField(
                          controller: _effectiveController,
                          focusNode: _focusNode,

                          textAlignVertical: TextAlignVertical.center,

                          style: TextStyle(
                            color: glass.palette.textPrimary,
                            fontSize: baseFontSize,
                            fontWeight: decoration.fontWeight,
                            letterSpacing: decoration.letterSpacing,
                            height: 1.0,
                          ),

                          cursorColor: focusColor,

                          decoration: InputDecoration(
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,

                            isDense: true,

                            contentPadding: calibrator.contentPadding,

                            // Le hint apparaît uniquement lorsque le label
                            // est flottant, comme dans le champ Outlined.
                            hintText: isFloating ? widget.hintText : null,

                            hintStyle: TextStyle(
                              color: glass.palette.textSecondary.withValues(
                                alpha: 0.50,
                              ),
                              fontSize: calibrator.hintFontSize,
                              fontWeight: decoration.fontWeight,
                              letterSpacing: decoration.letterSpacing,
                              height: 1.0,
                            ),

                            counterText: '',
                          ),
                        ),
                      ),

                      // =========================================================
                      // CLEAR BUTTON
                      // =========================================================
                      if (hasText) ...[
                        const SizedBox(width: 4.0),

                        context.buildInputIcon(
                          icon: Icons.close_rounded,
                          isActive: false,
                          enabled: true,
                          onTap: () {
                            _effectiveController.clear();
                            _focusNode.unfocus();
                          },
                          fieldHeight: widget.fieldHeight,
                          iconRatio: 0.55,
                          bubbleRatio: calibrator.isVeryCompact ? 0.65 : 0.60,
                          onlyIcon: true,
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              // =================================================================
              // FLOATING LABEL
              // =================================================================
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
                          : Colors.white.withValues(
                              alpha: isFloating ? 0.60 : 0.40,
                            ),

                      fontSize: isFloating
                          ? 10.5
                          : (calibrator.isVeryCompact ? 14.0 : baseFontSize),

                      fontWeight: isFloating
                          ? FontWeight.w700
                          : FontWeight.w500,

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
