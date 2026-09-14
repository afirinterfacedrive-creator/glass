
import 'package:flutter/foundation.dart';

/// Type de bien immobilier.
///
/// Le type décrit les caractéristiques de référence d'un bien :
/// nombre de pièces, surfaces, chambres, sanitaires, cuisine, etc.
///
/// Les valeurs peuvent être chargées depuis le JSON local ou
/// synchronisées avec Google Sheets via GAS.
@immutable
class PropertyType {
  // ===========================================================================
  // IDENTIFICATION
  // ===========================================================================

  /// Identifiant technique unique.
  ///
  /// Exemple : `villa_f2`.
  final String typeId;

  /// Code métier stable.
  ///
  /// Exemple : `VILLA_F2`.
  final String code;

  /// Nom affiché dans l'interface.
  ///
  /// Exemple : `Villa F2`.
  final String name;

  // ===========================================================================
  // CARACTÉRISTIQUES GÉNÉRALES
  // ===========================================================================

  /// Nombre total de pièces.
  ///
  /// Pour une F2 : 2.
  /// Pour une F3 : 3.
  final int rooms;

  // ===========================================================================
  // PRIX DE RÉFÉRENCE
  // ===========================================================================

  /// Prix minimum de référence en FCFA.
  final double priceMin;

  /// Prix maximum de référence en FCFA.
  final double priceMax;

  // ===========================================================================
  // SURFACES
  // ===========================================================================

  /// Surface minimale / de référence du terrain en m².
  final double landArea;

  /// Surface bâtie en m².
  final double builtArea;

  // ===========================================================================
  // COMPOSITION
  // ===========================================================================

  /// Nombre de chambres.
  final int bedrooms;

  /// Nombre de salons.
  final int livingRooms;

  /// Nombre de toilettes / salles d'eau.
  final int bathrooms;

  /// Indique si la cuisine est extérieure.
  final bool externalKitchen;

  // ===========================================================================
  // ÉTAT DU RÉFÉRENTIEL
  // ===========================================================================

  /// Permet de désactiver un type sans le supprimer.
  final bool active;

  /// Position d'affichage dans les listes.
  final int order;

  // ===========================================================================
  // CONSTRUCTOR
  // ===========================================================================

  const PropertyType({
    required this.typeId,
    required this.code,
    required this.name,
    required this.rooms,
    required this.priceMin,
    required this.priceMax,
    required this.landArea,
    required this.builtArea,
    required this.bedrooms,
    required this.livingRooms,
    required this.bathrooms,
    required this.externalKitchen,
    this.active = true,
    this.order = 0,
  });

  // ===========================================================================
  // COPY WITH
  // ===========================================================================

  PropertyType copyWith({
    String? typeId,
    String? code,
    String? name,
    int? rooms,
    double? priceMin,
    double? priceMax,
    double? landArea,
    double? builtArea,
    int? bedrooms,
    int? livingRooms,
    int? bathrooms,
    bool? externalKitchen,
    bool? active,
    int? order,
  }) {
    return PropertyType(
      typeId: typeId ?? this.typeId,
      code: code ?? this.code,
      name: name ?? this.name,
      rooms: rooms ?? this.rooms,
      priceMin: priceMin ?? this.priceMin,
      priceMax: priceMax ?? this.priceMax,
      landArea: landArea ?? this.landArea,
      builtArea: builtArea ?? this.builtArea,
      bedrooms: bedrooms ?? this.bedrooms,
      livingRooms: livingRooms ?? this.livingRooms,
      bathrooms: bathrooms ?? this.bathrooms,
      externalKitchen: externalKitchen ?? this.externalKitchen,
      active: active ?? this.active,
      order: order ?? this.order,
    );
  }

  // ===========================================================================
  // JSON
  // ===========================================================================

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'typeId': typeId,
      'code': code,
      'name': name,
      'rooms': rooms,
      'priceMin': priceMin,
      'priceMax': priceMax,
      'landArea': landArea,
      'builtArea': builtArea,
      'bedrooms': bedrooms,
      'livingRooms': livingRooms,
      'bathrooms': bathrooms,
      'externalKitchen': externalKitchen,
      'active': active,
      'order': order,
    };
  }

  // ===========================================================================
  // FROM JSON
  // ===========================================================================

  factory PropertyType.fromJson(Map<String, dynamic> json) {
    return PropertyType(
      typeId: _readString(
        json,
        'typeId',
      ),
      code: _readString(
        json,
        'code',
      ),
      name: _readString(
        json,
        'name',
      ),
      rooms: _readInt(
        json,
        'rooms',
        0,
      ),
      priceMin: _readDouble(
        json,
        'priceMin',
        0.0,
      ),
      priceMax: _readDouble(
        json,
        'priceMax',
        0.0,
      ),
      landArea: _readDouble(
        json,
        'landArea',
        0.0,
      ),
      builtArea: _readDouble(
        json,
        'builtArea',
        0.0,
      ),
      bedrooms: _readInt(
        json,
        'bedrooms',
        0,
      ),
      livingRooms: _readInt(
        json,
        'livingRooms',
        0,
      ),
      bathrooms: _readInt(
        json,
        'bathrooms',
        0,
      ),
      externalKitchen: _readBool(
        json,
        'externalKitchen',
        false,
      ),
      active: _readBool(
        json,
        'active',
        true,
      ),
      order: _readInt(
        json,
        'order',
        0,
      ),
    );
  }

  // ===========================================================================
  // JSON HELPERS
  // ===========================================================================

  static String _readString(
    Map<String, dynamic> json,
    String key,
  ) {
    final dynamic value = json[key];

    if (value is String) {
      return value;
    }

    return '';
  }

  static int _readInt(
    Map<String, dynamic> json,
    String key,
    int fallback,
  ) {
    final dynamic value = json[key];

    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    if (value is String) {
      return int.tryParse(value) ?? fallback;
    }

    return fallback;
  }

  static double _readDouble(
    Map<String, dynamic> json,
    String key,
    double fallback,
  ) {
    final dynamic value = json[key];

    if (value is num) {
      final double result = value.toDouble();

      if (result.isFinite) {
        return result;
      }
    }

    if (value is String) {
      final double? result = double.tryParse(value);

      if (result != null && result.isFinite) {
        return result;
      }
    }

    return fallback;
  }

  static bool _readBool(
    Map<String, dynamic> json,
    String key,
    bool fallback,
  ) {
    final dynamic value = json[key];

    if (value is bool) {
      return value;
    }

    if (value is String) {
      switch (value.toLowerCase().trim()) {
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
      }
    }

    if (value is num) {
      return value != 0;
    }

    return fallback;
  }

  // ===========================================================================
  // EQUALITY
  // ===========================================================================

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is PropertyType &&
            other.typeId == typeId &&
            other.code == code &&
            other.name == name &&
            other.rooms == rooms &&
            other.priceMin == priceMin &&
            other.priceMax == priceMax &&
            other.landArea == landArea &&
            other.builtArea == builtArea &&
            other.bedrooms == bedrooms &&
            other.livingRooms == livingRooms &&
            other.bathrooms == bathrooms &&
            other.externalKitchen == externalKitchen &&
            other.active == active &&
            other.order == order;
  }

  @override
  int get hashCode {
    return Object.hash(
      typeId,
      code,
      name,
      rooms,
      priceMin,
      priceMax,
      landArea,
      builtArea,
      bedrooms,
      livingRooms,
      bathrooms,
      externalKitchen,
      active,
      order,
    );
  }

  // ===========================================================================
  // DEBUG
  // ===========================================================================

  @override
  String toString() {
    return 'PropertyType('
        'typeId: $typeId, '
        'code: $code, '
        'name: $name, '
        'rooms: $rooms, '
        'priceMin: $priceMin, '
        'priceMax: $priceMax, '
        'active: $active'
        ')';
  }
}
