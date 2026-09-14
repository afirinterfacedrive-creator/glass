import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:universal_glass/components/surface/glass_surface_container.dart';
import 'package:universal_glass/components/universal_glass_button.dart';
import 'package:universal_glass/enums/glass_enums.dart';
import 'package:universal_glass/settings/widgets/glass_text.dart';
import 'package:universal_glass/theme/glass_effects.dart';
import 'package:universal_glass/core/layout/glass_layout_context.dart';
import 'package:universal_glass/core/layout/glass_layout_scope.dart';

/// ============================================================================
/// UNIVERSAL GLASS CONFIRM DIALOG VIEW
/// ============================================================================
///
/// Vue interne du dialogue de confirmation.
///
/// Responsabilités :
///
/// - afficher le contenu du dialogue ;
/// - appliquer le style Glass courant ;
/// - gérer le bouton Annuler ;
/// - gérer le bouton Confirmer ;
/// - adapter les dimensions aux petits écrans.
///
/// Cette classe :
///
/// - utilise Riverpod uniquement pour récupérer le contexte Glass ;
/// - ne gère aucune persistance ;
/// - ne modifie pas la configuration globale du thème.
///
class UniversalGlassConfirmDialogView extends ConsumerStatefulWidget {
  // ==========================================================================
  // PROPRIÉTÉS
  // ==========================================================================

  final String title;
  final String message;

  final IconData? icon;
  final Color? iconColor;

  final String cancelText;
  final String confirmText;

  final VoidCallback? onCancel;
  final Future<void> Function()? onConfirm;

  final bool enabled;

  final Color? accentColor;
  final Color? cancelColor;
  final Color? confirmColor;

  final GlassStyle? style;
  final GlassEffects? effects;

  final GlassShapeType shape;

  /// Identifiant permettant d'éviter les collisions entre plusieurs boutons.
  final String uniqueKey;

  // ==========================================================================
  // CONSTRUCTEUR
  // ==========================================================================

  const UniversalGlassConfirmDialogView({
    super.key,
    required this.title,
    required this.message,
    this.icon,
    this.iconColor,
    this.cancelText = 'Annuler',
    this.confirmText = 'Confirmer',
    this.onCancel,
    this.onConfirm,
    this.enabled = true,
    this.accentColor,
    this.cancelColor,
    this.confirmColor,
    this.style,
    this.effects,
    this.shape = GlassShapeType.squareRounded,
    this.uniqueKey = '',
  });

  @override
  ConsumerState<UniversalGlassConfirmDialogView> createState() =>
      _UniversalGlassConfirmDialogViewState();
}

// ============================================================================
// STATE
// ============================================================================

class _UniversalGlassConfirmDialogViewState
    extends ConsumerState<UniversalGlassConfirmDialogView> {
  // ==========================================================================
  // ANNULATION
  // ==========================================================================

  void _handleCancel() {
    widget.onCancel?.call();

    if (context.mounted) {
      Navigator.of(context).pop(false);
    }
  }

  // ==========================================================================
  // BUILD
  // ==========================================================================

  @override
  Widget build(BuildContext context) {
    final GlassLayoutContext glass = GlassLayoutScope.of(context);

    // ------------------------------------------------------------------------
    // RESPONSIVE
    // ------------------------------------------------------------------------

    final bool isSmallMobile = glass.isSmallMobile;

    // ------------------------------------------------------------------------
    // CONTEXTE VISUEL
    // ------------------------------------------------------------------------

    final bool isBackgroundLight = glass.theme.surfaceOpacity > 0.5;

    // ------------------------------------------------------------------------
    // STYLE
    // ------------------------------------------------------------------------

    final GlassStyle effectiveStyle = widget.style ?? glass.effectiveGlassStyle;

    final GlassEffects effectiveEffects = widget.effects ?? glass.effects;

    // ------------------------------------------------------------------------
    // COULEURS
    // ------------------------------------------------------------------------

    final Color accent = widget.accentColor ?? glass.palette.accent;

    final Color effectiveConfirmColor = widget.confirmColor ?? accent;

    final Color effectiveCancelColor =
        widget.cancelColor ??
        (isBackgroundLight
            ? const Color(0xFF475569)
            : glass.palette.textSecondary);

    // ------------------------------------------------------------------------
    // IDENTIFIANTS
    // ------------------------------------------------------------------------

    final String baseId = '${widget.uniqueKey}_${widget.title.hashCode}';

    // ==========================================================================
    // DIALOGUE
    // ==========================================================================

    return GlassSurfaceContainer(
      style: effectiveStyle,
      effects: effectiveEffects,
      shape: widget.shape,
      enabled: widget.enabled,
      borderRadius: BorderRadius.circular(isSmallMobile ? 16 : 20),
      padding: EdgeInsets.zero,
      liftOnHover: true,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          isSmallMobile ? 20 : 24,
          isSmallMobile ? 24 : 32,
          isSmallMobile ? 20 : 24,
          isSmallMobile ? 20 : 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ==================================================================
            // ICÔNE
            // ==================================================================
            if (widget.icon != null) ...[
              Icon(
                widget.icon,
                color: widget.iconColor ?? accent,
                size: isSmallMobile ? 32 : 38,
              ),
              SizedBox(height: isSmallMobile ? 14 : 18),
            ],

            // ==================================================================
            // TITRE
            // ==================================================================
            GlassText(
              widget.title,
              textAlign: TextAlign.center,
              fontSize: isSmallMobile ? 18 : 20,
              fontWeight: FontWeight.w800,
            ),

            const SizedBox(height: 12),

            // ==================================================================
            // MESSAGE
            // ==================================================================
            GlassSubText(
              widget.message,
              textAlign: TextAlign.center,
              fontSize: isSmallMobile ? 13 : 14,
              alpha: 0.7,
            ),

            SizedBox(height: isSmallMobile ? 22 : 28),

            // ==================================================================
            // BOUTONS
            // ==================================================================
            Row(
              children: [
                // ==============================================================
                // ANNULER
                // ==============================================================
                Expanded(
                  child: UniversalGlassButton(
                    buttonId: '${baseId}_cancel',
                    height: isSmallMobile ? 44 : 48,
                    borderRadius: 14,
                    shape: widget.shape,

                    // Anciennement GlassStyle.ghost.
                    //
                    // ghost ayant été supprimé, on utilise maintenant
                    // transparentAqua comme style neutre et translucide.
                    style: GlassStyle.transparentAqua,

                    effects: effectiveEffects,
                    label: widget.cancelText,
                    iconColor: effectiveCancelColor,
                    simpleOnTap: _handleCancel,
                  ),
                ),

                const SizedBox(width: 12),

                // ==============================================================
                // CONFIRMER
                // ==============================================================
                Expanded(
                 child: UniversalGlassButton(
  buttonId: '${baseId}_confirm',
  height: isSmallMobile ? 44 : 48,
  borderRadius: 14,
  shape: widget.shape,
  style: effectiveStyle,

  // ----------------------------------------------------------
  // EFFETS DU BOUTON CONFIRMER
  // ----------------------------------------------------------
  effects: GlassEffects(
    blur: effectiveEffects.blur,
    noise: effectiveEffects.noise,
    surfaceOpacity: (effectiveEffects.surfaceOpacity + 0.1).clamp(0.0, 1.0),
    bgGradient: [
      effectiveConfirmColor.withValues(alpha: 0.90),
      effectiveConfirmColor.withValues(alpha: 0.80),
    ],
    borderGradient: [
      effectiveConfirmColor.withValues(alpha: 0.95),
      effectiveConfirmColor.withValues(alpha: 0.85),
    ],
    enableGlow: effectiveEffects.enableGlow,
    glowOpacity: effectiveEffects.glowOpacity,
    glowBlur: effectiveEffects.glowBlur,
    enableShadow: effectiveEffects.enableShadow,
    shadowOpacity: effectiveEffects.shadowOpacity,
    shadowBlur: effectiveEffects.shadowBlur,
    shadowOffsetY: effectiveEffects.shadowOffsetY,
  ),

  label: widget.confirmText,
  iconColor: Colors.white,

  // ----------------------------------------------------------
  // CONFIRMATION
  // ----------------------------------------------------------
  futureOnTap: () async { // <- ENLEVE (buttonRef)
    if (widget.onConfirm != null) {
      await widget.onConfirm!();
    }
    if (context.mounted) {
      Navigator.of(context).pop(true);
    }
  },
),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// UNIVERSAL GLASS CONFIRM DIALOG
// ============================================================================
//
// API publique permettant d'afficher le dialogue.
//
// ============================================================================

class UniversalGlassConfirmDialog {
  /// Affiche un dialogue de confirmation Glass.
  ///
  /// Retourne :
  ///
  /// - `true`  → confirmation ;
  /// - `false` → annulation ;
  /// - `null`  → fermeture externe du dialogue.
  static Future<bool?> show(
    BuildContext context, {
    required String title,
    required String message,
    IconData? icon,
    Color? iconColor,
    String cancelText = 'Annuler',
    String confirmText = 'Confirmer',
    VoidCallback? onCancel,
    Future<void> Function()? onConfirm,
    bool barrierDismissible = true,
    Color? barrierColor,
    bool enabled = true,
    Color? accentColor,
    Color? cancelColor,
    Color? confirmColor,
    GlassStyle? style,
    GlassEffects? effects,
    GlassShapeType shape = GlassShapeType.squareRounded,
    double? width,
    String uniqueKey = '',
  }) {
    // ==========================================================================
    // LARGEUR DU DIALOGUE
    // ==========================================================================

    final double dialogWidth =
        width ?? (MediaQuery.of(context).size.width * 0.90).clamp(320.0, 520.0);

    // ==========================================================================
    // SHOW DIALOG
    // ==========================================================================

    return showDialog<bool>(
      context: context,
      barrierDismissible: barrierDismissible,

      // Transparence suffisante pour laisser apparaître
      // le rendu Glass derrière le dialogue.
      barrierColor: barrierColor ?? Colors.black.withValues(alpha: 0.65),

      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 24,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: dialogWidth),
            child: UniversalGlassConfirmDialogView(
              uniqueKey: uniqueKey,
              title: title,
              message: message,
              icon: icon,
              iconColor: iconColor,
              cancelText: cancelText,
              confirmText: confirmText,
              onCancel: onCancel,
              onConfirm: onConfirm,
              enabled: enabled,
              accentColor: accentColor,
              cancelColor: cancelColor,
              confirmColor: confirmColor,
              style: style,
              effects: effects,
              shape: shape,
            ),
          ),
        );
      },
    );
  }
}
