
import 'package:flutter/foundation.dart';

/// ============================================================================
/// ZONE SOCIÉTÉ
/// ============================================================================
///
/// Modèle de liaison entre une [Zone] et une [SocieteImmobiliere].
///
/// La relation est de type plusieurs-à-plusieurs :
///
///   Une zone
///       ├── Société A
///       ├── Société B
///       └── Société C
///
///   Une société
///       ├── Zone A
///       ├── Zone B
///       └── Zone C
///
/// Ce modèle ne contient pas les objets [Zone] et [SocieteImmobiliere]
/// eux-mêmes. Il conserve uniquement leurs identifiants afin de rester
/// indépendant des autres modèles et compatible avec Google Sheets.
///
/// Exemple :
///
///   zoneId    = "zone_bassinko"
///   companyId = "company_001"
///
/// signifie que la société "company_001" intervient dans la zone
/// "zone_bassinko".
///
/// ============================================================================

enum ZoneSocieteStatus {
  active,
  inactive,
}

@immutable
class ZoneSociete {
  /// Identifiant unique de la relation.
  ///
  /// Il peut être généré sous la forme :
  /// `zoneId_companyId`
  ///
  /// ou avec un UUID selon la stratégie de stockage choisie.
  final String zoneSocieteId;

  /// Identifiant de la zone.
  final String zoneId;

  /// Identifiant de la société immobilière.
  final String companyId;

  /// Statut de cette association.
  ///
  /// Une relation peut être désactivée sans être supprimée de l'historique.
  final ZoneSocieteStatus status;

  /// Date de création de la relation.
  final DateTime createdAt;

  /// Date de dernière modification.
  final DateTime updatedAt;

  /// Informations complémentaires concernant cette association.
  ///
  /// Exemple :
  /// "Programme disponible uniquement sur la partie sud de la zone."
  final String? notes;

  /// Position d'affichage lorsque les sociétés sont listées dans le contexte
  /// d'une zone.
  final int order;

  const ZoneSociete({
    required this.zoneSocieteId,
    required this.zoneId,
    required this.companyId,
    this.status = ZoneSocieteStatus.active,
    required this.createdAt,
    required this.updatedAt,
    this.notes,
    this.order = 0,
  });

  // ==========================================================================
  // GETTERS
  // ==========================================================================

  /// Indique si la relation est active.
  bool get isActive {
    return status == ZoneSocieteStatus.active;
  }

  /// Indique si la relation est inactive.
  bool get isInactive {
    return status == ZoneSocieteStatus.inactive;
  }

  // ==========================================================================
  // COPY WITH
  // ==========================================================================

  ZoneSociete copyWith({
    String? zoneSocieteId,
    String? zoneId,
    String? companyId,
    ZoneSocieteStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? notes,
    bool clearNotes = false,
    int? order,
  }) {
    return ZoneSociete(
      zoneSocieteId:
          zoneSocieteId ?? this.zoneSocieteId,
      zoneId:
          zoneId ?? this.zoneId,
      companyId:
          companyId ?? this.companyId,
      status:
          status ?? this.status,
      createdAt:
          createdAt ?? this.createdAt,
      updatedAt:
          updatedAt ?? this.updatedAt,
      notes:
          clearNotes ? null : (notes ?? this.notes),
      order:
          order ?? this.order,
    );
  }

  // ==========================================================================
  // JSON
  // ==========================================================================

  Map<String, dynamic> toJson() {
    return {
      'zoneSocieteId': zoneSocieteId,
      'zoneId': zoneId,
      'companyId': companyId,
      'status': status.name,
      'createdAt': createdAt.toUtc().toIso8601String(),
      'updatedAt': updatedAt.toUtc().toIso8601String(),
      'notes': notes,
      'order': order,
    };
  }

  factory ZoneSociete.fromJson(
    Map<String, dynamic> json,
  ) {
    return ZoneSociete(
      zoneSocieteId:
          _readString(json['zoneSocieteId']) ?? '',
      zoneId:
          _readString(json['zoneId']) ?? '',
      companyId:
          _readString(json['companyId']) ?? '',
      status:
          _readStatus(json['status']),
      createdAt:
          _readDateTime(json['createdAt']),
      updatedAt:
          _readDateTime(json['updatedAt']),
      notes:
          _readNullableString(json['notes']),
      order:
          _readInt(
            json['order'],
            fallback: 0,
          ),
    );
  }

  // ==========================================================================
  // FACTORY HELPERS
  // ==========================================================================

  /// Génère un identifiant déterministe à partir d'une zone et d'une société.
  ///
  /// Cela peut être pratique avec Google Sheets afin d'éviter de créer
  /// plusieurs fois la même association.
  static String buildId({
    required String zoneId,
    required String companyId,
  }) {
    return '${zoneId}_$companyId';
  }

  /// Crée une relation active entre une zone et une société.
  factory ZoneSociete.link({
    required String zoneId,
    required String companyId,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? notes,
    int order = 0,
  }) {
    final now = DateTime.now();

    return ZoneSociete(
      zoneSocieteId: buildId(
        zoneId: zoneId,
        companyId: companyId,
      ),
      zoneId: zoneId,
      companyId: companyId,
      status: ZoneSocieteStatus.active,
      createdAt: createdAt ?? now,
      updatedAt: updatedAt ?? now,
      notes: notes,
      order: order,
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

  static ZoneSocieteStatus _readStatus(
    dynamic value,
  ) {
    if (value is ZoneSocieteStatus) {
      return value;
    }

    final text = value?.toString().trim().toLowerCase();

    switch (text) {
      case 'active':
        return ZoneSocieteStatus.active;

      case 'inactive':
        return ZoneSocieteStatus.inactive;

      default:
        return ZoneSocieteStatus.active;
    }
  }

  // ==========================================================================
  // EQUALITY
  // ==========================================================================

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ZoneSociete &&
            other.zoneSocieteId == zoneSocieteId &&
            other.zoneId == zoneId &&
            other.companyId == companyId &&
            other.status == status &&
            other.createdAt == createdAt &&
            other.updatedAt == updatedAt &&
            other.notes == notes &&
            other.order == order;
  }

  @override
  int get hashCode {
    return Object.hash(
      zoneSocieteId,
      zoneId,
      companyId,
      status,
      createdAt,
      updatedAt,
      notes,
      order,
    );
  }

  // ==========================================================================
  // DEBUG
  // ==========================================================================

  @override
  String toString() {
    return 'ZoneSociete('
        'zoneSocieteId: $zoneSocieteId, '
        'zoneId: $zoneId, '
        'companyId: $companyId, '
        'status: ${status.name}, '
        'createdAt: $createdAt, '
        'updatedAt: $updatedAt, '
        'order: $order'
        ')';
  }
}
