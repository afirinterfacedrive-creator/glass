import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:universal_glass/components/surface/glass_surface_container.dart';
import 'package:universal_glass/components/universal_glass_button.dart';
import 'package:universal_glass/enums/glass_enums.dart';
import 'package:universal_glass/settings/widgets/glass_text.dart';
import 'package:universal_glass/theme/glass_effects.dart';
import 'package:universal_glass/utils/glass_theme_extension.dart';

class UniversalGlassConfirmDialogView extends ConsumerStatefulWidget {
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
  final String uniqueKey;

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
  ConsumerState<UniversalGlassConfirmDialogView> createState() => _UniversalGlassConfirmDialogViewState();
}

class _UniversalGlassConfirmDialogViewState extends ConsumerState<UniversalGlassConfirmDialogView> {

  void _handleCancel() {
    widget.onCancel?.call();
    Navigator.of(context).pop(false);
  }

  @override
  Widget build(BuildContext context) {
    final glass = ref.watchGlassContext(context);
    final bool isSmallMobile = glass.isSmallMobile; // <- UTILISE PARTOUT
    final bool isBackgroundLight = glass.theme.surfaceOpacity > 0.5;

    final GlassStyle effectiveStyle = widget.style ?? glass.effectiveGlassStyle;
    final GlassEffects effectiveEffects = widget.effects ?? glass.effects;

    final Color accent = widget.accentColor ?? glass.palette.accent;
    final Color effectiveConfirmColor = widget.confirmColor ?? accent;
    final Color effectiveCancelColor = widget.cancelColor ?? (isBackgroundLight ? const Color(0xFF475569) : glass.palette.textSecondary);

    final String baseId = '${widget.uniqueKey}_${widget.title.hashCode}';

    return GlassSurfaceContainer(
      style: effectiveStyle,
      effects: effectiveEffects,
      shape: widget.shape,
      enabled: widget.enabled,
      borderRadius: BorderRadius.circular(isSmallMobile ? 16 : 20),
      padding: EdgeInsets.zero,
      liftOnHover: true,
      child: Padding(
        padding: EdgeInsets.fromLTRB(isSmallMobile ? 20 : 24, isSmallMobile ? 24 : 32, isSmallMobile ? 20 : 24, isSmallMobile ? 20 : 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.icon != null) ...[
              Icon(widget.icon, color: widget.iconColor ?? accent, size: isSmallMobile ? 32 : 38), 
              SizedBox(height: isSmallMobile ? 14 : 18)
            ],
            // <- REMPLACE PAR GLASSTEXT
            GlassText(
              widget.title, 
              textAlign: TextAlign.center, 
              fontSize: isSmallMobile ? 18 : 20, 
              fontWeight: FontWeight.w800,
            ),
            const SizedBox(height: 12),
            // <- REMPLACE PAR GLASSSUBTEXT
            GlassSubText(
              widget.message, 
              //textAlign: TextAlign.center, 
              fontSize: isSmallMobile ? 13 : 14,
              alpha: isBackgroundLight ? 0.7 : 0.7, // garde la logique
            ),
            SizedBox(height: isSmallMobile ? 22 : 28),
            Row(
              children: [
                // Bouton Annuler
                Expanded(
                  child: UniversalGlassButton(
                    buttonId: '${baseId}_cancel',
                    height: isSmallMobile ? 44 : 48,
                    borderRadius: 14,
                    shape: widget.shape,
                    style: GlassStyle.ghost,
                    effects: effectiveEffects,
                    label: widget.cancelText,
                    iconColor: effectiveCancelColor,
                    simpleOnTap: _handleCancel,
                  ),
                ),
                const SizedBox(width: 12),
                // Bouton Confirmer
                Expanded(
                  child: UniversalGlassButton(
                    buttonId: '${baseId}_confirm',
                    height: isSmallMobile ? 44 : 48,
                    borderRadius: 14,
                    shape: widget.shape,
                    style: effectiveStyle,
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
                    futureOnTap: (buttonRef) async {
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

class UniversalGlassConfirmDialog {
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
    final double dialogWidth = width ?? (MediaQuery.of(context).size.width * 0.90).clamp(320.0, 520.0);
    
    return showDialog<bool>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor ?? Colors.black.withValues(alpha: 0.65), // <- baisse pour voir le glass
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: dialogWidth),
            child: UniversalGlassConfirmDialogView(
              uniqueKey: uniqueKey,
              title: title, message: message, icon: icon, iconColor: iconColor,
              cancelText: cancelText, confirmText: confirmText, onCancel: onCancel, onConfirm: onConfirm,
              enabled: enabled, accentColor: accentColor, cancelColor: cancelColor, confirmColor: confirmColor, 
              style: style, effects: effects,
              shape: shape,
            ),
          ),
        );
      },
    );
  }
}