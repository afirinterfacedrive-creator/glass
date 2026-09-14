
import 'package:flutter/foundation.dart';

/// ============================================================================
/// FINITION
/// ============================================================================
///
/// Représente une finition ou une caractéristique de finition proposée
/// pour un bien immobilier.
///
/// Exemples issus de la fiche actuelle :
///
/// - Dallage lissé
/// - Clôture
///
/// Le modèle reste volontairement générique afin de pouvoir ajouter
/// ultérieurement d'autres finitions sans modifier l'architecture.
///

@immutable
class Finish {
  /// Identifiant unique de la finition.
  final String finishId;

  /// Code métier stable.
  ///
  /// Exemple :
  /// `DALLAGE_LISSE`
  /// `CLOTURE`
  final String code;

  /// Nom affiché dans l'application.
  final String name;

  /// Description complémentaire.
  final String? description;

  /// Indique si la finition est actuellement disponible.
  final bool active;

  /// Position d'affichage.
  final int order;

  const Finish({
    required this.finishId,
    required this.code,
    required this.name,
    this.description,
    this.active = true,
    this.order = 0,
  });

  // ==========================================================================
  // GETTERS
  // ==========================================================================

  /// Indique si la finition est active.
  bool get isActive => active;

  // ==========================================================================
  // COPY WITH
  // ==========================================================================

  Finish copyWith({
    String? finishId,
    String? code,
    String? name,
    String? description,
    bool clearDescription = false,
    bool? active,
    int? order,
  }) {
    return Finish(
      finishId: finishId ?? this.finishId,
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
      'finishId': finishId,
      'code': code,
      'name': name,
      'description': description,
      'active': active,
      'order': order,
    };
  }

  factory Finish.fromJson(
    Map<String, dynamic> json,
  ) {
    return Finish(
      finishId: _readString(json['finishId']) ?? '',
      code: _readString(json['code']) ?? '',
      name: _readString(json['name']) ?? '',
      description: _readNullableString(
        json['description'],
      ),
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

  static bool _readBool(
    dynamic value, {
    bool fallback = false,
  }) {
    if (value is bool) {
      return value;
    }

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
        other is Finish &&
            other.finishId == finishId &&
            other.code == code &&
            other.name == name &&
            other.description == description &&
            other.active == active &&
            other.order == order;
  }

  @override
  int get hashCode {
    return Object.hash(
      finishId,
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
    return 'Finish('
        'finishId: $finishId, '
        'code: $code, '
        'name: $name, '
        'active: $active, '
        'order: $order'
        ')';
  }
}
