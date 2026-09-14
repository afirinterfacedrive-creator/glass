import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:universal_glass/enums/glass_enums.dart';
import 'package:universal_glass/provider/glass_theme_provider.dart';
import 'package:universal_glass/provider/glass_theme_state.dart';
import 'package:universal_glass/theme/glass_color_palette.dart';

import 'glass_toggle_knob.dart';
import 'glass_toggle_track.dart';

/// ============================================================================
/// GLASS TOGGLE
/// ============================================================================


class GlassToggle extends ConsumerStatefulWidget {
  /// État actuel du toggle.
  final bool value;

  /// Callback appelé lors du changement d'état. Si null = désactivé visuel
  final ValueChanged<bool>? onChanged; // <-- MAJ: ?

  /// Label à gauche du toggle
  final String? label;

  /// Sous-texte sous le label
  final String? subtitle;

  /// Couleur principale lorsque le toggle est actif.
  /// Si null, prend la couleur du theme auto
  final Color? activeColor;

  /// Taille du toggle
  final GlassToggleSize size;

  /// Style du toggle
  final GlassToggleStyle style;

  /// Permet d'activer ou désactiver l'interaction. Auto = false si onChanged == null
  final bool enabled;

  const GlassToggle({
    super.key,
    required this.value,
    this.onChanged, // <-- MAJ: plus required
    this.label,
    this.subtitle,
    this.activeColor,
    this.size = GlassToggleSize.medium,
    this.style = GlassToggleStyle.normal,
    this.enabled = true,
  });

  @override
  ConsumerState<GlassToggle> createState() => _GlassToggleState();
}

class _GlassToggleState extends ConsumerState<GlassToggle> {
  bool _pressed = false;

  bool get _isDisabled => !widget.enabled || widget.onChanged == null; // <-- AJOUTE

  double _getWidth(GlassToggleSize size) {
    switch (size) {
      case GlassToggleSize.small: return widget.style == GlassToggleStyle.breaker ? 70 : 52;
      case GlassToggleSize.medium: return widget.style == GlassToggleStyle.breaker ? 78 : 65;
      case GlassToggleSize.large: return widget.style == GlassToggleStyle.breaker ? 86 : 78;
    }
  }

  double _getHeight(GlassToggleSize size) {
    switch (size) {
      case GlassToggleSize.small: return widget.style == GlassToggleStyle.breaker ? 36 : 28;
      case GlassToggleSize.medium: return widget.style == GlassToggleStyle.breaker ? 42 : 35;
      case GlassToggleSize.large: return widget.style == GlassToggleStyle.breaker ? 48 : 42;
    }
  }

  // ==========================================================================
  // INTERACTION
  // ==========================================================================

  void _handleTap() {
    if (_isDisabled) return; // <-- MAJ
    widget.onChanged!(!widget.value); // <-- ! car on a checké
  }

  void _handleTapDown(TapDownDetails details) {
    if (_isDisabled) return;
    setState(() => _pressed = true);
  }

  void _handleTapUp(TapUpDetails details) {
    if (_isDisabled) return;
    setState(() => _pressed = false);
  }

  void _handleTapCancel() {
    if (_isDisabled) return;
    setState(() => _pressed = false);
  }

  // ==========================================================================
  // BUILD BREAKER STYLE
  // ==========================================================================
  Widget _buildBreaker(double width, double height, GlassColorPalette palette) {
    final bool on = widget.value;
    
    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // CORPS
          AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOut,
            width: width,
            height: height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: on
                  ? LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Colors.white.withValues(alpha: .28), Colors.white.withValues(alpha: .10), Colors.black.withValues(alpha: .18)])
                  : const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFFE0E0E0), Color(0xFF9E9E9E), Color(0xFF555555)]),
              border: Border.all(color: on ? Colors.white.withValues(alpha: .42) : Colors.black.withValues(alpha: .50)),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: on ? .28 : .45), blurRadius: on ? 8 : 6, offset: const Offset(2, 3))],
            ),
          ),
          // CAVITÉ
          AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            width: width * .52,
            height: height * .55,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7),
              gradient: on
                  ? LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.black.withValues(alpha: .30), Colors.black.withValues(alpha: .16), Colors.white.withValues(alpha: .08)])
                  : const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFF666666), Color(0xFF383838), Color(0xFF151515)]),
              border: Border.all(color: on ? Colors.white.withValues(alpha: .18) : Colors.black.withValues(alpha: .65)),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: on ? .25 : .45), blurRadius: 4)],
            ),
          ),
          // LEVIER
          Positioned(
            left: width * .19,
            right: width * .19,
            top: 0,
            bottom: 0,
            child: AnimatedAlign(
              alignment: on ? Alignment.centerRight : Alignment.centerLeft,
              duration: const Duration(milliseconds: 240),
              curve: Curves.easeOutBack,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: width * .20,
                height: height * .68,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  gradient: on
                      ? LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Colors.redAccent.withValues(alpha: .95), Colors.red.shade800.withValues(alpha: .85), Colors.red.shade900.withValues(alpha: .75)])
                      : const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFFD0D0D0), Color(0xFF8A8A8A), Color(0xFF444444)]),
                  border: Border.all(color: on ? Colors.white.withValues(alpha: .38) : Colors.black.withValues(alpha: .45)),
                  boxShadow: [BoxShadow(color: on ? Colors.redAccent.withValues(alpha: .55) : Colors.black.withValues(alpha: .35), blurRadius: on ? 9 : 4, offset: const Offset(1, 2))],
                ),
              ),
            ),
          ),
          // O
          Positioned(left: 5, child: IgnorePointer(child: _buildLabel('O', !on, palette))),
          // I
          Positioned(right: 5, child: IgnorePointer(child: _buildLabel('I', on, palette))),
          // VOYANT
          Positioned(
            right: 5,
            top: 3,
            child: IgnorePointer(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 4,
                height: 4,
                decoration: BoxDecoration(shape: BoxShape.circle, color: on ? Colors.redAccent : Colors.black38, boxShadow: on ? [BoxShadow(color: Colors.redAccent.withValues(alpha: .85), blurRadius: 6)] : null),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text, bool active, GlassColorPalette palette) {
    return AnimatedDefaultTextStyle(
      duration: const Duration(milliseconds: 150),
      style: TextStyle(color: active ? Colors.white : Colors.black.withValues(alpha: .38), fontSize: 8, fontWeight: FontWeight.w900, shadows: active ? [Shadow(color: Colors.black.withValues(alpha: .40), blurRadius: 3)] : null),
      child: Text(text),
    );
  }

  // ==========================================================================
  // BUILD NORMAL STYLE
  // ==========================================================================
  Widget _buildNormal(double width, double height, Color activeColor) {
    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(child: GlassToggleTrack(value: widget.value, activeColor: activeColor)),
          GlassToggleKnob(value: widget.value, activeColor: activeColor, width: width, height: height),
        ],
      ),
    );
  }

  // ==========================================================================
  // BUILD
  // ==========================================================================

  @override
  Widget build(BuildContext context) {
    final GlassThemeState theme = ref.watch(glassThemeProvider);
    final bool useAqua = theme.useAquaStyle;
    final GlassColorPalette palette = useAqua ? GlassColorPalette.aquaPreset() : GlassColorPalette.classicPreset();

    final double width = _getWidth(widget.size);
    final double height = _getHeight(widget.size);
    final Color activeColor = widget.activeColor ?? palette.primaryForStyle(useAqua);

    Widget toggle = widget.style == GlassToggleStyle.breaker 
        ? _buildBreaker(width, height, palette)
        : _buildNormal(width, height, activeColor);

    if (_isDisabled) toggle = Opacity(opacity: 0.45, child: toggle); // <-- MAJ

    Widget content = AnimatedScale(
      scale: _pressed ? 0.94 : 1.0,
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeOutCubic,
      child: toggle,
    );

    if (widget.label != null || widget.subtitle != null) {
      content = Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.label != null) Text(widget.label!, style: TextStyle(color: palette.textPrimary, fontSize: 15, fontWeight: FontWeight.w600)),
                if (widget.subtitle != null) Padding(padding: const EdgeInsets.only(top: 2), child: Text(widget.subtitle!, style: TextStyle(color: palette.textSecondary, fontSize: 12, height: 1.3))),
              ],
            ),
          ),
          const SizedBox(width: 12),
          content,
        ],
      );
    }

    return MouseRegion(
      cursor: _isDisabled ? SystemMouseCursors.basic : SystemMouseCursors.click, // <-- MAJ
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _isDisabled ? null : _handleTap, // <-- MAJ
        onTapDown: _isDisabled ? null : _handleTapDown,
        onTapUp: _isDisabled ? null : _handleTapUp,
        onTapCancel: _isDisabled ? null : _handleTapCancel,
        child: content,
      ),
    );
  }
}