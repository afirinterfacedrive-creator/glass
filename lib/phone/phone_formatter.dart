
import 'phone_country.dart';

/// ============================================================================
/// PHONE FORMATTER
///
/// Responsable du nettoyage, de la normalisation et du formatage
/// des numéros de téléphone.
///
/// IMPORTANT
///
/// Le formatter ne dépend d'aucun widget Flutter.
///
/// Il travaille uniquement avec :
///
/// • String
/// • PhoneCountry
///
/// ============================================================================

abstract final class PhoneFormatter {
  // ==========================================================================
  // DIGITS ONLY
  // ==========================================================================

  /// Supprime tout ce qui n'est pas un chiffre.
  static String digitsOnly(
    String value,
  ) {
    return value.replaceAll(
      RegExp(r'\D'),
      '',
    );
  }

  // ==========================================================================
  // NORMALIZE NATIONAL
  // ==========================================================================

  /// Retourne uniquement le numéro national.
  ///
  /// Exemple :
  ///
  /// "71 20 00 00" → "71200000"
  static String normalizeNational(
    String value,
  ) {
    return digitsOnly(value);
  }

  // ==========================================================================
  // REMOVE COUNTRY CODE
  // ==========================================================================

  /// Retire l'indicatif international lorsqu'il est présent.
  ///
  /// Exemple :
  ///
  /// +22671200000 → 71200000
  static String removeDialCode(
    String value,
    PhoneCountry country,
  ) {
    String digits =
        digitsOnly(value);

    final String dialCode =
        digitsOnly(country.dialCode);

    if (dialCode.isNotEmpty &&
        digits.startsWith(dialCode)) {
      digits = digits.substring(
        dialCode.length,
      );
    }

    return digits;
  }

  // ==========================================================================
  // FORMAT NATIONAL
  // ==========================================================================

  /// Formate un numéro national selon `formatGroups`.
  ///
  /// Exemple :
  ///
  /// 71200000
  ///
  /// devient :
  ///
  /// 71 20 00 00
  static String formatNational(
    String value,
    PhoneCountry country,
  ) {
    final String digits =
        normalizeNational(value);

    if (digits.isEmpty) {
      return '';
    }

    if (country.formatGroups.isEmpty) {
      return digits;
    }

    final List<String> groups =
        <String>[];

    int offset = 0;

    for (final int groupLength
        in country.formatGroups) {
      if (offset >= digits.length) {
        break;
      }

      final int end =
          (offset + groupLength)
              .clamp(
        0,
        digits.length,
      );

      groups.add(
        digits.substring(
          offset,
          end,
        ),
      );

      offset = end;
    }

    // Si des chiffres restent après les
    // groupes définis, on les conserve.
    if (offset < digits.length) {
      groups.add(
        digits.substring(offset),
      );
    }

    return groups.join(' ');
  }

  // ==========================================================================
  // FORMAT INTERNATIONAL
  // ==========================================================================

  /// Formate un numéro avec son indicatif.
  ///
  /// Exemple :
  ///
  /// +226 71 20 00 00
  static String formatInternational(
    String value,
    PhoneCountry country,
  ) {
    final String national =
        formatNational(
      removeDialCode(
        value,
        country,
      ),
      country,
    );

    if (national.isEmpty) {
      return country.dialCode;
    }

    return '${country.dialCode} $national';
  }

  // ==========================================================================
  // LIMIT
  // ==========================================================================

  /// Limite le numéro au nombre maximal de chiffres autorisés.
  static String limitDigits(
    String value,
    PhoneCountry country,
  ) {
    final String digits =
        normalizeNational(value);

    final int max =
        country.maxNationalDigits;

    if (max <= 0) {
      return digits;
    }

    if (digits.length <= max) {
      return digits;
    }

    return digits.substring(
      0,
      max,
    );
  }

  // ==========================================================================
  // VALIDATE LENGTH
  // ==========================================================================

  /// Vérifie la longueur du numéro.
  static bool hasValidLength(
    String value,
    PhoneCountry country,
  ) {
    final String digits =
        normalizeNational(value);

    return country.acceptsLength(
      digits.length,
    );
  }

  // ==========================================================================
  // VALIDATE PREFIX
  // ==========================================================================

  static bool hasValidPrefix(
    String value,
    PhoneCountry country,
  ) {
    return country.acceptsPrefix(
      value,
    );
  }

  // ==========================================================================
  // VALIDATE
  // ==========================================================================

  /// Validation complète.
  ///
  /// Retourne null si le numéro est valide.
  /// Retourne un message sinon.
  static String? validate(
    String? value,
    PhoneCountry country, {
    String emptyMessage =
        'Veuillez saisir votre numéro',
    String lengthMessage =
        'Le numéro n’a pas une longueur valide',
    String prefixMessage =
        'Le préfixe du numéro n’est pas valide',
  }) {
    final String digits =
        normalizeNational(
      value ?? '',
    );

    if (digits.isEmpty) {
      return emptyMessage;
    }

    if (!hasValidLength(
      digits,
      country,
    )) {
      return lengthMessage;
    }

    if (!hasValidPrefix(
      digits,
      country,
    )) {
      return prefixMessage;
    }

    return null;
  }

  // ==========================================================================
  // EXAMPLE
  // ==========================================================================

  /// Retourne l'exemple configuré du pays.
  static String example(
    PhoneCountry country,
  ) {
    if (country.example != null &&
        country.example!.trim().isNotEmpty) {
      return country.example!;
    }

    return country.effectivePlaceholder;
  }
}

