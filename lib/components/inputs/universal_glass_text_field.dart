// ignore_for_file: curly_braces_in_flow_control_structures
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:universal_glass/components/surface/glass_surface_container.dart';
import 'package:universal_glass/utils/glass_theme_extension.dart';
import 'package:universal_glass/utils/glass_input_utils.dart';
import '../../enums/glass_enums.dart';
import 'glass_input_decoration.dart';

class UniversalGlassTextField extends ConsumerStatefulWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? label;
  final String? hintText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixTap;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final bool autofocus;
  final int? maxLength;
  final String? Function(String?)? validator;
  final AutovalidateMode autovalidateMode;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final ValueChanged<String>? onSubmitted;
  final double? width;
  final double? height;
  final double fieldHeight;
  final GlassInputDecoration? decoration;
  final GlassStyle? style;
  final GlassShapeType shape;

  const UniversalGlassTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.label,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixTap,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.maxLength,
    this.validator,
    this.autovalidateMode = AutovalidateMode.disabled,
    this.onChanged,
    this.onTap,
    this.onSubmitted,
    this.width,
    this.height,
    this.fieldHeight = 58.0,
    this.decoration,
    this.style,
    this.shape = GlassShapeType.squareRounded,
  });

  @override
  ConsumerState<UniversalGlassTextField> createState() => _UniversalGlassTextFieldState();
}

class _UniversalGlassTextFieldState extends ConsumerState<UniversalGlassTextField> {
  late final TextEditingController _internalController;
  late final FocusNode _internalFocusNode;
  TextEditingController get _controller => widget.controller?? _internalController;
  FocusNode get _focusNode => widget.focusNode?? _internalFocusNode;
  bool _hasFocus = false;
  bool _isObscured = false;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _internalController = TextEditingController();
    _internalFocusNode = FocusNode();
    _isObscured = widget.obscureText;
    _hasFocus = _focusNode.hasFocus;
    _focusNode.addListener(_handleFocusChanged);
    if (widget.autofocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        if (widget.enabled) _focusNode.requestFocus();
      });
    }
  }

  @override
  void didUpdateWidget(covariant UniversalGlassTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.focusNode!= widget.focusNode) {
      oldWidget.focusNode?.removeListener(_handleFocusChanged);
      _focusNode.addListener(_handleFocusChanged);
      _hasFocus = _focusNode.hasFocus;
    }
    if (oldWidget.obscureText!= widget.obscureText) _isObscured = widget.obscureText;
    if (oldWidget.validator!= widget.validator) _validate();
  }

  void _handleFocusChanged() {
    if (!mounted) return;
    final bool newFocus = _focusNode.hasFocus;
    if (_hasFocus == newFocus) return;
    setState(() => _hasFocus = newFocus);
    if (!newFocus && widget.autovalidateMode == AutovalidateMode.onUnfocus) _validate();
  }

  void _validate() {
    if (widget.validator == null) {
      if (_errorText!= null && mounted) setState(() => _errorText = null);
      return;
    }
    final String? error = widget.validator!(_controller.text);
    if (!mounted || _errorText == error) return;
    setState(() => _errorText = error);
  }

  void _handleChanged(String value) {
    if (widget.autovalidateMode == AutovalidateMode.always || 
        widget.autovalidateMode == AutovalidateMode.onUserInteraction || 
        _errorText!= null) _validate();
    widget.onChanged?.call(value);
  }

  void _handleSubmitted(String value) {
    _validate();
    widget.onSubmitted?.call(value);
  }

  void _handleSuffixTap() {
    if (widget.onSuffixTap!= null) {
      widget.onSuffixTap!();
      return;
    }
    if (widget.obscureText) setState(() => _isObscured =!_isObscured);
  }

  IconData? get _effectiveSuffixIcon {
    if (widget.obscureText && widget.onSuffixTap == null) {
      return _isObscured? Icons.visibility_off_rounded : Icons.visibility_rounded;
    }
    return widget.suffixIcon;
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChanged);
    _internalController.dispose();
    _internalFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final glass = ref.watchGlassContext(context);
    final bool useAqua = glass.theme.useAquaStyle;
    final Color focusColor = useAqua ? Colors.cyanAccent : Colors.orangeAccent;
    final GlassStyle effectiveStyle = widget.style ?? glass.effectiveGlassStyle;
    final GlassInputDecoration effectiveDecoration = widget.decoration ?? const GlassInputDecoration();
    final bool hasError = _errorText!= null && _errorText!.trim().isNotEmpty;

    final double h = widget.height ?? widget.fieldHeight;
    final double verticalPadding = GlassInputUtils.verticalPadding(h);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        GlassSurfaceContainer(
          style: effectiveStyle,
          effects: glass.effects,
          isFocused: _hasFocus,
          hasError: hasError,
          errorText: _errorText,
          enabled: widget.enabled,
          width: widget.width,
          height: h,
          onTap: widget.enabled ? () { if (!widget.readOnly) _focusNode.requestFocus(); widget.onTap?.call(); } : null,
          borderRadius: BorderRadius.circular(glass.isSmallMobile ? 14 : effectiveDecoration.safeBorderRadius),
          padding: EdgeInsets.symmetric( // <- TOUJOURS LE MEME PADDING
            horizontal: effectiveDecoration.safeHorizontalPadding, 
            vertical: verticalPadding
          ),
          liftOnHover: false, // <- TOUJOURS true
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (widget.prefixIcon!= null)
                Padding(
                  padding: const EdgeInsets.only(right: 12), // <- 12 au lieu de 10 pour respirer
                  child: GlassInputUtils.buildInputIcon(
                    context: context,
                    icon: widget.prefixIcon!,
                    isActive: _hasFocus,
                    enabled: widget.enabled,
                    onTap: null,
                    fieldHeight: h,
                    bubbleRatio: 0.66, // <- 66% pour prefix
                    hasError: hasError,
                    onlyIcon: true
                  ),
                ),
              Expanded(
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  enabled: widget.enabled,
                  readOnly: widget.readOnly,
                  autofocus: false,
                  obscureText: _isObscured,
                  keyboardType: widget.keyboardType,
                  textInputAction: widget.textInputAction,
                  maxLength: widget.maxLength,
                  style: TextStyle(color: effectiveDecoration.effectiveTextColor, fontSize: 16, fontWeight: FontWeight.w400),
                  cursorColor: focusColor,
                  cursorWidth: 1.8,
                  decoration: InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    hintText: widget.hintText,
                    hintStyle: TextStyle(color: effectiveDecoration.effectiveHintColor, fontSize: 16),
                    counterText: '',
                  ),
                  onChanged: _handleChanged,
                  onTap: widget.onTap,
                  onSubmitted: _handleSubmitted,
                ),
              ),
              if (_effectiveSuffixIcon!= null)
                Padding(
                  padding: const EdgeInsets.only(left: 8), // <- 8 au lieu de 6
                  child: GlassInputUtils.buildInputIcon(
                    context: context,
                    icon: _effectiveSuffixIcon!,
                    isActive: _hasFocus,
                    enabled: widget.enabled,
                    onTap: widget.enabled? _handleSuffixTap : null,
                    fieldHeight: h,
                    bubbleRatio: 0.66, // <- 66% pour suffix aussi pour homogénéité
                    hasError: hasError,
                    onlyIcon: true
                  ),
                ),
            ],
          ),
        ),
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 12),
            child: Text(_errorText!, style: TextStyle(color: Colors.redAccent, fontSize: glass.isSmallMobile ? 11 : 12, fontWeight: FontWeight.w500)),
          ),
      ],
    );
  }
}