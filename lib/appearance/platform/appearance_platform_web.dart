
import 'dart:async';
import 'dart:convert';

// ignore: deprecated_member_use, avoid_web_libraries_in_flutter
import 'dart:html' as html;

import 'package:flutter/foundation.dart';

/// ============================================================================
/// APPEARANCE PLATFORM — WEB
/// ============================================================================
///
/// Plateforme :
/// - Web
///
/// Cette couche ne connaît pas [GlassThemeState].
/// Elle manipule uniquement du JSON.
///
/// Le Web ne dispose pas d'un accès équivalent à dart:io.
/// L'import utilise donc un sélecteur de fichier navigateur et l'export
/// utilise un téléchargement via Blob + AnchorElement.
///
/// La persistance normale de l'apparence reste assurée par le système
/// de persistance de Universal Glass.
/// ============================================================================

/// ============================================================================
/// IMPORT
/// ============================================================================

/// Ouvre le sélecteur de fichiers du navigateur et importe un JSON.
///
/// Retourne le contenu du fichier sélectionné.
///
/// Retourne `null` si :
/// - l'utilisateur annule ;
/// - aucun fichier n'est sélectionné ;
/// - le fichier ne peut pas être lu ;
/// - une erreur survient.
Future<String?> importJsonFromPlatform() async {
  try {
    final html.FileUploadInputElement uploadInput =
        html.FileUploadInputElement()
          ..accept = '.json,application/json';

    uploadInput.click();

    await uploadInput.onChange.first;

    final List<html.File>? files = uploadInput.files;

    if (files == null || files.isEmpty) {
      return null;
    }

    final html.File file = files.first;

    final html.FileReader reader = html.FileReader();

    final Completer<String?> completer =
        Completer<String?>();

    reader.onLoad.listen((_) {
      try {
        final dynamic result = reader.result;

        if (result is String) {
          if (!completer.isCompleted) {
            completer.complete(result);
          }
          return;
        }

        if (!completer.isCompleted) {
          completer.complete(null);
        }
      } catch (e) {
        if (!completer.isCompleted) {
          completer.completeError(e);
        }
      }
    });

    reader.onError.listen((_) {
      if (!completer.isCompleted) {
        completer.complete(null);
      }
    });

    reader.readAsText(file);

    return await completer.future;
  } catch (e, s) {
    debugPrint(
      '❌ Erreur import Appearance Web: $e',
    );
    debugPrint('$s');

    return null;
  }
}

/// ============================================================================
/// LOCAL STORAGE
/// ============================================================================
///
/// Sur Web, ces méthodes restent volontairement neutres.
///
/// La persistance normale de Universal Glass n'utilise pas ces fonctions.
/// Elles existent uniquement afin de conserver la même API entre la
/// plateforme IO et le Web.
///
/// Elles pourront être remplacées ultérieurement par une implémentation
/// IndexedDB si un véritable stockage de fichiers local Web devient
/// nécessaire.
/// ============================================================================

Future<String?> saveJsonToLocalFile({
  required String jsonString,
  required String fileName,
}) async {
  return null;
}

Future<String?> readLocalJsonFile({
  required String fileName,
}) async {
  return null;
}

Future<DateTime?> localJsonLastModified({
  required String fileName,
}) async {
  return null;
}

Future<void> deleteLocalJsonFile({
  required String fileName,
}) async {
  // Rien à supprimer sur Web.
}

/// ============================================================================
/// EXPORT
/// ============================================================================

/// Télécharge un fichier JSON depuis le navigateur.
///
/// Le navigateur décide ensuite de l'emplacement de téléchargement
/// conformément à ses propres paramètres.
///
/// Retourne [fileName] lorsque le téléchargement a été déclenché.
Future<String?> exportJsonToPlatform({
  required String jsonString,
  required String fileName,
}) async {
  try {
    // ------------------------------------------------------------------------
    // Sécurisation du nom de fichier
    // ------------------------------------------------------------------------

    final String normalizedFileName =
        fileName.toLowerCase().endsWith('.json')
            ? fileName
            : '$fileName.json';

    // ------------------------------------------------------------------------
    // JSON → bytes
    // ------------------------------------------------------------------------

    final List<int> bytes = utf8.encode(
      jsonString,
    );

    // ------------------------------------------------------------------------
    // Création du Blob
    // ------------------------------------------------------------------------

    final html.Blob blob = html.Blob(
      <dynamic>[bytes],
      'application/json;charset=utf-8',
    );

    // ------------------------------------------------------------------------
    // URL temporaire
    // ------------------------------------------------------------------------

    final String url =
        html.Url.createObjectUrlFromBlob(blob);

    // ------------------------------------------------------------------------
    // Élément <a download>
    // ------------------------------------------------------------------------

    final html.AnchorElement anchor =
        html.AnchorElement(href: url)
          ..setAttribute(
            'download',
            normalizedFileName,
          )
          ..style.display = 'none';

    // ------------------------------------------------------------------------
    // Ajout temporaire au DOM
    // ------------------------------------------------------------------------

    html.document.body?.children.add(anchor);

    // ------------------------------------------------------------------------
    // Déclenchement du téléchargement
    // ------------------------------------------------------------------------

    anchor.click();

    // ------------------------------------------------------------------------
    // Nettoyage
    // ------------------------------------------------------------------------

    anchor.remove();

    html.Url.revokeObjectUrl(url);

    return normalizedFileName;
  } catch (e, s) {
    debugPrint(
      '❌ Erreur export Appearance Web: $e',
    );
    debugPrint('$s');

    return null;
  }
}
