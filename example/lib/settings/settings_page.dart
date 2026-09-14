import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:universal_glass/glass.dart';
import 'package:universal_glass_example/settings/widgets/appearance/appearance_component_settings_section.dart';
import 'package:universal_glass_example/settings/widgets/appearance/appearance_section.dart';
import 'sections/display_section.dart';
import 'sections/general_section.dart';

/// ============================================================================
/// SETTINGS SECTION
/// ============================================================================
/// Définit la section de paramètres à afficher.
/// [null] Affiche la page complète des paramètres.
/// [SettingsSection.appearance] Affiche uniquement la configuration des profils d'apparence.
/// [SettingsSection.components] Affiche uniquement la configuration des composants.
/// [SettingsSection.display] Affiche uniquement les paramètres d'affichage.
/// [SettingsSection.general] Affiche uniquement les paramètres généraux.
enum SettingsSection { appearance, components, display, general }

/// ============================================================================
/// SETTINGS PAGE
/// ============================================================================
/// RESPONSABILITÉ
/// -----------------------------------------------------------------------------
/// Page principale des paramètres.
/// Les paramètres sont organisés en sections : Appearance, Components, Display, General.
/// La page peut également être ouverte directement sur une section précise grâce à [initialSection].
class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key, this.initialSection});

  /// Section à afficher directement.
  /// Lorsque cette valeur est `null`, la page complète des paramètres est affichée.
  final SettingsSection? initialSection;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // THÈME
    // WATCH permet de reconstruire automatiquement la page lorsque les paramètres du thème changent en direct.
    final GlassThemeState theme = ref.watch(glassThemeProvider);
    return GlassScaffold(
      // APP BAR
      title: switch (initialSection) {
        SettingsSection.appearance => 'Appearance',
        SettingsSection.components => 'Components',
        SettingsSection.display => 'Display',
        SettingsSection.general => 'General',
        null => 'Settings',
      },
      subtitle: switch (initialSection) {
        SettingsSection.appearance => 'APPEARANCE SETTINGS',
        SettingsSection.components => 'COMPONENT SETTINGS',
        SettingsSection.display => 'DISPLAY SETTINGS',
        SettingsSection.general => 'GENERAL SETTINGS',
        null => 'APPLICATION SETTINGS',
      },
      showLogo: true,
      showBackButton: true,
      blur: theme.effectiveBlur,
      noise: theme.effectiveNoise,
      hideNavigation: true,
      maxWidth: 1200.0,
      // CONTENU
      child: Builder(
        builder: (BuildContext context) {
          final GlassLayoutContext glass = context.glassLayout;
          final bool compact = glass.isSmallMobile || glass.isMobile;
          if (initialSection != null) {
            return _buildSingleSection(
              context,
              glass,
              compact,
              initialSection!,
              theme.themeMode,
            );
          }
          return _buildFullSettings(context, glass, compact, theme.themeMode);
        },
      ),
    );
  }
}

// ============================================================================
// PAGE COMPLÈTE
// ============================================================================
Widget _buildFullSettings(
  BuildContext context,
  GlassLayoutContext glass,
  bool compact,
  AppThemeMode mode,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Settings',
        style: TextStyle(
          color: Colors.white,
          fontSize: glass.fontSize(compact ? 24.0 : 28.0),
          fontWeight: FontWeight.bold,
          shadows: const [Shadow(blurRadius: 10, color: Colors.black26)],
        ),
      ),
      SizedBox(height: glass.spacing(6.0)),
      Text(
        'Configurez l’apparence, les composants, l’affichage et les préférences de l’application.',
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.54),
          fontSize: glass.fontSize(compact ? 11.0 : 12.0),
          height: 1.4,
        ),
      ),
      SizedBox(height: glass.spacing(compact ? 24.0 : 30.0)),
      GlassResponsiveGrid(
        spacing: glass.spacing(24.0),
        runSpacing: glass.spacing(24.0),
        mobileColumns: 1,
        tabletColumns: 1,
        desktopColumns: 2,
        children: [
          const AppearanceSection(),
          AppearanceComponentSettingsSection(mode: mode),
          const DisplaySection(),
          const GeneralSection(),
        ],
      ),
      SizedBox(height: glass.spacing(36.0)),
    ],
  );
}

// ============================================================================
// SECTION UNIQUE
// ============================================================================
Widget _buildSingleSection(
  BuildContext context,
  GlassLayoutContext glass,
  bool compact,
  SettingsSection section,
  AppThemeMode mode,
) {
  switch (section) {
    case SettingsSection.appearance:
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Appearance',
            style: TextStyle(
              color: Colors.white,
              fontSize: glass.fontSize(compact ? 24.0 : 28.0),
              fontWeight: FontWeight.bold,
              shadows: const [Shadow(blurRadius: 10, color: Colors.black26)],
            ),
          ),
          SizedBox(height: glass.spacing(6.0)),
          Text(
            'Personnalisez les profils d’apparence et les effets visuels de Glass.',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.54),
              fontSize: glass.fontSize(compact ? 11.0 : 12.0),
              height: 1.4,
            ),
          ),
          SizedBox(height: glass.spacing(compact ? 24.0 : 30.0)),
          const AppearanceSection(),
          SizedBox(height: glass.spacing(36.0)),
        ],
      );
    case SettingsSection.components:
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Components',
            style: TextStyle(
              color: Colors.white,
              fontSize: glass.fontSize(compact ? 24.0 : 28.0),
              fontWeight: FontWeight.bold,
              shadows: const [Shadow(blurRadius: 10, color: Colors.black26)],
            ),
          ),
          SizedBox(height: glass.spacing(6.0)),
          Text(
            'Configurez l’apparence des composants Form, Modal / Dialog, Toast et Tooltip.',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.54),
              fontSize: glass.fontSize(compact ? 11.0 : 12.0),
              height: 1.4,
            ),
          ),
          SizedBox(height: glass.spacing(compact ? 24.0 : 30.0)),
          AppearanceComponentSettingsSection(mode: mode),
          SizedBox(height: glass.spacing(36.0)),
        ],
      );
    case SettingsSection.display:
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Display',
            style: TextStyle(
              color: Colors.white,
              fontSize: glass.fontSize(compact ? 24.0 : 28.0),
              fontWeight: FontWeight.bold,
              shadows: const [Shadow(blurRadius: 10, color: Colors.black26)],
            ),
          ),
          SizedBox(height: glass.spacing(6.0)),
          Text(
            'Configurez les paramètres d’affichage de l’application.',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.54),
              fontSize: glass.fontSize(compact ? 11.0 : 12.0),
              height: 1.4,
            ),
          ),
          SizedBox(height: glass.spacing(compact ? 24.0 : 30.0)),
          const DisplaySection(),
          SizedBox(height: glass.spacing(36.0)),
        ],
      );
    case SettingsSection.general:
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'General',
            style: TextStyle(
              color: Colors.white,
              fontSize: glass.fontSize(compact ? 24.0 : 28.0),
              fontWeight: FontWeight.bold,
              shadows: const [Shadow(blurRadius: 10, color: Colors.black26)],
            ),
          ),
          SizedBox(height: glass.spacing(6.0)),
          Text(
            'Configurez les préférences générales de l’application.',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.54),
              fontSize: glass.fontSize(compact ? 11.0 : 12.0),
              height: 1.4,
            ),
          ),
          SizedBox(height: glass.spacing(compact ? 24.0 : 30.0)),
          const GeneralSection(),
          SizedBox(height: glass.spacing(36.0)),
        ],
      );
  }
}
