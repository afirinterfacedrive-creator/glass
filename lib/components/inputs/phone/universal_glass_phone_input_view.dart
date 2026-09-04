
import 'package:flutter/material.dart';

import 'package:universal_glass/components/inputs/glass_input_decoration.dart';
import 'package:universal_glass/components/inputs/universal_glass_phone_input.dart';
import 'package:universal_glass/components/inputs/phone/universal_glass_phone_input_state.dart';
import 'package:universal_glass/components/surface/glass_notch_shadow_wrapper-copy.dart';
import 'package:universal_glass/components/surface/glass_surface_container.dart';
import 'package:universal_glass/phone/phone_country.dart';
import 'package:universal_glass/phone/phone_country_picker.dart';
import 'package:universal_glass/phone/phone_country_registry.dart';
import 'package:universal_glass/utils/glass_input_utils.dart';
import 'package:universal_glass/utils/glass_layout_calibrator.dart';
import 'package:universal_glass/utils/glass_theme_extension.dart';

class UniversalGlassPhoneInputView extends StatelessWidget {
  final UniversalGlassPhoneInputState state;

  const UniversalGlassPhoneInputView({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final UniversalGlassPhoneInput widget = state.widget;

    return _PhoneInputVisualBuilder(
      focusNode: state.focusNode,
      controller: state.controller,
      builder: (
        BuildContext context,
        bool hasFocus,
        bool hasText,
      ) {
        return _buildPhoneInput(
          context: context,
          widget: widget,
          state: state,
          hasFocus: hasFocus,
          hasText: hasText,
        );
      },
    );
  }

  // ===========================================================================
  // PHONE INPUT
  // ===========================================================================

  Widget _buildPhoneInput({
    required BuildContext context,
    required UniversalGlassPhoneInput widget,
    required UniversalGlassPhoneInputState state,
    required bool hasFocus,
    required bool hasText,
  }) {
    final GlassLayoutContext glass =
        context.watchGlassContext;

    final bool hasError =
        state.errorText != null &&
        state.errorText!.trim().isNotEmpty;

    final GlassInputDecoration decoration =
        glass.inputDecoration(
      hasError: hasError,
      isFocused: hasFocus,
    );

    final bool useAqua =
        glass.theme.useAquaStyle;

    final Color focusColor =
        useAqua
            ? Colors.cyanAccent
            : Colors.orangeAccent;

    // -------------------------------------------------------------------------
    // CALIBRATEUR
    // -------------------------------------------------------------------------

    final GlassLayoutCalibrator geo =
        GlassLayoutCalibrator(
      fieldHeight: widget.fieldHeight,
      fontSize: decoration.fontSize,
      hasPrefixIcon: true,
    );

    final bool isFloating =
        hasFocus || hasText;

    final BorderRadius borderRadius =
        BorderRadius.circular(
      decoration.borderRadius,
    );

    // -------------------------------------------------------------------------
    // NOTCH VISUEL
    // -------------------------------------------------------------------------

    final double notchStart =
        geo.notchStart;

    final double notchWidth =
        geo.getLabelWidth(widget.label);

    return Opacity(
      opacity: widget.enabled ? 1.0 : 0.65,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: widget.width,
            height: widget.fieldHeight,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // =================================================================
                // SURFACE
                // =================================================================
GlassNotchShadowWrapper(
  clipper: null,

  isShadowEnabled: false,
  shadowOpacity: 0,
  elevation: 0,

  borderRadius: borderRadius,

  child: GlassSurfaceContainer(
    // =======================================================================
    // DÉCORATION
    // =======================================================================

    decoration: decoration,

    // =======================================================================
    // STYLE GLASS
    // =======================================================================

    style: glass.effectiveGlassStyle,
    effects: glass.effects,
    shape: widget.shape,

    // =======================================================================
    // ÉTAT DU CHAMP
    // =======================================================================

    isFocused: hasFocus,
    hasError: hasError,
    errorText: state.errorText,
    enabled: widget.enabled,

    // =======================================================================
    // DIMENSIONS
    // =======================================================================

    width: widget.width,
    height: widget.fieldHeight,

    borderRadius: borderRadius,

    padding: const EdgeInsets.symmetric(
      horizontal: 14,
    ),

    // =======================================================================
    // INTERACTION
    // =======================================================================

    onTap: null,
    liftOnHover: !hasFocus,

    // =======================================================================
    // EFFETS
    // =======================================================================

    disableShadow: true,
    clipBehavior: Clip.none,

    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // =========================================================
                        // PAYS
                        // =========================================================

                        _buildCountrySelector(
                          context: context,
                          widget: widget,
                          state: state,
                          decoration:
                              decoration,
                          glass: glass,
                          hasFocus:
                              hasFocus,
                          hasError:
                              hasError,
                          focusColor:
                              focusColor,
                          geo: geo,
                        ),

                        const SizedBox(
                          width: 12,
                        ),

                        // =========================================================
                        // TEXT FIELD
                        // =========================================================

                        Expanded(
                          child:
                              geo.translateTextVertically(
                            TextFormField(
                              controller:
                                  state.controller,

                              focusNode:
                                  state.focusNode,

                              enabled:
                                  widget.enabled,

                              readOnly:
                                  widget.readOnly,

                              autofocus:
                                  false,

                              showCursor:
                                  true,

                              keyboardType:
                                  TextInputType.phone,

                              textInputAction:
                                  widget.textInputAction,

                              textAlignVertical:
                                  TextAlignVertical.center,

                              inputFormatters:
                                  state.inputFormatters,

                              style:
                                  TextStyle(
                                color:
                                    widget.enabled
                                        ? decoration
                                            .effectiveTextColor
                                        : decoration
                                            .effectiveTextColor
                                            .withValues(
                                            alpha: 0.35,
                                          ),
                                fontSize:
                                    decoration.fontSize,
                                fontWeight:
                                    decoration.fontWeight,
                                letterSpacing:
                                    decoration.letterSpacing,
                              ),

                              cursorColor:
                                  focusColor,

                              // Aucun requestFocus().
                              onTap:
                                  widget.onTap,

                              onChanged:
                                  state.handleChanged,

                              onFieldSubmitted:
                                  state.handleSubmitted,

                              decoration:
                                  InputDecoration(
                                isDense:
                                    true,

                                // Le hint reste visible
                                // même lorsque le champ n'est
                                // pas focusé.
                                hintText:
                                    state.effectiveHintText,

                                hintStyle:
                                    TextStyle(
                                  color:
                                      decoration
                                          .effectiveHintColor,
                                  fontSize:
                                      geo.hintFontSize,
                                  fontWeight:
                                      FontWeight.w400,
                                  letterSpacing:
                                      decoration
                                          .letterSpacing,
                                ),

                                contentPadding:
                                    EdgeInsets.zero,

                                border:
                                    InputBorder.none,

                                enabledBorder:
                                    InputBorder.none,

                                focusedBorder:
                                    InputBorder.none,

                                errorBorder:
                                    InputBorder.none,

                                focusedErrorBorder:
                                    InputBorder.none,

                                errorText:
                                    null,
                              ),
                            ),
                          ),
                        ),
                      ],
    ),
  ),
),

/*
                GlassNotchShadowWrapper(
                  // Aucun clipping.
                  clipper: null,

                  isShadowEnabled: false,
                  shadowOpacity: 0,
                  elevation: 0,

                  borderRadius:
                      borderRadius,

                  child:
                                        GlassSurfaceContainer(
                    decoration: decoration,

                    style: glass.effectiveGlassStyle,
                    effects: glass.effects,

                    shape: widget.shape,

                    // =========================================================================
                    // ÉTAT VISUEL
                    // =========================================================================

                    isFocused: hasFocus,
                    hasError: hasError,
                    enabled: widget.enabled,

                    // =========================================================================
                    // DIMENSIONS
                    // =========================================================================

                    width: widget.width,
                    height: widget.fieldHeight,

                    borderRadius: borderRadius,

                    // =========================================================================
                    // INTERACTION
                    // =========================================================================

                    onTap: null,

                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                    ),

                    liftOnHover: !hasFocus,

                    // Le PhoneInput gère son propre rendu de bordure/notch.
                    disableShadow: true,

                    clipBehavior: Clip.none,

                    child: Row(
                      crossAxisAlignment:
                          CrossAxisAlignment.center,
                      children: [
                        // =========================================================
                        // PAYS
                        // =========================================================

                        _buildCountrySelector(
                          context: context,
                          widget: widget,
                          state: state,
                          decoration:
                              decoration,
                          glass: glass,
                          hasFocus:
                              hasFocus,
                          hasError:
                              hasError,
                          focusColor:
                              focusColor,
                          geo: geo,
                        ),

                        const SizedBox(
                          width: 12,
                        ),

                        // =========================================================
                        // TEXT FIELD
                        // =========================================================

                        Expanded(
                          child:
                              geo.translateTextVertically(
                            TextFormField(
                              controller:
                                  state.controller,

                              focusNode:
                                  state.focusNode,

                              enabled:
                                  widget.enabled,

                              readOnly:
                                  widget.readOnly,

                              autofocus:
                                  false,

                              showCursor:
                                  true,

                              keyboardType:
                                  TextInputType.phone,

                              textInputAction:
                                  widget.textInputAction,

                              textAlignVertical:
                                  TextAlignVertical.center,

                              inputFormatters:
                                  state.inputFormatters,

                              style:
                                  TextStyle(
                                color:
                                    widget.enabled
                                        ? decoration
                                            .effectiveTextColor
                                        : decoration
                                            .effectiveTextColor
                                            .withValues(
                                            alpha: 0.35,
                                          ),
                                fontSize:
                                    decoration.fontSize,
                                fontWeight:
                                    decoration.fontWeight,
                                letterSpacing:
                                    decoration.letterSpacing,
                              ),

                              cursorColor:
                                  focusColor,

                              // Aucun requestFocus().
                              onTap:
                                  widget.onTap,

                              onChanged:
                                  state.handleChanged,

                              onFieldSubmitted:
                                  state.handleSubmitted,

                              decoration:
                                  InputDecoration(
                                isDense:
                                    true,

                                // Le hint reste visible
                                // même lorsque le champ n'est
                                // pas focusé.
                                hintText:
                                    state.effectiveHintText,

                                hintStyle:
                                    TextStyle(
                                  color:
                                      decoration
                                          .effectiveHintColor,
                                  fontSize:
                                      geo.hintFontSize,
                                  fontWeight:
                                      FontWeight.w400,
                                  letterSpacing:
                                      decoration
                                          .letterSpacing,
                                ),

                                contentPadding:
                                    EdgeInsets.zero,

                                border:
                                    InputBorder.none,

                                enabledBorder:
                                    InputBorder.none,

                                focusedBorder:
                                    InputBorder.none,

                                errorBorder:
                                    InputBorder.none,

                                focusedErrorBorder:
                                    InputBorder.none,

                                errorText:
                                    null,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
*/
                // =================================================================
                // NOTCH VISUEL
                // =================================================================

                if (isFloating)
                  Positioned.fill(
                    child: IgnorePointer(
                      ignoring: true,
                      child: CustomPaint(
                        painter:
                            _PhoneInputNotchPainter(
                          notchStart:
                              notchStart,
                          notchWidth:
                              notchWidth,
                          color:
                              decoration.color,
                          borderColor:
                              hasError
                                  ? decoration
                                      .effectiveErrorBorderColor
                                  : decoration
                                      .effectiveFocusBorderColor,
                          borderWidth:
                              hasFocus
                                  ? decoration
                                      .safeFocusBorderWidth
                                  : decoration
                                      .safeBorderWidth,
                          borderRadius:
                              borderRadius,
                        ),
                      ),
                    ),
                  ),

                // =================================================================
                // LABEL
                // =================================================================
 Positioned(
  top: isFloating ? -8.5 : geo.labelTopAtRest,
  left: geo.getLabelLeft(
    isFloating,
  ),
  child: IgnorePointer(
    ignoring: true,
    child: AnimatedOpacity(
      duration: const Duration(
        milliseconds: 140,
      ),
      opacity: isFloating ? 1.0 : 0.0,
      child: AnimatedDefaultTextStyle(
        duration: const Duration(
          milliseconds: 180,
        ),
        style: TextStyle(
          color: hasError
              ? decoration.errorColor
              : focusColor,
          fontSize: isFloating
              ? 10.5
              : decoration.fontSize,
          fontWeight: isFloating
              ? FontWeight.w700
              : FontWeight.w500,
          letterSpacing: 0.2,
          backgroundColor: Colors.transparent,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 5.0,
          ),
          decoration: BoxDecoration(
            color: hasError
                ? decoration.effectiveErrorBorderColor
                    .withValues(alpha: 0.18)
                : decoration.effectiveFocusBorderColor
                    .withValues(alpha: 0.18),
          ),
          child: Text(
            widget.label,
          ),
        ),
      ),
    ),
  ),
),
 
              ],
            ),
          ),

          // =====================================================================
          // ERROR
          // =====================================================================

          if (hasError && widget.enabled)
            Padding(
              padding:
                  const EdgeInsets.only(
                top: 6,
                left: 14,
              ),
              child:
                  Text(
                state.errorText!,
                style:
                    TextStyle(
                  color:
                      decoration.errorColor,
                  fontSize: 12,
                  fontWeight:
                      FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ===========================================================================
  // COUNTRY SELECTOR
  // ===========================================================================

  Widget _buildCountrySelector({
    required BuildContext context,
    required UniversalGlassPhoneInput widget,
    required UniversalGlassPhoneInputState state,
    required GlassInputDecoration decoration,
    required GlassLayoutContext glass,
    required bool hasFocus,
    required bool hasError,
    required Color focusColor,
    required GlassLayoutCalibrator geo,
  }) {
    final bool canOpen =
        widget.enabled &&
        !widget.readOnly &&
        widget.countryPickerEnabled;

    final Color iconColor =
        hasError
            ? Colors.redAccent
            : hasFocus
                ? focusColor
                : decoration.iconColor;

    final double bubbleSize =
        GlassInputUtils.bubbleSize(
      fieldHeight:
          widget.fieldHeight,
      ratio: 0.6,
    );

    final Widget bubble =
        glass.buildInputBubble(
      child:
          _buildCountryFlag(
        state: state,
        size:
            GlassInputUtils.iconSize(
          bubbleSize:
              bubbleSize,
        ),
      ),
      fieldHeight:
          widget.fieldHeight,
      isFocused:
          hasFocus,
      enabled:
          canOpen,
      onTap: canOpen
          ? () {
              _handleCountryTap(
                context,
                widget,
                state,
              );
            }
          : null,
      iconColor:
          iconColor,
    );

    final Color finalTextColor =
        !widget.enabled
            ? decoration.textColor
                .withValues(alpha: 0.40)
            : hasFocus
                ? focusColor
                : decoration.textColor;

    final Color separatorColor =
        hasFocus
            ? focusColor.withValues(
                alpha: 0.4,
              )
            : glass.palette.border
                .withValues(
                alpha: 0.3,
              );

    final Widget countryCode =
        Text(
      state.effectiveCountryCode,
      style:
          TextStyle(
        color:
            finalTextColor,
        fontSize:
            decoration.fontSize - 1,
        fontWeight:
            FontWeight.w700,
      ),
    );

    final Widget chevron =
        geo.translateChevron(
      glass.buildInputActionIcon(
        icon:
            Icons.keyboard_arrow_down_rounded,
        isFocused:
            hasFocus,
        enabled:
            canOpen,
        onTap: canOpen
            ? () {
                _handleCountryTap(
                  context,
                  widget,
                  state,
                );
              }
            : null,
        hasError:
            hasError,
        customColor:
            iconColor,
        availableHeight:
            widget.fieldHeight,
        bubbleRatio:
            0.50,
        iconRatio:
            0.66,
        showGlow:
            false,
      ),
    );

    return Row(
      mainAxisSize:
          MainAxisSize.min,
      crossAxisAlignment:
          CrossAxisAlignment.center,
      children: [
        bubble,

        const SizedBox(
          width: 8,
        ),

        GestureDetector(
          behavior:
              HitTestBehavior.opaque,
          onTap: canOpen
              ? () {
                  _handleCountryTap(
                    context,
                    widget,
                    state,
                  );
                }
              : null,
          child: Row(
            mainAxisSize:
                MainAxisSize.min,
            crossAxisAlignment:
                CrossAxisAlignment.center,
            children: [
              countryCode,

              const SizedBox(
                width: 8,
              ),

              Container(
                width: 1,
                height:
                    GlassInputUtils
                        .separatorHeight(
                  bubbleSize,
                ),
                color:
                    separatorColor,
              ),

              const SizedBox(
                width: 4,
              ),

              chevron,
            ],
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // COUNTRY TAP
  // ===========================================================================

  Future<void> _handleCountryTap(
    BuildContext context,
    UniversalGlassPhoneInput widget,
    UniversalGlassPhoneInputState state,
  ) async {
    if (!widget.enabled ||
        widget.readOnly ||
        !widget.countryPickerEnabled) {
      return;
    }

    FocusScope.of(context).unfocus();

    final PhoneCountry? currentCountry =
        state.effectiveCountry;

    if (widget.onCountryTap != null &&
        currentCountry != null) {
      widget.onCountryTap!(
        currentCountry,
      );
      return;
    }

    try {
      final PhoneCountryRegistry registry =
          await state.registryFuture;

      if (!context.mounted) {
        return;
      }

      final GlassLayoutContext glass =
          context.watchGlassContext;

      final List<PhoneCountry> countries =
          widget.countries ??
          registry.all();

      final PhoneCountry? selected =
          await PhoneCountryPicker.show(
        context: context,
        countries: countries,
        palette: glass.palette,
        selectedCountry:
            currentCountry,
        title:
            widget.countryPickerTitle,
        subtitle:
            widget.countryPickerSubtitle,
      );

      if (selected == null ||
          !context.mounted) {
        return;
      }

      state.selectCountry(
        selected,
      );
    } catch (error, stackTrace) {
      debugPrint(
        'UniversalGlassPhoneInput: '
        'erreur country picker => $error',
      );

      debugPrintStack(
        stackTrace: stackTrace,
      );
    }
  }

  // ===========================================================================
  // FLAG
  // ===========================================================================

  Widget _buildCountryFlag({
    required UniversalGlassPhoneInputState state,
    double size = 22,
  }) {
    final String? asset =
        state.effectiveFlagAsset;

    if (asset != null &&
        asset.trim().isNotEmpty) {
      return ClipRRect(
        borderRadius:
            BorderRadius.circular(4),
        child: Image.asset(
          asset,
          package:
              'universal_glass',
          width: size,
          height:
              size * 0.60,
          fit: BoxFit.cover,
          cacheWidth:
              (size * 2.4).toInt(),
          errorBuilder:
              (
            BuildContext context,
            Object error,
            StackTrace? stackTrace,
          ) {
            return Text(
              state.effectiveCountryFlag,
              style:
                  TextStyle(
                fontSize: size,
                height: 1,
              ),
            );
          },
        ),
      );
    }

    return Text(
      state.effectiveCountryFlag,
      textAlign:
          TextAlign.center,
      style:
          TextStyle(
        fontSize: size,
        height: 1,
      ),
    );
  }
}

// ============================================================================
// NOTCH PAINTER
// ============================================================================
//
// Purement visuel.
//
// Aucun clipping.
// Aucun CustomClipper.
// Aucune interception du hit-test.
//
// Le TextFormField reste indépendant.
// ============================================================================

class _PhoneInputNotchPainter
    extends CustomPainter {
  final double notchStart;
  final double notchWidth;
  final Color color;
  final Color borderColor;
  final double borderWidth;
  final BorderRadius borderRadius;

  const _PhoneInputNotchPainter({
    required this.notchStart,
    required this.notchWidth,
    required this.color,
    required this.borderColor,
    required this.borderWidth,
    required this.borderRadius,
  });

  @override
void paint(
  Canvas canvas,
  Size size,
) {
  const double notchDepth = 6.0;
  const double notchRadius = 4.0;

  const double notchInset = 2.0;

  final double start =
      (notchStart + notchInset).clamp(
    notchRadius,
    size.width - notchRadius,
  );

  final double end =
      (start + notchWidth).clamp(
    start + notchRadius,
    size.width - notchRadius,
  );

  final Path path = Path();

  path.moveTo(
    start - notchRadius,
    0,
  );

  path.quadraticBezierTo(
    start,
    0,
    start,
    notchRadius,
  );

  path.lineTo(
    start,
    notchDepth - notchRadius,
  );

  path.quadraticBezierTo(
    start,
    notchDepth,
    start + notchRadius,
    notchDepth,
  );

  path.lineTo(
    end - notchRadius,
    notchDepth,
  );

  path.quadraticBezierTo(
    end,
    notchDepth,
    end,
    notchDepth - notchRadius,
  );

  path.lineTo(
    end,
    notchRadius,
  );

  path.quadraticBezierTo(
    end,
    0,
    end + notchRadius,
    0,
  );

  path.close();

  // -------------------------------------------------------------------------
  // FOND
  // -------------------------------------------------------------------------

  final Paint backgroundPaint = Paint()
    ..style = PaintingStyle.fill
    ..color = color;

  canvas.drawPath(
    path,
    backgroundPaint,
  );

  // -------------------------------------------------------------------------
  // BORDURE
  // -------------------------------------------------------------------------

  final Path borderPath = Path();

  borderPath.moveTo(
    start - notchRadius,
    0,
  );

  borderPath.quadraticBezierTo(
    start,
    0,
    start,
    notchRadius,
  );

  borderPath.lineTo(
    start,
    notchDepth - notchRadius,
  );

  borderPath.quadraticBezierTo(
    start,
    notchDepth,
    start + notchRadius,
    notchDepth,
  );

  borderPath.lineTo(
    end - notchRadius,
    notchDepth,
  );

  borderPath.quadraticBezierTo(
    end,
    notchDepth,
    end,
    notchDepth - notchRadius,
  );

  borderPath.lineTo(
    end,
    notchRadius,
  );

  borderPath.quadraticBezierTo(
    end,
    0,
    end + notchRadius,
    0,
  );

  final Paint borderPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = borderWidth
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round
    ..color = borderColor;

  canvas.drawPath(
    borderPath,
    borderPaint,
  );
}

  @override
  bool shouldRepaint(
    covariant _PhoneInputNotchPainter oldDelegate,
  ) {
    return oldDelegate.notchStart !=
            notchStart ||
        oldDelegate.notchWidth !=
            notchWidth ||
        oldDelegate.color !=
            color ||
        oldDelegate.borderColor !=
            borderColor ||
        oldDelegate.borderWidth !=
            borderWidth ||
        oldDelegate.borderRadius !=
            borderRadius;
  }
}




// ============================================================================
// OBSERVATEUR LOCAL
// ============================================================================

class _PhoneInputVisualBuilder
    extends StatefulWidget {
  final FocusNode focusNode;
  final TextEditingController controller;

  final Widget Function(
    BuildContext context,
    bool hasFocus,
    bool hasText,
  ) builder;

  const _PhoneInputVisualBuilder({
    required this.focusNode,
    required this.controller,
    required this.builder,
  });

  @override
  State<_PhoneInputVisualBuilder>
      createState() =>
          _PhoneInputVisualBuilderState();
}

class _PhoneInputVisualBuilderState
    extends State<_PhoneInputVisualBuilder> {
  late bool _hasFocus;
  late bool _hasText;

  @override
  void initState() {
    super.initState();

    _hasFocus =
        widget.focusNode.hasFocus;

    _hasText =
        widget.controller.text.isNotEmpty;

    widget.focusNode.addListener(
      _handleFocusChanged,
    );

    widget.controller.addListener(
      _handleTextChanged,
    );
  }

  @override
  void didUpdateWidget(
    covariant _PhoneInputVisualBuilder oldWidget,
  ) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.focusNode !=
        widget.focusNode) {
      oldWidget.focusNode.removeListener(
        _handleFocusChanged,
      );

      _hasFocus =
          widget.focusNode.hasFocus;

      widget.focusNode.addListener(
        _handleFocusChanged,
      );
    }

    if (oldWidget.controller !=
        widget.controller) {
      oldWidget.controller.removeListener(
        _handleTextChanged,
      );

      _hasText =
          widget.controller.text.isNotEmpty;

      widget.controller.addListener(
        _handleTextChanged,
      );
    }
  }

  void _handleFocusChanged() {
    if (!mounted) {
      return;
    }

    final bool value =
        widget.focusNode.hasFocus;

    if (_hasFocus == value) {
      return;
    }

    setState(() {
      _hasFocus = value;
    });
  }

  void _handleTextChanged() {
    if (!mounted) {
      return;
    }

    final bool value =
        widget.controller.text.isNotEmpty;

    if (_hasText == value) {
      return;
    }

    setState(() {
      _hasText = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(
      context,
      _hasFocus,
      _hasText,
    );
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(
      _handleFocusChanged,
    );

    widget.controller.removeListener(
      _handleTextChanged,
    );

    super.dispose();
  }
}
