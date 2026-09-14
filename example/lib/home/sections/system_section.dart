import 'package:flutter/foundation.dart';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:universal_glass/glass.dart';
import '../widgets/status_card.dart';

class SystemSection extends ConsumerWidget {
  const SystemSection({super.key});

  String _getOsName() {
    if (kIsWeb) return 'Web';
    final String os = Platform.operatingSystem;
    if (os == 'android') return 'Android';
    if (os == 'ios') return 'iOS';
    if (os == 'macos') return 'macOS';
    if (os == 'windows') return 'Windows';
    if (os == 'linux') return 'Linux';
    return os.toUpperCase();
  }

  String _getOsVersion() {
    if (kIsWeb) return 'Browser';
    final String version = Platform.operatingSystemVersion;
    if (Platform.isWindows) {
      String clean = version.replaceAll('Windows', '').trim();
      if (clean.length > 15) {
        final RegExp regex = RegExp(r'[\d\.]+');
        final match = regex.firstMatch(clean);
        if (match != null) {
          return 'Build ${match.group(0)}';
        }
      }
      return clean.isEmpty ? 'Active' : clean;
    }
    final List<String> parts = version.split(' ');
    if (parts.isNotEmpty) {
      return parts[0].replaceAll('"', '');
    }
    return 'Active';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GlassLayoutContext glass = GlassLayoutScope.of(context);
    final palette = glass.palette;
    final bool isSmallMobile = glass.isSmallMobile;

    final String osName = _getOsName();
    final String osVersion = _getOsVersion();

    return LayoutBuilder(
      builder: (context, constraints) {
        final double maxWidth = constraints.maxWidth;
        const double spacing = 16.0;

        int crossAxisCount = 1;
        if (maxWidth >= 750) {
          crossAxisCount = 3;
        } else if (maxWidth >= 480) {
          crossAxisCount = 2;
        }

        final double cardWidth =
            (maxWidth - (spacing * (crossAxisCount - 1))) / crossAxisCount;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GlassText(
              'SYSTEM',
              fontSize: isSmallMobile ? 12 : 13,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.3,
              alpha: 0.7,
            ),
            SizedBox(height: isSmallMobile ? 10 : 14),

            Wrap(
              spacing: spacing,
              runSpacing: 12,
              children: [
                SizedBox(
                  width: cardWidth,
                  child: HomeStatusCard(
                    // <- SUPPRIMÉ theme: theme
                    icon: kIsWeb
                        ? Icons.web_outlined
                        : Icons.phone_android_outlined,
                    iconColor: palette.accent, // <- AJOUTÉ pour cohérence
                    title: 'Device OS',
                    value: osName,
                    active: true,
                  ),
                ),
                SizedBox(
                  width: cardWidth,
                  child: HomeStatusCard(
                    // <- SUPPRIMÉ theme: theme
                    icon: Icons.settings_applications_outlined,
                    iconColor: palette.accent, // <- AJOUTÉ pour cohérence
                    title: 'OS Version',
                    value: osVersion,
                    active: true,
                  ),
                ),
                SizedBox(
                  width: cardWidth,
                  child: HomeStatusCard(
                    icon: Icons.auto_awesome_outlined,
                    iconColor: palette.accent,
                    title: 'Glass Engine',
                    value: glass.theme.glassStyle.name.contains('sage')
                        ? 'SAGE Live'
                        : glass.theme.useAquaStyle
                        ? 'Aqua Live'
                        : 'Classic Live',
                    active: true,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
