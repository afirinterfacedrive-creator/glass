import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:universal_glass/phone/phone_country.dart';
import 'package:universal_glass/phone/phone_country_database.dart';

/// Controller for the Universal Glass phone input.
///
/// Responsibilities:
/// - Manage the current phone number.
/// - Normalize the entered number.
/// - Detect the current operator.
/// - Validate the number length.
/// - Manage the selected country.
/// - Load phone countries from persistent storage or bundled assets.
/// - Persist operator/prefix modifications.
/// - Import/export phone data as JSON.
///
/// Persistence strategy:
/// - [SharedPreferences] is used for automatic persistence.
/// - [FilePicker] is used only for explicit JSON import/export.
///
/// No platform-specific `dart:io` or `dart:html` API is used here.
/// This keeps the controller compatible with Web, Windows, macOS,
/// Linux, Android and iOS.
class PhoneInputController extends ChangeNotifier {
  // ===========================================================================
  // CONFIGURATION
  // ===========================================================================

  final SharedPreferences _preferences;

  /// SharedPreferences key containing the customized phone database.
  static const String _kLocalCountriesKey =
      'custom_phone_countries_v2';

  // ===========================================================================
  // CONTROLLERS / STATE
  // ===========================================================================

  final TextEditingController textController;

  PhoneCountry? _effectiveCountry;

  List<PhoneCountry> _allCountries = [];

  bool _isLoading = false;

  Future<void>? _loadingFuture;

  String _normalizedPhone = '';

  String _submittedPhone = '';

  PhoneOperator? _operator;

  // ===========================================================================
  // FAST LOOKUP MAPS
  // ===========================================================================

  final Map<String, PhoneCountry> _countryMap =
      <String, PhoneCountry>{};

  final Map<String, PhoneCountry> _prefixMap =
      <String, PhoneCountry>{};

  // ===========================================================================
  // CONSTRUCTOR
  // ===========================================================================

  PhoneInputController({
    required SharedPreferences preferences,
    TextEditingController? controller,
    PhoneCountry? initialCountry,
  })  : _preferences = preferences,
        textController =
            controller ?? TextEditingController(),
        _effectiveCountry = initialCountry {
    textController.addListener(_onTextChanged);

    loadCountries();
  }

  // ===========================================================================
  // GETTERS
  // ===========================================================================

  /// All currently loaded countries.
  List<PhoneCountry> get allCountries =>
      List<PhoneCountry>.unmodifiable(_allCountries);

  /// Whether the phone database is currently loading.
  bool get isLoading => _isLoading;

  /// Currently selected country.
  PhoneCountry? get country => _effectiveCountry;

  /// Alias for [country].
  PhoneCountry? get effectiveCountry =>
      _effectiveCountry;

  /// Raw phone number entered in the text field.
  String get phoneNumber => textController.text;

  /// Alias for [phoneNumber].
  String get rawText => textController.text;

  /// Phone number normalized for the selected country.
  String get normalizedPhone => _normalizedPhone;

  /// Phone number stored when submitted.
  String get submittedPhone => _submittedPhone;

  /// Currently detected operator.
  PhoneOperator? get operator => _operator;

  /// Kept for backward compatibility with the previous API.
  String get name => '';

  /// Detects the operator directly from the current text.
  PhoneOperator? get detectedOperator {
    final String normalized =
        normalizePhoneNumber(rawText);

    final PhoneCountry? currentCountry =
        _effectiveCountry;

    if (currentCountry == null ||
        normalized.isEmpty) {
      return null;
    }

    return currentCountry.operatorForPrefix(
      normalized,
    );
  }

  /// Returns whether the current phone number has
  /// a valid length for the selected country.
  bool get isValid {
    final PhoneCountry? currentCountry =
        _effectiveCountry;

    if (currentCountry == null) {
      return false;
    }

    final String normalized =
        normalizePhoneNumber(rawText);

    if (normalized.isEmpty) {
      return false;
    }

    return currentCountry.acceptsLength(
      normalized.length,
    );
  }

  // ===========================================================================
  // SETTERS
  // ===========================================================================

  /// Changes the current phone number.
  void setPhoneNumber(String value) {
    if (textController.text == value) {
      return;
    }

    textController.value =
        textController.value.copyWith(
      text: value,
      selection: TextSelection.collapsed(
        offset: value.length,
      ),
      composing: TextRange.empty,
    );
  }

  /// Kept for backward compatibility.
  void setName(String value) {
    // Intentionally unused.
    //
    // This method remains part of the public API so existing
    // applications using older versions do not break.
  }

  /// Manually updates the normalized phone number.
  void setNormalizedPhone(String value) {
    if (_normalizedPhone == value) {
      return;
    }

    _normalizedPhone = value;

    _updateDetectedOperator();

    notifyListeners();
  }

  /// Stores the submitted phone number.
  void setSubmittedPhone(String value) {
    if (_submittedPhone == value) {
      return;
    }

    _submittedPhone = value;

    notifyListeners();
  }

  /// Changes the current country.
  void setCountry(PhoneCountry value) {
    effectiveCountry = value;
  }

  /// Changes the detected operator manually.
  void setOperator(PhoneOperator? value) {
    if (_operator == value) {
      return;
    }

    _operator = value;

    notifyListeners();
  }

  /// Changes the effective country.
  set effectiveCountry(PhoneCountry? value) {
    if (_effectiveCountry?.isoCode == value?.isoCode) {
      return;
    }

    _effectiveCountry = value;

    _updateNormalizedPhone();
    _updateDetectedOperator();

    notifyListeners();
  }

  // ===========================================================================
  // PHONE NORMALIZATION
  // ===========================================================================

  /// Normalizes a phone number.
  ///
  /// Removes all non-digit characters and removes the selected
  /// country's dial code when it is present.
  String normalizePhoneNumber(String text) {
    String cleaned = text.replaceAll(
      RegExp(r'[^\d]'),
      '',
    );

    final PhoneCountry? currentCountry =
        _effectiveCountry;

    if (currentCountry != null) {
      final String dial =
          currentCountry.dialCode.replaceAll('+', '');

      if (dial.isNotEmpty &&
          cleaned.startsWith(dial)) {
        cleaned =
            cleaned.substring(dial.length);
      }
    }

    return cleaned;
  }

  // ===========================================================================
  // TEXT CHANGE
  // ===========================================================================

  void _onTextChanged() {
    _updateNormalizedPhone();
    _updateDetectedOperator();

    notifyListeners();
  }

  void _updateNormalizedPhone() {
    _normalizedPhone =
        normalizePhoneNumber(
      textController.text,
    );
  }

  void _updateDetectedOperator() {
    final PhoneCountry? currentCountry =
        _effectiveCountry;

    if (currentCountry == null ||
        _normalizedPhone.isEmpty) {
      _operator = null;
      return;
    }

    _operator =
        currentCountry.operatorForPrefix(
      _normalizedPhone,
    );
  }

  // ===========================================================================
  // MAPS
  // ===========================================================================

  void _rebuildMaps() {
    _countryMap.clear();
    _prefixMap.clear();

    for (final PhoneCountry country
        in _allCountries) {
      _countryMap[country.isoCode] =
          country;

      _prefixMap[country.dialCode] =
          country;
    }
  }

  /// Finds a country by ISO code.
  PhoneCountry? findCountryByIso(
    String isoCode,
  ) {
    return _countryMap[isoCode];
  }

  /// Finds a country by dial code.
  PhoneCountry? findCountryByDialCode(
    String dialCode,
  ) {
    return _prefixMap[dialCode];
  }

  // ===========================================================================
  // LOADING
  // ===========================================================================

  /// Loads the phone database.
  ///
  /// SharedPreferences takes priority over the bundled database.
  /// If no customized data exists, the bundled asset database is loaded.
  Future<void> loadCountries({
    bool force = false,
  }) {
    if (force) {
      _loadingFuture = null;
    }

    _loadingFuture ??= _loadInternal();

    return _loadingFuture!;
  }

  Future<void> _loadInternal() async {
    if (_isLoading) {
      return;
    }

    _isLoading = true;

    notifyListeners();

    try {
      List<PhoneCountry> loadedCountries;

      // -----------------------------------------------------------------------
      // 1. SHARED PREFERENCES
      // -----------------------------------------------------------------------

      final String? savedJson =
          _preferences.getString(
        _kLocalCountriesKey,
      );

      if (savedJson != null &&
          savedJson.trim().isNotEmpty) {
        try {
          loadedCountries =
              _decodeCountriesJson(
            savedJson,
          );

          debugPrint(
            '✅ Phone database loaded from '
            'SharedPreferences: '
            '${loadedCountries.length} countries',
          );
        } catch (e) {
          debugPrint(
            '⚠️ Invalid saved phone database: $e',
          );

          loadedCountries =
              await PhoneCountryDatabase.load();

          debugPrint(
            '📦 Fallback to bundled database: '
            '${loadedCountries.length} countries',
          );
        }
      } else {
        // ---------------------------------------------------------------------
        // 2. BUNDLED DATABASE
        // ---------------------------------------------------------------------

        loadedCountries =
            await PhoneCountryDatabase.load();

        debugPrint(
          '📦 Phone database loaded from assets: '
          '${loadedCountries.length} countries',
        );
      }

      // -----------------------------------------------------------------------
      // 3. INSTALL DATA
      // -----------------------------------------------------------------------

      _allCountries =
          List<PhoneCountry>.from(
        loadedCountries,
      );

      _rebuildMaps();

      _restoreEffectiveCountry();

      _updateNormalizedPhone();
      _updateDetectedOperator();
    } catch (e, stackTrace) {
      debugPrint(
        '❌ Error loading phone database: $e',
      );

      debugPrint('$stackTrace');

      // -----------------------------------------------------------------------
      // FINAL FALLBACK
      // -----------------------------------------------------------------------

      try {
        _allCountries =
            await PhoneCountryDatabase.load();

        _rebuildMaps();

        _restoreEffectiveCountry();

        _updateNormalizedPhone();
        _updateDetectedOperator();
      } catch (fallbackError, fallbackStack) {
        debugPrint(
          '❌ Database fallback failed: '
          '$fallbackError',
        );

        debugPrint('$fallbackStack');

        _allCountries = [];

        _countryMap.clear();
        _prefixMap.clear();

        _effectiveCountry = null;
        _operator = null;
        _normalizedPhone = '';
      }
    } finally {
      _isLoading = false;

      _loadingFuture = null;

      notifyListeners();
    }
  }

  // ===========================================================================
  // RESTORE CURRENT COUNTRY
  // ===========================================================================

  void _restoreEffectiveCountry() {
    if (_allCountries.isEmpty) {
      _effectiveCountry = null;
      return;
    }

    final String? currentIso =
        _effectiveCountry?.isoCode;

    if (currentIso == null) {
      _effectiveCountry =
          _allCountries.firstWhere(
        (country) =>
            country.isoCode == 'BF',
        orElse: () =>
            _allCountries.first,
      );

      return;
    }

    _effectiveCountry =
        _allCountries.firstWhere(
      (country) =>
          country.isoCode == currentIso,
      orElse: () =>
          _allCountries.firstWhere(
        (country) =>
            country.isoCode == 'BF',
        orElse: () =>
            _allCountries.first,
      ),
    );
  }

  // ===========================================================================
  // JSON DECODING
  // ===========================================================================

  List<PhoneCountry> _decodeCountriesJson(
    String jsonString,
  ) {
    final dynamic decoded =
        jsonDecode(jsonString);

    late final List<dynamic> jsonList;

    if (decoded is List) {
      jsonList = decoded;
    } else if (decoded is Map &&
        decoded['countries'] is List) {
      jsonList =
          decoded['countries'] as List<dynamic>;
    } else {
      throw const FormatException(
        'Invalid phone countries JSON format.',
      );
    }

    return jsonList.map(
      (dynamic value) {
        if (value is! Map) {
          throw const FormatException(
            'Invalid country entry.',
          );
        }

        final Map<String, dynamic> map =
            Map<String, dynamic>.from(value);

        return PhoneCountry.fromJson(map);
      },
    ).toList();
  }

  // ===========================================================================
  // SAVE
  // ===========================================================================

  /// Saves the current phone database to SharedPreferences.
  ///
  /// This is the automatic persistence mechanism used by the package.
  Future<bool> _saveToLocalDrive() async {
    try {
      final String jsonString =
          jsonEncode(
        _allCountries
            .map(
              (PhoneCountry country) =>
                  country.toJson(),
            )
            .toList(),
      );

      final bool saved =
          await _preferences.setString(
        _kLocalCountriesKey,
        jsonString,
      );

      if (!saved) {
        debugPrint(
          '❌ SharedPreferences refused to save '
          'the phone database.',
        );

        return false;
      }

      debugPrint(
        '💾 Phone database saved: '
        '${_allCountries.length} countries | '
        '${jsonString.length} characters',
      );

      return true;
    } catch (e, stackTrace) {
      debugPrint(
        '❌ Error saving phone database: $e',
      );

      debugPrint('$stackTrace');

      return false;
    }
  }

  // ===========================================================================
  // ADD OPERATOR PREFIX
  // ===========================================================================

  Future<void> addPrefixToOperator({
    required String countryIso,
    required String operatorId,
    required String newPrefix,
  }) async {
    final String prefix =
        newPrefix.trim();

    if (prefix.isEmpty) {
      return;
    }

    debugPrint(
      '➡️ Adding prefix $prefix '
      'to $operatorId / $countryIso',
    );

    final int countryIndex =
        _allCountries.indexWhere(
      (PhoneCountry country) =>
          country.isoCode == countryIso,
    );

    if (countryIndex == -1) {
      debugPrint(
        '❌ Country not found: $countryIso',
      );
      return;
    }

    final PhoneCountry country =
        _allCountries[countryIndex];

    final int operatorIndex =
        country.operatorsDetailed.indexWhere(
      (PhoneOperator operator) =>
          operator.id == operatorId,
    );

    if (operatorIndex == -1) {
      debugPrint(
        '❌ Operator not found: $operatorId',
      );
      return;
    }

    final PhoneOperator operator =
        country.operatorsDetailed[operatorIndex];

    if (operator.prefixes.contains(prefix)) {
      debugPrint(
        '⚠️ Prefix already exists: $prefix',
      );
      return;
    }

    // -------------------------------------------------------------------------
    // 1. OPERATOR
    // -------------------------------------------------------------------------

    final List<String> updatedPrefixes = [
      ...operator.prefixes,
      prefix,
    ];

    final PhoneOperator updatedOperator =
        operator.copyWith(
      prefixes: updatedPrefixes,
    );

    // -------------------------------------------------------------------------
    // 2. OPERATORS
    // -------------------------------------------------------------------------

    final List<PhoneOperator>
        updatedOperators =
        List<PhoneOperator>.from(
      country.operatorsDetailed,
    );

    updatedOperators[operatorIndex] =
        updatedOperator;

    // -------------------------------------------------------------------------
    // 3. COUNTRY PREFIXES
    // -------------------------------------------------------------------------

    final List<String>
        updatedCountryPrefixes =
        List<String>.from(
      country.prefixes,
    );

    if (!updatedCountryPrefixes.contains(
      prefix,
    )) {
      updatedCountryPrefixes.add(prefix);
    }

    // -------------------------------------------------------------------------
    // 4. COUNTRY
    // -------------------------------------------------------------------------

    final PhoneCountry updatedCountry =
        country.copyWith(
      operatorsDetailed:
          updatedOperators,
      prefixes:
          updatedCountryPrefixes,
    );

    final List<PhoneCountry>
        updatedCountries =
        List<PhoneCountry>.from(
      _allCountries,
    );

    updatedCountries[countryIndex] =
        updatedCountry;

    _allCountries = updatedCountries;

    // -------------------------------------------------------------------------
    // 5. MAPS / CURRENT COUNTRY
    // -------------------------------------------------------------------------

    _rebuildMaps();

    if (_effectiveCountry?.isoCode ==
        countryIso) {
      _effectiveCountry =
          updatedCountry;
    }

    _updateNormalizedPhone();
    _updateDetectedOperator();

    // -------------------------------------------------------------------------
    // 6. SAVE
    // -------------------------------------------------------------------------

    await _saveToLocalDrive();

    notifyListeners();

    debugPrint(
      '✅ Prefix added: $prefix',
    );
  }

  // ===========================================================================
  // REMOVE OPERATOR PREFIX
  // ===========================================================================

  Future<void> removePrefixFromOperator({
    required String countryIso,
    required String operatorId,
    required String prefixToRemove,
  }) async {
    final String prefix =
        prefixToRemove.trim();

    if (prefix.isEmpty) {
      return;
    }

    final int countryIndex =
        _allCountries.indexWhere(
      (PhoneCountry country) =>
          country.isoCode == countryIso,
    );

    if (countryIndex == -1) {
      debugPrint(
        '❌ Country not found: $countryIso',
      );
      return;
    }

    final PhoneCountry country =
        _allCountries[countryIndex];

    final int operatorIndex =
        country.operatorsDetailed.indexWhere(
      (PhoneOperator operator) =>
          operator.id == operatorId,
    );

    if (operatorIndex == -1) {
      debugPrint(
        '❌ Operator not found: $operatorId',
      );
      return;
    }

    final PhoneOperator operator =
        country.operatorsDetailed[operatorIndex];

    if (!operator.prefixes.contains(prefix)) {
      debugPrint(
        '⚠️ Prefix not found: $prefix',
      );
      return;
    }

    // -------------------------------------------------------------------------
    // 1. OPERATOR PREFIXES
    // -------------------------------------------------------------------------

    final List<String> updatedPrefixes =
        operator.prefixes
            .where(
              (String value) =>
                  value != prefix,
            )
            .toList();

    final PhoneOperator updatedOperator =
        operator.copyWith(
      prefixes: updatedPrefixes,
    );

    // -------------------------------------------------------------------------
    // 2. OPERATORS
    // -------------------------------------------------------------------------

    final List<PhoneOperator>
        updatedOperators =
        List<PhoneOperator>.from(
      country.operatorsDetailed,
    );

    updatedOperators[operatorIndex] =
        updatedOperator;

    // -------------------------------------------------------------------------
    // 3. COUNTRY
    // -------------------------------------------------------------------------

    final PhoneCountry updatedCountry =
        country.copyWith(
      operatorsDetailed:
          updatedOperators,
    );

    final List<PhoneCountry>
        updatedCountries =
        List<PhoneCountry>.from(
      _allCountries,
    );

    updatedCountries[countryIndex] =
        updatedCountry;

    _allCountries = updatedCountries;

    // -------------------------------------------------------------------------
    // 4. MAPS
    // -------------------------------------------------------------------------

    _rebuildMaps();

    // -------------------------------------------------------------------------
    // 5. CURRENT COUNTRY
    // -------------------------------------------------------------------------

    if (_effectiveCountry?.isoCode ==
        countryIso) {
      _effectiveCountry =
          updatedCountry;
    }

    _updateNormalizedPhone();
    _updateDetectedOperator();

    // -------------------------------------------------------------------------
    // 6. SAVE
    // -------------------------------------------------------------------------

    await _saveToLocalDrive();

    notifyListeners();

    debugPrint(
      '🗑️ Prefix removed: $prefix',
    );
  }

  // ===========================================================================
  // JSON EXPORT
  // ===========================================================================

  /// Returns the complete phone database as formatted JSON.
  String getJsonString() {
    if (_allCountries.isEmpty) {
      return '[]';
    }

    return const JsonEncoder.withIndent(
      '  ',
    ).convert(
      _allCountries
          .map(
            (PhoneCountry country) =>
                country.toJson(),
          )
          .toList(),
    );
  }

  /// Opens a save dialog and exports the current phone database.
  ///
  /// Returns the selected destination path/identifier,
  /// or an empty string when the operation is cancelled
  /// or fails.
  Future<String> exportToJson() async {
    try {
      final String jsonString =
          getJsonString();

      final Uint8List bytes =
          Uint8List.fromList(
        utf8.encode(jsonString),
      );

      final String fileName =
          'phone_countries_'
          '${DateTime.now().millisecondsSinceEpoch}'
          '.json';

      final String? savedPath =
          await FilePicker.saveFile(
        dialogTitle:
            'Exporter les pays téléphoniques',
        fileName: fileName,
        bytes: bytes,
        type: FileType.custom,
        allowedExtensions: <String>[
          'json',
        ],
      );

      if (savedPath == null ||
          savedPath.isEmpty) {
        debugPrint(
          '⚠️ Export cancelled by user.',
        );

        return '';
      }

      debugPrint(
        '✅ JSON export successful: '
        '$savedPath',
      );

      return savedPath;
    } catch (e, stackTrace) {
      debugPrint(
        '❌ JSON export error: $e',
      );

      debugPrint('$stackTrace');

      return '';
    }
  }

  // ===========================================================================
  // JSON IMPORT
  // ===========================================================================

  /// Opens a file picker and imports a phone database from JSON.
  ///
  /// The imported database replaces the current database
  /// and is immediately persisted in SharedPreferences.
  Future<bool> importFromJson() async {
    try {
      debugPrint(
        '📥 Opening JSON file picker...',
      );

      final FilePickerResult? result =
          await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: <String>[
          'json',
        ],
        allowMultiple: false,
        withData: true,
      );

      if (result == null ||
          result.files.isEmpty) {
        debugPrint(
          '⚠️ JSON import cancelled.',
        );

        return false;
      }

      final PlatformFile file =
          result.files.single;

      Uint8List? bytes = file.bytes;

      // -----------------------------------------------------------------------
      // FALLBACK WHEN BYTES ARE NOT PROVIDED
      // -----------------------------------------------------------------------

      if (bytes == null) {
        try {
          final XFile xFile = file.xFile;

          bytes = await xFile.readAsBytes();
        } catch (e) {
          debugPrint(
            '❌ Unable to read selected file: $e',
          );

          return false;
        }
      }

      if (bytes.isEmpty) {
        debugPrint(
          '❌ Selected JSON file is empty.',
        );

        return false;
      }

      // -----------------------------------------------------------------------
      // UTF-8
      // -----------------------------------------------------------------------

      final String jsonString =
          utf8.decode(
        bytes,
        allowMalformed: false,
      );

      if (jsonString.trim().isEmpty) {
        debugPrint(
          '❌ JSON content is empty.',
        );

        return false;
      }

      // -----------------------------------------------------------------------
      // DECODE
      // -----------------------------------------------------------------------

      final List<PhoneCountry> importedCountries =
          _decodeCountriesJson(
        jsonString,
      );

      if (importedCountries.isEmpty) {
        debugPrint(
          '❌ Imported JSON contains no countries.',
        );

        return false;
      }

      // -----------------------------------------------------------------------
      // PRESERVE CURRENT COUNTRY
      // -----------------------------------------------------------------------

      final String? previousIso =
          _effectiveCountry?.isoCode;

      // -----------------------------------------------------------------------
      // REPLACE DATABASE
      // -----------------------------------------------------------------------

      _allCountries =
          List<PhoneCountry>.from(
        importedCountries,
      );

      // -----------------------------------------------------------------------
      // MAPS
      // -----------------------------------------------------------------------

      _rebuildMaps();

      // -----------------------------------------------------------------------
      // RESTORE CURRENT COUNTRY
      // -----------------------------------------------------------------------

      if (previousIso != null) {
        _effectiveCountry =
            _countryMap[previousIso];

        _effectiveCountry ??=
            _allCountries.first;
      } else {
        _restoreEffectiveCountry();
      }

      _updateNormalizedPhone();
      _updateDetectedOperator();

      // -----------------------------------------------------------------------
      // PERSIST
      // -----------------------------------------------------------------------

      final bool saved =
          await _saveToLocalDrive();

      if (!saved) {
        debugPrint(
          '⚠️ Import completed but persistence failed.',
        );
      }

      // -----------------------------------------------------------------------
      // NOTIFY
      // -----------------------------------------------------------------------

      notifyListeners();

      debugPrint(
        '✅ JSON import successful: '
        '${_allCountries.length} countries',
      );

      return true;
    } on FormatException catch (e) {
      debugPrint(
        '❌ Invalid JSON format: $e',
      );

      return false;
    } catch (e, stackTrace) {
      debugPrint(
        '❌ JSON import error: $e',
      );

      debugPrint('$stackTrace');

      return false;
    }
  }

  // ===========================================================================
  // RESET
  // ===========================================================================

  /// Removes all customized phone data and restores the bundled database.
  Future<void> resetToDefault() async {
    try {
      debugPrint(
        '♻️ Resetting phone database...',
      );

      // -----------------------------------------------------------------------
      // REMOVE PERSISTED CUSTOM DATABASE
      // -----------------------------------------------------------------------

      await _preferences.remove(
        _kLocalCountriesKey,
      );

      // -----------------------------------------------------------------------
      // CLEAR DATABASE CACHE
      // -----------------------------------------------------------------------

      PhoneCountryDatabase.clearCache();

      // -----------------------------------------------------------------------
      // CLEAR CURRENT STATE
      // -----------------------------------------------------------------------

      _allCountries = [];

      _countryMap.clear();
      _prefixMap.clear();

      _effectiveCountry = null;
      _operator = null;
      _normalizedPhone = '';

      // -----------------------------------------------------------------------
      // RELOAD BUNDLED DATABASE
      // -----------------------------------------------------------------------

      _loadingFuture = null;

      await loadCountries(
        force: true,
      );

      debugPrint(
        '✅ Phone database restored to bundled defaults.',
      );
    } catch (e, stackTrace) {
      debugPrint(
        '❌ Reset error: $e',
      );

      debugPrint('$stackTrace');
    }
  }

  // ===========================================================================
  // DISPOSE
  // ===========================================================================

  @override
  void dispose() {
    textController.removeListener(
      _onTextChanged,
    );

    textController.dispose();

    super.dispose();
  }
}