import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:universal_glass/core/layout/glass_layout_context.dart';
import 'package:universal_glass/core/layout/glass_layout_scope.dart';

/// ============================================================================
/// GLASS TEXT
/// ============================================================================
///
/// Texte utilisant automatiquement la palette Glass active.
///
/// Le widget récupère :
///
/// - la couleur principale du texte ;
/// - la transparence ;
/// - le contexte Glass.
///
/// Il reste volontairement indépendant de la persistance et de la
/// configuration des paramètres d'apparence.
///
class GlassText extends ConsumerWidget {
  // ==========================================================================
  // PROPRIÉTÉS
  // ==========================================================================

  final String data;

  final double? fontSize;
  final FontWeight? fontWeight;
  final double? letterSpacing;

  /// Hauteur de ligne.
  final double? height;

  final Color? color;

  /// Transparence appliquée à la couleur du texte.
  final double alpha;

  final TextAlign? textAlign;

  final int? maxLines;
  final TextOverflow? overflow;

  // ==========================================================================
  // CONSTRUCTEUR
  // ==========================================================================

  const GlassText(
    this.data, {
    super.key,
    this.fontSize,
    this.fontWeight,
    this.letterSpacing,
    this.height,
    this.color,
    this.alpha = 1.0,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  // ==========================================================================
  // BUILD
  // ==========================================================================

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GlassLayoutContext glass = GlassLayoutScope.of(context);

    final Color finalColor =
        color ??
        glass.palette.textPrimary.withValues(alpha: alpha.clamp(0.0, 1.0));

    return Text(
      data,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: TextStyle(
        color: finalColor,
        fontSize: fontSize,
        fontWeight: fontWeight,
        letterSpacing: letterSpacing,

        // Hauteur par défaut légèrement aérée.
        height: height ?? 1.3,
      ),
    );
  }
}

// ============================================================================
// GLASS SUB TEXT
// ============================================================================

/// Variante secondaire de [GlassText].
///
/// Par défaut :
///
/// - alpha = 0.6
/// - tous les paramètres de mise en forme importants sont transmis.
class GlassSubText extends GlassText {
  const GlassSubText(
    super.data, {
    super.key,
    super.fontSize,
    super.fontWeight,
    super.letterSpacing,
    super.height,
    super.color,
    super.alpha = 0.6,
    super.textAlign,
    super.maxLines,
    super.overflow,
  });
}

// ============================================================================
// GLASS SECTION HEADER
// ============================================================================

/// En-tête de section Glass.
///
/// Affiche :
///
/// - une icône optionnelle ;
/// - un titre ;
/// - un sous-titre optionnel.
///
/// La couleur d'accent est fournie par [GlassLayoutContext].
///
/// Le widget ne contient aucune logique Aqua/Classic/SAGE.
///
class GlassSectionHeader extends ConsumerWidget {
  // ==========================================================================
  // PROPRIÉTÉS
  // ==========================================================================

  final String title;
  final String? subtitle;
  final IconData? icon;

  // ==========================================================================
  // CONSTRUCTEUR
  // ==========================================================================

  const GlassSectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
  });

  // ==========================================================================
  // BUILD
  // ==========================================================================

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GlassLayoutContext glass = GlassLayoutScope.of(context);

    // ==========================================================================
    // ACCENT DYNAMIQUE
    // ==========================================================================
    //
    // Toute la décision de couleur est centralisée dans GlassLayoutContext.
    //
    // Le widget ne connaît donc plus :
    //
    // - Aqua
    // - Classic
    // - SAGE
    // - les couleurs cyan/orange
    //
    final Color accent = glass.focusColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ======================================================================
        // TITRE
        // ======================================================================
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: accent, size: 22),
              const SizedBox(width: 10),
            ],

            Expanded(
              child: GlassText(
                title,
                fontSize: glass.isSmallMobile ? 16 : 18,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
                height: 1.2,
              ),
            ),
          ],
        ),

        // ======================================================================
        // SOUS-TITRE
        // ======================================================================
        if (subtitle != null) ...[
          const SizedBox(height: 4),

          GlassSubText(
            subtitle!,
            fontSize: glass.isSmallMobile ? 11 : 13,
            height: 1.25,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }
}
