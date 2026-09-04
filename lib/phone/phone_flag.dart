// ignore: dangling_library_doc_comments
/// ============================================================================
/// PHONE FLAG
///
/// Représente le drapeau associé à un pays.
///
/// Les codes ISO restent en majuscules dans l'application.
/// Les fichiers physiques des drapeaux sont en minuscules.
///
/// Exemple:
///
/// ISO:
/// BF
///
/// Asset:
/// assets/phone/flags/bf.png
/// ============================================================================

class PhoneFlag {
  final String isoCode;

  const PhoneFlag({
    required this.isoCode,
  });

  /// Code ISO normalisé.
  String get normalizedIsoCode {
    return isoCode.trim().toUpperCase();
  }

  /// Nom du fichier du drapeau.
  String get fileName {
    return '${normalizedIsoCode.toLowerCase()}.png';
  }

  /// Chemin de l'asset dans le package.
  String get assetPath {
    return 'packages/universal_glass/assets/phone/flags/$fileName';
  }

  @override
  String toString() {
    return 'PhoneFlag('
        'isoCode: $normalizedIsoCode, '
        'assetPath: $assetPath'
        ')';
  }
}