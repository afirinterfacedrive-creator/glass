import 'package:flutter/material.dart';

import 'package:glass/glass.dart';

// ============================================================================
// THEME STYLE SWITCH
// ============================================================================
//
// Sélecteur du style visuel global.
//
// Classic  <── GlassBreakerSwitch ──>  Aqua
//
// Cette classe ne connaît pas Riverpod.
//
// Elle reçoit simplement :
//
// - la valeur actuelle
// - le callback de modification
//
// ============================================================================

class ThemeStyleSwitch extends StatelessWidget {
  final bool useAquaStyle;

  final ValueChanged<bool> onChanged;

  const ThemeStyleSwitch({
    super.key,
    required this.useAquaStyle,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ====================================================================
        // CLASSIC
        // ====================================================================
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 180),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(opacity: animation, child: child);
          },
          child: Icon(
            Icons.layers_clear,
            key: ValueKey<bool>(useAquaStyle),
            color: useAquaStyle ? Colors.white54 : Colors.orangeAccent,
            size: 20,
          ),
        ),

        const SizedBox(width: 8),

        // ====================================================================
        // TOGGLE
        // ====================================================================
        GlassBreakerSwitch(value: useAquaStyle, onChanged: onChanged),

        const SizedBox(width: 8),

        // ====================================================================
        // AQUA
        // ====================================================================
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 180),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(opacity: animation, child: child);
          },
          child: Icon(
            Icons.opacity,
            key: ValueKey<bool>(useAquaStyle),
            color: useAquaStyle ? Colors.cyanAccent : Colors.white54,
            size: 20,
          ),
        ),
      ],
    );
  }
}
