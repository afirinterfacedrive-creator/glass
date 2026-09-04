// ignore_for_file: prefer_initializing_formals

import 'dart:convert';
import 'package:flutter/services.dart';
import 'phone_country.dart';
import 'phone_country_database.dart';

/// ============================================================================
/// PHONE COUNTRY REGISTRY
/// ============================================================================
/// Registre centralisé des pays téléphoniques de Universal Glass.
/// Utilise PhoneCountryDatabase si dispo, sinon fallback sur asset direct.
/// ============================================================================

class PhoneCountryRegistry {
  static const String assetPath='packages/universal_glass/assets/phone/phone_countries.json';
  static Future<PhoneCountryRegistry>? _cachedLoad;
  final List<PhoneCountry> countries;
  const PhoneCountryRegistry(List<PhoneCountry> countries):countries=countries;

  /// Charge le registre. Priorité à PhoneCountryDatabase
  static Future<PhoneCountryRegistry> load(){
    return _cachedLoad??=_loadFromDatabaseOrAsset();
  }

  static Future<PhoneCountryRegistry> _loadFromDatabaseOrAsset() async {
    try{
      // 1. Tente via Database qui a le cache + opérateurs
      final List<PhoneCountry> dbCountries=await PhoneCountryDatabase.load();
      if(dbCountries.isNotEmpty){
        return PhoneCountryRegistry(List<PhoneCountry>.unmodifiable(dbCountries));
      }
    }catch(e){
      // fallback
    }
    // 2. Fallback direct JSON
    return _loadFromAsset();
  }

  static Future<PhoneCountryRegistry> _loadFromAsset() async {
    final String raw=await rootBundle.loadString(assetPath);
    if(raw.trim().isEmpty){
      throw const FormatException('Le fichier countries.json est vide.');
    }
    final dynamic decoded=jsonDecode(raw);
    if(decoded is! List){
      throw const FormatException('countries.json doit contenir un tableau JSON.');
    }
    final List<PhoneCountry> countries=<PhoneCountry>[];
    for(final dynamic item in decoded){
      if(item is! Map)continue;
      try{
        final Map<String,dynamic> map=Map<String,dynamic>.from(item);
        countries.add(PhoneCountry.fromJson(map));
      }catch(_){
        continue;
      }
    }
    if(countries.isEmpty){
      throw const FormatException('Aucun pays valide trouvé dans countries.json.');
    }
    return PhoneCountryRegistry(List<PhoneCountry>.unmodifiable(countries));
  }

  static void clearCache(){
    _cachedLoad=null;
    PhoneCountryDatabase.clearCache();
  }

  PhoneCountry? findByIsoCode(String? isoCode){
    if(isoCode==null)return null;
    final String normalized=isoCode.trim().toUpperCase();
    if(normalized.isEmpty)return null;
    for(final PhoneCountry country in countries){
      if(country.isoCode.trim().toUpperCase()==normalized)return country;
    }
    return null;
  }

  PhoneCountry? findByDialCode(String? dialCode){
    if(dialCode==null)return null;
    String normalized=dialCode.trim();
    if(normalized.isEmpty)return null;
    // ignore: prefer_interpolation_to_compose_strings
    if(!normalized.startsWith('+'))normalized='+'+normalized;
    for(final PhoneCountry country in countries){
      if(country.dialCode.trim()==normalized)return country;
    }
    return null;
  }

  /// Trouve le pays + opérateur à partir d'un numéro complet avec indicatif
  /// Ex: +22670123456 -> BF + Orange
  (PhoneCountry?,PhoneOperator?) findByFullNumber(String number){
    final String digits=number.replaceAll(RegExp(r'\D'), '');
    if(digits.isEmpty)return (null,null);
    for(final PhoneCountry country in countries){
      final String dial=country.dialCode.replaceAll(RegExp(r'\D'), '');
      if(digits.startsWith(dial)){
        final String national=digits.substring(dial.length);
        final PhoneOperator? op=country.operatorForPrefix(national);
        return (country,op);
      }
    }
    return (null,null);
  }

  List<PhoneCountry> search(String query){
    final String normalized=_normalizeSearch(query);
    if(normalized.isEmpty)return countries;
    final String compact=normalized.replaceAll(RegExp(r'\s+'), '');
    final List<PhoneCountry> result=<PhoneCountry>[];
    for(final PhoneCountry country in countries){
      if(_matchesCountry(country,normalized,compact))result.add(country);
    }
    return result;
  }

  bool _matchesCountry(PhoneCountry country,String query,String compactQuery){
    final String name=_normalizeSearch(country.name);
    final String iso=country.isoCode.trim().toLowerCase();
    final String dial=country.dialCode.trim().toLowerCase();
    if(name.contains(query))return true;
    if(iso.contains(query))return true;
    if(dial.contains(compactQuery))return true;
    for(final String prefix in country.prefixes){
      final String normalizedPrefix=prefix.trim().toLowerCase();
      if(normalizedPrefix.contains(compactQuery))return true;
    }
    final String dialCompact=dial.replaceAll(RegExp(r'[^0-9]'), '');
    if(dialCompact.contains(compactQuery))return true;
    return false;
  }

  String _normalizeSearch(String value){
    return value.trim().toLowerCase()
      .replaceAll(RegExp(r'[àáâãäå]'),'a')
      .replaceAll(RegExp(r'[èéêë]'),'e')
      .replaceAll(RegExp(r'[ìíîï]'),'i')
      .replaceAll(RegExp(r'[òóôõö]'),'o')
      .replaceAll(RegExp(r'[ùúûü]'),'u')
      .replaceAll(RegExp(r'[ç]'),'c');
  }

  PhoneCountry? first(){
    if(countries.isEmpty)return null;
    return countries.first;
  }

  /// Helper pour accès direct à la liste
  List<PhoneCountry> all()=>countries;
}