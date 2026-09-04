
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:universal_glass/enums/glass_enums.dart';


/// ============================================================================
/// FORMATTEURS TEXTE UNIVERSAL GLASS
/// ============================================================================

class GlassTextFormatter {
  // ==========================================================================
  // TEXTE
  // ==========================================================================

  /// Transforme la première lettre de chaque mot en majuscule.
  static String toCapitalize(String text) {
    if (text.trim().isEmpty) {
      return text;
    }

    return text.split(' ').map((String word) {
      if (word.trim().isEmpty) {
        return '';
      }

      return '${word[0].toUpperCase()}'
          '${word.substring(1).toLowerCase()}';
    }).join(' ');
  }

  /// Applique une transformation de texte.
  static String format(
    String text,
    GlassTextCase textCase,
  ) {
    switch (textCase) {
      case GlassTextCase.uppercase:
        return text.toUpperCase();

      case GlassTextCase.lowercase:
        return text.toLowerCase();

      case GlassTextCase.capitalize:
        return toCapitalize(text);

      case GlassTextCase.trimSpace:
        return text.replaceAll(RegExp(r'\s+'), ' ').trim();

      case GlassTextCase.normal:
        return text;
    }
  }

  // ==========================================================================
  // CURRENCY
  // ==========================================================================

  /// Supprime tout sauf les chiffres.
  static String clearCurrencyString(String text) {
    return text.replaceAll(RegExp(r'[^\d]'), '');
  }

  /// Formate un nombre avec séparateur de milliers.
  ///
  /// Exemple :
  ///
  /// 1000000 -> 1 000 000
  static String formatToCurrency(
    String text, {
    String separator = ' ',
  }) {
    final String digits = clearCurrencyString(text);

    if (digits.isEmpty) {
      return '';
    }

    final int intValue = int.tryParse(digits) ?? 0;
    final String value = intValue.toString();

    final StringBuffer buffer = StringBuffer();

    for (int i = 0; i < value.length; i++) {
      if (i > 0 && (value.length - i) % 3 == 0) {
        buffer.write(separator);
      }

      buffer.write(value[i]);
    }

    return buffer.toString();
  }

  // ==========================================================================
  // PHONE
  // ==========================================================================

  /// Nettoie un numéro de téléphone.
  ///
  /// Exemple :
  ///
  /// "07 12 34 56 78" -> "0712345678"
  static String clearPhoneString(
    String text, {
    int? maxDigits,
  }) {
    String digits = text.replaceAll(RegExp(r'\D'), '');

    if (maxDigits != null &&
        maxDigits >= 0 &&
        digits.length > maxDigits) {
      digits = digits.substring(0, maxDigits);
    }

    return digits;
  }

  /// Formate les chiffres selon les groupes.
  ///
  /// Exemple :
  ///
  /// digits = 07123456
  /// groups = [2, 2, 2, 2]
  ///
  /// résultat :
  ///
  /// 07 12 34 56
  static String formatPhone(
    String text, {
    required List<int> groups,
    int? maxDigits,
    bool enabled = true,
  }) {
    String digits = clearPhoneString(
      text,
      maxDigits: maxDigits,
    );

    if (!enabled || digits.isEmpty) {
      return digits;
    }

    return _formatPhoneDigits(
      digits,
      groups,
    );
  }

  /// Version interne purement algorithmique.
  static String _formatPhoneDigits(
    String digits,
    List<int> groups,
  ) {
    if (digits.isEmpty) {
      return '';
    }

    final StringBuffer result = StringBuffer();

    int index = 0;

    for (final int groupSize in groups) {
      if (groupSize <= 0 || index >= digits.length) {
        continue;
      }

      final int end = min(
        index + groupSize,
        digits.length,
      );

      if (result.isNotEmpty) {
        result.write(' ');
      }

      result.write(
        digits.substring(index, end),
      );

      index = end;
    }

    // Sécurité si les groupes ne couvrent pas
    // tous les chiffres.
    if (index < digits.length) {
      if (result.isNotEmpty) {
        result.write(' ');
      }

      result.write(
        digits.substring(index),
      );
    }

    return result.toString();
  }

  // ==========================================================================
  // POSITION CURSEUR
  // ==========================================================================

  /// Compte les chiffres présents avant une position donnée.
  static int countDigitsBeforeCursor(
    String text,
    int cursorOffset,
  ) {
    final int safeOffset = cursorOffset.clamp(
      0,
      text.length,
    );

    int count = 0;

    for (int i = 0; i < safeOffset; i++) {
      if (_isDigit(text[i])) {
        count++;
      }
    }

    return count;
  }

  /// Calcule la position du curseur après formatage.
  ///
  /// Le curseur est positionné après le même nombre de chiffres
  /// qu'avant le formatage.
  static int calculateCursorPosition({
    required String formatted,
    required int digitCountBeforeCursor,
  }) {
    if (digitCountBeforeCursor <= 0) {
      return 0;
    }

    int foundDigits = 0;

    for (int i = 0; i < formatted.length; i++) {
      if (_isDigit(formatted[i])) {
        foundDigits++;

        if (foundDigits >= digitCountBeforeCursor) {
          return i + 1;
        }
      }
    }

    return formatted.length;
  }

  static bool _isDigit(String character) {
    return character.codeUnitAt(0) >= 48 &&
        character.codeUnitAt(0) <= 57;
  }

  // ==========================================================================
  // INPUT FORMATTERS
  // ==========================================================================

  /// Majuscules en temps réel.
  static TextInputFormatter get uppercaseFormatter =>
      TextInputFormatter.withFunction(
        (TextEditingValue oldValue, TextEditingValue newValue) {
          return newValue.copyWith(
            text: newValue.text.toUpperCase(),
          );
        },
      );

  /// Minuscules en temps réel.
  static TextInputFormatter get lowercaseFormatter =>
      TextInputFormatter.withFunction(
        (TextEditingValue oldValue, TextEditingValue newValue) {
          return newValue.copyWith(
            text: newValue.text.toLowerCase(),
          );
        },
      );

  /// Capitalisation en temps réel.
  static TextInputFormatter get capitalizeFormatter =>
      TextInputFormatter.withFunction(
        (TextEditingValue oldValue, TextEditingValue newValue) {
          return newValue.copyWith(
            text: toCapitalize(newValue.text),
          );
        },
      );

  /// Formatter email.
  static TextInputFormatter get emailFormatter =>
      FilteringTextInputFormatter.allow(
        RegExp(r'[a-zA-Z0-9@._\-+]'),
      );

  /// Formatter mot de passe.
  static TextInputFormatter get passwordFormatter =>
      FilteringTextInputFormatter.deny(
        RegExp(r'\s'),
      );

  // ==========================================================================
  // CURRENCY FORMATTER
  // ==========================================================================

  static TextInputFormatter currencyFormatter({
    String separator = ' ',
  }) {
    return TextInputFormatter.withFunction(
      (
        TextEditingValue oldValue,
        TextEditingValue newValue,
      ) {
        if (newValue.text.isEmpty) {
          return const TextEditingValue();
        }

        final int digitsBeforeCursor =
            countDigitsBeforeCursor(
          newValue.text,
          newValue.selection.baseOffset,
        );

        final String formattedText =
            formatToCurrency(
          newValue.text,
          separator: separator,
        );

        final int cursorPosition =
            calculateCursorPosition(
          formatted: formattedText,
          digitCountBeforeCursor:
              digitsBeforeCursor,
        );

        return TextEditingValue(
          text: formattedText,
          selection: TextSelection.collapsed(
            offset: cursorPosition,
          ),
          composing: TextRange.empty,
        );
      },
    );
  }

  // ==========================================================================
  // PHONE FORMATTER
  // ==========================================================================

  /// Formatter téléphone Universal Glass.
  ///
  /// Cette méthode remplace complètement
  /// `_GlassPhoneInputFormatter`.
  ///
  /// Exemple :
  ///
  /// groups = [2, 2, 2, 2]
  ///
  /// 07123456
  /// devient
  /// 07 12 34 56
  ///
  /// Le curseur est recalculé à partir du nombre réel
  /// de chiffres avant le curseur.
static TextInputFormatter phoneFormatter({
  required List<int> groups,
  int? maxDigits,
}) {
  return TextInputFormatter.withFunction(
    (
      TextEditingValue oldValue,
      TextEditingValue newValue,
    ) {
      if (newValue.text.isEmpty) {
        return const TextEditingValue(
          text: '',
          selection: TextSelection.collapsed(offset: 0),
          composing: TextRange.empty,
        );
      }

      // ----------------------------------------------------------------------
      // 1. POSITION BRUTE FOURNIE PAR FLUTTER
      // ----------------------------------------------------------------------

      int rawOffset = newValue.selection.baseOffset;

      if (rawOffset < 0) {
        rawOffset = newValue.text.length;
      }

      rawOffset = rawOffset.clamp(
        0,
        newValue.text.length,
      );

      // ----------------------------------------------------------------------
      // 2. NOMBRE DE CHIFFRES AVANT LE CURSEUR
      // ----------------------------------------------------------------------

      int digitsBeforeCursor =
          countDigitsBeforeCursor(
        newValue.text,
        rawOffset,
      );

      // ----------------------------------------------------------------------
      // 3. EXTRACTION DES CHIFFRES
      // ----------------------------------------------------------------------

      String digits = clearPhoneString(
        newValue.text,
        maxDigits: maxDigits,
      );

      digitsBeforeCursor = digitsBeforeCursor.clamp(
        0,
        digits.length,
      );

      // ----------------------------------------------------------------------
      // 4. FORMATAGE
      // ----------------------------------------------------------------------

      final String formatted =
          _formatPhoneDigits(
        digits,
        groups,
      );

      // ----------------------------------------------------------------------
      // 5. POSITION LOGIQUE DU CURSEUR
      // ----------------------------------------------------------------------

      int cursorPosition =
          calculateCursorPosition(
        formatted: formatted,
        digitCountBeforeCursor:
            digitsBeforeCursor,
      );

      cursorPosition = cursorPosition.clamp(
        0,
        formatted.length,
      );

      return TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(
          offset: cursorPosition,
        ),
        composing: TextRange.empty,
      );
    },
  );
}
}
/// ============================================================================
/// SEARCH ENGINE
/// ============================================================================

class GlassSearchEngine {
  static List<String> filterSuggestions({
    required String query,
    required List<String> candidates,
    int maxResults = 5,
  }) {
    if (query.trim().isEmpty) {
      return const [];
    }

    final String cleanQuery =
        query.toLowerCase().trim();

    return candidates
        .where(
          (String element) =>
              element.toLowerCase().contains(
                    cleanQuery,
                  ),
        )
        .take(maxResults)
        .toList();
  }

  static List<T> filterCustomObjects<T>({
    required String query,
    required List<T> candidates,
    required String Function(T object)
        searchFieldExtractor,
    int maxResults = 5,
  }) {
    if (query.trim().isEmpty) {
      return const [];
    }

    final String cleanQuery =
        query.toLowerCase().trim();

    return candidates
        .where(
          (T element) =>
              searchFieldExtractor(element)
                  .toLowerCase()
                  .contains(cleanQuery),
        )
        .take(maxResults)
        .toList();
  }
}

/// ============================================================================
/// STRING EXTENSION
/// ============================================================================

extension GlassStringExtension on String {
  String get toGlassCapitalize =>
      GlassTextFormatter.toCapitalize(this);

  String get toGlassTrimSpace =>
      replaceAll(RegExp(r'\s+'), ' ').trim();

  String get toGlassCleanCurrency =>
      GlassTextFormatter.clearCurrencyString(this);

  String get toGlassCurrencyFormat =>
      GlassTextFormatter.formatToCurrency(this);

  String toGlassPhoneFormat({
    required List<int> groups,
    int? maxDigits,
  }) {
    return GlassTextFormatter.formatPhone(
      this,
      groups: groups,
      maxDigits: maxDigits,
    );
  }

  bool get isValidGlassEmail {
    return RegExp(
      r'^[\w\-.]+@([\w-]+\.)+[\w-]{2,4}$',
    ).hasMatch(this);
  }
}
