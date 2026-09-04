
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:universal_glass/components/inputs/universal_glass_phone_input.dart';
import 'package:universal_glass/components/inputs/phone/universal_glass_phone_input_state.dart';
import 'package:universal_glass/components/surface/glass_surface_container.dart';
import 'package:universal_glass/utils/glass_layout_calibrator.dart';

/// ============================================================================
/// TEST 18
/// ============================================================================
///
/// Objectif :
///
/// Remplacer complètement :
///
///   ClipPath
///   NotchClipper
///   GlassNotchShadowWrapper
///
/// par :
///
///   CustomPaint
///
/// Le CustomPainter ne découpe rien.
/// Il dessine uniquement le notch.
/// Le TextFormField reste dans une hiérarchie normale.
///
class UniversalGlassPhoneInputView extends ConsumerWidget {
  final UniversalGlassPhoneInputState state;

  const UniversalGlassPhoneInputView({
    super.key,
    required this.state,
  });

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final UniversalGlassPhoneInput widget =
        state.widget;

    final GlassLayoutCalibrator geo =
        GlassLayoutCalibrator(
      fieldHeight: widget.fieldHeight,
      fontSize: widget.decoration.fontSize,
      hasPrefixIcon: true,
    );

    final bool hasError =
        state.errorText != null &&
        state.errorText!.trim().isNotEmpty;

    return _PhoneInputVisualBuilder(
      focusNode: state.focusNode,
      controller: state.controller,
      builder: (
        BuildContext context,
        bool hasFocus,
        bool hasText,
      ) {
        final bool isFloating =
            hasFocus || hasText;

        return Opacity(
          opacity:
              widget.enabled ? 1.0 : 0.65,
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            mainAxisSize:
                MainAxisSize.min,
            children: [
              Stack(
                clipBehavior:
                    Clip.none,
                children: [
                  // ==========================================================
                  // SURFACE
                  // ==========================================================

                  GlassSurfaceContainer(
                    decoration:
                        widget.decoration,
                    style:
                        widget.style,
                    shape:
                        widget.shape,
                    width:
                        widget.width,
                    height:
                        widget.fieldHeight,
                    borderRadius:
                        BorderRadius.circular(
                      widget.decoration
                          .borderRadius,
                    ),
                    onTap: null,
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 14,
                    ),
                    liftOnHover:
                        false,
                    disableShadow:
                        true,
                    clipBehavior:
                        Clip.none,

                    child: Row(
                      crossAxisAlignment:
                          CrossAxisAlignment.center,
                      children: [
                        // ====================================================
                        // PAYS
                        // ====================================================

                        const SizedBox(
                          width: 45,
                          child: Center(
                            child: Text(
                              '🇧🇫',
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(
                          width: 8,
                        ),

                        // ====================================================
                        // CHAMP
                        // ====================================================

                        Expanded(
                          child: TextFormField(
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

                            keyboardType:
                                TextInputType.phone,

                            textInputAction:
                                widget.textInputAction,

                            inputFormatters:
                                state.inputFormatters,

                            onChanged:
                                state.handleChanged,

                            onTap:
                                widget.onTap,

                            onFieldSubmitted:
                                state.handleSubmitted,

                            validator:
                                widget.validator,

                            autovalidateMode:
                                widget.autovalidateMode,

                            decoration:
                                InputDecoration(
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

                              isDense:
                                  true,

                              contentPadding:
                                  EdgeInsets.zero,

                              labelText:
                                  null,

                              hintText:
                                  isFloating
                                      ? state
                                          .effectiveHintText
                                      : null,

                              hintStyle:
                                  TextStyle(
                                fontSize: 15,
                                color: Colors.white
                                    .withValues(
                                  alpha: 0.35,
                                ),
                              ),
                            ),
                          ),
                        ),

                        // ====================================================
                        // SUFFIX
                        // ====================================================

                        if (widget.suffixIcon != null &&
                            state.controller
                                .text
                                .isNotEmpty)
                          GestureDetector(
                            behavior:
                                HitTestBehavior.opaque,
                            onTap:
                                state.handleSuffixTap,
                            child: SizedBox(
                              width: 40,
                              height: 40,
                              child: Icon(
                                widget.suffixIcon,
                                size: 20,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  // ==========================================================
                  // NOTCH VISUEL
                  // ==========================================================
                  //
                  // IMPORTANT :
                  //
                  // CustomPaint dessine seulement.
                  //
                  // Il n'y a :
                  //
                  // - aucun ClipPath
                  // - aucun CustomClipper
                  // - aucun wrapper
                  // - aucun hit-test
                  //
                  // IgnorePointer est ajouté par sécurité.
                  // ==========================================================

                  if (isFloating)
                    Positioned.fill(
                      child: IgnorePointer(
                        child: CustomPaint(
                          painter:
                              _PhoneInputNotchPainter(
                            notchStart:
                                geo.notchStart,
                            notchWidth:
                                _labelWidth(
                              widget.label,
                              10.5,
                            ),
                            borderColor:
                                hasError
                                    ? widget
                                        .decoration
                                        .errorColor
                                    : hasFocus
                                        ? _focusColor(
                                            context,
                                          )
                                        : Colors.white
                                            .withValues(
                                            alpha:
                                                0.25,
                                          ),
                            borderWidth:
                                1.0,
                            radius:
                                widget.decoration
                                    .borderRadius,
                          ),
                        ),
                      ),
                    ),

                  // ==========================================================
                  // LABEL
                  // ==========================================================

                  if (isFloating)
                    Positioned(
                      left:
                          geo.getLabelLeft(
                        true,
                      ),
                      top:
                          -8.5,
                      child:
                          IgnorePointer(
                        child:
                            _buildFloatingLabel(
                          context:
                              context,
                          widget:
                              widget,
                          hasFocus:
                              hasFocus,
                          hasError:
                              hasError,
                        ),
                      ),
                    ),
                ],
              ),

              // =============================================================
              // ERROR
              // =============================================================

              if (hasError &&
                  widget.enabled)
                Padding(
                  padding:
                      const EdgeInsets.only(
                    top: 6,
                    left: 14,
                  ),
                  child: Text(
                    state.errorText!,
                    style: TextStyle(
                      color: widget
                          .decoration
                          .errorColor,
                      fontSize: 12,
                      fontWeight:
                          FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  // ==========================================================================
  // LABEL
  // ==========================================================================

  Widget _buildFloatingLabel({
    required BuildContext context,
    required UniversalGlassPhoneInput widget,
    required bool hasFocus,
    required bool hasError,
  }) {
    final Color color =
        hasError
            ? widget.decoration.errorColor
            : hasFocus
                ? _focusColor(context)
                : Colors.white.withValues(
                    alpha:
                        widget.enabled
                            ? 0.60
                            : 0.20,
                  );

    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 5,
      ),
      color: Colors.transparent,
      child: Text(
        widget.label,
        style: TextStyle(
          color: color,
          fontSize: 10.5,
          fontWeight:
              FontWeight.w700,
          letterSpacing: 0.2,
          height: 1.0,
        ),
      ),
    );
  }

  // ==========================================================================
  // COULEUR FOCUS
  // ==========================================================================

  Color _focusColor(
    BuildContext context,
  ) {
    /*
     * Pour le test, on utilise une couleur
     * stable et indépendante du thème.
     */
    return Colors.cyanAccent;
  }

  // ==========================================================================
  // LARGEUR LABEL
  // ==========================================================================

  double _labelWidth(
    String text,
    double fontSize,
  ) {
    final TextPainter painter =
        TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight:
              FontWeight.w700,
          letterSpacing: 0.2,
        ),
      ),
      textDirection:
          TextDirection.ltr,
      maxLines: 1,
    )..layout();

    return painter.width + 10;
  }
}

// ============================================================================
// PAINTER DU NOTCH
// ============================================================================
//
// IMPORTANT :
//
// Ce painter NE CLIPPE PAS le widget.
//
// Il dessine simplement une ligne qui reproduit visuellement
// le contour supérieur du notch.
//
// Le TextFormField reste complètement indépendant.
// ============================================================================

class _PhoneInputNotchPainter
    extends CustomPainter {
  final double notchStart;
  final double notchWidth;

  final Color borderColor;
  final double borderWidth;

  final double radius;

  const _PhoneInputNotchPainter({
    required this.notchStart,
    required this.notchWidth,
    required this.borderColor,
    required this.borderWidth,
    required this.radius,
  });

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    const double notchDepth = 6.0;
    const double notchRadius = 4.0;

    if (size.width <= 0 ||
        size.height <= 0) {
      return;
    }

    final double start =
        notchStart.clamp(
      notchRadius,
      size.width - notchRadius,
    );

    final double rawEnd =
        start + notchWidth;

    final double end =
        rawEnd.clamp(
      start + notchRadius,
      size.width - notchRadius,
    );

    final Paint paint =
        Paint()
          ..style =
              PaintingStyle.stroke
          ..strokeWidth =
              borderWidth
          ..color =
              borderColor
          ..strokeCap =
              StrokeCap.round
          ..strokeJoin =
              StrokeJoin.round;

    final Path path =
        Path();

    // ========================================================================
    // LIGNE SUPÉRIEURE GAUCHE
    // ========================================================================

    path.moveTo(
      0,
      0.5,
    );

    path.lineTo(
      start - notchRadius,
      0.5,
    );

    // ========================================================================
    // DESCENTE GAUCHE
    // ========================================================================

    path.quadraticBezierTo(
      start,
      0.5,
      start,
      notchRadius,
    );

    path.lineTo(
      start,
      notchDepth -
          notchRadius,
    );

    // ========================================================================
    // BAS GAUCHE
    // ========================================================================

    path.quadraticBezierTo(
      start,
      notchDepth,
      start + notchRadius,
      notchDepth,
    );

    // ========================================================================
    // FOND DU NOTCH
    // ========================================================================

    path.lineTo(
      end - notchRadius,
      notchDepth,
    );

    // ========================================================================
    // BAS DROIT
    // ========================================================================

    path.quadraticBezierTo(
      end,
      notchDepth,
      end,
      notchDepth -
          notchRadius,
    );

    // ========================================================================
    // REMONTÉE DROITE
    // ========================================================================

    path.lineTo(
      end,
      notchRadius,
    );

    path.quadraticBezierTo(
      end,
      0.5,
      end + notchRadius,
      0.5,
    );

    // ========================================================================
    // LIGNE SUPÉRIEURE DROITE
    // ========================================================================

    path.lineTo(
      size.width,
      0.5,
    );

    canvas.drawPath(
      path,
      paint,
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
        oldDelegate.borderColor !=
            borderColor ||
        oldDelegate.borderWidth !=
            borderWidth ||
        oldDelegate.radius !=
            radius;
  }
}

// ============================================================================
// BUILDER LOCAL
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
    extends State<
        _PhoneInputVisualBuilder> {
  bool _hasFocus = false;
  bool _hasText = false;

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
    super.didUpdateWidget(
      oldWidget,
    );

    if (oldWidget.focusNode !=
        widget.focusNode) {
      oldWidget.focusNode
          .removeListener(
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
      oldWidget.controller
          .removeListener(
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
    final bool value =
        widget.focusNode.hasFocus;

    if (_hasFocus == value) {
      return;
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _hasFocus = value;
    });
  }

  void _handleTextChanged() {
    final bool value =
        widget.controller.text.isNotEmpty;

    if (_hasText == value) {
      return;
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _hasText = value;
    });
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return widget.builder(
      context,
      _hasFocus,
      _hasText,
    );
  }

  @override
  void dispose() {
    widget.focusNode
        .removeListener(
      _handleFocusChanged,
    );

    widget.controller
        .removeListener(
      _handleTextChanged,
    );

    super.dispose();
  }
}
