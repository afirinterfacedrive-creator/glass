import 'package:flutter/material.dart';

import 'package:universal_glass/core/app_bar/universal_tab_item.dart';
import 'package:universal_glass/core/layout/glass_layout_context.dart';
import 'package:universal_glass/core/layout/glass_layout_extensions.dart';

/// ============================================================================
/// CONTENU DE L'APP BAR
/// ============================================================================
///
/// Responsable uniquement du contenu visuel :
///
/// - bouton retour
/// - logo
/// - titre
/// - sous-titre
/// - navigation
/// - actions
///
/// Le background, le blur et la décoration globale sont gérés par :
///
///     UniversalAppBar
///     UniversalAppBarDecorator
///     GlassSurfaceContainer
///
/// Le responsive est fourni exclusivement par GlassLayoutContext.
/// ============================================================================

class UniversalAppBarContent extends StatelessWidget {
  final String? title;
  final String? subtitle;

  final bool showLogo;

  final bool showBackButton;
  final VoidCallback? onBack;

  final List<Widget>? actions;

  final List<UniversalTabItem> tabs;
  final String currentRoute;

  final double appBarHeight;

  final ThemeData theme;

  final Color iconColor;
  final Color accentColor;
  final Color shadowColor;

  final BoxDecoration actionDecoration;

  const UniversalAppBarContent({
    super.key,
    this.title,
    this.subtitle,
    required this.showLogo,
    required this.showBackButton,
    this.onBack,
    this.actions,
    required this.tabs,
    required this.currentRoute,
    required this.appBarHeight,
    required this.theme,
    required this.iconColor,
    required this.accentColor,
    required this.shadowColor,
    required this.actionDecoration,
  });

  // ==========================================================================
  // BUILD
  // ==========================================================================

  @override
  Widget build(BuildContext context) {
    final GlassLayoutContext layout =
        context.glassLayout;

    // --------------------------------------------------------------------------
    // SOURCE DE VÉRITÉ RESPONSIVE
    // --------------------------------------------------------------------------
    //
    // Toutes les dimensions et tous les breakpoints viennent de
    // GlassLayoutContext.
    //
    // --------------------------------------------------------------------------

    final bool showNavigation =
        layout.isWideScreen &&
        tabs.isNotEmpty;

    return SizedBox(
      height: appBarHeight,
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: _horizontalPadding(layout),
        ),
        child: Row(
          crossAxisAlignment:
              CrossAxisAlignment.center,
          children: [
            // ==================================================================
            // RETOUR
            // ==================================================================

            if (showBackButton)
              _buildBackButton(
                context,
                layout,
              ),

            // ==================================================================
            // LOGO
            // ==================================================================

            if (showLogo)
              _buildLogo(layout),

            // ==================================================================
            // TITRE
            // ==================================================================

            if (title != null)
              Expanded(
                child: _buildTitle(layout),
              )
            else
              const Spacer(),

            // ==================================================================
            // NAVIGATION
            // ==================================================================

            if (showNavigation)
              Flexible(
                fit: FlexFit.loose,
                child: _buildNavigation(
                  context,
                  layout,
                ),
              ),

            // ==================================================================
            // ACTIONS
            // ==================================================================

            if (actions != null &&
                actions!.isNotEmpty)
              _buildActions(layout),
          ],
        ),
      ),
    );
  }

  // ==========================================================================
  // PADDING HORIZONTAL
  // ==========================================================================

  double _horizontalPadding(
    GlassLayoutContext layout,
  ) {
    if (layout.isLargeDesktop) {
      return layout.spacing(28.0);
    }

    if (layout.isDesktop) {
      return layout.spacing(20.0);
    }

    if (layout.isTablet) {
      return layout.spacing(14.0);
    }

    if (layout.isSmallMobile) {
      return layout.spacing(8.0);
    }

    return layout.spacing(10.0);
  }

  // ==========================================================================
  // BOUTON RETOUR
  // ==========================================================================

  Widget _buildBackButton(
    BuildContext context,
    GlassLayoutContext layout,
  ) {
    final double iconSize =
        layout.size(20.0).clamp(
          16.0,
          24.0,
        );

    final double spacing =
        layout.spacing(10.0).clamp(
          6.0,
          14.0,
        );

    return Padding(
      padding: EdgeInsets.only(
        right: spacing,
      ),
      child: _GlassIconButton(
        decoration: actionDecoration,
        icon: Icons.arrow_back,
        color: iconColor,
        size: iconSize,
        onTap:
            onBack ??
            () {
              Navigator.of(context).maybePop();
            },
      ),
    );
  }

  // ==========================================================================
  // LOGO
  // ==========================================================================

  Widget _buildLogo(
    GlassLayoutContext layout,
  ) {
    final double size =
        (appBarHeight * 0.62).clamp(
      34.0,
      76.0,
    );

    final double rightPadding =
        layout.spacing(14.0);

    return Padding(
      padding: EdgeInsets.only(
        right: rightPadding,
      ),
      child: SizedBox(
        width: size,
        height: size,
        child: DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,

            // ------------------------------------------------------------------
            // GLASS
            // ------------------------------------------------------------------

            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withValues(
                  alpha: .20,
                ),
                accentColor.withValues(
                  alpha: .14,
                ),
                Colors.black.withValues(
                  alpha: .10,
                ),
              ],
            ),

            // ------------------------------------------------------------------
            // BORDURE
            // ------------------------------------------------------------------

            border: Border.all(
              color: Colors.white.withValues(
                alpha: .30,
              ),
              width: 1.0,
            ),

            // ------------------------------------------------------------------
            // OMBRES
            // ------------------------------------------------------------------

            boxShadow: [
              BoxShadow(
                color: accentColor.withValues(
                  alpha: .16,
                ),
                blurRadius: 16,
                spreadRadius: .3,
              ),
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: .14,
                ),
                blurRadius: 7,
                offset: const Offset(
                  0,
                  2,
                ),
              ),
            ],
          ),
          child: Center(
            child: Icon(
              Icons.blur_on,
              size: size * .48,
              color: accentColor,
              shadows: [
                Shadow(
                  color: accentColor.withValues(
                    alpha: .30,
                  ),
                  blurRadius: 7,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================================================
  // TITRE
  // ==========================================================================

  Widget _buildTitle(
    GlassLayoutContext layout,
  ) {
    final double titleSize =
        layout.fontSize(18.0).clamp(
      16.0,
      27.0,
    );

    final double subtitleSize =
        layout.fontSize(11.0).clamp(
      10.0,
      16.0,
    );

    final double subtitleGap =
        layout.spacing(4.0);

    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: layout.spacing(2.0),
        ),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          crossAxisAlignment:
              CrossAxisAlignment.start,
          mainAxisSize:
              MainAxisSize.min,
          children: [
            // ==================================================================
            // TITRE PRINCIPAL
            // ==================================================================

            Text(
              title!,
              maxLines: 1,
              overflow:
                  TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white,
                fontSize: titleSize,
                fontWeight:
                    FontWeight.w700,
                height: 1.0,
                letterSpacing: .10,
                shadows: [
                  Shadow(
                    color:
                        Colors.black.withValues(
                      alpha: .28,
                    ),
                    blurRadius: 3,
                    offset:
                        const Offset(
                      0,
                      1,
                    ),
                  ),
                  Shadow(
                    color:
                        shadowColor.withValues(
                      alpha: .16,
                    ),
                    blurRadius: 6,
                  ),
                ],
              ),
            ),

            // ==================================================================
            // SOUS-TITRE
            // ==================================================================

            if (subtitle != null) ...[
              SizedBox(
                height: subtitleGap,
              ),
              Text(
                subtitle!,
                maxLines: 1,
                overflow:
                    TextOverflow.ellipsis,
                style: TextStyle(
                  color:
                      Colors.white.withValues(
                    alpha: .76,
                  ),
                  fontSize:
                      subtitleSize,
                  fontWeight:
                      FontWeight.w500,
                  letterSpacing: .55,
                  height: 1.0,
                  shadows: [
                    Shadow(
                      color:
                          Colors.black.withValues(
                        alpha: .30,
                      ),
                      blurRadius: 2,
                      offset:
                          const Offset(
                        0,
                        1,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ==========================================================================
  // NAVIGATION
  // ==========================================================================

  Widget _buildNavigation(
    BuildContext context,
    GlassLayoutContext layout,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: layout.spacing(8.0),
      ),
      child: Row(
        mainAxisSize:
            MainAxisSize.min,
        children: [
          for (final UniversalTabItem tab
              in tabs)
            _buildTab(
              context,
              layout,
              tab,
            ),
        ],
      ),
    );
  }

  // ==========================================================================
  // TAB
  // ==========================================================================

  Widget _buildTab(
    BuildContext context,
    GlassLayoutContext layout,
    UniversalTabItem tab,
  ) {
    final bool selected =
        currentRoute == tab.route;

    final Color textColor =
        selected
            ? Colors.white
            : Colors.white.withValues(
                alpha: .82,
              );

    final Color tabIconColor =
        selected
            ? accentColor
            : Colors.white.withValues(
                alpha: .78,
              );

    final double tabRadius =
        layout.radius(14.0);

    final double horizontalPadding =
        layout.spacing(12.0);

    final double verticalPadding =
        layout.spacing(7.0);

    final double iconSize =
        layout.size(16.0);

    final double iconLabelGap =
        layout.spacing(6.0);

    final double fontSize =
        layout.fontSize(12.0).clamp(
      11.0,
      17.0,
    );

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: layout.spacing(4.0),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius:
              BorderRadius.circular(
            tabRadius,
          ),
          onTap: () {
            if (selected) {
              return;
            }

            Navigator.of(context)
                .pushReplacementNamed(
              tab.route,
            );
          },
          child: AnimatedContainer(
            duration:
                const Duration(
              milliseconds: 180,
            ),
            curve: Curves.easeOut,
            padding: EdgeInsets.symmetric(
              horizontal:
                  horizontalPadding,
              vertical:
                  verticalPadding,
            ),
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(
                tabRadius,
              ),
              color: selected
                  ? accentColor.withValues(
                      alpha: .14,
                    )
                  : Colors.black.withValues(
                      alpha: .06,
                    ),
              border: Border.all(
                color: selected
                    ? accentColor.withValues(
                        alpha: .34,
                      )
                    : Colors.white.withValues(
                        alpha: .12,
                      ),
                width:
                    selected ? 1.0 : .7,
              ),
              boxShadow: [
                if (selected)
                  BoxShadow(
                    color:
                        accentColor.withValues(
                      alpha: .12,
                    ),
                    blurRadius: 10,
                    spreadRadius: .1,
                  ),
                if (!selected)
                  BoxShadow(
                    color:
                        Colors.black.withValues(
                      alpha: .08,
                    ),
                    blurRadius: 4,
                    offset:
                        const Offset(
                      0,
                      2,
                    ),
                  ),
              ],
            ),
            child: Row(
              mainAxisSize:
                  MainAxisSize.min,
              children: [
                if (tab.icon != null) ...[
                  Icon(
                    tab.icon,
                    size: iconSize,
                    color: tabIconColor,
                    shadows: [
                      Shadow(
                        color:
                            Colors.black.withValues(
                          alpha: .25,
                        ),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                  SizedBox(
                    width: iconLabelGap,
                  ),
                ],

                Flexible(
                  child: Text(
                    tab.label,
                    maxLines: 1,
                    overflow:
                        TextOverflow.ellipsis,
                    style: TextStyle(
                      color: textColor,
                      fontSize: fontSize,
                      fontWeight: selected
                          ? FontWeight.w700
                          : FontWeight.w500,
                      letterSpacing: .10,
                      shadows: [
                        Shadow(
                          color:
                              Colors.black.withValues(
                            alpha: .28,
                          ),
                          blurRadius: 2,
                          offset:
                              const Offset(
                            0,
                            1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================================================
  // ACTIONS
  // ==========================================================================

  Widget _buildActions(
    GlassLayoutContext layout,
  ) {
    return Row(
      mainAxisSize:
          MainAxisSize.min,
      children: [
        for (final Widget action
            in actions!)
          Padding(
            padding: EdgeInsets.only(
              left: layout.spacing(8.0),
            ),
            child: action,
          ),
      ],
    );
  }
}

// ============================================================================
// BOUTON GLASS INTERNE
// ============================================================================
//
// CORRECTION IMPORTANTE
// ----------------------------------------------------------------------------
//
// La zone interactive reste toujours 44 x 44.
//
// Le zoom ne doit pas réduire la zone de hit-test du bouton retour.
//
// Le rendu visuel interne peut cependant continuer à utiliser la taille
// calculée par GlassLayoutContext.
// ============================================================================

class _GlassIconButton extends StatelessWidget {
  final BoxDecoration decoration;

  final IconData icon;
  final Color color;
  final double size;

  final VoidCallback onTap;

  const _GlassIconButton({
    required this.decoration,
    required this.icon,
    required this.color,
    required this.size,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const double hitDimension = 44.0;

    final double visualDimension =
        (size + 20.0).clamp(
      32.0,
      48.0,
    );

    return SizedBox(
      width: hitDimension,
      height: hitDimension,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          customBorder:
              const CircleBorder(),
          child: Center(
            child: Container(
              width: visualDimension,
              height: visualDimension,
              decoration:
                  decoration.copyWith(
                shape: BoxShape.circle,
              ),
              alignment:
                  Alignment.center,
              child: Icon(
                icon,
                size: size,
                color: color,
                shadows: [
                  Shadow(
                    color:
                        Colors.black.withValues(
                      alpha: .28,
                    ),
                    blurRadius: 3,
                    offset:
                        const Offset(
                      0,
                      1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}