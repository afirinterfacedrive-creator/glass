import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:universal_glass/components/surface/glass_surface_container.dart';
import 'package:universal_glass/core/layout/glass_layout_context.dart';
import 'package:universal_glass/core/layout/glass_layout_scope.dart';
import 'package:universal_glass/enums/glass_enums.dart';
import 'package:universal_glass/theme/glass_effects.dart';

import 'glass_modal_controller.dart';

/// ============================================================================
/// GLASS MODAL
/// ============================================================================
///
/// Modal Glass générique.
///
/// Exemple :
///
/// ```dart
/// await GlassModal.show(
///   context: context,
///   title: 'Paramètres',
///   child: MySettingsWidget(),
/// );
/// ```
///
/// Le widget utilise le thème Glass actif sans connaître directement la
/// logique Aqua / Classic.
///
/// Le GlassLayoutContext du contexte appelant est capturé avant la création
/// de la route du modal afin que tous les descendants puissent continuer
/// à utiliser GlassLayoutScope.of(context).
///
class GlassModal extends ConsumerStatefulWidget {
  // ==========================================================================
  // PROPRIÉTÉS
  // ==========================================================================

  final Widget child;

  final String? title;
  final String? subtitle;
  final Widget? leading;
  final List<Widget>? actions;

  final GlassStyle style;
  final GlassEffects? effects;

  final Color? backgroundColor;

  final double? width;
  final double? maxWidth;
  final double? height;
  final double? maxHeight;

  final EdgeInsetsGeometry padding;

  final bool barrierDismissible;
  final bool showCloseButton;

  final Color? barrierColor;

  final BorderRadius? borderRadius;

  final VoidCallback? onClose;

  /// Layout capturé depuis le contexte appelant.
  ///
  /// Important pour les widgets affichés via showDialog(), car la nouvelle
  /// route du modal ne se trouve pas automatiquement sous le
  /// GlassLayoutScope de la page.
  final GlassLayoutContext? layout;

  // ==========================================================================
  // CONSTRUCTEUR
  // ==========================================================================

  const GlassModal({
    super.key,
    required this.child,
    this.title,
    this.subtitle,
    this.leading,
    this.actions,
    this.style = GlassStyle.transparentAqua,
    this.effects,
    this.backgroundColor,
    this.width,
    this.maxWidth = 560,
    this.height,
    this.maxHeight,
    this.padding = const EdgeInsets.all(24),
    this.barrierDismissible = true,
    this.showCloseButton = true,
    this.barrierColor,
    this.borderRadius,
    this.onClose,
    this.layout,
  });

  // ==========================================================================
  // SHOW
  // ==========================================================================

  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    String? title,
    String? subtitle,
    Widget? leading,
    List<Widget>? actions,
    GlassStyle style = GlassStyle.transparentAqua,
    GlassEffects? effects,
    Color? backgroundColor,
    double? width,
    double? maxWidth = 560,
    double? height,
    double? maxHeight,
    EdgeInsetsGeometry padding = const EdgeInsets.all(24),
    bool barrierDismissible = true,
    bool showCloseButton = true,
    Color? barrierColor,
    BorderRadius? borderRadius,
    VoidCallback? onClose,
  }) {
    // ------------------------------------------------------------------------
    // IMPORTANT
    //
    // On capture le GlassLayoutContext AVANT showDialog().
    //
    // Après showDialog(), le builder appartient à une nouvelle route et son
    // contexte peut être en dehors du GlassLayoutScope de la page.
    // ------------------------------------------------------------------------

    final GlassLayoutContext? layout =
        GlassLayoutScope.maybeOf(context);

    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor:
          barrierColor ?? Colors.black.withValues(alpha: 0.55),
      builder: (BuildContext modalContext) {
        final GlassModal modal = GlassModal(
          title: title,
          subtitle: subtitle,
          leading: leading,
          actions: actions,
          style: style,
          effects: effects,
          backgroundColor: backgroundColor,
          width: width,
          maxWidth: maxWidth,
          height: height,
          maxHeight: maxHeight,
          padding: padding,
          barrierDismissible: barrierDismissible,
          showCloseButton: showCloseButton,
          borderRadius: borderRadius,
          onClose: onClose,
          layout: layout,
          child: child,
        );

        // --------------------------------------------------------------------
        // On réinjecte le layout capturé dans la nouvelle route.
        // --------------------------------------------------------------------

        if (layout != null) {
          return GlassLayoutScope(
            layoutOverride: layout,
            child: modal,
          );
        }

        // --------------------------------------------------------------------
        // Fallback : si le modal est appelé hors d'un GlassLayoutScope,
        // on crée simplement un scope local.
        // --------------------------------------------------------------------

        return GlassLayoutScope(
          child: modal,
        );
      },
    );
  }

  // ==========================================================================
  // STATE
  // ==========================================================================

  @override
  ConsumerState<GlassModal> createState() => _GlassModalState();
}

// ============================================================================
// STATE
// ============================================================================

class _GlassModalState extends ConsumerState<GlassModal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;

  late final GlassModalController _controller;

  // ==========================================================================
  // INIT
  // ==========================================================================

  @override
  void initState() {
    super.initState();

    _controller = GlassModalController(
      onClose: widget.onClose,
    );

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
      reverseDuration: const Duration(milliseconds: 160),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.96,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutBack,
        reverseCurve: Curves.easeInBack,
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _animationController.forward();
      }
    });
  }

  // ==========================================================================
  // DISPOSE
  // ==========================================================================

  @override
  void dispose() {
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

    _controller.close();

    await _animationController.reverse();

    if (!mounted) {
      return;
    }

    Navigator.of(context).pop();
  }

  // ==========================================================================
  // BUILD
  // ==========================================================================

  @override
  Widget build(BuildContext context) {
    // ------------------------------------------------------------------------
    // Si un layout a été capturé avant showDialog(), on le réutilise.
    //
    // Sinon, on récupère le layout depuis le scope courant.
    // ------------------------------------------------------------------------

    final GlassLayoutContext glass =
        widget.layout ??
        GlassLayoutScope.of(context);

    final GlassEffects effectiveEffects =
        widget.effects ??
        glass.effects.copyWith(
          borderRadius:
              widget.borderRadius?.topLeft.x ??
              glass.effects.borderRadius,
        );

    return Material(
      type: MaterialType.transparency,
      child: SafeArea(
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth:
                      widget.maxWidth ?? double.infinity,
                  maxHeight:
                      widget.maxHeight ?? double.infinity,
                ),
                child: SizedBox(
                  width: widget.width,
                  height: widget.height,
                  child: GlassSurfaceContainer(
                    role: GlassSurfaceRole.modal,
                    style: widget.style,
                    effects: effectiveEffects,
                    backgroundColor:
                        widget.backgroundColor,
                    child: Padding(
                      padding: widget.padding,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment:
                            CrossAxisAlignment.stretch,
                        children: [
                          if (widget.title != null ||
                              widget.subtitle != null ||
                              widget.leading != null ||
                              widget.showCloseButton) ...[
                            _buildHeader(glass),
                            const SizedBox(height: 18),
                          ],

                          Flexible(
                            child: SingleChildScrollView(
                              child: widget.child,
                            ),
                          ),

                          if (widget.actions != null &&
                              widget.actions!.isNotEmpty) ...[
                            const SizedBox(height: 20),
                            _buildActions(),
                          ],
                        ],
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
  // HEADER
  // ==========================================================================

  Widget _buildHeader(
    GlassLayoutContext glass,
  ) {
    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        if (widget.leading != null) ...[
          widget.leading!,
          const SizedBox(width: 12),
        ],

        if (widget.title != null ||
            widget.subtitle != null)
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
                          glass.palette.textPrimary,
                      fontSize: 20,
                      fontWeight:
                          FontWeight.w700,
                    ),
                  ),

                if (widget.subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    widget.subtitle!,
                    style: TextStyle(
                      color:
                          glass.palette.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ],
            ),
          ),

        if (widget.showCloseButton)
          IconButton(
            tooltip: 'Fermer',
            onPressed: _close,
            icon: Icon(
              Icons.close_rounded,
              color:
                  glass.palette.textSecondary,
            ),
          ),
      ],
    );
  }

  // ==========================================================================
  // ACTIONS
  // ==========================================================================

  Widget _buildActions() {
    return Wrap(
      alignment: WrapAlignment.end,
      spacing: 10,
      runSpacing: 8,
      children: widget.actions!,
    );
  }
}