import 'package:flutter/material.dart';

class AppearanceColorRow
    extends StatelessWidget {
  final String label;
  final Color color;

  final VoidCallback? onTap;

  final String? description;

  final bool enabled;

  final double colorSize;

  final bool showHex;

  const AppearanceColorRow({
    super.key,
    required this.label,
    required this.color,
    this.onTap,
    this.description,
    this.enabled = true,
    this.colorSize = 32,
    this.showHex = true,
  });

  String get _hexColor {
    final int value = color.toARGB32();

    final String hex =
        value.toRadixString(16).padLeft(8, '0');

    return '#${hex.substring(2).toUpperCase()}';
  }

  @override
  Widget build(BuildContext context) {
    final Color textColor =
        Theme.of(context).colorScheme.onSurface;

    final Color secondaryColor =
        textColor.withValues(alpha: 0.60);

    return Opacity(
      opacity: enabled ? 1.0 : 0.45,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: enabled ? onTap : null,
          borderRadius:
              BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 4,
            ),
            child: Row(
              children: [
                _buildColorPreview(),

                const SizedBox(width: 12),

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
                          fontWeight: FontWeight.w600,
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

                if (showHex)
                  Text(
                    _hexColor,
                    style: TextStyle(
                      color: secondaryColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                const SizedBox(width: 8),

                Icon(
                  Icons.chevron_right_rounded,
                  size: 20,
                  color: secondaryColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildColorPreview() {
    return Container(
      width: colorSize,
      height: colorSize,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white.withValues(
            alpha: 0.35,
          ),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(
              alpha: 0.30,
            ),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
    );
  }
}