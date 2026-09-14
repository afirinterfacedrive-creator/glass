import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:universal_glass/provider/glass_theme_provider.dart';
import 'package:universal_glass/provider/glass_theme_state.dart';
import 'package:universal_glass/theme/glass_scale_engine.dart';

import 'glass_layout_context.dart';

/// Fournit un [GlassLayoutContext] à tous les widgets descendants.
///
/// Le layout est normalement calculé automatiquement à partir du contexte
/// courant.
///
/// [layoutOverride] permet cependant de réutiliser un layout déjà calculé.
/// C'est notamment utile pour les routes créées par [showDialog], dont le
/// contexte se trouve dans l'Overlay et donc en dehors du scope de la page.
class GlassLayoutScope extends ConsumerWidget {
  final Widget child;

  /// Layout déjà calculé à réutiliser.
  ///
  /// Lorsqu'il est fourni, le scope n'effectue pas un nouveau calcul.
  final GlassLayoutContext? layoutOverride;

  final double? maxWidth;
  final double? tabletBreakpoint;
  final double? desktopBreakpoint;
  final double? desktopPadding;
  final double? tabletPadding;
  final double? mobilePadding;
  final double? smallMobilePadding;

  const GlassLayoutScope({
    super.key,
    required this.child,
    this.layoutOverride,
    this.maxWidth,
    this.tabletBreakpoint,
    this.desktopBreakpoint,
    this.desktopPadding,
    this.tabletPadding,
    this.mobilePadding,
    this.smallMobilePadding,
  });

  /// Retourne le [GlassLayoutContext] fourni par le scope parent.
  ///
  /// Lance une [FlutterError] si le widget est utilisé en dehors
  /// d'un [GlassLayoutScope].
  static GlassLayoutContext of(BuildContext context) {
    final _GlassLayoutInherited? result =
        context.dependOnInheritedWidgetOfExactType<_GlassLayoutInherited>();

    if (result != null) {
      return result.layout;
    }

    throw FlutterError(
      'GlassLayoutScope.of() a été appelé '
      'en dehors d’un GlassLayoutScope.',
    );
  }

  /// Version sécurisée de [of].
  ///
  /// Retourne null lorsqu'aucun [GlassLayoutScope] n'est disponible.
  static GlassLayoutContext? maybeOf(BuildContext context) {
    final _GlassLayoutInherited? result =
        context.dependOnInheritedWidgetOfExactType<_GlassLayoutInherited>();

    return result?.layout;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GlassThemeState theme = ref.watch(glassThemeProvider);

    final GlassLayoutContext layout;

    // -----------------------------------------------------------------------
    // 1. Layout fourni explicitement
    // -----------------------------------------------------------------------
    //
    // Utilisé notamment par GlassDialog lorsque showDialog() crée une
    // nouvelle route en dehors du scope de la page.
    //
    if (layoutOverride != null) {
      layout = layoutOverride!;
    } else {
      // ---------------------------------------------------------------------
      // 2. Layout calculé normalement
      // ---------------------------------------------------------------------
      final GlassScaleData scale =
          GlassScale.maybeOf(context);

      layout = GlassLayoutContext.resolve(
        context: context,
        theme: theme,
        scale: scale,
        maxWidthOverride: maxWidth,
        desktopBreakpointOverride: desktopBreakpoint,
        tabletBreakpointOverride: tabletBreakpoint,
        desktopPaddingOverride: desktopPadding,
        tabletPaddingOverride: tabletPadding,
        mobilePaddingOverride: mobilePadding,
        smallMobilePaddingOverride: smallMobilePadding,
      );
    }

    return _GlassLayoutInherited(
      layout: layout,
      child: child,
    );
  }
}

/// InheritedWidget interne utilisé pour transmettre le layout.
class _GlassLayoutInherited extends InheritedWidget {
  final GlassLayoutContext layout;

  const _GlassLayoutInherited({
    required this.layout,
    required super.child,
  });

  @override
  bool updateShouldNotify(_GlassLayoutInherited oldWidget) {
    return oldWidget.layout != layout;
  }
}