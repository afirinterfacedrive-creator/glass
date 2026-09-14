import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:universal_glass/components/surface/glass_surface_container.dart';
import 'package:universal_glass/enums/glass_enums.dart';
import 'package:universal_glass/utils/glass_input_decoration.dart';
import 'package:universal_glass/utils/glass_input_state_style.dart';
import 'package:universal_glass/utils/glass_input_utils.dart';
import 'package:universal_glass/core/layout/glass_layout_context.dart';
import 'package:universal_glass/core/layout/glass_layout_scope.dart';

/// ============================================================================
/// UNIVERSAL GLASS TEXT BOX
/// ============================================================================
///
/// Champ de texte visuel non éditable.
///
/// Permet d'afficher :
///
/// - une valeur ou un texte indicatif ;
/// - une icône préfixe ;
/// - une icône suffixe ;
/// - un état focus ;
/// - un état erreur ;
/// - une décoration Glass personnalisée ;
/// - un style Glass personnalisé ;
/// - une forme personnalisée.
///
/// La résolution visuelle repose sur :
///
/// - GlassLayoutContext
/// - GlassInputDecoration
/// - GlassInputStateStyle
/// - GlassInputUtils
/// - GlassSurfaceContainer
///
/// Le composant ne contient aucune logique Aqua/Classic.
///
class UniversalGlassTextBox extends ConsumerWidget {
  // ==========================================================================
  // CONTENU
  // ==========================================================================

  final String? text;
  final String? hintText;

  // ==========================================================================
  // ICÔNES
  // ==========================================================================

  final IconData? prefixIcon;
  final IconData? suffixIcon;

  final VoidCallback? onSuffixTap;

  final double iconSize;

  // ==========================================================================
  // DIMENSIONS
  // ==========================================================================

  final double fieldHeight;

  final double prefixSpacing;
  final double suffixSpacing;

  final double? width;
  final double? height;

  // ==========================================================================
  // ÉTAT
  // ==========================================================================

  final bool enabled;
  final bool isFocused;
  final bool hasError;

  final String? errorText;

  final VoidCallback? onTap;

  // ==========================================================================
  // APPARENCE
  // ==========================================================================

  final GlassInputDecoration? decoration;
  final GlassStyle? style;
  final GlassShapeType shape;

  // ==========================================================================
  // TEXTE
  // ==========================================================================

  final int maxLines;

  // ==========================================================================
  // CONSTRUCTEUR
  // ==========================================================================

  const UniversalGlassTextBox({
    super.key,
    this.text,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixTap,
    this.iconSize = 20.0,
    this.fieldHeight = 55.0,
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

  // ==========================================================================
  // BUILD
  // ==========================================================================

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ------------------------------------------------------------------------
    // CONTEXTE GLASS
    // ------------------------------------------------------------------------
    //
    // Toute la configuration globale du thème passe par GlassLayoutContext.
    //
    final GlassLayoutContext glass =  GlassLayoutScope.of(context);

    // ==========================================================================
    // CONTENU
    // ==========================================================================

    final bool hasText = text != null && text!.trim().isNotEmpty;

    final String displayedText = hasText ? text! : (hintText ?? '');

    // ==========================================================================
    // DÉCORATION
    // ==========================================================================
    //
    // Si une décoration personnalisée est fournie, elle est conservée.
    //
    // Sinon, elle est résolue depuis GlassLayoutContext.
    //

    final GlassInputDecoration effectiveDecoration =
        decoration ??
        glass.inputDecoration(hasError: hasError, isFocused: isFocused);

    // ==========================================================================
    // ÉTAT VISUEL
    // ==========================================================================
    //
    // Toute la résolution :
    //
    // ERROR
    // FOCUS
    // SUCCESS
    // HOVER
    // NORMAL
    // DISABLED
    //
    // est centralisée dans GlassInputStateStyle.
    //

    final GlassInputStateStyle inputState = GlassInputStateStyle.resolve(
      decoration: effectiveDecoration,
      hasError: hasError,
      isFocused: isFocused,
      enabled: enabled,
    );

    // ==========================================================================
    // STYLE GLASS
    // ==========================================================================

    final GlassStyle effectiveStyle = style ?? glass.effectiveGlassStyle;

    // ==========================================================================
    // TAILLE DES BULLES / ICÔNES
    // ==========================================================================

    final double bubbleSize = (fieldHeight * 0.60).clamp(28.0, 48.0);

    final double finalIconSize = iconSize > 0.0 ? iconSize : bubbleSize * 0.66;

    // ==========================================================================
    // COULEUR DES ICÔNES
    // ==========================================================================
    //
    // La couleur est entièrement déterminée par GlassInputStateStyle.
    //
    // Aucune logique Aqua/Classic n'est présente ici.
    //

    final Color iconColor = inputState.iconColor;

    // ==========================================================================
    // COULEUR DU TEXTE
    // ==========================================================================

    final Color textColor = hasText
        ? inputState.textColor
        : inputState.hintColor;

    // ==========================================================================
    // OPACITÉ DU CONTENU
    // ==========================================================================

    final double contentOpacity = enabled ? 1.0 : 0.40;

    // ==========================================================================
    // CONTENU INTERNE
    // ==========================================================================

    final Widget content = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // ====================================================================
        // ICÔNE PRÉFIXE
        // ====================================================================
        if (prefixIcon != null) ...[
          context.buildInputBubbleWithChild(
            fieldHeight: fieldHeight,
            isActive: isFocused,
            enabled: enabled,
            onTap: null,
            color: iconColor,
            child: Icon(prefixIcon, size: finalIconSize),
          ),

          SizedBox(width: (prefixSpacing - 4.0).clamp(0.0, double.infinity)),
        ],

        // ====================================================================
        // TEXTE
        // ====================================================================
        Expanded(
          child: Text(
            displayedText,
            maxLines: maxLines,
            overflow: maxLines == 1 ? TextOverflow.ellipsis : TextOverflow.fade,
            style: TextStyle(
              color: textColor.withValues(alpha: contentOpacity),
              fontSize: effectiveDecoration.fontSize,
              fontWeight: hasText
                  ? effectiveDecoration.fontWeight
                  : FontWeight.w400,
              letterSpacing: effectiveDecoration.letterSpacing,
              height: 1.3,
            ),
          ),
        ),

        // ====================================================================
        // ICÔNE SUFFIXE
        // ====================================================================
        if (suffixIcon != null) ...[
          SizedBox(width: (suffixSpacing - 4.0).clamp(0.0, double.infinity)),

          context.buildInputBubbleWithChild(
            fieldHeight: fieldHeight,
            isActive: isFocused,
            enabled: enabled,
            onTap: enabled ? (onSuffixTap ?? onTap) : null,
            color: iconColor,
            child: Icon(suffixIcon, size: finalIconSize),
          ),
        ],
      ],
    );

    // ==========================================================================
    // CONTAINER GLASS
    // ==========================================================================

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        GlassSurfaceContainer(
          style: effectiveStyle,
          effects: glass.effects,
          decoration: effectiveDecoration,
          shape: shape,
          isFocused: isFocused,
          hasError: hasError,
          errorText: errorText,
          enabled: enabled,
          onTap: enabled ? onTap : null,
          width: width,
          height: height ?? fieldHeight,
          borderRadius: BorderRadius.circular(
            glass.isSmallMobile ? 12.0 : effectiveDecoration.safeBorderRadius,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 12.0,
            vertical: fieldHeight <= 48.0 ? 2.0 : 6.0,
          ),
          liftOnHover: true,
          child: content,
        ),

        // ==========================================================================
        // MESSAGE D'ERREUR
        // ==========================================================================
        if (hasError && errorText != null && errorText!.trim().isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 6.0, left: 12.0),
            child: Text(
              errorText!,
              style: TextStyle(
                color: inputState.borderColor,
                fontSize: glass.isSmallMobile ? 11.0 : 12.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }
}
