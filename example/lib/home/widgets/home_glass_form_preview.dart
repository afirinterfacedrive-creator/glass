import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:universal_glass/glass.dart';

class HomeGlassFormPreview extends ConsumerStatefulWidget {
  const HomeGlassFormPreview({super.key});

  @override
  ConsumerState<HomeGlassFormPreview> createState() =>
      _HomeGlassFormPreviewState();
}

class _HomeGlassFormPreviewState
    extends ConsumerState<HomeGlassFormPreview> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _searchController;

  final TextEditingController _passwordController = TextEditingController();

   late  final FocusNode _passwordFocus;

  late final FocusNode _nameFocusNode;
  late final FocusNode _emailFocusNode;
  late final FocusNode _searchFocusNode;
String? _selectedCountryName;
DateTime? _selectedBirthDate;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _searchController = TextEditingController();
    _nameFocusNode = FocusNode();
    _emailFocusNode = FocusNode();
    _searchFocusNode = FocusNode();
    _passwordFocus = FocusNode();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _searchController.dispose();
    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _searchFocusNode.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _nameController.clear();
    _emailController.clear();
    _searchController.clear();
     //_passwordFocus.;
    FocusScope.of(context).unfocus();
    setState(() {});
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      _handleValidSubmit();
    } else {
      _handleInvalidSubmit();
    }
  }

  void _handleValidSubmit() => setState(() {});
  void _handleInvalidSubmit() => setState(() {});
  String? _validateName(String? value) => (value == null || value.trim().isEmpty) ? 'Nom requis' : null;
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email requis';
    final emailRegex = RegExp(r'^[\w\.-]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(value) ? null : 'Email invalide';
  }

     @override
  Widget build(BuildContext context) {
    final glass = ref.watchGlassContext(context);
    
    // Extraction de focusColor depuis le contexte du thème pour alimenter l'AutoComplete
    final bool useAqua = glass.theme.useAquaStyle;
    final Color focusColor = useAqua ? Colors.cyanAccent : Colors.orangeAccent;

    return GlassSurfaceContainer(
      style: glass.effectiveGlassStyle, 
      effects: glass.effects,           
      borderRadius: BorderRadius.circular(glass.isSmallMobile ? 14 : 20), 
      padding: glass.dynamicPadding,
      liftOnHover: true, 

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GlassSectionHeader(
            title: 'Glass Form',
            subtitle: 'Style: ${glass.theme.glassStyle.name}, Effets dynamiques',
            icon: Icons.layers_outlined,
          ),

          SizedBox(height: glass.isSmallMobile ? 16 : 24),

          GlassText('Contrôles', fontSize: 12, fontWeight: FontWeight.w600, alpha: 0.7, letterSpacing: 0.5),
          SizedBox(height: glass.isSmallMobile ? 8 : 12),

          GlassForm(
            key: _formKey,
            spacing: glass.isSmallMobile ? 10 : 14,
            padding: EdgeInsets.zero,
            width: double.infinity,
            maxWidth: double.infinity,
            scrollable: false,
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onValidSubmit: _handleValidSubmit,
            onInvalidSubmit: _handleInvalidSubmit,
            children: [
              GlassResponsiveGrid(
                spacing: 16,
                runSpacing: 16,
                mobileColumns: 1,
                tabletColumns: 2,
                desktopColumns: 3,
                children: [
                  // NOM
                  UniversalGlassTextFieldOutlined(
                    controller: _nameController,
                    focusNode: _nameFocusNode,
                    label: 'Nom complet',
                    hintText: 'Entrez votre nom',
                    prefixIcon: Icons.person_outline_rounded,
                    textInputAction: TextInputAction.next,
                    validator: _validateName,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onChanged: (_) => setState(() {}),
                    onSubmitted: (_) => _emailFocusNode.requestFocus(),
                    fieldHeight: 55,
                    fontSize: 16,
                    textCase: GlassTextCase.capitalize,
                    enableBackdropBlur: true, 
                  ),

                  // EMAIL
                  UniversalGlassTextFieldOutlined(
                    controller: _emailController,
                    focusNode: _emailFocusNode,
                    label: 'Email',
                    hintText: 'exemple@email.com',
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: _validateEmail,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onChanged: (_) => setState(() {}),
                    onSubmitted: (_) => _searchFocusNode.requestFocus(),
                    fieldHeight: 55,
                    fontSize: 16,
                    iconSize: 26,
                    textCase: GlassTextCase.lowercase,
                    enableBackdropBlur: false,
                  ),
/*
                  // RECHERCHE AUTO-COMPLÈTE (Anciennement Code Promo)
                  GlassSearchAutoCompleteTextField<String>(
                    controller: _searchController, 
                    fieldHeight: 55, 
                    hintText: 'Rechercher un code promo...',
                    suggestions: const ['GLASS20', 'UNIVERSAL50', 'SUMMER10', 'BONUS30'],
                    stringExtractor: (item) => item, 
                    overlayIconColor: focusColor.withValues(alpha: 0.8), 
                    overlayHighlightColor: focusColor,
                    onSelected: (selectedCode) {
                      setState(() {}); 
                      _submitForm();
                    },
                  ),
*/
                            // 3. CHAMP SÉLECTION DE PAYS / DROPDOWN TEST
              GlassDropdownTextField<String>(
                fieldHeight: 55,
                label: 'Pays de résidence',
                hintText: 'Choisissez votre pays...',
                prefixIcon: Icons.public_rounded,
                value: _selectedCountryName, // Crée une variable String? _selectedCountryName dans ton State
                items: const ['Burkina Faso', 'France', 'Canada', 'Côte d\'Ivoire', 'Sénégal'],
                itemLabelExtractor: (item) => item,
                onChanged: (newValue) {
                  setState(() {
                    _selectedCountryName = newValue;
                  });
                },
              ),
              _buildGlassField(
                controller: _passwordController,
                focusNode: _passwordFocus,
                label: 'Mot de passe',
                hintText: 'Votre mot de passe',
                prefixIcon: Icons.lock_outline_rounded,
                obscureText: true,
                textInputAction: TextInputAction.done,
                //validator: _useValidation ? _validatePassword : null,
                glass: glass,
              ),

              // 4. CHAMP SÉLECTEUR DE DATE TEST
              GlassDatePickerTextField(
                fieldHeight: 55,
                label: 'Date de naissance',
                hintText: 'Sélectionnez une date...',
                selectedDate: _selectedBirthDate, // Crée une variable DateTime? _selectedBirthDate dans ton State
                onDateSelected: (newDate) {
                  setState(() {
                    _selectedBirthDate = newDate;
                  });
                },
              ),

             TextFormField(
                    // Définit le type de clavier (ex: email, nombre, etc.)
                    keyboardType: TextInputType.emailAddress,

                    // Style de décoration du champ
                    decoration: InputDecoration(
                      labelText: 'Email',
                      hintText: 'Entrez votre adresse email',
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),

                    // Fonction de validation
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer un email';
                      }
                      if (!value.contains('@')) {
                        return 'Veuillez entrer un email valide';
                      }
                      return null; // Retourne null si la saisie est correcte
                    },

                    // Récupération de la valeur lors de la modification
                    onChanged: (value) {
                      print("Texte actuel : $value");
                    },

                    // Action lorsque l'utilisateur valide le clavier
                    onSaved: (value) {
                      // Utile pour enregistrer la valeur dans une variable
                    },
                  ),
                ],
              ),

              const SizedBox(height: 16),

              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: GlassResponsiveGrid(
                  spacing: 12,
                  runSpacing: 10,
                  mobileColumns: 1,
                  tabletColumns: 2,
                  desktopColumns: 2,
                  tabletBreakpoint: 450,
                  children: [
                    _GlassFormButton(buttonId: 'reset_form_btn', icon: Icons.refresh_rounded, label: 'Réinitialiser', onTap: _resetForm),
                    _GlassFormButton(buttonId: 'submit_form_btn', icon: Icons.check_rounded, label: 'Valider', onTap: _submitForm),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: glass.isSmallMobile ? 16 : 20),

          GlassText('État', fontSize: 12, fontWeight: FontWeight.w600, alpha: 0.7, letterSpacing: 0.5),
          const SizedBox(height: 8),
          _buildStatus(glass.isSmallMobile),
          const SizedBox(height: 8),
          _buildValues(glass.isSmallMobile),
        ],
      ),
    );
  }

  Widget _buildStatus(bool isMobile) {
    final hasData = _nameController.text.isNotEmpty || _emailController.text.isNotEmpty;
    return GlassContainer(
      padding: const EdgeInsets.all(12),
      borderRadius: BorderRadius.circular(12),
      child: GlassText(hasData ? 'Formulaire modifié' : 'En attente de saisie', fontSize: isMobile ? 12 : 13, alpha: 0.7),
    );
  }

  Widget _buildValues(bool isMobile) {
    return GlassContainer(
      padding: const EdgeInsets.all(12),
      borderRadius: BorderRadius.circular(12),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _valueRow('Nom', _nameController.text, isMobile),
        _valueRow('Email', _emailController.text, isMobile),
        _valueRow('Promo', _searchController.text, isMobile),
      ]),
    );
  }

  Widget _valueRow(String label, String value, bool isMobile) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(children: [
        SizedBox(width: 80, child: GlassText('$label:', fontSize: isMobile ? 11 : 12, fontWeight: FontWeight.w600, alpha: 0.6)),
        Expanded(child: GlassText(value.isEmpty ? '-' : value, fontSize: isMobile ? 11 : 12)),
      ]),
    );
  }


Widget _buildGlassField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String label,
    required String hintText,
    IconData? prefixIcon,
    IconData? suffixIcon,
    VoidCallback? onSuffixTap,
    bool obscureText = false,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
    String? Function(String?)? validator,
    required GlassLayoutContext glass,
  }) {
    final bool useAqua = glass.theme.useAquaStyle;
    final Color focusColor = useAqua ? Colors.cyanAccent : Colors.orangeAccent;
    final double bgOpacity = glass.theme.effectiveBlur > 25 ? 0.12 : 0.18;

    // FIX: Plus de GlassContainer + AnimatedBuilder. Direct UniversalGlassTextField
    return UniversalGlassTextField(
      controller: controller,
      focusNode: focusNode,
      label: label,
      hintText: hintText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      onSuffixTap: onSuffixTap,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      
      validator: validator,
      
      decoration: GlassInputDecoration(
        color: useAqua ? focusColor.withValues(alpha:0.06) : Colors.white.withValues(alpha:0.04),
        backgroundOpacity: focusNode.hasFocus ? bgOpacity + 0.1 : bgOpacity,
        focusOpacity: bgOpacity + 0.14,
        borderColor: Colors.white.withValues(alpha: 0.12),
        focusBorderColor: focusColor,
        errorColor: Colors.redAccent,
        borderWidth: 1.2,
        focusBorderWidth: 1.8,
        borderRadius: glass.isSmallMobile ? 14 : 16,
        fontSize: 15,
        fontWeight: FontWeight.w600,
      ),
      style: glass.effectiveGlassStyle,
      shape: GlassShapeType.squareRounded,
      height: glass.isSmallMobile ? 52 : 58,
    );
  }


}
class _GlassFormButton extends ConsumerStatefulWidget {
  final String buttonId; final IconData icon; final String label; final VoidCallback onTap;
  const _GlassFormButton({required this.buttonId, required this.icon, required this.label, required this.onTap});
  @override
  ConsumerState<_GlassFormButton> createState() => _GlassFormButtonState();
}

class _GlassFormButtonState extends ConsumerState<_GlassFormButton> {
  bool _enabled = true; bool _defaultActive = false;
  SpinnerPosition _spinnerPosition = SpinnerPosition.left; bool _useFuture = false;

  Future<void> _fakeApiCall(WidgetRef ref) async {
    setState(() => _enabled = false);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => _enabled = true);
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final bool isSmallMobile = screenWidth < 375;
    final GlassThemeState theme = ref.watch(glassThemeProvider);
    final GlassColorPalette colors = GlassColorPalette.defaults();

    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      UniversalGlassButton(
        buttonId: widget.buttonId, width: double.infinity, height: isSmallMobile ? 46 : 52,
        borderRadius: theme.borderRadius,
        effects: GlassEffects.fromTheme(colors, blur: 0, noise: theme.effectiveNoise, surfaceOpacity: theme.surfaceOpacity),
        shape: GlassShapeType.squareRounded, style: theme.glassStyle, defaultActive: _defaultActive, enabled: _enabled,
        label: widget.label, icon: widget.icon, iconColor: Colors.white, spinnerPosition: _spinnerPosition,
        simpleOnTap: !_useFuture ? widget.onTap : null, futureOnTap: _useFuture ? _fakeApiCall : null,
      ),
      const SizedBox(height: 12),
      GlassResponsiveGrid(
        expandItems: false, mobileColumns: 2, tabletColumns: 3, desktopColumns: 4, spacing: 10, runSpacing: 10,
        children: [
          GlassToggle(label: 'Enabled', value: _enabled, onChanged: (v) => setState(() => _enabled = v), size: isSmallMobile ? GlassToggleSize.small : GlassToggleSize.medium),
          GlassToggle(label: 'Active', value: _defaultActive, onChanged: (v) => setState(() => _defaultActive = v), size: isSmallMobile ? GlassToggleSize.small : GlassToggleSize.medium),
          BreakerSwitchPreview(label: 'Loader', value: _useFuture, onChanged: (v) => setState(() => _useFuture = v)),
          _buildSegmented(isSmallMobile),
        ],
      ),
    ]);
  }

  Widget _buildSegmented(bool isSmallMobile) => Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
    const GlassPreviewLabel('Spinner'), const SizedBox(height: 4),
    GlassContainer(borderRadius: BorderRadius.circular(12), padding: EdgeInsets.all(isSmallMobile ? 2 : 4),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        _segmentButton(SpinnerPosition.left, 'Gauche', isSmallMobile),
        _segmentButton(SpinnerPosition.right, 'Droite', isSmallMobile),
      ]),
    ),
  ]);

  Widget _segmentButton(SpinnerPosition position, String text, bool isSmallMobile) {
    final bool isSelected = position == _spinnerPosition;
    return GestureDetector(
      onTap: () => setState(() => _spinnerPosition = position),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: isSmallMobile ? 6 : 8, horizontal: isSmallMobile ? 8 : 12),
        decoration: BoxDecoration(color: isSelected ? Colors.white.withOpacity(0.18) : Colors.transparent, borderRadius: BorderRadius.circular(8)),
        child: Text(text, style: TextStyle(color: Colors.white, fontSize: isSmallMobile ? 11 : 12, fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500)),
      ),
    );
  }
}