// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:universal_glass/components/inputs/glass_input_decoration.dart';
import 'package:universal_glass/components/surface/glass_surface_container.dart';
import 'package:universal_glass/utils/glass_theme_extension.dart';
import '../../enums/glass_enums.dart';

class UniversalGlassTextBox extends ConsumerWidget {
  final String? text;
  final String? hintText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixTap;
  final double iconSize;
  final double fieldHeight;
  final double prefixSpacing;
  final double suffixSpacing;
  final bool enabled;
  final bool isFocused;
  final bool hasError;
  final String? errorText;
  final VoidCallback? onTap;
  final double? width;
  final double? height;
  final GlassInputDecoration? decoration;
  final GlassStyle? style;
  final GlassShapeType shape;
  final int maxLines;

  const UniversalGlassTextBox({
    super.key,
    this.text,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixTap,
    this.iconSize = 20.0,
    this.fieldHeight = 55,
    this.prefixSpacing = 12.0,
    this.suffixSpacing = 12.0,
    this.enabled = true,
    this.isFocused = false,
    this.hasError = false,
    this.errorText,
    this.onTap,
    this.width,
    this.height,
    this.decoration,
    this.style,
    this.shape = GlassShapeType.squareRounded,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final glass = ref.watchGlassContext(context);

    final bool hasText = text != null && text!.trim().isNotEmpty;
    final String displayedText = hasText ? text! : (hintText ?? '');
    final double disabledOpacity = enabled ? 1.0 : 0.40;

    // 1. RESOLUTION STYLE + DECO CENTRALISEE
    final bool useAqua = glass.theme.useAquaStyle;
    final Color focusColor = useAqua ? Colors.cyanAccent : Colors.orangeAccent;
    final GlassStyle effectiveStyle = style ?? glass.effectiveGlassStyle;
    
    // <- UTILISE LE HELPER CENTRALISE
    final GlassInputDecoration baseDecoration = decoration ?? glass.inputDecoration(hasError: hasError, isFocused: isFocused);
    
    // On force juste le 60% et 80% demandé par dessus
    final GlassInputDecoration effectiveDecoration = baseDecoration.copyWith(
      borderColor: hasError 
          ? Colors.redAccent.withValues(alpha: 0.6) 
          : baseDecoration.borderColor.withValues(alpha: 0.6),
      focusBorderColor: hasError 
          ? Colors.redAccent 
          : focusColor.withValues(alpha: 0.8),
    );

    // 2. TAILLE ICONE: 60% de la hauteur * 0.66 pour rester dans la bulle
    final double bubbleSize = fieldHeight * 0.6;
    final double finalIconSize = iconSize > 0 ? iconSize : bubbleSize * 0.66;

    // 3. COULEURS DYNAMIQUES
    final Color baseIconColor = hasError 
        ? Colors.redAccent 
        : (isFocused ? focusColor : glass.palette.textSecondary.withValues(alpha: 0.7));
    
    final Color textColor = hasText 
        ? effectiveDecoration.effectiveTextColor 
        : effectiveDecoration.effectiveHintColor;

    final Widget content = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (prefixIcon != null) ...[
          // <- UTILISE LE HELPER CENTRALISE
          glass.buildInputBubble(
            fieldHeight: fieldHeight,
            isFocused: isFocused,
            enabled: enabled,
            onTap: null,
            iconColor: baseIconColor,
            child: Icon(prefixIcon, size: finalIconSize),
          ),
          SizedBox(width: prefixSpacing - 4),
        ],
        Expanded(
          child: Text(
            displayedText,
            maxLines: maxLines,
            overflow: maxLines == 1 ? TextOverflow.ellipsis : TextOverflow.fade,
            style: TextStyle(
              color: textColor.withValues(alpha: disabledOpacity),
              fontSize: effectiveDecoration.fontSize,
              fontWeight: hasText ? effectiveDecoration.fontWeight : FontWeight.w400,
              letterSpacing: effectiveDecoration.letterSpacing,
              height: 1.3,
            ),
          ),
        ),
        if (suffixIcon != null) ...[
          SizedBox(width: suffixSpacing - 4),
          // <- UTILISE LE HELPER CENTRALISE
          glass.buildInputBubble(
            fieldHeight: fieldHeight,
            isFocused: isFocused,
            enabled: enabled,
            onTap: enabled ? onSuffixTap ?? onTap : null,
            iconColor: baseIconColor,
            child: Icon(suffixIcon, size: finalIconSize),
          ),
        ],
      ],
    );

    final bool isGhostMode = effectiveStyle == GlassStyle.ghost;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        GlassSurfaceContainer(
          style: effectiveStyle,
          effects: glass.effects,
          decoration: isGhostMode 
            ? const GlassInputDecoration(color: Colors.transparent, backgroundOpacity: 0.0, borderColor: Colors.transparent)
            : effectiveDecoration,
          shape: shape,
          isFocused: isFocused,
          hasError: hasError,
          errorText: errorText,
          enabled: enabled,
          onTap: enabled ? onTap : null,
          width: width,
          height: height ?? fieldHeight,
          borderRadius: BorderRadius.circular(glass.isSmallMobile ? 12 : effectiveDecoration.safeBorderRadius),
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: fieldHeight <= 48 ? 2 : 6),
          liftOnHover: true,
          child: content,
        ),
        if (hasError && errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 12),
            child: Text(
              errorText!, 
              style: TextStyle(
                color: Colors.redAccent, 
                fontSize: glass.isSmallMobile ? 11 : 12, 
                fontWeight: FontWeight.w500
              ),
            ),
          ),
      ],
    );
  }
}