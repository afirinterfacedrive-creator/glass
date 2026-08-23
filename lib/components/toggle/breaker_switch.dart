import 'package:flutter/material.dart';

class BreakerSwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  final double width;
  final double height;

  const BreakerSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.width = 42,
    this.height = 68,
  });

  @override
  State<BreakerSwitch> createState() => _BreakerSwitchState();
}

class _BreakerSwitchState extends State<BreakerSwitch> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,

        onTapDown: (_) {
          setState(() {
            _pressed = true;
          });
        },

        onTapUp: (_) {
          setState(() {
            _pressed = false;
          });
        },

        onTapCancel: () {
          setState(() {
            _pressed = false;
          });
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
              alignment: Alignment.center,
              children: [
                // =================================================
                // CORPS DU DISJONCTEUR
                // =================================================
                Container(
                  width: widget.width,
                  height: widget.height,

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),

                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFFE5E5E5),
                        Color(0xFF9E9E9E),
                        Color(0xFF666666),
                      ],
                    ),

                    border: Border.all(color: Colors.black45, width: 1),

                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black45,
                        blurRadius: 6,
                        offset: Offset(2, 4),
                      ),
                    ],
                  ),
                ),

                // =================================================
                // FACE AVANT
                // =================================================
                Container(
                  width: widget.width - 7,
                  height: widget.height - 6,

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),

                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFFFAFAFA),
                        Color(0xFFD0D0D0),
                        Color(0xFFAAAAAA),
                      ],
                    ),

                    border: Border.all(color: Colors.black26),
                  ),
                ),

                // =================================================
                // I — POSITION ON
                // =================================================
                Positioned(
                  top: 2,
                  child: IgnorePointer(
                    child: Text(
                      'I',
                      style: TextStyle(
                        fontSize: 9,
                        height: 1,
                        fontWeight: FontWeight.w900,
                        color: widget.value ? Colors.black87 : Colors.black38,
                      ),
                    ),
                  ),
                ),

                // =================================================
                // O — POSITION OFF
                // =================================================
                Positioned(
                  bottom: 2,
                  child: IgnorePointer(
                    child: Text(
                      'O',
                      style: TextStyle(
                        fontSize: 9,
                        height: 1,
                        fontWeight: FontWeight.w900,
                        color: !widget.value ? Colors.black87 : Colors.black38,
                      ),
                    ),
                  ),
                ),

                // =================================================
                // CAVITÉ CENTRALE DU LEVIER
                //
                // On laisse une vraie zone libre en haut
                // et en bas pour que I et O restent visibles.
                // =================================================
                Positioned(
                  top: 16,
                  bottom: 16,

                  child: Container(
                    width: widget.width * 0.46,

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),

                      gradient: const LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Color(0xFF777777),
                          Color(0xFF444444),
                          Color(0xFF888888),
                        ],
                      ),

                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black38,
                          blurRadius: 3,
                          offset: Offset(1, 2),
                        ),
                      ],
                    ),
                  ),
                ),

                // =================================================
                // LEVIER
                // =================================================
                AnimatedAlign(
                  alignment: widget.value
                      ? Alignment.topCenter
                      : Alignment.bottomCenter,

                  duration: const Duration(milliseconds: 230),

                  curve: Curves.easeOutBack,

                  child: Container(
                    width: widget.width * 0.38,
                    height: widget.height * 0.24,

                    margin: EdgeInsets.only(
                      top: widget.value ? 16 : 0,
                      bottom: widget.value ? 0 : 16,
                    ),

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),

                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,

                        colors: widget.value
                            ? const [
                                Color(0xFFFF3333),
                                Color(0xFFB40000),
                                Color(0xFF720000),
                              ]
                            : const [
                                Color(0xFF777777),
                                Color(0xFF555555),
                                Color(0xFF333333),
                              ],
                      ),

                      border: Border.all(color: Colors.black54),

                      boxShadow: [
                        BoxShadow(
                          color: widget.value
                              ? Colors.red.withValues(alpha: 0.55)
                              : Colors.black.withValues(alpha: 0.35),

                          blurRadius: widget.value ? 8 : 3,

                          offset: const Offset(1, 2),
                        ),
                      ],
                    ),
                  ),
                ),

                // =================================================
                // VOYANT ROUGE
                // =================================================
                Positioned(
                  right: 5,
                  top: 14,

                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),

                    width: 4,
                    height: 4,

                    decoration: BoxDecoration(
                      shape: BoxShape.circle,

                      color: widget.value ? Colors.redAccent : Colors.black38,

                      boxShadow: widget.value
                          ? [
                              BoxShadow(
                                color: Colors.redAccent.withValues(alpha: 0.85),
                                blurRadius: 6,
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
