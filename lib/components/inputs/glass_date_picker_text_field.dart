import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:universal_glass/components/inputs/fieldoutlined/outlined_field_decoration.dart';
import 'package:universal_glass/components/surface/glass_surface_container.dart';
import 'package:universal_glass/enums/glass_enums.dart';
import 'package:universal_glass/utils/glass_input_decoration.dart';
import 'package:universal_glass/utils/glass_input_state_style.dart';
import 'package:universal_glass/utils/glass_input_utils.dart';
import 'package:universal_glass/utils/glass_layout_calibrator.dart';
import 'package:universal_glass/core/layout/glass_layout_context.dart';
import 'package:universal_glass/core/layout/glass_layout_scope.dart';

class GlassDatePickerTextField extends ConsumerStatefulWidget {
  final double fieldHeight;
  final double width;
  final String label;
  final String hintText;
  final DateTime? selectedDate;
  final void Function(DateTime date)? onDateSelected;

  /// Layout explicite utilisé lorsque le contrôle est affiché
  /// dans une route séparée comme un Dialog ou un Modal.
  ///
  /// Dans une utilisation normale, ce paramètre peut rester null :
  /// le contrôle récupère automatiquement le layout depuis
  /// GlassLayoutScope.
  final GlassLayoutContext? layout;

  const GlassDatePickerTextField({
    super.key,
    this.fieldHeight = 55.0,
    this.width = double.infinity,
    this.label = 'Date',
    this.hintText = 'Sélectionner une date...',
    this.selectedDate,
    this.onDateSelected,
    this.layout,
  });

  @override
  ConsumerState<GlassDatePickerTextField> createState() =>
      _GlassDatePickerTextFieldState();
}

class _GlassDatePickerTextFieldState
    extends ConsumerState<GlassDatePickerTextField> {
  bool _isPickerActive = false;

  // ===========================================================================
  // LAYOUT
  // ===========================================================================

  GlassLayoutContext _resolveLayout(BuildContext context) {
    return widget.layout ?? GlassLayoutScope.of(context);
  }

  // ===========================================================================
  // DATE PICKER
  // ===========================================================================

  Future<void> _openDatePicker(
    GlassLayoutContext glass,
  ) async {
    if (_isPickerActive) {
      return;
    }

    final GlassInputDecoration decoration =
        glass.inputDecoration(
      hasError: false,
      isFocused: true,
    );

    final GlassInputStateStyle inputState =
        GlassInputStateStyle.resolve(
      decoration: decoration,
      isFocused: true,
      enabled: true,
    );

    setState(() {
      _isPickerActive = true;
    });

    final DateTime now = DateTime.now();

    final DateTime initialDate =
        _normalizeInitialDate(
      widget.selectedDate ?? now,
    );

    final DateTime? picked =
        await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (
        BuildContext context,
        Widget? child,
      ) {
        if (child == null) {
          return const SizedBox.shrink();
        }

        final ThemeData theme =
            Theme.of(context);

        final Color surfaceColor =
            glass.palette.darkForStyle(
          glass.theme.useAquaStyle,
        );

        return Theme(
          data: theme.copyWith(
            colorScheme:
                theme.colorScheme.copyWith(
              primary:
                  inputState.borderColor,
              onPrimary:
                  inputState.iconColorInBubble,
              surface: surfaceColor,
              onSurface:
                  inputState.textColor,
            ),
            dialogTheme:
                DialogThemeData(
              backgroundColor:
                  surfaceColor,
            ),
          ),
          child: child,
        );
      },
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _isPickerActive = false;
    });

    if (picked != null) {
      widget.onDateSelected?.call(picked);
    }
  }

  // ===========================================================================
  // DATE NORMALIZATION
  // ===========================================================================

  DateTime _normalizeInitialDate(
    DateTime date,
  ) {
    final DateTime firstDate =
        DateTime(2000);

    final DateTime lastDate =
        DateTime(2100);

    if (date.isBefore(firstDate)) {
      return firstDate;
    }

    if (date.isAfter(lastDate)) {
      return lastDate;
    }

    return date;
  }

  // ===========================================================================
  // DATE FORMAT
  // ===========================================================================

  String _formatDate(DateTime date) {
    final String day =
        date.day.toString().padLeft(2, '0');

    final String month =
        date.month.toString().padLeft(2, '0');

    return '$day/$month/${date.year}';
  }

  // ===========================================================================
  // BUILD
  // ===========================================================================

  @override
  Widget build(BuildContext context) {
    // -------------------------------------------------------------------------
    // IMPORTANT
    //
    // Utilisation normale :
    //   widget.layout == null
    //   -> GlassLayoutScope.of(context)
    //
    // Dialog / Modal :
    //   widget.layout != null
    //   -> utilisation du layout transmis par le parent.
    // -------------------------------------------------------------------------

    final GlassLayoutContext glass =
        _resolveLayout(context);

    final GlassInputDecoration decoration =
        glass.inputDecoration(
      hasError: false,
      isFocused: _isPickerActive,
    );

    final GlassInputStateStyle inputState =
        GlassInputStateStyle.resolve(
      decoration: decoration,
      isFocused: _isPickerActive,
      enabled: true,
    );

    const double baseFontSize = 15.0;

    final GlassLayoutCalibrator calibrator =
        GlassLayoutCalibrator(
      fieldHeight: widget.fieldHeight,
      fontSize: baseFontSize,
      hasPrefixIcon: true,
    );

    final bool hasValue =
        widget.selectedDate != null;

    final bool isFloating =
        _isPickerActive || hasValue;

    final String formattedDate =
        hasValue
            ? _formatDate(
                widget.selectedDate!,
              )
            : '';

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _openDatePicker(glass),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: SizedBox(
          width: widget.width,
          height: widget.fieldHeight,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // ----------------------------------------------------------------
              // SURFACE
              // ----------------------------------------------------------------

              ClipPath(
                clipper: isFloating
                    ? NotchClipper(
                        notchStart:
                            calibrator.notchStart,
                        notchWidth:
                            calibrator.getLabelWidth(
                          widget.label,
                        ),
                      )
                    : null,
                child: GlassSurfaceContainer(
                  isFocused: _isPickerActive,
                  height: widget.fieldHeight,
                  style:
                      glass.effectiveGlassStyle,
                  shape:
                      GlassShapeType.squareRounded,
                  effects: glass.effects,
                  enabled: true,
                  decoration: decoration,
                  borderRadius:
                      BorderRadius.circular(
                    glass.isSmallMobile
                        ? 12.0
                        : 16.0,
                  ),
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 12.0,
                  ),
                  child: Row(
                    crossAxisAlignment:
                        CrossAxisAlignment.center,
                    children: [
                      // --------------------------------------------------------
                      // CALENDAR ICON
                      // --------------------------------------------------------

                      context.buildInputIcon(
                        layout: glass,
                        icon: Icons
                            .calendar_month_outlined,
                        isActive:
                            _isPickerActive,
                        enabled: true,
                        onTap: () =>
                            _openDatePicker(
                          glass,
                        ),
                        fieldHeight:
                            widget.fieldHeight,
                      ),

                      const SizedBox(
                        width: 8.0,
                      ),

                      // --------------------------------------------------------
                      // DATE TEXT
                      // --------------------------------------------------------

                      Expanded(
                        child: Padding(
                          padding:
                              calibrator
                                  .contentPadding,
                          child: Text(
                            isFloating
                                ? (hasValue
                                    ? formattedDate
                                    : widget
                                        .hintText)
                                : '',
                            style: TextStyle(
                              color: hasValue
                                  ? inputState
                                      .textColor
                                  : inputState
                                      .hintColor,
                              fontSize:
                                  baseFontSize,
                              fontWeight:
                                  FontWeight.w400,
                            ),
                            maxLines: 1,
                            overflow:
                                TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ----------------------------------------------------------------
              // FLOATING LABEL
              // ----------------------------------------------------------------

              AnimatedPositioned(
                duration:
                    const Duration(
                  milliseconds: 180,
                ),
                curve:
                    Curves.easeInOutQuad,
                top: isFloating
                    ? -8.5
                    : calibrator
                        .labelTopAtRest,
                left:
                    calibrator.getLabelLeft(
                  isFloating,
                ),
                child: IgnorePointer(
                  child:
                      AnimatedDefaultTextStyle(
                    duration:
                        const Duration(
                      milliseconds: 180,
                    ),
                    curve:
                        Curves.easeInOut,
                    style: TextStyle(
                      color: inputState
                          .effectiveLabelColor,
                      fontSize: isFloating
                          ? 10.5
                          : (calibrator
                                  .isVeryCompact
                              ? 14.0
                              : baseFontSize),
                      fontWeight: isFloating
                          ? FontWeight.w700
                          : FontWeight.w500,
                      letterSpacing: 0.2,
                      backgroundColor:
                          Colors.transparent,
                    ),
                    child: Text(
                      widget.label,
                    ),
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