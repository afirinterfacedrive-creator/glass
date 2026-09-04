import 'package:flutter/material.dart';
import 'package:universal_glass/components/glass_action_icon.dart';
import 'package:universal_glass/components/surface/glass_surface_container.dart';

import 'package:universal_glass/components/inputs/glass_input_decoration.dart';
import 'package:universal_glass/enums/glass_enums.dart';
import 'package:universal_glass/theme/glass_color_palette.dart';

class UniversalGlassTextFieldPlain extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String label;
  final String? hintText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixTap;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final AutovalidateMode autovalidateMode;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool enabled;
  final bool readOnly;

  const UniversalGlassTextFieldPlain({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.label,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixTap,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.validator,
    this.autovalidateMode = AutovalidateMode.disabled,
    this.onChanged,
    this.onSubmitted,
    this.enabled = true,
    this.readOnly = false,
  });

  @override
  State<UniversalGlassTextFieldPlain> createState() => _UniversalGlassTextFieldPlainState();
}

class _UniversalGlassTextFieldPlainState extends State<UniversalGlassTextFieldPlain> {
  bool _isObscured = false;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _isObscured = widget.obscureText;
    widget.focusNode.addListener(_onFocusChange);
    if (widget.validator != null) {
      widget.controller.addListener(_validateOnTrack);
    }
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_onFocusChange);
    widget.controller.removeListener(_validateOnTrack);
    super.dispose();
  }

  void _onFocusChange() {
    if (mounted) setState(() {});
  }

  void _validateOnTrack() {
    if (widget.autovalidateMode == AutovalidateMode.onUserInteraction) {
      final error = widget.validator?.call(widget.controller.text);
      if (_errorText != error) {
        setState(() => _errorText = error);
      }
    }
  }

  void _handleSubmitted(String value) {
    if (widget.validator != null) {
      setState(() => _errorText = widget.validator!(value));
    }
    widget.onSubmitted?.call(value);
  }

  void _handleSuffixTap() {
    if (widget.obscureText) {
      // Si c'est un champ mot de passe, le suffix sert de bouton "œil" pour afficher/masquer
      setState(() => _isObscured = !_isObscured);
    } else {
      widget.onSuffixTap?.call();
    }
  }

  IconData? get _effectiveSuffixIcon {
    if (widget.obscureText) {
      return _isObscured ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    }
    return widget.suffixIcon;
  }

  @override
  Widget build(BuildContext context) {
    final bool hasError = _errorText != null && _errorText!.trim().isNotEmpty;
    final bool isFocused = widget.focusNode.hasFocus;

    // Définition d'une décoration interne alignée sur les propriétés globales du package
    const GlassInputDecoration inputDecoration = GlassInputDecoration();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // ====================================================================
        // UNIQUE CADRE MAÎTRE DU CHAMP DE TEXTE
        // ====================================================================
        GlassSurfaceContainer(
          decoration: inputDecoration,
          style: GlassStyle.transparentAqua, // Conserve l'effet de transparence en verre
          shape: GlassShapeType.squareRounded,
          isFocused: isFocused,
          hasError: hasError,
          errorText: _errorText,
          enabled: widget.enabled,
          onTap: widget.enabled
              ? () {
                  if (!widget.readOnly) widget.focusNode.requestFocus();
                }
              : null,
          borderRadius: BorderRadius.circular(16),
          // Padding vertical augmenté pour offrir l'espace requis pour l'envolée du label flottant
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          liftOnHover: true,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ===============================================================
              // PREFIX ICON (Utilise GlassActionIcon officiel)
              // ===============================================================
              if (widget.prefixIcon != null)
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: GlassActionIcon(
                    icon: widget.prefixIcon,
                    enabled: widget.enabled,
                    size: 36,
                    isActive: isFocused,
                    onTap: null, // Non cliquable
                  ),
                ),

              // ===============================================================
              // CHAMP DE SAISIE FLUIDE (SANS BORDURES PARASITES)
              // ===============================================================
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  focusNode: widget.focusNode,
                  enabled: widget.enabled,
                  readOnly: widget.readOnly,
                  obscureText: _isObscured,
                  keyboardType: widget.keyboardType,
                  textInputAction: widget.textInputAction,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.15,
                  ),
                  cursorColor: Colors.cyanAccent,
                  cursorWidth: 1.5,
                  decoration: InputDecoration(
                    isDense: false, // Permet au label de s'élever proprement
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    
                    // ARCHITECTURE FLOATING LABEL SÉCURISÉE
                    labelText: widget.label,
                    labelStyle: TextStyle(
                      color: Colors.white.withValues(alpha: 0.45),
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                    floatingLabelStyle: const TextStyle(
                      color: Colors.cyanAccent, // S'illumine au focus
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    
                    hintText: widget.hintText,
                    hintStyle: TextStyle(
                      color: Colors.white.withValues(alpha: 0.25),
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  onChanged: (val) {
                    if (widget.onChanged != null) widget.onChanged!(val);
                    _validateOnTrack();
                  },
                  onSubmitted: _handleSubmitted,
                ),
              ),

              // ===============================================================
              // SUFFIX ICON (Utilise GlassActionIcon officiel)
              // ===============================================================
              if (_effectiveSuffixIcon != null)
                Padding(
                  padding: const EdgeInsets.only(left: 6),
                  child: GlassActionIcon(
                    icon: _effectiveSuffixIcon,
                    enabled: widget.enabled,
                    size: 36,
                    isActive: isFocused,
                    onTap: widget.enabled ? _handleSuffixTap : null,
                  ),
                ),
            ],
          ),
        ),
        
        // ====================================================================
        // SECTION DES MESSAGES D'ERREUR HAUTE COMPATIBILITÉ
        // ====================================================================
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 14),
            child: Text(
              _errorText!,
              style: const TextStyle(
                color: GlassColorPalette.red,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }
}
