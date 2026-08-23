import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';

import '../enums/glass_enums.dart';
import '../theme/glass_effects.dart';

import 'glass_icon.dart';
import 'glass_painter.dart';

class GlassButton extends StatefulWidget {
  final Widget? child;

  final GlassEffects effects;

  final GlassShapeType shape;

  final GlassStyle style;

  final VoidCallback onTap;

  final double? width;

  final double? height;

  final String? label;

  final IconData? leadingIcon;

  final Color? leadingIconColor;

  final double leadingIconScale;

  final bool leadingIconIsActive;

  final VoidCallback? onLeadingIconTap;

  final double? fontSize;

  final bool showSpinner;

  final bool replaceIcon;

  final SpinnerPosition spinnerPosition;

  final double borderRadius;

  // ==========================================================================
  // TEXTE EN DESSOUS
  // ==========================================================================

  final String? subLabel;

  final TextStyle? subLabelStyle;

  final double subLabelSpacing;

  const GlassButton({
    super.key,
    this.child,
    required this.effects,
    required this.shape,
    required this.onTap,
    this.width,
    this.height = 60.0,
    this.style = GlassStyle.transparentAqua,
    this.borderRadius = 35.0,
    this.label,
    this.leadingIcon,
    this.leadingIconColor,
    this.leadingIconScale = 60.0,
    this.leadingIconIsActive = false,
    this.onLeadingIconTap,
    this.fontSize,
    this.showSpinner = false,
    this.replaceIcon = false,
    this.spinnerPosition = SpinnerPosition.left,
    this.subLabel,
    this.subLabelStyle,
    this.subLabelSpacing = 6.0,
  });

  @override
  State<GlassButton> createState() => _GlassButtonState();
}

class _GlassButtonState extends State<GlassButton> {
  bool _isPressed = false;

  // ==========================================================================
  // PADDING HORIZONTAL
  // ==========================================================================

  double _getContentHorizontalPadding() {
    switch (widget.shape) {
      case GlassShapeType.circle:
      case GlassShapeType.capsuleVertical:
        return 0.0;

      case GlassShapeType.squareRounded:
      case GlassShapeType.pillHorizontal:
        return 12.0;
    }
  }

  // ==========================================================================
  // DIMENSION DE RÉFÉRENCE POUR L'ICÔNE
  // ==========================================================================

  double _getIconReferenceDimension(double width, double height) {
    switch (widget.shape) {
      case GlassShapeType.circle:
        return math.min(width, height);

      case GlassShapeType.capsuleVertical:
        // Pour une capsule verticale, l'icône doit être calculée
        // principalement à partir de la largeur.
        return width;

      case GlassShapeType.pillHorizontal:
        return height;

      case GlassShapeType.squareRounded:
        return math.min(width, height);
    }
  }

  // ==========================================================================
  // TAILLE RÉELLE DE L'ICÔNE
  // ==========================================================================

  double _getRealIconSize(double width, double height) {
    final double reference = _getIconReferenceDimension(width, height);

    final double scale = widget.leadingIconScale.clamp(0.0, 100.0);

    final double calculated = reference * scale / 100.0;

    // Marge minimale pour éviter qu'une icône touche le bord.
    const double safetyMargin = 4.0;

    final double maxAllowed = math.max(
      1.0,
      math.min(width, height) - safetyMargin,
    );

    return calculated.clamp(1.0, maxAllowed);
  }

  // ==========================================================================
  // TAILLE MAXIMALE DU CONTENU
  // ==========================================================================

  double _getAvailableContentWidth(double width) {
    final double horizontalPadding = _getContentHorizontalPadding();

    return math.max(1.0, width - (horizontalPadding * 2));
  }

  // ==========================================================================
  // BUILD
  // ==========================================================================

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double finalWidth =
            widget.width ??
            (constraints.hasBoundedWidth ? constraints.maxWidth : 200.0);

        final double finalHeight = widget.height ?? 60.0;

        final double realIconSize = _getRealIconSize(finalWidth, finalHeight);

        final _GlassWidgetClipper clipper = _GlassWidgetClipper(
          shape: widget.shape,
          radius: widget.borderRadius,
        );

        final double horizontalPadding = _getContentHorizontalPadding();

        final double availableContentWidth = _getAvailableContentWidth(
          finalWidth,
        );

        return MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,

            // ==================================================================
            // PRESS DOWN
            // ==================================================================
            onTapDown: (_) {
              if (!mounted) return;

              setState(() {
                _isPressed = true;
              });
            },

            // ==================================================================
            // PRESS UP
            // ==================================================================
            onTapUp: (_) {
              if (!mounted) return;

              setState(() {
                _isPressed = false;
              });
            },

            // ==================================================================
            // PRESS CANCEL
            // ==================================================================
            onTapCancel: () {
              if (!mounted) return;

              setState(() {
                _isPressed = false;
              });
            },

            // ==================================================================
            // TAP
            // ==================================================================
            onTap: widget.onTap,

            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedScale(
                  scale: _isPressed ? 0.94 : 1.0,
                  duration: const Duration(milliseconds: 100),
                  curve: Curves.easeOut,

                  child: SizedBox(
                    width: finalWidth,
                    height: finalHeight,

                    child: ClipPath(
                      clipper: clipper,

                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: widget.effects.blur,
                          sigmaY: widget.effects.blur,
                        ),

                        child: Stack(
                          fit: StackFit.expand,
                          alignment: Alignment.center,

                          children: [
                            // ==================================================
                            // GLASS PAINTER
                            // ==================================================
                            IgnorePointer(
                              child: CustomPaint(
                                painter: GlassPainter(
                                  effects: widget.effects,
                                  shapeType: widget.shape,
                                  useAquaReflect:
                                      widget.style ==
                                      GlassStyle.transparentAqua,
                                  customRadius: widget.borderRadius,
                                ),
                              ),
                            ),

                            // ==================================================
                            // CONTENU
                            // ==================================================
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: horizontalPadding,
                              ),

                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth: availableContentWidth,
                                  maxHeight: finalHeight,
                                ),

                                child:
                                    widget.child ??
                                    _buildDynamicContent(
                                      finalHeight,
                                      realIconSize,
                                      availableContentWidth,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // ==============================================================
                // SUB LABEL
                // ==============================================================
                if (widget.subLabel != null) ...[
                  SizedBox(height: widget.subLabelSpacing),

                  Text(
                    widget.subLabel!,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style:
                        widget.subLabelStyle ??
                        const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.white70,
                          letterSpacing: 0.5,
                          shadows: [
                            Shadow(
                              color: Colors.black26,
                              blurRadius: 2,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  // ==========================================================================
  // CONTENU DYNAMIQUE
  // ==========================================================================

  Widget _buildDynamicContent(
    double calculatedHeight,
    double realIconSize,
    double availableWidth,
  ) {
    // =========================================================================
    // MODE ICÔNE SEULE
    // =========================================================================

    final bool isIconOnly =
        (widget.shape == GlassShapeType.circle ||
            widget.shape == GlassShapeType.capsuleVertical) &&
        widget.leadingIcon != null &&
        widget.label == null &&
        !widget.showSpinner;

    if (isIconOnly) {
      return Center(
        child: _buildGlassIcon(math.min(realIconSize, availableWidth)),
      );
    }

    // =========================================================================
    // SPINNER
    // =========================================================================

    final double spinnerSize = (calculatedHeight * 0.40).clamp(16.0, 28.0);

    final Widget spinner = SizedBox(
      width: spinnerSize,
      height: spinnerSize,

      child: const CircularProgressIndicator(
        strokeWidth: 2.2,
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      ),
    );

    // =========================================================================
    // CONTENU
    // =========================================================================

    final List<Widget> items = [];

    // =========================================================================
    // SPINNER GAUCHE
    // =========================================================================

    if (widget.showSpinner && widget.spinnerPosition == SpinnerPosition.left) {
      items.add(spinner);

      if (!widget.replaceIcon && widget.leadingIcon != null) {
        items.add(const SizedBox(width: 8));
      }
    }

    // =========================================================================
    // ICÔNE
    // =========================================================================

    if (widget.leadingIcon != null) {
      if (!(widget.showSpinner && widget.replaceIcon)) {
        items.add(
          Flexible(
            fit: FlexFit.loose,
            child: _buildGlassIcon(math.min(realIconSize, availableWidth)),
          ),
        );
      }
    }

    // =========================================================================
    // ESPACE ICÔNE / LABEL
    // =========================================================================

    if (items.isNotEmpty && widget.label != null) {
      items.add(const SizedBox(width: 10));
    }

    // =========================================================================
    // LABEL
    // =========================================================================

    if (widget.label != null) {
      items.add(
        Flexible(
          fit: FlexFit.loose,

          child: Text(
            widget.label!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,

            style: TextStyle(
              fontWeight: FontWeight.w900,
              color: Colors.white,
              fontSize: widget.fontSize ?? (calculatedHeight * 0.24),
              letterSpacing: 0.8,
            ),
          ),
        ),
      );
    }

    // =========================================================================
    // SPINNER DROITE
    // =========================================================================

    if (widget.showSpinner && widget.spinnerPosition == SpinnerPosition.right) {
      if (widget.label != null || widget.leadingIcon != null) {
        items.add(const SizedBox(width: 10));
      }

      items.add(spinner);
    }

    // =========================================================================
    // AUCUN CONTENU
    // =========================================================================

    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    // =========================================================================
    // ROW SÉCURISÉ
    // =========================================================================

    return SizedBox(
      width: availableWidth,

      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: items,
      ),
    );
  }

  // ==========================================================================
  // GLASS ICON
  // ==========================================================================

  Widget _buildGlassIcon(double realIconSize) {
    return Center(
      child: GlassIcon(
        icon: widget.leadingIcon!,
        baseColor: widget.leadingIconColor ?? Colors.white,
        size: realIconSize,
        isActive: widget.leadingIconIsActive,
        onTap: widget.onLeadingIconTap ?? widget.onTap,
      ),
    );
  }
}

// =============================================================================
// GLASS BUTTON CLIPPER
// =============================================================================

class _GlassWidgetClipper extends CustomClipper<Path> {
  final GlassShapeType shape;

  final double radius;

  const _GlassWidgetClipper({required this.shape, required this.radius});

  @override
  Path getClip(Size size) {
    final Path path = Path();

    final Rect rect = Offset.zero & size;

    switch (shape) {
      // ========================================================================
      // CIRCLE
      // ========================================================================

      case GlassShapeType.circle:
        final double diameter = math.min(size.width, size.height);

        final double left = (size.width - diameter) / 2;

        final double top = (size.height - diameter) / 2;

        path.addOval(Rect.fromLTWH(left, top, diameter, diameter));

        break;

      // ========================================================================
      // SQUARE ROUNDED
      // ========================================================================

      case GlassShapeType.squareRounded:
        final double maxRadius = math.min(size.width, size.height) / 2;

        final double safeRadius = radius.clamp(0.0, maxRadius);

        path.addRRect(
          RRect.fromRectAndRadius(rect, Radius.circular(safeRadius)),
        );

        break;

      // ========================================================================
      // CAPSULE VERTICAL
      // ========================================================================

      case GlassShapeType.capsuleVertical:
        final double capsuleRadius = math.min(size.width, size.height) / 2;

        path.addRRect(
          RRect.fromRectAndRadius(rect, Radius.circular(capsuleRadius)),
        );

        break;

      // ========================================================================
      // PILL HORIZONTAL
      // ========================================================================

      case GlassShapeType.pillHorizontal:
        final double pillRadius = math.min(size.width, size.height) / 2;

        path.addRRect(
          RRect.fromRectAndRadius(rect, Radius.circular(pillRadius)),
        );

        break;
    }

    return path;
  }

  @override
  bool shouldReclip(covariant _GlassWidgetClipper oldClipper) {
    return oldClipper.shape != shape || oldClipper.radius != radius;
  }
}
