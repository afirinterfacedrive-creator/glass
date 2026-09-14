
import 'package:flutter/material.dart';

import 'package:universal_glass/glass.dart';

import '../../routes/app_router.dart';
import 'home_action_card.dart';

class HomeQuickAccess extends StatelessWidget {
  const HomeQuickAccess({super.key});

  @override
  Widget build(BuildContext context) {
    final GlassLayoutContext glass = GlassLayoutScope.of(context);

    final routes = AppRouter.quickAccessRoutes;

    return LayoutBuilder(
      builder: (context, constraints) {
        final double maxWidth = constraints.maxWidth;
        const double spacing = 16.0;

        // ====================================================================
        // RESPONSIVE GRID
        // ====================================================================

        int crossAxisCount = 1;

        if (maxWidth >= 1200) {
          crossAxisCount = 5;
        } else if (maxWidth >= 900) {
          crossAxisCount = 3;
        } else if (maxWidth >= 600) {
          crossAxisCount = 2;
        }

        final double cardWidth =
            (maxWidth - (spacing * (crossAxisCount - 1))) /
                crossAxisCount;

        // ====================================================================
        // CONTAINER
        // ====================================================================

        return GlassSurfaceContainer(
          style: glass.theme.glassStyle,
          effects: glass.effects,
          borderRadius: BorderRadius.circular(
            glass.isSmallMobile ? 14 : 20,
          ),
          padding: EdgeInsets.all(
            glass.isSmallMobile ? 14.0 : 20.0,
          ),
          liftOnHover: glass.theme.enableHover,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ================================================================
              // HEADER
              // ================================================================

              GlassSectionHeader(
                title: 'Quick Access',
                subtitle: '${routes.length} raccourcis disponibles',
                icon: Icons.rocket_launch_rounded,
              ),

              SizedBox(
                height: glass.isSmallMobile ? 16 : 24,
              ),

              // ================================================================
              // ACTION CARDS
              // ================================================================

              Wrap(
                spacing: spacing,
                runSpacing: 12,
                children: [
                  for (final route in routes)
                    SizedBox(
                      width: cardWidth,
                      child: HomeActionCard(
                        icon: route.icon,
                        title: route.title,
                        subtitle: route.subtitle,
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            route.route,
                          );
                        },
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
