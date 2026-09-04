
import 'package:flutter/material.dart';

/// ============================================================================
/// GLASS FORM ACTIONS
///
/// Barre d'actions générique pour les formulaires Glass.
///
/// Permet de gérer :
///
/// • bouton secondaire
/// • bouton principal
/// • bouton supplémentaire
/// • alignement
/// • espacement
/// • largeur des boutons
/// • état enabled
/// • chargement du bouton principal
///
/// IMPORTANT
///
/// Ce composant ne contient aucune logique de formulaire.
/// Il déclenche uniquement les callbacks fournis par le parent.
/// ============================================================================

class GlassFormActions extends StatelessWidget {
  // ==========================================================================
  // ACTION PRINCIPALE
  // ==========================================================================

  final String? primaryLabel;

  final VoidCallback? onPrimary;

  final IconData? primaryIcon;

  // ==========================================================================
  // ACTION SECONDAIRE
  // ==========================================================================

  final String? secondaryLabel;

  final VoidCallback? onSecondary;

  final IconData? secondaryIcon;

  // ==========================================================================
  // ACTION SUPPLÉMENTAIRE
  // ==========================================================================

  final Widget? leadingAction;

  final Widget? trailingAction;

  // ==========================================================================
  // ÉTAT
  // ==========================================================================

  final bool primaryEnabled;

  final bool secondaryEnabled;

  final bool loading;

  // ==========================================================================
  // APPARENCE
  // ==========================================================================

  final double spacing;

  final double? buttonHeight;

  final double? buttonWidth;

  final MainAxisAlignment mainAxisAlignment;

  final CrossAxisAlignment crossAxisAlignment;

  final bool expandButtons;

  // ==========================================================================
  // STYLE
  // ==========================================================================

  final ButtonStyle? primaryStyle;

  final ButtonStyle? secondaryStyle;

  // ==========================================================================
  // CONSTRUCTEUR
  // ==========================================================================

  const GlassFormActions({
    super.key,

    // PRINCIPAL
    this.primaryLabel,
    this.onPrimary,
    this.primaryIcon,

    // SECONDAIRE
    this.secondaryLabel,
    this.onSecondary,
    this.secondaryIcon,

    // ACTIONS LIBRES
    this.leadingAction,
    this.trailingAction,

    // ÉTAT
    this.primaryEnabled = true,
    this.secondaryEnabled = true,
    this.loading = false,

    // APPARENCE
    this.spacing = 10.0,
    this.buttonHeight = 46.0,
    this.buttonWidth,
    this.mainAxisAlignment =
        MainAxisAlignment.end,
    this.crossAxisAlignment =
        CrossAxisAlignment.center,
    this.expandButtons = false,

    // STYLE
    this.primaryStyle,
    this.secondaryStyle,
  });

  // ==========================================================================
  // PRIMARY BUTTON
  // ==========================================================================

  Widget _buildPrimaryButton() {
    if (primaryLabel == null) {
      return const SizedBox.shrink();
    }

    final bool enabled =
        primaryEnabled &&
        !loading &&
        onPrimary != null;

    final Widget child =
        loading
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              )
            : Row(
                mainAxisSize:
                    MainAxisSize.min,
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [
                  if (primaryIcon != null) ...[
                    Icon(
                      primaryIcon,
                      size: 18,
                    ),
                    const SizedBox(
                      width: 7,
                    ),
                  ],
                  Text(
                    primaryLabel!,
                  ),
                ],
              );

    final Widget button =
        FilledButton(
      onPressed:
          enabled
              ? onPrimary
              : null,
      style:
          primaryStyle,
      child:
          child,
    );

    if (buttonWidth == null &&
        buttonHeight == null) {
      return button;
    }

    return SizedBox(
      width:
          expandButtons
              ? null
              : buttonWidth,
      height:
          buttonHeight,
      child:
          button,
    );
  }

  // ==========================================================================
  // SECONDARY BUTTON
  // ==========================================================================

  Widget _buildSecondaryButton() {
    if (secondaryLabel == null) {
      return const SizedBox.shrink();
    }

    final bool enabled =
        secondaryEnabled &&
        onSecondary != null;

    final Widget button =
        OutlinedButton(
      onPressed:
          enabled
              ? onSecondary
              : null,
      style:
          secondaryStyle,
      child:
          Row(
        mainAxisSize:
            MainAxisSize.min,
        mainAxisAlignment:
            MainAxisAlignment.center,
        children: [
          if (secondaryIcon != null) ...[
            Icon(
              secondaryIcon,
              size: 18,
            ),
            const SizedBox(
              width: 7,
            ),
          ],
          Text(
            secondaryLabel!,
          ),
        ],
      ),
    );

    if (buttonWidth == null &&
        buttonHeight == null) {
      return button;
    }

    return SizedBox(
      width:
          expandButtons
              ? null
              : buttonWidth,
      height:
          buttonHeight,
      child:
          button,
    );
  }

  // ==========================================================================
  // BUILD
  // ==========================================================================

  @override
  Widget build(
    BuildContext context,
  ) {
    final List<Widget> actions =
        <Widget>[];

    if (leadingAction != null) {
      actions.add(
        leadingAction!,
      );
    }

    final Widget secondary =
        _buildSecondaryButton();

    final bool hasSecondary =
        secondaryLabel != null;

    final Widget primary =
        _buildPrimaryButton();

    final bool hasPrimary =
        primaryLabel != null;

    if (hasSecondary) {
      actions.add(
        secondary,
      );
    }

    if (hasSecondary &&
        hasPrimary) {
      actions.add(
        SizedBox(
          width:
              spacing,
        ),
      );
    }

    if (hasPrimary) {
      actions.add(
        primary,
      );
    }

    if (trailingAction != null) {
      if (actions.isNotEmpty) {
        actions.add(
          SizedBox(
            width:
                spacing,
          ),
        );
      }

      actions.add(
        trailingAction!,
      );
    }

    if (actions.isEmpty) {
      return const SizedBox.shrink();
    }

    return Row(
      mainAxisSize:
          MainAxisSize.max,
      mainAxisAlignment:
          mainAxisAlignment,
      crossAxisAlignment:
          crossAxisAlignment,
      children:
          actions,
    );
  }
}

