
import 'package:flutter/foundation.dart';

/// ============================================================================
/// ZONE
/// ============================================================================
///
/// Une zone représente un secteur géographique dans lequel un ou plusieurs
/// programmes ou biens immobiliers peuvent être proposés.
///
/// IMPORTANT :
/// Une zone peut être proposée par une ou plusieurs sociétés immobilières.
///
/// La relation entre [Zone] et les sociétés immobilières est une relation
/// plusieurs-à-plusieurs.
///
/// Exemple :
///
/// BASSINKO
///   ├── Société immobilière A
///   ├── Société immobilière B
///   └── Société immobilière C
///
/// Et inversement :
///
/// Société immobilière A
///   ├── BASSINKO
///   ├── BOASSA
///   └── SAABA
///
/// Cette relation sera gérée par un modèle de liaison [ZoneSociete]
/// et non directement dans cette classe.
///
/// Une zone peut être utilisée aussi bien pour les demandes immobilières
/// que pour les biens réellement disponibles.
///
@immutable
class Zone {
  final String zoneId;
  final String code;
  final String name;

  final String? description;

  /// Indique si la zone est actuellement active.
  final bool active;

  /// Position d'affichage de la zone dans les listes.
  final int order;

  const Zone({
    required this.zoneId,
    required this.code,
    required this.name,
    this.description,
    this.active = true,
    this.order = 0,
  });

  // ==========================================================================
  // HELPERS
  // ==========================================================================

  /// Retourne une copie de la zone avec les valeurs modifiées.
  Zone copyWith({
    String? zoneId,
    String? code,
    String? name,
    String? description,
    bool clearDescription = false,
    bool? active,
    int? order,
  }) {
    return Zone(
      zoneId: zoneId ?? this.zoneId,
      code: code ?? this.code,
      name: name ?? this.name,
      description:
          clearDescription ? null : (description ?? this.description),
      active: active ?? this.active,
      order: order ?? this.order,
    );
  }

  // ==========================================================================
  // JSON
  // ==========================================================================

  Map<String, dynamic> toJson() {
    return {
      'zoneId': zoneId,
      'code': code,
      'name': name,
      'description': description,
      'active': active,
      'order': order,
    };
  }

  factory Zone.fromJson(Map<String, dynamic> json) {
    return Zone(
      zoneId: _readString(json['zoneId']) ?? '',
      code: _readString(json['code']) ?? '',
      name: _readString(json['name']) ?? '',
      description: _readNullableString(json['description']),
      active: _readBool(
        json['active'],
        fallback: true,
      ),
      order: _readInt(
        json['order'],
        fallback: 0,
      ),
    );
  }

  // ==========================================================================
  // PARSING HELPERS
  // ==========================================================================

  static String? _readString(dynamic value) {
    if (value == null) return null;

    final result = value.toString().trim();

    return result.isEmpty ? null : result;
  }

  static String? _readNullableString(dynamic value) {
    return _readString(value);
  }

  static int _readInt(
    dynamic value, {
    int fallback = 0,
  }) {
    if (value is int) return value;

    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(
          value?.toString() ?? '',
        ) ??
        fallback;
  }

  static bool _readBool(
    dynamic value, {
    bool fallback = false,
  }) {
    if (value is bool) return value;

    if (value is num) {
      return value != 0;
    }

    final text = value?.toString().trim().toLowerCase();

    switch (text) {
      case 'true':
      case '1':
      case 'yes':
      case 'oui':
        return true;

      case 'false':
      case '0':
      case 'no':
      case 'non':
        return false;

      default:
        return fallback;
    }
  }

  // ==========================================================================
  // EQUALITY
  // ==========================================================================

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Zone &&
            other.zoneId == zoneId &&
            other.code == code &&
            other.name == name &&
            other.description == description &&
            other.active == active &&
            other.order == order;
  }

  @override
  int get hashCode {
    return Object.hash(
      zoneId,
      code,
      name,
      description,
      active,
      order,
    );
  }

  // ==========================================================================
  // DEBUG
  // ==========================================================================

  @override
  String toString() {
    return 'Zone('
        'zoneId: $zoneId, '
        'code: $code, '
        'name: $name, '
        'active: $active, '
        'order: $order'
        ')';
  }
}
