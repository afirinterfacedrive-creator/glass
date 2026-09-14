import 'package:flutter/material.dart';

import 'package:universal_glass/components/surface/glass_surface_container.dart';
import 'package:universal_glass/core/layout/glass_layout_context.dart';
import 'package:universal_glass/core/layout/glass_layout_scope.dart';
import 'package:universal_glass/enums/glass_enums.dart';
import 'package:universal_glass/theme/glass_effects.dart';

/// Toast Glass réutilisable.
///
/// Le composant utilise [GlassLayoutContext] comme source de vérité
/// pour les couleurs, les effets et les paramètres visuels globaux.
///
/// Les couleurs spécifiques au type du Toast
/// (success, error, warning, info) restent propres au Toast.
///
/// Aucun BackdropFilter n'est créé directement ici.
class UniversalGlassToast {
  static void show(
    BuildContext context, {
    required String message,
    String? title,
    GlassToastType type = GlassToastType.info,
    GlassToastPosition position = GlassToastPosition.topCenter,
    GlassStyle? style, // <- nullable
    Color? backgroundColor,
    Duration duration = const Duration(seconds: 3),
    GlassLayoutContext? layoutOverride, // <- AJOUT POUR OVERLAY
  }) {
    final OverlayState overlayState = Overlay.of(context);
    final GlassLayoutContext glass = layoutOverride ?? GlassLayoutScope.of(context); // <- FIX

    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (BuildContext overlayContext) {
        final _ToastVisuals visuals = _resolveVisuals(
          type: type,
          glass: glass,
          customBackgroundColor: backgroundColor,
          requestedStyle: style ?? GlassStyle.solidAqua, // <- default
        );

        return _GlassToastWidget(
          glass: glass,
          title: title,
          message: message,
          icon: visuals.icon,
          statusColor: visuals.statusColor,
          duration: duration,
          position: position,
          style: visuals.style,
          backgroundColor: visuals.backgroundColor,
          onDismiss: () {
            if (overlayEntry.mounted) {
              overlayEntry.remove();
            }
          },
        );
      },
    );

    overlayState.insert(overlayEntry);
  }


  /// Résout toutes les propriétés visuelles spécifiques
  /// au type du Toast.
  ///
  /// La couleur active du thème est obtenue depuis
  /// [GlassLayoutContext] et non recalculée ici.
  static _ToastVisuals _resolveVisuals({
    required GlassToastType type,
    required GlassLayoutContext glass,
    required Color? customBackgroundColor,
    required GlassStyle requestedStyle,
  }) {
    // ------------------------------------------------------------------------
    // COULEUR ACTIVE DU THÈME
    // ------------------------------------------------------------------------
    //
    // glass.focusColor centralise déjà Aqua / Classic.
    //
    final Color accent = glass.focusColor;

    // ------------------------------------------------------------------------
    // COULEURS PAR TYPE
    // ------------------------------------------------------------------------

    switch (type) {
      case GlassToastType.success:
        return _ToastVisuals(
          icon: Icons.check_circle_outline_rounded,
          statusColor: const Color(0xFF69F0AE),
          style: customBackgroundColor != null
              ? GlassStyle.solidClassic
              : GlassStyle.transparentGreen,
          backgroundColor:
              customBackgroundColor ??
              const Color(0xFF69F0AE).withValues(alpha: 0.15),
        );

      case GlassToastType.error:
        return _ToastVisuals(
          icon: Icons.error_outline_rounded,
          statusColor: Colors.redAccent,
          style: customBackgroundColor != null
              ? GlassStyle.solidClassic
              : GlassStyle.transparentRed,
          backgroundColor:
              customBackgroundColor ??
              Colors.redAccent.withValues(alpha: 0.15),
        );

      case GlassToastType.warning:
        return _ToastVisuals(
          icon: Icons.warning_amber_rounded,
          statusColor: Colors.amberAccent,
          style: customBackgroundColor != null
              ? GlassStyle.solidClassic
              : requestedStyle,
          backgroundColor:
              customBackgroundColor ??
              Colors.amberAccent.withValues(alpha: 0.15),
        );

      case GlassToastType.info:
        return _ToastVisuals(
          icon: Icons.info_outline_rounded,
          statusColor: accent,
          style: customBackgroundColor != null
              ? GlassStyle.solidClassic
              : requestedStyle,
          backgroundColor:
              customBackgroundColor ??
              accent.withValues(alpha: 0.15),
        );
    }
  }
}

/// Résolution interne des propriétés visuelles du Toast.
class _ToastVisuals {
  final IconData icon;
  final Color statusColor;
  final GlassStyle style;
  final Color backgroundColor;

  const _ToastVisuals({
    required this.icon,
    required this.statusColor,
    required this.style,
    required this.backgroundColor,
  });
}

class _GlassToastWidget extends StatefulWidget {
  final GlassLayoutContext glass;

  final String? title;
  final String message;

  final IconData icon;
  final Color statusColor;

  final Duration duration;
  final GlassToastPosition position;

  final GlassStyle style;
  final Color backgroundColor;

  final VoidCallback onDismiss;

  const _GlassToastWidget({
    required this.glass,
    this.title,
    required this.message,
    required this.icon,
    required this.statusColor,
    required this.duration,
    required this.position,
    required this.style,
    required this.backgroundColor,
    required this.onDismiss,
  });

  @override
  State<_GlassToastWidget> createState() =>
      _GlassToastWidgetState();
}

class _GlassToastWidgetState extends State<_GlassToastWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fadeController;

  late final Animation<double> _opacityAnimation;

  late final Animation<Offset> _slideAnimation;

  bool _dismissed = false;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: Curves.easeInOut,
      ),
    );

    final Offset beginOffset = switch (widget.position) {
      GlassToastPosition.topCenter =>
        const Offset(0.0, -0.3),
      GlassToastPosition.bottomCenter =>
        const Offset(0.0, 0.3),
      GlassToastPosition.center =>
        const Offset(0.0, 0.1),
    };

    _slideAnimation = Tween<Offset>(
      begin: beginOffset,
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: Curves.easeOutCubic,
      ),
    );

    _fadeController.forward();

    Future.delayed(
      widget.duration,
      _dismiss,
    );
  }

  Future<void> _dismiss() async {
    if (!mounted || _dismissed) {
      return;
    }

    _dismissed = true;

    await _fadeController.reverse();

    if (!mounted) {
      return;
    }

    widget.onDismiss();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  Alignment _getAlignment() {
    return switch (widget.position) {
      GlassToastPosition.topCenter =>
        Alignment.topCenter,
      GlassToastPosition.bottomCenter =>
        Alignment.bottomCenter,
      GlassToastPosition.center =>
        Alignment.center,
    };
  }

  @override
  Widget build(BuildContext context) {
    final GlassLayoutContext glass = widget.glass;

    final double screenWidth =
        MediaQuery.sizeOf(context).width;

    final bool isMobile =
        screenWidth < 600.0;

    // ------------------------------------------------------------------------
    // EFFETS GLASS
    // ------------------------------------------------------------------------
    //
    // Les effets globaux restent issus du GlassLayoutContext.
    //
    // On renforce légèrement la lisibilité du Toast
    // sans recréer la logique Glass.
    //
    final GlassEffects toastEffects =
        glass.effects.copyWith(
      surfaceOpacity:
          widget.backgroundColor.a,
      borderRadius: 16.0,
    );

    return SafeArea(
      child: Align(
        alignment: _getAlignment(),
        child: SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(
            opacity: _opacityAnimation,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal:
                    isMobile ? 16.0 : 32.0,
                vertical:
                    widget.position ==
                            GlassToastPosition
                                .bottomCenter
                        ? 40.0
                        : 20.0,
              ),
              child: Material(
                type: MaterialType.transparency,
                child: ConstrainedBox(
                  constraints:
                      const BoxConstraints(
                    maxWidth: 420.0,
                  ),
                  child:
                      GlassSurfaceContainer(
                    role: GlassSurfaceRole.card,
                    style: widget.style,
                    effects: toastEffects,
                    backgroundColor:
                        widget.backgroundColor,
                    backgroundOpacity: 0.90,
                    borderRadius:
                        BorderRadius.circular(
                      16.0,
                    ),
                    padding:
                        const EdgeInsets.all(
                      14.0,
                    ),
                    liftOnHover: false,
                    child: Row(
                      crossAxisAlignment:
                          CrossAxisAlignment.center,
                      children: [
                        // ----------------------------------------------------
                        // ICÔNE
                        // ----------------------------------------------------

                        Container(
                          decoration:
                              BoxDecoration(
                            shape:
                                BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: widget
                                    .statusColor
                                    .withValues(
                                  alpha: 0.40,
                                ),
                                blurRadius: 12.0,
                                spreadRadius: 1.0,
                              ),
                            ],
                          ),
                          child: Icon(
                            widget.icon,
                            color:
                                widget.statusColor,
                            size: 22.0,
                          ),
                        ),

                        const SizedBox(
                          width: 12.0,
                        ),

                        // ----------------------------------------------------
                        // TEXTE
                        // ----------------------------------------------------

                        Expanded(
                          child: Column(
                            mainAxisSize:
                                MainAxisSize.min,
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                            children: [
                              if (widget.title !=
                                  null)
                                Padding(
                                  padding:
                                      const EdgeInsets
                                          .only(
                                    bottom: 2.0,
                                  ),
                                  child: Text(
                                    widget.title!,
                                    maxLines: 1,
                                    overflow:
                                        TextOverflow
                                            .ellipsis,
                                    style:
                                        TextStyle(
                                      color: glass
                                          .palette
                                          .textPrimary,
                                      fontSize: 13.0,
                                      fontWeight:
                                          FontWeight
                                              .bold,
                                    ),
                                  ),
                                ),
                              Text(
                                widget.message,
                                maxLines: 4,
                                overflow:
                                    TextOverflow
                                        .ellipsis,
                                style: TextStyle(
                                  color: glass
                                      .palette
                                      .textSecondary
                                      .withValues(
                                    alpha: 0.90,
                                  ),
                                  fontSize: 12.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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
}