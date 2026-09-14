
import 'package:flutter/foundation.dart';

/// ============================================================================
/// PROPERTY STATUS
/// ============================================================================
///
/// État commercial d'un bien immobilier.
///
enum PropertyStatus {
  available,
  reserved,
  sold,
  rented,
  inactive,
}

/// ============================================================================
/// PROPERTY
/// ============================================================================
///
/// Représente un bien immobilier réel enregistré dans le système.
///
/// Contrairement à [PropertyRequest], qui représente la recherche ou le besoin
/// d'un client, [Property] représente un bien effectivement disponible,
/// réservé, vendu ou loué.
///
/// Les relations vers les autres modèles utilisent uniquement leurs IDs :
/// - [typeId]              -> PropertyType
/// - [zoneId]              -> Zone
/// - [companyId]           -> SocieteImmobiliere
/// - [finishIds]           -> Finish
///
/// Les données métier peuvent ensuite provenir de Google Sheets via
/// Google Apps Script sans que ce modèle dépende de cette infrastructure.
///
@immutable
class Property {
  // ==========================================================================
  // IDENTIFICATION
  // ==========================================================================

  final String propertyId;
  final String reference;

  // ==========================================================================
  // TYPE ET STATUT
  // ==========================================================================

  final String typeId;
  final PropertyStatus status;

  // ==========================================================================
  // INFORMATIONS GÉNÉRALES
  // ==========================================================================

  final String title;
  final String? description;

  // ==========================================================================
  // PRIX
  // ==========================================================================

  final double price;

  // ==========================================================================
  // SURFACES
  // ==========================================================================

  final double? landArea;
  final double? builtArea;

  // ==========================================================================
  // COMPOSITION
  // ==========================================================================

  final int? bedrooms;
  final int? livingRooms;
  final int? bathrooms;
  final bool? externalKitchen;
  final bool? socialHousing;

  // ==========================================================================
  // LOCALISATION
  // ==========================================================================

  final String zoneId;
  final String? address;
  final double? latitude;
  final double? longitude;

  // ==========================================================================
  // SOCIÉTÉ
  // ==========================================================================

  final String companyId;

  // ==========================================================================
  // FINITIONS
  // ==========================================================================

  final List<String> finishIds;

  // ==========================================================================
  // DISPONIBILITÉ
  // ==========================================================================

  final DateTime? availableFrom;

  // ==========================================================================
  // INFORMATIONS COMPLÉMENTAIRES
  // ==========================================================================

  final String? notes;

  // ==========================================================================
  // DATES
  // ==========================================================================

  final DateTime createdAt;
  final DateTime updatedAt;

  // ==========================================================================
  // CONSTRUCTOR
  // ==========================================================================

  const Property({
    required this.propertyId,
    required this.reference,
    required this.typeId,
    this.status = PropertyStatus.available,
    required this.title,
    this.description,
    required this.price,
    this.landArea,
    this.builtArea,
    this.bedrooms,
    this.livingRooms,
    this.bathrooms,
    this.externalKitchen,
    this.socialHousing,
    required this.zoneId,
    this.address,
    this.latitude,
    this.longitude,
    required this.companyId,
    this.finishIds = const <String>[],
    this.availableFrom,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  // ==========================================================================
  // GETTERS
  // ==========================================================================

  bool get isAvailable => status == PropertyStatus.available;

  bool get isReserved => status == PropertyStatus.reserved;

  bool get isSold => status == PropertyStatus.sold;

  bool get isRented => status == PropertyStatus.rented;

  bool get isInactive => status == PropertyStatus.inactive;

  bool get hasDescription =>
      description != null && description!.trim().isNotEmpty;

  bool get hasAddress => address != null && address!.trim().isNotEmpty;

  bool get hasCoordinates => latitude != null && longitude != null;

  bool get hasAvailableFrom => availableFrom != null;

  bool get hasFinishes => finishIds.isNotEmpty;

  bool get hasLandArea => landArea != null;

  bool get hasBuiltArea => builtArea != null;

  bool get hasBedrooms => bedrooms != null;

  bool get hasLivingRooms => livingRooms != null;

  bool get hasBathrooms => bathrooms != null;

  // ==========================================================================
  // COPY WITH
  // ==========================================================================

  Property copyWith({
    String? propertyId,
    String? reference,
    String? typeId,
    PropertyStatus? status,
    String? title,
    Object? description = _undefined,
    double? price,
    Object? landArea = _undefined,
    Object? builtArea = _undefined,
    Object? bedrooms = _undefined,
    Object? livingRooms = _undefined,
    Object? bathrooms = _undefined,
    Object? externalKitchen = _undefined,
    Object? socialHousing = _undefined,
    String? zoneId,
    Object? address = _undefined,
    Object? latitude = _undefined,
    Object? longitude = _undefined,
    String? companyId,
    List<String>? finishIds,
    Object? availableFrom = _undefined,
    Object? notes = _undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Property(
      propertyId: propertyId ?? this.propertyId,
      reference: reference ?? this.reference,
      typeId: typeId ?? this.typeId,
      status: status ?? this.status,
      title: title ?? this.title,
      description: identical(description, _undefined)
          ? this.description
          : description as String?,
      price: price ?? this.price,
      landArea: identical(landArea, _undefined)
          ? this.landArea
          : landArea as double?,
      builtArea: identical(builtArea, _undefined)
          ? this.builtArea
          : builtArea as double?,
      bedrooms: identical(bedrooms, _undefined)
          ? this.bedrooms
          : bedrooms as int?,
      livingRooms: identical(livingRooms, _undefined)
          ? this.livingRooms
          : livingRooms as int?,
      bathrooms: identical(bathrooms, _undefined)
          ? this.bathrooms
          : bathrooms as int?,
      externalKitchen: identical(externalKitchen, _undefined)
          ? this.externalKitchen
          : externalKitchen as bool?,
      socialHousing: identical(socialHousing, _undefined)
          ? this.socialHousing
          : socialHousing as bool?,
      zoneId: zoneId ?? this.zoneId,
      address: identical(address, _undefined)
          ? this.address
          : address as String?,
      latitude: identical(latitude, _undefined)
          ? this.latitude
          : latitude as double?,
      longitude: identical(longitude, _undefined)
          ? this.longitude
          : longitude as double?,
      companyId: companyId ?? this.companyId,
      finishIds: finishIds ?? this.finishIds,
      availableFrom: identical(availableFrom, _undefined)
          ? this.availableFrom
          : availableFrom as DateTime?,
      notes: identical(notes, _undefined) ? this.notes : notes as String?,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // ==========================================================================
  // JSON
  // ==========================================================================

  Map<String, dynamic> toJson() {
    return {
      'propertyId': propertyId,
      'reference': reference,
      'typeId': typeId,
      'status': status.name,
      'title': title,
      'description': description,
      'price': price,
      'landArea': landArea,
      'builtArea': builtArea,
      'bedrooms': bedrooms,
      'livingRooms': livingRooms,
      'bathrooms': bathrooms,
      'externalKitchen': externalKitchen,
      'socialHousing': socialHousing,
      'zoneId': zoneId,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'companyId': companyId,
      'finishIds': List<String>.from(finishIds),
      'availableFrom': availableFrom?.toUtc().toIso8601String(),
      'notes': notes,
      'createdAt': createdAt.toUtc().toIso8601String(),
      'updatedAt': updatedAt.toUtc().toIso8601String(),
    };
  }

  factory Property.fromJson(Map<String, dynamic> json) {
    final now = DateTime.now().toUtc();

    return Property(
      propertyId: _string(json['propertyId']),
      reference: _string(json['reference']),
      typeId: _string(json['typeId']),
      status: _propertyStatusFromJson(json['status']),
      title: _string(json['title']),
      description: _nullableString(json['description']),
      price: _double(json['price']),
      landArea: _nullableDouble(json['landArea']),
      builtArea: _nullableDouble(json['builtArea']),
      bedrooms: _nullableInt(json['bedrooms']),
      livingRooms: _nullableInt(json['livingRooms']),
      bathrooms: _nullableInt(json['bathrooms']),
      externalKitchen: _nullableBool(json['externalKitchen']),
      socialHousing: _nullableBool(json['socialHousing']),
      zoneId: _string(json['zoneId']),
      address: _nullableString(json['address']),
      latitude: _nullableDouble(json['latitude']),
      longitude: _nullableDouble(json['longitude']),
      companyId: _string(json['companyId']),
      finishIds: _stringList(json['finishIds']),
      availableFrom: _nullableDateTime(json['availableFrom']),
      notes: _nullableString(json['notes']),
      createdAt: _nullableDateTime(json['createdAt']) ?? now,
      updatedAt: _nullableDateTime(json['updatedAt']) ?? now,
    );
  }

  // ==========================================================================
  // FACTORY CREATE
  // ==========================================================================

  factory Property.create({
    required String propertyId,
    required String reference,
    required String typeId,
    PropertyStatus status = PropertyStatus.available,
    required String title,
    String? description,
    required double price,
    double? landArea,
    double? builtArea,
    int? bedrooms,
    int? livingRooms,
    int? bathrooms,
    bool? externalKitchen,
    bool? socialHousing,
    required String zoneId,
    String? address,
    double? latitude,
    double? longitude,
    required String companyId,
    List<String> finishIds = const <String>[],
    DateTime? availableFrom,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    final now = DateTime.now().toUtc();

    return Property(
      propertyId: propertyId,
      reference: reference,
      typeId: typeId,
      status: status,
      title: title,
      description: description,
      price: price,
      landArea: landArea,
      builtArea: builtArea,
      bedrooms: bedrooms,
      livingRooms: livingRooms,
      bathrooms: bathrooms,
      externalKitchen: externalKitchen,
      socialHousing: socialHousing,
      zoneId: zoneId,
      address: address,
      latitude: latitude,
      longitude: longitude,
      companyId: companyId,
      finishIds: List.unmodifiable(finishIds),
      availableFrom: availableFrom?.toUtc(),
      notes: notes,
      createdAt: (createdAt ?? now).toUtc(),
      updatedAt: (updatedAt ?? now).toUtc(),
    );
  }

  // ==========================================================================
  // EQUALITY
  // ==========================================================================

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Property &&
            runtimeType == other.runtimeType &&
            propertyId == other.propertyId &&
            reference == other.reference &&
            typeId == other.typeId &&
            status == other.status &&
            title == other.title &&
            description == other.description &&
            price == other.price &&
            landArea == other.landArea &&
            builtArea == other.builtArea &&
            bedrooms == other.bedrooms &&
            livingRooms == other.livingRooms &&
            bathrooms == other.bathrooms &&
            externalKitchen == other.externalKitchen &&
            socialHousing == other.socialHousing &&
            zoneId == other.zoneId &&
            address == other.address &&
            latitude == other.latitude &&
            longitude == other.longitude &&
            companyId == other.companyId &&
            listEquals(finishIds, other.finishIds) &&
            availableFrom == other.availableFrom &&
            notes == other.notes &&
            createdAt == other.createdAt &&
            updatedAt == other.updatedAt;
  }

  
@override
int get hashCode {
  return Object.hash(
    propertyId,
    reference,
    typeId,
    status,
    title,
    description,
    price,
    landArea,
    builtArea,
    bedrooms,
    livingRooms,
    bathrooms,
    externalKitchen,
    socialHousing,
    zoneId,
    address,
    latitude,
    longitude,
    companyId,
    Object.hash(
      Object.hashAll(finishIds),
      availableFrom,
      notes,
      createdAt,
      updatedAt,
    ),
  );
}

  // ==========================================================================
  // TO STRING
  // ==========================================================================

  @override
  String toString() {
    return 'Property('
        'propertyId: $propertyId, '
        'reference: $reference, '
        'typeId: $typeId, '
        'status: ${status.name}, '
        'title: $title, '
        'price: $price, '
        'zoneId: $zoneId, '
        'companyId: $companyId'
        ')';
  }
}

// ============================================================================
// INTERNAL COPYWITH SENTINEL
// ============================================================================

const Object _undefined = Object();

// ============================================================================
// PARSERS
// ============================================================================

String _string(dynamic value) {
  return value?.toString().trim() ?? '';
}

String? _nullableString(dynamic value) {
  if (value == null) {
    return null;
  }

  final result = value.toString().trim();

  return result.isEmpty ? null : result;
}

double _double(dynamic value) {
  if (value is num) {
    return value.toDouble();
  }

  if (value is String) {
    final normalized = value.trim().replaceAll(',', '.');
    return double.tryParse(normalized) ?? 0;
  }

  return 0;
}

double? _nullableDouble(dynamic value) {
  if (value == null) {
    return null;
  }

  if (value is num) {
    return value.toDouble();
  }

  if (value is String) {
    final normalized = value.trim().replaceAll(',', '.');

    if (normalized.isEmpty) {
      return null;
    }

    return double.tryParse(normalized);
  }

  return null;
}

int? _nullableInt(dynamic value) {
  if (value == null) {
    return null;
  }

  if (value is int) {
    return value;
  }

  if (value is num) {
    return value.toInt();
  }

  if (value is String) {
    final normalized = value.trim();

    if (normalized.isEmpty) {
      return null;
    }

    return int.tryParse(normalized) ??
        double.tryParse(normalized)?.toInt();
  }

  return null;
}

bool? _nullableBool(dynamic value) {
  if (value == null) {
    return null;
  }

  if (value is bool) {
    return value;
  }

  if (value is num) {
    if (value == 1) {
      return true;
    }

    if (value == 0) {
      return false;
    }
  }

  if (value is String) {
    switch (value.trim().toLowerCase()) {
      case 'true':
      case '1':
      case 'yes':
      case 'oui':
      case 'y':
        return true;

      case 'false':
      case '0':
      case 'no':
      case 'non':
      case 'n':
        return false;
    }
  }

  return null;
}

DateTime? _nullableDateTime(dynamic value) {
  if (value == null) {
    return null;
  }

  if (value is DateTime) {
    return value.toUtc();
  }

  if (value is String) {
    final normalized = value.trim();

    if (normalized.isEmpty) {
      return null;
    }

    return DateTime.tryParse(normalized)?.toUtc();
  }

  return null;
}

List<String> _stringList(dynamic value) {
  if (value == null) {
    return const <String>[];
  }

  if (value is List) {
    return List.unmodifiable(
      value
          .map((item) => item?.toString().trim() ?? '')
          .where((item) => item.isNotEmpty),
    );
  }

  if (value is String) {
    final normalized = value.trim();

    if (normalized.isEmpty) {
      return const <String>[];
    }

    return List.unmodifiable(
      normalized
          .split(',')
          .map((item) => item.trim())
          .where((item) => item.isNotEmpty),
    );
  }

  return const <String>[];
}

PropertyStatus _propertyStatusFromJson(dynamic value) {
  if (value is PropertyStatus) {
    return value;
  }

  final normalized = value?.toString().trim().toLowerCase();

  switch (normalized) {
    case 'available':
    case 'disponible':
      return PropertyStatus.available;

    case 'reserved':
    case 'reserve':
    case 'réservé':
    case 'reserved_property':
      return PropertyStatus.reserved;

    case 'sold':
    case 'vendu':
      return PropertyStatus.sold;

    case 'rented':
    case 'loue':
    case 'loué':
      return PropertyStatus.rented;

    case 'inactive':
    case 'inactif':
      return PropertyStatus.inactive;

    default:
      return PropertyStatus.available;
  }
}
