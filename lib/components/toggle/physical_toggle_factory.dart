import 'package:flutter/material.dart';
import 'package:universal_glass/enums/glass_enums.dart';

import 'toggle_types.dart';
import 'physical_toggles.dart';
import 'glass_toggle.dart';

/// ============================================================================
/// PHYSICAL TOGGLE FACTORY
/// ============================================================================
///
/// Construit automatiquement le widget correspondant à [PhysicalToggleType].
///
/// ============================================================================

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
    GlassToggleStyle glassStyle = GlassToggleStyle.normal, // <-- NOUVEAU
    String? label, // <-- NOUVEAU
    String? subtitle, // <-- NOUVEAU
  }) {
    Widget toggle = _buildToggle(
      type: type,
      value: value,
      onChanged: onChanged,
      orientation: orientation,
      width: width,
      height: height,
      size: size,
      glassStyle: glassStyle,
      label: label,
      subtitle: subtitle,
    );

    // =========================================================================
    // TOGGLE DÉSACTIVÉ
    // =========================================================================
    if (!enabled) {
      return IgnorePointer(
        child: Opacity(opacity: 0.45, child: toggle),
      );
    }

    return toggle;
  }

  /// ==========================================================================
  /// MAPPING TAILLE
  /// ==========================================================================
  static GlassToggleSize _mapSize(double? width, double? height, double? size) {
    // Si size donné en priorité
    if (size!= null) {
      if (size <= 30) return GlassToggleSize.small;
      if (size <= 40) return GlassToggleSize.medium;
      return GlassToggleSize.large;
    }

    // Sinon on déduit via width/height
    final h = height?? width?? 35;
    if (h <= 30) return GlassToggleSize.small;
    if (h <= 38) return GlassToggleSize.medium;
    return GlassToggleSize.large;
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
    required GlassToggleStyle glassStyle,
    String? label,
    String? subtitle,
  }) {
    switch (type) {
      // ========================================================================
      // METAL
      // ========================================================================
      case PhysicalToggleType.metal:
        return MetalToggleSwitch(
          value: value,
          onChanged: onChanged,
          orientation: orientation,
          width: width?? 48,
          height: height?? 72,
        );

      // ========================================================================
      // ROCKER
      // ========================================================================
      case PhysicalToggleType.rocker:
        return RockerSwitch(
          value: value,
          onChanged: onChanged,
          orientation: orientation,
          width: width?? 48,
          height: height?? 68,
        );

      // ========================================================================
      // ROTARY
      // ========================================================================
      case PhysicalToggleType.rotary:
        return RotarySwitch(
          value: value,
          onChanged: onChanged,
          orientation: orientation,
          size: size?? 70,
        );

      // ========================================================================
      // PUSH
      // ========================================================================
      case PhysicalToggleType.push:
        return PushButtonSwitch(
          value: value,
          onChanged: onChanged,
          orientation: orientation,
          width: width?? 58,
          height: height?? 58,
        );

      // ========================================================================
      // GUARDED
      // ========================================================================
      case PhysicalToggleType.guarded:
        return GuardedSwitch(
          value: value,
          onChanged: onChanged,
          orientation: orientation,
          width: width?? 52,
          height: height?? 75,
        );

      // ========================================================================
      // SLIDER
      // ========================================================================
      case PhysicalToggleType.slider:
        return SliderSwitch(
          value: value,
          onChanged: onChanged,
          orientation: orientation,
          width: width?? 80,
          height: height?? 32,
        );

      // ========================================================================
      // GLASS - MAJ
      // ========================================================================
      case PhysicalToggleType.glass:
        return GlassToggle(
          value: value,
          onChanged: onChanged,
          style: glassStyle,
          size: _mapSize(width, height, size),
          label: label,
          subtitle: subtitle,
          enabled: true, // géré par le wrapper
        );
    }
  }
}