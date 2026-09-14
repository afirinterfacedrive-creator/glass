import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:universal_glass/phone/phone_country.dart';

class PhoneCountryManager {
  List<PhoneCountry> _countries = [];

  List<PhoneCountry> get countries => _countries;

  Future<File> _getLocalFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/custom_phone_countries.json');
  }

  Future<void> initializeCountries() async {
    try {
      final localFile = await _getLocalFile();
      String jsonContent;

      if (await localFile.exists()) {
        jsonContent = await localFile.readAsString();
      } else {
        try {
          jsonContent = await rootBundle.loadString('packages/universal_glass/assets/phone_countries.json');
        } catch (_) {
          jsonContent = await rootBundle.loadString('assets/phone_countries.json');
        }
        await localFile.writeAsString(jsonContent);
      }

      final List<dynamic> decodedJson = jsonDecode(jsonContent);
      _countries = decodedJson.map((json) => PhoneCountry.fromJson(json)).toList();

    } catch (e) {
      debugPrint("Erreur init pays: $e");
      _countries = [];
    }
  }

  Future<void> _save() async {
    final localFile = await _getLocalFile();
    final jsonString = jsonEncode(_countries.map((c) => c.toJson()).toList());
    await localFile.writeAsString(jsonString);
  }

  // CRUD
  Future<void> addPrefixToOperator({
    required String countryIso,
    required String operatorId,
    required String newPrefix,
  }) async {
    final countryIndex = _countries.indexWhere((c) => c.isoCode == countryIso);
    if (countryIndex == -1) return;

    final country = _countries[countryIndex];
    final opIndex = country.operatorsDetailed.indexWhere((op) => op.id == operatorId);
    if (opIndex == -1) return;

    final operator = country.operatorsDetailed[opIndex];
    if (operator.prefixes.contains(newPrefix)) return;

    final updatedPrefixes = [...operator.prefixes, newPrefix];
    final updatedOperator = operator.copyWith(prefixes: updatedPrefixes);

    final updatedOperators = [...country.operatorsDetailed];
    updatedOperators[opIndex] = updatedOperator;

    final updatedCountryPrefixes = [...country.prefixes];
    if (!updatedCountryPrefixes.contains(newPrefix)) {
      updatedCountryPrefixes.add(newPrefix);
    }

    _countries[countryIndex] = country.copyWith(
      operatorsDetailed: updatedOperators,
      prefixes: updatedCountryPrefixes,
    );

    await _save(); // <- CRITIQUE: Sauvegarde direct
  }

  Future<void> removePrefixFromOperator({
    required String countryIso,
    required String operatorId,
    required String prefixToRemove,
  }) async {
    final countryIndex = _countries.indexWhere((c) => c.isoCode == countryIso);
    if (countryIndex == -1) return;

    final country = _countries[countryIndex];
    final opIndex = country.operatorsDetailed.indexWhere((op) => op.id == operatorId);
    if (opIndex == -1) return;

    final operator = country.operatorsDetailed[opIndex];
    if (!operator.prefixes.contains(prefixToRemove)) return;

    final updatedPrefixes = operator.prefixes.where((p) => p!= prefixToRemove).toList();
    final updatedOperator = operator.copyWith(prefixes: updatedPrefixes);

    final updatedOperators = [...country.operatorsDetailed];
    updatedOperators[opIndex] = updatedOperator;

    _countries[countryIndex] = country.copyWith(operatorsDetailed: updatedOperators);
    await _save();
  }

  Future<void> resetToDefault() async {
    final localFile = await _getLocalFile();
    if (await localFile.exists()) await localFile.delete();
    await initializeCountries();
  }
}