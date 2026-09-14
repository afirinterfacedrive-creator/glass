import 'package:flutter/material.dart';
import 'package:universal_glass/components/glass_action_icon.dart';
import 'package:universal_glass/components/surface/glass_surface_container.dart';

import '../../enums/glass_enums.dart';
import '../../utils/glass_input_decoration.dart';

/// ============================================================================
/// UNIVERSAL GLASS USERNAME INPUT
/// Avec GlassSurfaceContainer pour le hover glass synchro
/// ============================================================================

class UniversalGlassUsernameInput extends StatefulWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? hintText;
  final Widget? leadingChild;
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
  final GlassInputDecoration decoration;
  final GlassStyle style;
  final GlassShapeType shape;

  const UniversalGlassUsernameInput({
    super.key,
    this.controller,
    this.focusNode,
    this.hintText,
    this.leadingChild,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.validator,
    this.autovalidateMode = AutovalidateMode.disabled,
    this.onChanged,
    this.onTap,
    this.onSubmitted,
    this.textInputAction = TextInputAction.next,
    this.width,
    this.height,
    this.decoration = const GlassInputDecoration(),
    this.style = GlassStyle.transparentAqua,
    this.shape = GlassShapeType.squareRounded,
  });

  @override
  State<UniversalGlassUsernameInput> createState() => _UniversalGlassUsernameInputState();
}

class _UniversalGlassUsernameInputState extends State<UniversalGlassUsernameInput> {
  late final TextEditingController _internalController;
  late final FocusNode _internalFocusNode;
  TextEditingController get _controller => widget.controller?? _internalController;
  FocusNode get _focusNode => widget.focusNode?? _internalFocusNode;
  bool _hasFocus = false;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _internalController = TextEditingController();
    _internalFocusNode = FocusNode();
    _focusNode.addListener(_handleFocusChanged);
    if (widget.autofocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) { if (!mounted) return; _focusNode.requestFocus(); });
    }
  }

  @override
  void didUpdateWidget(covariant UniversalGlassUsernameInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.focusNode!= widget.focusNode) {
      oldWidget.focusNode?.removeListener(_handleFocusChanged);
      _focusNode.addListener(_handleFocusChanged);
      _hasFocus = _focusNode.hasFocus;
    }
  }

  void _handleFocusChanged() {
    if (!mounted) return;
    final bool focused = _focusNode.hasFocus;
    if (_hasFocus == focused) return;
    setState(() => _hasFocus = focused);
  }

  void _handleChanged(String value) {
    if (widget.autovalidateMode == AutovalidateMode.always) {
      _validate(value);
    } else if (widget.autovalidateMode == AutovalidateMode.onUserInteraction && _errorText!= null) {
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

  void _handleLeadingTap() {
    if (!widget.enabled || widget.readOnly) return;
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
    _internalController.dispose();
    _internalFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final GlassInputDecoration decoration = widget.decoration;
    final bool hasError = _errorText!= null && _errorText!.trim().isNotEmpty;

    // ========================================================================
    // TEXT FIELD
    // ========================================================================
    final Widget usernameTextField = TextField(
      controller: _controller,
      focusNode: _focusNode,
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      keyboardType: TextInputType.text,
      textInputAction: widget.textInputAction,
      textCapitalization: TextCapitalization.none,
      style: TextStyle(color: decoration.effectiveTextColor, fontSize: decoration.fontSize, fontWeight: decoration.fontWeight, letterSpacing: decoration.letterSpacing),
      cursorColor: hasError? decoration.errorColor : decoration.effectiveFocusColor,
      decoration: InputDecoration(
        isDense: true, border: InputBorder.none, enabledBorder: InputBorder.none, focusedBorder: InputBorder.none,
        disabledBorder: InputBorder.none, errorBorder: InputBorder.none, focusedErrorBorder: InputBorder.none, contentPadding: EdgeInsets.zero,
        hintText: widget.hintText?? 'Nom d’utilisateur',
        hintStyle: TextStyle(color: decoration.effectiveHintColor, fontSize: decoration.fontSize, fontWeight: FontWeight.w400, letterSpacing: decoration.letterSpacing),
        counterText: '',
      ),
      onChanged: _handleChanged,
      onTap: widget.onTap,
      onSubmitted: _handleSubmitted,
    );

    // ========================================================================
    // LEADING BUBBLE -> GLASSACTIONICON
    // Support du Text('@') custom
    // ========================================================================
    final Widget leadingBubble = GlassActionIcon(
      icon: widget.leadingChild == null? Icons.alternate_email_rounded : null, // fallback si pas de child
      // ignore: sort_child_properties_last
      child: widget.leadingChild ?? const Text('@', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 21, fontWeight: FontWeight.w700, height: 1.0)),
      enabled: widget.enabled,
      size: 46,
      isActive: _hasFocus || hasError, // rouge si erreur
      onTap: widget.enabled && !widget.readOnly? _handleLeadingTap : null,
      useTintedIcon: false, // false pour garder la couleur du Text('@')
    );

    // ========================================================================
    // CONTENU
    // ========================================================================
    final Widget content = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        leadingBubble,
        const SizedBox(width: 10),
        Expanded(child: usernameTextField),
      ],
    );

    // ========================================================================
    // CONTAINER GLASS
    // ========================================================================
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        GlassSurfaceContainer(
          decoration: decoration,
          style: widget.style,
          shape: widget.shape,
          isFocused: _hasFocus,
          hasError: hasError,
          errorText: _errorText,
          enabled: widget.enabled,
          width: widget.width,
          height: widget.height,
          onTap: _handleContainerTap,
          borderRadius: BorderRadius.circular(decoration.safeBorderRadius),
          padding: EdgeInsets.symmetric(horizontal: decoration.safeHorizontalPadding, vertical: decoration.safeVerticalPadding),
          liftOnHover: true,
          child: content,
        ),
        if (hasError)
          Padding(padding: const EdgeInsets.only(top: 6, left: 12), child: Text(_errorText!, style: TextStyle(color: decoration.errorColor, fontSize: 12, fontWeight: FontWeight.w500))),
      ],
    );
  }
}