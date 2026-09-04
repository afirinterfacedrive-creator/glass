import 'package:shared_preferences/shared_preferences.dart';

class GlassColorStoragePrimitives {
  const GlassColorStoragePrimitives._();

  static const String prefix = 'glass_color_';
  static SharedPreferences? cache;

  static Future<SharedPreferences> getPrefs() async {
    cache ??= await SharedPreferences.getInstance();
    return cache!;
  }

  // ==========================================================================
  // DOUBLE
  // ==========================================================================
  static Future<void> saveDouble(String key, double value) async {
    final prefs = await getPrefs();
    await prefs.setDouble('$prefix$key', value);
  }

  static Future<double?> loadDouble(String key) async {
    final prefs = await getPrefs();
    final dynamic value = prefs.get('$prefix$key');
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  static Future<void> removeDouble(String key) async {
    final prefs = await getPrefs();
    await prefs.remove('$prefix$key');
  }

  // ==========================================================================
  // STRING
  // ==========================================================================
  static Future<void> saveString(String key, String value) async {
    final prefs = await getPrefs();
    await prefs.setString('$prefix$key', value);
  }

  static Future<String?> loadString(String key) async {
    final prefs = await getPrefs();
    return prefs.getString('$prefix$key');
  }

  static Future<void> removeString(String key) async {
    final prefs = await getPrefs();
    await prefs.remove('$prefix$key');
  }

  // ==========================================================================
  // BOOL
  // ==========================================================================
  static Future<void> saveBool(String key, bool value) async {
    final prefs = await getPrefs();
    await prefs.setBool('$prefix$key', value);
  }

  static Future<bool?> loadBool(String key) async {
    final prefs = await getPrefs();
    final dynamic value = prefs.get('$prefix$key');
    if (value == null) return null;
    if (value is bool) return value;
    if (value is int) return value == 1;
    if (value is String) return value.toLowerCase() == 'true';
    return null;
  }

  static Future<void> removeBool(String key) async {
    final prefs = await getPrefs();
    await prefs.remove('$prefix$key');
  }

  // ==========================================================================
  // INT
  // ==========================================================================
  static Future<void> saveInt(String key, int value) async {
    final prefs = await getPrefs();
    await prefs.setInt('$prefix$key', value);
  }

  static Future<int?> loadInt(String key) async {
    final prefs = await getPrefs();
    final dynamic value = prefs.get('$prefix$key');
    if (value == null) return null;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }
}
