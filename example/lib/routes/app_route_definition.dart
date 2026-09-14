
import 'package:flutter/material.dart';

/// Définition complète d'une route de l'application.
///
/// Cette classe constitue la source des métadonnées utilisées
/// aussi bien par le routeur que par les raccourcis de l'accueil.
class AppRouteDefinition {
  final String route;
  final String title;
  final String subtitle;
  final IconData icon;
  final WidgetBuilder builder;
  final bool showInQuickAccess;

  const AppRouteDefinition({
    required this.route,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.builder,
    this.showInQuickAccess = false,
  });
}
