import 'package:flutter/material.dart';

import 'package:universal_glass/glass.dart';

import '../widgets/physical_toggle_card.dart';
import '../widgets/physical_toggle_definition.dart';
import '../widgets/physical_toggle_item.dart';
import '../widgets/physical_toggle_registry.dart';
import '../../control_panel/widgets/control_panel_section_title.dart';

// ============================================================================
// PHYSICAL TOGGLES SECTION
// ============================================================================
//
// Section de démonstration affichant la collection des contrôles physiques.
//
// Cette classe appartient à l'application Example.
//
// Elle utilise les composants réutilisables fournis par le package Glass.
//
// ============================================================================
//
// ARCHITECTURE
//
// PhysicalTogglesSection
//          │
//          ▼
// PhysicalToggleRegistry
//          │
//          ▼
// List<PhysicalToggleDefinition>
//          │
//          ▼
// PhysicalToggleItem
//          │
//          ▼
// PhysicalToggleCard
//          │
//          ▼
// Composant Glass
//
// ============================================================================

class PhysicalTogglesSection extends StatefulWidget {
  final GlassThemeState theme;

  const PhysicalTogglesSection({super.key, required this.theme});

  @override
  State<PhysicalTogglesSection> createState() => _PhysicalTogglesSectionState();
}

// ============================================================================
// STATE
// ============================================================================

class _PhysicalTogglesSectionState extends State<PhysicalTogglesSection> {
  late final Map<String, bool> _values;

  // ==========================================================================
  // INITIALISATION
  // ==========================================================================

  @override
  void initState() {
    super.initState();

    _values = {
      'breaker': true,
      'metal': false,
      'rocker': true,
      'rotary': false,
      'push_button': false,
      'guarded': true,
      'slider': false,
      'glass': true,
    };

    _synchronizeValuesWithRegistry();
  }

  // ==========================================================================
  // SYNCHRONISATION
  // ==========================================================================

  void _synchronizeValuesWithRegistry() {
    for (final PhysicalToggleDefinition definition
        in PhysicalToggleRegistry.definitions) {
      _values.putIfAbsent(definition.id, () => false);
    }
  }

  // ==========================================================================
  // BUILD
  // ==========================================================================

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double width = constraints.maxWidth;

        final int columns = _calculateColumns(width);

        final double cardHeight = _calculateCardHeight(columns: columns);

        final List<PhysicalToggleDefinition> definitions =
            PhysicalToggleRegistry.definitions;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ==================================================================
            // TITRE
            // ==================================================================
            ControlPanelSectionTitle(
              theme: widget.theme,
              title: 'PHYSICAL CONTROLS',
              description:
                  'Testez les interrupteurs et contrôles physiques '
                  'de l’interface.',
            ),

            const SizedBox(height: 18),

            // ==================================================================
            // GRILLE
            // ==================================================================
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: definitions.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                mainAxisExtent: cardHeight,
              ),
              itemBuilder: (BuildContext context, int index) {
                final PhysicalToggleDefinition definition = definitions[index];

                return _buildToggleItem(definition);
              },
            ),
          ],
        );
      },
    );
  }

  // ==========================================================================
  // TOGGLE ITEM
  // ==========================================================================

  Widget _buildToggleItem(PhysicalToggleDefinition definition) {
    final String id = definition.id;

    final bool value = _values[id] ?? false;

    void onChanged(bool newValue) {
      if (!mounted) {
        return;
      }

      setState(() {
        _values[id] = newValue;
      });
    }

    // =========================================================================
    // WIDGET PHYSIQUE
    // =========================================================================

    final Widget toggle = definition.buildToggle(
      value: value,
      onChanged: onChanged,
    );

    // =========================================================================
    // ITEM
    // =========================================================================

    final PhysicalToggleItem item = PhysicalToggleItem(
      id: definition.id,
      title: definition.title,
      subtitle: definition.subtitle,
      icon: definition.icon,
      value: value,
      accent: definition.accent,
      child: toggle,
    );

    // =========================================================================
    // CARD
    // =========================================================================

    return PhysicalToggleCard(
      title: item.title,
      subtitle: item.subtitle,
      icon: item.icon,
      value: item.value,
      accent: item.accent,
      child: item.child,
    );
  }

  // ==========================================================================
  // RESPONSIVE — COLONNES
  // ==========================================================================

  int _calculateColumns(double width) {
    if (width >= 1100) {
      return 4;
    }

    if (width >= 760) {
      return 3;
    }

    if (width >= 480) {
      return 2;
    }

    return 1;
  }

  // ==========================================================================
  // RESPONSIVE — HAUTEUR
  // ==========================================================================

  double _calculateCardHeight({required int columns}) {
    if (columns == 1) {
      return 230;
    }

    if (columns == 2) {
      return 230;
    }

    return 220;
  }
}
