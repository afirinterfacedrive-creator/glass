
import 'package:flutter/foundation.dart';

/// ============================================================================
/// CONDITION DE PAIEMENT
/// ============================================================================
///
/// Représente une condition de paiement proposée pour l'acquisition
/// d'un bien immobilier.
///
/// Exemples issus de la fiche client :
///
/// 1. Comptant
///    - Remise : 2,5 %
///
/// 2. Apport 30 % + Crédit bancaire
///    - Apport : 30 %
///    - Crédit bancaire : oui
///
/// 3. Apport 50 % + Paiement 12 mois
///    - Apport : 50 %
///    - Durée : 12 mois
///
/// 4. Crédit bancaire
///    - Crédit bancaire : oui
///
/// Les pourcentages sont stockés sous forme décimale :
///
///   2,5 %  -> 0.025
///   30 %   -> 0.30
///   50 %   -> 0.50
///
/// ============================================================================

@immutable
class PaymentCondition {
  /// Identifiant unique de la condition.
  final String paymentId;

  /// Code métier stable.
  ///
  /// Exemples :
  /// `CASH`
  /// `DOWN_PAYMENT_30_BANK`
  /// `DOWN_PAYMENT_50_12_MONTHS`
  /// `BANK_CREDIT`
  final String code;

  /// Nom affiché dans l'application.
  final String name;

  /// Description détaillée de la condition.
  final String? description;

  /// Pourcentage d'apport initial.
  ///
  /// Exemple :
  /// 30 % -> 0.30
  /// 50 % -> 0.50
  ///
  /// `null` signifie qu'aucun apport spécifique n'est défini.
  final double? downPayment;

  /// Pourcentage de remise accordé avec cette condition.
  ///
  /// Exemple :
  /// 2,5 % -> 0.025
  final double? discount;

  /// Durée de paiement en mois.
  ///
  /// Exemple :
  /// 12 mois -> 12
  ///
  /// `null` signifie qu'aucune durée spécifique n'est définie.
  final int? durationMonths;

  /// Indique si cette condition utilise un crédit bancaire.
  final bool bankCredit;

  /// Indique si le paiement est effectué comptant.
  final bool cashPayment;

  /// Indique si la condition est actuellement disponible.
  final bool active;

  /// Position d'affichage.
  final int order;

  const PaymentCondition({
    required this.paymentId,
    required this.code,
    required this.name,
    this.description,
    this.downPayment,
    this.discount,
    this.durationMonths,
    this.bankCredit = false,
    this.cashPayment = false,
    this.active = true,
    this.order = 0,
  });

  // ==========================================================================
  // GETTERS
  // ==========================================================================

  /// Indique si un apport est défini.
  bool get hasDownPayment {
    return downPayment != null && downPayment! > 0;
  }

  /// Indique si une remise est définie.
  bool get hasDiscount {
    return discount != null && discount! > 0;
  }

  /// Indique si une durée de paiement est définie.
  bool get hasDuration {
    return durationMonths != null && durationMonths! > 0;
  }

  /// Indique si la condition est active.
  bool get isActive => active;

  /// Pourcentage d'apport sous forme lisible.
  ///
  /// Exemple :
  /// `0.30` -> `30 %`
  String get downPaymentLabel {
    if (!hasDownPayment) {
      return '';
    }

    return '${_formatPercentage(downPayment!)} %';
  }

  /// Pourcentage de remise sous forme lisible.
  ///
  /// Exemple :
  /// `0.025` -> `2,5 %`
  String get discountLabel {
    if (!hasDiscount) {
      return '';
    }

    return '${_formatPercentage(discount!)} %';
  }

  /// Durée sous forme lisible.
  ///
  /// Exemple :
  /// `12` -> `12 mois`
  String get durationLabel {
    if (!hasDuration) {
      return '';
    }

    return '$durationMonths mois';
  }

  // ==========================================================================
  // COPY WITH
  // ==========================================================================

  PaymentCondition copyWith({
    String? paymentId,
    String? code,
    String? name,
    String? description,
    bool clearDescription = false,
    double? downPayment,
    bool clearDownPayment = false,
    double? discount,
    bool clearDiscount = false,
    int? durationMonths,
    bool clearDurationMonths = false,
    bool? bankCredit,
    bool? cashPayment,
    bool? active,
    int? order,
  }) {
    return PaymentCondition(
      paymentId: paymentId ?? this.paymentId,
      code: code ?? this.code,
      name: name ?? this.name,
      description:
          clearDescription
              ? null
              : (description ?? this.description),
      downPayment:
          clearDownPayment
              ? null
              : (downPayment ?? this.downPayment),
      discount:
          clearDiscount
              ? null
              : (discount ?? this.discount),
      durationMonths:
          clearDurationMonths
              ? null
              : (durationMonths ?? this.durationMonths),
      bankCredit: bankCredit ?? this.bankCredit,
      cashPayment: cashPayment ?? this.cashPayment,
      active: active ?? this.active,
      order: order ?? this.order,
    );
  }

  // ==========================================================================
  // JSON
  // ==========================================================================

  Map<String, dynamic> toJson() {
    return {
      'paymentId': paymentId,
      'code': code,
      'name': name,
      'description': description,
      'downPayment': downPayment,
      'discount': discount,
      'durationMonths': durationMonths,
      'bankCredit': bankCredit,
      'cashPayment': cashPayment,
      'active': active,
      'order': order,
    };
  }

  factory PaymentCondition.fromJson(
    Map<String, dynamic> json,
  ) {
    return PaymentCondition(
      paymentId:
          _readString(json['paymentId']) ?? '',
      code:
          _readString(json['code']) ?? '',
      name:
          _readString(json['name']) ?? '',
      description:
          _readNullableString(json['description']),
      downPayment:
          _readNullableDouble(json['downPayment']),
      discount:
          _readNullableDouble(json['discount']),
      durationMonths:
          _readNullableInt(json['durationMonths']),
      bankCredit:
          _readBool(
            json['bankCredit'],
            fallback: false,
          ),
      cashPayment:
          _readBool(
            json['cashPayment'],
            fallback: false,
          ),
      active:
          _readBool(
            json['active'],
            fallback: true,
          ),
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

  /// Condition "Comptant avec remise".
  ///
  /// Exemple par défaut :
  /// remise de 2,5 %.
  factory PaymentCondition.cash({
    required String paymentId,
    String code = 'CASH',
    String name = 'Comptant',
    double? discount = 0.025,
    String? description,
    bool active = true,
    int order = 0,
  }) {
    return PaymentCondition(
      paymentId: paymentId,
      code: code,
      name: name,
      description: description,
      discount: discount,
      cashPayment: true,
      active: active,
      order: order,
    );
  }

  /// Condition avec apport et crédit bancaire.
  ///
  /// Exemple :
  /// apport de 30 % + crédit bancaire.
  factory PaymentCondition.downPaymentWithBankCredit({
    required String paymentId,
    required double downPayment,
    String code = 'DOWN_PAYMENT_BANK',
    String name = 'Apport + Crédit bancaire',
    String? description,
    bool active = true,
    int order = 0,
  }) {
    return PaymentCondition(
      paymentId: paymentId,
      code: code,
      name: name,
      description: description,
      downPayment: downPayment,
      bankCredit: true,
      active: active,
      order: order,
    );
  }

  /// Condition avec apport et paiement échelonné.
  ///
  /// Exemple :
  /// apport de 50 % + paiement sur 12 mois.
  factory PaymentCondition.downPaymentWithInstallments({
    required String paymentId,
    required double downPayment,
    required int durationMonths,
    String code = 'DOWN_PAYMENT_INSTALLMENTS',
    String name = 'Apport + Paiement échelonné',
    String? description,
    bool active = true,
    int order = 0,
  }) {
    return PaymentCondition(
      paymentId: paymentId,
      code: code,
      name: name,
      description: description,
      downPayment: downPayment,
      durationMonths: durationMonths,
      active: active,
      order: order,
    );
  }

  /// Condition reposant entièrement sur un crédit bancaire.
  factory PaymentCondition.bankCredit({
    required String paymentId,
    String code = 'BANK_CREDIT',
    String name = 'Crédit bancaire',
    String? description,
    bool active = true,
    int order = 0,
  }) {
    return PaymentCondition(
      paymentId: paymentId,
      code: code,
      name: name,
      description: description,
      bankCredit: true,
      active: active,
      order: order,
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

  static int _readInt(
    dynamic value, {
    int fallback = 0,
  }) {
    return _readNullableInt(value) ?? fallback;
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
  // FORMAT
  // ==========================================================================

  static String _formatPercentage(double value) {
    final percentage = value * 100;

    if (percentage == percentage.roundToDouble()) {
      return percentage.toInt().toString();
    }

    return percentage
        .toStringAsFixed(2)
        .replaceFirst(RegExp(r'0+$'), '')
        .replaceFirst(RegExp(r'\.$'), '')
        .replaceAll('.', ',');
  }

  // ==========================================================================
  // EQUALITY
  // ==========================================================================

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is PaymentCondition &&
            other.paymentId == paymentId &&
            other.code == code &&
            other.name == name &&
            other.description == description &&
            other.downPayment == downPayment &&
            other.discount == discount &&
            other.durationMonths == durationMonths &&
            other.bankCredit == bankCredit &&
            other.cashPayment == cashPayment &&
            other.active == active &&
            other.order == order;
  }

  @override
  int get hashCode {
    return Object.hash(
      paymentId,
      code,
      name,
      description,
      downPayment,
      discount,
      durationMonths,
      bankCredit,
      cashPayment,
      active,
      order,
    );
  }

  // ==========================================================================
  // DEBUG
  // ==========================================================================

  @override
  String toString() {
    return 'PaymentCondition('
        'paymentId: $paymentId, '
        'code: $code, '
        'name: $name, '
        'downPayment: $downPayment, '
        'discount: $discount, '
        'durationMonths: $durationMonths, '
        'bankCredit: $bankCredit, '
        'cashPayment: $cashPayment, '
        'active: $active, '
        'order: $order'
        ')';
  }
}
