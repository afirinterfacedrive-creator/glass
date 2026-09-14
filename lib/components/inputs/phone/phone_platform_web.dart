import 'dart:async';
import 'dart:convert';
// ignore: deprecated_member_use, avoid_web_libraries_in_flutter
import 'dart:html' as html;

import 'package:flutter/foundation.dart';

Future<String?> importJsonFromPlatform() async {
  try {
    final html.FileUploadInputElement uploadInput =
        html.FileUploadInputElement()
          ..accept = '.json,application/json';

    uploadInput.click();

    await uploadInput.onChange.first;

    final List<html.File>? files =
        uploadInput.files;

    if (files == null || files.isEmpty) {
      return null;
    }

    final html.File file = files.first;

    final html.FileReader reader =
        html.FileReader();

    final Completer<String?> completer =
        Completer<String?>();

    reader.onLoad.listen((_) {
      try {
        final dynamic result = reader.result;

        if (result is String) {
          completer.complete(result);
        } else {
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
    debugPrint('❌ Erreur import Web: $e');
    debugPrint('$s');
    return null;
  }
}

Future<String?> saveJsonToLocalFile({
  required String jsonString,
}) async {
  // SharedPreferences est utilisé par
  // PhoneInputController pour la persistance.
  return null;
}

Future<String?> readLocalJsonFile() async {
  return null;
}

Future<DateTime?> localJsonLastModified() async {
  return null;
}

Future<void> deleteLocalJsonFile() async {
  // Rien à supprimer sur Web.
}

Future<String?> exportJsonToPlatform({
  required String jsonString,
}) async {
  try {
    final List<int> bytes =
        utf8.encode(jsonString);

    final html.Blob blob = html.Blob(
      <dynamic>[bytes],
      'application/json',
    );

    final String url =
        html.Url.createObjectUrlFromBlob(blob);

    final html.AnchorElement anchor =
        html.AnchorElement(href: url)
          ..setAttribute(
            'download',
            'phone_countries.json',
          )
          ..style.display = 'none';

    html.document.body?.children.add(anchor);

    anchor.click();

    anchor.remove();

    html.Url.revokeObjectUrl(url);

    return 'phone_countries.json';
  } catch (e, s) {
    debugPrint('❌ Erreur export Web: $e');
    debugPrint('$s');

    return null;
  }
}