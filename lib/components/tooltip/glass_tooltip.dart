import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:universal_glass/components/surface/glass_surface_container.dart';

import 'package:universal_glass/enums/glass_enums.dart';
import 'package:universal_glass/theme/glass_effects.dart';
import 'package:universal_glass/core/layout/glass_layout_context.dart';
import 'package:universal_glass/core/layout/glass_layout_scope.dart';

import 'glass_tooltip_controller.dart';

/// ============================================================================
/// GLASS TOOLTIP
/// ============================================================================
///
/// Tooltip Glass personnalisé.
///
/// Exemple :
///
/// ```dart
/// GlassTooltip(
///   message: 'Modifier',
///   child: Icon(Icons.edit),
/// )
/// ```
///
/// Le tooltip utilise le contexte Glass actif.
///
/// La logique Aqua / Classic n'est pas présente dans ce widget.
/// Elle est entièrement déléguée à [GlassLayoutContext].
///
class GlassTooltip extends ConsumerStatefulWidget {
  // ==========================================================================
  // PROPRIÉTÉS
  // ==========================================================================

  /// Widget autour duquel le tooltip est affiché.
  final Widget child;

  /// Message textuel du tooltip.
  final String message;

  /// Contenu personnalisé.
  ///
  /// Si fourni, [message] n'est pas affiché.
  final Widget? content;

  /// Style Glass de la surface.
  final GlassStyle style;

  /// Effets personnalisés.
  final GlassEffects? effects;

  /// Couleur de fond personnalisée.
  final Color? backgroundColor;

  /// Couleur du texte.
  final Color? textColor;

  /// Padding interne.
  final EdgeInsetsGeometry padding;

  /// Rayon de la surface.
  final double borderRadius;

  /// Délai avant apparition.
  final Duration waitDuration;

  /// Durée d'affichage.
  final Duration showDuration;

  /// Active/désactive complètement le tooltip.
  final bool enabled;

  /// Préfère afficher le tooltip sous le widget.
  final bool preferBelow;

  /// Déclenchement au clic.
  final bool triggerOnTap;

  /// Déclenchement au survol.
  final bool triggerOnHover;

  /// Déclenchement par appui long.
  final bool triggerOnLongPress;

  // ==========================================================================
  // CONSTRUCTEUR
  // ==========================================================================

  const GlassTooltip({
    super.key,
    required this.child,
    required this.message,
    this.content,
    this.style = GlassStyle.transparentAqua,
    this.effects,
    this.backgroundColor,
    this.textColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    this.borderRadius = 12,
    this.waitDuration = const Duration(milliseconds: 500),
    this.showDuration = const Duration(seconds: 3),
    this.enabled = true,
    this.preferBelow = true,
    this.triggerOnTap = false,
    this.triggerOnHover = true,
    this.triggerOnLongPress = true,
  });

  // ==========================================================================
  // STATE
  // ==========================================================================

  @override
  ConsumerState<GlassTooltip> createState() => _GlassTooltipState();
}

// ============================================================================
// STATE
// ============================================================================

class _GlassTooltipState extends ConsumerState<GlassTooltip> {
  // ==========================================================================
  // CONTROLLER
  // ==========================================================================

  late final GlassTooltipController _controller;

  // ==========================================================================
  // OVERLAY
  // ==========================================================================

  OverlayEntry? _overlayEntry;

  // ==========================================================================
  // STATE
  // ==========================================================================

  bool _hovering = false;

  // ==========================================================================
  // INIT
  // ==========================================================================

  @override
  void initState() {
    super.initState();

    _controller = GlassTooltipController(
      onShow: _showOverlay,
      onHide: _hideOverlay,
    );
  }

  // ==========================================================================
  // DISPOSE
  // ==========================================================================

  @override
  void dispose() {
    _hideOverlay();
    _controller.reset();

    super.dispose();
  }

  // ==========================================================================
  // SCHEDULE SHOW
  // ==========================================================================

  void _scheduleShow() {
    if (!widget.enabled) {
      return;
    }

    Future<void>.delayed(widget.waitDuration, () {
      if (!mounted) {
        return;
      }

      if (widget.triggerOnHover && !_hovering) {
        return;
      }

      _controller.show();
    });
  }

  // ==========================================================================
  // SCHEDULE HIDE
  // ==========================================================================

  void _scheduleHide() {
    Future<void>.delayed(widget.showDuration, () {
      if (!mounted) {
        return;
      }

      if (!_hovering) {
        _controller.hide();
      }
    });
  }

  // ==========================================================================
  // SHOW OVERLAY
  // ==========================================================================

  void _showOverlay() {
    if (_overlayEntry != null || !mounted) {
      return;
    }

    final OverlayState? overlay = Overlay.maybeOf(context);

    if (overlay == null) {
      return;
    }

    final RenderObject? renderObject = context.findRenderObject();

    if (renderObject is! RenderBox) {
      return;
    }

    final RenderBox renderBox = renderObject;

    if (!renderBox.hasSize) {
      return;
    }

    final Offset position = renderBox.localToGlobal(Offset.zero);

    final Size size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (overlayContext) {
        return _TooltipOverlay(
          anchor: position,
          anchorSize: size,
          preferBelow: widget.preferBelow,
          child: _buildTooltipContent(),
        );
      },
    );

    overlay.insert(_overlayEntry!);

    _scheduleHide();
  }

  // ==========================================================================
  // HIDE OVERLAY
  // ==========================================================================

  void _hideOverlay() {
    final OverlayEntry? entry = _overlayEntry;

    _overlayEntry = null;

    entry?.remove();
  }

  // ==========================================================================
  // TOOLTIP CONTENT
  // ==========================================================================

  Widget _buildTooltipContent() {
    final GlassLayoutContext glass = GlassLayoutScope.of(context);

    final Color effectiveTextColor =
        widget.textColor ?? glass.palette.textPrimary;

    final GlassEffects effectiveEffects =
        widget.effects ??
        glass.effects.copyWith(borderRadius: widget.borderRadius);

    return Material(
      type: MaterialType.transparency,
      child: GlassSurfaceContainer(
        role: GlassSurfaceRole.tooltip,
        style: widget.style,
        effects: effectiveEffects,
        backgroundColor: widget.backgroundColor,
        child: Padding(
          padding: widget.padding,
          child:
              widget.content ??
              Text(
                widget.message,
                style: TextStyle(
                  color: effectiveTextColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
        ),
      ),
    );
  }

  // ==========================================================================
  // BUILD
  // ==========================================================================

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) {
      return widget.child;
    }

    Widget result = GestureDetector(
      behavior: HitTestBehavior.opaque,

      // ----------------------------------------------------------------------
      // TAP
      // ----------------------------------------------------------------------
      onTap: widget.triggerOnTap ? _controller.toggle : null,

      // ----------------------------------------------------------------------
      // LONG PRESS
      // ----------------------------------------------------------------------
      onLongPress: widget.triggerOnLongPress ? _controller.show : null,

      child: widget.child,
    );

    // ------------------------------------------------------------------------
    // HOVER
    // ------------------------------------------------------------------------

    if (widget.triggerOnHover) {
      result = MouseRegion(
        onEnter: (_) {
          _hovering = true;
          _scheduleShow();
        },
        onExit: (_) {
          _hovering = false;
          _controller.hide();
        },
        child: result,
      );
    }

    return result;
  }
}

// ============================================================================
// TOOLTIP OVERLAY
// ============================================================================

class _TooltipOverlay extends StatelessWidget {
  // ==========================================================================
  // PROPRIÉTÉS
  // ==========================================================================

  final Offset anchor;
  final Size anchorSize;

  final bool preferBelow;

  final Widget child;

  // ==========================================================================
  // CONSTRUCTEUR
  // ==========================================================================

  const _TooltipOverlay({
    required this.anchor,
    required this.anchorSize,
    required this.preferBelow,
    required this.child,
  });

  // ==========================================================================
  // BUILD
  // ==========================================================================

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.sizeOf(context);

    const double margin = 8.0;

    const double estimatedWidth = 200.0;
    const double estimatedHeight = 60.0;

    // ------------------------------------------------------------------------
    // HORIZONTAL POSITION
    // ------------------------------------------------------------------------

    final double maxLeft = screenSize.width - estimatedWidth - margin;

    final double left = anchor.dx.clamp(
      margin,
      maxLeft < margin ? margin : maxLeft,
    );

    // ------------------------------------------------------------------------
    // VERTICAL POSITIONS
    // ------------------------------------------------------------------------

    final double topBelow = anchor.dy + anchorSize.height + margin;

    final double topAbove = anchor.dy - estimatedHeight - margin;

    final bool fitsBelow =
        topBelow + estimatedHeight <= screenSize.height - margin;

    final bool fitsAbove = topAbove >= margin;

    // ------------------------------------------------------------------------
    // FINAL POSITION
    // ------------------------------------------------------------------------

    double top;

    if (preferBelow) {
      if (fitsBelow) {
        top = topBelow;
      } else if (fitsAbove) {
        top = topAbove;
      } else {
        top = topBelow.clamp(
          margin,
          screenSize.height - estimatedHeight - margin,
        );
      }
    } else {
      if (fitsAbove) {
        top = topAbove;
      } else if (fitsBelow) {
        top = topBelow;
      } else {
        top = topBelow.clamp(
          margin,
          screenSize.height - estimatedHeight - margin,
        );
      }
    }

    return Positioned(
      left: left,
      top: top,
      child: IgnorePointer(child: child),
    );
  }
}
