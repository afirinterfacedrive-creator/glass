import 'phone_flag.dart';

/// ============================================================================
/// PHONE FLAG REGISTRY
///
/// Résout le drapeau correspondant à un code ISO.
///
/// Les fichiers sont stockés en minuscules:
///
/// BF → bf.png
/// CI → ci.png
/// ML → ml.png
///
/// Aucun fichier n'est chargé tant que le drapeau n'est pas réellement
/// affiché par Flutter.
/// ============================================================================

abstract final class PhoneFlagRegistry {
  /// Retourne le drapeau correspondant au code ISO.
  static PhoneFlag? findByIsoCode(
    String isoCode,
  ) {
    final String normalized =
        isoCode.trim().toUpperCase();

    if (normalized.isEmpty) {
      return null;
    }

    return PhoneFlag(
      isoCode: normalized,
    );
  }

  /// Retourne directement le chemin de l'asset.
  static String assetPath(
    String isoCode,
  ) {
    return PhoneFlag(
      isoCode: isoCode,
    ).assetPath;
  }
}