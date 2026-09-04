import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:universal_glass/components/inputs/fielddrop/glass_dropdown_overlay.dart';
import 'package:universal_glass/components/inputs/fieldoutlined/outlined_field_decoration.dart';
import 'package:universal_glass/components/surface/glass_surface_container.dart';
import 'package:universal_glass/enums/glass_enums.dart';
import 'package:universal_glass/utils/glass_input_utils.dart';
import 'package:universal_glass/utils/glass_layout_calibrator.dart';
import 'package:universal_glass/utils/glass_theme_extension.dart';

class GlassDropdownTextField<T> extends ConsumerStatefulWidget {
  final double fieldHeight;
  final double width;
  final String label;
  final String hintText;
  final List<T> items;
  final T? value;
  final String Function(T item) itemLabelExtractor;
  final void Function(T? value)? onChanged;
  final IconData? prefixIcon;

  const GlassDropdownTextField({
    super.key,
    this.fieldHeight = 55.0,
    this.width = double.infinity,
    this.label = 'Sélectionner',
    this.hintText = 'Choisissez une option...',
    required this.items,
    this.value,
    required this.itemLabelExtractor,
    this.onChanged,
    this.prefixIcon,
  });

  @override
  ConsumerState<GlassDropdownTextField<T>> createState() => _GlassDropdownTextFieldState<T>();
}

class _GlassDropdownTextFieldState<T> extends ConsumerState<GlassDropdownTextField<T>> {
  final LayerLink _layerLink = LayerLink();
  final OverlayPortalController _overlayController = OverlayPortalController();
  final FocusNode _focusNode = FocusNode();
  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    // FIX : Nettoyage et libération du FocusNode obligatoire pour pub.dev
    _focusNode.removeListener(_onFocusChanged);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChanged() {
    if (!_focusNode.hasFocus && _isOpen) {
      _toggleDropdown();
    }
  }

  void _toggleDropdown() {
    setState(() {
      _isOpen = !_isOpen;
      if (_isOpen) {
        _focusNode.requestFocus();
        _overlayController.show();
      } else {
        _focusNode.unfocus();
        _overlayController.hide();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final glass = ref.watchGlassContext(context);
    final bool useAqua = glass.theme.useAquaStyle;
    final Color focusColor = useAqua ? Colors.cyanAccent : Colors.orangeAccent;
    const double baseFontSize = 15.0;

    final calibrator = GlassLayoutCalibrator(
      fieldHeight: widget.fieldHeight,
      fontSize: baseFontSize,
      hasPrefixIcon: widget.prefixIcon != null,
    );

    final bool hasValue = widget.value != null;
    final bool isFloating = _isOpen || hasValue;

    // ignore: null_check_on_nullable_type_parameter
    final String displayLabel = hasValue ? widget.itemLabelExtractor(widget.value!) : '';

    return CompositedTransformTarget(
      link: _layerLink,
      child: OverlayPortal(
        controller: _overlayController,
        overlayChildBuilder: (context) => GlassDropdownOverlay<T>(
          layerLink: _layerLink,
          width: widget.width,
          items: widget.items,
          itemLabelExtractor: widget.itemLabelExtractor,
          glass: glass,
          onSelected: (item) {
            widget.onChanged?.call(item);
            _toggleDropdown();
          },
        ),
        child: GestureDetector(
          onTap: _toggleDropdown,
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: SizedBox(
              width: widget.width,
              height: widget.fieldHeight,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  ClipPath(
                    clipper: isFloating ? NotchClipper(notchStart: calibrator.notchStart, notchWidth: calibrator.getLabelWidth(widget.label)) : null,
                    child: GlassSurfaceContainer(
                      isFocused: _isOpen,
                      height: widget.fieldHeight,
                      style: glass.effectiveGlassStyle,
                      shape: GlassShapeType.squareRounded,
                      effects: glass.effects,
                      enabled: true,
                      decoration: glass.inputDecoration(hasError: false, isFocused: _isOpen),
                      borderRadius: BorderRadius.circular(glass.isSmallMobile ? 12 : 16),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      clipBehavior: Clip.none,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (widget.prefixIcon != null) ...[
                            context.buildInputIcon(
                              icon: widget.prefixIcon!,
                              isActive: _isOpen,
                              enabled: true,
                              onTap: _toggleDropdown,
                              fieldHeight: widget.fieldHeight,
                            ),
                            const SizedBox(width: 8),
                          ],
                          Expanded(
                            child: Padding(
                              padding: calibrator.contentPadding,
                              child: Text(
                                isFloating ? (hasValue ? displayLabel : widget.hintText) : '',
                                style: TextStyle(
                                  color: hasValue ? glass.palette.textPrimary : glass.palette.textSecondary.withValues(alpha: 0.5),
                                  fontSize: baseFontSize,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          context.buildInputIcon(
                            icon: _isOpen ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                            isActive: _isOpen,
                            enabled: true,
                            onTap: _toggleDropdown,
                            fieldHeight: widget.fieldHeight,
                            onlyIcon: true,
                          ),
                        ],
                      ),
                    ),
                  ),
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 180),
                    curve: Curves.easeInOutQuad,
                    top: isFloating ? -8.5 : calibrator.labelTopAtRest,
                    left: calibrator.getLabelLeft(isFloating),
                    child: IgnorePointer(
                      child: AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 180),
                        style: TextStyle(
                          color: _isOpen ? focusColor : Colors.white.withValues(alpha: isFloating ? 0.6 : 0.4),
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
        ),
      ),
    );
  }
}
