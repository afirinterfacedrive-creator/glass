import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:universal_glass/components/surface/glass_surface_container.dart';
import 'package:universal_glass/enums/glass_enums.dart';
import 'package:universal_glass/provider/glass_theme_provider.dart';
import 'package:universal_glass/theme/glass_effects.dart';

import 'glass_background.dart';
import 'package:universal_glass/core/app_bar/universal_app_bar.dart';

class GlassScaffold extends ConsumerWidget {
  final Widget child;
  final String? title;
  final String? subtitle;
  final bool showLogo;
  final bool showBackButton;
  final bool? useGradientBackground; 
  final bool useCustomGradient; 
  final String? customGradientKey; 
  final bool compactMode;
  final bool forceMobileLayout;
  final bool hideNavigation;
  final List<Widget>? actions;
  final double maxWidth;
  final EdgeInsetsGeometry? padding;
  final bool enableScroll;
  final double? blur; // <- sert uniquement pour l'appbar
  final double? noise;

  const GlassScaffold({
    super.key,
    required this.child,
    this.title,
    this.subtitle,
    this.showLogo = true,
    this.showBackButton = false,
    this.useGradientBackground,
    this.useCustomGradient = false,
    this.customGradientKey = 'appbar_gradient',
    this.compactMode = false,
    this.forceMobileLayout = false,
    this.hideNavigation = true,
    this.actions,
    this.maxWidth = 1100,
    this.padding,
    this.enableScroll = true,
    this.blur,
    this.noise,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GlassThemeState theme = ref.watch(glassThemeProvider);
    final double screenWidth = MediaQuery.sizeOf(context).width;
    
    final bool useGradient = useGradientBackground ?? theme.useAquaStyle;
    final GlassStyle appBarStyle = useCustomGradient 
        ? GlassStyle.customGradient 
        : (useGradient ? GlassStyle.gradientOpaque : GlassStyle.solidAqua);

    final List<Color> currentGradient = theme.activeGradient;
    final double currentBlur = blur ?? theme.effectiveBlur; 
    final double currentNoise = noise ?? theme.effectiveNoise; 
    final double bodyBlur = 0.0; // <- IMPORTANT: pas de blur sur le body

    final double appBarHeight = UniversalAppBar.getAppBarHeight(screenWidth);

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(appBarHeight),
        child: GlassSurfaceContainer(
          // ignore: unnecessary_brace_in_string_interps
          key: ValueKey('${appBarStyle.name}_${theme.useAquaStyle}_${currentGradient.hashCode}_${currentBlur}_${currentNoise}'), 
          style: appBarStyle,
          customGradient: useCustomGradient ? currentGradient : null, 
          customKey: useCustomGradient ? customGradientKey : null,
          effects: GlassEffects(
            bgGradient: currentGradient,
            bgBlur: currentBlur, // <- Blur seulement ici
            bgNoise: currentNoise,
          ),
          borderRadius: BorderRadius.zero,
          width: double.infinity,
          height: double.infinity,
          padding: EdgeInsets.zero,
          liftOnHover: false,
          child: UniversalAppBar(
            title: title,
            subtitle: subtitle,
            showLogo: showLogo,
            showBackButton: showBackButton,
            useGradientBackground: appBarStyle == GlassStyle.gradientOpaque,
            compactMode: compactMode,
            forceMobileLayout: forceMobileLayout,
            hideNavigation: hideNavigation,
            actions: actions,
          ),
        ),
      ),
      body: Stack(
        children: [
          GlassBackground(blur: bodyBlur, noise: currentNoise), // <- Passe 0 ici
          SafeArea(
            top: false,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final double width = constraints.maxWidth;
                final bool isVerySmallMobile = width < 375;
                final bool isStandardMobile = width >= 375 && width < 600;

                final EdgeInsetsGeometry basePadding = padding ??
                    EdgeInsets.symmetric(
                      horizontal: isVerySmallMobile ? 4.0 : (isStandardMobile ? 8.0 : 24.0),
                      vertical: isStandardMobile ? 12.0 : 20.0,
                    );

                final EdgeInsetsGeometry contentPadding = basePadding.add(
                  EdgeInsets.only(top: appBarHeight + 8),
                );

                Widget content = Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: maxWidth),
                    child: child,
                  ),
                );

                if (enableScroll) {
                  content = SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: contentPadding,
                    child: content,
                  );
                } else {
                    content = Padding(padding: contentPadding, child: child);
                }

                return content;
              },
            ),
          ),
        ],
      ),
    );
  }
}