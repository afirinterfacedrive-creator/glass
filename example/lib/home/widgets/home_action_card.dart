import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:universal_glass/glass.dart';

class HomeActionCard extends ConsumerWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const HomeActionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final glass = ref.watchGlassContext(context);
    final theme = glass.theme;
    final palette = glass.palette;

    final bool isSmallMobile = glass.isSmallMobile;

    // FIX FINAL: Utilise direct palette.accent 
    // En sagePro/sageOled -> #E50914 auto. En aqua -> #4DD0E1 auto.
    final Color accentColor = palette.accent;

    return GlassSurfaceContainer(
      style: theme.glassStyle,
      effects: glass.effects,
      width: double.infinity, 
      constraints: BoxConstraints(minHeight: isSmallMobile ? 86 : 102),
      padding: EdgeInsets.all(isSmallMobile ? 12 : 16),
      borderRadius: BorderRadius.circular(isSmallMobile ? 12 : 18),
      liftOnHover: theme.enableHover,
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: isSmallMobile ? 36 : 40,
            height: isSmallMobile ? 36 : 40,
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: isSmallMobile ? 18 : 20, color: accentColor),
          ),
          SizedBox(width: isSmallMobile ? 10 : 14),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GlassText(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  fontSize: isSmallMobile ? 13 : 14,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(height: 4),
                GlassText(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  fontSize: isSmallMobile ? 10 : 11,
                  height: 1.25,
                  alpha: 0.7,
                ),
              ],
            ),
          ),
          const SizedBox(width: 4),
          Icon(
            Icons.chevron_right_rounded,
            size: isSmallMobile ? 18 : 20,
            color: Colors.white.withValues(alpha: 0.3),
          ),
        ],
      ),
    );
  }
}