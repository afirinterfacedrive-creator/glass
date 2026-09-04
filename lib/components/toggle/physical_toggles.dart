import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'toggle_types.dart';

/// ===============================================================
/// TOGGLES PHYSIQUES
///
/// IMPORTANT :
/// ToggleOrientation est défini UNIQUEMENT dans toggle_types.dart.
/// Ne pas le redéclarer ici.
/// ===============================================================

/// ===============================================================
/// 1. METAL TOGGLE SWITCH
/// Levier métallique industriel
/// ===============================================================

class MetalToggleSwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final ToggleOrientation orientation;

  final double width;
  final double height;

  const MetalToggleSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.orientation = ToggleOrientation.vertical,
    this.width = 48,
    this.height = 72,
  });

  @override
  State<MetalToggleSwitch> createState() => _MetalToggleSwitchState();
}

class _MetalToggleSwitchState extends State<MetalToggleSwitch> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final bool vertical =
        widget.orientation == ToggleOrientation.vertical;

    final double w = vertical ? widget.width : widget.height;
    final double h = vertical ? widget.height : widget.width;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        onTap: () => widget.onChanged(!widget.value),
        child: AnimatedScale(
          scale: _pressed ? 0.94 : 1.0,
          duration: const Duration(milliseconds: 100),
          child: SizedBox(
            width: w,
            height: h,
            child: CustomPaint(
              painter: _MetalTogglePainter(
                value: widget.value,
                vertical: vertical,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MetalTogglePainter extends CustomPainter {
  final bool value;
  final bool vertical;

  const _MetalTogglePainter({
    required this.value,
    required this.vertical,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint();

    final Rect rect = Offset.zero & size;

    final RRect body = RRect.fromRectAndRadius(
      rect,
      const Radius.circular(7),
    );

    paint.shader = const LinearGradient(
      colors: [
        Color(0xFF252525),
        Color(0xFF111111),
        Color(0xFF303030),
      ],
    ).createShader(rect);

    canvas.drawRRect(body, paint);

    paint.shader = null;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 1;
    paint.color = Colors.white24;

    canvas.drawRRect(body, paint);

    final double centerX = size.width / 2;
    final double centerY = size.height / 2;

    paint.style = PaintingStyle.fill;
    paint.color = Colors.black87;

    final Rect track = vertical
        ? Rect.fromCenter(
            center: Offset(centerX, centerY),
            width: size.width * 0.28,
            height: size.height * 0.72,
          )
        : Rect.fromCenter(
            center: Offset(centerX, centerY),
            width: size.width * 0.72,
            height: size.height * 0.28,
          );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        track,
        const Radius.circular(8),
      ),
      paint,
    );

    final Offset lever = vertical
        ? Offset(
            centerX,
            value ? size.height * 0.30 : size.height * 0.70,
          )
        : Offset(
            value ? size.width * 0.70 : size.width * 0.30,
            centerY,
          );

    paint.shader = const RadialGradient(
      colors: [
        Color(0xFFF5F5F5),
        Color(0xFFAAAAAA),
        Color(0xFF555555),
      ],
    ).createShader(
      Rect.fromCircle(
        center: lever,
        radius: 11,
      ),
    );

    canvas.drawCircle(lever, 10, paint);

    paint.shader = null;
    paint.color = value ? Colors.redAccent : Colors.grey;

    canvas.drawCircle(lever, 4, paint);

    _drawText(
      canvas,
      value ? 'ON' : 'OFF',
      vertical
          ? centerX
          : value
              ? size.width * 0.82
              : size.width * 0.18,
      vertical
          ? value
              ? size.height * 0.12
              : size.height * 0.88
          : centerY,
    );
  }

  void _drawText(
    Canvas canvas,
    String text,
    double x,
    double y,
  ) {
    final TextPainter painter = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 7,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    painter.layout();

    painter.paint(
      canvas,
      Offset(
        x - painter.width / 2,
        y - painter.height / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(
    covariant _MetalTogglePainter oldDelegate,
  ) {
    return oldDelegate.value != value ||
        oldDelegate.vertical != vertical;
  }
}

/// ===============================================================
/// 2. ROCKER SWITCH
/// Interrupteur à bascule
/// ===============================================================

class RockerSwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final ToggleOrientation orientation;

  final double width;
  final double height;

  const RockerSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.orientation = ToggleOrientation.vertical,
    this.width = 48,
    this.height = 68,
  });

  @override
  State<RockerSwitch> createState() => _RockerSwitchState();
}

class _RockerSwitchState extends State<RockerSwitch> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final bool vertical =
        widget.orientation == ToggleOrientation.vertical;

    final double w = vertical ? widget.width : widget.height;
    final double h = vertical ? widget.height : widget.width;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        onTap: () => widget.onChanged(!widget.value),
        child: AnimatedScale(
          scale: _pressed ? 0.95 : 1.0,
          duration: const Duration(milliseconds: 100),
          child: SizedBox(
            width: w,
            height: h,
            child: CustomPaint(
              painter: _RockerPainter(
                value: widget.value,
                vertical: vertical,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RockerPainter extends CustomPainter {
  final bool value;
  final bool vertical;

  const _RockerPainter({
    required this.value,
    required this.vertical,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;

    final Paint paint = Paint();

    final RRect body = RRect.fromRectAndRadius(
      rect,
      const Radius.circular(8),
    );

    paint.shader = const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFF292929),
        Color(0xFF111111),
        Color(0xFF3A3A3A),
      ],
    ).createShader(rect);

    canvas.drawRRect(body, paint);

    paint.shader = null;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 1;
    paint.color = Colors.white24;

    canvas.drawRRect(body, paint);

    paint.style = PaintingStyle.fill;

    final Rect rockerRect = vertical
        ? Rect.fromLTWH(
            5,
            value
                ? size.height * 0.04
                : size.height * 0.28,
            size.width - 10,
            size.height * 0.68,
          )
        : Rect.fromLTWH(
            value
                ? size.width * 0.28
                : size.width * 0.04,
            5,
            size.width * 0.68,
            size.height - 10,
          );

    final RRect rocker = RRect.fromRectAndRadius(
      rockerRect,
      const Radius.circular(7),
    );

    paint.shader = LinearGradient(
      begin: vertical
          ? Alignment.topCenter
          : Alignment.centerLeft,
      end: vertical
          ? Alignment.bottomCenter
          : Alignment.centerRight,
      colors: value
          ? const [
              Color(0xFFFF5252),
              Color(0xFFB71C1C),
              Color(0xFF651010),
            ]
          : const [
              Color(0xFF666666),
              Color(0xFF333333),
              Color(0xFF181818),
            ],
    ).createShader(rockerRect);

    canvas.drawRRect(rocker, paint);

    paint.shader = null;

    _text(
      canvas,
      'ON',
      vertical
          ? size.width / 2
          : size.width * 0.84,
      vertical
          ? size.height * 0.12
          : size.height / 2,
      value,
    );

    _text(
      canvas,
      'OFF',
      vertical
          ? size.width / 2
          : size.width * 0.16,
      vertical
          ? size.height * 0.88
          : size.height / 2,
      !value,
    );
  }

  void _text(
    Canvas canvas,
    String text,
    double x,
    double y,
    bool active,
  ) {
    final TextPainter painter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: active
              ? Colors.white
              : Colors.white38,
          fontSize: 7,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    painter.layout();

    painter.paint(
      canvas,
      Offset(
        x - painter.width / 2,
        y - painter.height / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(
    covariant _RockerPainter oldDelegate,
  ) {
    return oldDelegate.value != value ||
        oldDelegate.vertical != vertical;
  }
}

/// ===============================================================
/// 3. ROTARY SWITCH
/// Sélecteur rotatif
/// ===============================================================

class RotarySwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final ToggleOrientation orientation;

  final double size;

  const RotarySwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.orientation = ToggleOrientation.vertical,
    this.size = 70,
  });

  @override
  State<RotarySwitch> createState() => _RotarySwitchState();
}

class _RotarySwitchState extends State<RotarySwitch> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final bool vertical =
        widget.orientation == ToggleOrientation.vertical;

    final double width =
        vertical ? widget.size : widget.size * 1.35;

    final double height =
        vertical ? widget.size * 1.35 : widget.size;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        onTap: () => widget.onChanged(!widget.value),
        child: AnimatedScale(
          scale: _pressed ? 0.94 : 1.0,
          duration: const Duration(milliseconds: 100),
          child: SizedBox(
            width: width,
            height: height,
            child: CustomPaint(
              painter: _RotaryPainter(
                value: widget.value,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RotaryPainter extends CustomPainter {
  final bool value;

  const _RotaryPainter({
    required this.value,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double radius =
        size.shortestSide * 0.35;

    final Offset center = Offset(
      size.width / 2,
      size.height / 2,
    );

    final Paint paint = Paint()
      ..shader = const RadialGradient(
        colors: [
          Color(0xFFE0E0E0),
          Color(0xFF777777),
          Color(0xFF222222),
        ],
      ).createShader(
        Rect.fromCircle(
          center: center,
          radius: radius,
        ),
      );

    canvas.drawCircle(
      center,
      radius,
      paint,
    );

    paint.shader = null;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 2;
    paint.color = Colors.black54;

    canvas.drawCircle(
      center,
      radius,
      paint,
    );

    final double angle =
        value ? -0.75 : 0.75;

    paint.style = PaintingStyle.fill;
    paint.color =
        value ? Colors.redAccent : Colors.grey;

    final Offset indicator = Offset(
      center.dx +
          radius * 0.65 * math.cos(angle),
      center.dy +
          radius * 0.65 * math.sin(angle),
    );

    canvas.drawCircle(
      indicator,
      4,
      paint,
    );
  }

  @override
  bool shouldRepaint(
    covariant _RotaryPainter oldDelegate,
  ) {
    return oldDelegate.value != value;
  }
}

/// ===============================================================
/// 4. PUSH BUTTON SWITCH
/// Bouton poussoir lumineux
/// ===============================================================

class PushButtonSwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final ToggleOrientation orientation;

  final double width;
  final double height;

  const PushButtonSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.orientation = ToggleOrientation.vertical,
    this.width = 58,
    this.height = 58,
  });

  @override
  State<PushButtonSwitch> createState() =>
      _PushButtonSwitchState();
}

class _PushButtonSwitchState
    extends State<PushButtonSwitch> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final bool vertical =
        widget.orientation == ToggleOrientation.vertical;

    final double w =
        vertical ? widget.width : widget.height;

    final double h =
        vertical ? widget.height : widget.width;

    final double buttonSize = vertical
        ? widget.width * 0.70
        : widget.height * 0.70;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        onTap: () => widget.onChanged(!widget.value),
        child: AnimatedScale(
          scale: _pressed ? 0.90 : 1.0,
          duration: const Duration(milliseconds: 100),
          child: SizedBox(
            width: w,
            height: h,
            child: Center(
              child: AnimatedContainer(
                duration:
                    const Duration(milliseconds: 180),
                width: buttonSize,
                height: buttonSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: widget.value
                        ? const [
                            Color(0xFFFF6B6B),
                            Color(0xFFC00000),
                            Color(0xFF550000),
                          ]
                        : const [
                            Color(0xFF777777),
                            Color(0xFF333333),
                            Color(0xFF111111),
                          ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: widget.value
                          ? Colors.redAccent.withValues(
                              alpha: 0.7,
                            )
                          : Colors.black54,
                      blurRadius:
                          widget.value ? 14 : 5,
                    ),
                  ],
                  border: Border.all(
                    color: Colors.white24,
                  ),
                ),
                child: Center(
                  child: Text(
                    widget.value ? 'ON' : 'OFF',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// ===============================================================
/// 5. GUARDED SWITCH
/// Interrupteur avec capot de sécurité
/// ===============================================================

class GuardedSwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final ToggleOrientation orientation;

  final double width;
  final double height;

  const GuardedSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.orientation = ToggleOrientation.vertical,
    this.width = 52,
    this.height = 75,
  });

  @override
  State<GuardedSwitch> createState() =>
      _GuardedSwitchState();
}

class _GuardedSwitchState
    extends State<GuardedSwitch> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final bool vertical =
        widget.orientation == ToggleOrientation.vertical;

    final double w =
        vertical ? widget.width : widget.height;

    final double h =
        vertical ? widget.height : widget.width;

    final double innerWidth = vertical
        ? widget.width * 0.55
        : widget.height * 0.55;

    final double innerHeight = vertical
        ? widget.height * 0.55
        : widget.width * 0.55;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        onTap: () => widget.onChanged(!widget.value),
        child: AnimatedScale(
          scale: _pressed ? 0.94 : 1.0,
          duration: const Duration(milliseconds: 100),
          child: SizedBox(
            width: w,
            height: h,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF292929),
                    borderRadius:
                        BorderRadius.circular(7),
                    border: Border.all(
                      color: Colors.white24,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black54,
                        blurRadius: 7,
                        offset: Offset(2, 3),
                      ),
                    ],
                  ),
                ),
                AnimatedContainer(
                  duration:
                      const Duration(milliseconds: 200),
                  width: innerWidth,
                  height: innerHeight,
                  decoration: BoxDecoration(
                    color: widget.value
                        ? Colors.red.shade800
                        : Colors.black54,
                    borderRadius:
                        BorderRadius.circular(4),
                    border: Border.all(
                      color: Colors.white24,
                    ),
                  ),
                ),
                Text(
                  widget.value ? 'ON' : 'OFF',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
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

/// ===============================================================
/// 6. SLIDER SWITCH
/// Curseur mécanique
/// ===============================================================

class SliderSwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final ToggleOrientation orientation;

  final double width;
  final double height;

  const SliderSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.orientation = ToggleOrientation.horizontal,
    this.width = 80,
    this.height = 32,
  });

  @override
  State<SliderSwitch> createState() =>
      _SliderSwitchState();
}

class _SliderSwitchState
    extends State<SliderSwitch> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final bool vertical =
        widget.orientation == ToggleOrientation.vertical;

    final double w =
        vertical ? widget.height : widget.width;

    final double h =
        vertical ? widget.width : widget.height;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        onTap: () => widget.onChanged(!widget.value),
        child: AnimatedScale(
          scale: _pressed ? 0.96 : 1.0,
          duration: const Duration(milliseconds: 100),
          child: SizedBox(
            width: w,
            height: h,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius:
                        BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.white24,
                    ),
                  ),
                ),
                AnimatedAlign(
                  alignment: vertical
                      ? widget.value
                          ? Alignment.topCenter
                          : Alignment.bottomCenter
                      : widget.value
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                  duration:
                      const Duration(milliseconds: 220),
                  curve: Curves.easeOutBack,
                  child: Container(
                    margin: const EdgeInsets.all(4),
                    width: vertical
                        ? w * 0.65
                        : w * 0.28,
                    height: vertical
                        ? h * 0.28
                        : h * 0.65,
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(6),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: widget.value
                            ? const [
                                Color(0xFFFF5555),
                                Color(0xFF9C0000),
                              ]
                            : const [
                                Color(0xFF777777),
                                Color(0xFF333333),
                              ],
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black54,
                          blurRadius: 4,
                          offset: Offset(1, 2),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: vertical ? null : 6,
                  right: vertical ? null : 6,
                  top: vertical ? 4 : null,
                  bottom: vertical ? 4 : null,
                  child: Text(
                    widget.value ? 'ON' : 'OFF',
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 7,
                      fontWeight: FontWeight.bold,
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

/// ===============================================================
/// 7. GLASS TOGGLE SWITCH
/// Version futuriste adaptée à l'interface Glass
/// ===============================================================

class GlassToggleSwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final ToggleOrientation orientation;

  final double width;
  final double height;

  const GlassToggleSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.orientation = ToggleOrientation.horizontal,
    this.width = 82,
    this.height = 36,
  });

  @override
  State<GlassToggleSwitch> createState() =>
      _GlassToggleSwitchState();
}

class _GlassToggleSwitchState
    extends State<GlassToggleSwitch> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final bool vertical =
        widget.orientation == ToggleOrientation.vertical;

    final double w =
        vertical ? widget.height : widget.width;

    final double h =
        vertical ? widget.width : widget.height;

    final double knobSize = h * 0.72;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        onTap: () => widget.onChanged(!widget.value),
        child: AnimatedScale(
          scale: _pressed ? 0.94 : 1.0,
          duration: const Duration(milliseconds: 100),
          child: SizedBox(
            width: w,
            height: h,
            child: ClipRRect(
              borderRadius:
                  BorderRadius.circular(h / 2),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: widget.value
                        ? [
                            Colors.cyanAccent.withValues(
                              alpha: 0.45,
                            ),
                            Colors.blue.withValues(
                              alpha: 0.20,
                            ),
                          ]
                        : [
                            Colors.white.withValues(
                              alpha: 0.18,
                            ),
                            Colors.white.withValues(
                              alpha: 0.06,
                            ),
                          ],
                  ),
                  border: Border.all(
                    color: Colors.white38,
                  ),
                ),
                child: Stack(
                  children: [
                    AnimatedAlign(
                      alignment: vertical
                          ? widget.value
                              ? Alignment.topCenter
                              : Alignment.bottomCenter
                          : widget.value
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                      duration:
                          const Duration(milliseconds: 250),
                      curve: Curves.easeOutBack,
                      child: Container(
                        margin:
                            const EdgeInsets.all(4),
                        width: knobSize,
                        height: knobSize,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: widget.value
                                ? const [
                                    Colors.white,
                                    Colors.cyanAccent,
                                    Colors.blue,
                                  ]
                                : const [
                                    Colors.white70,
                                    Colors.grey,
                                  ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: widget.value
                                  ? Colors.cyanAccent
                                      .withValues(
                                      alpha: 0.75,
                                    )
                                  : Colors.black45,
                              blurRadius:
                                  widget.value ? 12 : 4,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}