import 'package:flutter/material.dart';
import 'package:universal_glass/core/app_bar/universal_tab_item.dart';

// ============================================================================
// CONTENU DE L'APP BAR
// ============================================================================
//
// Responsable uniquement du contenu.
//
// - bouton retour
// - logo
// - titre
// - sous-titre
// - navigation
// - actions
//
// Le blur, le background et la décoration sont gérés par
// UniversalAppBarDecorator.
//
// ============================================================================

class UniversalAppBarContent extends StatelessWidget {
  final String? title;
  final String? subtitle;

  final bool showLogo;

  final bool showBackButton;
  final VoidCallback? onBack;

  final List<Widget>? actions;

  final List<UniversalTabItem> tabs;
  final String currentRoute;

  final bool isTv;
  final bool isDesktop;
  final bool isTablet;

  final double scale;
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
    required this.isTv,
    required this.isDesktop,
    required this.isTablet,
    required this.scale,
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
    return Container(
      height: appBarHeight,

      padding: EdgeInsets.symmetric(
        horizontal: _horizontalPadding(),
      ),

      child: Row(
        children: [
          // ==================================================================
          // RETOUR
          // ==================================================================

          if (showBackButton) _buildBackButton(context),

          // ==================================================================
          // LOGO
          // ==================================================================

          if (showLogo) _buildLogo(),

          // ==================================================================
          // TITRE
          // ==================================================================

          if (title != null)
            Expanded(
              child: _buildTitle(),
            )
          else
            const Spacer(),

          // ==================================================================
          // NAVIGATION
          // ==================================================================

          if (isDesktop && tabs.isNotEmpty)
            _buildNavigation(context),

          // ==================================================================
          // ACTIONS
          // ==================================================================

          if (actions != null && actions!.isNotEmpty)
            _buildActions(),
        ],
      ),
    );
  }

  // ==========================================================================
  // PADDING HORIZONTAL
  // ==========================================================================

  double _horizontalPadding() {
    if (isTv) {
      return 40;
    }

    if (isDesktop) {
      return 28;
    }

    if (isTablet) {
      return 20;
    }

    return 14;
  }

  // ==========================================================================
  // BOUTON RETOUR
  // ==========================================================================

  Widget _buildBackButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        right: 10 * scale,
      ),

      child: _GlassIconButton(
        decoration: actionDecoration,
        icon: Icons.arrow_back,
        color: iconColor,

        // --------------------------------------------------------------------
        // Taille maîtrisée.
        // --------------------------------------------------------------------

        size: 20 * scale,

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

  Widget _buildLogo() {
    final double size = (appBarHeight * .62).clamp(
      38.0,
      76.0,
    );

    return Padding(
      padding: EdgeInsets.only(
        right: 14 * scale,
      ),

      child: Container(
        width: size,
        height: size,

        decoration: BoxDecoration(
          shape: BoxShape.circle,

          // ------------------------------------------------------------------
          // GLASS
          // ------------------------------------------------------------------

          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,

            colors: [
              Colors.white.withValues(alpha: .20),
              accentColor.withValues(alpha: .14),
              Colors.black.withValues(alpha: .10),
            ],
          ),

          // ------------------------------------------------------------------
          // BORDURE
          // ------------------------------------------------------------------

          border: Border.all(
            color: Colors.white.withValues(alpha: .30),
            width: 1,
          ),

          // ------------------------------------------------------------------
          // OMBRES DOUCES
          // ------------------------------------------------------------------

          boxShadow: [
            BoxShadow(
              color: accentColor.withValues(alpha: .16),
              blurRadius: 16,
              spreadRadius: .3,
            ),

            BoxShadow(
              color: Colors.black.withValues(alpha: .14),
              blurRadius: 7,
              offset: const Offset(0, 2),
            ),
          ],
        ),

        child: Icon(
          Icons.blur_on,

          size: size * .48,

          color: accentColor,

          shadows: [
            Shadow(
              color: accentColor.withValues(alpha: .30),
              blurRadius: 7,
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================================
  // TITRE
  // ==========================================================================

  Widget _buildTitle() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        // ====================================================================
        // TITRE PRINCIPAL
        // ====================================================================

        Text(
          title!,

          maxLines: 1,

          overflow: TextOverflow.ellipsis,

          style: TextStyle(
            color: Colors.white,

            // ----------------------------------------------------------------
            // IMPORTANT :
            //
            // On conserve le responsive mais on évite que la typographie
            // devienne excessivement grosse sur les grandes fenêtres.
            // ----------------------------------------------------------------

            fontSize: (18 * scale).clamp(
              16.0,
              27.0,
            ),

            // ----------------------------------------------------------------
            // Plus élégant que w900 sur Windows.
            // ----------------------------------------------------------------

            fontWeight: FontWeight.w700,

            height: 1.0,

            letterSpacing: .10,

            // ----------------------------------------------------------------
            // Ombre douce.
            //
            // L'ancien système utilisait deux ombres assez fortes.
            // Cela pouvait donner un rendu plus lourd sur Windows.
            // ----------------------------------------------------------------

            shadows: [
              Shadow(
                color: Colors.black.withValues(alpha: .28),
                blurRadius: 3,
                offset: const Offset(0, 1),
              ),

              Shadow(
                color: shadowColor.withValues(alpha: .16),
                blurRadius: 6,
              ),
            ],
          ),
        ),

        // ====================================================================
        // SOUS-TITRE
        // ====================================================================

        if (subtitle != null) ...[
          SizedBox(
            height: 4 * scale,
          ),

          Text(
            subtitle!,

            maxLines: 1,

            overflow: TextOverflow.ellipsis,

            style: TextStyle(
              color: Colors.white.withValues(alpha: .76),

              fontSize: (11 * scale).clamp(
                10.0,
                16.0,
              ),

              fontWeight: FontWeight.w500,

              letterSpacing: .55,

              height: 1.0,

              shadows: [
                Shadow(
                  color: Colors.black.withValues(alpha: .30),
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  // ==========================================================================
  // NAVIGATION
  // ==========================================================================

  Widget _buildNavigation(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 12 * scale,
      ),

      child: Row(
        mainAxisSize: MainAxisSize.min,

        children: [
          for (final tab in tabs)
            _buildTab(
              context,
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
    UniversalTabItem tab,
  ) {
    final bool selected = currentRoute == tab.route;

    final Color textColor = selected
        ? Colors.white
        : Colors.white.withValues(alpha: .82);

    final Color tabIconColor = selected
        ? accentColor
        : Colors.white.withValues(alpha: .78);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 4 * scale,
      ),

      child: Material(
        color: Colors.transparent,

        child: InkWell(
          borderRadius: BorderRadius.circular(14),

          onTap: () {
            if (selected) {
              return;
            }

            Navigator.of(context).pushReplacementNamed(
              tab.route,
            );
          },

          child: AnimatedContainer(
            duration: const Duration(
              milliseconds: 180,
            ),

            curve: Curves.easeOut,

            padding: EdgeInsets.symmetric(
              horizontal: 12 * scale,
              vertical: 8 * scale,
            ),

            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),

              // --------------------------------------------------------------
              // FOND
              // --------------------------------------------------------------

              color: selected
                  ? accentColor.withValues(alpha: .14)
                  : Colors.black.withValues(alpha: .06),

              // --------------------------------------------------------------
              // BORDURE
              // --------------------------------------------------------------

              border: Border.all(
                color: selected
                    ? accentColor.withValues(alpha: .34)
                    : Colors.white.withValues(alpha: .12),

                width: selected ? 1.0 : .7,
              ),

              // --------------------------------------------------------------
              // OMBRE
              // --------------------------------------------------------------

              boxShadow: [
                if (selected)
                  BoxShadow(
                    color: accentColor.withValues(alpha: .12),
                    blurRadius: 10,
                    spreadRadius: .1,
                  ),

                if (!selected)
                  BoxShadow(
                    color: Colors.black.withValues(alpha: .08),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
              ],
            ),

            child: Row(
              mainAxisSize: MainAxisSize.min,

              children: [
                // ============================================================
                // ICÔNE
                // ============================================================

                if (tab.icon != null) ...[
                  Icon(
                    tab.icon,

                    size: 16 * scale,

                    color: tabIconColor,

                    shadows: [
                      Shadow(
                        color: Colors.black.withValues(alpha: .25),
                        blurRadius: 2,
                      ),
                    ],
                  ),

                  const SizedBox(width: 6),
                ],

                // ============================================================
                // LABEL
                // ============================================================

                Text(
                  tab.label,

                  style: TextStyle(
                    color: textColor,

                    fontSize: (12 * scale).clamp(
                      11.0,
                      17.0,
                    ),

                    fontWeight: selected
                        ? FontWeight.w700
                        : FontWeight.w500,

                    letterSpacing: .10,

                    shadows: [
                      Shadow(
                        color: Colors.black.withValues(alpha: .28),
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                    ],
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

  Widget _buildActions() {
    return Row(
      mainAxisSize: MainAxisSize.min,

      children: [
        for (final action in actions!)
          Padding(
            padding: EdgeInsets.only(
              left: 8 * scale,
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
    final double dimension = size + 20;

    return Material(
      color: Colors.transparent,

      child: InkWell(
        onTap: onTap,

        borderRadius: BorderRadius.circular(100),

        child: Container(
          width: dimension,
          height: dimension,

          decoration: decoration,

          child: Icon(
            icon,

            size: size,

            color: color,

            shadows: [
              Shadow(
                color: Colors.black.withValues(alpha: .28),
                blurRadius: 3,
                offset: const Offset(0, 1),
              ),
            ],
          ),
        ),
      ),
    );
  }
}