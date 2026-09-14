
import 'package:universal_glass/glass.dart';
import 'package:universal_glass_example/settings/widgets/appearance/appearance_settings.dart';

import 'appearance_profiles.dart';
import 'appearance_profiles_codec.dart';

/// ============================================================================
/// APPEARANCE PROFILES SERVICE
/// ============================================================================
///
/// Service d'import/export des profils d'apparence globaux de l'application.
///
/// IMPORTANT
/// ---------------------------------------------------------------------------
/// Ce service appartient à l'application example.
///
/// Il ne doit PAS être déplacé dans le package Universal Glass, car :
///
///   AppearanceProfiles
///   AppearanceSettings
///
/// appartiennent au projet example.
///
/// Le package Universal Glass possède déjà son propre :
///
///   GlassAppearanceService
///
/// qui travaille exclusivement avec [GlassThemeState].
///
/// Ce service-ci travaille avec :
///
///   AppearanceProfiles
///   +
///   AppThemeMode actif
///
/// ---------------------------------------------------------------------------
/// PROFILS EXPORTÉS
/// ---------------------------------------------------------------------------
///
/// - Aqua
/// - Classic
/// - Light
/// - Dark
///
/// Le mode [AppThemeMode.system] n'est jamais considéré comme un profil.
///
/// ---------------------------------------------------------------------------
/// RÉGLAGES NON EXPORTÉS
/// ---------------------------------------------------------------------------
///
/// Les réglages spécifiques aux composants ne font PAS partie de cet export :
///
/// - AppBar
/// - Component
/// - Input
/// - Form
/// - Toast
/// - Tooltip
///
/// Ils restent gérés séparément.
///
class AppearanceProfilesService {
  AppearanceProfilesService._();

  // ==========================================================================
  // FICHIER PAR DÉFAUT
  // ==========================================================================

  /// Nom du fichier JSON utilisé pour l'import/export des profils.
  static const String defaultFileName =
      'universal_glass_appearance_profiles.json';

  // ==========================================================================
  // ENCODE
  // ==========================================================================

  /// Convertit les profils et le mode actif en JSON.
  ///
  /// [pretty] permet d'obtenir un JSON indenté et lisible.
  static String encode({
    required AppearanceProfiles profiles,
    required AppThemeMode activeMode,
    bool pretty = true,
  }) {
    return AppearanceProfilesCodec.encode(
      profiles: profiles,
      activeMode: _normalizeActiveMode(activeMode),
      pretty: pretty,
    );
  }

  // ==========================================================================
  // DECODE
  // ==========================================================================

  /// Décode un document JSON contenant les quatre profils.
  ///
  /// En cas d'erreur, les [fallback] sont retournés.
  static AppearanceProfilesDocument decode({
    required String source,
    required AppearanceProfiles fallback,
    AppThemeMode fallbackActiveMode = AppThemeMode.aqua,
  }) {
    return AppearanceProfilesCodec.decode(
      source: source,
      fallback: fallback,
      fallbackActiveMode: _normalizeActiveMode(
        fallbackActiveMode,
      ),
    );
  }

  // ==========================================================================
  // IMPORT DEPUIS LA PLATEFORME
  // ==========================================================================

  /// Ouvre le sélecteur de fichier de la plateforme et importe les profils.
  ///
  /// Retourne `null` si :
  /// - l'utilisateur annule ;
  /// - aucun fichier n'est sélectionné ;
  /// - le fichier est vide ;
  /// - le fichier est invalide.
  ///
  /// Le décodage final doit être effectué par [decode].
  static Future<String?> importJson() async {
    final String? jsonString = await importJsonFromPlatform();

    if (jsonString == null) {
      return null;
    }

    if (jsonString.trim().isEmpty) {
      return null;
    }

    return jsonString;
  }

  /// Importe directement les profils depuis un fichier sélectionné.
  ///
  /// En cas d'erreur ou d'annulation, les [fallback] sont retournés.
  static Future<AppearanceProfilesDocument> importProfiles({
    required AppearanceProfiles fallback,
    AppThemeMode fallbackActiveMode = AppThemeMode.aqua,
  }) async {
    final String? jsonString = await importJson();

    if (jsonString == null) {
      return AppearanceProfilesDocument(
        profiles: fallback,
        activeMode: _normalizeActiveMode(
          fallbackActiveMode,
        ),
      );
    }

    return decode(
      source: jsonString,
      fallback: fallback,
      fallbackActiveMode: fallbackActiveMode,
    );
  }

  // ==========================================================================
  // EXPORT VERS LA PLATEFORME
  // ==========================================================================

  /// Exporte les profils vers la plateforme.
  ///
  /// Retourne le chemin ou l'identifiant retourné par la plateforme,
  /// selon la plateforme utilisée.
  static Future<String?> exportProfiles({
    required AppearanceProfiles profiles,
    required AppThemeMode activeMode,
    String? fileName,
    bool pretty = true,
  }) async {
    final String jsonString = encode(
      profiles: profiles,
      activeMode: activeMode,
      pretty: pretty,
    );

    return exportJsonToPlatform(
      jsonString: jsonString,
      fileName: _normalizeFileName(fileName),
    );
  }

  // ==========================================================================
  // SAUVEGARDE LOCALE
  // ==========================================================================

  /// Sauvegarde les profils dans le fichier local de l'application.
  ///
  /// Cette méthode est utile pour une sauvegarde automatique ou une
  /// persistance secondaire indépendante de SharedPreferences.
  static Future<String?> saveLocal({
    required AppearanceProfiles profiles,
    required AppThemeMode activeMode,
    String? fileName,
    bool pretty = true,
  }) async {
    final String jsonString = encode(
      profiles: profiles,
      activeMode: activeMode,
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

  /// Lit les profils depuis le fichier local.
  ///
  /// Retourne `null` si le fichier n'existe pas, est vide ou invalide.
  static Future<String?> readLocalJson({
    String? fileName,
  }) async {
    final String? jsonString = await readLocalJsonFile(
      fileName: _normalizeFileName(fileName),
    );

    if (jsonString == null) {
      return null;
    }

    if (jsonString.trim().isEmpty) {
      return null;
    }

    return jsonString;
  }

  /// Lit et décode directement les profils locaux.
  ///
  /// Les [fallback] permettent de conserver un état valide si le fichier
  /// local est absent ou corrompu.
  static Future<AppearanceProfilesDocument> readLocal({
    required AppearanceProfiles fallback,
    AppThemeMode fallbackActiveMode = AppThemeMode.aqua,
    String? fileName,
  }) async {
    final String? jsonString = await readLocalJson(
      fileName: fileName,
    );

    if (jsonString == null) {
      return AppearanceProfilesDocument(
        profiles: fallback,
        activeMode: _normalizeActiveMode(
          fallbackActiveMode,
        ),
      );
    }

    return decode(
      source: jsonString,
      fallback: fallback,
      fallbackActiveMode: fallbackActiveMode,
    );
  }

  // ==========================================================================
  // SUPPRESSION DU FICHIER LOCAL
  // ==========================================================================

  /// Supprime la sauvegarde locale des profils.
  static Future<void> deleteLocal({
    String? fileName,
  }) {
    return deleteLocalJsonFile(
      fileName: _normalizeFileName(fileName),
    );
  }

  // ==========================================================================
  // DATE DE MODIFICATION
  // ==========================================================================

  /// Retourne la date de dernière modification du fichier local.
  ///
  /// Retourne `null` si le fichier n'existe pas ou si la plateforme
  /// ne fournit pas cette information.
  static Future<DateTime?> localLastModified({
    String? fileName,
  }) {
    return localJsonLastModified(
      fileName: _normalizeFileName(fileName),
    );
  }

  // ==========================================================================
  // UTILITAIRE : SAUVEGARDE + EXPORT
  // ==========================================================================

  /// Sauvegarde localement puis exporte les profils.
  ///
  /// Cette méthode peut être utilisée lorsque l'application souhaite :
  ///
  /// 1. conserver une copie locale ;
  /// 2. puis permettre à l'utilisateur d'exporter le même document.
  ///
  /// Le résultat correspond au résultat de l'export plateforme.
  static Future<String?> saveAndExport({
    required AppearanceProfiles profiles,
    required AppThemeMode activeMode,
    String? fileName,
    bool pretty = true,
  }) async {
    final String normalizedFileName =
        _normalizeFileName(fileName);

    final String jsonString = encode(
      profiles: profiles,
      activeMode: activeMode,
      pretty: pretty,
    );

    await saveJsonToLocalFile(
      jsonString: jsonString,
      fileName: normalizedFileName,
    );

    return exportJsonToPlatform(
      jsonString: jsonString,
      fileName: normalizedFileName,
    );
  }

  // ==========================================================================
  // VALIDATION
  // ==========================================================================

  /// Vérifie si une chaîne contient un document de profils valide.
  ///
  /// Cette méthode ne modifie aucun profil.
  static bool isValidJson(String source) {
    if (source.trim().isEmpty) {
      return false;
    }

    try {
      final AppearanceProfilesDocument document =
          AppearanceProfilesCodec.decode(
        source: source,
        fallback: const AppearanceProfiles(
          aqua: AppearanceSettings(),
          classic: AppearanceSettings(),
          light: AppearanceSettings(),
          dark: AppearanceSettings(),
        ),
      );

      // ignore: unnecessary_null_comparison
      return document.profiles.aqua != null;
    } catch (_) {
      return false;
    }
  }

  // ==========================================================================
  // NORMALISATION DU MODE ACTIF
  // ==========================================================================

  /// Le mode système n'est pas un profil personnalisable.
  ///
  /// Il est donc converti en Aqua lorsqu'il doit être stocké dans le
  /// document des profils.
  static AppThemeMode _normalizeActiveMode(
    AppThemeMode mode,
  ) {
    if (mode == AppThemeMode.system) {
      return AppThemeMode.aqua;
    }

    return mode;
  }

  // ==========================================================================
  // NORMALISATION DU NOM DE FICHIER
  // ==========================================================================

  /// Garantit l'extension `.json`.
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