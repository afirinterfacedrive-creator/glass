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
  State<GlassPresetPreview> createState() => _GlassPresetPreviewState();
}

class _GlassPresetPreviewState extends State<GlassPresetPreview>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Helper pour savoir si on anime
  bool get _shouldAnimate {
    return widget.style == GlassStyle.sagePro || 
           widget.style == GlassStyle.sageGlass ||
           widget.style == GlassStyle.transparentAqua; // garde aqua animé
  }

  @override
  Widget build(BuildContext context) {
    final bool animate = _shouldAnimate;

    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return GlassSurfaceContainer(
            style: widget.style,
            liftOnHover: true,
            padding: const EdgeInsets.all(16),
            borderRadius: BorderRadius.circular(18),
            child: Stack(
              children: [
                // 1. REFLET ANIMÉ PAR DESSUS
                if (animate)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        gradient: LinearGradient(
                          colors: widget.style.name.contains('sage') 
                            ? [ // Glow rouge pour Sage
                                widget.accent.withValues(alpha: .15),
                                Colors.transparent,
                                widget.accent.withValues(alpha: .08),
                              ]
                            : [ // Reflet blanc pour Aqua
                                Colors.white.withValues(alpha: .25),
                                Colors.transparent,
                                Colors.white.withValues(alpha: .1),
                              ],
                          stops: const [0.0, 0.5, 1.0],
                          begin: Alignment(
                            0.5 + 0.5 * cos(_controller.value * 6.28),
                            0.5 + 0.5 * sin(_controller.value * 6.28),
                          ),
                          end: Alignment(
                            0.5 - 0.5 * cos(_controller.value * 6.28),
                            0.5 - 0.5 * sin(_controller.value * 6.28),
                          ),
                        ),
                      ),
                    ),
                  ),

                // 2. CONTENU
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Spacer(),
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: widget.accent,
                            shape: BoxShape.circle,
                            boxShadow: animate ? [ // Glow sur le point
                              BoxShadow(
                                color: widget.accent.withValues(alpha: 0.6),
                                blurRadius: 8,
                                spreadRadius: 1,
                              )
                            ] : [],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            widget.label,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              letterSpacing: 0.3,
                              color: widget.style == GlassStyle.sageOled 
                                ? Colors.white 
                                : null,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                // 3. BORDER DE SELECTION
                Positioned.fill(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: widget.selected
                            ? widget.style.name.contains('sage')
                                ? widget.accent // Bordure rouge pour sage
                                : Colors.white.withValues(alpha: .9)
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