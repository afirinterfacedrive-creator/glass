import 'package:flutter/material.dart';

import 'package:universal_glass/components/glass_breaker_switch.dart';
import 'package:universal_glass/components/toggle/physical_toggles.dart';
import 'package:universal_glass/components/toggle/toggle_types.dart';

import 'physical_toggle_definition.dart';

// ============================================================================
// PHYSICAL TOGGLE REGISTRY
// ============================================================================
//
// Registre central de tous les contrôles physiques disponibles.
//
// RESPONSABILITÉS
//
// - déclarer les contrôles disponibles
// - fournir leurs métadonnées
// - fournir leur builder
// - fournir un identifiant stable
// - permettre une recherche par ID
//
// NE GÈRE PAS
//
// - l'état des toggles
// - setState
// - Riverpod
// - navigation
// - logique métier
// - affichage
//
// ============================================================================
//
// ARCHITECTURE
//
// PhysicalToggleRegistry
//          │
//          ▼
//     definitions
//          │
//          ├── breaker
//          ├── metal
//          ├── rocker
//          ├── rotary
//          ├── push_button
//          ├── guarded
//          ├── slider
//          └── glass
//
// ============================================================================

class PhysicalToggleRegistry {
  // ==========================================================================
  // CONSTRUCTEUR PRIVÉ
  // ==========================================================================
  //
  // Le Registry fonctionne uniquement comme registre statique.
  //
  // ==========================================================================

  PhysicalToggleRegistry._();

  // ==========================================================================
  // IDENTIFIANTS
  // ==========================================================================
  //
  // Centraliser les IDs évite les fautes de frappe dans le reste du système.
  //
  // ==========================================================================

  static const String breakerId = 'breaker';
  static const String metalId = 'metal';
  static const String rockerId = 'rocker';
  static const String rotaryId = 'rotary';
  static const String pushButtonId = 'push_button';
  static const String guardedId = 'guarded';
  static const String sliderId = 'slider';
  static const String glassId = 'glass';

  // ==========================================================================
  // DÉFINITIONS
  // ==========================================================================
  //
  // Liste centrale et immuable des contrôles.
  //
  // L'ordre de cette liste correspond à l'ordre d'affichage par défaut.
  //
  // ==========================================================================

  static final List<PhysicalToggleDefinition>
  definitions = List<PhysicalToggleDefinition>.unmodifiable([
    // ======================================================================
    // 1. BREAKER
    // ======================================================================
    PhysicalToggleDefinition(
      id: breakerId,
      title: 'Breaker',
      subtitle: 'Disjoncteur',
      icon: Icons.power,
      accent: Colors.redAccent,
      builder: (bool value, ValueChanged<bool> onChanged) {
        return GlassBreakerSwitch(value: value, onChanged: onChanged);
      },
    ),

    // ======================================================================
    // 2. METAL
    // ======================================================================
    PhysicalToggleDefinition(
      id: metalId,
      title: 'Metal',
      subtitle: 'Levier métallique',
      icon: Icons.toggle_on,
      accent: Colors.blueGrey,
      builder: (bool value, ValueChanged<bool> onChanged) {
        return MetalToggleSwitch(
          value: value,
          orientation: ToggleOrientation.vertical,
          onChanged: onChanged,
        );
      },
    ),

    // ======================================================================
    // 3. ROCKER
    // ======================================================================
    PhysicalToggleDefinition(
      id: rockerId,
      title: 'Rocker',
      subtitle: 'Interrupteur à bascule',
      icon: Icons.power_settings_new,
      accent: Colors.orangeAccent,
      builder: (bool value, ValueChanged<bool> onChanged) {
        return RockerSwitch(
          value: value,
          orientation: ToggleOrientation.vertical,
          onChanged: onChanged,
        );
      },
    ),

    // ======================================================================
    // 4. ROTARY
    // ======================================================================
    PhysicalToggleDefinition(
      id: rotaryId,
      title: 'Rotary',
      subtitle: 'Sélecteur rotatif',
      icon: Icons.settings,
      accent: Colors.amberAccent,
      builder: (bool value, ValueChanged<bool> onChanged) {
        return RotarySwitch(
          value: value,
          orientation: ToggleOrientation.vertical,
          onChanged: onChanged,
        );
      },
    ),

    // ======================================================================
    // 5. PUSH BUTTON
    // ======================================================================
    PhysicalToggleDefinition(
      id: pushButtonId,
      title: 'Push Button',
      subtitle: 'Bouton poussoir',
      icon: Icons.radio_button_checked,
      accent: Colors.greenAccent,
      builder: (bool value, ValueChanged<bool> onChanged) {
        return PushButtonSwitch(
          value: value,
          orientation: ToggleOrientation.vertical,
          onChanged: onChanged,
        );
      },
    ),

    // ======================================================================
    // 6. GUARDED
    // ======================================================================
    PhysicalToggleDefinition(
      id: guardedId,
      title: 'Guarded',
      subtitle: 'Interrupteur sécurisé',
      icon: Icons.shield,
      accent: Colors.deepOrangeAccent,
      builder: (bool value, ValueChanged<bool> onChanged) {
        return GuardedSwitch(
          value: value,
          orientation: ToggleOrientation.vertical,
          onChanged: onChanged,
        );
      },
    ),

    // ======================================================================
    // 7. SLIDER
    // ======================================================================
    PhysicalToggleDefinition(
      id: sliderId,
      title: 'Slider',
      subtitle: 'Curseur mécanique',
      icon: Icons.linear_scale,
      accent: Colors.cyanAccent,
      builder: (bool value, ValueChanged<bool> onChanged) {
        return SliderSwitch(
          value: value,
          orientation: ToggleOrientation.horizontal,
          onChanged: onChanged,
        );
      },
    ),

    // ======================================================================
    // 8. GLASS
    // ======================================================================
    PhysicalToggleDefinition(
      id: glassId,
      title: 'Glass',
      subtitle: 'Glass Toggle',
      icon: Icons.blur_on,
      accent: Colors.cyanAccent,
      builder: (bool value, ValueChanged<bool> onChanged) {
        return GlassToggleSwitch(
          value: value,
          orientation: ToggleOrientation.horizontal,
          onChanged: onChanged,
        );
      },
    ),
  ]);

  // ==========================================================================
  // RECHERCHE PAR ID
  // ==========================================================================

  /// Retourne la définition correspondant à [id].
  ///
  /// Retourne `null` si aucun contrôle ne correspond.
  static PhysicalToggleDefinition? findById(String id) {
    for (final definition in definitions) {
      if (definition.id == id) {
        return definition;
      }
    }

    return null;
  }

  // ==========================================================================
  // RECHERCHE OBLIGATOIRE
  // ==========================================================================

  /// Retourne la définition correspondant à [id].
  ///
  /// Lance une [StateError] si l'ID n'existe pas.
  ///
  /// Utile lorsqu'un ID est censé être garanti par le programme.
  static PhysicalToggleDefinition requireById(String id) {
    final definition = findById(id);

    if (definition == null) {
      throw StateError('PhysicalToggleDefinition introuvable pour id="$id".');
    }

    return definition;
  }

  // ==========================================================================
  // EXISTENCE
  // ==========================================================================

  /// Indique si un contrôle portant [id] existe.
  static bool contains(String id) {
    return findById(id) != null;
  }

  // ==========================================================================
  // NOMBRE DE CONTRÔLES
  // ==========================================================================

  static int get count => definitions.length;

  // ==========================================================================
  // IDS
  // ==========================================================================

  /// Retourne tous les identifiants disponibles.
  static List<String> get ids {
    return List<String>.unmodifiable(
      definitions.map((PhysicalToggleDefinition definition) => definition.id),
    );
  }

  // ==========================================================================
  // DÉFINITIONS PAR ID
  // ==========================================================================

  /// Retourne plusieurs définitions correspondant aux IDs demandés.
  ///
  /// Les IDs inconnus sont simplement ignorés.
  static List<PhysicalToggleDefinition> findAllByIds(Iterable<String> ids) {
    final Set<String> requestedIds = ids.toSet();

    return List<PhysicalToggleDefinition>.unmodifiable(
      definitions.where(
        (PhysicalToggleDefinition definition) =>
            requestedIds.contains(definition.id),
      ),
    );
  }
}
