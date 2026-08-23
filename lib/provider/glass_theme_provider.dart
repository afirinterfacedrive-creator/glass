import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../enums/glass_enums.dart';
import '../providers/shared_preferences_provider.dart';
import '../theme/glass_effects.dart';

// ============================================================================
// ÉTAT GLOBAL DU THÈME GLASS
// ============================================================================
class GlassThemeState {
  final bool useAquaStyle;

  const GlassThemeState({this.useAquaStyle = true});

  GlassThemeState copyWith({bool? useAquaStyle}) {
    return GlassThemeState(useAquaStyle: useAquaStyle ?? this.useAquaStyle);
  }

  GlassStyle get style {
    return useAquaStyle ? GlassStyle.transparentAqua : GlassStyle.opaqueMat;
  }

  GlassEffects get effects {
    return useAquaStyle ? GlassEffects.liquidWhite : GlassEffects.liquidDark;
  }

  Color get appBarBackgroundColor {
    return useAquaStyle ? const Color(0xE610242A) : const Color(0xE6171717);
  }

  Color get appBarBorderColor {
    return useAquaStyle
        ? Colors.white.withValues(alpha: 0.24)
        : Colors.white.withValues(alpha: 0.16);
  }

  Color get appBarIconColor {
    return useAquaStyle ? Colors.cyanAccent : Colors.white;
  }
}

// ============================================================================
// NOTIFIER DU THÈME GLASS
// ============================================================================
class GlassThemeNotifier extends Notifier<GlassThemeState> {
  static const String _aquaKey = 'glass_use_aqua_style';

  dynamic get _prefs => ref.read(sharedPreferencesProvider);

  @override
  GlassThemeState build() {
    final savedValue = _prefs.getBool(_aquaKey);

    return GlassThemeState(useAquaStyle: savedValue ?? true);
  }

  // ==========================================================================
  // ACTIVER / DÉSACTIVER LE STYLE AQUA
  // ==========================================================================
  Future<void> setAquaStyle(bool value) async {
    if (state.useAquaStyle == value) {
      return;
    }

    state = state.copyWith(useAquaStyle: value);

    await _prefs.setBool(_aquaKey, value);
  }

  // ==========================================================================
  // TOGGLE STYLE
  // ==========================================================================
  Future<void> toggleAquaStyle() async {
    await setAquaStyle(!state.useAquaStyle);
  }

  // ==========================================================================
  // RESET
  // ==========================================================================
  Future<void> reset() async {
    await setAquaStyle(true);
  }
}

// ============================================================================
// PROVIDER GLOBAL DU THÈME GLASS
// ============================================================================
final glassThemeProvider =
    NotifierProvider<GlassThemeNotifier, GlassThemeState>(
      GlassThemeNotifier.new,
    );
