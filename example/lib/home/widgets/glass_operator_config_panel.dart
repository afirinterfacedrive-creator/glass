
import 'package:flutter/material.dart';
import 'package:universal_glass/glass.dart';


class GlassOperatorConfigPanel extends StatelessWidget {
  final PhoneCountry country;
  final PhoneInputController controller;
  final GlassColorPalette palette;
  final PhoneOperator? selectedOperator;
  final ValueChanged<PhoneOperator?> onOperatorSelected;
  final TextEditingController prefixTextController;
  final FocusNode prefixFocusNode;
  final GlassInputStyle inputStyle;
  final bool saving;
  final VoidCallback? onChanged;

  final void Function({
    required String title,
    required String message,
    required GlassToastType type,
    required GlassToastPosition position,
    GlassStyle? style,
    Color? backgroundColor,
  })? onToast;

  const GlassOperatorConfigPanel({
    super.key,
    required this.country,
    required this.controller,
    required this.palette,
    required this.selectedOperator,
    required this.onOperatorSelected,
    required this.prefixTextController,
    required this.prefixFocusNode,
    required this.inputStyle,
    this.saving = false,
    this.onChanged,
    this.onToast,
  });

  // ===========================================================================
  // BUILD
  // ===========================================================================

  @override
  Widget build(BuildContext context) {
    final currentCountry = controller.allCountries.firstWhere(
      (c) => c.isoCode == country.isoCode,
      orElse: () => country,
    );

    final currentOperator = selectedOperator == null
        ? null
        : currentCountry.operatorsDetailed.firstWhere(
            (op) => op.id == selectedOperator!.id,
            orElse: () => selectedOperator!,
          );

    return GlassSurfaceContainer(
      style: GlassStyle.transparentAqua,
      padding: const EdgeInsets.all(16),
      borderRadius: BorderRadius.circular(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Opérateurs disponibles :',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: palette.textPrimary,
            ),
          ),

          const SizedBox(height: 10),

          _buildChips(currentCountry),

          const SizedBox(height: 20),

          if (currentOperator != null) ...[
            _buildAddRow(
              currentOperator,
              currentCountry,
            ),

            const SizedBox(height: 20),

            Text(
              'Préfixes actifs :',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: palette.textPrimary,
              ),
            ),

            const SizedBox(height: 10),

            _buildPrefixesChips(
              currentOperator,
              currentCountry,
            ),
          ] else
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 20,
              ),
              child: Text(
                'Aucun opérateur configuré pour ce territoire.',
                style: TextStyle(
                  color: palette.textSecondary,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ===========================================================================
  // OPERATOR CHIPS
  // ===========================================================================

  Widget _buildChips(PhoneCountry currentCountry) {
    return GlassScrollViewWithArrows(
      arrowColor: palette.accent.withValues(alpha: 0.8),
      spacing: 8.0,
      runSpacing: 8.0,
      children: currentCountry.operatorsDetailed.map((op) {
        final bool isSelected =
            selectedOperator?.id == op.id;

        return Padding(
          key: ValueKey('op_chip_${op.id}'),
          padding: const EdgeInsets.only(
            right: 8,
            bottom: 4,
          ),
          child: GlassModeChip<PhoneOperator?>(
            label: op.name,
            icon: Icons.cell_tower_rounded,
            mode: op,
            selected: selectedOperator,
            accent: op.color,
            height: 45,
            borderRadius: 14,
            enableBlur: true,
            enableGlow: isSelected,
            glowRadius: 12,
            backgroundColor: palette.surface,
            backgroundOpacity: isSelected ? 0.15 : 0.05,
            borderColor:
                isSelected ? op.color : Colors.white,
            borderOpacity:
                isSelected ? 0.5 : 0.12,
            textColor: palette.textPrimary,
            onSelected: saving
                ? (_) {}
                : onOperatorSelected,
          ),
        );
      }).toList(),
    );
  }

  // ===========================================================================
  // ADD PREFIX
  // ===========================================================================

  Widget _buildAddRow(
    PhoneOperator currentOp,
    PhoneCountry currentCountry,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: UniversalGlassTextFieldOutlined(
            controller: prefixTextController,
            focusNode: prefixFocusNode,
            style: inputStyle.copyWith(
              fieldHeight: 48,
              fontSize: 14,
              enableBlur: false,
              enabled: !saving,
            ),
            label: 'Nouveau préfixe',
            hintText: 'Ex: 05, 77...',
            keyboardType: TextInputType.number,
            prefixIcon: Icons.add,
            onSubmitted: saving
                ? null
                : (val) => _addPrefix(
                      currentOp,
                      currentCountry,
                    ),
          ),
        ),

        const SizedBox(width: 12),

        UniversalGlassButton(
          buttonId: 'add_prefix_btn',
          label: 'Ajouter',
          icon: Icons.add_rounded,
          style: GlassStyle.transparentAqua,
          height: 48,
          borderRadius: 12,
          effects: GlassEffects.defaults(),
          shape: GlassShapeType.squareRounded,
          enabled: !saving,
          futureOnTap: saving
              ? null
              : () async => _addPrefix(
                    currentOp,
                    currentCountry,
                  ),
        ),
      ],
    );
  }

  // ===========================================================================
  // ADD PREFIX ACTION
  // ===========================================================================

  Future<void> _addPrefix(
    PhoneOperator currentOp,
    PhoneCountry currentCountry,
  ) async {
    final prefix = prefixTextController.text.trim();

    if (prefix.isEmpty) {
      onToast?.call(
        title: 'Champ vide',
        message: 'Entrez un préfixe à ajouter',
        type: GlassToastType.warning,
        position: GlassToastPosition.topCenter,
      );
      return;
    }

    if (currentOp.prefixes.contains(prefix)) {
      onToast?.call(
        title: 'Doublon',
        message:
            'Le préfixe $prefix existe déjà pour ${currentOp.name}',
        type: GlassToastType.error,
        position: GlassToastPosition.topCenter,
      );
      return;
    }

    try {
      await controller.addPrefixToOperator(
        countryIso: currentCountry.isoCode,
        operatorId: currentOp.id,
        newPrefix: prefix,
      );

      prefixTextController.clear();

      prefixFocusNode.requestFocus();

      onChanged?.call();

      onToast?.call(
        title: 'Ajouté',
        message:
            'Préfixe $prefix ajouté à ${currentOp.name}',
        type: GlassToastType.success,
        position: GlassToastPosition.center,
        style: GlassStyle.solidAqua,
        backgroundColor:
            currentOp.color.withValues(alpha: 0.2),
      );
    } catch (e) {
      onToast?.call(
        title: 'Erreur',
        message:
            "Impossible d'ajouter le préfixe: $e",
        type: GlassToastType.error,
        position: GlassToastPosition.topCenter,
      );
    }
  }

  // ===========================================================================
  // PREFIX LIST
  // ===========================================================================

  Widget _buildPrefixesChips(
    PhoneOperator op,
    PhoneCountry currentCountry,
  ) {
    final freshOp =
        currentCountry.operatorsDetailed.firstWhere(
      (o) => o.id == op.id,
      orElse: () => op,
    );

    if (freshOp.prefixes.isEmpty) {
      return Text(
        'Aucun préfixe actif.',
        style: TextStyle(
          color: palette.textDisabled,
          fontSize: 13,
        ),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: freshOp.prefixes.map((prefix) {
        return _PrefixDeleteChip(
          key: ValueKey(
            'prefix_chip_${op.id}_$prefix',
          ),
          prefix: prefix,
          operator: op,
          palette: palette,
          enabled: !saving,
          onDelete: () => _removePrefix(
            op,
            currentCountry,
            prefix,
          ),
        );
      }).toList(),
    );
  }

  // ===========================================================================
  // REMOVE PREFIX
  // ===========================================================================

  Future<void> _removePrefix(
    PhoneOperator op,
    PhoneCountry currentCountry,
    String prefix,
  ) async {
    if (saving) return;

    try {
      await controller.removePrefixFromOperator(
        countryIso: currentCountry.isoCode,
        operatorId: op.id,
        prefixToRemove: prefix,
      );

      onChanged?.call();

      onToast?.call(
        title: 'Supprimé',
        message:
            'Préfixe $prefix retiré de ${op.name}',
        type: GlassToastType.success,
        position: GlassToastPosition.center,
      );
    } catch (e) {
      onToast?.call(
        title: 'Erreur',
        message:
            "Impossible de supprimer le préfixe $prefix: $e",
        type: GlassToastType.error,
        position: GlassToastPosition.topCenter,
      );
    }
  }
}

// =============================================================================
// PREFIX DELETE CHIP
// =============================================================================

class _PrefixDeleteChip extends StatelessWidget {
  final String prefix;
  final PhoneOperator operator;
  final GlassColorPalette palette;
  final bool enabled;
  final VoidCallback onDelete;

  const _PrefixDeleteChip({
    super.key,
    required this.prefix,
    required this.operator,
    required this.palette,
    required this.enabled,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? onDelete : null,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 150),
          opacity: enabled ? 1.0 : 0.45,
          child: Container(
            height: 38,
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
            ),
            decoration: BoxDecoration(
              color: palette.surface.withValues(
                alpha: 0.04,
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: operator.color.withValues(
                  alpha: 0.25,
                ),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    color: Colors.redAccent.withValues(
                      alpha: 0.12,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close_rounded,
                    size: 14,
                    color: Colors.redAccent,
                  ),
                ),

                const SizedBox(width: 7),

                Text(
                  prefix,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: palette.textSecondary,
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
