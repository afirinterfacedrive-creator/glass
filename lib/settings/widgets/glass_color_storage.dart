import 'package:flutter/material.dart';
import 'package:universal_glass/enums/glass_enums.dart';
import 'glass_color_storage_primitives.dart';
import 'glass_color_storage_presets.dart';

class GlassColorStorage {
  const GlassColorStorage._();

  // Redirection des Primitives
  static Future<void> saveDouble(String key, double value) => GlassColorStoragePrimitives.saveDouble(key, value);
  static Future<double?> loadDouble(String key) => GlassColorStoragePrimitives.loadDouble(key);
  static Future<void> removeDouble(String key) => GlassColorStoragePrimitives.removeDouble(key);

  static Future<void> saveString(String key, String value) => GlassColorStoragePrimitives.saveString(key, value);
  static Future<String?> loadString(String key) => GlassColorStoragePrimitives.loadString(key);
  static Future<void> removeString(String key) => GlassColorStoragePrimitives.removeString(key);

  static Future<void> saveBool(String key, bool value) => GlassColorStoragePrimitives.saveBool(key, value);
  static Future<bool?> loadBool(String key) => GlassColorStoragePrimitives.loadBool(key);
  static Future<void> removeBool(String key) => GlassColorStoragePrimitives.removeBool(key);

  static Future<void> saveInt(String key, int value) => GlassColorStoragePrimitives.saveInt(key, value);
  static Future<int?> loadInt(String key) => GlassColorStoragePrimitives.loadInt(key);

  // Redirection des Couleurs & Presets
  static Future<void> saveColor(String key, Color color) => GlassColorStoragePresets.saveColor(key, color);
  static Future<Color?> loadColor(String key) => GlassColorStoragePresets.loadColor(key);
  static Future<void> removeColor(String key) => GlassColorStoragePresets.removeColor(key);

  static Future<void> saveColorList(String key, List<Color> colors) => GlassColorStoragePresets.saveColorList(key, colors);
  static Future<List<Color>?> loadColorList(String key) => GlassColorStoragePresets.loadColorList(key);
  static Future<void> removeColorList(String key) => GlassColorStoragePresets.removeColorList(key);

  static Future<void> savePresetGradient(GlassStyle style, List<Color> colors, {required bool useAqua}) => GlassColorStoragePresets.savePresetGradient(style, colors, useAqua: useAqua);
  static Future<List<Color>?> loadPresetGradient(GlassStyle style, {required bool useAqua}) => GlassColorStoragePresets.loadPresetGradient(style, useAqua: useAqua);
  static Future<void> saveUserGradient(String customKey, List<Color> colors, {required bool useAqua}) => GlassColorStoragePresets.saveUserGradient(customKey, colors, useAqua: useAqua);
  static Future<List<Color>?> loadUserGradient(String customKey, {required bool useAqua}) => GlassColorStoragePresets.loadUserGradient(customKey, useAqua: useAqua);
  static Future<void> resetPresetGradient(GlassStyle style) => GlassColorStoragePresets.resetPresetGradient(style);

  // Maintenance & Outils
  static Future<void> clear() => GlassColorStoragePresets.clear();
  static Future<Map<String, dynamic>> getAllGlassKeys() => GlassColorStoragePresets.getAllGlassKeys();
  static Future<String> exportAllPresets() => GlassColorStoragePresets.exportAllPresets();
  static Future<void> importPresets(String jsonString) => GlassColorStoragePresets.importPresets(jsonString);
}
