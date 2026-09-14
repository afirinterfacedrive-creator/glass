
import 'package:flutter/foundation.dart';

/// ============================================================================
/// STATUT DE LA DEMANDE
/// ============================================================================
///
/// Évolution commerciale d'une demande immobilière.
///
/// newRequest
///   Demande nouvellement enregistrée.
///
/// contacted
///   Le client a été contacté.
///
/// proposalSent
///   Une ou plusieurs propositions immobilières ont été présentées.
///
/// appointment
///   Un rendez-vous a été programmé.
///
/// visitCompleted
///   Une ou plusieurs visites ont été effectuées.
///
/// waiting
///   Le client est en attente ou la demande est temporairement suspendue.
///
/// closed
///   La demande est terminée avec succès ou classée.
///
/// cancelled
///   La demande a été annulée.
///
enum PropertyRequestStatus {
  newRequest,
  contacted,
  proposalSent,
  appointment,
  visitCompleted,
  waiting,
  closed,
  cancelled,
}

/// ============================================================================
/// DEMANDE IMMOBILIÈRE
/// ============================================================================
///
/// Représente le besoin immobilier exprimé par un client.
///
/// IMPORTANT :
///
/// [PropertyRequest] n'est PAS un bien immobilier.
///
/// Il représente une recherche ou un besoin client.
///
/// Exemple :
///
/// Client : Jean
///
/// Demande :
///   - Type : F2 ou F3
///   - Zones : BASSINKO, BOASSA
///   - Sociétés : Société A, Société B
///   - Finitions : Dallage lissé, Clôture
///   - Paiement : Comptant ou Apport 30 % + Crédit bancaire
///   - Budget : 7 500 000 à 14 500 000 FCFA
///
/// Un [PropertyRequest] peut donc correspondre à plusieurs biens réels.
///
@immutable
class PropertyRequest {
  // ==========================================================================
  // IDENTIFICATION
  // ==========================================================================

  /// Identifiant unique de la demande.
  final String requestId;

  /// Identifiant du client ayant formulé la demande.
  final String clientId;

  /// Date à laquelle la demande a été formulée.
  final DateTime requestDate;

  /// Date de création de l'enregistrement.
  final DateTime createdAt;

  /// Date de dernière modification.
  final DateTime updatedAt;

  // ==========================================================================
  // STATUT
  // ==========================================================================

  final PropertyRequestStatus status;

  // ==========================================================================
  // TYPES DE BIENS
  // ==========================================================================

  /// Identifiants des types de biens recherchés.
  ///
  /// Exemple :
  /// - F2
  /// - F3
  ///
  /// Plusieurs types peuvent être sélectionnés.
  final List<String> propertyTypeIds;

  // ==========================================================================
  // SOCIÉTÉS IMMOBILIÈRES
  // ==========================================================================

  /// Sociétés immobilières auprès desquelles le client accepte
  /// des propositions.
  ///
  /// Une demande peut cibler plusieurs sociétés.
  final List<String> companyIds;

  // ==========================================================================
  // ZONES
  // ==========================================================================

  /// Zones géographiques recherchées par le client.
  ///
  /// Exemple :
  /// - BASSINKO
  /// - BOASSA
  /// - SAABA
  final List<String> zoneIds;

  // ==========================================================================
  // FINITIONS
  // ==========================================================================

  /// Finitions souhaitées par le client.
  ///
  /// Exemple :
  /// - Dallage lissé
  /// - Clôture
  final List<String> finishIds;

  // ==========================================================================
  // CONDITIONS DE PAIEMENT
  // ==========================================================================

  /// Conditions de paiement acceptées par le client.
  ///
  /// Plusieurs conditions peuvent être sélectionnées.
  final List<String> paymentConditionIds;

  // ==========================================================================
  // BUDGET
  // ==========================================================================

  /// Budget minimum du client en FCFA.
  final double? priceMin;

  /// Budget maximum du client en FCFA.
  final double? priceMax;

  // ==========================================================================
  // TERRAIN
  // ==========================================================================

  /// Surface minimale de terrain recherchée en m².
  final double? landAreaMin;

  /// Surface maximale de terrain recherchée en m².
  final double? landAreaMax;

  // ==========================================================================
  // SURFACE BÂTIE
  // ==========================================================================

  /// Surface bâtie minimale recherchée en m².
  final double? builtAreaMin;

  /// Surface bâtie maximale recherchée en m².
  final double? builtAreaMax;

  // ==========================================================================
  // CHAMBRES
  // ==========================================================================

  /// Nombre minimal de chambres recherché.
  final int? bedroomsMin;

  /// Nombre maximal de chambres recherché.
  final int? bedroomsMax;

  // ==========================================================================
  // SALONS
  // ==========================================================================

  /// Nombre minimal de salons recherché.
  final int? livingRoomsMin;

  /// Nombre maximal de salons recherché.
  final int? livingRoomsMax;

  // ==========================================================================
  // TOILETTES
  // ==========================================================================

  /// Nombre minimal de toilettes recherché.
  final int? bathroomsMin;

  /// Nombre maximal de toilettes recherché.
  final int? bathroomsMax;

  // ==========================================================================
  // CUISINE
  // ==========================================================================

  /// Indique si le client souhaite une cuisine externe.
  ///
  /// `null` signifie que le client n'a pas exprimé de préférence.
  final bool? externalKitchen;

  // ==========================================================================
  // LOGEMENT SOCIAL
  // ==========================================================================

  /// Indique si le client recherche un logement social.
  ///
  /// `null` signifie qu'aucune préférence n'a été indiquée.
  final bool? socialHousing;

  // ==========================================================================
  // NOTES
  // ==========================================================================

  /// Informations complémentaires données par le client.
  final String? notes;

  const PropertyRequest({
    required this.requestId,
    required this.clientId,
    required this.requestDate,
    required this.createdAt,
    required this.updatedAt,
    this.status = PropertyRequestStatus.newRequest,
    this.propertyTypeIds = const [],
    this.companyIds = const [],
    this.zoneIds = const [],
    this.finishIds = const [],
    this.paymentConditionIds = const [],
    this.priceMin,
    this.priceMax,
    this.landAreaMin,
    this.landAreaMax,
    this.builtAreaMin,
    this.builtAreaMax,
    this.bedroomsMin,
    this.bedroomsMax,
    this.livingRoomsMin,
    this.livingRoomsMax,
    this.bathroomsMin,
    this.bathroomsMax,
    this.externalKitchen,
    this.socialHousing,
    this.notes,
  });

  // ==========================================================================
  // GETTERS
  // ==========================================================================

  /// Indique si la demande est nouvellement créée.
  bool get isNew {
    return status == PropertyRequestStatus.newRequest;
  }

  /// Indique si la demande est active commercialement.
  bool get isActive {
    return status != PropertyRequestStatus.closed &&
        status != PropertyRequestStatus.cancelled;
  }

  /// Indique si la demande est terminée.
  bool get isClosed {
    return status == PropertyRequestStatus.closed;
  }

  /// Indique si la demande a été annulée.
  bool get isCancelled {
    return status == PropertyRequestStatus.cancelled;
  }

  /// Indique si un budget minimum est défini.
  bool get hasPriceMin {
    return priceMin != null && priceMin! >= 0;
  }

  /// Indique si un budget maximum est défini.
  bool get hasPriceMax {
    return priceMax != null && priceMax! >= 0;
  }

  /// Indique si une plage de prix est définie.
  bool get hasPriceRange {
    return hasPriceMin || hasPriceMax;
  }

  /// Indique si une plage de terrain est définie.
  bool get hasLandAreaRange {
    return landAreaMin != null || landAreaMax != null;
  }

  /// Indique si une plage de surface bâtie est définie.
  bool get hasBuiltAreaRange {
    return builtAreaMin != null || builtAreaMax != null;
  }

  /// Indique si une plage de chambres est définie.
  bool get hasBedroomsRange {
    return bedroomsMin != null || bedroomsMax != null;
  }

  /// Indique si une plage de salons est définie.
  bool get hasLivingRoomsRange {
    return livingRoomsMin != null || livingRoomsMax != null;
  }

  /// Indique si une plage de toilettes est définie.
  bool get hasBathroomsRange {
    return bathroomsMin != null || bathroomsMax != null;
  }

  /// Indique si au moins un type de bien est sélectionné.
  bool get hasPropertyTypes {
    return propertyTypeIds.isNotEmpty;
  }

  /// Indique si au moins une société est sélectionnée.
  bool get hasCompanies {
    return companyIds.isNotEmpty;
  }

  /// Indique si au moins une zone est sélectionnée.
  bool get hasZones {
    return zoneIds.isNotEmpty;
  }

  /// Indique si au moins une finition est sélectionnée.
  bool get hasFinishes {
    return finishIds.isNotEmpty;
  }

  /// Indique si au moins une condition de paiement est sélectionnée.
  bool get hasPaymentConditions {
    return paymentConditionIds.isNotEmpty;
  }

  // ==========================================================================
  // COPY WITH
  // ==========================================================================

  PropertyRequest copyWith({
    String? requestId,
    String? clientId,
    DateTime? requestDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    PropertyRequestStatus? status,
    List<String>? propertyTypeIds,
    List<String>? companyIds,
    List<String>? zoneIds,
    List<String>? finishIds,
    List<String>? paymentConditionIds,
    double? priceMin,
    bool clearPriceMin = false,
    double? priceMax,
    bool clearPriceMax = false,
    double? landAreaMin,
    bool clearLandAreaMin = false,
    double? landAreaMax,
    bool clearLandAreaMax = false,
    double? builtAreaMin,
    bool clearBuiltAreaMin = false,
    double? builtAreaMax,
    bool clearBuiltAreaMax = false,
    int? bedroomsMin,
    bool clearBedroomsMin = false,
    int? bedroomsMax,
    bool clearBedroomsMax = false,
    int? livingRoomsMin,
    bool clearLivingRoomsMin = false,
    int? livingRoomsMax,
    bool clearLivingRoomsMax = false,
    int? bathroomsMin,
    bool clearBathroomsMin = false,
    int? bathroomsMax,
    bool clearBathroomsMax = false,
    bool? externalKitchen,
    bool clearExternalKitchen = false,
    bool? socialHousing,
    bool clearSocialHousing = false,
    String? notes,
    bool clearNotes = false,
  }) {
    return PropertyRequest(
      requestId: requestId ?? this.requestId,
      clientId: clientId ?? this.clientId,
      requestDate: requestDate ?? this.requestDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      status: status ?? this.status,
      propertyTypeIds:
          List.unmodifiable(
            propertyTypeIds ?? this.propertyTypeIds,
          ),
      companyIds:
          List.unmodifiable(
            companyIds ?? this.companyIds,
          ),
      zoneIds:
          List.unmodifiable(
            zoneIds ?? this.zoneIds,
          ),
      finishIds:
          List.unmodifiable(
            finishIds ?? this.finishIds,
          ),
      paymentConditionIds:
          List.unmodifiable(
            paymentConditionIds ?? this.paymentConditionIds,
          ),
      priceMin:
          clearPriceMin ? null : (priceMin ?? this.priceMin),
      priceMax:
          clearPriceMax ? null : (priceMax ?? this.priceMax),
      landAreaMin:
          clearLandAreaMin
              ? null
              : (landAreaMin ?? this.landAreaMin),
      landAreaMax:
          clearLandAreaMax
              ? null
              : (landAreaMax ?? this.landAreaMax),
      builtAreaMin:
          clearBuiltAreaMin
              ? null
              : (builtAreaMin ?? this.builtAreaMin),
      builtAreaMax:
          clearBuiltAreaMax
              ? null
              : (builtAreaMax ?? this.builtAreaMax),
      bedroomsMin:
          clearBedroomsMin
              ? null
              : (bedroomsMin ?? this.bedroomsMin),
      bedroomsMax:
          clearBedroomsMax
              ? null
              : (bedroomsMax ?? this.bedroomsMax),
      livingRoomsMin:
          clearLivingRoomsMin
              ? null
              : (livingRoomsMin ?? this.livingRoomsMin),
      livingRoomsMax:
          clearLivingRoomsMax
              ? null
              : (livingRoomsMax ?? this.livingRoomsMax),
      bathroomsMin:
          clearBathroomsMin
              ? null
              : (bathroomsMin ?? this.bathroomsMin),
      bathroomsMax:
          clearBathroomsMax
              ? null
              : (bathroomsMax ?? this.bathroomsMax),
      externalKitchen:
          clearExternalKitchen
              ? null
              : (externalKitchen ?? this.externalKitchen),
      socialHousing:
          clearSocialHousing
              ? null
              : (socialHousing ?? this.socialHousing),
      notes:
          clearNotes ? null : (notes ?? this.notes),
    );
  }

  // ==========================================================================
  // JSON
  // ==========================================================================

  Map<String, dynamic> toJson() {
    return {
      'requestId': requestId,
      'clientId': clientId,
      'requestDate': requestDate.toUtc().toIso8601String(),
      'createdAt': createdAt.toUtc().toIso8601String(),
      'updatedAt': updatedAt.toUtc().toIso8601String(),
      'status': status.name,

      'propertyTypeIds': propertyTypeIds,
      'companyIds': companyIds,
      'zoneIds': zoneIds,
      'finishIds': finishIds,
      'paymentConditionIds': paymentConditionIds,

      'priceMin': priceMin,
      'priceMax': priceMax,

      'landAreaMin': landAreaMin,
      'landAreaMax': landAreaMax,

      'builtAreaMin': builtAreaMin,
      'builtAreaMax': builtAreaMax,

      'bedroomsMin': bedroomsMin,
      'bedroomsMax': bedroomsMax,

      'livingRoomsMin': livingRoomsMin,
      'livingRoomsMax': livingRoomsMax,

      'bathroomsMin': bathroomsMin,
      'bathroomsMax': bathroomsMax,

      'externalKitchen': externalKitchen,
      'socialHousing': socialHousing,

      'notes': notes,
    };
  }

  factory PropertyRequest.fromJson(
    Map<String, dynamic> json,
  ) {
    return PropertyRequest(
      requestId:
          _readString(json['requestId']) ?? '',
      clientId:
          _readString(json['clientId']) ?? '',

      requestDate:
          _readDateTime(json['requestDate']),
      createdAt:
          _readDateTime(json['createdAt']),
      updatedAt:
          _readDateTime(json['updatedAt']),

      status:
          _readStatus(json['status']),

      propertyTypeIds:
          _readStringList(
            json['propertyTypeIds'],
          ),

      companyIds:
          _readStringList(
            json['companyIds'],
          ),

      zoneIds:
          _readStringList(
            json['zoneIds'],
          ),

      finishIds:
          _readStringList(
            json['finishIds'],
          ),

      paymentConditionIds:
          _readStringList(
            json['paymentConditionIds'],
          ),

      priceMin:
          _readNullableDouble(json['priceMin']),
      priceMax:
          _readNullableDouble(json['priceMax']),

      landAreaMin:
          _readNullableDouble(json['landAreaMin']),
      landAreaMax:
          _readNullableDouble(json['landAreaMax']),

      builtAreaMin:
          _readNullableDouble(json['builtAreaMin']),
      builtAreaMax:
          _readNullableDouble(json['builtAreaMax']),

      bedroomsMin:
          _readNullableInt(json['bedroomsMin']),
      bedroomsMax:
          _readNullableInt(json['bedroomsMax']),

      livingRoomsMin:
          _readNullableInt(json['livingRoomsMin']),
      livingRoomsMax:
          _readNullableInt(json['livingRoomsMax']),

      bathroomsMin:
          _readNullableInt(json['bathroomsMin']),
      bathroomsMax:
          _readNullableInt(json['bathroomsMax']),

      externalKitchen:
          _readNullableBool(json['externalKitchen']),

      socialHousing:
          _readNullableBool(json['socialHousing']),

      notes:
          _readNullableString(json['notes']),
    );
  }

  // ==========================================================================
  // FACTORY
  // ==========================================================================

  /// Crée une nouvelle demande avec les valeurs temporelles initialisées
  /// automatiquement.
  factory PropertyRequest.create({
    required String requestId,
    required String clientId,
    DateTime? requestDate,
    PropertyRequestStatus status =
        PropertyRequestStatus.newRequest,
    List<String> propertyTypeIds = const [],
    List<String> companyIds = const [],
    List<String> zoneIds = const [],
    List<String> finishIds = const [],
    List<String> paymentConditionIds = const [],
    double? priceMin,
    double? priceMax,
    double? landAreaMin,
    double? landAreaMax,
    double? builtAreaMin,
    double? builtAreaMax,
    int? bedroomsMin,
    int? bedroomsMax,
    int? livingRoomsMin,
    int? livingRoomsMax,
    int? bathroomsMin,
    int? bathroomsMax,
    bool? externalKitchen,
    bool? socialHousing,
    String? notes,
  }) {
    final now = DateTime.now();

    return PropertyRequest(
      requestId: requestId,
      clientId: clientId,
      requestDate: requestDate ?? now,
      createdAt: now,
      updatedAt: now,
      status: status,
      propertyTypeIds:
          List.unmodifiable(propertyTypeIds),
      companyIds:
          List.unmodifiable(companyIds),
      zoneIds:
          List.unmodifiable(zoneIds),
      finishIds:
          List.unmodifiable(finishIds),
      paymentConditionIds:
          List.unmodifiable(paymentConditionIds),
      priceMin: priceMin,
      priceMax: priceMax,
      landAreaMin: landAreaMin,
      landAreaMax: landAreaMax,
      builtAreaMin: builtAreaMin,
      builtAreaMax: builtAreaMax,
      bedroomsMin: bedroomsMin,
      bedroomsMax: bedroomsMax,
      livingRoomsMin: livingRoomsMin,
      livingRoomsMax: livingRoomsMax,
      bathroomsMin: bathroomsMin,
      bathroomsMax: bathroomsMax,
      externalKitchen: externalKitchen,
      socialHousing: socialHousing,
      notes: notes,
    );
  }

  // ==========================================================================
  // PARSING HELPERS
  // ==========================================================================

  static String? _readString(dynamic value) {
    if (value == null) {
      return null;
    }

    final result = value.toString().trim();

    return result.isEmpty ? null : result;
  }

  static String? _readNullableString(dynamic value) {
    return _readString(value);
  }

  static List<String> _readStringList(dynamic value) {
    if (value == null) {
      return const [];
    }

    if (value is List) {
      final result = <String>[];

      for (final item in value) {
        final text = _readString(item);

        if (text != null) {
          result.add(text);
        }
      }

      return List.unmodifiable(result);
    }

    final text = _readString(value);

    if (text == null) {
      return const [];
    }

    return List.unmodifiable(
      text
          .split(',')
          .map((item) => item.trim())
          .where((item) => item.isNotEmpty),
    );
  }

  static double? _readNullableDouble(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is double) {
      return value;
    }

    if (value is num) {
      return value.toDouble();
    }

    final text = value
        .toString()
        .trim()
        .replaceAll(',', '.');

    if (text.isEmpty) {
      return null;
    }

    return double.tryParse(text);
  }

  static int? _readNullableInt(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(
      value.toString().trim(),
    );
  }

  static DateTime _readDateTime(dynamic value) {
    if (value is DateTime) {
      return value;
    }

    final parsed = DateTime.tryParse(
      value?.toString() ?? '',
    );

    return parsed ?? DateTime.now();
  }

  static bool? _readNullableBool(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is bool) {
      return value;
    }

    if (value is num) {
      return value != 0;
    }

    final text = value.toString().trim().toLowerCase();

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
        return null;
    }
  }

  static PropertyRequestStatus _readStatus(
    dynamic value,
  ) {
    if (value is PropertyRequestStatus) {
      return value;
    }

    final text = value?.toString().trim().toLowerCase();

    switch (text) {
      case 'newrequest':
      case 'new_request':
        return PropertyRequestStatus.newRequest;

      case 'contacted':
        return PropertyRequestStatus.contacted;

      case 'proposalsent':
      case 'proposal_sent':
        return PropertyRequestStatus.proposalSent;

      case 'appointment':
        return PropertyRequestStatus.appointment;

      case 'visitcompleted':
      case 'visit_completed':
        return PropertyRequestStatus.visitCompleted;

      case 'waiting':
        return PropertyRequestStatus.waiting;

      case 'closed':
        return PropertyRequestStatus.closed;

      case 'cancelled':
      case 'canceled':
        return PropertyRequestStatus.cancelled;

      default:
        return PropertyRequestStatus.newRequest;
    }
  }

  // ==========================================================================
  // EQUALITY
  // ==========================================================================

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is PropertyRequest &&
            other.requestId == requestId &&
            other.clientId == clientId &&
            other.requestDate == requestDate &&
            other.createdAt == createdAt &&
            other.updatedAt == updatedAt &&
            other.status == status &&
            listEquals(
              other.propertyTypeIds,
              propertyTypeIds,
            ) &&
            listEquals(
              other.companyIds,
              companyIds,
            ) &&
            listEquals(
              other.zoneIds,
              zoneIds,
            ) &&
            listEquals(
              other.finishIds,
              finishIds,
            ) &&
            listEquals(
              other.paymentConditionIds,
              paymentConditionIds,
            ) &&
            other.priceMin == priceMin &&
            other.priceMax == priceMax &&
            other.landAreaMin == landAreaMin &&
            other.landAreaMax == landAreaMax &&
            other.builtAreaMin == builtAreaMin &&
            other.builtAreaMax == builtAreaMax &&
            other.bedroomsMin == bedroomsMin &&
            other.bedroomsMax == bedroomsMax &&
            other.livingRoomsMin == livingRoomsMin &&
            other.livingRoomsMax == livingRoomsMax &&
            other.bathroomsMin == bathroomsMin &&
            other.bathroomsMax == bathroomsMax &&
            other.externalKitchen == externalKitchen &&
            other.socialHousing == socialHousing &&
            other.notes == notes;
  }


@override
int get hashCode {
  return Object.hash(
    requestId,
    clientId,
    requestDate,
    createdAt,
    updatedAt,
    status,
    Object.hashAll(propertyTypeIds),
    Object.hashAll(companyIds),
    Object.hashAll(zoneIds),
    Object.hashAll(finishIds),
    Object.hashAll(paymentConditionIds),
    Object.hash(
      priceMin,
      priceMax,
      landAreaMin,
      landAreaMax,
      builtAreaMin,
      builtAreaMax,
      bedroomsMin,
      bedroomsMax,
      livingRoomsMin,
      livingRoomsMax,
      bathroomsMin,
      bathroomsMax,
      externalKitchen,
      socialHousing,
      notes,
    ),
  );
}

  // ==========================================================================
  // DEBUG
  // ==========================================================================

  @override
  String toString() {
    return 'PropertyRequest('
        'requestId: $requestId, '
        'clientId: $clientId, '
        'status: ${status.name}, '
        'propertyTypes: ${propertyTypeIds.length}, '
        'companies: ${companyIds.length}, '
        'zones: ${zoneIds.length}, '
        'finishes: ${finishIds.length}, '
        'paymentConditions: ${paymentConditionIds.length}, '
        'priceMin: $priceMin, '
        'priceMax: $priceMax'
        ')';
  }
}
