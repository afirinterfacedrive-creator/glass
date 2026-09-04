import 'package:flutter/material.dart';

import 'physical_toggles.dart';
import 'toggle_types.dart';

class AppToggle extends StatelessWidget {
  final PhysicalToggleType type;
  final bool value;
  final ToggleOrientation orientation;
  final ValueChanged<bool> onChanged;

  const AppToggle({
    super.key,
    required this.type,
    required this.value,
    this.orientation = ToggleOrientation.horizontal,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case PhysicalToggleType.metal:
        return MetalToggleSwitch(
          value: value,
          orientation: orientation,
          onChanged: onChanged,
        );

      case PhysicalToggleType.rocker:
        return RockerSwitch(
          value: value,
          orientation: orientation,
          onChanged: onChanged,
        );

      case PhysicalToggleType.rotary:
        return RotarySwitch(
          value: value,
          orientation: orientation,
          onChanged: onChanged,
        );

      case PhysicalToggleType.push:
        return PushButtonSwitch(
          value: value,
          orientation: orientation,
          onChanged: onChanged,
        );

      case PhysicalToggleType.guarded:
        return GuardedSwitch(
          value: value,
          orientation: orientation,
          onChanged: onChanged,
        );

      case PhysicalToggleType.slider:
        return SliderSwitch(
          value: value,
          orientation: orientation,
          onChanged: onChanged,
        );

      case PhysicalToggleType.glass:
        return GlassToggleSwitch(
          value: value,
          orientation: orientation,
          onChanged: onChanged,
        );
    }
  }
}