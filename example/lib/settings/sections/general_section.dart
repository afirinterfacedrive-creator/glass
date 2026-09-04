
import 'package:flutter/material.dart';

import '../widgets/setting_divider.dart';
import '../widgets/setting_section.dart';
import '../widgets/setting_tile.dart';

// ============================================================================
// GENERAL SECTION
// ============================================================================
//
// Section générale des paramètres.
//
// Cette classe appartient uniquement à l'application example.
//
// Elle utilise les widgets de paramètres locaux :
//
// • SettingSection
// • SettingTile
// • SettingDivider
//
// Elle ne dépend pas directement des fichiers internes du package Glass.
//
// ============================================================================

class GeneralSection extends StatelessWidget {
  const GeneralSection({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    const Color accent =
        Colors.cyanAccent;

    return SettingSection(
      title:
          'General',

      accent:
          accent,

      children: [
        // ====================================================================
        // NOTIFICATIONS
        // ====================================================================

        SettingTile(
          icon:
              Icons.notifications_outlined,

          iconColor:
              accent,

          title:
              'Notifications',

          subtitle:
              'Gestion des notifications',

          trailing:
              const Icon(
            Icons.chevron_right,
            color:
                Colors.white54,
          ),

          onTap: () {
            // Navigation future.
          },
        ),

        // ====================================================================
        // DIVIDER
        // ====================================================================

        const SettingDivider(),

        // ====================================================================
        // SOUND
        // ====================================================================

        SettingTile(
          icon:
              Icons.volume_up_outlined,

          iconColor:
              accent,

          title:
              'Sound',

          subtitle:
              'Gestion du son',

          trailing:
              const Icon(
            Icons.chevron_right,
            color:
                Colors.white54,
          ),

          onTap: () {
            // Navigation future.
          },
        ),
      ],
    );
  }
}

