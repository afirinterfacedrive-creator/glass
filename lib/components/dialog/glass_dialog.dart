
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:universal_glass/components/dialog/glass_dialog_action.dart';

import 'package:universal_glass/components/surface/glass_surface_container.dart';
import 'package:universal_glass/core/layout/glass_layout_context.dart';
import 'package:universal_glass/core/layout/glass_layout_scope.dart';
import 'package:universal_glass/enums/glass_enums.dart';
import 'package:universal_glass/provider/glass_theme_provider.dart';
import 'package:universal_glass/provider/glass_theme_state.dart';
import 'package:universal_glass/theme/glass_color_palette.dart';
import 'package:universal_glass/theme/glass_effects.dart';

import 'glass_dialog_controller.dart';

/// ============================================================================
/// GLASS DIALOG
/// ============================================================================
///
/// Dialog Universal Glass.
///
/// Particularité importante :
///
/// showDialog() crée une nouvelle route dans l'Overlay Flutter.
/// Cette route n'est donc pas automatiquement descendante du
/// GlassLayoutScope de la page.
///
/// GlassDialog.capture donc le GlassLayoutContext avant showDialog(), puis
/// réinjecte ce contexte dans un nouveau GlassLayoutScope.
///
/// Cela permet à GlassDialog, GlassSurfaceContainer et aux autres widgets
/// descendants d'utiliser normalement :
///
/// GlassLayoutScope.of(context)
///
/// ============================================================================

class GlassDialog extends ConsumerStatefulWidget {
  // ==========================================================================
  // HEADER
  // ==========================================================================

  final String? title;
  final String? subtitle;
  final IconData? icon;

  // ==========================================================================
  // CONTENT
  // ==========================================================================

  final Widget content;

  // ==========================================================================
  // ACTIONS
  // ==========================================================================

  final List<GlassDialogAction>? actions;

  // ==========================================================================
  // GLASS
  // ==========================================================================

  final GlassStyle style;
  final GlassEffects? effects;
  final Color? backgroundColor;

  // ==========================================================================
  // DIMENSIONS
  // ==========================================================================

  final double? width;
  final double maxWidth;

  final EdgeInsetsGeometry padding;

  // ==========================================================================
  // BEHAVIOR
  // ==========================================================================

  final bool barrierDismissible;

  final VoidCallback? onClose;

  // ==========================================================================
  // LAYOUT
  // ==========================================================================

  /// Layout calculé avant l'ouverture du dialog.
  ///
  /// Il permet de conserver le même contexte responsive dans la nouvelle
  /// route créée par showDialog().
  final GlassLayoutContext? layout;

  // ==========================================================================
  // CONSTRUCTOR
  // ==========================================================================

  const GlassDialog({
    super.key,

    this.title,
    this.subtitle,
    this.icon,

    required this.content,

    this.actions,

    this.style = GlassStyle.transparentAqua,
    this.effects,
    this.backgroundColor,

    this.width,
    this.maxWidth = 520,

    this.padding = const EdgeInsets.all(24),

    this.barrierDismissible = true,

    this.onClose,

    this.layout,
  });

  // ==========================================================================
  // SHOW
  // ==========================================================================

  static Future<T?> show<T>({
    required BuildContext context,

    String? title,
    String? subtitle,
    IconData? icon,

    required Widget content,

    List<GlassDialogAction>? actions,

    GlassStyle style = GlassStyle.transparentAqua,
    GlassEffects? effects,

    Color? backgroundColor,

    double? width,
    double maxWidth = 520,

    EdgeInsetsGeometry padding =
        const EdgeInsets.all(24),

    bool barrierDismissible = true,

    VoidCallback? onClose,
  }) {
    // ------------------------------------------------------------------------
    // IMPORTANT
    // ------------------------------------------------------------------------
    //
    // Ce contexte appartient encore à la page.
    //
    // Il faut donc récupérer le layout AVANT showDialog().
    //
    // ------------------------------------------------------------------------

    final GlassLayoutContext? layout =
        GlassLayoutScope.maybeOf(context);

    return showDialog<T>(
      context: context,

      barrierDismissible:
          barrierDismissible,

      barrierColor:
          Colors.black.withValues(
        alpha: 0.55,
      ),

      builder: (_) {
        // --------------------------------------------------------------------
        // DIALOG
        // --------------------------------------------------------------------

        final GlassDialog dialog =
            GlassDialog(
          title: title,
          subtitle: subtitle,
          icon: icon,

          content: content,

          actions: actions,

          style: style,
          effects: effects,
          backgroundColor:
              backgroundColor,

          width: width,
          maxWidth: maxWidth,

          padding: padding,

          barrierDismissible:
              barrierDismissible,

          onClose: onClose,

          layout: layout,
        );

        // --------------------------------------------------------------------
        // LAYOUT REINJECTION
        // --------------------------------------------------------------------
        //
        // Si le contexte appelant possède déjà un GlassLayoutScope,
        // on réutilise exactement son layout.
        //
        // --------------------------------------------------------------------

        if (layout != null) {
          return GlassLayoutScope(
            layoutOverride: layout,
            child: dialog,
          );
        }

        // --------------------------------------------------------------------
        // FALLBACK
        // --------------------------------------------------------------------
        //
        // Si GlassDialog.show() est appelé depuis un contexte qui n'est pas
        // lui-même sous GlassLayoutScope, on crée quand même un scope dans
        // la route du dialog.
        //
        // Cela évite que les widgets descendants déclenchent immédiatement
        // GlassLayoutScope.of() en dehors d'un scope.
        //
        // --------------------------------------------------------------------

        return GlassLayoutScope(
          child: dialog,
        );
      },
    );
  }

  // ==========================================================================
  // STATE
  // ==========================================================================

  @override
  ConsumerState<GlassDialog> createState() =>
      _GlassDialogState();
}

// ============================================================================
// STATE
// ============================================================================

class _GlassDialogState
    extends ConsumerState<GlassDialog>
    with SingleTickerProviderStateMixin {
  // ==========================================================================
  // CONTROLLER
  // ==========================================================================

  late final GlassDialogController _controller;

  // ==========================================================================
  // ANIMATION
  // ==========================================================================

  late final AnimationController
      _animationController;

  late final Animation<double>
      _fadeAnimation;

  late final Animation<double>
      _scaleAnimation;

  // ==========================================================================
  // INIT
  // ==========================================================================

  @override
  void initState() {
    super.initState();

    _controller =
        GlassDialogController();

    // ------------------------------------------------------------------------
    // ANIMATION CONTROLLER
    // ------------------------------------------------------------------------

    _animationController =
        AnimationController(
      vsync: this,

      duration:
          const Duration(
        milliseconds: 220,
      ),

      reverseDuration:
          const Duration(
        milliseconds: 180,
      ),
    );

    // ------------------------------------------------------------------------
    // FADE
    // ------------------------------------------------------------------------

    _fadeAnimation =
        CurvedAnimation(
      parent: _animationController,

      curve:
          Curves.easeOutCubic,

      reverseCurve:
          Curves.easeInCubic,
    );

    // ------------------------------------------------------------------------
    // SCALE
    // ------------------------------------------------------------------------

    _scaleAnimation =
        Tween<double>(
      begin: 0.96,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent:
            _animationController,

        curve:
            Curves.easeOutBack,

        reverseCurve:
            Curves.easeInCubic,
      ),
    );

    // ------------------------------------------------------------------------
    // START
    // ------------------------------------------------------------------------

    WidgetsBinding.instance
        .addPostFrameCallback(
      (_) {
        if (!mounted) {
          return;
        }

        _animationController.forward();
      },
    );
  }

  // ==========================================================================
  // DISPOSE
  // ==========================================================================

  @override
  void dispose() {
    // ------------------------------------------------------------------------
    // IMPORTANT
    // ------------------------------------------------------------------------
    //
    // GlassDialogController ne possède pas de dispose().
    //
    // On ne fait donc PAS :
    //
    // _controller.dispose();
    //
    // ------------------------------------------------------------------------

    _animationController.dispose();

    super.dispose();
  }

  // ==========================================================================
  // CLOSE
  // ==========================================================================

  Future<void> _close() async {
    if (_controller.isClosed) {
      return;
    }

    // ------------------------------------------------------------------------
    // CONTROLLER
    // ------------------------------------------------------------------------

    _controller.close();

    // ------------------------------------------------------------------------
    // ANIMATION
    // ------------------------------------------------------------------------

    await _animationController.reverse();

    if (!mounted) {
      return;
    }

    // ------------------------------------------------------------------------
    // NAVIGATION
    // ------------------------------------------------------------------------

    Navigator.of(context).pop();
  }

  // ==========================================================================
  // BUILD
  // ==========================================================================

  @override
  Widget build(
    BuildContext context,
  ) {
    // ------------------------------------------------------------------------
    // LAYOUT
    // ------------------------------------------------------------------------
    //
    // Normalement widget.layout est renseigné par GlassDialog.show().
    //
    // Dans tous les cas, le contexte actuel est maintenant sous un
    // GlassLayoutScope grâce au wrapper placé dans show().
    //
    // ------------------------------------------------------------------------

    final GlassLayoutContext glass =
        widget.layout ??
        GlassLayoutScope.of(context);

    // ------------------------------------------------------------------------
    // EFFECTS
    // ------------------------------------------------------------------------

    final GlassEffects effects =
        widget.effects ??
        glass.effects;

    // ------------------------------------------------------------------------
    // SCREEN
    // ------------------------------------------------------------------------

    final Size screenSize =
        MediaQuery.sizeOf(context);

    // =========================================================================
    // MATERIAL
    // =========================================================================

    return Material(
      type: MaterialType.transparency,

      child: SafeArea(
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,

            child: ScaleTransition(
              scale: _scaleAnimation,

              child: ConstrainedBox(
                constraints:
                    BoxConstraints(
                  maxWidth:
                      widget.maxWidth,

                  maxHeight:
                      screenSize.height *
                          0.90,
                ),

                child: SizedBox(
                  width: widget.width,

                  child:
                      GlassSurfaceContainer(
                    role:
                        GlassSurfaceRole.dialog,

                    style:
                        widget.style,

                    effects:
                        effects,

                    backgroundColor:
                        widget.backgroundColor,

                    child: Padding(
                      padding:
                          widget.padding,

                      child:
                          _buildDialogContent(
                        glass,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================================================
  // DIALOG CONTENT
  // ==========================================================================

  Widget _buildDialogContent(
    GlassLayoutContext glass,
  ) {
    final bool hasHeader =
        widget.title != null ||
        widget.subtitle != null ||
        widget.icon != null;

    final bool hasActions =
        widget.actions != null &&
        widget.actions!.isNotEmpty;

    return Column(
      mainAxisSize:
          MainAxisSize.min,

      crossAxisAlignment:
          CrossAxisAlignment.stretch,

      children: [
        // ----------------------------------------------------------------------
        // HEADER
        // ----------------------------------------------------------------------

        if (hasHeader) ...[
          _buildHeader(glass),

          SizedBox(
            height:
                glass.spacing(18),
          ),
        ],

        // ----------------------------------------------------------------------
        // CONTENT
        // ----------------------------------------------------------------------
        //
        // Le contenu est borné pour éviter les problèmes de contraintes
        // verticales liés à Flexible dans un Column shrink-wrapped.
        //
        // ----------------------------------------------------------------------

        ConstrainedBox(
          constraints:
              BoxConstraints(
            maxHeight:
                MediaQuery.sizeOf(
                      context,
                    ).height *
                    0.62,
          ),

          child:
              SingleChildScrollView(
            child:
                widget.content,
          ),
        ),

        // ----------------------------------------------------------------------
        // ACTIONS
        // ----------------------------------------------------------------------

        if (hasActions) ...[
          SizedBox(
            height:
                glass.spacing(20),
          ),

          _buildActions(glass),
        ],
      ],
    );
  }

  // ==========================================================================
  // HEADER
  // ==========================================================================

  Widget _buildHeader(
    GlassLayoutContext glass,
  ) {
    final GlassThemeState theme =
        ref.watch(
      glassThemeProvider,
    );

    final GlassColorPalette palette =
        glass.palette;

    final Color primary =
        palette.primaryForStyle(
      theme.useAquaStyle,
    );

    final Color textPrimary =
        palette.textPrimary;

    final Color textSecondary =
        palette.textSecondary;

    // ------------------------------------------------------------------------
    // SANS ICONE
    // ------------------------------------------------------------------------

    if (widget.icon == null) {
      return Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          if (widget.title != null)
            Text(
              widget.title!,

              style: TextStyle(
                color: textPrimary,

                fontSize:
                    glass.fontSize(20),

                fontWeight:
                    FontWeight.w700,

                height: 1.15,
              ),
            ),

          if (widget.subtitle != null) ...[
            SizedBox(
              height:
                  glass.spacing(6),
            ),

            Text(
              widget.subtitle!,

              style: TextStyle(
                color: textSecondary,

                fontSize:
                    glass.fontSize(13),

                height: 1.35,
              ),
            ),
          ],
        ],
      );
    }

    // ------------------------------------------------------------------------
    // AVEC ICONE
    // ------------------------------------------------------------------------

    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [
        // --------------------------------------------------------------------
        // ICON CONTAINER
        // --------------------------------------------------------------------

        Container(
          width:
              glass.size(42),

          height:
              glass.size(42),

          decoration:
              BoxDecoration(
            borderRadius:
                BorderRadius.circular(
              glass.radius(12),
            ),

            color:
                primary.withValues(
              alpha: 0.14,
            ),
          ),

          child: Icon(
            widget.icon,

            color: primary,

            size:
                glass.size(22),
          ),
        ),

        // --------------------------------------------------------------------
        // SPACING
        // --------------------------------------------------------------------

        SizedBox(
          width:
              glass.spacing(14),
        ),

        // --------------------------------------------------------------------
        // TEXT
        // --------------------------------------------------------------------

        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [
              if (widget.title != null)
                Text(
                  widget.title!,

                  style: TextStyle(
                    color:
                        textPrimary,

                    fontSize:
                        glass.fontSize(
                      20,
                    ),

                    fontWeight:
                        FontWeight.w700,

                    height: 1.15,
                  ),
                ),

              if (widget.subtitle != null) ...[
                SizedBox(
                  height:
                      glass.spacing(6),
                ),

                Text(
                  widget.subtitle!,

                  style: TextStyle(
                    color:
                        textSecondary,

                    fontSize:
                        glass.fontSize(
                      13,
                    ),

                    height: 1.35,
                  ),
                ),
              ],
            ],
          ),
        ),

        // --------------------------------------------------------------------
        // CLOSE
        // --------------------------------------------------------------------

        SizedBox(
          width:
              glass.spacing(8),
        ),

        IconButton(
          tooltip: 'Fermer',

          onPressed:
              widget.barrierDismissible
                  ? _close
                  : null,

          icon: Icon(
            Icons.close_rounded,

            color:
                textSecondary,

            size:
                glass.size(20),
          ),

          visualDensity:
              VisualDensity.compact,
        ),
      ],
    );
  }

  // ==========================================================================
  // ACTIONS
  // ==========================================================================

  Widget _buildActions(
    GlassLayoutContext glass,
  ) {
    final List<GlassDialogAction>
        actions =
        widget.actions ?? const [];

    return Wrap(
      alignment:
          WrapAlignment.end,

      spacing:
          glass.spacing(10),

      runSpacing:
          glass.spacing(10),

      children:
          actions.map(
        (
          GlassDialogAction action,
        ) {
          // ------------------------------------------------------------------
          // IMPORTANT :
          //
          // GlassDialogAction.build() attend UN SEUL argument.
          //
          // Il ne faut donc PAS faire :
          //
          // action.build(context, glass)
          //
          // ------------------------------------------------------------------

          return action.build(
            context,
          );
        },
      ).toList(),
    );
  }
}
