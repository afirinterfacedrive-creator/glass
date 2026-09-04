import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:universal_glass/glass.dart';


class HomeModalPreview extends ConsumerWidget {
  const HomeModalPreview({super.key});

  // ==========================================================================
  // MODAL DE CONFIGURATION DE PROFIL
  // ==========================================================================
  void _openProfileFormModal(BuildContext context, WidgetRef ref) {
    final glass = ref.watchGlassContext(context);
    
    final TextEditingController bioController = TextEditingController();
    final FocusNode bioFocusNode = FocusNode();

    UniversalGlassModal.show(
      context: context,
      title: 'Mon Profil',
      subtitle: 'Modifiez vos données. Le modal s\'adapte au clavier.',
      maxWidth: 650, 
      style: glass.effectiveGlassStyle,
      effects: glass.effects,
      actions: [
        _modalButton(glass, 'Annuler', isPrimary: false, onTap: () {
          bioController.dispose();
          bioFocusNode.dispose();
          Navigator.pop(context);
        }),
        _modalButton(glass, 'Enregistrer', isPrimary: true, onTap: () {
          bioController.dispose();
          bioFocusNode.dispose();
          Navigator.pop(context);
          
          UniversalGlassToast.show(
            context,
            title: 'Profil mis à jour',
            message: 'Les modifications de votre profil ont été enregistrées avec succès.',
            type: GlassToastType.success,
          );
        }),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 8),
          GlassResponsiveGrid(
            spacing: 12,
            runSpacing: 12,
            mobileColumns: 1,
            tabletColumns: 2,
            desktopColumns: 2, 
            children: [
              UniversalGlassNameInput(
                hintText: 'Prénom',
                textInputAction: TextInputAction.next,
              ),
              UniversalGlassNameInput(
                hintText: 'Nom de famille',
                textInputAction: TextInputAction.next,
              ),
            ],
          ),
          const SizedBox(height: 12),
          UniversalGlassTextFieldOutlined( // <- REMPLACE ICI
            controller: bioController,
            focusNode: bioFocusNode,
            label: 'Biographie',
            hintText: 'Racontez-nous quelque chose...',
            prefixIcon: Icons.article_outlined,
            keyboardType: TextInputType.multiline, 
            textInputAction: TextInputAction.done,
            fieldHeight: glass.isSmallMobile ? 52 : 58, // <- optionnel mais cohérent
            textCase: GlassTextCase.normal,
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // MODAL DE SÉLECTION / LISTE DE CONTENU
  // ==========================================================================
  void _openSettingsListModal(BuildContext context, WidgetRef ref) {
    final glass = ref.watchGlassContext(context);
    
    UniversalGlassModal.show(
      context: context,
      title: 'Réglages Avancés',
      subtitle: 'Contenu scrollable à l\'aide du moteur physique de défilement.',
      style: GlassStyle.opaqueHeavy, 
      effects: glass.effects,
      maxWidth: 480,
      maxHeight: 500, 
      actions: [
        _modalButton(glass, 'Fermer', isPrimary: true, onTap: () => Navigator.pop(context)),
      ],
      child: Column(
        children: [
          for (int i = 1; i <= 8; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: GlassContainer(
                style: GlassStyle.ghost,
                effects: glass.effects,
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle_outline_rounded, 
                      color: glass.theme.useAquaStyle ? Colors.cyanAccent : Colors.orangeAccent,
                      size: 18
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Option de configuration numéro $i',
                        style: TextStyle(color: glass.palette.textPrimary, fontSize: 13),
                      ),
                    ),
                    Icon(Icons.chevron_right_rounded, color: glass.palette.textSecondary.withValues(alpha: 0.5), size: 16),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ==========================================================================
  // FONCTION DE TEST RAPIDE DU TOAST SYSTÈME
  // ==========================================================================
  void _triggerQuickToast(BuildContext context) {
    UniversalGlassToast.show(
      context,
      title: 'Glass Notification',
      message: 'Moteur de rendu graphique synchronisé avec succès.',
      type: GlassToastType.info,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final glass = ref.watchGlassContext(context);
    final bool isSmallMobile = glass.isSmallMobile;

    return GlassSurfaceContainer(
      style: glass.effectiveGlassStyle,
      effects: glass.effects,
      borderRadius: BorderRadius.circular(isSmallMobile ? 14 : 20),
      padding: EdgeInsets.all(isSmallMobile ? 12 : 18),
      liftOnHover: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Modals & Overlays',
            style: TextStyle(
              color: glass.palette.textPrimary,
              fontSize: isSmallMobile ? 16 : 18,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Fenêtres modales fluides et toasts système synchronisés au thème',
            style: TextStyle(color: glass.palette.textSecondary.withValues(alpha: 0.7), fontSize: isSmallMobile ? 11 : 13),
          ),

          SizedBox(height: isSmallMobile ? 16 : 24),

          GlassResponsiveGrid(
            spacing: 14,
            runSpacing: 12,
            mobileColumns: 1,
            tabletColumns: 2,
            desktopColumns: 3,
            tabletBreakpoint: 500,
            desktopBreakpoint: 950,
            children: [
              _buildTriggerButton(
                glass,
                icon: Icons.assignment_ind_outlined,
                label: 'Ouvrir Formulaire',
                onTap: () => _openProfileFormModal(context, ref),
              ),
              _buildTriggerButton(
                glass,
                icon: Icons.layers_outlined,
                label: 'Ouvrir Liste Scroll',
                onTap: () => _openSettingsListModal(context, ref),
              ),
              _buildTriggerButton(
                glass,
                icon: Icons.notification_important_outlined,
                label: 'Tester le Toast',
                onTap: () => _triggerQuickToast(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTriggerButton(GlassLayoutContext glass, {required IconData icon, required String label, required VoidCallback onTap}) {
    return GlassSurfaceContainer(
      style: glass.effectiveGlassStyle,
      effects: glass.effects,
      padding: const EdgeInsets.symmetric(vertical: 14),
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18, color: glass.palette.textPrimary),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: glass.palette.textPrimary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _modalButton(GlassLayoutContext glass, String text, {required bool isPrimary, required VoidCallback onTap}) {
    final bool useAqua = glass.theme.useAquaStyle;
    final Color primaryColor = useAqua ? Colors.cyanAccent : Colors.orangeAccent;
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isPrimary ? primaryColor.withValues(alpha: 0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: isPrimary ? primaryColor.withValues(alpha: 0.3) : Colors.transparent),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isPrimary ? primaryColor : glass.palette.textSecondary,
            fontSize: 13,
            fontWeight: isPrimary ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}