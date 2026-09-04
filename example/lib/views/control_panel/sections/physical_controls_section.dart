import 'package:flutter/material.dart';
import 'package:universal_glass/glass.dart';

import '../widgets/control_panel_section_title.dart';

// ============================================================================
// PHYSICAL CONTROLS SECTION
// ============================================================================
//
// Zone de démonstration des différents contrôles physiques.
//
// Composants :
//
// 1. BreakerSwitch
// 2. MetalToggleSwitch
// 3. RockerSwitch
// 4. RotarySwitch
// 5. PushButtonSwitch
// 6. GuardedSwitch
// 7. SliderSwitch
// 8. GlassToggleSwitch
//
// RESPONSABILITÉS
//
// - afficher les contrôles physiques
// - gérer leur état de démonstration local
// - gérer leur disposition responsive
//
// NE GÈRE PAS
//
// - Riverpod
// - modification du thème global
// - Aqua Glass
// - navigation
// - Scaffold
// - AppBar
//
// ============================================================================

class PhysicalControlsSection extends StatefulWidget {
  final GlassThemeState theme;

  const PhysicalControlsSection({super.key, required this.theme});

  @override
  State<PhysicalControlsSection> createState() =>
      _PhysicalControlsSectionState();
}

class _PhysicalControlsSectionState extends State<PhysicalControlsSection> {
  // ==========================================================================
  // ÉTATS DE DÉMONSTRATION
  // ==========================================================================

  bool _metal = false;
  bool _rocker = false;
  bool _rotary = false;
  bool _pushButton = false;
  bool _guarded = false;
  bool _slider = false;
  bool _glass = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // =====================================================================
        // TITRE
        // =====================================================================
        ControlPanelSectionTitle(
          theme: widget.theme,
          title: 'PHYSICAL CONTROLS',
          description:
              'Testez les interrupteurs et contrôles physiques '
              'de l’interface.',
        ),

        const SizedBox(height: 18),

        // =====================================================================
        // GRILLE RESPONSIVE
        // =====================================================================
        LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final double width = constraints.maxWidth;

            final bool compact = width < 600;

            final double spacing = compact ? 14 : 20;

            return Wrap(
              spacing: spacing,
              runSpacing: spacing,
              alignment: WrapAlignment.start,
              children: [
               

                // =============================================================
                // METAL
                // =============================================================
                _PhysicalControlCard(
                  title: 'Metal',
                  subtitle: 'Levier industriel',
                  child: MetalToggleSwitch(
                    value: _metal,
                    orientation: ToggleOrientation.vertical,
                    onChanged: (bool value) {
                      setState(() {
                        _metal = value;
                      });
                    },
                  ),
                ),

                // =============================================================
                // ROCKER
                // =============================================================
                _PhysicalControlCard(
                  title: 'Rocker',
                  subtitle: 'Interrupteur à bascule',
                  child: RockerSwitch(
                    value: _rocker,
                    orientation: ToggleOrientation.vertical,
                    onChanged: (bool value) {
                      setState(() {
                        _rocker = value;
                      });
                    },
                  ),
                ),

                // =============================================================
                // ROTARY
                // =============================================================
                _PhysicalControlCard(
                  title: 'Rotary',
                  subtitle: 'Sélecteur rotatif',
                  child: RotarySwitch(
                    value: _rotary,
                    orientation: ToggleOrientation.vertical,
                    onChanged: (bool value) {
                      setState(() {
                        _rotary = value;
                      });
                    },
                  ),
                ),

                // =============================================================
                // PUSH BUTTON
                // =============================================================
                _PhysicalControlCard(
                  title: 'Push Button',
                  subtitle: 'Bouton poussoir',
                  child: PushButtonSwitch(
                    value: _pushButton,
                    orientation: ToggleOrientation.vertical,
                    onChanged: (bool value) {
                      setState(() {
                        _pushButton = value;
                      });
                    },
                  ),
                ),

                // =============================================================
                // GUARDED
                // =============================================================
                _PhysicalControlCard(
                  title: 'Guarded',
                  subtitle: 'Interrupteur sécurisé',
                  child: GuardedSwitch(
                    value: _guarded,
                    orientation: ToggleOrientation.vertical,
                    onChanged: (bool value) {
                      setState(() {
                        _guarded = value;
                      });
                    },
                  ),
                ),

                // =============================================================
                // SLIDER
                // =============================================================
                _PhysicalControlCard(
                  title: 'Slider',
                  subtitle: 'Curseur mécanique',
                  child: SliderSwitch(
                    value: _slider,
                    orientation: ToggleOrientation.horizontal,
                    onChanged: (bool value) {
                      setState(() {
                        _slider = value;
                      });
                    },
                  ),
                ),

                // =============================================================
                // GLASS
                // =============================================================
                _PhysicalControlCard(
                  title: 'Glass',
                  subtitle: 'Interrupteur Glass',
                  child: GlassToggleSwitch(
                    value: _glass,
                    orientation: ToggleOrientation.horizontal,
                    onChanged: (bool value) {
                      setState(() {
                        _glass = value;
                      });
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

// ============================================================================
// PHYSICAL CONTROL CARD
// ============================================================================
//
// Carte de présentation générique.
//
// Aucune logique de toggle ici.
// ============================================================================

class _PhysicalControlCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;

  const _PhysicalControlCard({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      constraints: const BoxConstraints(minHeight: 150),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .055),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: .10)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .12),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ===================================================================
          // NOM
          // ===================================================================
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 3),

          // ===================================================================
          // DESCRIPTION
          // ===================================================================
          Text(
            subtitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 9,
              height: 1.2,
            ),
          ),

          const SizedBox(height: 14),

          // ===================================================================
          // TOGGLE
          // ===================================================================
          SizedBox(height: 82, child: Center(child: child)),
        ],
      ),
    );
  }
}
