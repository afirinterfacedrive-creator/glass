import 'package:flutter/material.dart';

// ============================================================================
// AQUA GLASS SWITCH
// ============================================================================
//
// Toggle dédié au paramètre Aqua Glass.
//
// Ce widget ne connaît pas Riverpod.
//
// Il reçoit uniquement :
//
// - value
// - accent
// - onChanged
//
// ============================================================================

class AquaGlassSwitch extends StatelessWidget {
  final bool value;

  final Color accent;

  final ValueChanged<bool> onChanged;

  const AquaGlassSwitch({
    super.key,
    required this.value,
    required this.accent,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: value,

      onChanged: onChanged,

      // ======================================================================
      // ACTIVE
      // ======================================================================
      activeColor: Colors.white,

      activeTrackColor: Colors.cyanAccent.withValues(alpha: .55),

      // ======================================================================
      // INACTIVE
      // ======================================================================
      inactiveThumbColor: Colors.white70,

      inactiveTrackColor: Colors.white.withValues(alpha: .12),

      // ======================================================================
      // BORDER
      // ======================================================================
      trackOutlineColor: WidgetStateProperty.resolveWith((
        Set<WidgetState> states,
      ) {
        if (states.contains(WidgetState.selected)) {
          return Colors.cyanAccent.withValues(alpha: .45);
        }

        return Colors.white.withValues(alpha: .16);
      }),
    );
  }
}
