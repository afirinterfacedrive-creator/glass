// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:universal_glass/glass.dart';

class UniversalGlassTextBoxView extends ConsumerStatefulWidget {
  const UniversalGlassTextBoxView({super.key});

  @override
  ConsumerState<UniversalGlassTextBoxView> createState() =>
      _UniversalGlassTextBoxViewState();
}

class _UniversalGlassTextBoxViewState
    extends ConsumerState<UniversalGlassTextBoxView> {
  bool _focused = false;
  bool _enabled = true;
  bool _error = false;
  String _selectedValue = 'Burkina Faso';

  @override
  Widget build(BuildContext context) {
    final GlassLayoutContext glass = GlassLayoutScope.of(context);

    return GlassSurfaceContainer(
      style: glass.effectiveGlassStyle,
      effects: glass.effects,
      borderRadius: BorderRadius.circular(glass.isSmallMobile ? 14 : 20),
      padding: glass.dynamicPadding,
      liftOnHover: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GlassSectionHeader(
            title: 'UniversalGlassTextBox',
            subtitle:
                'Style: ${glass.theme.glassStyle.name}, Single Glass Layer',
            icon: Icons.layers_outlined,
          ),
          SizedBox(height: glass.isSmallMobile ? 16 : 24),

          GlassResponsiveGrid(
            spacing: 16,
            runSpacing: 16,
            mobileColumns: 1,
            tabletColumns: 2,
            desktopColumns: 3,
            children: [
              _buildLabeledGridItem(
                'Texte simple',
                _buildGlassBox(
                  text: 'Burkina Faso',
                  onTap: _handleTap,
                  glass: glass,
                ),
              ),
              _buildLabeledGridItem(
                'Hint',
                _buildGlassBox(hintText: 'Sélectionner un pays', glass: glass),
              ),
              _buildLabeledGridItem(
                'Prefix icon',
                _buildGlassBox(
                  text: 'Burkina Faso',
                  prefixIcon: Icons.public_rounded,
                  onTap: _handleTap,
                  glass: glass,
                ),
              ),
              _buildLabeledGridItem(
                'Suffix icon',
                _buildGlassBox(
                  text: 'Burkina Faso',
                  suffixIcon: Icons.keyboard_arrow_down_rounded,
                  onTap: _handleTap,
                  glass: glass,
                ),
              ),
              _buildLabeledGridItem(
                'Prefix + suffix',
                _buildGlassBox(
                  text: _selectedValue,
                  prefixIcon: Icons.public_rounded,
                  suffixIcon: Icons.keyboard_arrow_down_rounded,
                  onTap: _handleTap,
                  glass: glass,
                ),
              ),
              _buildLabeledGridItem(
                'Focus contrôlé',
                _buildGlassBox(
                  text: 'Zone actuellement focus',
                  prefixIcon: Icons.edit_rounded,
                  isFocused: _focused,
                  onTap: () => setState(() => _focused = !_focused),
                  glass: glass,
                ),
              ),
              _buildLabeledGridItem(
                'Erreur',
                _buildGlassBox(
                  text: 'Valeur invalide',
                  prefixIcon: Icons.warning_amber_rounded,
                  hasError: _error,
                  errorText: _error ? 'Cette valeur est invalide' : null,
                  onTap: () => setState(() => _error = !_error),
                  glass: glass,
                ),
              ),
              _buildLabeledGridItem(
                'Disabled',
                _buildGlassBox(
                  text: 'Champ désactivé',
                  prefixIcon: Icons.lock_outline_rounded,
                  enabled: false,
                  glass: glass,
                ),
              ),
              _buildLabeledGridItem(
                'Texte long / ellipsis',
                _buildGlassBox(
                  text:
                      'Ceci est une très longue valeur qui doit être tronquée automatiquement',
                  prefixIcon: Icons.description_outlined,
                  suffixIcon: Icons.more_horiz_rounded,
                  glass: glass,
                ),
              ),
            ],
          ),

          SizedBox(height: glass.isSmallMobile ? 20 : 28),
          const GlassPreviewLabel('Contrôles'),
          const SizedBox(height: 8),

          GlassResponsiveGrid(
            expandItems: false,
            mobileColumns: 2,
            tabletColumns: 3,
            desktopColumns: 3,
            spacing: 10,
            runSpacing: 10,
            children: [
              GlassToggle(
                label: 'Enabled',
                value: _enabled,
                onChanged: (v) => setState(() => _enabled = v),
                size: glass.isSmallMobile
                    ? GlassToggleSize.small
                    : GlassToggleSize.medium,
              ),
              GlassToggle(
                label: 'Focused',
                value: _focused,
                onChanged: (v) => setState(() => _focused = v),
                size: glass.isSmallMobile
                    ? GlassToggleSize.small
                    : GlassToggleSize.medium,
              ),
              GlassToggle(
                label: 'Error',
                value: _error,
                onChanged: (v) => setState(() => _error = v),
                size: glass.isSmallMobile
                    ? GlassToggleSize.small
                    : GlassToggleSize.medium,
              ),
            ],
          ),

          SizedBox(height: glass.isSmallMobile ? 20 : 24),
          const GlassPreviewLabel('Preview dynamique'),
          const SizedBox(height: 8),

          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 620),
            child: _buildGlassBox(
              text: _selectedValue,
              hintText: 'Sélectionner une valeur',
              prefixIcon: Icons.public_rounded,
              suffixIcon: Icons.keyboard_arrow_down_rounded,
              enabled: _enabled,
              isFocused: _focused,
              hasError: _error,
              errorText: _error ? 'Veuillez sélectionner une valeur' : null,
              onTap: () {
                setState(() {
                  _selectedValue = _selectedValue == 'Burkina Faso'
                      ? 'Côte d’Ivoire'
                      : 'Burkina Faso';
                });
              },
              glass: glass,
            ),
          ),

          const SizedBox(height: 20),
          const GlassPreviewLabel('État'),
          const SizedBox(height: 8),
          _buildStatusCard(glass: glass),
        ],
      ),
    );
  }

  Widget _buildLabeledGridItem(String label, Widget field) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [GlassPreviewLabel(label), const SizedBox(height: 6), field],
    );
  }

  Widget _buildGlassBox({
    String? text,
    String? hintText,
    IconData? prefixIcon,
    IconData? suffixIcon,
    bool enabled = true,
    bool isFocused = false,
    bool hasError = false,
    String? errorText,
    VoidCallback? onTap,
    required GlassLayoutContext glass,
  }) {
    final bool useAqua = glass.theme.useAquaStyle;
    final Color focusColor = useAqua ? Colors.cyanAccent : Colors.orangeAccent;
    final double bgOpacity = glass.theme.effectiveBlur > 25 ? 0.12 : 0.18;

    return UniversalGlassTextBox(
      text: text,
      hintText: hintText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      enabled: enabled && _enabled,
      isFocused: isFocused,
      hasError: hasError,
      errorText: errorText,
      onTap: onTap,
      decoration: GlassInputDecoration(
        color: useAqua
            ? focusColor.withValues(alpha: 0.06)
            : Colors.white.withValues(alpha: 0.04),
        backgroundOpacity: isFocused ? bgOpacity + 0.1 : bgOpacity,
        focusOpacity: bgOpacity + 0.14,
        borderColor: hasError
            ? Colors.redAccent.withValues(alpha: 0.5)
            : Colors.white.withValues(alpha: 0.12),
        focusBorderColor: hasError ? Colors.redAccent : focusColor,
        errorColor: Colors.redAccent,
        borderWidth: 1.2,
        focusBorderWidth: 1.8,
        borderRadius: glass.isSmallMobile ? 14 : 16,
        fontSize: 15,
        fontWeight: FontWeight.w600,
      ),
      style: glass.effectiveGlassStyle,
      shape: GlassShapeType.squareRounded,
      height: glass.isSmallMobile ? 52 : 58,
    );
  }

  Widget _buildStatusCard({required GlassLayoutContext glass}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      width: double.infinity,
      child: Text(
        'Valeur sélectionnée: $_selectedValue',
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.7),
          fontSize: 14,
        ),
      ),
    );
  }

  void _handleTap() => setState(() => _focused = !_focused);
}
