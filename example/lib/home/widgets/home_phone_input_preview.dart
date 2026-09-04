
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:universal_glass/glass.dart';

class HomePhoneInputPreview extends ConsumerStatefulWidget {
  final bool? useAquaStyle;

  const HomePhoneInputPreview({
    super.key,
    this.useAquaStyle,
  });

  @override
  ConsumerState<HomePhoneInputPreview> createState() =>
      _HomePhoneInputPreviewState();
}

class _HomePhoneInputPreviewState
    extends ConsumerState<HomePhoneInputPreview> {
  late final TextEditingController _phoneController;
  late final FocusNode _phoneFocusNode;

  List<PhoneCountry> _allCountries = const [];

  PhoneCountry? _country;

  String _normalizedPhone = '';
  String _submittedPhone = '';

  PhoneOperator? _operator;
  String? _errorText;

  AutovalidateMode _autoValidate =
      AutovalidateMode.disabled;

  @override
  void initState() {
    super.initState();

    _phoneController = TextEditingController();
    _phoneFocusNode = FocusNode();

    _loadCountries();
  }

  // ===========================================================================
  // COUNTRIES
  // ===========================================================================

  Future<void> _loadCountries() async {
    final countries =
        await PhoneCountryDatabase.defaultCountries;

    if (!mounted) return;

    setState(() {
      _allCountries = countries;

      _country = countries.firstWhere(
        (c) => c.isoCode == 'BF',
        orElse: () => countries.first,
      );
    });
  }

  // ===========================================================================
  // COUNTRY
  // ===========================================================================

  void _onCountryChanged(PhoneCountry newCountry) {
    if (!mounted) return;

    setState(() {
      _country = newCountry;
      _normalizedPhone = '';
      _operator = null;
      _errorText = null;
      _autoValidate =
          AutovalidateMode.disabled;
    });

    _phoneController.clear();
  }

  // ===========================================================================
  // OPERATOR
  // ===========================================================================

  PhoneOperator? _detectOperator(String digits) {
    if (_country == null) return null;

    return _country!.operatorForPrefix(digits);
  }

  // ===========================================================================
  // VALIDATION
  // ===========================================================================

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Numéro requis';
    }

    final String digits =
        value.replaceAll(RegExp(r'\D'), '');

    if (_country == null) return null;

    if (!_country!.acceptsLength(digits.length)) {
      return '${_country!.phoneDigits} chiffres requis';
    }

    if (_country!.prefixes.isNotEmpty &&
        !_country!.acceptsPrefix(digits)) {
      return 'Préfixe invalide';
    }

    if (_isFakeNumber(digits)) {
      return 'Numéro invalide';
    }

    return null;
  }

  // ===========================================================================
  // ANTI FAKE
  // ===========================================================================

  bool _isFakeNumber(String digits) {
    if (digits.length < 4) return false;

    // Tous les chiffres identiques.
    if (RegExp(r'^(\d)\1+$').hasMatch(digits)) {
      return true;
    }

    // Séquence croissante.
    bool isSeq = true;

    for (int i = 1; i < digits.length; i++) {
      if (int.parse(digits[i]) !=
          int.parse(digits[i - 1]) + 1) {
        isSeq = false;
        break;
      }
    }

    if (isSeq) return true;

    // Séquence décroissante.
    bool isRevSeq = true;

    for (int i = 1; i < digits.length; i++) {
      if (int.parse(digits[i]) !=
          int.parse(digits[i - 1]) - 1) {
        isRevSeq = false;
        break;
      }
    }

    if (isRevSeq) return true;

    return false;
  }

  // ===========================================================================
  // PHONE CHANGED
  // ===========================================================================

  void _handlePhoneChanged(String value) {
    if (!mounted) return;

    final String digits =
        value.replaceAll(RegExp(r'\D'), '');

    setState(() {
      _normalizedPhone = digits;

      _operator = _detectOperator(digits);

      if (_autoValidate !=
          AutovalidateMode.disabled) {
        _errorText = _validatePhone(digits);
      }
    });
  }

  // ===========================================================================
  // SUBMITTED
  // ===========================================================================

  void _handlePhoneSubmitted(String value) {
    if (!mounted) return;

    final String digits =
        value.replaceAll(RegExp(r'\D'), '');

    setState(() {
      _submittedPhone = digits;

      _autoValidate =
          AutovalidateMode.always;

      _errorText = _validatePhone(digits);
    });
  }

  // ===========================================================================
  // CLEAR
  // ===========================================================================

  void _clearPhone() {
    _phoneController.clear();

    if (!mounted) return;

    setState(() {
      _normalizedPhone = '';
      _submittedPhone = '';
      _operator = null;
      _errorText = null;
      _autoValidate =
          AutovalidateMode.disabled;
    });

    _phoneFocusNode.requestFocus();
  }

  // ===========================================================================
  // DISPOSE
  // ===========================================================================

  @override
  void dispose() {
    _phoneController.dispose();
    _phoneFocusNode.dispose();

    super.dispose();
  }

  // ===========================================================================
  // PHONE INPUT
  // ===========================================================================

  Widget _buildPhoneInput(
    GlassColorPalette palette,
  ) {
    return UniversalGlassPhoneInput(
      controller: _phoneController,
      focusNode: _phoneFocusNode,

      label: 'Numéro de téléphone mobile Burkina Faso',

      initialCountryIsoCode: 'BF',

      countryPickerEnabled: true,

      countries: _allCountries,

      onCountryChanged: _onCountryChanged,

      formatPhoneNumber: true,

      maxPhoneDigits:
          _country?.phoneDigits ?? 8,

      suffixIcon:
          Icons.clear_rounded,

      onSuffixTap:
          _clearPhone,

      onChanged:
          _handlePhoneChanged,

      onSubmitted:
          _handlePhoneSubmitted,

      textInputAction:
          TextInputAction.done,

      width:
          double.infinity,

      fieldHeight:
          55,

      palette:
          palette,

      validator:
          _validatePhone,

      autovalidateMode:
          _autoValidate,
    );
  }

  // ===========================================================================
  // BUILD
  // ===========================================================================

@override
Widget build(BuildContext context) 
{
  final glass = ref.watchGlassContext(context);

  final bool currentUseAqua =
      widget.useAquaStyle ?? glass.theme.useAquaStyle;

  final GlassColorPalette currentPalette =
      widget.useAquaStyle != null
          ? GlassColorPalette.fromMode(
              currentUseAqua
                  ? AppThemeMode.aqua
                  : AppThemeMode.classic,
            )
          : glass.palette;

  final Color focusColor =
      currentUseAqua
          ? Colors.cyanAccent
          : Colors.orangeAccent;

  final bool hasError =
      _errorText != null;

  final bool showBadge =
      _operator != null ||
      _normalizedPhone.length >= 2;


    return  GlassSurfaceContainer(
        style: glass.effectiveGlassStyle,

        // Même pipeline d'effets que UniversalGlassTextField.
        effects: glass.effects,

        // IMPORTANT POUR LE TEST :
        // on laisse les effets de backdrop traverser cette surface.
        disableBackdropEffects: false,

        borderRadius: BorderRadius.circular(
          glass.isSmallMobile ? 14 : 20,
        ),

        padding: glass.dynamicPadding,


        clipBehavior: Clip.none,

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            // =================================================================
            // TITRE
            // =================================================================

            Row(
              children: [
                Text(
                  'Phone Input',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize:
                        glass.isSmallMobile
                            ? 16
                            : 18,
                    fontWeight:
                        FontWeight.w700,
                    letterSpacing: 0.3,
                  ),
                ),

                const Spacer(),

                if (showBadge)
                  _buildOperatorBadge(
                    _operator,
                    focusColor,
                  ),
              ],
            ),

            const SizedBox(height: 4),

            // =================================================================
            // DESCRIPTION
            // =================================================================

            Text(
              'TEST 27 — Phone Input + Blur / Noise',
              style: TextStyle(
                color:
                    Colors.white.withValues(
                  alpha: 0.6,
                ),
                fontSize:
                    glass.isSmallMobile
                        ? 11
                        : 13,
              ),
            ),

            SizedBox(
              height:
                  glass.isSmallMobile
                      ? 16
                      : 24,
            ),

            // =================================================================
            // PHONE INPUT
            // =================================================================

            ConstrainedBox(
              constraints:
                  const BoxConstraints(
                maxWidth: 620,
              ),
              child: _buildPhoneInput(
                currentPalette,
              ),
            ),

            // =================================================================
            // ERREUR
            // =================================================================

            if (hasError) ...[
              const SizedBox(height: 6),

              Padding(
                padding:
                    const EdgeInsets.only(
                  left: 12,
                ),
                child: Text(
                  _errorText!,
                  style:
                      const TextStyle(
                    color:
                        Colors.redAccent,
                    fontSize: 12,
                    fontWeight:
                        FontWeight.w500,
                  ),
                ),
              ),
            ],

            SizedBox(
              height:
                  glass.isSmallMobile
                      ? 20
                      : 26,
            ),

            // =================================================================
            // VALEURS
            // =================================================================

            const GlassPreviewLabel(
              'Valeurs',
            ),

            const SizedBox(height: 10),

            GlassResponsiveGrid(
              spacing: 14,
              runSpacing: 10,
              mobileColumns: 1,
              tabletColumns: 2,
              desktopColumns: 2,
              children: [
                _buildValue(
                  'Valeur affichée',
                  _phoneController.text,
                  currentPalette,
                ),
                _buildValue(
                  'Valeur normalisée',
                  _normalizedPhone,
                  currentPalette,
                ),
                _buildValue(
                  'Opérateur',
                  _operator?.shortName ??
                      (_isFakeNumber(
                        _normalizedPhone,
                      )
                          ? 'Invalide'
                          : '—'),
                  currentPalette,
                ),
                _buildValue(
                  'Pays',
                  _country?.name ?? '—',
                  currentPalette,
                ),
                _buildValue(
                  'Dernière valeur envoyée',
                  _submittedPhone,
                  currentPalette,
                ),
              ],
            ),
          ],
        ),
      );
    
/*
  return Stack(
    children: [
      // =======================================================================
      // ARRIÈRE-PLAN DE TEST
      // =======================================================================
      //
      // Important :
      // Le BackdropFilter ne peut être visible que s'il existe quelque chose
      // derrière lui à flouter.
      //
      // On place donc des éléments visuels derrière le PhoneInput.
      //
      Positioned.fill(
        child: IgnorePointer(
          child: CustomPaint(
            painter: _PhonePreviewBackgroundPainter(
              aqua: currentUseAqua,
            ),
          ),
        ),
      ),

      // =======================================================================
      // CONTENU DU PREVIEW
      // =======================================================================

    
    ],
  );
*/

}
  // ===========================================================================
  // OPERATOR BADGE
  // ===========================================================================

  Widget _buildOperatorBadge(
    PhoneOperator? operator,
    Color focusColor,
  ) {
    final bool isFake =
        _normalizedPhone.isNotEmpty &&
        _isFakeNumber(
          _normalizedPhone,
        );

    final Color badgeColor =
        isFake
            ? Colors.redAccent
            : operator?.color ??
                focusColor;

    return AnimatedContainer(
      duration:
          const Duration(
        milliseconds: 200,
      ),

      padding:
          const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 4,
      ),

      decoration:
          BoxDecoration(
        color:
            badgeColor.withValues(
          alpha: 0.15,
        ),

        borderRadius:
            BorderRadius.circular(20),

        border:
            Border.all(
          color:
              badgeColor.withValues(
            alpha: 0.4,
          ),
        ),
      ),

      child: Text(
        isFake
            ? 'Invalide'
            : operator?.shortName ??
                '—',

        style: TextStyle(
          color:
              badgeColor,
          fontSize: 11,
          fontWeight:
              FontWeight.w700,
        ),
      ),
    );
  }

  // ===========================================================================
  // VALUE
  // ===========================================================================

  Widget _buildValue(
    String label,
    String value,
    GlassColorPalette palette,
  ) {
    return Container(
      width:
          double.infinity,

      padding:
          const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 10,
      ),

      decoration:
          BoxDecoration(
        color:
            Colors.white.withValues(
          alpha: 0.03,
        ),

        borderRadius:
            BorderRadius.circular(12),

        border:
            Border.all(
          color:
              Colors.white.withValues(
            alpha: 0.05,
          ),
          width: 0.8,
        ),
      ),

      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween,

        children: [
          Expanded(
            child: Text(
              label,

              style: TextStyle(
                color:
                    palette.textSecondary,
                fontSize: 13,
              ),
            ),
          ),

          const SizedBox(width: 12),

          Flexible(
            child: Text(
              value.isEmpty
                  ? '—'
                  : value,

              textAlign:
                  TextAlign.right,

              overflow:
                  TextOverflow.ellipsis,

              style: TextStyle(
                color:
                    palette.textPrimary,
                fontSize: 14,
                fontWeight:
                    FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
