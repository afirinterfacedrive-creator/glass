
import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

/// ============================================================================
/// APPEARANCE PLATFORM — IO
/// ============================================================================
///
/// Plateformes concernées :
/// - Android
/// - iOS
/// - Windows
/// - macOS
/// - Linux
///
/// Cette couche ne connaît pas [GlassThemeState].
/// Elle manipule uniquement du JSON.
///
/// Le codec Appearance est responsable de :
///
///   GlassThemeState <-> JSON
///
/// Cette couche est responsable de :
///
///   JSON <-> fichier / partage
///
/// ============================================================================

/// ============================================================================
/// IMPORT
/// ============================================================================

/// Ouvre le sélecteur de fichiers système et importe un fichier JSON.
///
/// Retourne le contenu JSON du fichier sélectionné.
///
/// Retourne `null` si :
/// - l'utilisateur annule ;
/// - aucun fichier n'est sélectionné ;
/// - le fichier ne peut pas être lu ;
/// - une erreur survient.
Future<String?> importJsonFromPlatform() async {
  try {
    final FilePickerResult? result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: <String>['json'],
      withData: true,
    );

    if (result == null || result.files.isEmpty) {
      return null;
    }

    final PlatformFile file = result.files.single;

    // ------------------------------------------------------------------------
    // Priorité aux bytes
    // ------------------------------------------------------------------------

    if (file.bytes != null) {
      return utf8.decode(file.bytes!);
    }

    // ------------------------------------------------------------------------
    // Fallback vers le chemin du fichier
    // ------------------------------------------------------------------------

    if (file.path != null) {
      final File localFile = File(file.path!);

      if (!await localFile.exists()) {
        return null;
      }

      return await localFile.readAsString(
        encoding: utf8,
      );
    }

    return null;
  } catch (e, s) {
    debugPrint(
      '❌ Erreur import Appearance: $e',
    );
    debugPrint('$s');

    return null;
  }
}

/// ============================================================================
/// LOCAL STORAGE
/// ============================================================================

/// Enregistre temporairement un JSON dans le dossier Documents
/// de l'application.
///
/// Cette fonction n'est pas destinée à l'export utilisateur.
///
/// Elle peut être utilisée pour :
/// - un preset local ;
/// - un cache ;
/// - une sauvegarde temporaire ;
/// - une fonctionnalité future de synchronisation.
Future<String?> saveJsonToLocalFile({
  required String jsonString,
  required String fileName,
}) async {
  try {
    final Directory appDir =
        await getApplicationDocumentsDirectory();

    final File file = File(
      '${appDir.path}/$fileName',
    );

    await file.writeAsString(
      jsonString,
      encoding: utf8,
    );

    return file.path;
  } catch (e, s) {
    debugPrint(
      '❌ Erreur sauvegarde Appearance: $e',
    );
    debugPrint('$s');

    return null;
  }
}

/// Lit un fichier JSON local précédemment enregistré.
Future<String?> readLocalJsonFile({
  required String fileName,
}) async {
  try {
    final Directory appDir =
        await getApplicationDocumentsDirectory();

    final File file = File(
      '${appDir.path}/$fileName',
    );

    if (!await file.exists()) {
      return null;
    }

    return await file.readAsString(
      encoding: utf8,
    );
  } catch (e, s) {
    debugPrint(
      '❌ Erreur lecture Appearance: $e',
    );
    debugPrint('$s');

    return null;
  }
}

/// Retourne la date de dernière modification du fichier local.
Future<DateTime?> localJsonLastModified({
  required String fileName,
}) async {
  try {
    final Directory appDir =
        await getApplicationDocumentsDirectory();

    final File file = File(
      '${appDir.path}/$fileName',
    );

    if (!await file.exists()) {
      return null;
    }

    return await file.lastModified();
  } catch (e) {
    debugPrint(
      '❌ Erreur date modification Appearance: $e',
    );

    return null;
  }
}

/// Supprime un fichier JSON local.
Future<void> deleteLocalJsonFile({
  required String fileName,
}) async {
  try {
    final Directory appDir =
        await getApplicationDocumentsDirectory();

    final File file = File(
      '${appDir.path}/$fileName',
    );

    if (await file.exists()) {
      await file.delete();
    }
  } catch (e, s) {
    debugPrint(
      '❌ Erreur suppression Appearance: $e',
    );
    debugPrint('$s');
  }
}

/// ============================================================================
/// EXPORT
/// ============================================================================

/// Exporte un preset Appearance.
///
/// Desktop :
///
/// Ouvre le sélecteur d'enregistrement afin que l'utilisateur choisisse
/// lui-même l'emplacement du fichier.
///
/// Mobile :
///
/// Crée temporairement le fichier dans le dossier Documents de l'application
/// puis ouvre le partage système via [SharePlus].
///
/// Retourne :
/// - le chemin du fichier sur desktop/mobile lorsque disponible ;
/// - `null` en cas d'annulation ou d'erreur.
Future<String?> exportJsonToPlatform({
  required String jsonString,
  required String fileName,
}) async {
  try {
    // ========================================================================
    // DESKTOP
    // ========================================================================

    if (Platform.isWindows ||
        Platform.isMacOS ||
        Platform.isLinux) {
      final String? selectedPath =
          await FilePicker.saveFile(
        dialogTitle: 'Exporter Universal Glass Appearance',
        fileName: fileName,
        type: FileType.custom,
        allowedExtensions: <String>['json'],
      );

      if (selectedPath == null ||
          selectedPath.trim().isEmpty) {
        return null;
      }

      final String normalizedPath =
          selectedPath.toLowerCase().endsWith('.json')
              ? selectedPath
              : '$selectedPath.json';

      final File exportFile = File(
        normalizedPath,
      );

      await exportFile.writeAsString(
        jsonString,
        encoding: utf8,
      );

      // ----------------------------------------------------------------------
      // Copie également le chemin dans le presse-papiers.
      //
      // Cela permet de retrouver facilement l'emplacement du preset.
      // ----------------------------------------------------------------------

      await Clipboard.setData(
        ClipboardData(
          text: exportFile.path,
        ),
      );

      return exportFile.path;
    }

    // ========================================================================
    // MOBILE
    // ========================================================================

    if (Platform.isAndroid ||
        Platform.isIOS) {
      final Directory appDir =
          await getApplicationDocumentsDirectory();

      final File exportFile = File(
        '${appDir.path}/$fileName',
      );

      await exportFile.writeAsString(
        jsonString,
        encoding: utf8,
      );

      await SharePlus.instance.share(
        ShareParams(
          files: <XFile>[
            XFile(exportFile.path),
          ],
          text: 'Universal Glass Appearance',
        ),
      );

      return exportFile.path;
    }

    // ========================================================================
    // PLATEFORME INCONNUE
    // ========================================================================

    debugPrint(
      '⚠️ Plateforme non prise en charge pour '
      'l\'export Appearance.',
    );

    return null;
  } catch (e, s) {
    debugPrint(
      '❌ Erreur export Appearance: $e',
    );
    debugPrint('$s');

    return null;
  }
}
