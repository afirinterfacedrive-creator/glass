import 'package:flutter/material.dart';
import 'package:universal_glass/glass.dart';


// ============================================================================
// HOME WELCOME CARD
// ============================================================================
//
// RESPONSABILITÉ
// -----------------------------------------------------------------------------
// Carte d'accueil de la page Home.
//
// La surface Glass est entièrement gérée par GlassSurfaceContainer.
//
// Le responsive est fourni par GlassLayoutContext.
//
// GlassDisplaySettings contient les paramètres globaux d'affichage.
// GlassLayoutContext transforme ces paramètres en valeurs adaptées au contexte
// courant.
//
// Architecture :
//
// GlassScaffold
//      ↓
// GlassScaleScope
//      ↓
// GlassLayoutScope
//      ↓
// HomeWelcomeCard
//      ↓
// GlassSurfaceContainer
//      ↓
// contenu
//
// ============================================================================

class HomeWelcomeCard extends StatelessWidget {
  const HomeWelcomeCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final GlassLayoutContext glass =
        context.glassLayout;

    final GlassThemeState theme =
        glass.theme;

    final GlassDisplaySettings display =
        glass.display;

    final bool compact =
        glass.isSmallMobile ||
        glass.isMobile;

    final Color accent =
        glass.focusColor;

    // ------------------------------------------------------------------------
    // DIMENSIONS RESPONSIVE
    // ------------------------------------------------------------------------
    //
    // Les valeurs de base restent définies ici pour le composant.
    // Leur mise à l'échelle est ensuite gérée par GlassLayoutContext.
    //
    // ------------------------------------------------------------------------

    final double horizontalSpacing =
        glass.spacing(
      compact ? 16.0 : 30.0,
    );

    final double iconContainerSize =
        glass.size(
      compact ? 64.0 : 100.0,
    );

    final double iconSize =
        glass.size(
      compact ? 38.0 : 62.0,
    );

    // ------------------------------------------------------------------------
    // PADDING GLOBAL
    // ------------------------------------------------------------------------

    final double cardPadding =
        compact
            ? display.mobilePadding
            : display.desktopPadding;

    return GlassSurfaceContainer(
      // ----------------------------------------------------------------------
      // STYLE GLASS
      // ----------------------------------------------------------------------

      style: theme.glassStyle,

      // ----------------------------------------------------------------------
      // EFFETS GLASS
      // ----------------------------------------------------------------------

      effects: glass.effects,

      // ----------------------------------------------------------------------
      // RAYON
      // ----------------------------------------------------------------------

      borderRadius: BorderRadius.circular(
        glass.radius(26.0),
      ),

      // ----------------------------------------------------------------------
      // PADDING
      // ----------------------------------------------------------------------
       padding: EdgeInsets.all(cardPadding),
/*
      padding: EdgeInsets.all(
        glass.spacing(
          compact ? 20.0 : 28.0,
        ),
      ),*/

      // ----------------------------------------------------------------------
      // INTERACTION
      // ----------------------------------------------------------------------

      liftOnHover:
          theme.enableHover,

      // ----------------------------------------------------------------------
      // CONTENU
      // ----------------------------------------------------------------------

      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.center,
        children: [
          // ==================================================================
          // TEXTE
          // ==================================================================

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              mainAxisSize:
                  MainAxisSize.min,
              children: [
                Text(
                  'BIENVENUE',
                  style: TextStyle(
                    color: accent,
                    fontSize:
                        glass.fontSize(12.0),
                    fontWeight:
                        FontWeight.bold,
                    letterSpacing:
                        glass.fontSize(1.6),
                  ),
                ),

                SizedBox(
                  height:
                      glass.spacing(9.0),
                ),

                Text(
                  'Votre espace de contrôle Glass',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: glass.fontSize(
                      compact
                          ? 20.0
                          : 23.0,
                    ),
                    fontWeight:
                        FontWeight.bold,
                    height: 1.15,
                  ),
                ),

                SizedBox(
                  height:
                      glass.spacing(9.0),
                ),

                Text(
                  'Accédez rapidement à vos contrôles, '
                  'réglages et outils.',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize:
                        glass.fontSize(13.0),
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),

          // ==================================================================
          // ESPACEMENT TEXTE → ICÔNE
          // ==================================================================

          SizedBox(
            width:
                horizontalSpacing,
          ),

          // ==================================================================
          // ICÔNE
          // ==================================================================

          Container(
            width:
                iconContainerSize,
            height:
                iconContainerSize,

            decoration:
                BoxDecoration(
              shape:
                  BoxShape.circle,

              color:
                  accent.withValues(
                alpha: .045,
              ),
            ),

            child: Icon(
              Icons.dashboard_customize_outlined,
              size:
                  iconSize,
              color:
                  accent.withValues(
                alpha: .32,
              ),
            ),
          ),
        ],
      ),
    );
  }
}