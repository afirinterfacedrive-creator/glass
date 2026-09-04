
import 'package:flutter/material.dart';
import 'package:universal_glass/components/inputs/fieldoutlined/outlined_field_decoration.dart';
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

    return _PhoneInputFocusObserver(
      focusNode: state.focusNode,
      controller: state.controller,
      builder: (
        BuildContext context,
        bool hasFocus,
        bool hasText,
      ) {
        final bool isFloating = hasFocus || hasText;

        return _buildContent(
          context: context,
          widget: widget,
          state: state,
          hasFocus: hasFocus,
          hasText: hasText,
          isFloating: isFloating,
        );
      },
    );
  }

  Widget _buildContent({
    required BuildContext context,
    required UniversalGlassPhoneInput widget,
    required UniversalGlassPhoneInputState state,
    required bool hasFocus,
    required bool hasText,
    required bool isFloating,
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

    final GlassLayoutCalibrator geo =
        GlassLayoutCalibrator(
      fieldHeight: widget.fieldHeight,
      fontSize: decoration.fontSize,
      hasPrefixIcon: true,
    );

    final BorderRadius borderRadius =
        BorderRadius.circular(
      decoration.borderRadius,
    );

    final NotchClipper? notchClipper =
        isFloating
            ? NotchClipper(
                notchStart: geo.notchStart,
                notchWidth:
                    geo.getLabelWidth(widget.label),
              )
            : null;

    return Opacity(
      opacity: widget.enabled ? 1.0 : 0.65,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              GlassNotchShadowWrapper(
                clipper: notchClipper,
                isShadowEnabled:
                    isFloating &&
                    glass.theme.enableShadow,
                shadowOpacity:
                    glass.theme.shadowOpacity,
                elevation: 6,
                borderRadius: borderRadius,
                child: GlassSurfaceContainer(
                  decoration: decoration,
                  style: glass.effectiveGlassStyle,
                  shape: widget.shape,
                  width: widget.width,
                  height: widget.fieldHeight,
                  borderRadius: borderRadius,
                  onTap: null,
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 14,
                  ),
                  liftOnHover: !hasFocus,
                  disableShadow: true,
                  clipBehavior: Clip.none,
                  child: Row(
                    crossAxisAlignment:
                        CrossAxisAlignment.center,
                    children: [
                      _buildCountrySelector(
                        context: context,
                        widget: widget,
                        state: state,
                        decoration: decoration,
                        glass: glass,
                        hasFocus: hasFocus,
                        hasError: hasError,
                        focusColor: focusColor,
                      ),

                      const SizedBox(width: 12),

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

                          autofocus: false,

                          showCursor: true,

                          keyboardType:
                              TextInputType.phone,

                          textInputAction:
                              widget.textInputAction,

                          textAlignVertical:
                              TextAlignVertical.center,

                          inputFormatters:
                              state.inputFormatters,

                          style: TextStyle(
                            color: widget.enabled
                                ? Colors.white
                                : Colors.white.withValues(
                                    alpha: 0.35,
                                  ),
                            fontSize:
                                decoration.fontSize,
                            fontWeight:
                                decoration.fontWeight,
                          ),

                          cursorColor:
                              focusColor,

                          onTap:
                              widget.onTap,

                          onChanged:
                              state.handleChanged,

                          onFieldSubmitted:
                              state.handleSubmitted,

                          decoration:
                              InputDecoration(
                            isDense: true,

                            // --------------------------------------------------
                            // TEST 19
                            //
                            // Le hint n'est visible que lorsque le champ
                            // possède réellement le focus.
                            //
                            // Le label est indépendant du hint.
                            // --------------------------------------------------
                            hintText: hasFocus
                                ? state.effectiveHintText
                                : null,

                            hintStyle:
                                TextStyle(
                              color:
                                  Colors.white
                                      .withValues(
                                alpha: 0.35,
                              ),
                              fontSize:
                                  geo.hintFontSize,
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

                            errorText: null,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ---------------------------------------------------------------
              // LABEL
              // ---------------------------------------------------------------

              AnimatedPositioned(
                duration:
                    const Duration(
                  milliseconds: 180,
                ),
                curve:
                    Curves.easeInOutQuad,

                top: isFloating
                    ? -8.5
                    : geo.labelTopAtRest,

                left:
                    geo.getLabelLeft(
                  isFloating,
                ),

                child: IgnorePointer(
                  child: AnimatedOpacity(
                    duration:
                        const Duration(
                      milliseconds: 140,
                    ),

                    opacity:
                        isFloating ? 1.0 : 0.0,

                    child:
                        AnimatedDefaultTextStyle(
                      duration:
                          const Duration(
                        milliseconds: 180,
                      ),

                      style: TextStyle(
                        color: hasError
                            ? decoration
                                .errorColor
                            : focusColor,

                        fontSize:
                            isFloating
                                ? 10.5
                                : decoration
                                    .fontSize,

                        fontWeight:
                            isFloating
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
              ),
            ],
          ),

          if (hasError && widget.enabled)
            Padding(
              padding:
                  const EdgeInsets.only(
                top: 6,
                left: 14,
              ),
              child: Text(
                state.errorText!,
                style: TextStyle(
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

  Widget _buildCountrySelector({
    required BuildContext context,
    required UniversalGlassPhoneInput widget,
    required UniversalGlassPhoneInputState state,
    required GlassInputDecoration decoration,
    required GlassLayoutContext glass,
    required bool hasFocus,
    required bool hasError,
    required Color focusColor,
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
      fieldHeight: widget.fieldHeight,
      ratio: 0.6,
    );

    final Widget bubble =
        glass.buildInputBubble(
      child: Text(
        state.effectiveCountryFlag,
        style: TextStyle(
          fontSize:
              GlassInputUtils.iconSize(
            bubbleSize: bubbleSize,
          ),
        ),
      ),
      fieldHeight:
          widget.fieldHeight,
      isFocused: hasFocus,
      enabled: canOpen,
      onTap: canOpen
          ? () {
              _handleCountryTap(
                context,
                widget,
                state,
              );
            }
          : null,
      iconColor: iconColor,
    );

    final Widget countryCode = Text(
      state.effectiveCountryCode,
      style: TextStyle(
        color: !widget.enabled
            ? decoration.textColor.withValues(
                alpha: 0.40,
              )
            : hasFocus
                ? focusColor
                : decoration.textColor,
        fontSize:
            decoration.fontSize - 1,
        fontWeight:
            FontWeight.w700,
      ),
    );

    final Widget chevron =
        glass.buildInputActionIcon(
      icon: Icons.keyboard_arrow_down_rounded,
      isFocused: hasFocus,
      enabled: canOpen,
      onTap: canOpen
          ? () {
              _handleCountryTap(
                context,
                widget,
                state,
              );
            }
          : null,
      hasError: hasError,
      customColor: iconColor,
      availableHeight:
          widget.fieldHeight,
      bubbleRatio: 0.50,
      iconRatio: 0.66,
      showGlow: false,
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment:
          CrossAxisAlignment.center,
      children: [
        bubble,

        const SizedBox(width: 8),

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
            mainAxisSize: MainAxisSize.min,
            children: [
              countryCode,

              const SizedBox(width: 8),

              Container(
                width: 1,
                height:
                    GlassInputUtils.separatorHeight(
                  bubbleSize,
                ),
                color: hasFocus
                    ? focusColor.withValues(
                        alpha: 0.4,
                      )
                    : glass.palette.border
                        .withValues(
                      alpha: 0.3,
                    ),
              ),

              const SizedBox(width: 4),

              chevron,
            ],
          ),
        ),
      ],
    );
  }

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
      widget.onCountryTap!(currentCountry);
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

      state.selectCountry(selected);
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
}

// ============================================================================
// OBSERVATEUR LOCAL
// ============================================================================

class _PhoneInputFocusObserver
    extends StatefulWidget {
  final FocusNode focusNode;
  final TextEditingController controller;

  final Widget Function(
    BuildContext context,
    bool hasFocus,
    bool hasText,
  ) builder;

  const _PhoneInputFocusObserver({
    required this.focusNode,
    required this.controller,
    required this.builder,
  });

  @override
  State<_PhoneInputFocusObserver> createState() =>
      _PhoneInputFocusObserverState();
}

class _PhoneInputFocusObserverState
    extends State<_PhoneInputFocusObserver> {
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
      _onFocusChanged,
    );

    widget.controller.addListener(
      _onTextChanged,
    );
  }

  @override
  void didUpdateWidget(
    covariant _PhoneInputFocusObserver oldWidget,
  ) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.focusNode !=
        widget.focusNode) {
      oldWidget.focusNode.removeListener(
        _onFocusChanged,
      );

      _hasFocus =
          widget.focusNode.hasFocus;

      widget.focusNode.addListener(
        _onFocusChanged,
      );
    }

    if (oldWidget.controller !=
        widget.controller) {
      oldWidget.controller.removeListener(
        _onTextChanged,
      );

      _hasText =
          widget.controller.text.isNotEmpty;

      widget.controller.addListener(
        _onTextChanged,
      );
    }
  }

  void _onFocusChanged() {
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

  void _onTextChanged() {
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
      _onFocusChanged,
    );

    widget.controller.removeListener(
      _onTextChanged,
    );

    super.dispose();
  }
}
