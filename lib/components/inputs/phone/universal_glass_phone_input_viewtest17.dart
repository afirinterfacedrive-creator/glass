
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:universal_glass/components/inputs/universal_glass_phone_input.dart';
import 'package:universal_glass/components/inputs/phone/universal_glass_phone_input_state.dart';
import 'package:universal_glass/components/surface/glass_surface_container.dart';

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
    final UniversalGlassPhoneInput widget = state.widget;

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
          opacity: widget.enabled ? 1.0 : 0.65,
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  // =========================================================
                  // SURFACE + CHAMP
                  //
                  // TEST 17 :
                  // AUCUN ClipPath
                  // AUCUN NotchClipper
                  // AUCUN GlassNotchShadowWrapper
                  // =========================================================

                  GlassSurfaceContainer(
                    decoration: widget.decoration,
                    style: widget.style,
                    shape: widget.shape,
                    width: widget.width,
                    height: widget.fieldHeight,
                    borderRadius: BorderRadius.circular(
                      widget.decoration.borderRadius,
                    ),
                    onTap: null,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                    ),
                    liftOnHover: false,
                    disableShadow: true,
                    clipBehavior: Clip.none,
                    child: Row(
                      crossAxisAlignment:
                          CrossAxisAlignment.center,
                      children: [
                        // ===================================================
                        // PAYS
                        // ===================================================

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

                        const SizedBox(width: 8),

                        // ===================================================
                        // TEXT FIELD
                        // ===================================================

                        Expanded(
                          child: TextFormField(
                            controller: state.controller,
                            focusNode: state.focusNode,

                            enabled: widget.enabled,
                            readOnly: widget.readOnly,
                            autofocus: false,

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

                              isDense: true,

                              contentPadding:
                                  EdgeInsets.zero,

                              labelText: null,

                              hintText:
                                  state.effectiveHintText,

                              hintStyle:
                                  const TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),

                        // ===================================================
                        // SUFFIX
                        // ===================================================

                        if (widget.suffixIcon != null)
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

                  // =========================================================
                  // LABEL FLOTTANT
                  //
                  // Il reste purement visuel et ne peut pas intercepter
                  // le clic.
                  // =========================================================

                  if (isFloating)
                    Positioned(
                      left: 18,
                      top: -8,
                      child: IgnorePointer(
                        child: _buildFloatingLabel(
                          context,
                          widget,
                          hasFocus,
                        ),
                      ),
                    ),
                ],
              ),

              // =============================================================
              // ERREUR
              // =============================================================

              if (hasError && widget.enabled)
                Padding(
                  padding: const EdgeInsets.only(
                    left: 14,
                    top: 5,
                  ),
                  child: Text(
                    state.errorText!,
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context)
                          .colorScheme
                          .error,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  // =========================================================================
  // LABEL FLOTTANT
  // =========================================================================

  Widget _buildFloatingLabel(
    BuildContext context,
    UniversalGlassPhoneInput widget,
    bool hasFocus,
  ) {
    final Color labelColor = hasFocus
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context)
            .colorScheme
            .onSurface;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 5,
      ),
      color:
          Theme.of(context).scaffoldBackgroundColor,
      child: Text(
        widget.label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: labelColor,
        ),
      ),
    );
  }
}

// =============================================================================
// FOCUS / TEXT VISUAL BUILDER
// =============================================================================

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

    if (_hasFocus == value) return;
    if (!mounted) return;

    setState(() {
      _hasFocus = value;
    });
  }

  void _handleTextChanged() {
    final bool value =
        widget.controller.text.isNotEmpty;

    if (_hasText == value) return;
    if (!mounted) return;

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
