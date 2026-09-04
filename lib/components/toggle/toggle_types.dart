// lib/components/toggle/toggle_types.dart

import 'package:flutter/material.dart';

/// ============================================================================
/// ORIENTATION COMMUNE À TOUS LES TOGGLES
/// ============================================================================
///
/// Définition unique de l'orientation utilisée par les toggles.
///
/// IMPORTANT :
/// - Ne pas redéclarer ToggleOrientation ailleurs.
/// - Les widgets de toggle importent ce fichier.
///
enum ToggleOrientation { horizontal, vertical }

/// ============================================================================
/// TYPE DE TOGGLE PHYSIQUE
/// ============================================================================
///
/// Identifie le style de toggle utilisé.
///
/// IMPORTANT :
/// - Aucun rendu graphique ici.
/// - Aucune dépendance vers un widget particulier.
/// - Peut être utilisé par des registres, factories ou adaptateurs.
///
enum PhysicalToggleType {
  metal,
  rocker,
  rotary,
  push,
  guarded,
  slider,
  glass,
}

/// ============================================================================
/// UTILITAIRES D'ORIENTATION
/// ============================================================================

extension ToggleOrientationExtension on ToggleOrientation {
  /// Axe Flutter correspondant à l'orientation.
  Axis get axis {
    switch (this) {
      case ToggleOrientation.horizontal:
        return Axis.horizontal;

      case ToggleOrientation.vertical:
        return Axis.vertical;
    }
  }

  /// Indique si l'orientation est horizontale.
  bool get isHorizontal => this == ToggleOrientation.horizontal;

  /// Indique si l'orientation est verticale.
  bool get isVertical => this == ToggleOrientation.vertical;
}

/// ============================================================================
/// INFORMATIONS SUR LES TYPES DE TOGGLE
/// ============================================================================

extension PhysicalToggleTypeExtension on PhysicalToggleType {
  /// Nom court affichable.
  ///
  /// Exemple :
  ///
  /// PhysicalToggleType.breaker.label
  /// → BREAKER
  ///
  String get label {
    switch (this) {
      case PhysicalToggleType.metal:
        return 'METAL';

      case PhysicalToggleType.rocker:
        return 'ROCKER';

      case PhysicalToggleType.rotary:
        return 'ROTARY';

      case PhysicalToggleType.push:
        return 'PUSH';

      case PhysicalToggleType.guarded:
        return 'GUARDED';

      case PhysicalToggleType.slider:
        return 'SLIDER';

      case PhysicalToggleType.glass:
        return 'GLASS';
    }
  }

  /// Indique si ce type correspond au toggle Glass.
  bool get isGlass => this == PhysicalToggleType.glass;

  /// Indique si ce type correspond à un toggle physique.
  ///
  /// Cette propriété est volontairement simple afin de conserver
  /// une API extensible si de nouveaux types sont ajoutés plus tard.
  bool get isPhysical => true;
}
