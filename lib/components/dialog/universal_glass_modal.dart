import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:universal_glass/components/surface/glass_surface_container.dart';
import 'package:universal_glass/enums/glass_enums.dart';
import 'package:universal_glass/theme/glass_effects.dart';
import 'package:universal_glass/core/layout/glass_layout_context.dart';
import 'package:universal_glass/core/layout/glass_layout_scope.dart';

/// Modal Glass générique pour formulaires, listes, paramètres, contenus scrollables.
class UniversalGlassModal extends ConsumerWidget {
  const UniversalGlassModal({
    super.key,
    this.title,
    this.subtitle,
    this.leading,
    this.child,
    this.actions = const [],
    this.maxWidth = 720,
    this.maxHeight,
    this.minHeight = 0,
    this.headerSpacing = 16,
    this.contentSpacing = 18,
    this.actionsSpacing = 10,
    this.padding,
    this.scrollable = true,
    this.scrollController,
    this.borderRadius,
    this.borderWidth = 0.72,
    this.style,
    this.effects, // <- AJOUT 1
    this.customGradient,
    this.customKey,
  });

  // Header
  final String? title, subtitle;
  final Widget? leading;
  // Content
  final Widget? child;
  // Actions
  final List<Widget> actions;
  // Dimensions
  final double maxWidth;
  final double? maxHeight;
  final double minHeight;
  // Spacing
  final double headerSpacing, contentSpacing, actionsSpacing;
  // Layout
  final EdgeInsetsGeometry? padding;
  // Scroll
  final bool scrollable;
  final ScrollController? scrollController;
  // Style Moteur Glass
  final double? borderRadius;
  final double borderWidth;
  final GlassStyle? style;
  final GlassEffects? effects; // <- AJOUT 2
  final List<Color>? customGradient;
  final String? customKey;

  /// Affiche le modal
  static Future<T?> show<T>({
    required BuildContext context,
    String? title,
    String? subtitle,
    Widget? leading,
    Widget? child,
    List<Widget> actions = const [],
    double maxWidth = 720,
    double? maxHeight,
    double minHeight = 0,
    double headerSpacing = 16,
    double contentSpacing = 18,
    double actionsSpacing = 10,
    EdgeInsetsGeometry? padding,
    bool scrollable = true,
    ScrollController? scrollController,
    double? borderRadius,
    double borderWidth = 0.72,
    GlassStyle? style,
    GlassEffects? effects, // <- AJOUT 3
    List<Color>? customGradient,
    String? customKey,
    bool barrierDismissible = true,
    bool useSafeArea = true,
    bool useRootNavigator = true,
    Color barrierColor = const Color(0x99000000),
  }) {
    return showDialog<T>(
      context: context,
      useRootNavigator: useRootNavigator,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      builder: (context) {
        Widget modal = UniversalGlassModal(
          // ignore: sort_child_properties_last
          title: title,
          subtitle: subtitle,
          leading: leading,
          // ignore: sort_child_properties_last
          child: child,
          actions: actions,
          maxWidth: maxWidth,
          maxHeight: maxHeight,
          minHeight: minHeight,
          headerSpacing: headerSpacing,
          contentSpacing: contentSpacing,
          actionsSpacing: actionsSpacing,
          padding: padding,
          scrollable: scrollable,
          scrollController: scrollController,
          borderRadius: borderRadius,
          borderWidth: borderWidth,
          style: style,
          effects: effects, // <- AJOUT 4
          customGradient: customGradient,
          customKey: customKey,
        );
        return useSafeArea ? SafeArea(child: modal) : modal;
      },
    );
  }

  Widget _buildHeader(
    BuildContext context,
    GlassLayoutContext glass,
    bool isSmallMobile,
  ) {
    final hasTitle = (title ?? '').trim().isNotEmpty;
    final hasSubtitle = (subtitle ?? '').trim().isNotEmpty;
    if (!hasTitle && !hasSubtitle && leading == null)
      // ignore: curly_braces_in_flow_control_structures
      return const SizedBox.shrink();

    final titleCol = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (hasTitle)
          Text(
            title!,
            style: TextStyle(
              color: glass.palette.textPrimary,
              fontWeight: FontWeight.w700,
              fontSize: isSmallMobile ? 18 : 22,
            ),
          ),
        if (hasTitle && hasSubtitle) const SizedBox(height: 4),
        if (hasSubtitle)
          Text(
            subtitle!,
            style: TextStyle(
              color: glass.palette.textSecondary.withValues(alpha: 0.68),
              fontSize: isSmallMobile ? 12 : 14,
            ),
          ),
      ],
    );

    return leading == null
        ? titleCol
        : Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              leading!,
              const SizedBox(width: 12),
              Expanded(child: titleCol),
            ],
          );
  }

  Widget _buildContent() {
    if (child == null) return const SizedBox.shrink();
    return scrollable
        ? Flexible(
            child: SingleChildScrollView(
              controller: scrollController,
              physics: const BouncingScrollPhysics(),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: child!,
            ),
          )
        : child!;
  }

  Widget _buildActions(GlassLayoutContext glass, bool isSmallMobile) {
    if (actions.isEmpty) return const SizedBox.shrink();

    if (isSmallMobile || actions.length > 2) {
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
      children: [
        for (int i = 0; i < actions.length; i++) ...[
          if (i > 0) SizedBox(width: actionsSpacing),
          Flexible(child: actions[i]),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GlassLayoutContext glass = GlassLayoutScope.of(context);

    final hasHeader =
        (title ?? '').trim().isNotEmpty ||
        (subtitle ?? '').trim().isNotEmpty ||
        leading != null;
    final hasContent = child != null;
    final hasActions = actions.isNotEmpty;

    final Size screenSize = MediaQuery.sizeOf(context);
    final double screenWidth = screenSize.width;
    final double screenHeight = screenSize.height;
    final double keyboardHeight = MediaQuery.viewInsetsOf(context).bottom;

    final bool isSmallMobile = glass.isSmallMobile;

    final double targetMaxWidth = screenWidth - (isSmallMobile ? 16 : 40);
    final double effectiveMaxWidth = maxWidth < targetMaxWidth
        ? maxWidth
        : targetMaxWidth;
    final double effectiveMaxHeight = maxHeight ?? (screenHeight * 0.85);

    final EdgeInsetsGeometry effectivePadding =
        padding ?? EdgeInsets.all(isSmallMobile ? 14 : 20);
    final double effectiveBorderRadius =
        borderRadius ?? (isSmallMobile ? 20 : 28);

    final GlassStyle effectiveStyle = style ?? glass.effectiveGlassStyle;
    final GlassEffects effectiveEffects =
        effects ?? glass.effects; // <- FALLBACK SUR LE THEME

    return Material(
      type: MaterialType.transparency,
      child: AnimatedPadding(
        padding: EdgeInsets.only(bottom: keyboardHeight),
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOutQuad,
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: minHeight,
              maxWidth: effectiveMaxWidth,
              maxHeight: effectiveMaxHeight,
            ),
            child: GlassSurfaceContainer(
              style: effectiveStyle,
              effects: effectiveEffects, // <- UTILISE LES EFFETS
              borderRadius: BorderRadius.circular(effectiveBorderRadius),
              padding: effectivePadding,
              customGradient: customGradient,
              customKey: customKey,
              liftOnHover: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (hasHeader) _buildHeader(context, glass, isSmallMobile),
                  if (hasHeader && hasContent) SizedBox(height: headerSpacing),
                  if (hasContent) _buildContent(),
                  if (hasContent && hasActions)
                    SizedBox(height: contentSpacing),
                  if (!hasContent && hasHeader && hasActions)
                    SizedBox(height: headerSpacing),
                  if (hasActions) _buildActions(glass, isSmallMobile),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
