import 'package:flutter/material.dart';

// ============================================================================
// PHYSICAL TOGGLE DEFINITION
// ============================================================================
//
// Définition générique d'un contrôle physique.
//
// Cette classe décrit un contrôle sans posséder son état.
//
// Elle constitue la couche CONFIGURATION du système.
//
// ============================================================================
//
// RESPONSABILITÉS
//
// - définir l'identifiant stable du contrôle
// - définir le titre
// - définir le sous-titre
// - définir l'icône
// - définir la couleur d'accent
// - construire le widget physique réel
//
// ============================================================================
//
// NE GÈRE PAS
//
// - l'état du contrôle
// - setState
// - Riverpod
// - navigation
// - logique métier
// - affichage de la carte
//
// ============================================================================
//
// ARCHITECTURE
//
// PhysicalToggleDefinition
//          │
//          ├── id
//          ├── title
//          ├── subtitle
//          ├── icon
//          ├── accent
//          │
//          └── builder
//                 │
//                 ├── value
//                 └── onChanged
//                         │
//                         ▼
//                  Widget physique
//
// ============================================================================

class PhysicalToggleDefinition {
  // ==========================================================================
  // IDENTIFIANT
  // ==========================================================================

  /// Identifiant stable et unique du contrôle.
  ///
  /// IMPORTANT :
  ///
  /// Cet identifiant ne doit jamais dépendre de la position
  /// du contrôle dans la liste du Registry.
  ///
  /// Exemples :
  ///
  /// - breaker
  /// - metal
  /// - rocker
  /// - rotary
  /// - push_button
  /// - guarded
  /// - slider
  /// - glass
  final String id;

  // ==========================================================================
  // INFORMATIONS D'AFFICHAGE
  // ==========================================================================

  /// Nom principal affiché dans [PhysicalToggleHeader].
  final String title;

  /// Description courte affichée sous le titre.
  final String subtitle;

  /// Icône affichée dans [PhysicalToggleHeader].
  final IconData icon;

  // ==========================================================================
  // COULEUR D'ACCENT
  // ==========================================================================

  /// Couleur d'accent du contrôle.
  ///
  /// Elle est utilisée par :
  ///
  /// - PhysicalToggleCard
  /// - PhysicalToggleHeader
  /// - PhysicalToggleStatus
  final Color accent;

  // ==========================================================================
  // BUILDER
  // ==========================================================================
  //
  // Le builder est volontairement indépendant de l'état.
  //
  // Il reçoit uniquement :
  //
  //     value
  //     onChanged
  //
  // Le Registry peut donc décrire les contrôles sans connaître
  // leur état courant.
  //
  // ==========================================================================

  final Widget Function(bool value, ValueChanged<bool> onChanged) builder;

  // ==========================================================================
  // CONSTRUCTEUR
  // ==========================================================================

  const PhysicalToggleDefinition({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accent,
    required this.builder,
  }) : assert(id != '', 'PhysicalToggleDefinition.id ne peut pas être vide.'),
       assert(
         title != '',
         'PhysicalToggleDefinition.title ne peut pas être vide.',
       ),
       assert(
         subtitle != '',
         'PhysicalToggleDefinition.subtitle ne peut pas être vide.',
       );

  // ==========================================================================
  // CONSTRUCTION DU TOGGLE
  // ==========================================================================
  //
  // Construit le widget physique associé à cette définition.
  //
  // Exemple :
  //
  // final widget = definition.buildToggle(
  //   value: true,
  //   onChanged: (value) {},
  // );
  //
  // ==========================================================================

  Widget buildToggle({
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return builder(value, onChanged);
  }

  // ==========================================================================
  // COPY WITH
  // ==========================================================================

  /// Crée une nouvelle définition à partir de celle-ci.
  ///
  /// Les propriétés non fournies restent inchangées.
  PhysicalToggleDefinition copyWith({
    String? id,
    String? title,
    String? subtitle,
    IconData? icon,
    Color? accent,
    Widget Function(bool value, ValueChanged<bool> onChanged)? builder,
  }) {
    return PhysicalToggleDefinition(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      icon: icon ?? this.icon,
      accent: accent ?? this.accent,
      builder: builder ?? this.builder,
    );
  }

  // ==========================================================================
  // DEBUG
  // ==========================================================================

  @override
  String toString() {
    return 'PhysicalToggleDefinition('
        'id: $id, '
        'title: $title, '
        'subtitle: $subtitle, '
        'accent: $accent'
        ')';
  }
}
