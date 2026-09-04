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
                //
                // TEST 20 :
                //
                // La surface est uniquement visuelle.
                //
                // Aucun onTap.
                // Aucun GestureDetector global.
                // Aucun FocusNode manipulé ici.
                //
                // =================================================================

                GlassNotchShadowWrapper(
                  clipper: null,
                  isShadowEnabled: false,
                  shadowOpacity: 0,
                  elevation: 0,
                  borderRadius: borderRadius,
                  child: GlassSurfaceContainer(
                    decoration: decoration,
                    style:
                        glass.effectiveGlassStyle,
                    shape: widget.shape,
                    width: widget.width,
                    height:
                        widget.fieldHeight,
                    borderRadius:
                        borderRadius,

                    onTap: null,

                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 14,
                    ),

                    liftOnHover:
                        !hasFocus,

                    disableShadow:
                        true,

                    clipBehavior:
                        Clip.none,

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
                        ),

                        const SizedBox(
                          width: 12,
                        ),

                        // =========================================================
                        // TEXT FIELD
                        // =========================================================
                        //
                        // TEST 20 :
                        //
                        // C'est le seul élément qui reçoit les clics du texte.
                        //
                        // =========================================================

                        Expanded(
                          child:
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
                                      ? Colors.white
                                      : Colors.white
                                          .withValues(
                                          alpha: 0.35,
                                        ),
                              fontSize:
                                  decoration
                                      .fontSize,
                              fontWeight:
                                  decoration
                                      .fontWeight,
                            ),

                            cursorColor:
                                focusColor,

                            // -----------------------------------------------------
                            // IMPORTANT
                            // -----------------------------------------------------
                            //
                            // Aucun requestFocus().
                            //
                            // Flutter gère le focus nativement.
                            //
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

                              // ---------------------------------------------------
                              // HINT
                              // ---------------------------------------------------
                              //
                              // Visible uniquement avec focus.
                              //
                              hintText:
                                  hasFocus
                                      ? state
                                          .effectiveHintText
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

                              errorText:
                                  null,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // =================================================================
                // LABEL
                // =================================================================
                //
                // IMPORTANT :
                //
                // IgnorePointer garantit que le label ne peut JAMAIS intercepter
                // le clic destiné au TextFormField.
                //
                // =================================================================

                Positioned(
                  top: isFloating
                      ? -8.5
                      : geo.labelTopAtRest,

                  left:
                      geo.getLabelLeft(
                    isFloating,
                  ),

                  child: IgnorePointer(
                    ignoring: true,
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

                        style:
                            TextStyle(
                          color:
                              hasError
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

                          letterSpacing:
                              0.2,

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
      style: TextStyle(
        color:
            finalTextColor,
        fontSize:
            decoration.fontSize - 1,
        fontWeight:
            FontWeight.w700,
      ),
    );

    final Widget chevron =
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
              style: TextStyle(
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
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: size,
        height: 1,
      ),
    );
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
