import 'package:flutter/material.dart';

// ============================================================================
// SETTING SECTION
// ============================================================================
//
// Conteneur Glass générique des réglages.
//
// ============================================================================

class SettingSection extends StatelessWidget {
  final String title;

  final Color accent;

  final List<Widget> children;

  const SettingSection({
    super.key,
    required this.title,
    required this.accent,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        // ====================================================================
        // TITRE
        // ====================================================================
        Text(
          title.toUpperCase(),

          style: TextStyle(
            color: accent,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.3,
          ),
        ),

        const SizedBox(height: 10),

        // ====================================================================
        // CONTENEUR
        // ====================================================================
        Container(
          width: double.infinity,

          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: .065),

            borderRadius: BorderRadius.circular(18),

            border: Border.all(color: Colors.white.withValues(alpha: .12)),

            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: .12),

                blurRadius: 18,

                offset: const Offset(0, 6),
              ),
            ],
          ),

          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),

            child: Column(children: children),
          ),
        ),
      ],
    );
  }
}
