import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:universal_glass/components/universal_glass_button.dart';
import 'package:universal_glass/enums/glass_enums.dart';
import 'package:universal_glass/provider/glass_button_provider.dart';
import 'package:universal_glass/core/layout/glass_layout_context.dart';
import 'package:universal_glass/core/layout/glass_layout_scope.dart'; // <- AJOUT

/// ============================================================================
/// UNIVERSAL GLASS BUTTON PREVIEW
/// Widget intégrable dans HomePage. Pas de Scaffold.
/// ============================================================================

class UniversalGlassHomePreview extends ConsumerWidget {
  const UniversalGlassHomePreview({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GlassLayoutContext glass = GlassLayoutScope.of(
      context,
    ); // <- RECUP CONTEXTE

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Universal Glass Button',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Test de tous les états et styles',
          style: TextStyle(
            color: glass.palette.textSecondary.withValues(alpha: 0.7),
            fontSize: 13,
          ), // <- COULEUR DU CONTEXTE
        ),
        const SizedBox(height: 24),

        // ==================================================================
        // 1. STYLES DE BASE
        // ==================================================================
        _sectionTitle(glass, 'Styles de base'),
        const SizedBox(height: 14),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            UniversalGlassButton(
              buttonId: 'btn_transparent',
              width: 150,
              height: 48,
              effects: glass.effects, // <- UTILISE CEUX DU CONTEXTE
              shape: GlassShapeType.squareRounded,
              style: GlassStyle.transparentAqua,
              label: 'Transparent',
              icon: Icons.blur_on,
              simpleOnTap: () => _toast(context, 'Transparent'),
            ),
            UniversalGlassButton(
              buttonId: 'btn_solid',
              width: 150,
              height: 48,
              effects: glass.effects,
              shape: GlassShapeType.squareRounded,
              style: GlassStyle.solidAqua,
              label: 'Solid Aqua',
              icon: Icons.water_drop,
              simpleOnTap: () => _toast(context, 'Solid'),
            ),
            UniversalGlassButton(
              buttonId: 'btn_opaque',
              width: 150,
              height: 48,
              effects: glass.effects,
              shape: GlassShapeType.squareRounded,
              style: GlassStyle.opaqueHeavy,
              label: 'Opaque',
              icon: Icons.layers,
              simpleOnTap: () => _toast(context, 'Opaque'),
            ),
            UniversalGlassButton(
              buttonId: 'btn_gradient',
              width: 150,
              height: 48,
              effects: glass.effects,
              shape: GlassShapeType.squareRounded,
              style: GlassStyle.gradientOpaque,
              label: 'Gradient',
              icon: Icons.gradient,
              iconColor: const Color(0xFFFF5252),
              simpleOnTap: () => _toast(context, 'Gradient'),
            ),
          ],
        ),
        const SizedBox(height: 28),

        // ==================================================================
        // 2. ÉTAT ACTIF
        // ==================================================================
        _sectionTitle(glass, 'État Actif / Toggle'),
        const SizedBox(height: 14),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            UniversalGlassButton(
              buttonId: 'btn_active_1',
              width: 130,
              height: 46,
              effects: glass.effects,
              shape: GlassShapeType.pillHorizontal,
              style: GlassStyle.transparentAqua,
              defaultActive: true,
              label: 'Actif',
              icon: Icons.check_circle,
              simpleOnTap: () => ref
                  .read(glassButtonProvider.notifier)
                  .toggleActive('btn_active_1'),
            ),
            UniversalGlassButton(
              buttonId: 'btn_active_2',
              width: 130,
              height: 46,
              effects: glass.effects,
              shape: GlassShapeType.pillHorizontal,
              style: GlassStyle.transparentAqua,
              label: 'Toggle',
              icon: Icons.toggle_on,
              simpleOnTap: () => ref
                  .read(glassButtonProvider.notifier)
                  .toggleActive('btn_active_2'),
            ),
          ],
        ),
        const SizedBox(height: 28),

        // ==================================================================
        // 3. LOADING
        // ==================================================================
        _sectionTitle(glass, 'Loading Asynchrone'),
        const SizedBox(height: 14),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
  UniversalGlassButton(
    buttonId: 'btn_loading_left',
    width: 170,
    height: 48,
    effects: glass.effects,
    shape: GlassShapeType.squareRounded,
    style: GlassStyle.solidAqua,
    label: 'Loading Gauche',
    icon: Icons.download,
    spinnerPosition: SpinnerPosition.left,
    iconColor: const Color(0xFF4DD0E1),
    futureOnTap: () async { // <- ENLEVE (ref)
      await Future.delayed(const Duration(seconds: 2));
      if (context.mounted) _toast(context, 'Terminé !');
    },
  ),
  UniversalGlassButton(
    buttonId: 'btn_loading_right',
    width: 170,
    height: 48,
    effects: glass.effects,
    shape: GlassShapeType.squareRounded,
    style: GlassStyle.solidAqua,
    label: 'Loading Droite',
    icon: Icons.upload,
    spinnerPosition: SpinnerPosition.right,
    iconColor: const Color(0xFFFF5252),
    futureOnTap: () async { // <- ENLEVE (ref)
      await Future.delayed(const Duration(seconds: 2));
      if (context.mounted) _toast(context, 'Upload OK');
    },
  ),
],
        ),
        const SizedBox(height: 28),

        // ==================================================================
        // 4. ICONE SEUL
        // ==================================================================
        _sectionTitle(glass, 'Icône Seul'),
        const SizedBox(height: 14),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            UniversalGlassButton(
              buttonId: 'btn_icon_1',
              height: 52,
              width: 52,
              effects: glass.effects,
              shape: GlassShapeType.circle,
              style: GlassStyle.transparentAqua,
              icon: Icons.favorite,
              iconColor: Colors.redAccent,
              simpleOnTap: () => _toast(context, 'Like'),
            ),
            UniversalGlassButton(
              buttonId: 'btn_icon_2',
              height: 52,
              width: 52,
              effects: glass.effects,
              shape: GlassShapeType.circle,
              style: GlassStyle.solidAqua,
              icon: Icons.share,
              iconColor: Colors.white,
              simpleOnTap: () => _toast(context, 'Share'),
            ),
            UniversalGlassButton(
              buttonId: 'btn_icon_3',
              height: 52,
              width: 52,
              effects: glass.effects,
              shape: GlassShapeType.circle,
              style: GlassStyle.opaqueMat,
              icon: Icons.settings,
              iconColor: Colors.white,
              simpleOnTap: () => _toast(context, 'Settings'),
            ),
          ],
        ),
        const SizedBox(height: 28),

        // ==================================================================
        // 5. DESACTIVE
        // ==================================================================
        _sectionTitle(glass, 'Désactivé'),
        const SizedBox(height: 14),
        UniversalGlassButton(
          buttonId: 'btn_disabled',
          width: 200,
          height: 48,
          effects: glass.effects,
          shape: GlassShapeType.squareRounded,
          style: GlassStyle.transparentAqua,
          enabled: false,
          label: 'Désactivé',
          icon: Icons.block,
          simpleOnTap: () {},
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _sectionTitle(GlassLayoutContext glass, String title) => Text(
    // <- AJOUT glass en param
    title,
    style: TextStyle(
      color: glass.palette.textPrimary,
      fontSize: 15,
      fontWeight: FontWeight.w700,
    ), // <- COULEUR DU CONTEXTE
  );

  void _toast(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: const Color(0xFF4DD0E1),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(milliseconds: 800),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
