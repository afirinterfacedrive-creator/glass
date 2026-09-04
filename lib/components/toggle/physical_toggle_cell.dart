// lib/components/toggle/physical_toggle_cell.dart

import 'package:flutter/material.dart';

import 'toggle_types.dart';
import 'physical_toggles.dart';

/// ============================================================================
/// PHYSICAL TOGGLE CELL
///
/// Adaptateur générique permettant d'afficher automatiquement le bon toggle
/// physique à partir de [PhysicalToggleType].
///
/// IMPORTANT :
/// - Ne gère aucune base de données.
/// - Ne gère aucun DataTable.
/// - Ne contient aucune logique métier.
/// - Sert uniquement à sélectionner et afficher le bon toggle.
///
/// Toggles disponibles :
///   • breaker
///   • metal
///   • rocker
///   • rotary
///   • push
///   • guarded
///   • slider
///   • glass
///
/// Exemple :
///
/// PhysicalToggleCell(
///   type: PhysicalToggleType.breaker,
///   value: true,
///   onChanged: (value) {
///     print(value);
///   },
/// )
/// ============================================================================
class PhysicalToggleCell extends StatelessWidget {
  /// --------------------------------------------------------------------------
  /// TYPE
  /// --------------------------------------------------------------------------

  /// Type du toggle physique à afficher.
  final PhysicalToggleType type;

  /// --------------------------------------------------------------------------
  /// ÉTAT
  /// --------------------------------------------------------------------------

  /// État actuel du toggle.
  final bool value;

  /// --------------------------------------------------------------------------
  /// CALLBACK
  /// --------------------------------------------------------------------------

  /// Appelé lorsque l'utilisateur modifie l'état du toggle.
  final ValueChanged<bool> onChanged;

  /// --------------------------------------------------------------------------
  /// ORIENTATION
  /// --------------------------------------------------------------------------

  /// Orientation commune à tous les toggles.
  ///
  /// Par défaut :
  /// [ToggleOrientation.vertical]
  final ToggleOrientation orientation;

  /// --------------------------------------------------------------------------
  /// DIMENSIONS
  /// --------------------------------------------------------------------------

  /// Largeur personnalisée.
  ///
  /// Si null, la largeur par défaut du toggle est utilisée.
  final double? width;

  /// Hauteur personnalisée.
  ///
  /// Si null, la hauteur par défaut du toggle est utilisée.
  final double? height;

  /// Taille spécifique au [RotarySwitch].
  final double? size;

  /// --------------------------------------------------------------------------
  /// ÉTAT D'INTERACTION
  /// --------------------------------------------------------------------------

  /// Active ou désactive complètement le toggle.
  ///
  /// Lorsqu'il est false :
  /// - le toggle devient semi-transparent ;
  /// - les interactions sont bloquées.
  final bool enabled;

  /// --------------------------------------------------------------------------
  /// ÉCHELLE
  /// --------------------------------------------------------------------------

  /// Échelle visuelle du toggle.
  ///
  /// Exemple :
  ///
  /// scale: 0.8
  ///
  /// ou
  ///
  /// scale: 1.2
  final double scale;

  /// --------------------------------------------------------------------------
  /// CONSTRUCTEUR
  /// --------------------------------------------------------------------------

  const PhysicalToggleCell({
    super.key,
    required this.type,
    required this.value,
    required this.onChanged,
    this.orientation = ToggleOrientation.vertical,
    this.width,
    this.height,
    this.size,
    this.enabled = true,
    this.scale = 1.0,
  });

  /// ==========================================================================
  /// BUILD
  /// ==========================================================================

  @override
  Widget build(BuildContext context) {
    Widget toggle = _buildToggle();

    // -------------------------------------------------------------------------
    // DISABLED
    // -------------------------------------------------------------------------

    if (!enabled) {
      toggle = Opacity(
        opacity: 0.45,
        child: IgnorePointer(ignoring: true, child: toggle),
      );
    }

    // -------------------------------------------------------------------------
    // SCALE
    // -------------------------------------------------------------------------

    if (scale != 1.0) {
      toggle = Transform.scale(
        scale: scale,
        alignment: Alignment.center,
        child: toggle,
      );
    }

    // -------------------------------------------------------------------------
    // CENTER
    // -------------------------------------------------------------------------

    return Center(child: toggle);
  }

  /// ==========================================================================
  /// CONSTRUCTION DU TOGGLE
  /// ==========================================================================

  Widget _buildToggle() {
    switch (type) {
      // ========================================================================
      // METAL
      // ========================================================================

      case PhysicalToggleType.metal:
        return MetalToggleSwitch(
          value: value,
          onChanged: onChanged,
          orientation: orientation,
          width: width ?? 48,
          height: height ?? 72,
        );

      // ========================================================================
      // ROCKER
      // ========================================================================

      case PhysicalToggleType.rocker:
        return RockerSwitch(
          value: value,
          onChanged: onChanged,
          orientation: orientation,
          width: width ?? 48,
          height: height ?? 68,
        );

      // ========================================================================
      // ROTARY
      // ========================================================================

      case PhysicalToggleType.rotary:
        return RotarySwitch(
          value: value,
          onChanged: onChanged,
          orientation: orientation,
          size: size ?? 70,
        );

      // ========================================================================
      // PUSH
      // ========================================================================

      case PhysicalToggleType.push:
        return PushButtonSwitch(
          value: value,
          onChanged: onChanged,
          orientation: orientation,
          width: width ?? 58,
          height: height ?? 58,
        );

      // ========================================================================
      // GUARDED
      // ========================================================================

      case PhysicalToggleType.guarded:
        return GuardedSwitch(
          value: value,
          onChanged: onChanged,
          orientation: orientation,
          width: width ?? 52,
          height: height ?? 75,
        );

      // ========================================================================
      // SLIDER
      // ========================================================================

      case PhysicalToggleType.slider:
        return SliderSwitch(
          value: value,
          onChanged: onChanged,
          orientation: orientation,
          width: width ?? 80,
          height: height ?? 32,
        );

      // ========================================================================
      // GLASS
      // ========================================================================

      case PhysicalToggleType.glass:
        return GlassToggleSwitch(
          value: value,
          onChanged: onChanged,
          orientation: orientation,
          width: width ?? 82,
          height: height ?? 36,
        );
    }
  }
}
