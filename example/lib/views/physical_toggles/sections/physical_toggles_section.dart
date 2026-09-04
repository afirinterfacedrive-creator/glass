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
// ControlPanelSection
// │
// ├── GlassThemeState
// │
// └── GlassColorPalette
// │
// ▼
// PhysicalTogglesSection
// │
// ▼
// PhysicalToggleRegistry
// │
// ▼
// PhysicalToggleDefinition
// │
// │ buildToggle()
// ▼
// PhysicalToggleItem
// │
// ▼
// PhysicalToggleCard
// │
// ├── palette
// │
// ▼
// PhysicalToggleShell
// │
// ▼
// Composant Glass
//
// ============================================================================
//
// RESPONSABILITÉS
//
// - recevoir le thème Glass
// - recevoir la palette Glass
// - gérer l'état local des contrôles
// - récupérer les définitions depuis le Registry
// - construire les PhysicalToggleItem
// - transmettre la palette aux PhysicalToggleCard
// - gérer uniquement la disposition générale
//
// ============================================================================
//
// NE GÈRE PAS
//
// - Riverpod
// - navigation
// - GlassScaffold
// - AppBar
// - création de la palette
// - création des effets Glass
// - définition des contrôles
// - logique interne des contrôles physiques
//
// ============================================================================

class PhysicalTogglesSection extends StatefulWidget {
  // ==========================================================================
  // THÈME
  // ==========================================================================
  final GlassThemeState theme;

  // ==========================================================================
  // PALETTE
  // ==========================================================================
  //
  // La palette est créée par la couche supérieure puis injectée ici.
  //
  // PhysicalTogglesSection ne connaît pas Riverpod et ne crée pas la palette.
  //
  // ==========================================================================
  final GlassColorPalette palette;

  // ==========================================================================
  // CONSTRUCTEUR
  // ==========================================================================
  const PhysicalTogglesSection({
    super.key,
    required this.theme,
    required this.palette,
  });

  @override
  State<PhysicalTogglesSection> createState() => _PhysicalTogglesSectionState();
}

// ============================================================================
// STATE
// ============================================================================

class _PhysicalTogglesSectionState extends State<PhysicalTogglesSection> {
  // ==========================================================================
  // ÉTATS DES CONTRÔLES
  // ==========================================================================
  late final Map<String, bool> _values;

  // ==========================================================================
  // INITIALISATION
  // ==========================================================================
  @override
  void initState() {
    super.initState();
    _values = {
      // ----------------------------------------------------------------------
      // BREAKER
      // ----------------------------------------------------------------------
      PhysicalToggleRegistry.breakerId: true,
      // ----------------------------------------------------------------------
      // METAL
      // ----------------------------------------------------------------------
      PhysicalToggleRegistry.metalId: false,
      // ----------------------------------------------------------------------
      // ROCKER
      // ----------------------------------------------------------------------
      PhysicalToggleRegistry.rockerId: true,
      // ----------------------------------------------------------------------
      // ROTARY
      // ----------------------------------------------------------------------
      PhysicalToggleRegistry.rotaryId: false,
      // ----------------------------------------------------------------------
      // PUSH BUTTON
      // ----------------------------------------------------------------------
      PhysicalToggleRegistry.pushButtonId: false,
      // ----------------------------------------------------------------------
      // GUARDED
      // ----------------------------------------------------------------------
      PhysicalToggleRegistry.guardedId: true,
      // ----------------------------------------------------------------------
      // SLIDER
      // ----------------------------------------------------------------------
      PhysicalToggleRegistry.sliderId: false,
      // ----------------------------------------------------------------------
      // GLASS
      // ----------------------------------------------------------------------
      PhysicalToggleRegistry.glassId: true,
    };
    _synchronizeValuesWithRegistry();
  }

  // ==========================================================================
  // SYNCHRONISATION
  // ==========================================================================
  //
  // Si un nouveau contrôle est ajouté au Registry sans être ajouté
  // manuellement à _values, il reçoit automatiquement false.
  //
  // ==========================================================================
  void _synchronizeValuesWithRegistry() {
    for (final PhysicalToggleDefinition definition in PhysicalToggleRegistry.definitions) {
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

        // ====================================================================
        // RESPONSIVE
        // ====================================================================
        final int columns = _calculateColumns(width);
        final double cardHeight = _calculateCardHeight(columns: columns);

        // ====================================================================
        // REGISTRY
        // ====================================================================
        final List<PhysicalToggleDefinition> definitions = PhysicalToggleRegistry.definitions;

        // ====================================================================
        // CONTENU
        // ====================================================================
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ==================================================================
            // TITRE
            // ==================================================================
            ControlPanelSectionTitle(
              theme: widget.theme,
              title: 'PHYSICAL CONTROLS',
              description: 'Testez les interrupteurs et contrôles physiques de l’interface.',
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
    // ==========================================================================
    // ID
    // ==========================================================================
    final String id = definition.id;

    // ==========================================================================
    // VALEUR COURANTE
    // ==========================================================================
    final bool value = _values[id]?? false;

    // ==========================================================================
    // CALLBACK
    // ==========================================================================
    void onChanged(bool newValue) {
      if (!mounted) return;
      setState(() {
        _values[id] = newValue;
      });
    }

    // ==========================================================================
    // WIDGET PHYSIQUE
    // ==========================================================================
    //
    // La définition connaît uniquement la façon de construire le contrôle.
    //
    // Elle ne connaît pas l'état global.
    //
    // ==========================================================================
    final Widget toggle = definition.buildToggle(value: value, onChanged: onChanged);

    // ==========================================================================
    // ITEM
    // ==========================================================================
    final PhysicalToggleItem item = PhysicalToggleItem(
      id: definition.id,
      title: definition.title,
      subtitle: definition.subtitle,
      icon: definition.icon,
      value: value,
      accent: definition.accent,
      child: toggle,
    );

    // ==========================================================================
    // CARD
    // ==========================================================================
    //
    // IMPORTANT :
    //
    // La palette est transmise ici.
    //
    // C'est précisément ce qui corrige :
    //
    // "The named parameter 'palette' is required,
    // but there's no corresponding argument."
    //
    // ==========================================================================
    return PhysicalToggleCard(
      title: item.title,
      subtitle: item.subtitle,
      icon: item.icon,
      value: item.value,
      accent: item.accent,
      // ----------------------------------------------------------------------
      // PALETTE GLASS
      // ----------------------------------------------------------------------
      palette: widget.palette,
      // ----------------------------------------------------------------------
      // CONTRÔLE PHYSIQUE
      // ----------------------------------------------------------------------
      child: item.child,
    );
  }

  // ==========================================================================
  // RESPONSIVE — COLONNES
  // ==========================================================================
  int _calculateColumns(double width) {
    if (width >= 1100) return 4;
    if (width >= 760) return 3;
    if (width >= 480) return 2;
    return 1;
  }

  // ==========================================================================
  // RESPONSIVE — HAUTEUR
  // ==========================================================================
  double _calculateCardHeight({required int columns}) {
    if (columns == 1) return 230;
    if (columns == 2) return 230;
    return 220;
  }
}