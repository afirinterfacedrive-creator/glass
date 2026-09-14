
import 'package:flutter/foundation.dart';

/// ============================================================================
/// REQUEST FOLLOW-UP TYPE
/// ============================================================================
///
/// Type d'action réalisée dans le suivi d'une demande client.
///
enum RequestFollowUpType {
  note,
  phoneCall,
  message,
  email,
  proposal,
  propertySuggestion,
  appointment,
  propertyVisit,
  documentRequest,
  documentReceived,
  negotiation,
  payment,
  statusChange,
  other,
}

/// ============================================================================
/// REQUEST FOLLOW-UP RESULT
/// ============================================================================
///
/// Résultat de l'action de suivi.
///
enum RequestFollowUpResult {
  none,
  positive,
  negative,
  pending,
  completed,
  noResponse,
  cancelled,
}

/// ============================================================================
/// REQUEST FOLLOW-UP
/// ============================================================================
///
/// Représente une action ou un événement enregistré dans l'historique
/// commercial d'une [PropertyRequest].
///
/// Relations :
/// - [requestId]  -> PropertyRequest
/// - [clientId]   -> Client
/// - [propertyId] -> Property, lorsqu'un bien précis est concerné.
/// - [appointmentId] -> Appointment, lorsqu'une action provient d'un RDV.
///
/// Le modèle conserve uniquement les IDs des relations afin de rester
/// indépendant de Google Sheets, Google Apps Script et de l'interface Flutter.
///
@immutable
class RequestFollowUp {
  // ==========================================================================
  // IDENTIFICATION
  // ==========================================================================

  final String followUpId;

  // ==========================================================================
  // RELATIONS
  // ==========================================================================

  final String requestId;
  final String clientId;
  final String? propertyId;
  final String? appointmentId;

  // ==========================================================================
  // TYPE ET RÉSULTAT
  // ==========================================================================

  final RequestFollowUpType type;
  final RequestFollowUpResult result;

  // ==========================================================================
  // CONTENU
  // ==========================================================================

  final String? title;
  final String? description;

  // ==========================================================================
  // INFORMATIONS DE CONTACT
  // ==========================================================================

  final String? contactPhone;
  final String? contactName;

  // ==========================================================================
  // INFORMATIONS DE SUIVI
  // ==========================================================================

  final String? previousStatus;
  final String? newStatus;

  // ==========================================================================
  // DATE DE L'ACTION
  // ==========================================================================

  final DateTime occurredAt;

  // ==========================================================================
  // UTILISATEUR / AGENT
  // ==========================================================================

  final String? createdBy;

  // ==========================================================================
  // NOTES
  // ==========================================================================

  final String? notes;

  // ==========================================================================
  // DATES TECHNIQUES
  // ==========================================================================

  final DateTime createdAt;
  final DateTime updatedAt;

  // ==========================================================================
  // CONSTRUCTOR
  // ==========================================================================

  const RequestFollowUp({
    required this.followUpId,
    required this.requestId,
    required this.clientId,
    this.propertyId,
    this.appointmentId,
    this.type = RequestFollowUpType.note,
    this.result = RequestFollowUpResult.none,
    this.title,
    this.description,
    this.contactPhone,
    this.contactName,
    this.previousStatus,
    this.newStatus,
    required this.occurredAt,
    this.createdBy,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  // ==========================================================================
  // GETTERS — TYPE
  // ==========================================================================

  bool get isNote => type == RequestFollowUpType.note;

  bool get isPhoneCall => type == RequestFollowUpType.phoneCall;

  bool get isMessage => type == RequestFollowUpType.message;

  bool get isEmail => type == RequestFollowUpType.email;

  bool get isProposal => type == RequestFollowUpType.proposal;

  bool get isPropertySuggestion =>
      type == RequestFollowUpType.propertySuggestion;

  bool get isAppointment => type == RequestFollowUpType.appointment;

  bool get isPropertyVisit => type == RequestFollowUpType.propertyVisit;

  bool get isDocumentRequest =>
      type == RequestFollowUpType.documentRequest;

  bool get isDocumentReceived =>
      type == RequestFollowUpType.documentReceived;

  bool get isNegotiation => type == RequestFollowUpType.negotiation;

  bool get isPayment => type == RequestFollowUpType.payment;

  bool get isStatusChange => type == RequestFollowUpType.statusChange;

  bool get isOther => type == RequestFollowUpType.other;

  // ==========================================================================
  // GETTERS — RESULT
  // ==========================================================================

  bool get hasNoResult => result == RequestFollowUpResult.none;

  bool get isPositive => result == RequestFollowUpResult.positive;

  bool get isNegative => result == RequestFollowUpResult.negative;

  bool get isPending => result == RequestFollowUpResult.pending;

  bool get isCompleted => result == RequestFollowUpResult.completed;

  bool get hasNoResponse => result == RequestFollowUpResult.noResponse;

  bool get isCancelled => result == RequestFollowUpResult.cancelled;

  // ==========================================================================
  // GETTERS — RELATIONS
  // ==========================================================================

  bool get hasProperty =>
      propertyId != null && propertyId!.trim().isNotEmpty;

  bool get hasAppointment =>
      appointmentId != null && appointmentId!.trim().isNotEmpty;

  // ==========================================================================
  // GETTERS — CONTENU
  // ==========================================================================

  bool get hasTitle => title != null && title!.trim().isNotEmpty;

  bool get hasDescription =>
      description != null && description!.trim().isNotEmpty;

  bool get hasContactPhone =>
      contactPhone != null && contactPhone!.trim().isNotEmpty;

  bool get hasContactName =>
      contactName != null && contactName!.trim().isNotEmpty;

  bool get hasStatusChange =>
      previousStatus != null &&
      previousStatus!.trim().isNotEmpty &&
      newStatus != null &&
      newStatus!.trim().isNotEmpty;

  bool get hasCreatedBy =>
      createdBy != null && createdBy!.trim().isNotEmpty;

  bool get hasNotes => notes != null && notes!.trim().isNotEmpty;

  // ==========================================================================
  // COPY WITH
  // ==========================================================================

  RequestFollowUp copyWith({
    String? followUpId,
    String? requestId,
    String? clientId,
    Object? propertyId = _undefined,
    Object? appointmentId = _undefined,
    RequestFollowUpType? type,
    RequestFollowUpResult? result,
    Object? title = _undefined,
    Object? description = _undefined,
    Object? contactPhone = _undefined,
    Object? contactName = _undefined,
    Object? previousStatus = _undefined,
    Object? newStatus = _undefined,
    DateTime? occurredAt,
    Object? createdBy = _undefined,
    Object? notes = _undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return RequestFollowUp(
      followUpId: followUpId ?? this.followUpId,
      requestId: requestId ?? this.requestId,
      clientId: clientId ?? this.clientId,
      propertyId: identical(propertyId, _undefined)
          ? this.propertyId
          : propertyId as String?,
      appointmentId: identical(appointmentId, _undefined)
          ? this.appointmentId
          : appointmentId as String?,
      type: type ?? this.type,
      result: result ?? this.result,
      title: identical(title, _undefined)
          ? this.title
          : title as String?,
      description: identical(description, _undefined)
          ? this.description
          : description as String?,
      contactPhone: identical(contactPhone, _undefined)
          ? this.contactPhone
          : contactPhone as String?,
      contactName: identical(contactName, _undefined)
          ? this.contactName
          : contactName as String?,
      previousStatus: identical(previousStatus, _undefined)
          ? this.previousStatus
          : previousStatus as String?,
      newStatus: identical(newStatus, _undefined)
          ? this.newStatus
          : newStatus as String?,
      occurredAt: occurredAt ?? this.occurredAt,
      createdBy: identical(createdBy, _undefined)
          ? this.createdBy
          : createdBy as String?,
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
      'followUpId': followUpId,
      'requestId': requestId,
      'clientId': clientId,
      'propertyId': propertyId,
      'appointmentId': appointmentId,
      'type': type.name,
      'result': result.name,
      'title': title,
      'description': description,
      'contactPhone': contactPhone,
      'contactName': contactName,
      'previousStatus': previousStatus,
      'newStatus': newStatus,
      'occurredAt': occurredAt.toUtc().toIso8601String(),
      'createdBy': createdBy,
      'notes': notes,
      'createdAt': createdAt.toUtc().toIso8601String(),
      'updatedAt': updatedAt.toUtc().toIso8601String(),
    };
  }

  // ==========================================================================
  // FROM JSON
  // ==========================================================================

  factory RequestFollowUp.fromJson(Map<String, dynamic> json) {
    final now = DateTime.now().toUtc();

    return RequestFollowUp(
      followUpId: _string(json['followUpId']),
      requestId: _string(json['requestId']),
      clientId: _string(json['clientId']),
      propertyId: _nullableString(json['propertyId']),
      appointmentId: _nullableString(json['appointmentId']),
      type: _requestFollowUpTypeFromJson(json['type']),
      result: _requestFollowUpResultFromJson(json['result']),
      title: _nullableString(json['title']),
      description: _nullableString(json['description']),
      contactPhone: _nullableString(json['contactPhone']),
      contactName: _nullableString(json['contactName']),
      previousStatus: _nullableString(json['previousStatus']),
      newStatus: _nullableString(json['newStatus']),
      occurredAt: _dateTime(json['occurredAt']) ?? now,
      createdBy: _nullableString(json['createdBy']),
      notes: _nullableString(json['notes']),
      createdAt: _dateTime(json['createdAt']) ?? now,
      updatedAt: _dateTime(json['updatedAt']) ?? now,
    );
  }

  // ==========================================================================
  // FACTORY CREATE
  // ==========================================================================

  factory RequestFollowUp.create({
    required String followUpId,
    required String requestId,
    required String clientId,
    String? propertyId,
    String? appointmentId,
    RequestFollowUpType type = RequestFollowUpType.note,
    RequestFollowUpResult result = RequestFollowUpResult.none,
    String? title,
    String? description,
    String? contactPhone,
    String? contactName,
    String? previousStatus,
    String? newStatus,
    required DateTime occurredAt,
    String? createdBy,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    final now = DateTime.now().toUtc();

    return RequestFollowUp(
      followUpId: followUpId,
      requestId: requestId,
      clientId: clientId,
      propertyId: _cleanNullable(propertyId),
      appointmentId: _cleanNullable(appointmentId),
      type: type,
      result: result,
      title: _cleanNullable(title),
      description: _cleanNullable(description),
      contactPhone: _cleanNullable(contactPhone),
      contactName: _cleanNullable(contactName),
      previousStatus: _cleanNullable(previousStatus),
      newStatus: _cleanNullable(newStatus),
      occurredAt: occurredAt.toUtc(),
      createdBy: _cleanNullable(createdBy),
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
        other is RequestFollowUp &&
            runtimeType == other.runtimeType &&
            followUpId == other.followUpId &&
            requestId == other.requestId &&
            clientId == other.clientId &&
            propertyId == other.propertyId &&
            appointmentId == other.appointmentId &&
            type == other.type &&
            result == other.result &&
            title == other.title &&
            description == other.description &&
            contactPhone == other.contactPhone &&
            contactName == other.contactName &&
            previousStatus == other.previousStatus &&
            newStatus == other.newStatus &&
            occurredAt == other.occurredAt &&
            createdBy == other.createdBy &&
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
      followUpId,
      requestId,
      clientId,
      propertyId,
      appointmentId,
      type,
      result,
      title,
      description,
      contactPhone,
      contactName,
      previousStatus,
      newStatus,
      occurredAt,
      createdBy,
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
    return 'RequestFollowUp('
        'followUpId: $followUpId, '
        'requestId: $requestId, '
        'clientId: $clientId, '
        'type: ${type.name}, '
        'result: ${result.name}, '
        'occurredAt: $occurredAt'
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
// DATE PARSER
// ============================================================================

DateTime? _dateTime(dynamic value) {
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
// TYPE PARSER
// ============================================================================

RequestFollowUpType _requestFollowUpTypeFromJson(dynamic value) {
  if (value is RequestFollowUpType) {
    return value;
  }

  final normalized = value?.toString().trim().toLowerCase();

  switch (normalized) {
    case 'note':
    case 'notes':
      return RequestFollowUpType.note;

    case 'phonecall':
    case 'phone_call':
    case 'call':
    case 'appel':
      return RequestFollowUpType.phoneCall;

    case 'message':
    case 'sms':
    case 'whatsapp':
      return RequestFollowUpType.message;

    case 'email':
    case 'mail':
      return RequestFollowUpType.email;

    case 'proposal':
    case 'proposition':
    case 'offre':
      return RequestFollowUpType.proposal;

    case 'propertysuggestion':
    case 'property_suggestion':
    case 'suggestion_bien':
    case 'suggestionbien':
      return RequestFollowUpType.propertySuggestion;

    case 'appointment':
    case 'rendezvous':
    case 'rendez-vous':
    case 'rdv':
      return RequestFollowUpType.appointment;

    case 'propertyvisit':
    case 'property_visit':
    case 'visit':
    case 'visite':
      return RequestFollowUpType.propertyVisit;

    case 'documentrequest':
    case 'document_request':
    case 'demande_document':
      return RequestFollowUpType.documentRequest;

    case 'documentreceived':
    case 'document_received':
    case 'document_recu':
    case 'document reçu':
      return RequestFollowUpType.documentReceived;

    case 'negotiation':
    case 'negociation':
    case 'négociation':
      return RequestFollowUpType.negotiation;

    case 'payment':
    case 'paiement':
      return RequestFollowUpType.payment;

    case 'statuschange':
    case 'status_change':
    case 'changement_statut':
      return RequestFollowUpType.statusChange;

    case 'other':
    case 'autre':
      return RequestFollowUpType.other;

    default:
      return RequestFollowUpType.note;
  }
}

// ============================================================================
// RESULT PARSER
// ============================================================================

RequestFollowUpResult _requestFollowUpResultFromJson(dynamic value) {
  if (value is RequestFollowUpResult) {
    return value;
  }

  final normalized = value?.toString().trim().toLowerCase();

  switch (normalized) {
    case 'none':
    case 'aucun':
      return RequestFollowUpResult.none;

    case 'positive':
    case 'positif':
      return RequestFollowUpResult.positive;

    case 'negative':
    case 'negatif':
    case 'négatif':
      return RequestFollowUpResult.negative;

    case 'pending':
    case 'en_attente':
    case 'en attente':
      return RequestFollowUpResult.pending;

    case 'completed':
    case 'complete':
    case 'complété':
    case 'termine':
    case 'terminé':
      return RequestFollowUpResult.completed;

    case 'noresponse':
    case 'no_response':
    case 'sans_reponse':
    case 'sans réponse':
      return RequestFollowUpResult.noResponse;

    case 'cancelled':
    case 'canceled':
    case 'annule':
    case 'annulé':
      return RequestFollowUpResult.cancelled;

    default:
      return RequestFollowUpResult.none;
  }
}
