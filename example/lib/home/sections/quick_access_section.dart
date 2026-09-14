import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:universal_glass/glass.dart';

import '../../routes/app_routes.dart';

class QuickAccessSection extends ConsumerStatefulWidget {
  const QuickAccessSection({super.key});

  @override
  ConsumerState<QuickAccessSection> createState() =>
      _QuickAccessSectionState();
}

class _QuickAccessSectionState extends ConsumerState<QuickAccessSection> {
  @override
  Widget build(BuildContext context) {
    final GlassLayoutContext glass = GlassLayoutScope.of(context);

    return GlassSurfaceContainer(
      style: glass.theme.glassStyle,
      effects: glass.effects,
      borderRadius: BorderRadius.circular(16),
      padding: const EdgeInsets.all(20),
      liftOnHover: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GlassSectionHeader(
            title: 'QUICK ACCESS',
            subtitle:
                'Style: ${glass.theme.glassStyle.name}, Effets dynamiques',
            icon: Icons.layers_outlined,
          ),
          const SizedBox(height: 16),
          GlassResponsiveGrid(
            spacing: 12,
            runSpacing: 12,
            mobileColumns: 1,
            tabletColumns: 2,
            desktopColumns: 4,
            children: [
              _buildActionCard(
                icon: Icons.tune_rounded,
                title: 'Control Panel',
                subtitle: 'Contrôler les\ncomposants',
                onTap: () => Navigator.of(context).pushNamed(
                  AppRoutes.controlPanel,
                ),
              ),
              _buildActionCard(
                icon: Icons.settings_rounded,
                title: 'Settings',
                subtitle: 'Configurer\nl’application',
                onTap: () => Navigator.of(context).pushNamed(
                  AppRoutes.settings,
                ),
              ),
              _buildActionCard(
                icon: Icons.toggle_on_rounded,
                title: 'Physical Toggles',
                subtitle: 'Tester les\ninterrupteurs',
                onTap: () => Navigator.of(context).pushNamed(
                  AppRoutes.physicalToggles,
                ),
              ),
              _buildActionCard(
                icon: Icons.palette_rounded,
                title: 'Appearance',
                subtitle: 'Personnaliser\nle style',
                onTap: () => Navigator.of(context).pushNamed(
                  AppRoutes.appearance,
                ),
              ),
              _buildActionCard(
                icon: Icons.layers_rounded,
                title: 'Style Gallery',
                subtitle: 'Tester les ${GlassStyle.values.length} presets',
                onTap: () => Navigator.of(context).pushNamed(
                  AppRoutes.styleGallery,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final GlassLayoutContext glass = GlassLayoutScope.of(context);

    /*
     * L'accent est maintenant indépendant de GlassStyle.
     *
     * Il suit directement le mode visuel Aqua / Classic.
     * Aucune logique liée à un ancien mode ou style Sage.
     */
    final Color accentColor = glass.theme.useAquaStyle
        ? Colors.cyanAccent
        : Colors.orangeAccent;

    return GlassSurfaceContainer(
      style: glass.theme.glassStyle,
      effects: glass.effects,
      borderRadius: BorderRadius.circular(14),
      padding: const EdgeInsets.all(14),
      liftOnHover: glass.theme.enableHover,
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 20,
              color: accentColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.5),
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            size: 20,
            color: Colors.white.withValues(alpha: 0.3),
          ),
        ],
      ),
    );
  }
}