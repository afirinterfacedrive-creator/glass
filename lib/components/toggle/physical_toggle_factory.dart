import 'package:flutter/material.dart';

import 'toggle_types.dart';
import 'physical_toggles.dart';
import 'glass_toggle.dart';

/// ============================================================================
/// PHYSICAL TOGGLE FACTORY
/// ============================================================================
///
/// Construit automatiquement le widget correspondant à
/// [PhysicalToggleType].
///
/// Cette factory appartient au package Glass.
///
/// Elle ne dépend d'aucune logique DataTable.
///
// ============================================================================

class PhysicalToggleFactory {
  const PhysicalToggleFactory._();

  /// ==========================================================================
  /// CONSTRUCTION DU TOGGLE
  /// ==========================================================================

  static Widget build({
    required PhysicalToggleType type,
    required bool value,
    required ValueChanged<bool> onChanged,

    ToggleOrientation orientation = ToggleOrientation.vertical,

    bool enabled = true,

    double? width,
    double? height,
    double? size,
  }) {
    // =========================================================================
    // TOGGLE DÉSACTIVÉ
    // =========================================================================

    if (!enabled) {
      return IgnorePointer(
        child: Opacity(
          opacity: 0.45,
          child: _buildToggle(
            type: type,
            value: value,
            onChanged: onChanged,
            orientation: orientation,
            width: width,
            height: height,
            size: size,
          ),
        ),
      );
    }

    // =========================================================================
    // TOGGLE ACTIF
    // =========================================================================

    return _buildToggle(
      type: type,
      value: value,
      onChanged: onChanged,
      orientation: orientation,
      width: width,
      height: height,
      size: size,
    );
  }

  /// ==========================================================================
  /// CONSTRUCTION INTERNE
  /// ==========================================================================

  static Widget _buildToggle({
    required PhysicalToggleType type,
    required bool value,
    required ValueChanged<bool> onChanged,
    required ToggleOrientation orientation,
    double? width,
    double? height,
    double? size,
  }) {
    switch (type) {
      // ========================================================================
      // BREAKER
      // ========================================================================

      case PhysicalToggleType.breaker:
        return BreakerSwitch(
          value: value,
          onChanged: onChanged,
          orientation: orientation,
          width: width ?? 42,
          height: height ?? 68,
        );

      // ========================================================================
      // METAL
      // ========================================================================

      case PhysicalToggleType.metal:
        return MetalToggleSwitch(
          value: value,
          onChanged: onChanged,
          orientation: orientation,
          width: width ?? 48,
          height: height ?? 72,
        );

      // ========================================================================
      // ROCKER
      // ========================================================================

      case PhysicalToggleType.rocker:
        return RockerSwitch(
          value: value,
          onChanged: onChanged,
          orientation: orientation,
          width: width ?? 48,
          height: height ?? 68,
        );

      // ========================================================================
      // ROTARY
      // ========================================================================

      case PhysicalToggleType.rotary:
        return RotarySwitch(
          value: value,
          onChanged: onChanged,
          orientation: orientation,
          size: size ?? 70,
        );

      // ========================================================================
      // PUSH
      // ========================================================================

      case PhysicalToggleType.push:
        return PushButtonSwitch(
          value: value,
          onChanged: onChanged,
          orientation: orientation,
          width: width ?? 58,
          height: height ?? 58,
        );

      // ========================================================================
      // GUARDED
      // ========================================================================

      case PhysicalToggleType.guarded:
        return GuardedSwitch(
          value: value,
          onChanged: onChanged,
          orientation: orientation,
          width: width ?? 52,
          height: height ?? 75,
        );

      // ========================================================================
      // SLIDER
      // ========================================================================

      case PhysicalToggleType.slider:
        return SliderSwitch(
          value: value,
          onChanged: onChanged,
          orientation: orientation,
          width: width ?? 80,
          height: height ?? 32,
        );

      // ========================================================================
      // GLASS
      // ========================================================================

      case PhysicalToggleType.glass:
        return GlassToggle(
          value: value,
          onChanged: onChanged,
          width: width ?? 65,
          height: height ?? 35,
        );
    }
  }
}
