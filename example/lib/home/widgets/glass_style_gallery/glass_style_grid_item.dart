
import 'package:flutter/material.dart';
import 'package:universal_glass/glass.dart';

class GlassStyleGridItem extends StatefulWidget {
  final GlassStyle style;
  final bool isActive;
  final bool enableHover;
  final String title;
  final String description;
  final IconData icon;
  final int index;
  final VoidCallback onTap;

  /// Couleur d'accent résolue par le parent
  /// à partir de la palette utilisateur.
  final Color accentColor;

  /// Couleur principale du texte.
  final Color textPrimary;

  /// Couleur secondaire du texte.
  final Color textSecondary;

  /// Couleur tertiaire du texte.
  final Color textTertiary;

  /// Couleur utilisée pour les bordures neutres.
  final Color border;

  const GlassStyleGridItem({
    super.key,
    required this.style,
    required this.isActive,
    required this.enableHover,
    required this.title,
    required this.description,
    required this.icon,
    required this.index,
    required this.onTap,
    required this.accentColor,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.border,
  });

  @override
  State<GlassStyleGridItem> createState() =>
      _GlassStyleGridItemState();
}

class _GlassStyleGridItemState
    extends State<GlassStyleGridItem> {
  bool _isHovered = false;

  bool get _highlighted =>
      widget.isActive || _isHovered;

  @override
  Widget build(BuildContext context) {
    final Color accent =
        widget.accentColor;

    final Color textPrimary =
        widget.textPrimary;

    final Color textSecondary =
        widget.textSecondary;

    final Color textTertiary =
        widget.textTertiary;

    final Color border =
        widget.border;

    return MouseRegion(
      cursor: SystemMouseCursors.click,

      // ================================================================
      // HOVER ENTER
      // ================================================================

      onEnter: widget.enableHover
          ? (_) {
              if (!mounted) return;

              setState(() {
                _isHovered = true;
              });
            }
          : null,

      // ================================================================
      // HOVER EXIT
      // ================================================================

      onExit: widget.enableHover
          ? (_) {
              if (!mounted) return;

              setState(() {
                _isHovered = false;
              });
            }
          : null,

      child: AnimatedScale(
        scale: widget.enableHover &&
                _isHovered
            ? 1.012
            : 1.0,
        duration:
            const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,

        child: GlassSurfaceContainer(
          style: widget.style,
          liftOnHover:
              widget.enableHover,
          borderRadius:
              BorderRadius.circular(18),
          padding:
              const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
          onTap: widget.onTap,

          decoration:
              const GlassInputDecoration(
            fontSize: 14,
            fontWeight:
                FontWeight.w600,
          ),

          child: ClipRRect(
            borderRadius:
                BorderRadius.circular(18),

            child: Stack(
              fit: StackFit.expand,
              children: [
                // ======================================================
                // ACCENT GLOW
                // ======================================================

                Positioned(
                  top: -35,
                  right: -25,

                  child:
                      AnimatedContainer(
                    duration:
                        const Duration(
                      milliseconds: 220,
                    ),

                    width:
                        _highlighted
                            ? 105
                            : 80,

                    height:
                        _highlighted
                            ? 105
                            : 80,

                    decoration:
                        BoxDecoration(
                      shape:
                          BoxShape.circle,

                      boxShadow: [
                        BoxShadow(
                          color:
                              accent.withValues(
                            alpha:
                                widget.isActive
                                    ? 0.16
                                    : _isHovered
                                        ? 0.10
                                        : 0.04,
                          ),
                          blurRadius:
                              _highlighted
                                  ? 34
                                  : 24,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ),

                // ======================================================
                // ACTIVE BADGE
                // ======================================================

                AnimatedPositioned(
                  duration:
                      const Duration(
                    milliseconds: 220,
                  ),
                  curve:
                      Curves.easeOutCubic,

                  top:
                      widget.isActive
                          ? 8
                          : -30,

                  right: 8,

                  child:
                      AnimatedOpacity(
                    duration:
                        const Duration(
                      milliseconds: 180,
                    ),

                    opacity:
                        widget.isActive
                            ? 1
                            : 0,

                    child: _ActiveBadge(
                      accent: accent,
                    ),
                  ),
                ),

                // ======================================================
                // MAIN CONTENT
                // ======================================================

                Positioned.fill(
                  child: Padding(
                    padding:
                        const EdgeInsets.fromLTRB(
                      12,
                      8,
                      12,
                      8,
                    ),

                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,

                      children: [
                        // =================================================
                        // HEADER
                        // =================================================

                        SizedBox(
                          height: 42,

                          child: Row(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,

                            children: [
                              // -------------------------------------------
                              // STYLE ICON
                              // -------------------------------------------

                              _StyleIcon(
                                icon:
                                    widget.icon,
                                accent:
                                    accent,
                                active:
                                    widget.isActive,
                                hovered:
                                    _isHovered,
                              ),

                              const SizedBox(
                                width: 10,
                              ),

                              // -------------------------------------------
                              // TITLE + CATEGORY
                              // -------------------------------------------

                              Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets
                                          .only(
                                    top: 1,
                                  ),

                                  child: Column(
                                    mainAxisSize:
                                        MainAxisSize.min,

                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,

                                    children: [
                                      // ---------------------------------
                                      // TITLE
                                      // ---------------------------------

                                      Text(
                                        widget.title,
                                        maxLines: 1,
                                        overflow:
                                            TextOverflow
                                                .ellipsis,

                                        style:
                                            TextStyle(
                                          color:
                                              textPrimary
                                                  .withValues(
                                            alpha:
                                                0.94,
                                          ),
                                          fontSize: 15,
                                          fontWeight:
                                              FontWeight
                                                  .w700,
                                          letterSpacing:
                                              0.2,
                                        ),
                                      ),

                                      const SizedBox(
                                        height: 2,
                                      ),

                                      // ---------------------------------
                                      // CATEGORY
                                      // ---------------------------------

                                      Text(
                                        _styleCategory,
                                        maxLines: 1,
                                        overflow:
                                            TextOverflow
                                                .ellipsis,

                                        style:
                                            TextStyle(
                                          color:
                                              accent
                                                  .withValues(
                                            alpha:
                                                0.78,
                                          ),
                                          fontSize:
                                              9.5,
                                          fontWeight:
                                              FontWeight
                                                  .w600,
                                          letterSpacing:
                                              0.8,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(
                          height: 7,
                        ),

                        // =================================================
                        // DESCRIPTION
                        // =================================================

                        SizedBox(
                          height: 32,
                          width:
                              double.infinity,

                          child: Text(
                            widget.description,

                            maxLines: 2,

                            overflow:
                                TextOverflow
                                    .ellipsis,

                            style:
                                TextStyle(
                              color:
                                  textSecondary
                                      .withValues(
                                alpha: 0.57,
                              ),
                              fontSize: 11.5,
                              height: 1.35,
                              fontWeight:
                                  FontWeight.w400,
                            ),
                          ),
                        ),

                        const SizedBox(
                          height: 8,
                        ),

                        // =================================================
                        // BOTTOM ACTION
                        // =================================================

                        SizedBox(
                          height: 17,

                          child: Row(
                            children: [
                              // -------------------------------------------
                              // ACCENT LINE
                              // -------------------------------------------

                              Expanded(
                                child:
                                    AnimatedContainer(
                                  duration:
                                      const Duration(
                                    milliseconds: 180,
                                  ),

                                  height: 1,

                                  decoration:
                                      BoxDecoration(
                                    gradient:
                                        LinearGradient(
                                      colors: [
                                        accent.withValues(
                                          alpha:
                                              widget.isActive
                                                  ? 0.45
                                                  : _isHovered
                                                      ? 0.25
                                                      : 0.10,
                                        ),
                                        Colors.transparent,
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(
                                width: 10,
                              ),

                              // -------------------------------------------
                              // ACTION ICON
                              // -------------------------------------------

                              AnimatedSwitcher(
                                duration:
                                    const Duration(
                                  milliseconds: 180,
                                ),

                                transitionBuilder:
                                    (
                                  child,
                                  animation,
                                ) {
                                  return ScaleTransition(
                                    scale:
                                        animation,

                                    child:
                                        FadeTransition(
                                      opacity:
                                          animation,
                                      child:
                                          child,
                                    ),
                                  );
                                },

                                child:
                                    widget.isActive
                                        ? Icon(
                                            Icons
                                                .check_circle_rounded,
                                            key:
                                                const ValueKey(
                                              'active',
                                            ),
                                            size: 17,
                                            color:
                                                accent,
                                          )
                                        : Icon(
                                            Icons
                                                .arrow_forward_rounded,
                                            key:
                                                const ValueKey(
                                              'inactive',
                                            ),
                                            size: 16,
                                            color:
                                                textTertiary
                                                    .withValues(
                                              alpha:
                                                  _isHovered
                                                      ? 0.75
                                                      : 0.32,
                                            ),
                                          ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // ======================================================
                // ACTIVE BORDER
                // ======================================================

                IgnorePointer(
                  child:
                      AnimatedOpacity(
                    duration:
                        const Duration(
                      milliseconds: 180,
                    ),

                    opacity:
                        widget.isActive
                            ? 1
                            : 0,

                    child: Container(
                      decoration:
                          BoxDecoration(
                        borderRadius:
                            BorderRadius
                                .circular(
                          18,
                        ),

                        border:
                            Border.all(
                          color:
                              accent.withValues(
                            alpha: 0.65,
                          ),
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                ),

                // ======================================================
                // HOVER BORDER
                // ======================================================

                IgnorePointer(
                  child:
                      AnimatedOpacity(
                    duration:
                        const Duration(
                      milliseconds: 160,
                    ),

                    opacity:
                        widget.enableHover &&
                                _isHovered
                            ? 1
                            : 0,

                    child: Container(
                      decoration:
                          BoxDecoration(
                        borderRadius:
                            BorderRadius
                                .circular(
                          18,
                        ),

                        border:
                            Border.all(
                          color:
                              border.withValues(
                            alpha: 0.14,
                          ),
                          width: 0.7,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ========================================================================
  // STYLE CATEGORY
  // ========================================================================

  String get _styleCategory {
    switch (widget.style) {
      case GlassStyle.opaqueMat:
        return 'OPAQUE';

      case GlassStyle.gradientOpaque:
        return 'GRADIENT';

      case GlassStyle.customGradient:
        return 'CUSTOM';

      case GlassStyle.solidAqua:
        return 'AQUA';

      case GlassStyle.solidClassic:
        return 'CLASSIC';

      case GlassStyle.opaqueHeavy:
        return 'HEAVY';

      case GlassStyle.transparentAqua:
      case GlassStyle.transparentRed:
      case GlassStyle.transparentGreen:
        return 'TRANSPARENT';

      case GlassStyle.classicSb:
        return 'CLASSIC SB';

      case GlassStyle.custom:
        return 'CUSTOM';
    }
  }
}

// ============================================================================
// ACTIVE BADGE
// ============================================================================

class _ActiveBadge extends StatelessWidget {
  final Color accent;

  const _ActiveBadge({
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),

      decoration:
          BoxDecoration(
        color:
            accent.withValues(
          alpha: 0.10,
        ),

        borderRadius:
            BorderRadius.circular(20),

        border:
            Border.all(
          color:
              accent.withValues(
            alpha: 0.38,
          ),
          width: 0.7,
        ),
      ),

      child: Row(
        mainAxisSize:
            MainAxisSize.min,

        children: [
          // ----------------------------------------------------------------
          // STATUS DOT
          // ----------------------------------------------------------------

          Container(
            width: 5,
            height: 5,

            decoration:
                BoxDecoration(
              shape:
                  BoxShape.circle,

              color: accent,

              boxShadow: [
                BoxShadow(
                  color:
                      accent.withValues(
                    alpha: 0.55,
                  ),
                  blurRadius: 5,
                ),
              ],
            ),
          ),

          const SizedBox(
            width: 5,
          ),

          // ----------------------------------------------------------------
          // LABEL
          // ----------------------------------------------------------------

          Text(
            'ACTIVE',

            style: TextStyle(
              color: accent,
              fontSize: 8,
              fontWeight:
                  FontWeight.w800,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// STYLE ICON
// ============================================================================

class _StyleIcon extends StatelessWidget {
  final IconData icon;
  final Color accent;
  final bool active;
  final bool hovered;

  const _StyleIcon({
    required this.icon,
    required this.accent,
    required this.active,
    required this.hovered,
  });

  @override
  Widget build(BuildContext context) {
    final bool highlighted =
        active || hovered;

    return AnimatedContainer(
      duration:
          const Duration(
        milliseconds: 180,
      ),

      curve:
          Curves.easeOutCubic,

      width: 42,
      height: 42,

      decoration:
          BoxDecoration(
        borderRadius:
            BorderRadius.circular(13),

        // ================================================================
        // ACCENT BACKGROUND
        // ================================================================

        color:
            accent.withValues(
          alpha: active
              ? 0.15
              : hovered
                  ? 0.10
                  : 0.055,
        ),

        // ================================================================
        // ACCENT BORDER
        // ================================================================

        border:
            Border.all(
          color:
              accent.withValues(
            alpha: active
                ? 0.45
                : hovered
                    ? 0.28
                    : 0.12,
          ),
          width:
              active ? 0.9 : 0.7,
        ),

        // ================================================================
        // ACCENT GLOW
        // ================================================================

        boxShadow:
            highlighted
                ? [
                    BoxShadow(
                      color:
                          accent.withValues(
                        alpha:
                            active
                                ? 0.16
                                : 0.08,
                      ),
                      blurRadius: 12,
                      spreadRadius: -2,
                    ),
                  ]
                : null,
      ),

      child: Center(
        child: AnimatedScale(
          scale:
              hovered ? 1.08 : 1.0,

          duration:
              const Duration(
            milliseconds: 160,
          ),

          child: Icon(
            icon,
            size: 20,

            color:
                accent.withValues(
              alpha: active
                  ? 1.0
                  : hovered
                      ? 0.9
                      : 0.68,
            ),
          ),
        ),
      ),
    );
  }
}
