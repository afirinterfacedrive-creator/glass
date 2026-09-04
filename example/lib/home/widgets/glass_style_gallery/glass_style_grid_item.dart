import 'package:flutter/material.dart';
import 'package:universal_glass/glass.dart';

class GlassStyleGridItem extends StatelessWidget {
  final GlassStyle style;
  final bool isActive;
  final bool enableHover;
  final String title;
  final String description;
  final IconData icon;
  final int index;
  final bool isNew; // <-- AJOUTÉ
  final VoidCallback onTap;

  const GlassStyleGridItem({
    super.key,
    required this.style,
    required this.isActive,
    required this.enableHover,
    required this.title,
    required this.description,
    required this.icon,
    required this.index,
    this.isNew = false, // <-- AJOUTÉ
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSage = style.name.contains('sage');
    final Color accentColor = isSage
        ? const Color(0xFFE91E63) // Rouge KDTV
        : style == GlassStyle.transparentAqua
            ? Colors.cyanAccent
            : Colors.orangeAccent;

    return GlassSurfaceContainer(
      style: style,
      liftOnHover: enableHover,
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      decoration: const GlassInputDecoration(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      child: Stack(
        children: [
          // 1. BADGE ACTIVE
          if (isActive)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.2),
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(16),
                    bottomLeft: Radius.circular(12),
                  ),
                  border: Border.all(color: accentColor, width: 0.8),
                ),
                child: Text(
                  'ACTIVE',
                  style: TextStyle(
                    color: accentColor,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

          // 2. BADGE NEW
          if (isNew && !isActive)
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFE91E63),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'NEW',
                  style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),

          // 3. CONTENU
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                      color: style == GlassStyle.sageOled ? Colors.white : null,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.6),
                      fontSize: 11,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Index: ${index + 1}/${GlassStyle.values.length}', // MAJ 21 -> dynamique
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.4),
                      fontSize: 11,
                    ),
                  ),
                  Icon(
                    icon,
                    size: 18,
                    color: isSage 
                      ? accentColor.withValues(alpha: 0.7) // Icone rouge pour sage
                      : Colors.white.withValues(alpha: 0.5),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}