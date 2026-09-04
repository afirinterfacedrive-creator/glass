import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:universal_glass/components/inputs/fieldoutlined/outlined_field_decoration.dart';
import 'package:universal_glass/components/inputs/glass_input_decoration.dart';
import 'package:universal_glass/components/inputs/universal_glass_phone_input.dart';
import 'package:universal_glass/components/surface/glass_notch_shadow_wrapper.dart';
import 'package:universal_glass/components/surface/glass_surface_container.dart';
import 'package:universal_glass/phone/phone_country.dart';
import 'package:universal_glass/phone/phone_country_picker.dart';
import 'package:universal_glass/phone/phone_country_registry.dart';
import 'package:universal_glass/theme/glass_color_palette.dart';
import 'package:universal_glass/utils/glass_input_utils.dart';
import 'package:universal_glass/utils/glass_layout_calibrator.dart';
import 'package:universal_glass/utils/glass_theme_extension.dart';

import 'universal_glass_phone_input_state.dart';

/// ============================================================================
/// VUE DU PHONE INPUT
/// ============================================================================
///
/// Responsabilités :
/// - rendu visuel ;
/// - GlassSurfaceContainer ;
/// - TextFormField ;
/// - sélecteur de pays ;
/// - label flottant ;
/// - message d'erreur.
///
/// Le State principal reste responsable de :
/// - controller ;
/// - FocusNode ;
/// - pays courant ;
/// - validation ;
/// - formatage ;
/// - callbacks métier.
///
/// IMPORTANT POUR LE CURSEUR
/// -------------------------
///
/// Le changement de focus ne doit PAS provoquer un setState() sur
/// UniversalGlassPhoneInputState.
///
/// Le focus et le texte sont donc observés localement par
/// _PhoneInputVisualBuilder.
///
/// Cela permet de conserver le TextFormField / EditableText stable
/// lorsque le focus change.
///
/// Aucun GestureDetector global autour du champ.
/// Aucun requestFocus() manuel dans onTap.
/// Aucun Transform autour du TextFormField.
/// Aucun ClipPath autour du TextFormField.
///
class UniversalGlassPhoneInputView extends ConsumerWidget {
  final UniversalGlassPhoneInputState state;

  const UniversalGlassPhoneInputView({
    super.key,
    required this.state,
  });

  // ==========================================================================
  // BUILD
  // ==========================================================================

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final UniversalGlassPhoneInput widget =
        state.widget;

    final GlassLayoutContext glass =
        ref.watchGlassContext(context);

    final bool hasError =
        state.errorText != null &&
        state.errorText!.trim().isNotEmpty;

    final GlassInputDecoration effectiveDecoration =
        glass.inputDecoration(
      hasError: hasError,
      isFocused: state.focusNode.hasFocus,
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
      fontSize: effectiveDecoration.fontSize,
      hasPrefixIcon: true,
    );

    // =========================================================================
    // OBSERVATION LOCALE
    // =========================================================================
    //
    // Très important :
    //
    // Le State principal ne reconstruit plus toute la View lorsque le focus
    // change.
    //
    // Ce petit widget écoute uniquement :
    //
    // - FocusNode
    // - TextEditingController
    //
    // Ainsi :
    //
    // focus -> rebuild local
    // texte -> rebuild local
    //
    // tandis que le State parent de UniversalGlassPhoneInput reste stable.
    // =========================================================================

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
                  _buildGlassField(
                    context: context,
                    widget: widget,
                    state: state,
                    decoration:
                        effectiveDecoration,
                    focusColor:
                        focusColor,
                    glass: glass,
                    geo: geo,
                    hasError:
                        hasError,
                    hasFocus:
                        hasFocus,
                    isFloating:
                        isFloating,
                  ),

                  _buildFloatingLabel(
                    widget: widget,
                    decoration:
                        effectiveDecoration,
                    focusColor:
                        focusColor,
                    geo: geo,
                    hasError:
                        hasError,
                    isFloating:
                        isFloating,
                  ),
                ],
              ),

              if (hasError &&
                  widget.enabled)
                _buildError(
                  state: state,
                  decoration:
                      effectiveDecoration,
                ),
            ],
          ),
        );
      },
    );
  }

  // ==========================================================================
  // GLASS FIELD
  // ==========================================================================

  Widget _buildGlassField({
    required BuildContext context,
    required UniversalGlassPhoneInput widget,
    required UniversalGlassPhoneInputState state,
    required GlassInputDecoration decoration,
    required Color focusColor,
    required GlassLayoutContext glass,
    required GlassLayoutCalibrator geo,
    required bool hasError,
    required bool hasFocus,
    required bool isFloating,
  }) {
    final NotchClipper? notchClipper =
        isFloating
            ? NotchClipper(
                notchStart:
                    geo.notchStart,
                notchWidth:
                    geo.getLabelWidth(
                  widget.label,
                ),
              )
            : null;

    final Widget interactiveContent =
        _buildInteractiveContent(
      context: context,
      widget: widget,
      state: state,
      decoration: decoration,
      focusColor: focusColor,
      glass: glass,
      geo: geo,
      hasError: hasError,
      hasFocus: hasFocus,
    );

    final BorderRadius borderRadius =
        BorderRadius.circular(
      decoration.borderRadius,
    );

    return GlassNotchShadowWrapper(
      clipper: notchClipper,
      isShadowEnabled:
          isFloating &&
          glass.theme.enableShadow,
      shadowOpacity:
          glass.theme.shadowOpacity,
      elevation: 6.0,
      borderRadius: borderRadius,
      child: GlassSurfaceContainer(
        decoration: decoration,
        style: glass.effectiveGlassStyle,
        shape: widget.shape,
        width: widget.width,
        height: widget.fieldHeight,
        borderRadius: borderRadius,

        // ====================================================================
        // IMPORTANT :
        //
        // GlassSurfaceContainer ne gère PAS le focus.
        // ====================================================================

        onTap: null,

        padding:
            const EdgeInsets.symmetric(
          horizontal: 14,
        ),

        // ====================================================================
        // IMPORTANT :
        //
        // On ne dépend plus de state.focusNode.hasFocus ici.
        //
        // hasFocus vient du builder local.
        // ====================================================================

        liftOnHover:
            !hasFocus,

        disableShadow: true,

        // ====================================================================
        // IMPORTANT :
        //
        // Pas de ClipPath autour du TextFormField.
        // ====================================================================

        clipBehavior:
            Clip.none,

        child: interactiveContent,
      ),
    );
  }

  // ==========================================================================
  // CONTENU INTERACTIF
  // ==========================================================================

  Widget _buildInteractiveContent({
    required BuildContext context,
    required UniversalGlassPhoneInput widget,
    required UniversalGlassPhoneInputState state,
    required GlassInputDecoration decoration,
    required Color focusColor,
    required GlassLayoutContext glass,
    required GlassLayoutCalibrator geo,
    required bool hasError,
    required bool hasFocus,
  }) {
    // ------------------------------------------------------------------------
    // COUNTRY SELECTOR
    // ------------------------------------------------------------------------

    final Widget countrySelector =
        _buildCountrySelector(
      context: context,
      widget: widget,
      state: state,
      decoration: decoration,
      contentColor:
          hasFocus
              ? focusColor
              : decoration.textColor,
      iconColor:
          hasFocus
              ? focusColor
              : decoration.iconColor,
      hasError: hasError,
      palette: glass.palette,
      focusColor: focusColor,
      glass: glass,
      hasFocus: hasFocus,
    );

    // ------------------------------------------------------------------------
    // TEXT FIELD
    // ------------------------------------------------------------------------
    //
    // IMPORTANT :
    //
    // Un seul Expanded.
    //
    // L'ancien code avait :
    //
    // Expanded(
    //   child: phoneTextField,
    // )
    //
    // alors que phoneTextField était déjà Expanded.
    //
    // Cela créait un Expanded imbriqué inutile.
    // ------------------------------------------------------------------------

    final Widget phoneTextField =
        Expanded(
      child: TextFormField(
        controller:
            state.controller,
        focusNode:
            state.focusNode,

        // ====================================================================
        // INTERACTION NATIVE FLUTTER
        // ====================================================================

        showCursor: true,

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

        textAlignVertical:
            TextAlignVertical.center,

        // ====================================================================
        // FORMATAGE
        // ====================================================================

        inputFormatters:
            state.inputFormatters,

        // ====================================================================
        // STYLE
        // ====================================================================

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

        // ====================================================================
        // TAP
        // ====================================================================
        //
        // IMPORTANT :
        //
        // Pas de requestFocus().
        //
        // Flutter gère lui-même :
        // - focus
        // - hit test
        // - position du curseur
        // - sélection
        // ====================================================================

        onTap:
            widget.onTap,

        onChanged:
            state.handleChanged,

        onFieldSubmitted:
            state.handleSubmitted,

        // ====================================================================
        // DÉCORATION
        // ====================================================================

        decoration: InputDecoration(
          isDense: true,

          hintText:
              hasFocus
                  ? state.effectiveHintText
                  : null,

          hintStyle: TextStyle(
            color:
                Colors.white.withValues(
              alpha: 0.35,
            ),
            fontSize:
                geo.hintFontSize,
          ),

          // ==================================================================
          // L'erreur est affichée à l'extérieur.
          // ==================================================================

          errorText: null,

          // ==================================================================
          // ZONE DE SAISIE
          // ==================================================================

          contentPadding:
              EdgeInsets.zero,

          // ==================================================================
          // BORDURES
          // ==================================================================

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

          // ==================================================================
          // SUFFIX ICON
          // ==================================================================
          //
          // Le controller est observé par _PhoneInputVisualBuilder.
          //
          // Donc :
          //
          // texte vide
          //      ↓
          // pas de suffixe
          //
          // texte présent
          //      ↓
          // suffixe visible
          //
          // sans setState() dans le State principal.
          // ==================================================================

          suffixIcon:
              widget.suffixIcon != null &&
                      state.controller.text.isNotEmpty
                  ? Padding(
                      padding:
                          const EdgeInsets.only(
                        left: 6,
                        right: 2,
                      ),
                      child:
                          glass.buildInputActionIcon(
                        icon:
                            widget.suffixIcon!,
                        isFocused:
                            hasFocus,
                        enabled:
                            widget.enabled,
                        onTap:
                            widget.onSuffixTap !=
                                    null
                                ? state
                                    .handleSuffixTap
                                : null,
                        hasError:
                            hasError,
                        customColor:
                            hasError
                                ? decoration
                                    .errorColor
                                : decoration
                                    .iconColor,
                        availableHeight:
                            widget.fieldHeight,
                        bubbleRatio:
                            0.60,
                        iconRatio:
                            0.66,
                        showGlow:
                            true,
                      ),
                    )
                  : null,

          suffixIconConstraints:
              const BoxConstraints(
            minWidth: 0,
            minHeight: 0,
          ),
        ),
      ),
    );

    // ------------------------------------------------------------------------
    // ROW
    // ------------------------------------------------------------------------

    return Row(
      mainAxisAlignment:
          MainAxisAlignment.start,
      crossAxisAlignment:
          CrossAxisAlignment.center,
      children: [
        countrySelector,

        const SizedBox(
          width: 12,
        ),

        phoneTextField,
      ],
    );
  }

  // ==========================================================================
  // COUNTRY SELECTOR
  // ==========================================================================

  Widget _buildCountrySelector({
    required BuildContext context,
    required UniversalGlassPhoneInput widget,
    required UniversalGlassPhoneInputState state,
    required GlassInputDecoration decoration,
    required Color contentColor,
    required Color iconColor,
    required bool hasError,
    required GlassColorPalette palette,
    required Color focusColor,
    required GlassLayoutContext glass,
    required bool hasFocus,
  }) {
    final bool canOpen =
        widget.enabled &&
        !widget.readOnly &&
        widget.countryPickerEnabled;

    final Color finalTextColor =
        !widget.enabled
            ? contentColor.withValues(
                alpha: 0.40,
              )
            : hasFocus
                ? focusColor
                : contentColor;

    final Color separatorColor =
        !widget.enabled
            ? palette.border.withValues(
                alpha: 0.2,
              )
            : hasFocus
                ? focusColor.withValues(
                    alpha: 0.4,
                  )
                : palette.border.withValues(
                    alpha: 0.3,
                  );

    // ------------------------------------------------------------------------
    // BUBBLE SIZE
    // ------------------------------------------------------------------------

    final double bubbleSize =
        GlassInputUtils.bubbleSize(
      fieldHeight:
          widget.fieldHeight,
      ratio: 0.6,
    );

    // ------------------------------------------------------------------------
    // DRAPEAU
    // ------------------------------------------------------------------------

    final Widget bubble =
        glass.buildInputBubble(
      child:
          _buildCountryFlag(
        context: context,
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
          ? () => _handleCountryTap(
                context,
                widget,
                state,
              )
          : null,
      iconColor:
          hasError
              ? Colors.redAccent
              : iconColor,
    );

    // ------------------------------------------------------------------------
    // INDICATIF
    // ------------------------------------------------------------------------

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

    // ------------------------------------------------------------------------
    // CHEVRON
    // ------------------------------------------------------------------------

    final Widget chevron =
        glass.buildInputActionIcon(
      icon:
          Icons.keyboard_arrow_down_rounded,
      isFocused:
          hasFocus,
      enabled:
          canOpen,
      onTap: canOpen
          ? () => _handleCountryTap(
                context,
                widget,
                state,
              )
          : null,
      hasError:
          hasError,
      customColor:
          hasError
              ? Colors.redAccent
              : iconColor,
      availableHeight:
          widget.fieldHeight,
      bubbleRatio:
          0.50,
      iconRatio:
          0.66,
      showGlow:
          false,
    );

    // ------------------------------------------------------------------------
    // SELECTEUR
    // ------------------------------------------------------------------------

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

        MouseRegion(
          cursor:
              canOpen
                  ? SystemMouseCursors.click
                  : SystemMouseCursors.basic,
          child: GestureDetector(
            behavior:
                HitTestBehavior.opaque,
            onTap: canOpen
                ? () => _handleCountryTap(
                      context,
                      widget,
                      state,
                    )
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
        ),
      ],
    );
  }

  // ==========================================================================
  // COUNTRY TAP
  // ==========================================================================

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

    // ------------------------------------------------------------------------
    // Retire le focus du champ téléphone avant d'ouvrir le picker.
    // ------------------------------------------------------------------------

    FocusScope.of(context).unfocus();

    final PhoneCountry? currentCountry =
        state.effectiveCountry;

    // ------------------------------------------------------------------------
    // CALLBACK EXTERNE
    // ------------------------------------------------------------------------

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

      final GlassLayoutContext glassContext =
          context.watchGlassContext;

      final GlassColorPalette palette =
          glassContext.palette;

      final List<PhoneCountry> countriesList =
          widget.countries ??
          registry.all();

      final PhoneCountry? selected =
          await PhoneCountryPicker.show(
        context: context,
        countries:
            countriesList,
        palette:
            palette,
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

  // ==========================================================================
  // FLOATING LABEL
  // ==========================================================================

  Widget _buildFloatingLabel({
    required UniversalGlassPhoneInput widget,
    required GlassInputDecoration decoration,
    required Color focusColor,
    required GlassLayoutCalibrator geo,
    required bool hasError,
    required bool isFloating,
  }) {
    return AnimatedPositioned(
      duration:
          const Duration(
        milliseconds: 180,
      ),
      curve:
          Curves.easeInOutQuad,
      top:
          isFloating
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
              isFloating
                  ? 1.0
                  : 0.0,
          child:
              AnimatedDefaultTextStyle(
            duration:
                const Duration(
              milliseconds: 180,
            ),
            style: TextStyle(
              color:
                  hasError
                      ? decoration.errorColor
                      : isFloating
                          ? focusColor
                          : Colors.white
                              .withValues(
                              alpha:
                                  widget.enabled
                                      ? 0.6
                                      : 0.20,
                            ),
              fontSize:
                  isFloating
                      ? 10.5
                      : (geo.isVeryCompact
                          ? 14
                          : decoration.fontSize),
              fontWeight:
                  isFloating
                      ? FontWeight.w700
                      : FontWeight.w500,
              letterSpacing: 0.2,
              backgroundColor:
                  Colors.transparent,
            ),
            child:
                Text(
              widget.label,
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================================================
  // ERROR
  // ==========================================================================

  Widget _buildError({
    required UniversalGlassPhoneInputState state,
    required GlassInputDecoration decoration,
  }) {
    final String? error =
        state.errorText;

    if (error == null ||
        error.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding:
          const EdgeInsets.only(
        top: 6,
        left: 14,
      ),
      child: Text(
        error,
        style: TextStyle(
          color:
              decoration.errorColor,
          fontSize: 12,
          fontWeight:
              FontWeight.w500,
        ),
      ),
    );
  }

  // ==========================================================================
  // FLAG
  // ==========================================================================

  Widget _buildCountryFlag({
    required BuildContext context,
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
          fit:
              BoxFit.cover,
          cacheWidth:
              (size * 2.4).toInt(),
          errorBuilder: (
            BuildContext context,
            Object error,
            StackTrace? stackTrace,
          ) {
            debugPrint(
              'UniversalGlassPhoneInput: '
              'impossible de charger le '
              'drapeau "$asset" : $error',
            );

            return _buildFallbackFlag(
              context: context,
              state: state,
              size: size,
            );
          },
        ),
      );
    }

    return _buildFallbackFlag(
      context: context,
      state: state,
      size: size,
    );
  }

  // ==========================================================================
  // FALLBACK FLAG
  // ==========================================================================

  Widget _buildFallbackFlag({
    required BuildContext context,
    required UniversalGlassPhoneInputState state,
    double size = 22,
  }) {
    final GlassLayoutContext glass =
        context.watchGlassContext;

    return Text(
      state.effectiveCountryFlag,
      textAlign:
          TextAlign.center,
      style: TextStyle(
        color:
            glass.palette.white,
        fontSize:
            size,
        height: 1.0,
      ),
    );
  }
}

// ============================================================================
// BUILDER LOCAL DU PHONE INPUT
// ============================================================================
//
// Ce widget est volontairement séparé du ConsumerWidget principal.
//
// Il écoute :
// - FocusNode
// - TextEditingController
//
// Le setState() qui se produit ici ne reconstruit PAS
// UniversalGlassPhoneInputState.
//
// C'est précisément ce qui corrige le problème du double clic.
//
// ============================================================================

class _PhoneInputVisualBuilder extends StatefulWidget {
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
  State<_PhoneInputVisualBuilder> createState() =>
      _PhoneInputVisualBuilderState();
}

class _PhoneInputVisualBuilderState
    extends State<_PhoneInputVisualBuilder> {
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