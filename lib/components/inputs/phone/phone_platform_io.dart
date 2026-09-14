import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

Future<String?> importJsonFromPlatform() async {
  try {
    final FilePickerResult? result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
      withData: true,
    );

    if (result == null || result.files.isEmpty) {
      return null;
    }

    final PlatformFile file = result.files.single;

    if (file.bytes != null) {
      return utf8.decode(file.bytes!);
    }

    if (file.path != null) {
      return await File(file.path!).readAsString();
    }

    return null;
  } catch (e, s) {
    debugPrint('❌ Erreur import JSON: $e');
    debugPrint('$s');
    return null;
  }
}

Future<String?> saveJsonToLocalFile({
  required String jsonString,
}) async {
  try {
    final Directory appDir =
        await getApplicationDocumentsDirectory();

    final File file = File(
      '${appDir.path}/custom_phone_countries.json',
    );

    await file.writeAsString(jsonString);

    return file.path;
  } catch (e, s) {
    debugPrint('❌ Erreur sauvegarde fichier: $e');
    debugPrint('$s');
    return null;
  }
}

Future<String?> readLocalJsonFile() async {
  try {
    final Directory appDir =
        await getApplicationDocumentsDirectory();

    final File file = File(
      '${appDir.path}/custom_phone_countries.json',
    );

    if (!await file.exists()) {
      return null;
    }

    return await file.readAsString();
  } catch (e) {
    debugPrint('❌ Erreur lecture fichier: $e');
    return null;
  }
}

Future<DateTime?> localJsonLastModified() async {
  try {
    final Directory appDir =
        await getApplicationDocumentsDirectory();

    final File file = File(
      '${appDir.path}/custom_phone_countries.json',
    );

    if (!await file.exists()) {
      return null;
    }

    return await file.lastModified();
  } catch (_) {
    return null;
  }
}

Future<void> deleteLocalJsonFile() async {
  try {
    final Directory appDir =
        await getApplicationDocumentsDirectory();

    final File file = File(
      '${appDir.path}/custom_phone_countries.json',
    );

    if (await file.exists()) {
      await file.delete();
    }
  } catch (e) {
    debugPrint('❌ Erreur suppression fichier: $e');
  }
}

Future<String?> exportJsonToPlatform({
  required String jsonString,
}) async {
  try {
    final Directory appDir =
        await getApplicationDocumentsDirectory();

    final File exportFile = File(
      '${appDir.path}/export_phone_countries_'
      '${DateTime.now().millisecondsSinceEpoch}.json',
    );

    await exportFile.writeAsString(jsonString);

    if (Platform.isWindows ||
        Platform.isMacOS ||
        Platform.isLinux) {
      await Clipboard.setData(
        ClipboardData(text: exportFile.path),
      );
    }

    if (Platform.isAndroid || Platform.isIOS) {
      await SharePlus.instance.share(
        ShareParams(
          files: [
            XFile(exportFile.path),
          ],
          text: 'Export PhoneCountries ${DateTime.now()}',
        ),
      );
    }

    return exportFile.path;
  } catch (e, s) {
    debugPrint('❌ Erreur export: $e');
    debugPrint('$s');
    return null;
  }
}