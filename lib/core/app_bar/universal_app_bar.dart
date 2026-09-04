import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:universal_glass/components/surface/glass_surface_container.dart';

import 'package:universal_glass/core/app_bar/universal_app_bar_content.dart';
import 'package:universal_glass/core/app_bar/universal_app_bar_decorator.dart';
import 'package:universal_glass/core/app_bar/universal_tab_item.dart';
import 'package:universal_glass/enums/glass_enums.dart';
import 'package:universal_glass/provider/glass_theme_provider.dart';

class UniversalAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final bool showLogo;
  final String? title;
  final String? subtitle;
  final bool showBackButton;
  final VoidCallback? onBack;
  final List<Widget>? actions;
  final List<UniversalTabItem>? tabs;
  final bool hideNavigation;
  final bool useGradientBackground;
  final bool compactMode;
  final bool forceMobileLayout;

  const UniversalAppBar({
    super.key,
    this.showLogo = true,
    this.title,
    this.subtitle,
    this.showBackButton = false,
    this.onBack,
    this.actions,
    this.tabs,
    this.hideNavigation = false,
    this.useGradientBackground = false,
    this.compactMode = false,
    this.forceMobileLayout = false,
  });

  static double getAppBarHeight(double width) {
    if (width >= 1600) return 100.0;
    if (width >= 1200) return 90.0;
    if (width >= 950) return 80.0;
    return kToolbarHeight;
  }

  static double getScale(double width) {
    if (width >= 1600) return 1.70;
    if (width >= 1400) return 1.50;
    if (width >= 1200) return 1.30;
    if (width >= 950) return 1.15;
    if (width >= 600) return 1.00;
    return 0.90;
  }

  static double getCurrentViewWidth() {
    final views = WidgetsBinding.instance.platformDispatcher.views;
    if (views.isEmpty) return 0.0;
    final FlutterView view = views.first;
    final double devicePixelRatio = view.devicePixelRatio;
    if (devicePixelRatio <= 0) return 0.0;
    return view.physicalSize.width / devicePixelRatio;
  }

  @override
  Size get preferredSize {
    final double width = getCurrentViewWidth();
    final double height = compactMode ? kToolbarHeight : getAppBarHeight(width);
    return Size.fromHeight(height);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GlassThemeState glassTheme = ref.watch(glassThemeProvider);
    final ThemeData theme = Theme.of(context);
    final double screenWidth = MediaQuery.sizeOf(context).width;

    // FIX 1: -8px pour éviter le BOTTOM OVERFLOWED
    final double rawHeight = compactMode ? kToolbarHeight : getAppBarHeight(screenWidth);
    final double appBarHeight = rawHeight - 8; 
    final double scale = compactMode ? 0.90 : getScale(screenWidth);

    final bool isTv = !forceMobileLayout && screenWidth >= 1600;
    final bool isDesktop = !forceMobileLayout && screenWidth >= 950;
    final bool isTablet = !forceMobileLayout && screenWidth >= 600 && screenWidth < 950;

    final Color accentColor = glassTheme.useAquaStyle ? Colors.cyanAccent : Colors.orangeAccent;
    final Color iconColor = glassTheme.useAquaStyle ? Colors.cyanAccent : Colors.white;

    // FIX 2: Une seule source de vérité pour le glass
    final GlassStyle glassStyle = useGradientBackground 
        ? GlassStyle.gradientOpaque 
        : GlassStyle.transparentAqua;

    final BoxDecoration actionDecoration = BoxDecoration(
      shape: BoxShape.circle,
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withValues(alpha: 0.14),
          accentColor.withValues(alpha: 0.07),
        ],
      ),
      border: Border.all(
        color: glassTheme.useAquaStyle ? Colors.white.withValues(alpha: 0.20) : Colors.white.withValues(alpha: 0.15),
        width: 0.8,
      ),
      boxShadow: [
        BoxShadow(
          color: accentColor.withValues(alpha: 0.06),
          blurRadius: 8,
          spreadRadius: 0,
          offset: const Offset(0, 1),
        ),
      ],
    );

    final String currentRoute = ModalRoute.of(context)?.settings.name ?? '';
    final List<UniversalTabItem> activeTabs = hideNavigation ? const [] : (tabs ?? const []);
    final Color appBarShadowColor = Colors.black.withValues(alpha: isTv ? 0.10 : 0.045);

    // =========================================================================
    // WRAP AVEC GLASS SURFACE CONTAINER - 1 SEULE COUCHE
    // =========================================================================
    return GlassSurfaceContainer(
      style: glassStyle,
      borderRadius: BorderRadius.zero,
      width: double.infinity,
      height: appBarHeight,
      padding: EdgeInsets.zero,
      liftOnHover: false,
      clipBehavior: Clip.antiAlias, // <-- FIX 3: Coupe le débordement
      child: UniversalAppBarDecorator(
        height: appBarHeight,
        backgroundDecoration: const BoxDecoration(), // VIDE
        useGradientBackground: false, // <-- FIX 4: FORCE FALSE pour éviter double gradient
        child: UniversalAppBarContent(
          title: title,
          subtitle: subtitle,
          showLogo: showLogo,
          showBackButton: showBackButton,
          onBack: onBack,
          actions: actions,
          tabs: activeTabs,
          currentRoute: currentRoute,
          isTv: isTv,
          isDesktop: isDesktop,
          isTablet: isTablet,
          scale: scale,
          appBarHeight: appBarHeight,
          theme: theme,
          iconColor: iconColor,
          accentColor: accentColor,
          shadowColor: appBarShadowColor,
          actionDecoration: actionDecoration,
        ),
      ),
    );
  }
}