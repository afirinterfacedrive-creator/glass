import 'package:flutter/material.dart';

import 'package:universal_glass/glass.dart';

class GlassGradientAnimationDemo extends StatelessWidget {
  const GlassGradientAnimationDemo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GlassScaffold(
      title: 'Démo Animation Glass',
      subtitle: 'GLASS GRADIENT ANIMATION',
      showLogo: true,
      showBackButton: true,
      hideNavigation: true,
      child: Builder(
        builder: (BuildContext context) {
          final GlassLayoutContext glass =
              GlassLayoutScope.of(context);

          return Center(
            child: SingleChildScrollView(
              padding: glass.dynamicPadding,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // =========================================================
                  // 1. TRANSPARENT AQUA
                  // =========================================================

                  GlassSurfaceContainer(
                    style: GlassStyle.transparentAqua,
                    effects: glass.effects,
                    padding: EdgeInsets.symmetric(
                      horizontal: glass.spacing(24.0),
                      vertical: glass.spacing(16.0),
                    ),
                    borderRadius: BorderRadius.circular(
                      glass.radius(16.0),
                    ),
                    child: Text(
                      'Hover me - Aqua Frost',
                      style: TextStyle(
                        fontSize: glass.fontSize(14.0),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  SizedBox(
                    height: glass.spacing(20.0),
                  ),

                  // =========================================================
                  // 2. TRANSPARENT RED
                  // =========================================================

                  GlassSurfaceContainer(
                    style: GlassStyle.transparentRed,
                    effects: glass.effects,
                    padding: EdgeInsets.symmetric(
                      horizontal: glass.spacing(24.0),
                      vertical: glass.spacing(16.0),
                    ),
                    borderRadius: BorderRadius.circular(
                      glass.radius(16.0),
                    ),
                    child: Text(
                      'Hover me - Red Glass',
                      style: TextStyle(
                        fontSize: glass.fontSize(14.0),
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  SizedBox(
                    height: glass.spacing(20.0),
                  ),

                  // =========================================================
                  // 3. TRANSPARENT GREEN
                  // =========================================================

                  GlassSurfaceContainer(
                    style: GlassStyle.transparentGreen,
                    effects: glass.effects,
                    padding: EdgeInsets.symmetric(
                      horizontal: glass.spacing(24.0),
                      vertical: glass.spacing(16.0),
                    ),
                    borderRadius: BorderRadius.circular(
                      glass.radius(16.0),
                    ),
                    child: Text(
                      'Hover me - Green Glass',
                      style: TextStyle(
                        fontSize: glass.fontSize(14.0),
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}