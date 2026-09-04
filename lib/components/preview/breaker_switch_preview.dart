import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:universal_glass/components/toggle/breaker_switch.dart';
import 'package:universal_glass/glass.dart';

class BreakerSwitchPreview extends ConsumerWidget {
  final String label;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final double width;
  final double height;

  const BreakerSwitchPreview({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.subtitle,
    this.width = 48,
    this.height = 76,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final glass = ref.watchGlassContext(context);
    final bool isSmall = glass.isSmallMobile;
    final palette = glass.theme.useAquaStyle 
        ? GlassColorPalette.aquaPreset() 
        : GlassColorPalette.classicPreset();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        BreakerSwitch(
          value: value,
          onChanged: onChanged,
          width: isSmall ? width * 0.85 : width,
          height: isSmall ? height * 0.85 : height,
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            color: palette.textPrimary,
            fontSize: isSmall ? 11 : 12,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 2),
          Text(
            subtitle!,
            style: TextStyle(
              color: palette.textTertiary,
              fontSize: isSmall ? 9 : 10,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}