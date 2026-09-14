
import 'package:flutter/foundation.dart';

/// Statut d'un client immobilier.
enum ClientStatus {
  active,
  inactive,
  archived,
}

/// Client enregistré dans le système immobilier.
///
/// Ce modèle représente uniquement l'identité et les coordonnées
/// du client. Les demandes immobilières sont stockées séparément
/// dans [PropertyRequest].
@immutable
class Client {
  // ===========================================================================
  // IDENTIFICATION
  // ===========================================================================

  /// Identifiant unique du client.
  ///
  /// Exemple : `CLI-000001`.
  final String clientId;

  // ===========================================================================
  // DATES
  // ===========================================================================

  /// Date de création du client.
  final DateTime createdAt;

  /// Date de dernière modification.
  final DateTime updatedAt;

  // ===========================================================================
  // INFORMATIONS CLIENT
  // ===========================================================================

  /// Nom complet du client.
  final String name;

  /// Numéro de téléphone principal.
  final String phone;

  /// Deuxième numéro de téléphone éventuel.
  final String? secondaryPhone;

  /// Adresse e-mail éventuelle.
  final String? email;

  /// Structure / entreprise représentée par le client.
  final String? structure;

  /// Notes internes.
  final String? notes;

  /// Statut actuel du client.
  final ClientStatus status;

  // ===========================================================================
  // CONSTRUCTOR
  // ===========================================================================

  const Client({
    required this.clientId,
    required this.createdAt,
    required this.updatedAt,
    required this.name,
    required this.phone,
    this.secondaryPhone,
    this.email,
    this.structure,
    this.notes,
    this.status = ClientStatus.active,
  });

  // ===========================================================================
  // COPY WITH
  // ===========================================================================

  Client copyWith({
    String? clientId,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? name,
    String? phone,
    String? secondaryPhone,
    String? email,
    String? structure,
    String? notes,
    ClientStatus? status,
  }) {
    return Client(
      clientId: clientId ?? this.clientId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      secondaryPhone: secondaryPhone ?? this.secondaryPhone,
      email: email ?? this.email,
      structure: structure ?? this.structure,
      notes: notes ?? this.notes,
      status: status ?? this.status,
    );
  }

  // ===========================================================================
  // JSON
  // ===========================================================================

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'clientId': clientId,
      'createdAt': createdAt.toUtc().toIso8601String(),
      'updatedAt': updatedAt.toUtc().toIso8601String(),
      'name': name,
      'phone': phone,
      'secondaryPhone': secondaryPhone,
      'email': email,
      'structure': structure,
      'notes': notes,
      'status': status.name,
    };
  }

  // ===========================================================================
  // FROM JSON
  // ===========================================================================

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      clientId: _readString(json, 'clientId'),
      createdAt: _readDateTime(json, 'createdAt'),
      updatedAt: _readDateTime(json, 'updatedAt'),
      name: _readString(json, 'name'),
      phone: _readString(json, 'phone'),
      secondaryPhone: _readNullableString(
        json,
        'secondaryPhone',
      ),
      email: _readNullableString(
        json,
        'email',
      ),
      structure: _readNullableString(
        json,
        'structure',
      ),
      notes: _readNullableString(
        json,
        'notes',
      ),
      status: _readStatus(
        json,
        'status',
      ),
    );
  }

  // ===========================================================================
  // HELPERS
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

  static String? _readNullableString(
    Map<String, dynamic> json,
    String key,
  ) {
    final dynamic value = json[key];

    if (value is String && value.trim().isNotEmpty) {
      return value;
    }

    return null;
  }

  static DateTime _readDateTime(
    Map<String, dynamic> json,
    String key,
  ) {
    final dynamic value = json[key];

    if (value is DateTime) {
      return value;
    }

    if (value is String) {
      final DateTime? parsed = DateTime.tryParse(value);

      if (parsed != null) {
        return parsed.toLocal();
      }
    }

    return DateTime.now();
  }

  static ClientStatus _readStatus(
    Map<String, dynamic> json,
    String key,
  ) {
    final dynamic value = json[key];

    if (value is String) {
      for (final ClientStatus status in ClientStatus.values) {
        if (status.name == value) {
          return status;
        }
      }
    }

    return ClientStatus.active;
  }

  // ===========================================================================
  // EQUALITY
  // ===========================================================================

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Client &&
            other.clientId == clientId &&
            other.createdAt == createdAt &&
            other.updatedAt == updatedAt &&
            other.name == name &&
            other.phone == phone &&
            other.secondaryPhone == secondaryPhone &&
            other.email == email &&
            other.structure == structure &&
            other.notes == notes &&
            other.status == status;
  }

  @override
  int get hashCode {
    return Object.hash(
      clientId,
      createdAt,
      updatedAt,
      name,
      phone,
      secondaryPhone,
      email,
      structure,
      notes,
      status,
    );
  }

  // ===========================================================================
  // DEBUG
  // ===========================================================================

  @override
  String toString() {
    return 'Client('
        'clientId: $clientId, '
        'name: $name, '
        'phone: $phone, '
        'status: ${status.name}'
        ')';
  }
}
