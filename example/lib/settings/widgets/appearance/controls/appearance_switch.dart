import 'package:flutter/material.dart';

class AppearanceSwitch extends StatelessWidget {
  final String label;
  final String? description;

  final bool value;
  final ValueChanged<bool> onChanged;

  final bool enabled;

  final IconData? icon;

  const AppearanceSwitch({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.description,
    this.enabled = true,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final Color textColor =
        Theme.of(context).colorScheme.onSurface;

    final Color secondaryColor =
        textColor.withValues(alpha: 0.60);

    return Opacity(
      opacity: enabled ? 1.0 : 0.45,
      child: InkWell(
        borderRadius:
            BorderRadius.circular(12),
        onTap: enabled
            ? () => onChanged(!value)
            : null,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 6,
            horizontal: 2,
          ),
          child: Row(
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 18,
                  color: value
                      ? textColor
                      : secondaryColor,
                ),
                const SizedBox(width: 10),
              ],

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    if (description != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        description!,
                        style: TextStyle(
                          color: secondaryColor,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              Switch(
                value: value,
                onChanged:
                    enabled ? onChanged : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}