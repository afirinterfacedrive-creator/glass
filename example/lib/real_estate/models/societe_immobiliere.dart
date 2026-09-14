
import 'package:flutter/foundation.dart';

/// ============================================================================
/// SOCIÉTÉ IMMOBILIÈRE
/// ============================================================================
///
/// Représente une société immobilière intervenant dans le système.
///
/// Une société peut proposer des biens ou programmes dans plusieurs zones.
/// Une zone peut également être proposée par plusieurs sociétés.
///
/// La relation plusieurs-à-plusieurs entre [SocieteImmobiliere] et [Zone]
/// est volontairement gérée dans un modèle séparé : [ZoneSociete].
///
/// Exemple :
///
/// Société A
///   ├── BASSINKO
///   ├── BOASSA
///   └── SAABA
///
/// Société B
///   ├── BASSINKO
///   └── GONSIN
///
/// ============================================================================

enum SocieteImmobiliereStatus {
  active,
  inactive,
  archived,
}

@immutable
class SocieteImmobiliere {
  /// Identifiant unique de la société.
  final String companyId;

  /// Code métier court et stable.
  ///
  /// Exemple :
  /// `SOCIETE_A`
  /// `IMMO_BF_01`
  final String code;

  /// Nom officiel ou commercial de la société.
  final String name;

  /// Nom légal complet de la société, si différent du nom commercial.
  final String? legalName;

  /// Numéro de téléphone principal.
  final String? phone;

  /// Numéro de téléphone secondaire.
  final String? secondaryPhone;

  /// Adresse e-mail principale.
  final String? email;

  /// Site internet de la société.
  final String? website;

  /// Adresse physique ou siège de la société.
  final String? address;

  /// Ville dans laquelle se trouve le siège.
  final String? city;

  /// Pays de la société.
  final String? country;

  /// Numéro d'identification fiscale ou référence administrative,
  /// lorsque cette information est disponible.
  final String? taxId;

  /// Personne de contact principale.
  final String? contactName;

  /// Fonction de la personne de contact.
  final String? contactRole;

  /// Logo de la société.
  ///
  /// Peut être une URL distante ou une référence vers une ressource
  /// stockée localement.
  final String? logoUrl;

  /// Description ou présentation de la société.
  final String? description;

  /// Statut de la société dans l'application.
  final SocieteImmobiliereStatus status;

  /// Date de création de l'enregistrement.
  final DateTime createdAt;

  /// Date de dernière modification.
  final DateTime updatedAt;

  /// Position d'affichage.
  final int order;

  const SocieteImmobiliere({
    required this.companyId,
    required this.code,
    required this.name,
    this.legalName,
    this.phone,
    this.secondaryPhone,
    this.email,
    this.website,
    this.address,
    this.city,
    this.country,
    this.taxId,
    this.contactName,
    this.contactRole,
    this.logoUrl,
    this.description,
    this.status = SocieteImmobiliereStatus.active,
    required this.createdAt,
    required this.updatedAt,
    this.order = 0,
  });

  // ==========================================================================
  // COPY WITH
  // ==========================================================================

  SocieteImmobiliere copyWith({
    String? companyId,
    String? code,
    String? name,
    String? legalName,
    bool clearLegalName = false,
    String? phone,
    bool clearPhone = false,
    String? secondaryPhone,
    bool clearSecondaryPhone = false,
    String? email,
    bool clearEmail = false,
    String? website,
    bool clearWebsite = false,
    String? address,
    bool clearAddress = false,
    String? city,
    bool clearCity = false,
    String? country,
    bool clearCountry = false,
    String? taxId,
    bool clearTaxId = false,
    String? contactName,
    bool clearContactName = false,
    String? contactRole,
    bool clearContactRole = false,
    String? logoUrl,
    bool clearLogoUrl = false,
    String? description,
    bool clearDescription = false,
    SocieteImmobiliereStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? order,
  }) {
    return SocieteImmobiliere(
      companyId: companyId ?? this.companyId,
      code: code ?? this.code,
      name: name ?? this.name,
      legalName:
          clearLegalName ? null : (legalName ?? this.legalName),
      phone:
          clearPhone ? null : (phone ?? this.phone),
      secondaryPhone:
          clearSecondaryPhone
              ? null
              : (secondaryPhone ?? this.secondaryPhone),
      email:
          clearEmail ? null : (email ?? this.email),
      website:
          clearWebsite ? null : (website ?? this.website),
      address:
          clearAddress ? null : (address ?? this.address),
      city:
          clearCity ? null : (city ?? this.city),
      country:
          clearCountry ? null : (country ?? this.country),
      taxId:
          clearTaxId ? null : (taxId ?? this.taxId),
      contactName:
          clearContactName ? null : (contactName ?? this.contactName),
      contactRole:
          clearContactRole ? null : (contactRole ?? this.contactRole),
      logoUrl:
          clearLogoUrl ? null : (logoUrl ?? this.logoUrl),
      description:
          clearDescription ? null : (description ?? this.description),
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      order: order ?? this.order,
    );
  }

  // ==========================================================================
  // JSON
  // ==========================================================================

  Map<String, dynamic> toJson() {
    return {
      'companyId': companyId,
      'code': code,
      'name': name,
      'legalName': legalName,
      'phone': phone,
      'secondaryPhone': secondaryPhone,
      'email': email,
      'website': website,
      'address': address,
      'city': city,
      'country': country,
      'taxId': taxId,
      'contactName': contactName,
      'contactRole': contactRole,
      'logoUrl': logoUrl,
      'description': description,
      'status': status.name,
      'createdAt': createdAt.toUtc().toIso8601String(),
      'updatedAt': updatedAt.toUtc().toIso8601String(),
      'order': order,
    };
  }

  factory SocieteImmobiliere.fromJson(
    Map<String, dynamic> json,
  ) {
    return SocieteImmobiliere(
      companyId: _readString(json['companyId']) ?? '',
      code: _readString(json['code']) ?? '',
      name: _readString(json['name']) ?? '',
      legalName: _readNullableString(json['legalName']),
      phone: _readNullableString(json['phone']),
      secondaryPhone: _readNullableString(
        json['secondaryPhone'],
      ),
      email: _readNullableString(json['email']),
      website: _readNullableString(json['website']),
      address: _readNullableString(json['address']),
      city: _readNullableString(json['city']),
      country: _readNullableString(json['country']),
      taxId: _readNullableString(json['taxId']),
      contactName: _readNullableString(json['contactName']),
      contactRole: _readNullableString(json['contactRole']),
      logoUrl: _readNullableString(json['logoUrl']),
      description: _readNullableString(json['description']),
      status: _readStatus(json['status']),
      createdAt: _readDateTime(
        json['createdAt'],
      ),
      updatedAt: _readDateTime(
        json['updatedAt'],
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
    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(
          value?.toString() ?? '',
        ) ??
        fallback;
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

  static SocieteImmobiliereStatus _readStatus(
    dynamic value,
  ) {
    if (value is SocieteImmobiliereStatus) {
      return value;
    }

    final text = value?.toString().trim().toLowerCase();

    switch (text) {
      case 'active':
        return SocieteImmobiliereStatus.active;

      case 'inactive':
        return SocieteImmobiliereStatus.inactive;

      case 'archived':
        return SocieteImmobiliereStatus.archived;

      default:
        return SocieteImmobiliereStatus.active;
    }
  }

  // ==========================================================================
  // GETTERS
  // ==========================================================================

  /// Indique si la société est actuellement active.
  bool get isActive {
    return status == SocieteImmobiliereStatus.active;
  }

  /// Indique si la société est inactive.
  bool get isInactive {
    return status == SocieteImmobiliereStatus.inactive;
  }

  /// Indique si la société est archivée.
  bool get isArchived {
    return status == SocieteImmobiliereStatus.archived;
  }

  /// Nom à utiliser pour l'affichage.
  ///
  /// Le nom commercial est prioritaire.
  String get displayName => name;

  // ==========================================================================
  // EQUALITY
  // ==========================================================================

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is SocieteImmobiliere &&
            other.companyId == companyId &&
            other.code == code &&
            other.name == name &&
            other.legalName == legalName &&
            other.phone == phone &&
            other.secondaryPhone == secondaryPhone &&
            other.email == email &&
            other.website == website &&
            other.address == address &&
            other.city == city &&
            other.country == country &&
            other.taxId == taxId &&
            other.contactName == contactName &&
            other.contactRole == contactRole &&
            other.logoUrl == logoUrl &&
            other.description == description &&
            other.status == status &&
            other.createdAt == createdAt &&
            other.updatedAt == updatedAt &&
            other.order == order;
  }

  @override
  int get hashCode {
    return Object.hash(
      companyId,
      code,
      name,
      legalName,
      phone,
      secondaryPhone,
      email,
      website,
      address,
      city,
      country,
      taxId,
      contactName,
      contactRole,
      logoUrl,
      description,
      status,
      createdAt,
      updatedAt,
      order,
    );
  }

  // ==========================================================================
  // DEBUG
  // ==========================================================================

  @override
  String toString() {
    return 'SocieteImmobiliere('
        'companyId: $companyId, '
        'code: $code, '
        'name: $name, '
        'legalName: $legalName, '
        'phone: $phone, '
        'email: $email, '
        'city: $city, '
        'status: ${status.name}, '
        'order: $order'
        ')';
  }
}
