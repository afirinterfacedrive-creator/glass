import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:universal_glass/glass.dart';

class GlassDialogPreviewPage extends ConsumerStatefulWidget {
  const GlassDialogPreviewPage({super.key});

  @override
  ConsumerState<GlassDialogPreviewPage> createState() =>
      _GlassDialogPreviewPageState();
}

class _GlassDialogPreviewPageState
    extends ConsumerState<GlassDialogPreviewPage> {
  // ===========================================================================
  // DIALOGUE SIMPLE
  // ===========================================================================

  void _showBasicDialog(BuildContext dialogContext) {
    GlassDialog.show<void>(
      context: dialogContext,
      title: 'Glass Dialog',
      subtitle: 'Dialogue standard Universal Glass',
      icon: Icons.info_outline_rounded,
      content: const GlassText(
        'Ce dialogue est construit avec le composant GlassDialog '
        'du package Universal Glass.',
      ),
      actions: [
        GlassDialogAction(
          label: 'Fermer',
          onPressed: () {
            Navigator.of(dialogContext).pop();
          },
        ),
      ],
    );
  }

  // ===========================================================================
  // DIALOGUE DE CONFIRMATION
  // ===========================================================================

  void _showConfirmationDialog(BuildContext dialogContext) {
    GlassDialog.show<bool>(
      context: dialogContext,
      title: 'Confirmation',
      subtitle: 'Action nécessitant une confirmation',
      icon: Icons.warning_amber_rounded,
      content: const GlassText(
        'Voulez-vous réellement effectuer cette opération ? '
        'Cette action peut être irréversible.',
      ),
      actions: [
        GlassDialogAction(
          label: 'Annuler',
          onPressed: () {
            Navigator.of(dialogContext).pop(false);
          },
        ),
        GlassDialogAction(
          label: 'Confirmer',
          icon: const Icon(Icons.check_rounded),
          isPrimary: true,
          onPressed: () {
            Navigator.of(dialogContext).pop(true);
          },
        ),
      ],
    );
  }

  // ===========================================================================
  // DIALOGUE DESTRUCTIF
  // ===========================================================================

  void _showDestructiveDialog(BuildContext dialogContext) {
    GlassDialog.show<void>(
      context: dialogContext,
      title: 'Supprimer',
      subtitle: 'Action destructive',
      icon: Icons.delete_outline_rounded,
      content: const GlassText(
        'Cette opération supprimera définitivement les données '
        'sélectionnées.',
      ),
      actions: [
        GlassDialogAction(
          label: 'Annuler',
          onPressed: () {
            Navigator.of(dialogContext).pop();
          },
        ),
        GlassDialogAction(
          label: 'Supprimer',
          icon: const Icon(Icons.delete_outline_rounded),
          isPrimary: true,
          isDestructive: true,
          onPressed: () {
            Navigator.of(dialogContext).pop();
          },
        ),
      ],
    );
  }

  // ===========================================================================
  // DIALOGUE PERSONNALISÉ
  // ===========================================================================

  void _showCustomDialog(
    BuildContext dialogContext,
    GlassLayoutContext glass,
  ) {
    final GlassEffects effects = glass.effects.copyWith(
      blur: 20.0,
      surfaceOpacity: 0.96,
    );

    GlassDialog.show<void>(
      context: dialogContext,
      title: 'Dialog personnalisé',
      subtitle: 'GlassEffects personnalisé',
      icon: Icons.tune_rounded,
      style: glass.effectiveGlassStyle,
      effects: effects,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GlassText(
            'Personnalisation',
            fontSize: glass.fontSize(17.0),
            fontWeight: FontWeight.w600,
          ),
          SizedBox(
            height: glass.spacing(10.0),
          ),
          const GlassSubText(
            'Le dialogue reprend automatiquement le thème et la '
            'palette Universal Glass.',
          ),
        ],
      ),
      actions: [
        GlassDialogAction(
          label: 'Fermer',
          onPressed: () {
            Navigator.of(dialogContext).pop();
          },
        ),
      ],
    );
  }

  // ===========================================================================
  // BUILD
  // ===========================================================================

  @override
  Widget build(BuildContext context) {
    final GlassThemeState theme = ref.watch(
      glassThemeProvider,
    );

    return GlassScaffold(
      title: 'Glass Dialog',
      subtitle: 'DIALOG PREVIEW',
      showLogo: true,
      showBackButton: true,
      blur: theme.effectiveBlur,
      noise: theme.effectiveNoise,
      hideNavigation: true,
      maxWidth: 1200.0,

      // -----------------------------------------------------------------------
      // IMPORTANT
      //
      // Le Builder est placé sous GlassScaffold.
      // Le contexte obtenu ici est donc sous GlassLayoutScope.
      //
      // GlassDialog.show() capture ensuite ce GlassLayoutContext avant
      // de créer la nouvelle route du dialogue.
      // -----------------------------------------------------------------------

      child: Builder(
        builder: (BuildContext dialogContext) {
          final GlassLayoutContext glass =
              GlassLayoutScope.of(dialogContext);

          final bool compact =
              glass.isSmallMobile || glass.isMobile;

          final double horizontalPadding =
              compact ? 12.0 : 24.0;

          return SingleChildScrollView(
            padding: EdgeInsets.only(
              top: glass.spacing(12.0),
              bottom: glass.spacing(24.0),
              left: glass.spacing(horizontalPadding),
              right: glass.spacing(horizontalPadding),
            ),
            child: GlassSurfaceContainer(
              role: GlassSurfaceRole.card,
              style: glass.effectiveGlassStyle,
              effects: glass.effects,
              borderRadius: BorderRadius.circular(
                glass.radius(
                  glass.theme.borderRadius,
                ),
              ),
              padding: EdgeInsets.all(
                glass.spacing(
                  compact ? 14.0 : 24.0,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // =============================================================
                  // HEADER
                  // =============================================================

                  const GlassSectionHeader(
                    title: 'Glass Dialog',
                    subtitle:
                        'Testez les dialogues, actions et variantes '
                        'destructives.',
                    icon: Icons.chat_bubble_outline_rounded,
                  ),

                  SizedBox(
                    height: glass.spacing(24.0),
                  ),

                  // =============================================================
                  // GRILLE DES DIALOGUES
                  // =============================================================

                  GlassResponsiveGrid(
                    spacing: glass.spacing(20.0),
                    runSpacing: glass.spacing(20.0),
                    mobileColumns: 1,
                    tabletColumns: 2,
                    desktopColumns: 2,
                    expandItems: true,
                    children: [
                      // =========================================================
                      // DIALOGUES
                      // =========================================================

                      GlassSurfaceContainer(
                        role: GlassSurfaceRole.card,
                        style: glass.effectiveGlassStyle,
                        effects: glass.effects,
                        borderRadius: BorderRadius.circular(
                          glass.radius(
                            glass.theme.borderRadius,
                          ),
                        ),
                        padding: EdgeInsets.all(
                          glass.spacing(20.0),
                        ),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            GlassText(
                              'Dialogues',
                              fontSize:
                                  glass.fontSize(17.0),
                              fontWeight:
                                  FontWeight.w600,
                            ),

                            SizedBox(
                              height: glass.spacing(8.0),
                            ),

                            const GlassSubText(
                              'Chaque bouton ouvre une variante '
                              'différente de GlassDialog.',
                            ),

                            SizedBox(
                              height: glass.spacing(20.0),
                            ),

                            Wrap(
                              spacing:
                                  glass.spacing(12.0),
                              runSpacing:
                                  glass.spacing(12.0),
                              children: [
                                // ----------------------------------------------
                                // SIMPLE
                                // ----------------------------------------------

                                FilledButton.icon(
                                  onPressed: () {
                                    _showBasicDialog(
                                      dialogContext,
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.info_outline_rounded,
                                  ),
                                  label: const Text(
                                    'Dialogue simple',
                                  ),
                                ),

                                // ----------------------------------------------
                                // CONFIRMATION
                                // ----------------------------------------------

                                FilledButton.tonalIcon(
                                  onPressed: () {
                                    _showConfirmationDialog(
                                      dialogContext,
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.help_outline_rounded,
                                  ),
                                  label: const Text(
                                    'Confirmation',
                                  ),
                                ),

                                // ----------------------------------------------
                                // DESTRUCTIF
                                // ----------------------------------------------

                                OutlinedButton.icon(
                                  onPressed: () {
                                    _showDestructiveDialog(
                                      dialogContext,
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.delete_outline_rounded,
                                  ),
                                  label: const Text(
                                    'Destructif',
                                  ),
                                ),

                                // ----------------------------------------------
                                // PERSONNALISÉ
                                // ----------------------------------------------

                                OutlinedButton.icon(
                                  onPressed: () {
                                    _showCustomDialog(
                                      dialogContext,
                                      glass,
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.tune_rounded,
                                  ),
                                  label: const Text(
                                    'Personnalisé',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // =========================================================
                      // ACTIONS
                      // =========================================================

                      GlassSurfaceContainer(
                        role: GlassSurfaceRole.card,
                        style: glass.effectiveGlassStyle,
                        effects: glass.effects,
                        borderRadius: BorderRadius.circular(
                          glass.radius(
                            glass.theme.borderRadius,
                          ),
                        ),
                        padding: EdgeInsets.all(
                          glass.spacing(20.0),
                        ),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            GlassText(
                              'Actions',
                              fontSize:
                                  glass.fontSize(17.0),
                              fontWeight:
                                  FontWeight.w600,
                            ),

                            SizedBox(
                              height: glass.spacing(12.0),
                            ),

                            const GlassSubText(
                              'GlassDialogAction permet de gérer '
                              'les actions principales, secondaires '
                              'et destructives.',
                            ),
                          ],
                        ),
                      ),

                      // =========================================================
                      // API
                      // =========================================================

                      GlassSurfaceContainer(
                        role: GlassSurfaceRole.card,
                        style: glass.effectiveGlassStyle,
                        effects: glass.effects,
                        borderRadius: BorderRadius.circular(
                          glass.radius(
                            glass.theme.borderRadius,
                          ),
                        ),
                        padding: EdgeInsets.all(
                          glass.spacing(20.0),
                        ),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            GlassText(
                              'API utilisée',
                              fontSize:
                                  glass.fontSize(17.0),
                              fontWeight:
                                  FontWeight.w600,
                            ),

                            SizedBox(
                              height: glass.spacing(12.0),
                            ),

                            const GlassSubText(
                              'GlassDialog • '
                              'GlassDialogAction • '
                              'GlassSurfaceContainer • '
                              'GlassEffects • '
                              'GlassSectionHeader',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}