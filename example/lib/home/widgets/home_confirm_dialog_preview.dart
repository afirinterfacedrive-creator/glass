import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:universal_glass/glass.dart';

/// ============================================================================
/// HOME CONFIRM DIALOG PREVIEW
/// Démo du UniversalGlassConfirmDialog avec GlassText
/// ============================================================================

class HomeConfirmDialogPreview extends ConsumerWidget {
  const HomeConfirmDialogPreview({super.key});

  void _showDeleteDialog(BuildContext context, WidgetRef ref) {
    final glass = ref.watchGlassContext(context);

    UniversalGlassConfirmDialog.show(
      context,
      style: GlassStyle.gradientOpaque, 
      effects: glass.effects.copyWith(
        surfaceOpacity: (glass.effects.surfaceOpacity + 0.2).clamp(0.0, 1.0),
        blur: glass.effects.blur > 0 ? glass.effects.blur : 20,
      ),
      barrierColor: const Color.fromARGB(255, 14, 7, 7).withValues(alpha: 0.65),
      accentColor: const Color(0xFFFF5252),
      confirmColor: const Color(0xFFFF5252),
      title: 'Supprimer l\'élément',
      message: 'Cette action est irréversible. Voulez-vous vraiment continuer ?',
      icon: Icons.warning_amber_rounded,
      iconColor: const Color(0xFFFF5252),
      confirmText: 'Supprimer',
      cancelText: 'Annuler',
      onConfirm: () async {
        await Future.delayed(const Duration(seconds: 2)); 
      },
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    final glass = ref.watchGlassContext(context);

    UniversalGlassConfirmDialog.show(
      context,
      style: glass.effectiveGlassStyle,
      effects: glass.effects.copyWith(
        surfaceOpacity: (glass.effects.surfaceOpacity + 0.15).clamp(0.0, 1.0),
        blur: glass.effects.blur > 0 ? glass.effects.blur : 20,
      ),
      barrierColor: const Color(0xFF0A0F14).withValues(alpha: 0.65),
      accentColor: glass.palette.accent,
      confirmColor: glass.palette.accent,
      title: 'Déconnexion',
      message: 'Êtes-vous sûr de vouloir vous déconnecter ?',
      icon: Icons.logout_rounded,
      confirmText: 'Se déconnecter',
      cancelText: 'Rester',
    );
  }

@override
Widget build(BuildContext context, WidgetRef ref) {
  final glass = ref.watchGlassContext(context);
  final bool isSmallMobile = glass.isSmallMobile; // <- UTILISE

  return LayoutBuilder(
    builder: (context, constraints) {
      final double maxWidth = constraints.maxWidth;
      const double spacing = 16.0;

      int crossAxisCount = 1;
      if (maxWidth >= 550) {
        crossAxisCount = 2;
      }

      final double buttonWidth = (maxWidth - (spacing * (crossAxisCount - 1))) / crossAxisCount;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GlassSectionHeader(
            title: 'Confirm Dialog',
            subtitle: 'Dialog de confirmation Glass avec loading',
            icon: Icons.verified_user_rounded,
          ),
          const SizedBox(height: 18),
          
          Wrap(
            spacing: spacing,
            runSpacing: 12,
            children: [
              SizedBox(
                width: buttonWidth,
                child: GlassSurfaceContainer(
                  style: glass.effectiveGlassStyle,
                  effects: glass.effects,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => _showDeleteDialog(context, ref),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.delete_outline_rounded, size: isSmallMobile ? 16 : 18, color: Colors.redAccent), // <- UTILISE
                      const SizedBox(width: 7),
                      GlassText(
                        'Supprimer', 
                        fontSize: isSmallMobile ? 11 : 12, // <- UTILISE
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  ),
                ),
              ),
              
              SizedBox(
                width: buttonWidth,
                child: GlassSurfaceContainer(
                  style: glass.effectiveGlassStyle,
                  effects: glass.effects,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => _showLogoutDialog(context, ref),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.logout_rounded, size: isSmallMobile ? 16 : 18, color: glass.palette.textPrimary), // <- UTILISE
                      const SizedBox(width: 7),
                      GlassText(
                        'Déconnexion', 
                        fontSize: isSmallMobile ? 11 : 12, // <- UTILISE
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    },
  );
}
}