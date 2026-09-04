import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:universal_glass/glass.dart';
import 'package:universal_glass_example/home/widgets/glass_style_gallery/glass_style_grid_item.dart';
import 'package:universal_glass_example/home/widgets/glass_style_gallery/glass_style_live_preview.dart';



import 'glass_style_gallery_helpers.dart';
import 'glass_style_settings_panel.dart';

class GlassStyleGallery extends ConsumerWidget {
  const GlassStyleGallery({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GlassThemeState theme = ref.watch(glassThemeProvider);
    final GlassThemeNotifier notifier =
        ref.read(glassThemeProvider.notifier);

    final Size size = MediaQuery.sizeOf(context);
    final double width = size.width;

    final bool isMobile = width < 600;
    final bool isTablet = width >= 600 && width < 1024;

    final int columns = isMobile
        ? 1
        : isTablet
            ? 2
            : 3;

    final Color textColor = theme.useAquaStyle
        ? Colors.cyanAccent
        : Colors.white;

    final Color accentColor = theme.useAquaStyle
        ? Colors.cyanAccent
        : Colors.pinkAccent;

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: _buildAppBar(
        theme: theme,
        notifier: notifier,
        textColor: textColor,
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildLivePreview(
              theme: theme,
              isMobile: isMobile,
            ),

            const Divider(
              color: Colors.white12,
              height: 24,
              thickness: 1,
            ),

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.fromLTRB(
                  isMobile ? 12 : 24,
                  0,
                  isMobile ? 12 : 24,
                  36,
                ),
                child: Column(
                  children: [
                    _buildPresetGrid(
                      context: context,
                      ref: ref,
                      theme: theme,
                      columns: columns,
                      isMobile: isMobile,
                    ),

                    const SizedBox(height: 28),

                    GlassStyleSettingsPanel(
                      theme: theme,
                      notifier: notifier,
                      textColor: textColor,
                      accentColor: accentColor,
                      isMobile: isMobile,
                    ),

                    const SizedBox(height: 36),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar({
    required GlassThemeState theme,
    required GlassThemeNotifier notifier,
    required Color textColor,
  }) {
    return AppBar(
      title: const Text(
        'Glass Style Gallery',
        style: TextStyle(
          fontWeight: FontWeight.w700,
        ),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      foregroundColor: Colors.white,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: IconButton(
            icon: Icon(
              Icons.restart_alt_rounded,
              color: textColor,
            ),
            tooltip: 'Réinitialiser',
            onPressed: notifier.reset,
          ),
        ),
      ],
    );
  }

  Widget _buildLivePreview({
    required GlassThemeState theme,
    required bool isMobile,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 12 : 24,
        vertical: 8,
      ),
      child: GlassStyleLivePreview(
        theme: theme,
        isMobile: isMobile,
        title: GlassStyleGalleryHelpers.getStyleNameFormatted(
          theme.glassStyle,
        ),
        description:
            'Blur: ${theme.blur.toInt()}'
            '  •  Opacité: ${theme.surfaceOpacity.toStringAsFixed(2)}'
            '  •  ${theme.enableBlur ? "Blur actif" : "Blur désactivé"}',
        icon: theme.breakerOn
            ? Icons.power_off_rounded
            : GlassStyleGalleryHelpers.getStyleIcon(
                theme.glassStyle,
              ),
        isNew: theme.glassStyle.name.contains('sage'),
      ),
    );
  }

  Widget _buildPresetGrid({
    required BuildContext context,
    required WidgetRef ref,
    required GlassThemeState theme,
    required int columns,
    required bool isMobile,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double availableWidth = constraints.maxWidth;

        final double spacing = isMobile ? 0 : 16;

        final double itemWidth = columns == 1
            ? availableWidth
            : (availableWidth - spacing * (columns - 1)) / columns;

        final double itemHeight = isMobile
            ? 138
            : itemWidth < 320
                ? 138
                : 130;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: GlassStyle.values.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: spacing,
            mainAxisSpacing: 16,
            mainAxisExtent: itemHeight,
          ),
          itemBuilder: (context, index) {
            final GlassStyle style = GlassStyle.values[index];

            final bool isActive = theme.glassStyle == style;
            final bool isNew = style.name.contains('sage');

            return GlassStyleGridItem(
              style: style,
              isActive: isActive,
              enableHover: theme.enableHover,
              title: GlassStyleGalleryHelpers.getStyleNameFormatted(
                style,
              ),
              description: GlassStyleGalleryHelpers.getStyleDescription(
                style,
              ),
              icon: GlassStyleGalleryHelpers.getStyleIcon(style),
              index: index,
              isNew: isNew,
              onTap: () {
                ref
                    .read(glassThemeProvider.notifier)
                    .setGlassStyle(style);
              },
            );
          },
        );
      },
    );
  }
}