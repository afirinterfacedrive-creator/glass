import 'package:flutter/services.dart';
import 'dart:math';

/// Type de transformation de texte disponible dans le package Universal Glass
enum GlassTextCase { normal, uppercase, lowercase, capitalize, trimSpace }

class GlassTextFormatter {
  /// --------------------------------------------------------------------------
  /// 1. FONCTIONS STATIQUES (Pour formater une String directement en Dart)
  /// --------------------------------------------------------------------------

  /// Transforme la première lettre de chaque mot en majuscule (Capitalize)
  static String toCapitalize(String text) {
    if (text.trim().isEmpty) return text;
    return text.split(' ').map((word) {
      if (word.trim().isEmpty) return '';
      return '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}';
    }).join(' ');
  }

  /// Applique la transformation selon l'enum choisi
  static String format(String text, GlassTextCase textCase) {
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

  /// Nettoie une chaîne pour ne garder que la valeur numérique brute d'un montant
  static String clearCurrencyString(String text) {
    return text.replaceAll(RegExp(r'[^\d]'), '');
  }

  /// Formate un nombre brut avec séparateur de milliers (ex: 1000000 -> 1 000 000)
  static String formatToCurrency(String text, {String separator = ' '}) {
    String digits = clearCurrencyString(text);
    if (digits.isEmpty) return '';
    
    final intValue = int.tryParse(digits) ?? 0;
    final buffer = StringBuffer();
    final str = intValue.toString();
    
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) {
        buffer.write(separator);
      }
      buffer.write(str[i]);
    }
    return buffer.toString();
  }

  /// --------------------------------------------------------------------------
  /// 2. INPUT FORMATTERS (Pour formater en temps réel pendant la saisie clavier)
  /// --------------------------------------------------------------------------

  /// Force la saisie en MAJUSCULES en temps réel au clavier
  static TextInputFormatter get uppercaseFormatter =>
      TextInputFormatter.withFunction((oldValue, newValue) {
        return newValue.copyWith(text: newValue.text.toUpperCase());
      });

  /// Force la saisie en minuscules en temps réel au clavier
  static TextInputFormatter get lowercaseFormatter =>
      TextInputFormatter.withFunction((oldValue, newValue) {
        return newValue.copyWith(text: newValue.text.toLowerCase());
      });

  /// Force la capitalisation (Première lettre majuscule) en temps réel au clavier
  static TextInputFormatter get capitalizeFormatter =>
      TextInputFormatter.withFunction((oldValue, newValue) {
        return newValue.copyWith(text: toCapitalize(newValue.text));
      });

  /// NOUVEAU : Bloque la saisie d'espaces et force les caractères autorisés pour un Email
  static TextInputFormatter get emailFormatter =>
      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9@._\-\+]'));

  /// NOUVEAU : Supprime les caractères non sécurisés pour les mots de passe (ex: espaces si interdits, ou gestion brute)
  static TextInputFormatter get passwordFormatter =>
      FilteringTextInputFormatter.deny(RegExp(r'\s'));

  /// NOUVEAU : Formateur monétaire dynamique avec gestion parfaite du curseur lors des saisies/suppressions
  static TextInputFormatter currencyFormatter({String separator = ' '}) {
    return TextInputFormatter.withFunction((oldValue, newValue) {
      if (newValue.text.isEmpty) {
        return newValue.copyWith(text: '');
      }

      // 1. Récupération du texte formaté
      final String formattedText = formatToCurrency(newValue.text, separator: separator);
      
      // 2. Repositionnement intelligent du curseur (Prend en compte l'ajout/suppression des espaces)
      int cursorPosition = newValue.selection.end;
      int oldSpaces = oldValue.text.split(separator).length - 1;
      int newSpaces = formattedText.split(separator).length - 1;
      
      int spaceDifference = newSpaces - oldSpaces;
      int finalSelection = max(0, min(formattedText.length, cursorPosition + spaceDifference));

      return TextEditingValue(
        text: formattedText,
        selection: TextSelection.collapsed(offset: finalSelection),
      );
    });
  }
}

/// ----------------------------------------------------------------------------
/// 3. UTILITAIRE DE FILTRAGE / AUTO-COMPLÉTION (Pour ta TextBox de propositions)
/// ----------------------------------------------------------------------------
class GlassSearchEngine {
  /// Filtre une liste de suggestions en fonction de la saisie utilisateur (insensible à la casse)
  static List<String> filterSuggestions({
    required String query,
    required List<String> candidates,
    int maxResults = 5,
  }) {
    if (query.trim().isEmpty) return const [];
    
    final cleanQuery = query.toLowerCase().trim();
    
    return candidates
        .where((element) => element.toLowerCase().contains(cleanQuery))
        .take(maxResults)
        .toList();
  }

  /// Version générique pour filtrer des objets complexes (ex: classe Pays, Ville)
  static List<T> filterCustomObjects<T>({
    required String query,
    required List<T> candidates,
    required String Function(T object) searchFieldExtractor,
    int maxResults = 5,
  }) {
    if (query.trim().isEmpty) return const [];
    
    final cleanQuery = query.toLowerCase().trim();
    
    return candidates
        .where((element) => searchFieldExtractor(element).toLowerCase().contains(cleanQuery))
        .take(maxResults)
        .toList();
  }
}

/// ----------------------------------------------------------------------------
/// 4. EXTENSION DART (Permet de faire directement : myString.toGlassCapitalize)
/// ----------------------------------------------------------------------------
extension GlassStringExtension on String {
  String get toGlassCapitalize => GlassTextFormatter.toCapitalize(this);
  String get toGlassTrimSpace => replaceAll(RegExp(r'\s+'), ' ').trim();
  String get toGlassCleanCurrency => GlassTextFormatter.clearCurrencyString(this);
  String get toGlassCurrencyFormat => GlassTextFormatter.formatToCurrency(this);
  
  /// Validation rapide Regex pour l'UI Glass
  bool get isValidGlassEmail {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(this);
  }
}
