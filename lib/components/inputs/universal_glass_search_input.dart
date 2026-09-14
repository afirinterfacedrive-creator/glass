import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:universal_glass/utils/glass_input_decoration.dart';
import 'package:universal_glass/components/surface/glass_surface_container.dart';
import 'package:universal_glass/utils/glass_input_utils.dart';
import 'package:universal_glass/utils/glass_layout_calibrator.dart';
import 'package:universal_glass/core/layout/glass_layout_context.dart';
import 'package:universal_glass/core/layout/glass_layout_scope.dart';

import '../../enums/glass_enums.dart';

class UniversalGlassSearchInput extends ConsumerStatefulWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? hintText;
  final bool showClearButton;
  final VoidCallback? onClear;
  final GlassInputBubbleFit bubbleFit;
  final GlassInputBubbleShape bubbleShape;
  final bool showBubbleContentGlow;
  final bool enabled;
  final bool readOnly;
  final bool autofocus;
  final String? Function(String?)? validator;
  final AutovalidateMode autovalidateMode;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final ValueChanged<String>? onSubmitted;
  final TextInputAction? textInputAction;
  final double? width;
  final double? height;
  final GlassInputDecoration? decoration;
  final GlassStyle? style;
  final GlassShapeType? shape;

  const UniversalGlassSearchInput({
    super.key,
    this.controller,
    this.focusNode,
    this.hintText,
    this.showClearButton = true,
    this.onClear,
    this.bubbleFit = GlassInputBubbleFit.contain,
    this.bubbleShape = GlassInputBubbleShape.circle,
    this.showBubbleContentGlow = false,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.validator,
    this.autovalidateMode = AutovalidateMode.disabled,
    this.onChanged,
    this.onTap,
    this.onSubmitted,
    this.textInputAction = TextInputAction.search,
    this.width,
    this.height,
    this.decoration,
    this.style,
    this.shape,
  });

  @override
  ConsumerState<UniversalGlassSearchInput> createState() =>
      _UniversalGlassSearchInputState();
}

class _UniversalGlassSearchInputState
    extends ConsumerState<UniversalGlassSearchInput> {
  late final TextEditingController _internalController;
  late final FocusNode _internalFocusNode;
  TextEditingController get _controller =>
      widget.controller ?? _internalController;
  FocusNode get _focusNode => widget.focusNode ?? _internalFocusNode;
  bool _hasFocus = false;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _internalController = TextEditingController();
    _internalFocusNode = FocusNode();
    _focusNode.addListener(_handleFocusChanged);
    _controller.addListener(_handleControllerChanged);
    _hasFocus = _focusNode.hasFocus;
    if (widget.autofocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && widget.enabled) _focusNode.requestFocus();
      });
    }
  }

  @override
  void didUpdateWidget(covariant UniversalGlassSearchInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.focusNode != widget.focusNode) {
      oldWidget.focusNode?.removeListener(_handleFocusChanged);
      _focusNode.addListener(_handleFocusChanged);
      _hasFocus = _focusNode.hasFocus;
    }
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?.removeListener(_handleControllerChanged);
      _controller.addListener(_handleControllerChanged);
    }
  }

  void _handleControllerChanged() => mounted ? setState(() {}) : null;
  void _handleFocusChanged() {
    if (!mounted) return;
    final bool focused = _focusNode.hasFocus;
    if (_hasFocus == focused) return;
    setState(() => _hasFocus = focused);
  }

  void _handleChanged(String value) {
    if (widget.autovalidateMode == AutovalidateMode.always) {
      _validate(value);
    } else if (widget.autovalidateMode == AutovalidateMode.onUserInteraction &&
        _errorText != null) {
      _validate(value);
    }
    widget.onChanged?.call(value);
  }

  void _handleSubmitted(String value) {
    _validate(value);
    widget.onSubmitted?.call(value);
  }

  void _validate(String? value) {
    if (widget.validator == null) return;
    final String? error = widget.validator!(value);
    if (!mounted || _errorText == error) return;
    setState(() => _errorText = error);
  }

  void _handleSearchTap() {
    if (!widget.enabled || widget.readOnly) return;
    _focusNode.requestFocus();
    widget.onTap?.call();
  }

  void _handleClear() {
    if (!widget.enabled || widget.readOnly) return;
    _controller.clear();
    widget.onChanged?.call('');
    widget.onClear?.call();
    _focusNode.requestFocus();
  }

  void _handleContainerTap() {
    if (!widget.enabled || widget.readOnly) return;
    _focusNode.requestFocus();
    widget.onTap?.call();
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChanged);
    _controller.removeListener(_handleControllerChanged);
    _internalController.dispose();
    _internalFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final GlassLayoutContext glass = GlassLayoutScope.of(context);

    final bool hasError = _errorText != null && _errorText!.trim().isNotEmpty;
    final bool showClear =
        widget.showClearButton &&
        widget.enabled &&
        !widget.readOnly &&
        _controller.text.isNotEmpty;

    final double inputHeight = widget.height ?? (glass.isSmallMobile ? 52 : 58);
    const double fontSize = 15;

    final calibrator = GlassLayoutCalibrator(
      fieldHeight: inputHeight,
      fontSize: fontSize,
      hasPrefixIcon: true,
    );

    final double bubbleRatio = widget.bubbleFit == GlassInputBubbleFit.cover
        ? 0.7
        : 0.6;
    final double bubbleSize = inputHeight * bubbleRatio;
    final double clearFieldHeight =
        bubbleSize * 0.75 / 0.6; // <- hack pour avoir 75% de la taille

    final GlassInputDecoration decoration =
        widget.decoration ??
        glass.inputDecoration(hasError: hasError, isFocused: _hasFocus);

    final Widget searchTextField = TextField(
      controller: _controller,
      focusNode: _focusNode,
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      keyboardType: TextInputType.text,
      textInputAction: widget.textInputAction,
      textAlignVertical: TextAlignVertical.center,
      style: TextStyle(
        color: decoration.effectiveTextColor,
        fontSize: fontSize,
        height: 1.0,
      ),
      cursorColor: glass.palette.accent,
      decoration: InputDecoration(
        isDense: true,
        border: InputBorder.none,
        contentPadding: calibrator.contentPadding, // <- FIX HINT
        hintText: widget.hintText ?? 'Rechercher ici.........',
        hintStyle: TextStyle(
          color: decoration.effectiveHintColor,
          fontSize: calibrator.hintFontSize,
          height: 1.0,
        ),
        counterText: '',
      ),
      onChanged: _handleChanged,
      onTap: widget.onTap,
      onSubmitted: _handleSubmitted,
    );

    // Bulle Search
    final Widget searchBubble = context.buildInputBubbleWithChild(
      fieldHeight: bubbleSize / 0.6,
      isActive: _hasFocus,
      enabled: widget.enabled,
      onTap: widget.enabled && !widget.readOnly ? _handleSearchTap : null,
      color: _hasFocus
          ? glass.focusColor
          : decoration.iconColor.withValues(alpha: 0.8),
      child: const Icon(Icons.search_rounded),
    );

    // Bulle Clear
    final Color baseIconColor = showClear
        ? glass.focusColor
        : decoration.iconColor.withValues(alpha: 0.25);

    final Widget clearButton = context.buildInputBubbleWithChild(
      fieldHeight: clearFieldHeight,
      isActive: _hasFocus && showClear,
      enabled: showClear,
      onTap: showClear ? _handleClear : null,
      color: baseIconColor,
      child: const Icon(Icons.close_rounded),
    );

    final Widget content = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        searchBubble,
        SizedBox(width: bubbleSize * 0.2),
        Expanded(child: searchTextField),
        if (widget.showClearButton) ...[
          SizedBox(width: bubbleSize * 0.15),
          clearButton,
        ],
      ],
    );

    return GlassSurfaceContainer(
      decoration: decoration,
      style: widget.style ?? glass.effectiveGlassStyle,
      shape: widget.shape ?? GlassShapeType.squareRounded,
      effects: glass.effects,
      isFocused: _hasFocus,
      hasError: hasError,
      errorText: _errorText,
      enabled: widget.enabled,
      width: widget.width,
      height: inputHeight,
      onTap: _handleContainerTap,
      borderRadius: BorderRadius.circular(decoration.safeBorderRadius),
      padding: EdgeInsets.symmetric(
        horizontal: decoration.safeHorizontalPadding,
        vertical: decoration.safeVerticalPadding,
      ),
      liftOnHover: glass.theme.enableHover,
      child: content,
    );
  }
}
