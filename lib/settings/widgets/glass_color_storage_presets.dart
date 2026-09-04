import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:universal_glass/enums/glass_enums.dart';
import 'glass_color_storage_primitives.dart';

class GlassColorStoragePresets {
  const GlassColorStoragePresets._();

  // ==========================================================================
  // COLOR
  // ==========================================================================
  static Future<void> saveColor(String key, Color color) async {
    final prefs = await GlassColorStoragePrimitives.getPrefs();
    await prefs.setInt('${GlassColorStoragePrimitives.prefix}$key', color.toARGB32());
  }

  static Future<Color?> loadColor(String key) async {
    final prefs = await GlassColorStoragePrimitives.getPrefs();
    final dynamic value = prefs.get('${GlassColorStoragePrimitives.prefix}$key');
    if (value == null) return null;
    if (value is int) return Color(value);
    if (value is String) {
      final intVal = int.tryParse(value);
      if (intVal != null) return Color(intVal);
    }
    return null;
  }

  static Future<void> removeColor(String key) async {
    final prefs = await GlassColorStoragePrimitives.getPrefs();
    await prefs.remove('${GlassColorStoragePrimitives.prefix}$key');
  }

  // ==========================================================================
  // COLOR LIST (GRADIENTS)
  // ==========================================================================
  static Future<void> saveColorList(String key, List<Color> colors) async {
    final prefs = await GlassColorStoragePrimitives.getPrefs();
    final values = colors.map((c) => c.toARGB32().toString()).toList();
    await prefs.setStringList('${GlassColorStoragePrimitives.prefix}$key', values);
  }

  static Future<List<Color>?> loadColorList(String key) async {
    try {
      final prefs = await GlassColorStoragePrimitives.getPrefs();
      final List<String>? values = prefs.getStringList('${GlassColorStoragePrimitives.prefix}$key');
      if (values == null) return null;
      return values.map((v) => Color(int.parse(v))).toList();
    } catch (e) {
      debugPrint('GlassColorStorage: Erreur loadColorList $key -> $e');
      await removeColorList(key);
      return null;
    }
  }

  static Future<void> removeColorList(String key) async {
    final prefs = await GlassColorStoragePrimitives.getPrefs();
    await prefs.remove('${GlassColorStoragePrimitives.prefix}$key');
  }

  // ==========================================================================
  // PRESETS GRADIENT & USER GRADIENTS
  // ==========================================================================
  static Future<void> savePresetGradient(GlassStyle style, List<Color> colors, {required bool useAqua}) async {
    final suffix = useAqua ? '_aqua' : '_classic';
    await saveColorList('preset_${style.name}$suffix', colors);
  }

  static Future<List<Color>?> loadPresetGradient(GlassStyle style, {required bool useAqua}) async {
    final suffix = useAqua ? '_aqua' : '_classic';
    return await loadColorList('preset_${style.name}$suffix');
  }

  static Future<void> saveUserGradient(String customKey, List<Color> colors, {required bool useAqua}) async {
    final suffix = useAqua ? '_aqua' : '_classic';
    await saveColorList('user_$customKey$suffix', colors);
  }

  static Future<List<Color>?> loadUserGradient(String customKey, {required bool useAqua}) async {
    final suffix = useAqua ? '_aqua' : '_classic';
    return await loadColorList('user_$customKey$suffix');
  }

  static Future<void> resetPresetGradient(GlassStyle style) async {
    await removeColorList('preset_${style.name}_aqua');
    await removeColorList('preset_${style.name}_classic');
  }

  // ==========================================================================
  // MAINTENANCE & JSON
  // ==========================================================================
  static Future<void> clear() async {
    final prefs = await GlassColorStoragePrimitives.getPrefs();
    final keys = prefs.getKeys().where((k) => k.startsWith(GlassColorStoragePrimitives.prefix)).toList();
    for (final key in keys) {
      await prefs.remove(key);
    }
    GlassColorStoragePrimitives.cache = null;
  }

  static Future<Map<String, dynamic>> getAllGlassKeys() async {
    final prefs = await GlassColorStoragePrimitives.getPrefs();
    final Map<String, dynamic> result = {};
    for (final key in prefs.getKeys().where((k) => k.startsWith(GlassColorStoragePrimitives.prefix))) {
      result[key] = prefs.get(key);
    }
    return result;
  }

  static Future<String> exportAllPresets() async {
    final prefs = await GlassColorStoragePrimitives.getPrefs();
    final Map<String, dynamic> data = {};

    for (final key in prefs.getKeys().where((k) => k.startsWith(GlassColorStoragePrimitives.prefix))) {
      final value = prefs.get(key);
      if (value is List<String>) {
        data[key.replaceFirst(GlassColorStoragePrimitives.prefix, '')] = value.map((v) => int.parse(v)).toList();
      } else {
        data[key.replaceFirst(GlassColorStoragePrimitives.prefix, '')] = value;
      }
    }
    return jsonEncode(data);
  }

  static Future<void> importPresets(String jsonString) async {
    final prefs = await GlassColorStoragePrimitives.getPrefs();
    final Map<String, dynamic> data = jsonDecode(jsonString);

    for (final entry in data.entries) {
      final key = '${GlassColorStoragePrimitives.prefix}${entry.key}';
      if (entry.value is List) {
        final colorStrings = (entry.value as List).map((v) => v.toString()).toList();
        await prefs.setStringList(key, colorStrings);
      } else if (entry.value is int) {
        await prefs.setInt(key, entry.value);
      } else if (entry.value is double) {
        await prefs.setDouble(key, entry.value);
      } else if (entry.value is bool) {
        await prefs.setBool(key, entry.value);
      } else if (entry.value is String) {
        await prefs.setString(key, entry.value);
      }
    }
  }
}
