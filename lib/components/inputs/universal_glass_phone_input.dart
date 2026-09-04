import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:universal_glass/components/inputs/glass_input_decoration.dart';
import 'package:universal_glass/enums/glass_enums.dart';
import 'package:universal_glass/phone/phone_country.dart';
import 'package:universal_glass/theme/glass_color_palette.dart';
import 'package:universal_glass/utils/glass_palettes.dart';

import 'phone/universal_glass_phone_input_state.dart';


/// ============================================================================
/// UNIVERSAL GLASS PHONE INPUT
/// ============================================================================
///
/// Champ de saisie de numéro de téléphone avec :
///
/// - sélection du pays ;
/// - indicatif téléphonique ;
/// - drapeau ;
/// - formatage automatique ;
/// - limitation du nombre de chiffres ;
/// - label flottant ;
/// - validation ;
/// - suffix icon ;
/// - style Glass ;
/// - intégration Riverpod.
///
/// ============================================================================
/// ARCHITECTURE
/// ============================================================================
///
/// UniversalGlassPhoneInput
///         │
///         └── API publique / configuration
///                    │
///                    ▼
/// UniversalGlassPhoneInputState
///         │
///         ├── controller
///         ├── FocusNode
///         ├── pays courant
///         ├── formatage
///         ├── validation
///         └── callbacks
///                    │
///                    ▼
/// UniversalGlassPhoneInputView
///         │
///         ├── GlassSurfaceContainer
///         ├── Country selector
///         ├── TextFormField
///         ├── Floating label
///         └── Error
///
/// ============================================================================
///
/// IMPORTANT :
///
/// Le widget public ne contient volontairement aucune logique de rendu.
///
/// Le controller et le FocusNode peuvent être fournis par le parent.
/// S'ils ne sont pas fournis, le State crée ses propres instances.
///
/// ============================================================================
class UniversalGlassPhoneInput extends ConsumerStatefulWidget {
  // ==========================================================================
  // CONTROLLER
  // ==========================================================================

  /// Controller externe optionnel.
  ///
  /// Si null, le State crée automatiquement un controller interne.
  final TextEditingController? controller;

  // ==========================================================================
  // FOCUS
  // ==========================================================================

  /// FocusNode externe optionnel.
  ///
  /// Si null, le State crée automatiquement un FocusNode interne.
  final FocusNode? focusNode;

  // ==========================================================================
  // COUNTRY
  // ==========================================================================

  /// Pays imposé depuis l'extérieur.
  ///
  /// Si null, le composant utilise son propre pays interne.
  final PhoneCountry? country;

  /// Liste personnalisée des pays disponibles dans le picker.
  ///
  /// Si null, le registre global des pays est utilisé.
  final List<PhoneCountry>? countries;

  /// Code ISO du pays utilisé lors de l'initialisation.
  ///
  /// Exemple :
  ///
  ///     BF
  ///     CI
  ///     FR
  ///     US
  final String initialCountryIsoCode;

  /// Active ou désactive le sélecteur de pays.
  final bool countryPickerEnabled;

  /// Appelé lorsque le pays sélectionné change.
  final void Function(PhoneCountry country)?
      onCountryChanged;

  /// Appelé lorsqu'on tape sur le sélecteur de pays.
  ///
  /// Si ce callback est fourni, le picker interne n'est pas ouvert.
  final void Function(PhoneCountry country)?
      onCountryTap;

  /// Titre du sélecteur de pays.
  final String countryPickerTitle;

  /// Sous-titre du sélecteur de pays.
  final String countryPickerSubtitle;

  // ==========================================================================
  // LABEL / HINT
  // ==========================================================================

  /// Label flottant du champ.
  final String label;

  /// Hint personnalisé.
  ///
  /// Si null, le composant utilise le placeholder du pays,
  /// puis génère automatiquement un placeholder à partir des groupes.
  final String? hintText;

  // ==========================================================================
  // PHONE FORMAT
  // ==========================================================================

  /// Nombre maximum de chiffres autorisés.
  ///
  /// Cette valeur est utilisée comme fallback lorsque le pays ne fournit
  /// pas ses propres longueurs nationales.
  final int maxPhoneDigits;

  /// Groupes de formatage du numéro.
  ///
  /// Exemple Burkina Faso :
  ///
  ///     [2, 2, 2, 2]
  ///
  /// produit :
  ///
  ///     70 12 34 56
  final List<int> phoneFormatGroups;

  /// Active le formatage visuel automatique du numéro.
  final bool formatPhoneNumber;

  // ==========================================================================
  // SUFFIX
  // ==========================================================================

  /// Icône affichée à droite du champ.
  final IconData? suffixIcon;

  /// Callback du bouton suffixe.
  final VoidCallback? onSuffixTap;

  // ==========================================================================
  // BEHAVIOR
  // ==========================================================================

  /// Active/désactive complètement le champ.
  final bool enabled;

  /// Rend le champ non éditable tout en permettant éventuellement
  /// certaines interactions externes.
  final bool readOnly;

  /// Demande automatiquement le focus après le premier rendu.
  final bool autofocus;

  // ==========================================================================
  // VALIDATION
  // ==========================================================================

  /// Fonction de validation.
  ///
  /// La valeur reçue est le numéro normalisé, sans espaces.
  final String? Function(String?)? validator;

  /// Mode de validation automatique.
  final AutovalidateMode autovalidateMode;

  // ==========================================================================
  // CALLBACKS
  // ==========================================================================

  /// Appelé lors d'une modification du numéro.
  ///
  /// La valeur retournée est normalisée sans espaces.
  final void Function(String)? onChanged;

  /// Appelé lors du tap sur le champ.
  final VoidCallback? onTap;

  /// Appelé lors de la soumission du champ.
  ///
  /// La valeur retournée est normalisée sans espaces.
  final void Function(String)? onSubmitted;

  /// Action clavier.
  final TextInputAction textInputAction;

  // ==========================================================================
  // DIMENSIONS
  // ==========================================================================

  /// Largeur du champ.
  ///
  /// Si null, le champ prend la largeur disponible.
  final double? width;

  /// Hauteur du champ.
  final double fieldHeight;

  // ==========================================================================
  // GLASS
  // ==========================================================================

  /// Décoration logique du champ.
  ///
  /// Les couleurs finales sont adaptées au thème par GlassLayoutContext.
  final GlassInputDecoration decoration;

  /// Style Glass utilisé pour la surface.
  final GlassStyle style;

  /// Forme de la surface.
  final GlassShapeType shape;

  /// Palette utilisée par le composant.
  final GlassColorPalette palette;

  // ==========================================================================
  // CONSTRUCTOR
  // ==========================================================================

  const UniversalGlassPhoneInput({
    super.key,

    // Controller / focus
    this.controller,
    this.focusNode,

    // Country
    this.country,
    this.countries,
    this.initialCountryIsoCode = 'BF',
    this.countryPickerEnabled = true,
    this.onCountryChanged,
    this.onCountryTap,
    this.countryPickerTitle = 'Changer de pays',
    this.countryPickerSubtitle =
        'Sélectionnez votre indicatif',

    // Label / hint
    this.label = 'Numéro de téléphone',
    this.hintText,

    // Formatting
    this.maxPhoneDigits = 8,
    this.phoneFormatGroups = const <int>[
      2,
      2,
      2,
      2,
    ],
    this.formatPhoneNumber = true,

    // Suffix
    this.suffixIcon,
    this.onSuffixTap,

    // Behavior
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,

    // Validation
    this.validator,
    this.autovalidateMode =
        AutovalidateMode.disabled,

    // Callbacks
    this.onChanged,
    this.onTap,
    this.onSubmitted,
    this.textInputAction =
        TextInputAction.next,

    // Dimensions
    this.width,
    this.fieldHeight = 55,

    // Glass
    this.decoration =
        const GlassInputDecoration(),
    this.style =
        GlassStyle.transparentAqua,
    this.shape =
        GlassShapeType.squareRounded,
    this.palette =
        GlassPalettes.aqua,
  });

  // ==========================================================================
  // STATE
  // ==========================================================================

  @override
  ConsumerState<UniversalGlassPhoneInput>
      createState() =>
          UniversalGlassPhoneInputState();
}