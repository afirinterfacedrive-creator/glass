// ignore: dangling_library_doc_comments
/// ============================================================================
/// PHONE COUNTRY
///
/// Configuration téléphonique d'un pays.
///
/// Cette classe ne dépend d'aucun widget Flutter.
/// ============================================================================

import 'package:flutter/material.dart';

/// ============================================================================
/// PHONE OPERATOR
/// ============================================================================

class PhoneOperator {
  final String id;
  final String name;
  final String shortName;
  final List<String> prefixes;
  final String colorHex;
  
  const PhoneOperator({required this.id, required this.name, required this.shortName, required this.prefixes, required this.colorHex});
  
  factory PhoneOperator.fromJson(Map<String, dynamic> json) {
    return PhoneOperator(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      shortName: json['shortName'] as String? ?? json['name'] as String? ?? '',
      prefixes: _stringList(json['prefixes']),
      colorHex: json['color'] as String? ?? '#888',
    );
  }
  
  static List<String> _stringList(dynamic value) {
    if (value is! List) return const <String>[];
    return value.whereType<String>().map((String value) => value.trim()).where((String value) => value.isNotEmpty).toList(growable: false);
  }
  
  Color get color => Color(int.parse(colorHex.replaceFirst('#', '0xFF')));
}

class PhoneCountry {
  final String isoCode;
  final String name;
  final String flag;
  final String? flagAsset;
  final String dialCode;
  final List<int> nationalDigits;
  final List<int> formatGroups;
  final List<String> prefixes;
  final List<String> operators;
  final List<PhoneOperator> operatorsDetailed;
  final String? example;
  final String? placeholder;

  const PhoneCountry({
    required this.isoCode,
    required this.name,
    required this.flag,
    required this.dialCode,
    required this.nationalDigits,
    required this.formatGroups,
    this.prefixes = const <String>[],
    this.operators = const <String>[],
    this.operatorsDetailed = const <PhoneOperator>[],
    this.flagAsset,
    this.example,
    this.placeholder,
  });

  int get maxNationalDigits {
    if (nationalDigits.isEmpty) return 0;
    return nationalDigits.reduce((int a, int b) => a > b ? a : b);
  }

  int get minNationalDigits {
    if (nationalDigits.isEmpty) return 0;
    return nationalDigits.reduce((int a, int b) => a < b ? a : b);
  }

  int get phoneDigits => maxNationalDigits;

  bool acceptsLength(int length) {
    return nationalDigits.contains(length);
  }

  bool acceptsPrefix(String phone) {
    if (prefixes.isEmpty) return true;
    final String digits = phone.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) return false;
    return prefixes.any((String prefix) => digits.startsWith(prefix));
  }

  String get effectivePlaceholder {
    if (placeholder != null && placeholder!.trim().isNotEmpty) return placeholder!;
    if (formatGroups.isEmpty) return '';
    return formatGroups.map((int length) => '0' * length).join(' ');
  }

  bool get hasFlagAsset {
    final String? asset = flagAsset;
    return asset != null && asset.trim().isNotEmpty;
  }

  String get effectiveFlagAsset {
    if (hasFlagAsset) return flagAsset!.replaceFirst('packages/universal_glass/', '');
    return 'assets/phone/flags/${isoCode.toLowerCase()}.png';
  }

  bool get hasOperatorsDetailed => operatorsDetailed.isNotEmpty;

  PhoneOperator? operatorForPrefix(String digits) {
    if (digits.length < 2) return null;
    final String p2 = digits.substring(0, 2);
    for (final op in operatorsDetailed) {
      if (op.prefixes.contains(p2)) return op;
    }
    return null;
  }

  factory PhoneCountry.fromJson(Map<String, dynamic> json) {
    final List<String> operators = _stringList(json['operators']);
    final List<dynamic> operatorsJson = json['operators'] is List ? json['operators'] : const [];
    final List<PhoneOperator> operatorsDetailed = operatorsJson.whereType<Map<String, dynamic>>().map(PhoneOperator.fromJson).toList(growable: false);
    final List<PhoneOperator> finalOperatorsDetailed = operatorsDetailed.isNotEmpty ? operatorsDetailed : operators.map((name) => PhoneOperator(id: name, name: name, shortName: name, prefixes: const [], colorHex: '#888')).toList();
    return PhoneCountry(
      isoCode: json['isoCode'] as String,
      name: json['name'] as String,
      flag: json['flag'] as String,
      flagAsset: json['flagAsset'] as String?,
      dialCode: json['dialCode'] as String,
      nationalDigits: (json['nationalDigits'] as List<dynamic>).whereType<num>().map((num value) => value.toInt()).toList(growable: false),
      formatGroups: (json['formatGroups'] as List<dynamic>).whereType<num>().map((num value) => value.toInt()).toList(growable: false),
      prefixes: _stringList(json['prefixes']),
      operators: operators,
      operatorsDetailed: finalOperatorsDetailed,
      example: json['example'] as String?,
      placeholder: json['placeholder'] as String?,
    );
  }

  static List<String> _stringList(dynamic value) {
    if (value is! List) return const <String>[];
    return value.whereType<String>().map((String value) => value.trim()).where((String value) => value.isNotEmpty).toList(growable: false);
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'isoCode': isoCode,
      'name': name,
      'flag': flag,
      'flagAsset': flagAsset,
      'dialCode': dialCode,
      'nationalDigits': nationalDigits,
      'formatGroups': formatGroups,
      'prefixes': prefixes,
      'operators': operators,
      'example': example,
      'placeholder': placeholder,
    };
  }

  PhoneCountry copyWith({
    String? isoCode,
    String? name,
    String? flag,
    String? flagAsset,
    String? dialCode,
    List<int>? nationalDigits,
    List<int>? formatGroups,
    List<String>? prefixes,
    List<String>? operators,
    List<PhoneOperator>? operatorsDetailed,
    String? example,
    String? placeholder,
  }) {
    return PhoneCountry(
      isoCode: isoCode ?? this.isoCode,
      name: name ?? this.name,
      flag: flag ?? this.flag,
      flagAsset: flagAsset ?? this.flagAsset,
      dialCode: dialCode ?? this.dialCode,
      nationalDigits: nationalDigits ?? this.nationalDigits,
      formatGroups: formatGroups ?? this.formatGroups,
      prefixes: prefixes ?? this.prefixes,
      operators: operators ?? this.operators,
      operatorsDetailed: operatorsDetailed ?? this.operatorsDetailed,
      example: example ?? this.example,
      placeholder: placeholder ?? this.placeholder,
    );
  }

  @override
  String toString() {
    return 'PhoneCountry(isoCode: $isoCode, name: $name, dialCode: $dialCode, nationalDigits: $nationalDigits, operators: $operators)';
  }
}