// ignore: unnecessary_library_name
library universal_glass_theme;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:universal_glass/core/layout/glass_layout_context.dart';
import 'package:universal_glass/core/layout/glass_layout_scope.dart';


/// ============================================================================
/// WIDGET REF EXTENSION
/// ============================================================================

extension GlassThemeRefExtension on WidgetRef {
  /// Retourne le contexte Glass canonique.
  ///
  /// Le contexte doit être fourni par [GlassLayoutScope].
  ///
  /// Cette méthode est conservée uniquement pour compatibilité avec
  /// les anciens widgets utilisant encore `ref.watchGlassContext(context)`.
  GlassLayoutContext watchGlassContext(
    BuildContext context,
  ) {
    return GlassLayoutScope.of(context);
  }
}

/// ============================================================================
/// BUILD CONTEXT EXTENSION
/// ============================================================================

extension GlassThemeContextExtension on BuildContext {
  /// Retourne le contexte Glass canonique fourni par [GlassLayoutScope].
  ///
  /// Cette propriété ne reconstruit plus un GlassLayoutContext.
  /// Elle utilise directement la source de vérité de l'arbre Flutter.
  ///
  /// Utilisation recommandée :
  ///
  ///     final GlassLayoutContext glass = context.glassLayout;
  ///
  /// ou :
  ///
  ///     final GlassLayoutContext glass =
  ///         GlassLayoutScope.of(context);
  GlassLayoutContext get watchGlassContext {
    return GlassLayoutScope.of(this);
  }
}