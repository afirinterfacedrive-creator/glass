import 'package:flutter/material.dart';
import 'package:universal_glass/glass.dart';

/// Wrapper responsive pour une liste de widgets Glass.
///
/// Comportement :
/// - Sur desktop avec une largeur >= 500 px :
///   défilement horizontal avec flèches.
/// - Sur desktop très étroit (< 500 px) :
///   passage automatique en [GlassResponsiveGrid].
/// - Sur mobile/tablette :
///   défilement horizontal avec flèches.
///
/// Le composant ne gère aucune logique Aqua/Classic.
/// Le rendu des enfants reste entièrement piloté par leur propre
/// architecture Glass.
class GlassScrollViewWithArrows extends StatefulWidget {
  /// Widgets à afficher, généralement des GlassModeChip.
  final List<Widget> children;

  /// Couleur des flèches de navigation.
  final Color arrowColor;

  /// Espacement horizontal entre les éléments en mode grille.
  final double spacing;

  /// Espacement vertical entre les lignes en mode grille.
  final double runSpacing;

  /// Distance parcourue lors d'un clic sur une flèche.
  final double scrollStep;

  /// Seuil à partir duquel le composant considère qu'il reste
  /// suffisamment de contenu à faire défiler.
  final double scrollThreshold;

  const GlassScrollViewWithArrows({
    super.key,
    required this.children,
    this.arrowColor = Colors.white70,
    this.spacing = 8.0,
    this.runSpacing = 8.0,
    this.scrollStep = 160.0,
    this.scrollThreshold = 4.0,
  });

  @override
  State<GlassScrollViewWithArrows> createState() =>
      _GlassScrollViewWithArrowsState();
}

class _GlassScrollViewWithArrowsState
    extends State<GlassScrollViewWithArrows> {
  final ScrollController _scrollController =
      ScrollController();

  bool _showLeftArrow = false;
  bool _showRightArrow = false;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(
      _updateArrows,
    );

    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _updateArrows(),
    );
  }

  @override
  void didUpdateWidget(
    covariant GlassScrollViewWithArrows oldWidget,
  ) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.children.length !=
        widget.children.length) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _updateArrows(),
      );
    }
  }

  void _updateArrows() {
    if (!mounted ||
        !_scrollController.hasClients) {
      return;
    }

    final ScrollPosition position =
        _scrollController.position;

    final double maxScroll =
        position.maxScrollExtent;

    final double currentScroll =
        position.pixels;

    final bool showLeft =
        maxScroll > widget.scrollThreshold &&
        currentScroll > widget.scrollThreshold;

    final bool showRight =
        maxScroll > widget.scrollThreshold &&
        currentScroll <
            maxScroll - widget.scrollThreshold;

    if (_showLeftArrow == showLeft &&
        _showRightArrow == showRight) {
      return;
    }

    setState(() {
      _showLeftArrow = showLeft;
      _showRightArrow = showRight;
    });
  }

  void _scrollToLeft() {
    _animateTo(
      _scrollController.offset -
          widget.scrollStep,
    );
  }

  void _scrollToRight() {
    _animateTo(
      _scrollController.offset +
          widget.scrollStep,
    );
  }

  void _animateTo(double target) {
    if (!_scrollController.hasClients) {
      return;
    }

    final ScrollPosition position =
        _scrollController.position;

    final double clampedTarget =
        target.clamp(
      0.0,
      position.maxScrollExtent,
    );

    if ((clampedTarget - position.pixels)
            .abs() <
        0.5) {
      return;
    }

    _scrollController.animateTo(
      clampedTarget,
      duration:
          const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(
      _updateArrows,
    );

    _scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme =
        Theme.of(context);

    final bool isDesktop =
        theme.platform ==
            TargetPlatform.windows ||
        theme.platform ==
            TargetPlatform.macOS ||
        theme.platform ==
            TargetPlatform.linux;

    return LayoutBuilder(
      builder: (
        BuildContext context,
        BoxConstraints constraints,
      ) {
        /*
         * ----------------------------------------------------------
         * DESKTOP ÉTROIT
         * ----------------------------------------------------------
         *
         * Sur une fenêtre desktop très étroite,
         * le défilement horizontal devient moins pratique.
         *
         * On bascule donc vers la grille responsive.
         */
        if (isDesktop &&
            constraints.maxWidth < 500.0) {
          return GlassResponsiveGrid(
            spacing: widget.spacing,
            runSpacing: widget.runSpacing,
            expandItems: false,
            mobileColumns: 1,
            children: widget.children,
          );
        }

        /*
         * ----------------------------------------------------------
         * DÉFILEMENT HORIZONTAL
         * ----------------------------------------------------------
         */
        return Row(
          children: [
            _ArrowButton(
              visible: _showLeftArrow,
              direction:
                  Icons.arrow_left_rounded,
              color: widget.arrowColor,
              onPressed: _scrollToLeft,
            ),

            Expanded(
              child: SingleChildScrollView(
                controller:
                    _scrollController,
                scrollDirection:
                    Axis.horizontal,
                physics:
                    const BouncingScrollPhysics(),
                child: Row(
                  mainAxisSize:
                      MainAxisSize.min,
                  children:
                      _withSpacing(
                    widget.children,
                  ),
                ),
              ),
            ),

            _ArrowButton(
              visible: _showRightArrow,
              direction:
                  Icons.arrow_right_rounded,
              color: widget.arrowColor,
              onPressed: _scrollToRight,
            ),
          ],
        );
      },
    );
  }

  List<Widget> _withSpacing(
    List<Widget> children,
  ) {
    if (children.length < 2) {
      return children;
    }

    final List<Widget> result =
        <Widget>[];

    for (int i = 0;
        i < children.length;
        i++) {
      if (i > 0) {
        result.add(
          SizedBox(
            width: widget.spacing,
          ),
        );
      }

      result.add(children[i]);
    }

    return result;
  }
}

/// Flèche de navigation animée.
class _ArrowButton extends StatelessWidget {
  final bool visible;
  final IconData direction;
  final Color color;
  final VoidCallback onPressed;

  const _ArrowButton({
    required this.visible,
    required this.direction,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration:
          const Duration(milliseconds: 200),
      curve: Curves.easeOutCubic,
      width: visible ? 32.0 : 0.0,
      child: AnimatedOpacity(
        duration:
            const Duration(milliseconds: 160),
        opacity: visible ? 1.0 : 0.0,
        child: visible
            ? IconButton(
                padding: EdgeInsets.zero,
                splashRadius: 20.0,
                icon: Icon(
                  direction,
                  color: color,
                  size: 28.0,
                ),
                onPressed: onPressed,
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}