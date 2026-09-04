
import 'package:flutter/material.dart';
import 'package:universal_glass/glass.dart';


/// ============================================================================
/// UNIVERSAL GLASS PHONE INPUT DEMO
/// ============================================================================
///
/// Démonstration complète de UniversalGlassPhoneInput.
///
/// ARCHITECTURE
///
/// PhoneCountryRegistry
///        │
///        ├── tous les pays
///        │
///        └── _selectedCountry
///                  │
///                  ▼
///        UniversalGlassPhoneInput
///
/// Le Demo ne connaît plus directement :
///
/// • le code pays
/// • le drapeau
/// • le nombre de chiffres
/// • les groupes de formatage
/// • le placeholder
///
/// Toutes ces données viennent de PhoneCountry.
///
/// Exemple Burkina Faso :
///
///     Saisie      → 71200000
///     Affichage   → 71 20 00 00
///     onChanged   → 71200000
///
/// ============================================================================

class UniversalGlassPhoneInputDemo extends StatefulWidget {
  const UniversalGlassPhoneInputDemo({
    super.key,
  });

  @override
  State<UniversalGlassPhoneInputDemo> createState() =>
      _UniversalGlassPhoneInputDemoState();
}

class _UniversalGlassPhoneInputDemoState
    extends State<UniversalGlassPhoneInputDemo> {
  // ==========================================================================
  // REGISTRY
  // ==========================================================================

  late PhoneCountryRegistry _countryRegistry;

  // ==========================================================================
  // CONTROLES
  // ==========================================================================

  late final TextEditingController _phoneController;

  late final FocusNode _phoneFocusNode;

  late final TextEditingController _countrySearchController;

  // ==========================================================================
  // PAYS
  // ==========================================================================

  PhoneCountry? _selectedCountry;

  // ==========================================================================
  // ETAT
  // ==========================================================================

  String _normalizedPhone = '';

  String _submittedPhone = '';

  String _countrySearchQuery = '';

  bool _isLoadingCountries = true;

  String? _countryLoadError;

  // ==========================================================================
  // INIT
  // ==========================================================================

  @override
  void initState() {
    super.initState();

    _phoneController = TextEditingController();

    _phoneFocusNode = FocusNode();

    _countrySearchController = TextEditingController();

    _countrySearchController.addListener(
      _handleCountrySearchChanged,
    );

    _loadCountries();
  }

  // ==========================================================================
  // LOAD COUNTRIES
  // ==========================================================================

  Future<void> _loadCountries() async {
    try {
      final PhoneCountryRegistry registry =
          await PhoneCountryRegistry.load();

      if (!mounted) {
        return;
      }

      // ----------------------------------------------------------------------
      // PAYS PAR DEFAUT
      // ----------------------------------------------------------------------
      //
      // On recherche BF dans le registre.
      //
      // Aucun code téléphonique, drapeau ou format n'est défini ici.
      //
      // ----------------------------------------------------------------------

      final PhoneCountry? burkina =
          registry.findByIsoCode('BF');

      final PhoneCountry? initialCountry =
          burkina ??
          (registry.countries.isNotEmpty
              ? registry.countries.first
              : null);

      setState(() {
        _countryRegistry = registry;

        _selectedCountry = initialCountry;

        _isLoadingCountries = false;

        _countryLoadError = null;
      });
    } catch (error, stackTrace) {
      debugPrint(
        'UniversalGlassPhoneInputDemo: '
        'erreur chargement pays : $error',
      );

      debugPrintStack(
        stackTrace: stackTrace,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _isLoadingCountries = false;

        _countryLoadError =
            'Impossible de charger les pays.';
      });
    }
  }

  // ==========================================================================
  // COUNTRY SEARCH
  // ==========================================================================

  void _handleCountrySearchChanged() {
    if (!mounted) {
      return;
    }

    final String query =
        _countrySearchController.text
            .toLowerCase()
            .trim();

    setState(() {
      _countrySearchQuery = query;
    });
  }

  // ==========================================================================
  // FILTERED COUNTRIES
  // ==========================================================================

  List<PhoneCountry> _filteredCountries() {
    if (_isLoadingCountries) {
      return <PhoneCountry>[];
    }

    if (_countrySearchQuery.trim().isEmpty) {
      return _countryRegistry.countries;
    }

    return _countryRegistry.search(
      _countrySearchQuery,
    );
  }

  // ==========================================================================
  // PHONE CHANGED
  // ==========================================================================

  void _handlePhoneChanged(
    String value,
  ) {
    if (!mounted) {
      return;
    }

    setState(() {
      _normalizedPhone = value;
    });

    debugPrint(
      'PHONE NORMALISE => $value',
    );
  }

  // ==========================================================================
  // SUBMITTED
  // ==========================================================================

  void _handlePhoneSubmitted(
    String value,
  ) {
    if (!mounted) {
      return;
    }

    setState(() {
      _submittedPhone = value;
    });

    debugPrint(
      'PHONE SUBMITTED => $value',
    );
  }

  // ==========================================================================
  // COUNTRY TAP
  // ==========================================================================

  void _handleCountryTap() {
    if (_isLoadingCountries) {
      return;
    }

    if (_countryLoadError != null) {
      return;
    }

    _showCountrySelector();
  }

  // ==========================================================================
  // COUNTRY SELECTOR
  // ==========================================================================

  void _showCountrySelector() {
    _countrySearchController.clear();

    showModalBottomSheet<void>(
      context: context,

      backgroundColor:
          Colors.transparent,

      isScrollControlled:
          true,

      builder: (
        BuildContext bottomSheetContext,
      ) {
        return SafeArea(
          child: Container(
            height:
                MediaQuery.sizeOf(
                  bottomSheetContext,
                ).height *
                0.78,

            margin:
                const EdgeInsets.all(
              12,
            ),

            decoration:
                BoxDecoration(
              color:
                  const Color(
                0xFF17252B,
              ),

              borderRadius:
                  BorderRadius.circular(
                24,
              ),

              border:
                  Border.all(
                color:
                    Colors.white.withValues(
                  alpha: 0.12,
                ),
              ),

              boxShadow: [
                BoxShadow(
                  color:
                      Colors.black.withValues(
                    alpha: 0.35,
                  ),

                  blurRadius:
                      30,

                  offset:
                      const Offset(
                    0,
                    12,
                  ),
                ),
              ],
            ),

            child: Column(
              children: [
                // =============================================================
                // HEADER
                // =============================================================

                Padding(
                  padding:
                      const EdgeInsets.fromLTRB(
                    20,
                    18,
                    20,
                    10,
                  ),

                  child: Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Choisir un pays',

                          style:
                              TextStyle(
                            color:
                                Colors.white,

                            fontSize:
                                19,

                            fontWeight:
                                FontWeight.w800,
                          ),
                        ),
                      ),

                      IconButton(
                        onPressed:
                            () {
                          Navigator.of(
                            bottomSheetContext,
                          ).pop();
                        },

                        icon:
                            const Icon(
                          Icons.close_rounded,
                          color:
                              Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),

                // =============================================================
                // SEARCH
                // =============================================================

                Padding(
                  padding:
                      const EdgeInsets.fromLTRB(
                    18,
                    4,
                    18,
                    14,
                  ),

                  child:
                      TextField(
                    controller:
                        _countrySearchController,

                    style:
                        const TextStyle(
                      color:
                          Colors.white,

                      fontSize:
                          15,
                    ),

                    cursorColor:
                        const Color(
                      0xFF4DD0E1,
                    ),

                    decoration:
                        InputDecoration(
                      hintText:
                          'Rechercher un pays...',

                      hintStyle:
                          TextStyle(
                        color:
                            Colors.white.withValues(
                          alpha: 0.45,
                        ),
                      ),

                      prefixIcon:
                          const Icon(
                        Icons.search_rounded,

                        color:
                            Colors.white70,
                      ),

                      filled:
                          true,

                      fillColor:
                          Colors.white.withValues(
                        alpha: 0.06,
                      ),

                      border:
                          OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(
                          16,
                        ),

                        borderSide:
                            BorderSide.none,
                      ),

                      enabledBorder:
                          OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(
                          16,
                        ),

                        borderSide:
                            BorderSide.none,
                      ),

                      focusedBorder:
                          OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(
                          16,
                        ),

                        borderSide:
                            BorderSide(
                          color:
                              const Color(
                            0xFF4DD0E1,
                          ).withValues(
                            alpha: 0.45,
                          ),
                        ),
                      ),

                      contentPadding:
                          const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 14,
                      ),
                    ),
                  ),
                ),

                // =============================================================
                // LISTE
                // =============================================================

                Expanded(
                  child:
                      _buildCountryList(
                    bottomSheetContext,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ==========================================================================
  // COUNTRY LIST
  // ==========================================================================

  Widget _buildCountryList(
    BuildContext bottomSheetContext,
  ) {
    final List<PhoneCountry> countries =
        _filteredCountries();

    if (countries.isEmpty) {
      return Center(
        child: Padding(
          padding:
              const EdgeInsets.all(
            24,
          ),

          child: Text(
            _countrySearchQuery.isEmpty
                ? 'Aucun pays disponible.'
                : 'Aucun pays trouvé.',

            textAlign:
                TextAlign.center,

            style:
                TextStyle(
              color:
                  Colors.white.withValues(
                alpha: 0.55,
              ),

              fontSize:
                  14,
            ),
          ),
        ),
      );
    }

    return ListView.separated(
      padding:
          const EdgeInsets.fromLTRB(
        12,
        4,
        12,
        18,
      ),

      itemCount:
          countries.length,

      separatorBuilder:
          (
        BuildContext context,
        int index,
      ) {
        return Divider(
          height:
              1,

          indent:
              64,

          color:
              Colors.white.withValues(
            alpha: 0.06,
          ),
        );
      },

      itemBuilder:
          (
        BuildContext context,
        int index,
      ) {
        final PhoneCountry country =
            countries[index];

        final bool selected =
            _selectedCountry?.isoCode
                .toUpperCase() ==
            country.isoCode.toUpperCase();

        return _buildCountryItem(
          bottomSheetContext:
              bottomSheetContext,

          country:
              country,

          selected:
              selected,
        );
      },
    );
  }

  // ==========================================================================
  // COUNTRY ITEM
  // ==========================================================================

  Widget _buildCountryItem({
    required BuildContext bottomSheetContext,
    required PhoneCountry country,
    required bool selected,
  }) {
    return Material(
      color:
          Colors.transparent,

      child: InkWell(
        borderRadius:
            BorderRadius.circular(
          14,
        ),

        onTap: () {
          _selectCountry(
            country,
          );

          Navigator.of(
            bottomSheetContext,
          ).pop();
        },

        child: Padding(
          padding:
              const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 10,
          ),

          child: Row(
            children: [
              // ===============================================================
              // FLAG
              // ===============================================================

              Container(
                width:
                    44,

                height:
                    36,

                alignment:
                    Alignment.center,

                decoration:
                    BoxDecoration(
                  color:
                      Colors.white.withValues(
                    alpha: 0.05,
                  ),

                  borderRadius:
                      BorderRadius.circular(
                    10,
                  ),
                ),

                child:
                    Text(
                  country.flag,

                  style:
                      const TextStyle(
                    fontSize:
                        23,
                  ),
                ),
              ),

              const SizedBox(
                width: 12,
              ),

              // ===============================================================
              // COUNTRY NAME
              // ===============================================================

              Expanded(
                child:
                    Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [
                    Text(
                      country.name,

                      maxLines:
                          1,

                      overflow:
                          TextOverflow.ellipsis,

                      style:
                          TextStyle(
                        color:
                            Colors.white,

                        fontSize:
                            15,

                        fontWeight:
                            selected
                                ? FontWeight.w800
                                : FontWeight.w600,
                      ),
                    ),

                    const SizedBox(
                      height: 3,
                    ),

                    Text(
                      country.isoCode
                          .toUpperCase(),

                      style:
                          TextStyle(
                        color:
                            Colors.white.withValues(
                          alpha: 0.42,
                        ),

                        fontSize:
                            11,

                        fontWeight:
                            FontWeight.w600,

                        letterSpacing:
                            0.8,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(
                width: 10,
              ),

              // ===============================================================
              // DIAL CODE
              // ===============================================================

              Text(
                country.dialCode,

                style:
                    const TextStyle(
                  color:
                      Colors.white70,

                  fontSize:
                      14,

                  fontWeight:
                      FontWeight.w700,
                ),
              ),

              const SizedBox(
                width: 8,
              ),

              // ===============================================================
              // SELECTED
              // ===============================================================

              AnimatedOpacity(
                duration:
                    const Duration(
                  milliseconds: 180,
                ),

                opacity:
                    selected
                        ? 1
                        : 0,

                child:
                    const Icon(
                  Icons.check_circle_rounded,

                  color:
                      Color(
                    0xFF4DD0E1,
                  ),

                  size:
                      20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================================================
  // SELECT COUNTRY
  // ==========================================================================

  void _selectCountry(
    PhoneCountry country,
  ) {
    if (_selectedCountry?.isoCode ==
        country.isoCode) {
      return;
    }

    setState(() {
      _selectedCountry = country;
    });

    // ------------------------------------------------------------------------
    // VALIDATION / FORMAT
    // ------------------------------------------------------------------------
    //
    // UniversalGlassPhoneInput récupère automatiquement :
    //
    // country.nationalDigits
    // country.formatGroups
    // country.placeholder
    // country.dialCode
    // country.flag
    //
    // ------------------------------------------------------------------------

    debugPrint(
      'PAYS SELECTIONNE => '
      '${country.name} '
      '(${country.isoCode}) '
      '${country.dialCode}',
    );
  }

  // ==========================================================================
  // VALIDATION
  // ==========================================================================

  String? _validatePhone(
    String? value,
  ) {
    final String phone =
        value
                ?.replaceAll(
                  RegExp(r'\D'),
                  '',
                ) ??
            '';

    final PhoneCountry? country =
        _selectedCountry;

    if (phone.isEmpty) {
      return 'Veuillez saisir votre numéro';
    }

    if (country == null) {
      return null;
    }

    // ------------------------------------------------------------------------
    // LONGUEURS AUTORISEES
    // ------------------------------------------------------------------------

    final List<int> validLengths =
        country.nationalDigits;

    if (validLengths.isEmpty) {
      return null;
    }

    if (!validLengths.contains(
      phone.length,
    )) {
      if (validLengths.length == 1) {
        return 'Le numéro doit contenir '
            '${validLengths.first} chiffres';
      }

      final String lengths =
          validLengths.join(
        ' ou ',
      );

      return 'Le numéro doit contenir '
          '$lengths chiffres';
    }

    // ------------------------------------------------------------------------
    // PREFIXES
    // ------------------------------------------------------------------------
    //
    // La validation du préfixe n'est appliquée que lorsque le pays fournit
    // réellement des préfixes dans son registre.
    //
    // ------------------------------------------------------------------------

    if (country.prefixes.isNotEmpty) {
      final bool validPrefix =
          country.prefixes.any(
        (String prefix) {
          return phone.startsWith(
            prefix,
          );
        },
      );

      if (!validPrefix) {
        return 'Le préfixe du numéro est invalide';
      }
    }

    return null;
  }

  // ==========================================================================
  // CLEAR
  // ==========================================================================

  void _clearPhone() {
    _phoneController.clear();

    if (!mounted) {
      return;
    }

    setState(() {
      _normalizedPhone = '';

      _submittedPhone = '';
    });

    _phoneFocusNode.requestFocus();
  }

  // ==========================================================================
  // DISPOSE
  // ==========================================================================

  @override
  void dispose() {
    _countrySearchController
        .removeListener(
      _handleCountrySearchChanged,
    );

    _countrySearchController.dispose();

    _phoneController.dispose();

    _phoneFocusNode.dispose();

    super.dispose();
  }

  // ==========================================================================
  // BUILD
  // ==========================================================================

  @override
  Widget build(
    BuildContext context,
  ) {
    // =========================================================================
    // LOADING
    // =========================================================================

    if (_isLoadingCountries) {
      return Scaffold(
        backgroundColor:
            const Color(
          0xFF071216,
        ),

        appBar:
            AppBar(
          backgroundColor:
              Colors.transparent,

          elevation:
              0,

          title:
              const Text(
            'Glass Phone Input',

            style:
                TextStyle(
              color:
                  Colors.white,

              fontWeight:
                  FontWeight.w700,
            ),
          ),
        ),

        body:
            const Center(
          child:
              CircularProgressIndicator(
            color:
                Color(
              0xFF4DD0E1,
            ),
          ),
        ),
      );
    }

    // =========================================================================
    // ERROR
    // =========================================================================

    if (_countryLoadError != null ||
        _selectedCountry == null) {
      return Scaffold(
        backgroundColor:
            const Color(
          0xFF071216,
        ),

        appBar:
            AppBar(
          backgroundColor:
              Colors.transparent,

          elevation:
              0,

          title:
              const Text(
            'Glass Phone Input',

            style:
                TextStyle(
              color:
                  Colors.white,

              fontWeight:
                  FontWeight.w700,
            ),
          ),
        ),

        body:
            Center(
          child:
              Padding(
            padding:
                const EdgeInsets.all(
              24,
            ),

            child:
                Text(
              _countryLoadError ??
                  'Aucun pays disponible.',

                  textAlign:
                      TextAlign.center,

                  style:
                      const TextStyle(
                    color:
                        Colors.white70,

                    fontSize:
                        15,
                  ),
                ),
              ),
            ),
          );
    }

    // =========================================================================
    // NORMAL
    // =========================================================================

    final PhoneCountry country =
        _selectedCountry!;

    return Scaffold(
      backgroundColor:
          const Color(
        0xFF071216,
      ),

      appBar:
          AppBar(
        backgroundColor:
            Colors.transparent,

        elevation:
            0,

        title:
            const Text(
          'Glass Phone Input',

          style:
              TextStyle(
            color:
                Colors.white,

            fontWeight:
                FontWeight.w700,
          ),
        ),
      ),

      body:
          SafeArea(
        child:
            SingleChildScrollView(
          padding:
              const EdgeInsets.all(
            20,
          ),

          child:
              Column(
            crossAxisAlignment:
                CrossAxisAlignment.stretch,

            children: [
              // ===============================================================
              // TITLE
              // ===============================================================

              const Text(
                'Numéro de téléphone',

                style:
                    TextStyle(
                  color:
                      Colors.white,

                  fontSize:
                      24,

                  fontWeight:
                      FontWeight.w800,
                ),
              ),

              const SizedBox(
                height: 8,
              ),

              Text(
                'Le pays, le format et la longueur '
                'sont automatiquement déterminés '
                'par PhoneCountry.',

                style:
                    TextStyle(
                  color:
                      Colors.white.withValues(
                    alpha: 0.65,
                  ),

                  fontSize:
                      14,
                ),
              ),

              const SizedBox(
                height: 28,
              ),

              // ===============================================================
              // PHONE INPUT
              // ===============================================================

              UniversalGlassPhoneInput(
                controller:
                    _phoneController,

                focusNode:
                    _phoneFocusNode,

                // -------------------------------------------------------------
                // NOUVELLE API
                // -------------------------------------------------------------

                country:
                    country,

                countryPickerEnabled:
                    true,

                // Dans universal_glass_phone_input_demo.dart :
                onCountryTap: (country) => _handleCountryTap(), 

                // -------------------------------------------------------------
                // TELEPHONE
                // -------------------------------------------------------------

                formatPhoneNumber:
                    true,

                // -------------------------------------------------------------
                // SUFFIX
                // -------------------------------------------------------------

                suffixIcon:
                    Icons.clear_rounded,

                onSuffixTap:
                    _clearPhone,

                // -------------------------------------------------------------
                // CLAVIER
                // -------------------------------------------------------------

                textInputAction:
                    TextInputAction.done,

                // -------------------------------------------------------------
                // VALIDATION
                // -------------------------------------------------------------

                validator:
                    _validatePhone,

                autovalidateMode:
                    AutovalidateMode
                        .onUserInteraction,

                // -------------------------------------------------------------
                // CALLBACKS
                // -------------------------------------------------------------

                onChanged:
                    _handlePhoneChanged,

                onSubmitted:
                    _handlePhoneSubmitted,

                // -------------------------------------------------------------
                // DIMENSIONS
                // -------------------------------------------------------------

                width:
                    double.infinity,

                fieldHeight:
                    55,

                // -------------------------------------------------------------
                // DECORATION
                // -------------------------------------------------------------

                decoration:
                    const GlassInputDecoration(
                  color:
                      Color(
                    0xFF00BCD4,
                  ),

                  fontSize:
                      16,

                  fontWeight:
                      FontWeight.w600,

                  backgroundOpacity:
                      0.18,

                  focusOpacity:
                      0.28,

                  borderRadius:
                      18,

                  blur:
                      6,

                  showReflection:
                      true,

                  reflectionOpacity:
                      0.30,
                ),

                // -------------------------------------------------------------
                // STYLE
                // -------------------------------------------------------------

                style:
                    GlassStyle.transparentAqua,

                shape:
                    GlassShapeType
                        .squareRounded,
              ),

              const SizedBox(
                height: 28,
              ),

              // ===============================================================
              // PAYS ACTUEL
              // ===============================================================

              _buildCountryInfoCard(
                country:
                    country,
              ),

              const SizedBox(
                height: 12,
              ),

              // ===============================================================
              // VALEUR AFFICHÉE
              // ===============================================================

              _buildInfoCard(
                title:
                    'Valeur affichée',

                value:
                    _phoneController
                            .text
                            .isEmpty
                        ? '—'
                        : _phoneController.text,
              ),

              const SizedBox(
                height: 12,
              ),

              // ===============================================================
              // VALEUR NORMALISEE
              // ===============================================================

              _buildInfoCard(
                title:
                    'Valeur normalisée',

                value:
                    _normalizedPhone.isEmpty
                        ? '—'
                        : _normalizedPhone,
              ),

              const SizedBox(
                height: 12,
              ),

              // ===============================================================
              // SUBMITTED
              // ===============================================================

              _buildInfoCard(
                title:
                    'Dernière valeur envoyée',

                value:
                    _submittedPhone.isEmpty
                        ? '—'
                        : _submittedPhone,
              ),

              const SizedBox(
                height: 28,
              ),

              // ===============================================================
              // EXEMPLE
              // ===============================================================

              _buildBehaviorCard(
                country:
                    country,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================================================
  // COUNTRY INFO CARD
  // ==========================================================================

  Widget _buildCountryInfoCard({
    required PhoneCountry country,
  }) {
    return Container(
      padding:
          const EdgeInsets.all(
        16,
      ),

      decoration:
          BoxDecoration(
        color:
            Colors.white.withValues(
          alpha: 0.045,
        ),

        borderRadius:
            BorderRadius.circular(
          16,
        ),

        border:
            Border.all(
          color:
              Colors.white.withValues(
            alpha: 0.08,
          ),
        ),
      ),

      child:
          Row(
        children: [
          Text(
            country.flag,

            style:
                const TextStyle(
              fontSize:
                  27,
            ),
          ),

          const SizedBox(
            width: 12,
          ),

          Expanded(
            child:
                Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                Text(
                  country.name,

                  style:
                      const TextStyle(
                    color:
                        Colors.white,

                    fontSize:
                        15,

                    fontWeight:
                        FontWeight.w700,
                  ),
                ),

                const SizedBox(
                  height: 3,
                ),

                Text(
                  // ignore: prefer_interpolation_to_compose_strings
                  country.isoCode
                          .toUpperCase() +
                      ' • ' +
                      country.dialCode,

                  style:
                      TextStyle(
                    color:
                        Colors.white.withValues(
                      alpha: 0.55,
                    ),

                    fontSize:
                        12,

                    fontWeight:
                        FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // INFO CARD
  // ==========================================================================

  Widget _buildInfoCard({
    required String title,
    required String value,
  }) {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),

      decoration:
          BoxDecoration(
        color:
            Colors.white.withValues(
          alpha: 0.045,
        ),

        borderRadius:
            BorderRadius.circular(
          16,
        ),

        border:
            Border.all(
          color:
              Colors.white.withValues(
            alpha: 0.08,
          ),
        ),
      ),

      child:
          Row(
        children: [
          Expanded(
            child:
                Text(
              title,

              style:
                  TextStyle(
                color:
                    Colors.white.withValues(
                  alpha: 0.60,
                ),

                fontSize:
                    13,
              ),
            ),
          ),

          Text(
            value,

            style:
                const TextStyle(
              color:
                  Colors.white,

              fontSize:
                  15,

              fontWeight:
                  FontWeight.w700,

              letterSpacing:
                  0.5,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // BEHAVIOR CARD
  // ==========================================================================

  Widget _buildBehaviorCard({
    required PhoneCountry country,
  }) {
    final String example =
        country.example?.trim().isNotEmpty == true
            ? country.example!
            : '71200000';

    final String placeholder =
        country.placeholder?.trim().isNotEmpty == true
            ? country.placeholder!
            : '—';

    final String format =
        country.formatGroups.isEmpty
            ? '—'
            : country.formatGroups.join(
                ' • ',
              );

    final String lengths =
        country.nationalDigits.isEmpty
            ? '—'
            : country.nationalDigits.join(
                ' / ',
              );

    return Container(
      padding:
          const EdgeInsets.all(
        18,
      ),

      decoration:
          BoxDecoration(
        color:
            Colors.white.withValues(
          alpha: 0.05,
        ),

        borderRadius:
            BorderRadius.circular(
          18,
        ),

        border:
            Border.all(
          color:
              Colors.white.withValues(
            alpha: 0.10,
          ),
        ),
      ),

      child:
          Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          const Text(
            'Données PhoneCountry',

            style:
                TextStyle(
              color:
                  Colors.white,

              fontSize:
                  16,

              fontWeight:
                  FontWeight.w700,
            ),
          ),

          const SizedBox(
            height: 12,
          ),

          _buildExampleRow(
            'Pays',
            country.name,
          ),

          _buildExampleRow(
            'ISO',
            country.isoCode.toUpperCase(),
          ),

          _buildExampleRow(
            'Indicatif',
            country.dialCode,
          ),

          _buildExampleRow(
            'Longueurs',
            lengths,
          ),

          _buildExampleRow(
            'Format',
            format,
          ),

          _buildExampleRow(
            'Placeholder',
            placeholder,
          ),

          _buildExampleRow(
            'Exemple',
            example,
          ),

          const SizedBox(
            height: 12,
          ),

          Divider(
            color:
                Colors.white.withValues(
              alpha: 0.08,
            ),
          ),

          const SizedBox(
            height: 8,
          ),

          const Text(
            'Comportement attendu',

            style:
                TextStyle(
              color:
                  Colors.white,

              fontSize:
                  14,

              fontWeight:
                  FontWeight.w700,
            ),
          ),

          const SizedBox(
            height: 8,
          ),

          _buildExampleRow(
            'Saisie',
            '71200000',
          ),

          _buildExampleRow(
            'Affichage',
            '71 20 00 00',
          ),

          _buildExampleRow(
            'onChanged',
            '71200000',
          ),

          _buildExampleRow(
            'validator',
            '71200000',
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // EXAMPLE ROW
  // ==========================================================================

  Widget _buildExampleRow(
    String label,
    String value,
  ) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(
        vertical: 5,
      ),

      child:
          Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          Expanded(
            child:
                Text(
              label,

              style:
                  TextStyle(
                color:
                    Colors.white.withValues(
                  alpha: 0.55,
                ),
              ),
            ),
          ),

          const SizedBox(
            width: 12,
          ),

          Flexible(
            child:
                Text(
              value,

              textAlign:
                  TextAlign.right,

              style:
                  const TextStyle(
                color:
                    Colors.white,

                fontWeight:
                    FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

