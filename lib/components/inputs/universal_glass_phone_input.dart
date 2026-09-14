import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:universal_glass/components/inputs/phone/universal_glass_phone_input_state.dart';
import 'package:universal_glass/enums/glass_enums.dart';
import 'package:universal_glass/models/glass_input_style.dart'; // <- AJOUT
import 'package:universal_glass/phone/phone_country.dart';

class UniversalGlassPhoneInput extends ConsumerStatefulWidget {
  // ==========================================================================
  // CONTROLLER
  // ==========================================================================
  final TextEditingController? controller;

  // ==========================================================================
  // FOCUS
  // ==========================================================================
  final FocusNode? focusNode;

  // ==========================================================================
  // COUNTRY
  // ==========================================================================
  final PhoneCountry? country;
  final List<PhoneCountry>? countries;
  final String initialCountryIsoCode;
  final bool countryPickerEnabled;
  final void Function(PhoneCountry country)? onCountryChanged;
  final void Function(PhoneCountry country)? onCountryTap;
  final String countryPickerTitle;
  final String countryPickerSubtitle;

  // ==========================================================================
  // LABEL / HINT
  // ==========================================================================
  final String label;
  final String? hintText;

  // ==========================================================================
  // PHONE FORMAT - RESTE ICI C'EST METIER
  // ==========================================================================
  final int maxPhoneDigits;
  final List<int> phoneFormatGroups;
  final bool formatPhoneNumber;

  // ==========================================================================
  // SUFFIX
  // ==========================================================================
  final IconData? suffixIcon;
  final VoidCallback? onSuffixTap;

  // ==========================================================================
  // PREFIX
  // ==========================================================================
  final IconData? prefixIcon;

  // ==========================================================================
  // BEHAVIOR - RESTE ICI
  // ==========================================================================
  final bool enabled;
  final bool readOnly;
  final bool autofocus;
  final bool obscureText;

  // ==========================================================================
  // VALIDATION - RESTE ICI
  // ==========================================================================
  final String? Function(String?)? validator;
  final AutovalidateMode autovalidateMode;
  final String? successText;

  // ==========================================================================
  // CALLBACKS
  // ==========================================================================
  final void Function(String)? onChanged;
  final VoidCallback? onTap;
  final void Function(String)? onSubmitted;
  final TextInputAction textInputAction;

  // ==========================================================================
  // DIMENSIONS / STYLE - VISUEL UNIQUEMENT
  // ==========================================================================
  final GlassInputStyle style; // <- NOUVEAU REQUIRED
  final double? width;
  final double? iconSize;
  final double? iconInnerRatio;
  final GlassTextCase textCase;
  final List<TextInputFormatter>? inputFormatters;

  // ==========================================================================
  // OPTIONAL INFORMATION DISPLAY
  // ==========================================================================
  final bool showOperatorBadge;
  final bool showNormalizedPhone;
  final bool showSubmittedPhone;

  const UniversalGlassPhoneInput({
    super.key,
    this.controller,
    this.focusNode,
    this.country,
    this.countries,
    this.initialCountryIsoCode = 'BF',
    this.countryPickerEnabled = true,
    this.onCountryChanged,
    this.onCountryTap,
    this.countryPickerTitle = 'Changer de pays',
    this.countryPickerSubtitle = 'Sélectionnez votre indicatif',
    this.label = 'Numéro de téléphone',
    this.hintText,
    this.maxPhoneDigits = 8,
    this.phoneFormatGroups = const <int>[2, 2, 2, 2],
    this.formatPhoneNumber = true,
    this.suffixIcon,
    this.onSuffixTap,
    this.prefixIcon,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.obscureText = false,
    this.validator,
    this.autovalidateMode = AutovalidateMode.disabled,
    this.successText,
    this.onChanged,
    this.onTap,
    this.onSubmitted,
    this.textInputAction = TextInputAction.next,
    required this.style, // <- REQUIRED
    this.width,
    this.iconSize,
    this.iconInnerRatio,
    this.textCase = GlassTextCase.normal,
    this.inputFormatters,
    this.showOperatorBadge = false,
    this.showNormalizedPhone = false,
    this.showSubmittedPhone = false,
  });

  @override
  ConsumerState<UniversalGlassPhoneInput> createState() => UniversalGlassPhoneInputState();
}