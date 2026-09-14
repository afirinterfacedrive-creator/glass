part of 'appearance_component_settings_section.dart';

// Widgets publics pour réutilisation dans BaseComponentPanel
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.palette,
    required this.title,
    required this.subtitle,
    required this.trailing,
  });
  final GlassColorPalette palette;
  final String title;
  final String subtitle;
  final Widget trailing;
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: palette.textPrimary)),
              const SizedBox(height: 4),
              Text(subtitle, style: TextStyle(fontSize: 11.5, color: palette.textSecondary)),
            ],
          ),
        ),
        const SizedBox(width: 12),
        trailing,
      ],
    );
  }
}

class ResetButton extends StatelessWidget {
  const ResetButton({super.key, required this.onPressed, required this.palette, required this.mode});
  final VoidCallback onPressed;
  final GlassColorPalette palette;
  final AppThemeMode mode;
  @override
  Widget build(BuildContext context) {
    final Color accent = palette.primaryForMode(mode);
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.restart_alt_rounded, size: 16),
      label: const Text('Reset'),
      style: OutlinedButton.styleFrom(
        foregroundColor: accent,
        side: BorderSide(color: accent.withValues(alpha: 0.24)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class ComponentTabBar extends StatelessWidget {
  const ComponentTabBar({super.key, required this.controller, required this.tabs, required this.palette, required this.mode});
  final TabController controller;
  // ignore: library_private_types_in_public_api
  final List<_ComponentTab> tabs;
  final GlassColorPalette palette;
  final AppThemeMode mode;
  @override
  Widget build(BuildContext context) {
    final Color foreground = palette.textPrimary;
    final Color accent = palette.primaryForMode(mode);
    return GlassSurfaceContainer(
      style: GlassStyle.opaqueMat,
      padding: const EdgeInsets.all(3),
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        height: 42,
        child: TabBar(
          controller: controller,
          isScrollable: true,
          dividerHeight: 0,
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorPadding: EdgeInsets.zero,
          indicator: BoxDecoration(borderRadius: BorderRadius.circular(14), color: accent.withValues(alpha: 0.14)),
          labelColor: foreground,
          unselectedLabelColor: palette.textSecondary,
          labelStyle: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700),
          unselectedLabelStyle: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w500),
          tabs: tabs.map((_ComponentTab tab) {
            return Tab(height: 42, child: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[Icon(tab.icon, size: 16), const SizedBox(width: 7), Text(tab.label)]));
          }).toList(),
        ),
      ),
    );
  }
}

class ComponentLayout extends StatelessWidget {
  const ComponentLayout({super.key, required this.controls, required this.preview});
  final List<Widget> controls;
  final Widget preview;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool wide = constraints.maxWidth >= 900;
        if (wide) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(flex: 6, child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: controls)),
              const SizedBox(width: 20),
              Expanded(flex: 4, child: Align(alignment: Alignment.topCenter, child: preview)),
            ],
          );
        }
        return Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: <Widget>[...controls, const SizedBox(height: 20), preview]);
      },
    );
  }
}

class ControlSection extends StatelessWidget {
  const ControlSection({super.key, required this.title, required this.icon, required this.child});
  final String title;
  final IconData icon;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    final GlassColorPalette palette = GlassColorPalette.fromMode(AppThemeMode.system);
    return GlassSurfaceContainer(
      style: GlassStyle.opaqueMat,
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 14),
      borderRadius: BorderRadius.circular(18),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(children: <Widget>[Icon(icon, size: 18, color: palette.textSecondary), const SizedBox(width: 9), Text(title, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: palette.textPrimary))]),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class SwitchRow extends StatelessWidget {
  const SwitchRow({super.key, required this.title, required this.value, required this.palette, required this.onChanged, this.enabled = true, this.subtitle});
  final String title;
  final bool value;
  final GlassColorPalette palette;
  final ValueChanged<bool> onChanged;
  final bool enabled;
  final String? subtitle;
  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1 : 0.42,
      child: Row(
        children: <Widget>[
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[Text(title, style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: palette.textPrimary)), if (subtitle != null) ...<Widget>[const SizedBox(height: 2), Text(subtitle!, style: TextStyle(fontSize: 11, color: palette.textSecondary))]])),
          const SizedBox(width: 12),
          IgnorePointer(ignoring: !enabled, child: GlassBreakerSwitch(value: value, onChanged: onChanged)),
        ],
      ),
    );
  }
}

class SliderRow extends StatelessWidget {
  const SliderRow({super.key, required this.label, required this.value, required this.min, required this.max, required this.divisions, required this.enabled, required this.valueLabel, required this.onChanged});
  final String label;
  final double value;
  final double min;
  final double max;
  final int divisions;
  final bool enabled;
  final String valueLabel;
  final ValueChanged<double> onChanged;
  @override
  Widget build(BuildContext context) {
    final GlassColorPalette palette = GlassColorPalette.fromMode(AppThemeMode.system);
    final double safeValue = value.clamp(min, max).toDouble();
    return Opacity(
      opacity: enabled ? 1 : 0.42,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(children: <Widget>[Expanded(child: Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: palette.textPrimary))), Text(valueLabel, style: TextStyle(fontSize: 11, fontFeatures: const <FontFeature>[FontFeature.tabularFigures()], color: palette.textSecondary))]),
            SliderTheme(data: SliderTheme.of(context).copyWith(trackHeight: 2, thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6), overlayShape: const RoundSliderOverlayShape(overlayRadius: 14)), child: Slider(value: safeValue, min: min, max: max, divisions: divisions, onChanged: enabled ? (double newValue) {onChanged(newValue.clamp(min, max).toDouble());} : null)),
          ],
        ),
      ),
    );
  }
}

class PreviewContainer extends StatelessWidget {
  const PreviewContainer({super.key, required this.title, required this.child, required this.palette});
  final String title;
  final Widget child;
  final GlassColorPalette palette;
  @override
  Widget build(BuildContext context) {
    return GlassSurfaceContainer(
      style: GlassStyle.transparentAqua,
      padding: const EdgeInsets.all(18),
      borderRadius: BorderRadius.circular(20),
      child: ConstrainedBox(constraints: const BoxConstraints(minHeight: 280), child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[Text(title, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1.1, color: palette.textSecondary)), const SizedBox(height: 16), SizedBox(width: double.infinity, child: Center(child: child))])),
    );
  }
}

class _PreviewContainer extends StatelessWidget {
  const _PreviewContainer({
    required this.title,
    required this.child,
    required this.palette,
  });
  final String title;
  final Widget child;
  final GlassColorPalette palette;
  @override
  Widget build(BuildContext context) {
    return GlassSurfaceContainer(
      style: GlassStyle.transparentAqua,
      padding: const EdgeInsets.all(18),
      borderRadius: BorderRadius.circular(20),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 280),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.1,
                color: palette.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: Center(child: child),
            ),
          ],
        ),
      ),
    );
  }
}


class _FormPreview extends StatelessWidget {
  const _FormPreview({
    required this.mode,
    required this.settings,
    required this.palette,
  });
  final AppThemeMode mode;
  final AppearanceFormSettings settings;
  final GlassColorPalette palette;
  @override
  Widget build(BuildContext context) {
    final Color accent = palette.primaryForMode(mode);
    return _PreviewContainer(
      title: 'LIVE PREVIEW',
      palette: palette,
      child: Opacity(
        opacity: settings.enabled ? 1 : 0.38,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: settings.effectiveHorizontalPadding,
            vertical: settings.effectiveVerticalPadding,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(settings.effectiveBorderRadius),
            color: accent.withValues(
              alpha: settings.effectiveBackgroundOpacity * 0.12,
            ),
            border: settings.effectiveBorderWidth > 0
                ? Border.all(
                    width: settings.effectiveBorderWidth,
                    color: accent.withValues(
                      alpha: settings.effectiveBorderOpacity,
                    ),
                  )
                : null,
            boxShadow:
                settings.effectiveShadowBlur > 0 ||
                    settings.effectiveShadowOpacity > 0
                ? <BoxShadow>[
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: settings.effectiveShadowOpacity,
                      ),
                      blurRadius: settings.effectiveShadowBlur,
                      offset: Offset(0, settings.effectiveShadowOffsetY),
                    ),
                  ]
                : null,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _PreviewField(label: 'First name', palette: palette),
              SizedBox(height: settings.effectiveFieldSpacing),
              _PreviewField(label: 'Email', palette: palette),
              SizedBox(height: settings.effectiveActionsSpacing),
              SizedBox(
                width: double.infinity,
                height: 40,
                child: FilledButton(
                  onPressed: settings.enabled ? () {} : null,
                  child: const Text('Continue', style: TextStyle(fontSize: 11)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PreviewField extends StatelessWidget {
  const _PreviewField({required this.label, required this.palette});
  final String label;
  final GlassColorPalette palette;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 42,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: palette.textPrimary.withValues(alpha: 0.10)),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 11, color: palette.textSecondary),
      ),
    );
  }
}

class _InputPreview extends StatelessWidget {
  const _InputPreview({
    required this.mode,
    required this.settings,
    required this.palette,
  });
  final AppThemeMode mode;
  final AppearanceInputSettings settings;
  final GlassColorPalette palette;
  @override
  Widget build(BuildContext context) {
    final Color accent = palette.primaryForMode(mode);
    return _PreviewContainer(
      title: 'LIVE PREVIEW',
      palette: palette,
      child: Opacity(
        opacity: settings.enabled ? 1 : 0.38,
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 340),
          height: settings.effectiveFieldHeight,
          padding: EdgeInsets.symmetric(
            horizontal: settings.effectiveHorizontalPadding,
            vertical: settings.effectiveVerticalPadding,
          ),
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(settings.effectiveBorderRadius),
            color: accent.withValues(
              alpha: settings.effectiveBackgroundOpacity * 0.18,
            ),
            border: settings.effectiveBorderWidth > 0
                ? Border.all(
                    width: settings.effectiveBorderWidth,
                    color: accent.withValues(
                      alpha: settings.effectiveBorderOpacity,
                    ),
                  )
                : null,
            boxShadow:
                settings.effectiveShadowBlur > 0 ||
                    settings.effectiveShadowOpacity > 0
                ? <BoxShadow>[
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: settings.effectiveShadowOpacity,
                      ),
                      blurRadius: settings.effectiveShadowBlur,
                      offset: Offset(0, settings.effectiveShadowOffsetY),
                    ),
                  ]
                : null,
          ),
          child: Row(
            children: <Widget>[
              Icon(
                Icons.edit_outlined,
                size: 17,
                color: accent.withValues(alpha: 0.85),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  'Saisissez une valeur...',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12, color: palette.textSecondary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ModalDialogPreview extends StatelessWidget {
  const _ModalDialogPreview({
    required this.mode,
    required this.settings,
    required this.palette,
  });
  final AppThemeMode mode;
  final AppearanceComponentSettings settings;
  final GlassColorPalette palette;
  @override
  Widget build(BuildContext context) {
    final Color accent = palette.primaryForMode(mode);
    return _PreviewContainer(
      title: 'LIVE PREVIEW',
      palette: palette,
      child: Opacity(
        opacity: settings.enabled ? 1 : 0.38,
        child: Transform.translate(
          offset: Offset(0, settings.effectiveHoverLift * -0.25),
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(maxWidth: 320),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                settings.effectiveBorderRadius,
              ),
              color: accent.withValues(
                alpha: settings.effectiveBackgroundOpacity * 0.18,
              ),
              border: settings.effectiveBorderWidth > 0
                  ? Border.all(
                      width: settings.effectiveBorderWidth,
                      color: accent.withValues(
                        alpha: settings.effectiveBorderOpacity,
                      ),
                    )
                  : null,
              boxShadow:
                  settings.effectiveShadowBlur > 0 ||
                      settings.effectiveShadowOpacity > 0
                  ? <BoxShadow>[
                      BoxShadow(
                        color: Colors.black.withValues(
                          alpha: settings.effectiveShadowOpacity,
                        ),
                        blurRadius: settings.effectiveShadowBlur,
                        offset: Offset(0, settings.effectiveShadowOffsetY),
                      ),
                    ]
                  : null,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(Icons.auto_awesome_rounded, size: 24, color: accent),
                const SizedBox(height: 12),
                Text(
                  'Dialog preview',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: palette.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Modal et Dialog utilisent ce même style.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 11, color: palette.textSecondary),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 38,
                  child: FilledButton(
                    onPressed: settings.enabled ? () {} : null,
                    child: const Text(
                      'Confirm',
                      style: TextStyle(fontSize: 11),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ToastPreview extends StatelessWidget {
  const _ToastPreview({
    required this.mode,
    required this.settings,
    required this.palette,
  });
  final AppThemeMode mode;
  final AppearanceToastSettings settings;
  final GlassColorPalette palette;
  @override
  Widget build(BuildContext context) {
    final Color accent = palette.primaryForMode(mode);
    final double previewMaxWidth = settings.effectiveMaxWidth
        .clamp(180, 360)
        .toDouble();
    return _PreviewContainer(
      title: 'LIVE PREVIEW',
      palette: palette,
      child: Opacity(
        opacity: settings.enabled ? 1 : 0.38,
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(maxWidth: previewMaxWidth),
          padding: EdgeInsets.symmetric(
            horizontal: settings.effectiveHorizontalPadding,
            vertical: settings.effectiveVerticalPadding,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(settings.effectiveBorderRadius),
            color: accent.withValues(
              alpha: settings.effectiveBackgroundOpacity * 0.18,
            ),
            border: settings.effectiveBorderWidth > 0
                ? Border.all(
                    width: settings.effectiveBorderWidth,
                    color: accent.withValues(
                      alpha: settings.effectiveBorderOpacity,
                    ),
                  )
                : null,
            boxShadow:
                settings.effectiveShadowBlur > 0 ||
                    settings.effectiveShadowOpacity > 0
                ? <BoxShadow>[
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: settings.effectiveShadowOpacity,
                      ),
                      blurRadius: settings.effectiveShadowBlur,
                      offset: Offset(0, settings.effectiveShadowOffsetY),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(Icons.check_circle_outline_rounded, size: 20, color: accent),
              const SizedBox(width: 10),
              Flexible(
                child: Text(
                  'Operation completed successfully',
                  style: TextStyle(fontSize: 11, color: palette.textPrimary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TooltipPreview extends StatelessWidget {
  const _TooltipPreview({
    required this.mode,
    required this.settings,
    required this.palette,
  });
  final AppThemeMode mode;
  final AppearanceTooltipSettings settings;
  final GlassColorPalette palette;
  @override
  Widget build(BuildContext context) {
    final Color accent = palette.primaryForMode(mode);
    final double previewMaxWidth = settings.effectiveMaxWidth
        .clamp(140, 340)
        .toDouble();
    return _PreviewContainer(
      title: 'LIVE PREVIEW',
      palette: palette,
      child: Opacity(
        opacity: settings.enabled ? 1 : 0.38,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: double.infinity,
              constraints: BoxConstraints(maxWidth: previewMaxWidth),
              padding: EdgeInsets.symmetric(
                horizontal: settings.effectiveHorizontalPadding,
                vertical: settings.effectiveVerticalPadding,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  settings.effectiveBorderRadius,
                ),
                color: accent.withValues(
                  alpha: settings.effectiveBackgroundOpacity * 0.18,
                ),
                border: settings.effectiveBorderWidth > 0
                    ? Border.all(
                        width: settings.effectiveBorderWidth,
                        color: accent.withValues(
                          alpha: settings.effectiveBorderOpacity,
                        ),
                      )
                    : null,
                boxShadow:
                    settings.effectiveShadowBlur > 0 ||
                        settings.effectiveShadowOpacity > 0
                    ? <BoxShadow>[
                        BoxShadow(
                          color: Colors.black.withValues(
                            alpha: settings.effectiveShadowOpacity,
                          ),
                          blurRadius: settings.effectiveShadowBlur,
                          offset: Offset(0, settings.effectiveShadowOffsetY),
                        ),
                      ]
                    : null,
              ),
              child: Text(
                'This is a tooltip preview',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11, color: palette.textPrimary),
              ),
            ),
            const SizedBox(height: 8),
            Icon(Icons.arrow_drop_down_rounded, size: 22, color: accent),
            const SizedBox(height: 4),
            Icon(Icons.mouse_outlined, size: 18, color: palette.textSecondary),
          ],
        ),
      ),
    );
  }
}
