import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:universal_glass/glass.dart';

class GlassFormPreviewPage extends ConsumerStatefulWidget {
  const GlassFormPreviewPage({super.key});

  @override
  ConsumerState<GlassFormPreviewPage> createState() =>
      _GlassFormPreviewPageState();
}

class _GlassFormPreviewPageState
    extends ConsumerState<GlassFormPreviewPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  bool _notifications = true;
  bool _marketing = false;
  bool _advancedMode = false;
  bool _submitted = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // FORM LOGIC
  // ---------------------------------------------------------------------------

  void _submitForm() {
    FocusScope.of(context).unfocus();

    final FormState? form = _formKey.currentState;
    if (form == null) return;

    final bool isValid = form.validate();

    if (!isValid) {
      setState(() {
        _submitted = false;
      });
      return;
    }

    setState(() {
      _submitted = true;
    });
  }

  void _resetForm() {
    FocusScope.of(context).unfocus();

    _formKey.currentState?.reset();

    _nameController.clear();
    _emailController.clear();
    _phoneController.clear();
    _messageController.clear();

    setState(() {
      _notifications = true;
      _marketing = false;
      _advancedMode = false;
      _submitted = false;
    });
  }

  void _handleFormChanged() {
    if (!_submitted) return;

    setState(() {
      _submitted = false;
    });
  }

  // ---------------------------------------------------------------------------
  // VALIDATORS
  // ---------------------------------------------------------------------------

  String? _validateName(String? value) {
    final String name = value?.trim() ?? '';

    if (name.isEmpty) {
      return 'Veuillez saisir votre nom.';
    }

    if (name.length < 2) {
      return 'Le nom doit contenir au moins 2 caractères.';
    }

    return null;
  }

  String? _validateEmail(String? value) {
    final String email = value?.trim() ?? '';

    if (email.isEmpty) {
      return 'Veuillez saisir votre e-mail.';
    }

    final bool valid =
        RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email);

    if (!valid) {
      return 'Adresse e-mail invalide.';
    }

    return null;
  }

  String? _validatePhone(String? value) {
    final String phone = value?.trim() ?? '';

    if (phone.isEmpty) {
      return 'Veuillez saisir votre numéro.';
    }

    return null;
  }

  String? _validateMessage(String? value) {
    final String message = value?.trim() ?? '';

    if (message.isEmpty) {
      return 'Veuillez saisir un message.';
    }

    return null;
  }

  // ---------------------------------------------------------------------------
  // SUCCESS CARD
  // ---------------------------------------------------------------------------

  Widget _buildSuccessCard(GlassLayoutContext glass) {
    return GlassSurfaceContainer(
      role: GlassSurfaceRole.card,
      style: glass.effectiveGlassStyle,
      effects: glass.effects,
      borderRadius: BorderRadius.circular(
        glass.radius(glass.theme.borderRadius),
      ),
      padding: EdgeInsets.all(
        glass.spacing(18.0),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle_outline_rounded,
            color: glass.focusColor,
            size: glass.size(24.0),
          ),
          SizedBox(
            width: glass.spacing(12.0),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GlassText(
                  'Formulaire valide',
                  fontSize: glass.fontSize(16.0),
                  fontWeight: FontWeight.w600,
                ),
                SizedBox(
                  height: glass.spacing(4.0),
                ),
                const GlassSubText(
                  'Toutes les informations obligatoires '
                  'ont été correctement saisies.',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // COMPONENTS CARD
  // ---------------------------------------------------------------------------

  Widget _buildComponentsCard(GlassLayoutContext glass) {
    return GlassSurfaceContainer(
      role: GlassSurfaceRole.card,
      style: glass.effectiveGlassStyle,
      effects: glass.effects,
      borderRadius: BorderRadius.circular(
        glass.radius(glass.theme.borderRadius),
      ),
      padding: EdgeInsets.all(
        glass.spacing(20.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GlassText(
            'Composants utilisés',
            fontSize: glass.fontSize(17.0),
            fontWeight: FontWeight.w600,
          ),
          SizedBox(
            height: glass.spacing(12.0),
          ),
          const GlassSubText(
            'GlassForm • '
            'GlassFormSection • '
            'GlassFormActions • '
            'GlassPreviewSwitch • '
            'GlassPreviewBreaker • '
            'GlassSurfaceContainer',
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // BUILD
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final GlassThemeState theme = ref.watch(glassThemeProvider);

    return GlassScaffold(
      title: 'Glass Form',
      subtitle: 'FORM PREVIEW',
      showLogo: true,
      showBackButton: true,
      blur: theme.effectiveBlur,
      noise: theme.effectiveNoise,
      hideNavigation: true,
      maxWidth: 1200.0,
      child: Builder(
        builder: (BuildContext context) {
          final GlassLayoutContext glass =
              GlassLayoutScope.of(context);

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
                glass.radius(glass.theme.borderRadius),
              ),
              padding: EdgeInsets.all(
                glass.spacing(compact ? 14.0 : 24.0),
              ),
              child: GlassForm(
                formKey: _formKey,
                onChanged: _handleFormChanged,
                children: [
                  // -----------------------------------------------------------
                  // HEADER
                  // -----------------------------------------------------------

                  const GlassSectionHeader(
                    title: 'Glass Form',
                    subtitle:
                        'Exemple complet avec sections, champs, switches '
                        'et actions.',
                    icon: Icons.assignment_outlined,
                  ),

                  SizedBox(
                    height: glass.spacing(24.0),
                  ),

                  // -----------------------------------------------------------
                  // FORM GRID
                  // -----------------------------------------------------------

                  GlassResponsiveGrid(
                    spacing: glass.spacing(20.0),
                    runSpacing: glass.spacing(20.0),
                    mobileColumns: 1,
                    tabletColumns: 2,
                    desktopColumns: 2,
                    expandItems: true,
                    children: [
                      // -------------------------------------------------------
                      // PERSONAL INFORMATION
                      // -------------------------------------------------------

                      GlassFormSection(
                        title: 'Informations personnelles',
                        subtitle:
                            'Informations principales du profil',
                        icon: Icons.person_outline_rounded,
                        children: [
                          TextFormField(
                            controller: _nameController,
                            keyboardType: TextInputType.name,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              labelText: 'Nom complet',
                              hintText: 'Ex. Abdoulaye Kone',
                              prefixIcon: Icon(
                                Icons.person_outline_rounded,
                              ),
                            ),
                            validator: _validateName,
                          ),
                          TextFormField(
                            controller: _emailController,
                            keyboardType:
                                TextInputType.emailAddress,
                            textInputAction:
                                TextInputAction.next,
                            decoration: const InputDecoration(
                              labelText: 'Adresse e-mail',
                              hintText: 'exemple@email.com',
                              prefixIcon: Icon(
                                Icons.email_outlined,
                              ),
                            ),
                            validator: _validateEmail,
                          ),
                          TextFormField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            textInputAction:
                                TextInputAction.next,
                            decoration: const InputDecoration(
                              labelText: 'Téléphone',
                              hintText: '+226 XX XX XX XX',
                              prefixIcon: Icon(
                                Icons.phone_outlined,
                              ),
                            ),
                            validator: _validatePhone,
                          ),
                        ],
                      ),

                      // -------------------------------------------------------
                      // PREFERENCES
                      // -------------------------------------------------------

                      GlassFormSection(
                        title: 'Préférences',
                        subtitle:
                            'Configurez les notifications du profil',
                        icon: Icons.tune_rounded,
                        children: [
                          GlassPreviewSwitch(
                            label: 'Notifications',
                            subtitle:
                                'Recevoir les notifications importantes',
                            value: _notifications,
                            onChanged: (value) {
                              setState(() {
                                _notifications = value;
                              });
                            },
                            icon: Icons.notifications_outlined,
                          ),
                          GlassPreviewSwitch(
                            label: 'Communications marketing',
                            subtitle:
                                'Recevoir les nouveautés et offres',
                            value: _marketing,
                            onChanged: (value) {
                              setState(() {
                                _marketing = value;
                              });
                            },
                            icon: Icons.campaign_outlined,
                          ),
                        ],
                      ),

                      // -------------------------------------------------------
                      // GLASS CONTROL
                      // -------------------------------------------------------

                      GlassFormSection(
                        title: 'Contrôle Glass',
                        subtitle:
                            'Prévisualisation du composant breaker '
                            'du package',
                        icon: Icons.toggle_on_outlined,
                        children: [
                          GlassPreviewBreaker(
                            label: 'Mode avancé',
                            subtitle:
                                'Active une configuration avancée',
                            value: _advancedMode,
                            onChanged: (value) {
                              setState(() {
                                _advancedMode = value;
                              });
                            },
                            icon:
                                Icons.settings_suggest_outlined,
                          ),
                        ],
                      ),

                      // -------------------------------------------------------
                      // MESSAGE
                      // -------------------------------------------------------

                      GlassFormSection(
                        title: 'Message',
                        subtitle:
                            'Informations complémentaires',
                        icon: Icons.message_outlined,
                        children: [
                          TextFormField(
                            controller: _messageController,
                            minLines: 4,
                            maxLines: 7,
                            keyboardType:
                                TextInputType.multiline,
                            textInputAction:
                                TextInputAction.newline,
                            decoration: const InputDecoration(
                              labelText: 'Message',
                              hintText: 'Votre message...',
                              alignLabelWithHint: true,
                              prefixIcon: Padding(
                                padding: EdgeInsets.only(
                                  bottom: 70,
                                ),
                                child: Icon(
                                  Icons.message_outlined,
                                ),
                              ),
                            ),
                            validator: _validateMessage,
                          ),
                        ],
                      ),
                    ],
                  ),

                  // -----------------------------------------------------------
                  // ACTIONS
                  // -----------------------------------------------------------

                  SizedBox(
                    height: glass.spacing(24.0),
                  ),

                  GlassFormActions(
                    alignment: MainAxisAlignment.end,
                    spacing: glass.spacing(12.0),
                    runSpacing: glass.spacing(12.0),
                    children: [
                      OutlinedButton.icon(
                        onPressed: _resetForm,
                        icon: const Icon(
                          Icons.refresh_rounded,
                        ),
                        label: const Text(
                          'Réinitialiser',
                        ),
                      ),
                      FilledButton.icon(
                        onPressed: _submitForm,
                        icon: const Icon(
                          Icons.check_rounded,
                        ),
                        label: const Text(
                          'Valider',
                        ),
                      ),
                    ],
                  ),

                  // -----------------------------------------------------------
                  // SUCCESS
                  // -----------------------------------------------------------

                  if (_submitted) ...[
                    SizedBox(
                      height: glass.spacing(20.0),
                    ),
                    _buildSuccessCard(glass),
                  ],

                  // -----------------------------------------------------------
                  // COMPONENTS
                  // -----------------------------------------------------------

                  SizedBox(
                    height: glass.spacing(24.0),
                  ),

                  _buildComponentsCard(glass),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}