import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:universal_glass/components/surface/glass_surface_container.dart';
import 'package:universal_glass/enums/glass_enums.dart';
import 'package:universal_glass/theme/glass_effects.dart';
import 'package:universal_glass/core/layout/glass_layout_context.dart';
import 'package:universal_glass/core/layout/glass_layout_scope.dart';

/// ============================================================================
/// UNIVERSAL GLASS DIALOG
///
/// Dialog Glass générique qui suit le thème global.
/// Gère : titre, sous-titre, icône, contenu, actions, dimensions, barrier.
/// ============================================================================

class UniversalGlassDialog extends ConsumerWidget {
  // <- CONSUMER
  // ==========================================================================
  // HEADER
  // ==========================================================================
  final String? title;
  final String? subtitle;
  final Widget? leading;

  // ==========================================================================
  // CONTENU
  // ==========================================================================
  final Widget? child;

  // ==========================================================================
  // ACTIONS
  // ==========================================================================
  final List<Widget> actions;

  // ==========================================================================
  // DIMENSIONS
  // ==========================================================================
  final double maxWidth;
  final double? minWidth;

  // ==========================================================================
  // ESPACEMENT
  // ==========================================================================
  final double headerSpacing;
  final double contentSpacing;
  final double actionsSpacing;

  // ==========================================================================
  // PADDING
  // ==========================================================================
  final EdgeInsetsGeometry padding;

  // ==========================================================================
  // APPARENCE
  // ==========================================================================
  final double? borderRadius; // <- nullable pour prendre le theme
  final GlassStyle? style; // <- nullable
  final GlassEffects? effects; // <- nullable
  final Gradient? gradient;
  final String? customKey;

  const UniversalGlassDialog({
    super.key,
    // HEADER
    this.title,
    this.subtitle,
    this.leading,
    // CONTENU
    this.child,
    // ACTIONS
    this.actions = const <Widget>[],
    // DIMENSIONS
    this.maxWidth = 520,
    this.minWidth,
    // ESPACEMENT
    this.headerSpacing = 16,
    this.contentSpacing = 16,
    this.actionsSpacing = 18,
    // PADDING
    this.padding = const EdgeInsets.all(24),
    // APPARENCE
    this.borderRadius,
    this.style,
    this.effects,
    this.gradient,
    this.customKey,
  });

  // ==========================================================================
  // SHOW
  // ==========================================================================
  static Future<T?> show<T>({
    required BuildContext context,
    String? title,
    String? subtitle,
    Widget? leading,
    Widget? child,
    List<Widget> actions = const <Widget>[],
    double maxWidth = 520,
    double? minWidth,
    double headerSpacing = 16,
    double contentSpacing = 16,
    double actionsSpacing = 18,
    EdgeInsetsGeometry padding = const EdgeInsets.all(24),
    double? borderRadius, // <- nullable
    GlassStyle? style, // <- nullable
    GlassEffects? effects, // <- nullable
    Gradient? gradient,
    String? customKey,
    bool barrierDismissible = true,
    bool useSafeArea = true,
    Color barrierColor = const Color(0x99000000),
    bool useRootNavigator = true,
  }) {
    return showDialog<T>(
      context: context,
      useRootNavigator: useRootNavigator,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      builder: (context) {
        Widget dialog = UniversalGlassDialog(
          title: title,
          subtitle: subtitle,
          leading: leading,
          // ignore: sort_child_properties_last
          child: child,
          actions: actions,
          maxWidth: maxWidth,
          minWidth: minWidth,
          headerSpacing: headerSpacing,
          contentSpacing: contentSpacing,
          actionsSpacing: actionsSpacing,
          padding: padding,
          borderRadius: borderRadius,
          style: style,
          effects: effects,
          gradient: gradient,
          customKey: customKey,
        );

        if (useSafeArea) {
          dialog = SafeArea(child: dialog);
        }

        return dialog;
      },
    );
  }

  // ==========================================================================
  // HEADER
  // ==========================================================================
  Widget _buildHeader(GlassLayoutContext glass, bool isSmallMobile) {
    final bool hasTitle = title != null && title!.trim().isNotEmpty;
    final bool hasSubtitle = subtitle != null && subtitle!.trim().isNotEmpty;

    if (!hasTitle && !hasSubtitle && leading == null) {
      return const SizedBox.shrink();
    }

    final Widget text = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (hasTitle)
          Text(
            title!,
            style: TextStyle(
              color: glass.palette.textPrimary, // <- PALETTE GLASS
              fontWeight: FontWeight.w700,
              fontSize: isSmallMobile ? 18 : 22,
            ),
          ),
        if (hasTitle && hasSubtitle) const SizedBox(height: 5),
        if (hasSubtitle)
          Text(
            subtitle!,
            style: TextStyle(
              color: glass.palette.textSecondary.withValues(
                alpha: 0.68,
              ), // <- PALETTE GLASS
              fontSize: isSmallMobile ? 12 : 14,
            ),
          ),
      ],
    );

    if (leading == null) {
      return text;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        leading!,
        const SizedBox(width: 12),
        Expanded(child: text),
      ],
    );
  }

  // ==========================================================================
  // CONTENT
  // ==========================================================================
  Widget _buildContent() {
    if (child == null) {
      return const SizedBox.shrink();
    }
    return child!;
  }

  // ==========================================================================
  // ACTIONS
  // ==========================================================================
  Widget _buildActions(bool isSmallMobile) {
    if (actions.isEmpty) {
      return const SizedBox.shrink();
    }

    if (isSmallMobile || actions.length > 2) {
      // <- auto column sur mobile
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (int i = 0; i < actions.length; i++) ...[
            if (i > 0) SizedBox(height: actionsSpacing),
            actions[i],
          ],
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        for (int i = 0; i < actions.length; i++) ...[
          if (i > 0) SizedBox(width: actionsSpacing),
          Flexible(child: actions[i]),
        ],
      ],
    );
  }

  // ==========================================================================
  // BUILD
  // ==========================================================================
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // <- WIDGETREF
    final GlassLayoutContext glass = GlassLayoutScope.of(
      context,
    ); // <- CONTEXTE GLASS

    final bool hasHeader =
        (title != null && title!.trim().isNotEmpty) ||
        (subtitle != null && subtitle!.trim().isNotEmpty) ||
        leading != null;

    final bool hasContent = child != null;
    final bool hasActions = actions.isNotEmpty;
    final bool isSmallMobile = glass.isSmallMobile;

    final double effectiveBorderRadius =
        borderRadius ?? (isSmallMobile ? 20 : glass.theme.borderRadius);
    final GlassStyle effectiveStyle = style ?? glass.effectiveGlassStyle;
    final GlassEffects effectiveEffects = effects ?? glass.effects;

    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: minWidth ?? 0,
            maxWidth: maxWidth,
          ),
          child: GlassSurfaceContainer(
            // <- REMPLACE Container PAR GLASS
            style: effectiveStyle,
            effects: effectiveEffects,
            borderRadius: BorderRadius.circular(effectiveBorderRadius),
            padding: padding,
            customGradient: gradient?.colors,
            customKey: customKey,
            liftOnHover: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // HEADER
                if (hasHeader) _buildHeader(glass, isSmallMobile),
                if (hasHeader && hasContent) SizedBox(height: headerSpacing),
                // CONTENT
                if (hasContent) _buildContent(),
                if (hasContent && hasActions) SizedBox(height: contentSpacing),
                if (!hasContent && hasHeader && hasActions)
                  SizedBox(height: headerSpacing),
                // ACTIONS
                if (hasActions) _buildActions(isSmallMobile),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
