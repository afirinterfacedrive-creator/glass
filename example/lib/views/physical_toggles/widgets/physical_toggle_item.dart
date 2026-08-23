import 'package:flutter/material.dart';

// ============================================================================
// PHYSICAL TOGGLE ITEM
// ============================================================================
//
// Représente UNE INSTANCE RENDUE d'un contrôle physique.
//
// IMPORTANT
//
// Il existe maintenant deux niveaux dans l'architecture:
//
//   PhysicalToggleDefinition
//          │
//          │ configuration statique
//          ▼
//   PhysicalToggleItem
//          │
//          │ état actuel + widget construit
//          ▼
//   PhysicalToggleCard
//
// -----------------------------------------------------------------------------
//
// PhysicalToggleDefinition
//
// Contient:
//
// - id
// - title
// - subtitle
// - icon
// - accent
// - builder
//
// Elle ne possède PAS l'état.
//
// -----------------------------------------------------------------------------
//
// PhysicalToggleItem
//
// Contient:
//
// - id
// - title
// - subtitle
// - icon
// - accent
// - value
// - child
//
// Il représente donc le résultat concret d'une définition pour un état donné.
//
// ============================================================================
//
// RESPONSABILITÉS
//
// - transporter les données nécessaires à PhysicalToggleCard
// - transporter l'état actuel du contrôle
// - transporter le widget physique déjà construit
// - permettre un copyWith() propre
//
// NE GÈRE PAS
//
// - Riverpod
// - navigation
// - setState
// - logique métier
// - registre
// - construction automatique du toggle
//
// ============================================================================
//
// ARCHITECTURE
//
// PhysicalToggleDefinition
//          │
//          │ buildToggle()
//          ▼
// PhysicalToggleItem
//          │
//          ├── id
//          ├── title
//          ├── subtitle
//          ├── icon
//          ├── accent
//          ├── value
//          └── child
//                  │
//                  ▼
//          PhysicalToggleCard
//
// ============================================================================
//
// EXEMPLE
//
// final item = PhysicalToggleItem(
//   id: 'rotary',
//   title: 'Rotary',
//   subtitle: 'Sélecteur rotatif',
//   icon: Icons.settings,
//   value: _rotary,
//   accent: Colors.amberAccent,
//   child: RotarySwitch(
//     value: _rotary,
//     orientation: ToggleOrientation.vertical,
//     onChanged: onChanged,
//   ),
// );
//
// Puis:
//
// PhysicalToggleCard(
//   title: item.title,
//   subtitle: item.subtitle,
//   icon: item.icon,
//   value: item.value,
//   accent: item.accent,
//   child: item.child,
// );
//
// ============================================================================

class PhysicalToggleItem {
  // ==========================================================================
  // IDENTIFIANT
  // ==========================================================================

  /// Identifiant unique du contrôle.
  ///
  /// Il correspond normalement à l'identifiant de
  /// PhysicalToggleDefinition.
  ///
  /// Exemples:
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
  // INFORMATIONS
  // ==========================================================================

  /// Nom principal du contrôle.
  final String title;

  /// Description courte affichée sous le nom.
  final String subtitle;

  /// Icône représentative du contrôle.
  final IconData icon;

  // ==========================================================================
  // ÉTAT
  // ==========================================================================

  /// État actuel du contrôle.
  ///
  /// true  = ACTIVE
  /// false = INACTIVE
  final bool value;

  // ==========================================================================
  // COULEUR
  // ==========================================================================

  /// Couleur d'accent utilisée par la carte.
  final Color accent;

  // ==========================================================================
  // CONTRÔLE
  // ==========================================================================

  /// Widget représentant le contrôle physique réel.
  ///
  /// Ce widget est déjà construit à partir de l'état `value`.
  final Widget child;

  // ==========================================================================
  // CONSTRUCTEUR
  // ==========================================================================

  const PhysicalToggleItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.value,
    required this.accent,
    required this.child,
  });

  // ==========================================================================
  // COPY WITH
  // ==========================================================================
  //
  // Permet de créer une nouvelle instance en modifiant uniquement certaines
  // propriétés.
  //
  // Exemple:
  //
  // item.copyWith(
  //   value: true,
  // );
  //
  // ==========================================================================

  PhysicalToggleItem copyWith({
    String? id,
    String? title,
    String? subtitle,
    IconData? icon,
    bool? value,
    Color? accent,
    Widget? child,
  }) {
    return PhysicalToggleItem(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      icon: icon ?? this.icon,
      value: value ?? this.value,
      accent: accent ?? this.accent,
      child: child ?? this.child,
    );
  }

  // ==========================================================================
  // DEBUG
  // ==========================================================================

  @override
  String toString() {
    return 'PhysicalToggleItem('
        'id: $id, '
        'title: $title, '
        'subtitle: $subtitle, '
        'value: $value, '
        'accent: $accent'
        ')';
  }
}
