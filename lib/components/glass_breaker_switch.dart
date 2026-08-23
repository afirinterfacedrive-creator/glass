import 'package:flutter/material.dart';

/// ===============================================================
/// GLASS BREAKER SWITCH
///
/// ON  → Corps Glass + levier rouge
/// OFF → Corps métal gris + levier gris
///
/// O / I toujours visibles
/// ===============================================================

class GlassBreakerSwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  final double width;
  final double height;

  const GlassBreakerSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.width = 78,
    this.height = 42,
  });

  @override
  State<GlassBreakerSwitch> createState() => _GlassBreakerSwitchState();
}

class _GlassBreakerSwitchState extends State<GlassBreakerSwitch> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final bool on = widget.value;

    return MouseRegion(
      cursor: SystemMouseCursors.click,

      child: GestureDetector(
        behavior: HitTestBehavior.opaque,

        onTapDown: (_) {
          setState(() => _pressed = true);
        },

        onTapUp: (_) {
          setState(() => _pressed = false);
        },

        onTapCancel: () {
          setState(() => _pressed = false);
        },

        onTap: () {
          widget.onChanged(!widget.value);
        },

        child: AnimatedScale(
          scale: _pressed ? .94 : 1.0,

          duration: const Duration(milliseconds: 100),

          curve: Curves.easeOut,

          child: SizedBox(
            width: widget.width,
            height: widget.height,

            child: Stack(
              alignment: Alignment.center,

              children: [
                // =================================================
                // CORPS
                //
                // ON  = GLASS
                // OFF = MÉTAL
                // =================================================
                AnimatedContainer(
                  duration: const Duration(milliseconds: 220),

                  curve: Curves.easeOut,

                  width: widget.width,
                  height: widget.height,

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),

                    gradient: on
                        ? LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,

                            colors: [
                              Colors.white.withValues(alpha: .28),
                              Colors.white.withValues(alpha: .10),
                              Colors.black.withValues(alpha: .18),
                            ],
                          )
                        : const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,

                            colors: [
                              Color(0xFFE0E0E0),
                              Color(0xFF9E9E9E),
                              Color(0xFF555555),
                            ],
                          ),

                    border: Border.all(
                      color: on
                          ? Colors.white.withValues(alpha: .42)
                          : Colors.black.withValues(alpha: .50),
                    ),

                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: on ? .28 : .45),
                        blurRadius: on ? 8 : 6,
                        offset: const Offset(2, 3),
                      ),
                    ],
                  ),
                ),

                // =================================================
                // CAVITÉ
                //
                // Elle reste entre les zones O et I.
                // =================================================
                AnimatedContainer(
                  duration: const Duration(milliseconds: 220),

                  width: widget.width * .52,
                  height: widget.height * .55,

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),

                    gradient: on
                        ? LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,

                            colors: [
                              Colors.black.withValues(alpha: .30),
                              Colors.black.withValues(alpha: .16),
                              Colors.white.withValues(alpha: .08),
                            ],
                          )
                        : const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,

                            colors: [
                              Color(0xFF666666),
                              Color(0xFF383838),
                              Color(0xFF151515),
                            ],
                          ),

                    border: Border.all(
                      color: on
                          ? Colors.white.withValues(alpha: .18)
                          : Colors.black.withValues(alpha: .65),
                    ),

                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: on ? .25 : .45),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),

                // =================================================
                // ZONE DU LEVIER
                //
                // Levier limité au centre pour ne jamais
                // recouvrir O et I.
                // =================================================
                Positioned(
                  left: widget.width * .19,
                  right: widget.width * .19,
                  top: 0,
                  bottom: 0,

                  child: AnimatedAlign(
                    alignment: on
                        ? Alignment.centerRight
                        : Alignment.centerLeft,

                    duration: const Duration(milliseconds: 240),

                    curve: Curves.easeOutBack,

                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),

                      width: widget.width * .20,
                      height: widget.height * .68,

                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),

                        // =========================================
                        // ON  = ROUGE
                        // OFF = MÉTAL
                        // =========================================
                        gradient: on
                            ? LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,

                                colors: [
                                  Colors.redAccent.withValues(alpha: .95),
                                  Colors.red.shade800.withValues(alpha: .85),
                                  Colors.red.shade900.withValues(alpha: .75),
                                ],
                              )
                            : const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,

                                colors: [
                                  Color(0xFFD0D0D0),
                                  Color(0xFF8A8A8A),
                                  Color(0xFF444444),
                                ],
                              ),

                        border: Border.all(
                          color: on
                              ? Colors.white.withValues(alpha: .38)
                              : Colors.black.withValues(alpha: .45),
                        ),

                        boxShadow: [
                          BoxShadow(
                            color: on
                                ? Colors.redAccent.withValues(alpha: .55)
                                : Colors.black.withValues(alpha: .35),

                            blurRadius: on ? 9 : 4,

                            offset: const Offset(1, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // =================================================
                // O — OFF
                // =================================================
                Positioned(
                  left: 5,

                  child: IgnorePointer(child: _buildLabel('O', !on)),
                ),

                // =================================================
                // I — ON
                // =================================================
                Positioned(
                  right: 5,

                  child: IgnorePointer(child: _buildLabel('I', on)),
                ),

                // =================================================
                // VOYANT
                // =================================================
                Positioned(
                  right: 5,
                  top: 3,

                  child: IgnorePointer(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),

                      width: 4,
                      height: 4,

                      decoration: BoxDecoration(
                        shape: BoxShape.circle,

                        color: on ? Colors.redAccent : Colors.black38,

                        boxShadow: on
                            ? [
                                BoxShadow(
                                  color: Colors.redAccent.withValues(
                                    alpha: .85,
                                  ),
                                  blurRadius: 6,
                                ),
                              ]
                            : null,
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

  // =============================================================
  // LABEL O / I
  // =============================================================

  Widget _buildLabel(String text, bool active) {
    return AnimatedDefaultTextStyle(
      duration: const Duration(milliseconds: 150),

      style: TextStyle(
        color: active ? Colors.white : Colors.black.withValues(alpha: .38),

        fontSize: 8,

        fontWeight: FontWeight.w900,

        shadows: active
            ? [
                Shadow(
                  color: Colors.black.withValues(alpha: .40),
                  blurRadius: 3,
                ),
              ]
            : null,
      ),

      child: Text(text),
    );
  }
}
