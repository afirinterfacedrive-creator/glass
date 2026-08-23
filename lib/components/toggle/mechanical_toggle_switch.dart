import 'package:flutter/material.dart';

class MechanicalToggleSwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  final double width;
  final double height;

  const MechanicalToggleSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.width = 58,
    this.height = 72,
  });

  @override
  State<MechanicalToggleSwitch> createState() => _MechanicalToggleSwitchState();
}

class _MechanicalToggleSwitchState extends State<MechanicalToggleSwitch> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final double centerX = widget.width / 2;

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
          scale: _pressed ? 0.94 : 1.0,
          duration: const Duration(milliseconds: 100),

          child: SizedBox(
            width: widget.width,
            height: widget.height,

            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,

              children: [
                // =================================================
                // CORPS DE L'INTERRUPTEUR
                // =================================================
                Container(
                  width: widget.width,
                  height: widget.height,

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),

                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(0xFF3A3A3A),
                        const Color(0xFF161616),
                        const Color(0xFF080808),
                      ],
                    ),

                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.20),
                    ),

                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.55),
                        blurRadius: 8,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                ),

                // =================================================
                // PLAQUE INTERNE
                // =================================================
                Container(
                  width: widget.width - 12,
                  height: widget.height - 10,

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),

                    color: const Color(0xFF202020),

                    border: Border.all(
                      color: Colors.black.withValues(alpha: 0.8),
                    ),
                  ),
                ),

                // =================================================
                // OFF
                // =================================================
                Positioned(
                  top: 5,
                  child: Text(
                    'ON',
                    style: TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                      color: widget.value ? Colors.redAccent : Colors.white38,
                    ),
                  ),
                ),

                // =================================================
                // OFF
                // =================================================
                Positioned(
                  bottom: 5,
                  child: Text(
                    'OFF',
                    style: TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                      color: !widget.value ? Colors.white70 : Colors.white30,
                    ),
                  ),
                ),

                // =================================================
                // AXE DU LEVIER
                // =================================================
                Positioned(
                  left: centerX - 6,
                  top: widget.height / 2 - 6,

                  child: Container(
                    width: 12,
                    height: 12,

                    decoration: BoxDecoration(
                      shape: BoxShape.circle,

                      gradient: const RadialGradient(
                        colors: [
                          Color(0xFFAAAAAA),
                          Color(0xFF333333),
                          Color(0xFF111111),
                        ],
                      ),

                      border: Border.all(color: Colors.white24),
                    ),
                  ),
                ),

                // =================================================
                // LEVIER
                // =================================================
                AnimatedRotation(
                  turns: widget.value ? 0.0 : 0.075,

                  duration: const Duration(milliseconds: 220),

                  curve: Curves.easeOutBack,

                  child: Transform.translate(
                    offset: const Offset(0, -9),

                    child: Container(
                      width: 12,
                      height: 34,

                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),

                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            const Color(0xFF7A0000),
                            Colors.redAccent,
                            const Color(0xFF8B0000),
                          ],
                        ),

                        border: Border.all(
                          color: Colors.red.shade200.withValues(alpha: 0.55),
                          width: 1,
                        ),

                        boxShadow: [
                          BoxShadow(
                            color: Colors.red.withValues(
                              alpha: widget.value ? 0.65 : 0.25,
                            ),
                            blurRadius: widget.value ? 10 : 4,
                          ),

                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.6),
                            blurRadius: 4,
                            offset: const Offset(2, 3),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // =================================================
                // VOYANT ROUGE
                // =================================================
                Positioned(
                  top: 17,
                  right: 9,

                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),

                    width: 5,
                    height: 5,

                    decoration: BoxDecoration(
                      shape: BoxShape.circle,

                      color: widget.value
                          ? Colors.redAccent
                          : Colors.red.shade900,

                      boxShadow: widget.value
                          ? [
                              BoxShadow(
                                color: Colors.redAccent.withValues(alpha: 0.8),
                                blurRadius: 7,
                              ),
                            ]
                          : null,
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
}
