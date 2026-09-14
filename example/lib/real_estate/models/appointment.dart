
import 'package:flutter/foundation.dart';

/// ============================================================================
/// APPOINTMENT TYPE
/// ============================================================================
///
/// Type de rendez-vous ou d'interaction planifiée avec le client.
///
enum AppointmentType {
  meeting,
  propertyVisit,
  phoneCall,
  videoCall,
  documentSubmission,
  signing,
  other,
}

/// ============================================================================
/// APPOINTMENT STATUS
/// ============================================================================
///
/// État du rendez-vous.
///
enum AppointmentStatus {
  scheduled,
  confirmed,
  completed,
  cancelled,
  postponed,
  noShow,
}

/// ============================================================================
/// APPOINTMENT
/// ============================================================================
///
/// Représente un rendez-vous ou une interaction planifiée avec un client.
///
/// Relations :
/// - [clientId]       -> Client
/// - [requestId]      -> PropertyRequest
/// - [propertyId]     -> Property, lorsqu'un bien précis est concerné.
///
/// Les relations utilisent uniquement les IDs afin de garder le modèle
/// indépendant de la couche de données, de Google Sheets, de GAS et de l'UI.
///
@immutable
class Appointment {
  // ==========================================================================
  // IDENTIFICATION
  // ==========================================================================

  final String appointmentId;

  // ==========================================================================
  // RELATIONS
  // ==========================================================================

  final String clientId;
  final String? requestId;
  final String? propertyId;

  // ==========================================================================
  // TYPE ET STATUT
  // ==========================================================================

  final AppointmentType type;
  final AppointmentStatus status;

  // ==========================================================================
  // DATE ET HEURE
  // ==========================================================================

  final DateTime startAt;
  final DateTime? endAt;

  // ==========================================================================
  // INFORMATIONS DU RENDEZ-VOUS
  // ==========================================================================

  final String? title;
  final String? description;

  // ==========================================================================
  // LIEU
  // ==========================================================================

  final String? location;
  final double? latitude;
  final double? longitude;

  // ==========================================================================
  // CONTACT
  // ==========================================================================

  final String? contactPhone;

  // ==========================================================================
  // INFORMATIONS COMPLÉMENTAIRES
  // ==========================================================================

  final String? notes;

  // ==========================================================================
  // DATES DE SUIVI
  // ==========================================================================

  final DateTime createdAt;
  final DateTime updatedAt;

  // ==========================================================================
  // CONSTRUCTOR
  // ==========================================================================

  const Appointment({
    required this.appointmentId,
    required this.clientId,
    this.requestId,
    this.propertyId,
    this.type = AppointmentType.meeting,
    this.status = AppointmentStatus.scheduled,
    required this.startAt,
    this.endAt,
    this.title,
    this.description,
    this.location,
    this.latitude,
    this.longitude,
    this.contactPhone,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  // ==========================================================================
  // GETTERS
  // ==========================================================================

  bool get isScheduled => status == AppointmentStatus.scheduled;

  bool get isConfirmed => status == AppointmentStatus.confirmed;

  bool get isCompleted => status == AppointmentStatus.completed;

  bool get isCancelled => status == AppointmentStatus.cancelled;

  bool get isPostponed => status == AppointmentStatus.postponed;

  bool get isNoShow => status == AppointmentStatus.noShow;

  bool get isMeeting => type == AppointmentType.meeting;

  bool get isPropertyVisit => type == AppointmentType.propertyVisit;

  bool get isPhoneCall => type == AppointmentType.phoneCall;

  bool get isVideoCall => type == AppointmentType.videoCall;

  bool get isDocumentSubmission =>
      type == AppointmentType.documentSubmission;

  bool get isSigning => type == AppointmentType.signing;

  bool get isOther => type == AppointmentType.other;

  bool get hasRequest => requestId != null && requestId!.isNotEmpty;

  bool get hasProperty => propertyId != null && propertyId!.isNotEmpty;

  bool get hasTitle => title != null && title!.trim().isNotEmpty;

  bool get hasDescription =>
      description != null && description!.trim().isNotEmpty;

  bool get hasLocation =>
      location != null && location!.trim().isNotEmpty;

  bool get hasCoordinates => latitude != null && longitude != null;

  bool get hasContactPhone =>
      contactPhone != null && contactPhone!.trim().isNotEmpty;

  bool get hasNotes => notes != null && notes!.trim().isNotEmpty;

  bool get hasEndAt => endAt != null;

  Duration? get duration {
    if (endAt == null) {
      return null;
    }

    return endAt!.difference(startAt);
  }

  bool get isPast => startAt.isBefore(DateTime.now());

  bool get isFuture => startAt.isAfter(DateTime.now());

  // ==========================================================================
  // COPY WITH
  // ==========================================================================

  Appointment copyWith({
    String? appointmentId,
    String? clientId,
    Object? requestId = _undefined,
    Object? propertyId = _undefined,
    AppointmentType? type,
    AppointmentStatus? status,
    DateTime? startAt,
    Object? endAt = _undefined,
    Object? title = _undefined,
    Object? description = _undefined,
    Object? location = _undefined,
    Object? latitude = _undefined,
    Object? longitude = _undefined,
    Object? contactPhone = _undefined,
    Object? notes = _undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Appointment(
      appointmentId: appointmentId ?? this.appointmentId,
      clientId: clientId ?? this.clientId,
      requestId: identical(requestId, _undefined)
          ? this.requestId
          : requestId as String?,
      propertyId: identical(propertyId, _undefined)
          ? this.propertyId
          : propertyId as String?,
      type: type ?? this.type,
      status: status ?? this.status,
      startAt: startAt ?? this.startAt,
      endAt: identical(endAt, _undefined)
          ? this.endAt
          : endAt as DateTime?,
      title: identical(title, _undefined)
          ? this.title
          : title as String?,
      description: identical(description, _undefined)
          ? this.description
          : description as String?,
      location: identical(location, _undefined)
          ? this.location
          : location as String?,
      latitude: identical(latitude, _undefined)
          ? this.latitude
          : latitude as double?,
      longitude: identical(longitude, _undefined)
          ? this.longitude
          : longitude as double?,
      contactPhone: identical(contactPhone, _undefined)
          ? this.contactPhone
          : contactPhone as String?,
      notes: identical(notes, _undefined)
          ? this.notes
          : notes as String?,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // ==========================================================================
  // JSON
  // ==========================================================================

  Map<String, dynamic> toJson() {
    return {
      'appointmentId': appointmentId,
      'clientId': clientId,
      'requestId': requestId,
      'propertyId': propertyId,
      'type': type.name,
      'status': status.name,
      'startAt': startAt.toUtc().toIso8601String(),
      'endAt': endAt?.toUtc().toIso8601String(),
      'title': title,
      'description': description,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'contactPhone': contactPhone,
      'notes': notes,
      'createdAt': createdAt.toUtc().toIso8601String(),
      'updatedAt': updatedAt.toUtc().toIso8601String(),
    };
  }

  factory Appointment.fromJson(Map<String, dynamic> json) {
    final now = DateTime.now().toUtc();

    return Appointment(
      appointmentId: _string(json['appointmentId']),
      clientId: _string(json['clientId']),
      requestId: _nullableString(json['requestId']),
      propertyId: _nullableString(json['propertyId']),
      type: _appointmentTypeFromJson(json['type']),
      status: _appointmentStatusFromJson(json['status']),
      startAt:
          _dateTime(json['startAt']) ??
          now,
      endAt: _nullableDateTime(json['endAt']),
      title: _nullableString(json['title']),
      description: _nullableString(json['description']),
      location: _nullableString(json['location']),
      latitude: _nullableDouble(json['latitude']),
      longitude: _nullableDouble(json['longitude']),
      contactPhone: _nullableString(json['contactPhone']),
      notes: _nullableString(json['notes']),
      createdAt: _nullableDateTime(json['createdAt']) ?? now,
      updatedAt: _nullableDateTime(json['updatedAt']) ?? now,
    );
  }

  // ==========================================================================
  // FACTORY CREATE
  // ==========================================================================

  factory Appointment.create({
    required String appointmentId,
    required String clientId,
    String? requestId,
    String? propertyId,
    AppointmentType type = AppointmentType.meeting,
    AppointmentStatus status = AppointmentStatus.scheduled,
    required DateTime startAt,
    DateTime? endAt,
    String? title,
    String? description,
    String? location,
    double? latitude,
    double? longitude,
    String? contactPhone,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    final now = DateTime.now().toUtc();

    return Appointment(
      appointmentId: appointmentId,
      clientId: clientId,
      requestId: _cleanNullable(requestId),
      propertyId: _cleanNullable(propertyId),
      type: type,
      status: status,
      startAt: startAt.toUtc(),
      endAt: endAt?.toUtc(),
      title: _cleanNullable(title),
      description: _cleanNullable(description),
      location: _cleanNullable(location),
      latitude: latitude,
      longitude: longitude,
      contactPhone: _cleanNullable(contactPhone),
      notes: _cleanNullable(notes),
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
        other is Appointment &&
            runtimeType == other.runtimeType &&
            appointmentId == other.appointmentId &&
            clientId == other.clientId &&
            requestId == other.requestId &&
            propertyId == other.propertyId &&
            type == other.type &&
            status == other.status &&
            startAt == other.startAt &&
            endAt == other.endAt &&
            title == other.title &&
            description == other.description &&
            location == other.location &&
            latitude == other.latitude &&
            longitude == other.longitude &&
            contactPhone == other.contactPhone &&
            notes == other.notes &&
            createdAt == other.createdAt &&
            updatedAt == other.updatedAt;
  }

  // ==========================================================================
  // HASH CODE
  // ==========================================================================

  @override
  int get hashCode {
    return Object.hash(
      appointmentId,
      clientId,
      requestId,
      propertyId,
      type,
      status,
      startAt,
      endAt,
      title,
      description,
      location,
      latitude,
      longitude,
      contactPhone,
      notes,
      createdAt,
      updatedAt,
    );
  }

  // ==========================================================================
  // TO STRING
  // ==========================================================================

  @override
  String toString() {
    return 'Appointment('
        'appointmentId: $appointmentId, '
        'clientId: $clientId, '
        'requestId: $requestId, '
        'propertyId: $propertyId, '
        'type: ${type.name}, '
        'status: ${status.name}, '
        'startAt: $startAt'
        ')';
  }
}

// ============================================================================
// INTERNAL COPYWITH SENTINEL
// ============================================================================

const Object _undefined = Object();

// ============================================================================
// STRING HELPERS
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

String? _cleanNullable(String? value) {
  if (value == null) {
    return null;
  }

  final result = value.trim();

  return result.isEmpty ? null : result;
}

// ============================================================================
// NUMBER PARSERS
// ============================================================================

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

// ============================================================================
// DATE PARSERS
// ============================================================================

DateTime? _dateTime(dynamic value) {
  return _nullableDateTime(value);
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

// ============================================================================
// APPOINTMENT TYPE PARSER
// ============================================================================

AppointmentType _appointmentTypeFromJson(dynamic value) {
  if (value is AppointmentType) {
    return value;
  }

  final normalized = value?.toString().trim().toLowerCase();

  switch (normalized) {
    case 'meeting':
    case 'rendezvous':
    case 'rendez-vous':
    case 'rdv':
      return AppointmentType.meeting;

    case 'propertyvisit':
    case 'property_visit':
    case 'visit':
    case 'visite':
    case 'visite_bien':
    case 'visitebien':
      return AppointmentType.propertyVisit;

    case 'phonecall':
    case 'phone_call':
    case 'call':
    case 'appel':
      return AppointmentType.phoneCall;

    case 'videocall':
    case 'video_call':
    case 'video':
    case 'appel_video':
      return AppointmentType.videoCall;

    case 'documentsubmission':
    case 'document_submission':
    case 'documents':
    case 'depot_documents':
      return AppointmentType.documentSubmission;

    case 'signing':
    case 'signature':
    case 'signature_contrat':
      return AppointmentType.signing;

    case 'other':
    case 'autre':
      return AppointmentType.other;

    default:
      return AppointmentType.meeting;
  }
}

// ============================================================================
// APPOINTMENT STATUS PARSER
// ============================================================================

AppointmentStatus _appointmentStatusFromJson(dynamic value) {
  if (value is AppointmentStatus) {
    return value;
  }

  final normalized = value?.toString().trim().toLowerCase();

  switch (normalized) {
    case 'scheduled':
    case 'planifie':
    case 'planifié':
    case 'programme':
    case 'programmé':
      return AppointmentStatus.scheduled;

    case 'confirmed':
    case 'confirme':
    case 'confirmé':
      return AppointmentStatus.confirmed;

    case 'completed':
    case 'complete':
    case 'complété':
    case 'termine':
    case 'terminé':
      return AppointmentStatus.completed;

    case 'cancelled':
    case 'canceled':
    case 'annule':
    case 'annulé':
      return AppointmentStatus.cancelled;

    case 'postponed':
    case 'reporte':
    case 'reporté':
      return AppointmentStatus.postponed;

    case 'noshow':
    case 'no_show':
    case 'absent':
      return AppointmentStatus.noShow;

    default:
      return AppointmentStatus.scheduled;
  }
}
