import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:universal_glass/glass.dart'; // <- Import global

import '../../routes/app_routes.dart';
import 'home_action_card.dart';

class HomeQuickAccess extends ConsumerStatefulWidget {
  const HomeQuickAccess({super.key});

  @override
  ConsumerState<HomeQuickAccess> createState() => _HomeQuickAccessState();
}

class _HomeQuickAccessState extends ConsumerState<HomeQuickAccess> {
  @override
  Widget build(BuildContext context) {
    final glass = ref.watchGlassContext(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final double maxWidth = constraints.maxWidth;
        const double spacing = 16.0;

        int crossAxisCount = 1;
        if (maxWidth >= 1100) {
          crossAxisCount = 5; // <- Passé à 6 pour la nouvelle carte
        } else if (maxWidth >= 850) {
          crossAxisCount = 3; 
        } else if (maxWidth >= 500) {
          crossAxisCount = 2; 
        }

        final double cardWidth = (maxWidth - (spacing * (crossAxisCount - 1))) / crossAxisCount;

        return GlassSurfaceContainer( 
          style: glass.theme.glassStyle,
          effects: glass.effects,
          borderRadius: BorderRadius.circular(glass.isSmallMobile ? 14 : 20),
          padding: glass.dynamicPadding,
          liftOnHover: glass.theme.enableHover,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GlassSectionHeader(
                title: 'Quick Access',
                subtitle: '${GlassStyle.values.length + 1} raccourcis disponibles', // <- +1
                icon: Icons.rocket_launch_rounded,
              ),

              SizedBox(height: glass.isSmallMobile ? 16 : 24),

              Wrap(
                spacing: spacing,
                runSpacing: 12, 
                children: [
                  SizedBox(
                    width: cardWidth, 
                    child: HomeActionCard(
                      icon: Icons.tune_rounded,
                      title: 'Control Panel',
                      subtitle: 'Contrôler les composants',
                      onTap: () => Navigator.of(context).pushNamed(AppRoutes.controlPanel),
                    ),
                  ),
                  SizedBox(
                    width: cardWidth,
                    child: HomeActionCard(
                      icon: Icons.settings_rounded,
                      title: 'Settings',
                      subtitle: 'Configurer l’application',
                      onTap: () => Navigator.of(context).pushNamed(AppRoutes.settings),
                    ),
                  ),
                  SizedBox(
                    width: cardWidth,
                    child: HomeActionCard(
                      icon: Icons.design_services_rounded, // <- NOUVELLE ICÔNE
                      title: 'Glass Settings', // <- NOUVELLE CARTE
                      subtitle: 'Configurer le glass global',
                      onTap: () => Navigator.of(context).pushNamed(AppRoutes.glassGlobalSettings),
                    ),
                  ),
                  SizedBox(
                    width: cardWidth,
                    child: HomeActionCard(
                      icon: Icons.toggle_on_rounded,
                      title: 'Physical Toggles',
                      subtitle: 'Tester les interrupteurs',
                      onTap: () => Navigator.of(context).pushNamed(AppRoutes.physicalToggles),
                    ),
                  ),
                  SizedBox(
                    width: cardWidth,
                    child: HomeActionCard(
                      icon: Icons.palette_rounded,
                      title: 'Appearance',
                      subtitle: 'Personnaliser le style',
                      onTap: () => Navigator.of(context).pushNamed(AppRoutes.appearance),
                    ),
                  ),
                  SizedBox(
                    width: cardWidth,
                    child: HomeActionCard(
                      icon: Icons.layers_rounded,
                      title: 'Style Gallery',
                      subtitle: 'Tester les ${GlassStyle.values.length} presets',
                      onTap: () => Navigator.of(context).pushNamed(AppRoutes.styleGallery),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}