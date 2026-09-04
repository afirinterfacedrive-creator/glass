import 'package:flutter/material.dart';
import 'package:universal_glass/glass.dart';


/// ============================================================================
/// UNIVERSAL GLASS CONFIRM DIALOG VIEW
/// Widget pur, à utiliser directement dans un Scaffold si besoin
/// ============================================================================

class UniversalGlassConfirmDialogView extends StatefulWidget {
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
  final GlassStyle style;
  final GlassShapeType shape;

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
    this.style = GlassStyle.transparentAqua,
    this.shape = GlassShapeType.squareRounded,
  });

  @override
  State<UniversalGlassConfirmDialogView> createState() => _UniversalGlassConfirmDialogViewState();
}

class _UniversalGlassConfirmDialogViewState extends State<UniversalGlassConfirmDialogView> {
  bool _loading = false;

  Color get _accent => widget.accentColor ?? const Color(0xFF4DD0E1);
  Color get _effectiveConfirmColor => widget.confirmColor ?? _accent;
  Color get _effectiveCancelColor => widget.cancelColor ?? Colors.white.withValues(alpha: 0.72);
  Color get _effectiveIconColor => widget.iconColor ?? _accent;

  void _handleCancel() {
    if (!widget.enabled || _loading) return;
    widget.onCancel?.call();
    if (!mounted) return;
    Navigator.of(context).pop(false);
  }

  Future<void> _handleConfirm() async {
    if (!widget.enabled || _loading) return;
    final callback = widget.onConfirm;
    if (callback == null) {
      if (!mounted) return;
      Navigator.of(context).pop(true);
      return;
    }
    setState(() => _loading = true);
    try {
      await callback();
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (_) {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Widget content = Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.icon != null) ...[_buildIconBubble(), const SizedBox(height: 18)],
          Text(widget.title, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w800, height: 1.15)),
          const SizedBox(height: 10),
          Text(widget.message, textAlign: TextAlign.center, style: TextStyle(color: Colors.white.withValues(alpha: 0.70), fontSize: 14, fontWeight: FontWeight.w400, height: 1.45)),
          const SizedBox(height: 24),
          _buildActions(),
        ],
      ),
    );

    return GlassSurfaceContainer(
      decoration: const GlassInputDecoration(),
      style: widget.style,
      shape: widget.shape,
      isFocused: false,
      hasError: false,
      errorText: null,
      enabled: widget.enabled,
      borderRadius: BorderRadius.circular(20),
      padding: EdgeInsets.zero,
      liftOnHover: true,
      child: content,
    );
  }

  Widget _buildIconBubble() => GlassActionIcon(icon: widget.icon, size: 58, enabled: false, useTintedIcon: true, child: Icon(widget.icon, color: _effectiveIconColor, size: 25));

  Widget _buildActions() => Row(children: [Expanded(child: _buildActionButton(text: widget.cancelText, color: _effectiveCancelColor, onTap: _handleCancel, outlined: true)), const SizedBox(width: 10), Expanded(child: _buildActionButton(text: widget.confirmText, color: _effectiveConfirmColor, onTap: _handleConfirm, loading: _loading, outlined: false))]);

  Widget _buildActionButton({required String text, required Color color, required VoidCallback onTap, required bool outlined, bool loading = false}) {
    final bool active = widget.enabled && !loading;
    return GlassActionIcon(
      enabled: active, size: 46, onTap: active ? onTap : null, useTintedIcon: false,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160), width: double.infinity, height: 46,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: outlined ? LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Colors.white.withValues(alpha: 0.08), Colors.white.withValues(alpha: 0.025)]) : LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [color.withValues(alpha: 0.25), color.withValues(alpha: 0.10)]),
          border: Border.all(color: outlined ? Colors.white.withValues(alpha: 0.16) : color.withValues(alpha: 0.42), width: 1),
          boxShadow: outlined ? [] : [BoxShadow(color: color.withValues(alpha: 0.10), blurRadius: 9, spreadRadius: 0, offset: Offset.zero)],
        ),
        child: Center(child: loading ? SizedBox(width: 19, height: 19, child: CircularProgressIndicator(strokeWidth: 2, color: color)) : Text(text, style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w700, letterSpacing: 0.1))),
      ),
    );
  }
}

/// ============================================================================
/// UNIVERSAL GLASS CONFIRM DIALOG
/// Wrapper pour showDialog. Même pattern que les autres inputs
/// ============================================================================

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
    bool enabled = true,
    Color? accentColor,
    Color? cancelColor,
    Color? confirmColor,
    GlassStyle style = GlassStyle.transparentAqua,
    GlassShapeType shape = GlassShapeType.squareRounded,
    double? width,
  }) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double dialogWidth = width ?? (screenWidth * 0.90).clamp(320.0, 520.0);

    return showDialog<bool>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: Colors.black.withValues(alpha: 0.58),
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent, elevation: 0,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: dialogWidth),
            child: UniversalGlassConfirmDialogView(
              title: title, message: message, icon: icon, iconColor: iconColor,
              cancelText: cancelText, confirmText: confirmText, onCancel: onCancel, onConfirm: onConfirm,
              enabled: enabled, accentColor: accentColor, cancelColor: cancelColor, confirmColor: confirmColor,
              style: style, shape: shape,
            ),
          ),
        );
      },
    );
  }
}