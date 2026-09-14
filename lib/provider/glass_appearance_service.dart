
import 'package:universal_glass/appearance/platform/appearance_platform.dart';
import 'package:universal_glass/provider/glass_theme_state.dart';

import 'glass_appearance_codec.dart';

/// ============================================================================
/// GLASS APPEARANCE SERVICE
/// ============================================================================
///
/// Service de gestion des configurations d'apparence Universal Glass.
///
/// Responsabilités :
///
/// - encoder l'apparence en JSON ;
/// - décoder une configuration JSON ;
/// - importer une configuration depuis la plateforme ;
/// - exporter une configuration vers la plateforme ;
/// - sauvegarder une configuration localement ;
/// - lire une configuration locale ;
/// - supprimer une configuration locale ;
/// - connaître la date de dernière modification.
///
/// Ce service ne possède aucun état.
///
/// Il fait le lien entre :
///
///     GlassThemeState
///          ↓
///     GlassAppearanceCodec
///          ↓
///     AppearancePlatform
///
/// Le service ne contient aucune logique d'interface utilisateur.
/// ============================================================================
class GlassAppearanceService {
  GlassAppearanceService._();

  // ==========================================================================
  // CONSTANTES
  // ==========================================================================

  /// Nom de fichier utilisé lorsque aucun nom personnalisé n'est fourni.
  static const String defaultFileName =
      'universal_glass_appearance.json';

  // ==========================================================================
  // IMPORT DEPUIS LA PLATEFORME
  // ==========================================================================

  /// Ouvre le sélecteur de fichier de la plateforme et importe
  /// une configuration Universal Glass.
  ///
  /// Retourne `null` si :
  ///
  /// - aucun fichier n'a été sélectionné ;
  /// - le fichier est vide ;
  /// - le JSON est invalide ;
  /// - le type de configuration est incorrect ;
  /// - la version n'est pas supportée.
  ///
  /// Les erreurs de décodage sont volontairement absorbées ici afin
  /// que l'appelant puisse simplement tester la valeur retournée.
  static Future<GlassThemeState?> importAppearance() async {
    final String? jsonString =
        await importJsonFromPlatform();

    if (jsonString == null ||
        jsonString.trim().isEmpty) {
      return null;
    }

    try {
      return decode(jsonString);
    } catch (_) {
      return null;
    }
  }

  // ==========================================================================
  // EXPORT VERS LA PLATEFORME
  // ==========================================================================

  /// Exporte l'état courant sous forme de fichier JSON.
  ///
  /// Retourne le chemin, le nom ou l'identifiant retourné par la plateforme.
  ///
  /// Les erreurs de plateforme ne sont pas absorbées ici afin que
  /// l'appelant puisse les traiter correctement.
  static Future<String?> exportAppearance(
    GlassThemeState state, {
    String? fileName,
    bool pretty = true,
  }) async {
    final String jsonString = encode(
      state,
      pretty: pretty,
    );

    return exportJsonToPlatform(
      jsonString: jsonString,
      fileName: _normalizeFileName(fileName),
    );
  }

  // ==========================================================================
  // ENCODE
  // ==========================================================================

  /// Encode directement une configuration en JSON.
  ///
  /// Cette méthode ne réalise aucune opération de fichier.
  static String encode(
    GlassThemeState state, {
    bool pretty = true,
  }) {
    return GlassAppearanceCodec.toJson(
      state,
      pretty: pretty,
    );
  }

  // ==========================================================================
  // DECODE
  // ==========================================================================

  /// Décode directement une configuration JSON.
  ///
  /// Contrairement à [importAppearance], cette méthode ne masque pas
  /// les erreurs.
  ///
  /// Une [FormatException] peut être levée si :
  ///
  /// - le JSON est invalide ;
  /// - le fichier n'est pas un objet JSON ;
  /// - le type est incorrect ;
  /// - la version est incompatible ;
  /// - la version est invalide.
  static GlassThemeState decode(
    String jsonString,
  ) {
    return GlassAppearanceCodec.fromJson(
      jsonString,
    );
  }

  // ==========================================================================
  // SAUVEGARDE LOCALE
  // ==========================================================================

  /// Sauvegarde une configuration dans le stockage local
  /// de la plateforme.
  ///
  /// Retourne le chemin ou l'identifiant fourni par la plateforme.
  static Future<String?> saveLocal(
    GlassThemeState state, {
    String fileName = defaultFileName,
    bool pretty = true,
  }) async {
    final String jsonString = encode(
      state,
      pretty: pretty,
    );

    return saveJsonToLocalFile(
      jsonString: jsonString,
      fileName: _normalizeFileName(fileName),
    );
  }

  // ==========================================================================
  // LECTURE LOCALE
  // ==========================================================================

  /// Lit une configuration précédemment sauvegardée localement.
  ///
  /// Retourne `null` si aucun fichier n'existe, si le fichier est vide
  /// ou si sa configuration est invalide.
  static Future<GlassThemeState?> readLocal({
    String fileName = defaultFileName,
  }) async {
    final String? jsonString = await readLocalJsonFile(
      fileName: _normalizeFileName(fileName),
    );

    if (jsonString == null ||
        jsonString.trim().isEmpty) {
      return null;
    }

    try {
      return decode(jsonString);
    } catch (_) {
      return null;
    }
  }

  // ==========================================================================
  // SUPPRESSION LOCALE
  // ==========================================================================

  /// Supprime une configuration locale.
  static Future<void> deleteLocal({
    String fileName = defaultFileName,
  }) {
    return deleteLocalJsonFile(
      fileName: _normalizeFileName(fileName),
    );
  }

  // ==========================================================================
  // DERNIÈRE MODIFICATION
  // ==========================================================================

  /// Retourne la date de dernière modification du fichier local.
  ///
  /// Retourne `null` lorsque la plateforme ne dispose pas d'un fichier
  /// local correspondant ou lorsque cette information n'est pas disponible.
  static Future<DateTime?> localLastModified({
    String fileName = defaultFileName,
  }) {
    return localJsonLastModified(
      fileName: _normalizeFileName(fileName),
    );
  }

  // ==========================================================================
  // NORMALISATION DU NOM
  // ==========================================================================

  /// Garantit qu'un nom de fichier possède l'extension `.json`.
  static String _normalizeFileName(
    String? fileName,
  ) {
    final String value =
        fileName?.trim().isNotEmpty == true
            ? fileName!.trim()
            : defaultFileName;

    if (value.toLowerCase().endsWith('.json')) {
      return value;
    }

    return '$value.json';
  }
}
