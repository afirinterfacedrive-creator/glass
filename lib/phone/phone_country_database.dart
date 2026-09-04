import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:universal_glass/phone/phone_country.dart';

abstract final class PhoneCountryDatabase {
  static const String assetPath='packages/universal_glass/assets/phone/phone_countries.json';
  static const String flagsAssetPath='assets/phone/flags';
  static const String packageName='universal_glass';
  static const String packageAssetPrefix='packages/universal_glass/';
  static List<PhoneCountry>? _cache;
  static Future<List<PhoneCountry>> load() async {
    if(_cache!=null){
      debugPrint('PHONE COUNTRY CACHE => ${_cache!.length} pays');
      return _cache!;
    }
    try{
      debugPrint('PHONE COUNTRY ASSET => $assetPath');
      final String jsonString=await rootBundle.loadString(assetPath);
      debugPrint('PHONE COUNTRY JSON => ${jsonString.length} caractères');
      final dynamic decoded=jsonDecode(jsonString);
      if(decoded is! List){
        throw const FormatException('phone_countries.json doit contenir une liste de pays.');
      }
      final List<PhoneCountry> countries=decoded.whereType<Map<String,dynamic>>().map(PhoneCountryDatabase._fromJson).toList(growable:false);
      if(countries.isEmpty){
        throw const FormatException('phone_countries.json ne contient aucun pays.');
      }
      _cache=List<PhoneCountry>.unmodifiable(countries);
      debugPrint('PHONE COUNTRY LOAD OK => ${countries.length} pays');
      final int countriesWithFlags=countries.where((PhoneCountry country)=>country.hasFlagAsset).length;
      debugPrint('PHONE COUNTRY FLAGS => $countriesWithFlags/${countries.length} pays avec drapeau');
      final int countriesWithOperators=countries.where((PhoneCountry country)=>country.operatorsDetailed.isNotEmpty).length;
      debugPrint('PHONE COUNTRY OPERATORS => $countriesWithOperators/${countries.length} pays avec opérateurs détaillés');
      if(countries.isNotEmpty){
        final PhoneCountry first=countries.first;
        debugPrint('PHONE COUNTRY FIRST => ${first.isoCode} | ${first.name} | ${first.dialCode} | ${first.flagAsset}');
      }
      return _cache!;
    }catch(e,stackTrace){
      debugPrint('PHONE COUNTRY LOAD ERROR => $e');
      debugPrintStack(stackTrace:stackTrace);
      rethrow;
    }
  }
  static PhoneCountry _fromJson(Map<String,dynamic> json){
    final String isoCode=_requiredString(json,'isoCode').toUpperCase();
    final String flag=_requiredString(json,'flag');
    final String? jsonFlagAsset=_nullableString(json['flagAsset']);
    final String flagAsset=jsonFlagAsset!=null?_normalizeFlagAssetPath(jsonFlagAsset):flagAssetForIso(isoCode);
    final List<String> operators=_stringList(json['operators']);
    final List<dynamic> operatorsJson=json['operators'] is List?json['operators']:const[];
    final List<PhoneOperator> operatorsDetailed=operatorsJson.whereType<Map<String,dynamic>>().map(PhoneOperator.fromJson).toList(growable:false);
    final List<PhoneOperator> finalOperatorsDetailed=operatorsDetailed.isNotEmpty?operatorsDetailed:operators.map((name)=>PhoneOperator(id:name,name:name,shortName:name,prefixes:const[],colorHex:'#888')).toList();
    return PhoneCountry(
      isoCode:isoCode,
      name:_requiredString(json,'name'),
      flag:flag,
      flagAsset:flagAsset,
      dialCode:_requiredString(json,'dialCode'),
      nationalDigits:_intList(json['nationalDigits']),
      formatGroups:_intList(json['formatGroups']),
      prefixes:_stringList(json['prefixes']),
      operators:operators,
      operatorsDetailed:finalOperatorsDetailed,
      example:_nullableString(json['example']),
      placeholder:_nullableString(json['placeholder']),
    );
  }
  static String _normalizeFlagAssetPath(String path){
    String normalized=path.trim();
    if(normalized.isEmpty)return'';
    normalized=normalized.replaceAll(r'\','/');
    normalized=normalized.replaceFirst(RegExp(r'^/+'),'');
    if(normalized.startsWith(packageAssetPrefix)){
      normalized=normalized.substring(packageAssetPrefix.length);
    }
    if(normalized.startsWith('assets/'))return normalized;
    if(normalized.startsWith('phone/'))return'assets/$normalized';
    if(normalized.startsWith('flags/'))return'assets/phone/$normalized';
    if(!normalized.contains('/'))return'$flagsAssetPath/$normalized';
    return normalized;
  }
  static String _requiredString(Map<String,dynamic> json,String key){
    final dynamic value=json[key];
    if(value is String&&value.trim().isNotEmpty)return value.trim();
    throw FormatException('Champ "$key" invalide dans phone_countries.json.');
  }
  static String? _nullableString(dynamic value){
    if(value is! String)return null;
    final String normalized=value.trim();
    if(normalized.isEmpty)return null;
    return normalized;
  }
  static List<int> _intList(dynamic value){
    if(value is! List)return const<int>[];
    return value.whereType<num>().map((num value)=>value.toInt()).where((int value)=>value>0).toList(growable:false);
  }
  static List<String> _stringList(dynamic value){
    if(value is! List)return const<String>[];
    return value.whereType<String>().map((String value)=>value.trim()).where((String value)=>value.isNotEmpty).toList(growable:false);
  }
  static void clearCache(){
    _cache=null;
    debugPrint('PHONE COUNTRY CACHE CLEARED');
  }
  static Future<List<PhoneCountry>> get defaultCountries=>load();
  static String flagAssetForIso(String isoCode){
    final String normalized=isoCode.trim().toLowerCase();
    if(normalized.isEmpty)return'';
    return'$flagsAssetPath/$normalized.png';
  }
}