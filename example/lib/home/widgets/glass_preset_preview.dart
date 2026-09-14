import 'dart:math';

import 'package:flutter/material.dart';
import 'package:universal_glass/glass.dart';

class GlassPresetPreview extends StatefulWidget {
  final GlassStyle style;
  final String label;
  final Color accent;
  final bool selected;
  final VoidCallback onTap;

  const GlassPresetPreview({
    super.key,
    required this.style,
    required this.label,
    required this.accent,
    required this.selected,
    required this.onTap,
  });

  @override
  State<GlassPresetPreview> createState() =>
      _GlassPresetPreviewState();
}

class _GlassPresetPreviewState
    extends State<GlassPresetPreview>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  // ==========================================================================
  // INIT
  // ==========================================================================

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();
  }

  // ==========================================================================
  // DISPOSE
  // ==========================================================================

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // ==========================================================================
  // ANIMATION
  // ==========================================================================

  bool get _shouldAnimate {
    return widget.style == GlassStyle.transparentAqua ||
        widget.style == GlassStyle.gradientOpaque ||
        widget.style == GlassStyle.customGradient ||
        widget.style == GlassStyle.solidAqua;
  }

  // ==========================================================================
  // BUILD
  // ==========================================================================

  @override
  Widget build(BuildContext context) {
    final bool animate = _shouldAnimate;

    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (
          BuildContext context,
          Widget? child,
        ) {
          final double angle =
              _controller.value * 2 * pi;

          final Alignment begin = Alignment(
            0.5 + 0.5 * cos(angle),
            0.5 + 0.5 * sin(angle),
          );

          final Alignment end = Alignment(
            0.5 - 0.5 * cos(angle),
            0.5 - 0.5 * sin(angle),
          );

          return GlassSurfaceContainer(
            style: widget.style,
            liftOnHover: true,
            padding: const EdgeInsets.all(16),
            borderRadius: BorderRadius.circular(18),
            child: Stack(
              children: [
                // =============================================================
                // 1. REFLET ANIMÉ
                // =============================================================

                if (animate)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(18),
                        gradient: LinearGradient(
                          colors: [
                            widget.accent.withValues(
                              alpha: 0.15,
                            ),
                            Colors.transparent,
                            widget.accent.withValues(
                              alpha: 0.08,
                            ),
                          ],
                          stops: const [
                            0.0,
                            0.5,
                            1.0,
                          ],
                          begin: begin,
                          end: end,
                        ),
                      ),
                    ),
                  ),

                // =============================================================
                // 2. CONTENU
                // =============================================================

                Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  mainAxisAlignment:
                      MainAxisAlignment.end,
                  children: [
                    const Spacer(),

                    Row(
                      children: [
                        // =====================================================
                        // INDICATEUR
                        // =====================================================

                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: widget.accent,
                            shape: BoxShape.circle,
                            boxShadow: animate
                                ? [
                                    BoxShadow(
                                      color: widget.accent
                                          .withValues(
                                        alpha: 0.6,
                                      ),
                                      blurRadius: 8,
                                      spreadRadius: 1,
                                    ),
                                  ]
                                : [],
                          ),
                        ),

                        const SizedBox(width: 8),

                        // =====================================================
                        // LABEL
                        // =====================================================

                        Expanded(
                          child: Text(
                            widget.label,
                            style: const TextStyle(
                              fontWeight:
                                  FontWeight.w700,
                              fontSize: 14,
                              letterSpacing: 0.3,
                            ),
                            maxLines: 1,
                            overflow:
                                TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                // =============================================================
                // 3. BORDER DE SÉLECTION
                // =============================================================

                Positioned.fill(
                  child: AnimatedContainer(
                    duration: const Duration(
                      milliseconds: 200,
                    ),
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(18),
                      border: Border.all(
                        color: widget.selected
                            ? widget.accent
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}