import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:universal_glass/glass.dart';

class GlassModalPreviewPage extends ConsumerStatefulWidget {
  const GlassModalPreviewPage({super.key});

  @override
  ConsumerState<GlassModalPreviewPage> createState() =>
      _GlassModalPreviewPageState();
}

class _GlassModalPreviewPageState
    extends ConsumerState<GlassModalPreviewPage> {
  bool _showCloseButton = true;
  bool _barrierDismissible = true;

  // ===========================================================================
  // MODAL SIMPLE
  // ===========================================================================

  void _showBasicModal(BuildContext modalContext) {
    GlassModal.show<void>(
      context: modalContext,
      title: 'Modal Glass',
      subtitle: 'Exemple de fenêtre modale Universal Glass',
      leading: const Icon(
        Icons.layers_rounded,
      ),
      showCloseButton: _showCloseButton,
      barrierDismissible: _barrierDismissible,
      child: const Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GlassText(
              'Bienvenue dans Universal Glass.',
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
            SizedBox(height: 12),
            GlassSubText(
              'Cette fenêtre utilise directement le système de surface '
              'et les effets du thème courant.',
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // MODAL FORMULAIRE
  // ===========================================================================

  void _showFormModal(BuildContext modalContext) {
    GlassModal.show<void>(
      context: modalContext,
      title: 'Modifier le profil',
      subtitle: 'Exemple de contenu interactif',
      leading: const Icon(
        Icons.person_outline_rounded,
      ),
      showCloseButton: true,
      barrierDismissible: true,
      child: const _ModalFormContent(),
    );
  }

  // ===========================================================================
  // MODAL AVEC EFFETS PERSONNALISÉS
  // ===========================================================================

  void _showCustomEffectsModal(
    BuildContext modalContext,
    GlassLayoutContext glass,
  ) {
    final GlassEffects effects = glass.effects.copyWith(
      blur: 18.0,
      surfaceOpacity: 0.96,
    );

    GlassModal.show<void>(
      context: modalContext,
      title: 'Effets personnalisés',
      subtitle: 'Modal avec GlassEffects personnalisé',
      leading: const Icon(
        Icons.auto_awesome_rounded,
      ),
      effects: effects,
      style: glass.effectiveGlassStyle,
      showCloseButton: true,
      barrierDismissible: true,
      child: const Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GlassText(
              'GlassEffects',
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
            SizedBox(height: 8),
            GlassSubText(
              'Le blur, la transparence et les autres effets '
              'proviennent du système Universal Glass.',
            ),
          ],
        ),
      ),
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
      title: 'Glass Modal',
      subtitle: 'MODAL PREVIEW',
      showLogo: true,
      showBackButton: true,
      blur: theme.effectiveBlur,
      noise: theme.effectiveNoise,
      hideNavigation: true,

      // -----------------------------------------------------------------------
      // IMPORTANT
      //
      // Le Builder est placé sous GlassScaffold.
      // Le contexte fourni ici se trouve donc sous GlassLayoutScope.
      //
      // GlassModal.show() capture ce GlassLayoutContext avant de créer
      // la nouvelle route du modal.
      // -----------------------------------------------------------------------

      child: Builder(
        builder: (BuildContext modalContext) {
          final GlassLayoutContext glass =
              GlassLayoutScope.of(modalContext);

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
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                // =================================================================
                // HEADER
                // =================================================================

                const GlassSectionHeader(
                  title: 'Glass Modal',
                  subtitle:
                      'Testez les différentes variantes de fenêtres modales.',
                  icon: Icons.layers_rounded,
                ),

                SizedBox(
                  height: glass.spacing(24.0),
                ),

                // =================================================================
                // CONFIGURATION
                // =================================================================

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
                        'Configuration',
                        fontSize:
                            glass.fontSize(17.0),
                        fontWeight:
                            FontWeight.w600,
                      ),

                      SizedBox(
                        height: glass.spacing(16.0),
                      ),

                      // -----------------------------------------------------------
                      // BOUTON FERMER
                      // -----------------------------------------------------------

                      GlassPreviewSwitch(
                        label:
                            'Afficher le bouton fermer',
                        subtitle:
                            'Affiche le bouton de fermeture dans la fenêtre.',
                        value: _showCloseButton,
                        onChanged: (value) {
                          setState(() {
                            _showCloseButton = value;
                          });
                        },
                        icon: Icons.close_rounded,
                      ),

                      SizedBox(
                        height: glass.spacing(12.0),
                      ),

                      // -----------------------------------------------------------
                      // BARRIÈRE
                      // -----------------------------------------------------------

                      GlassPreviewSwitch(
                        label:
                            'Fermeture en cliquant à l’extérieur',
                        subtitle:
                            'Autorise la fermeture en cliquant hors du modal.',
                        value: _barrierDismissible,
                        onChanged: (value) {
                          setState(() {
                            _barrierDismissible = value;
                          });
                        },
                        icon: Icons.touch_app_rounded,
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  height: glass.spacing(24.0),
                ),

                // =================================================================
                // PRÉVISUALISATIONS
                // =================================================================

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
                        'Prévisualisations',
                        fontSize:
                            glass.fontSize(17.0),
                        fontWeight:
                            FontWeight.w600,
                      ),

                      SizedBox(
                        height: glass.spacing(16.0),
                      ),

                      Wrap(
                        spacing: glass.spacing(12.0),
                        runSpacing: glass.spacing(12.0),
                        children: [
                          // -------------------------------------------------------
                          // MODAL SIMPLE
                          // -------------------------------------------------------

                          FilledButton.icon(
                            onPressed: () {
                              _showBasicModal(
                                modalContext,
                              );
                            },
                            icon: const Icon(
                              Icons.open_in_new_rounded,
                            ),
                            label: const Text(
                              'Modal simple',
                            ),
                          ),

                          // -------------------------------------------------------
                          // MODAL FORMULAIRE
                          // -------------------------------------------------------

                          FilledButton.tonalIcon(
                            onPressed: () {
                              _showFormModal(
                                modalContext,
                              );
                            },
                            icon: const Icon(
                              Icons.edit_rounded,
                            ),
                            label: const Text(
                              'Modal formulaire',
                            ),
                          ),

                          // -------------------------------------------------------
                          // EFFETS PERSONNALISÉS
                          // -------------------------------------------------------

                          OutlinedButton.icon(
                            onPressed: () {
                              _showCustomEffectsModal(
                                modalContext,
                                glass,
                              );
                            },
                            icon: const Icon(
                              Icons.auto_awesome_rounded,
                            ),
                            label: const Text(
                              'Effets personnalisés',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  height: glass.spacing(24.0),
                ),

                // =================================================================
                // COMPOSANTS UTILISÉS
                // =================================================================

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
                        'Composants utilisés',
                        fontSize:
                            glass.fontSize(17.0),
                        fontWeight:
                            FontWeight.w600,
                      ),

                      SizedBox(
                        height: glass.spacing(12.0),
                      ),

                      const GlassSubText(
                        'GlassModal • '
                        'GlassSurfaceContainer • '
                        'GlassText • '
                        'GlassSubText • '
                        'GlassFormActions • '
                        'GlassEffects • '
                        'GlassPreviewSwitch',
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  height: glass.spacing(24.0),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// =============================================================================
// CONTENU DU FORMULAIRE DU MODAL
// =============================================================================
//
// Le controller appartient à ce State et est donc correctement détruit,
// même si le modal est fermé avec le bouton X ou en cliquant à l'extérieur.
// =============================================================================

class _ModalFormContent extends StatefulWidget {
  const _ModalFormContent();

  @override
  State<_ModalFormContent> createState() =>
      _ModalFormContentState();
}

class _ModalFormContentState
    extends State<_ModalFormContent> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  void _cancel() {
    FocusScope.of(context).unfocus();

    Navigator.of(context).pop();
  }

  void _save() {
    final String value =
        _controller.text.trim();

    if (value.isEmpty) {
      return;
    }

    FocusScope.of(context).unfocus();

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment:
          CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _controller,
          textInputAction:
              TextInputAction.done,
          decoration: const InputDecoration(
            labelText: 'Nom',
            hintText: 'Votre nom',
          ),
          onSubmitted: (_) => _save(),
        ),

        const SizedBox(height: 20),

        GlassFormActions(
          alignment: MainAxisAlignment.end,
          spacing: 12,
          runSpacing: 12,
          children: [
            TextButton(
              onPressed: _cancel,
              child: const Text('Annuler'),
            ),
            FilledButton.icon(
              onPressed: _save,
              icon: const Icon(
                Icons.check_rounded,
              ),
              label: const Text(
                'Enregistrer',
              ),
            ),
          ],
        ),
      ],
    );
  }
}