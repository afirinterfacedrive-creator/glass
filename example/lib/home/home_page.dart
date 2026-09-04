import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:universal_glass/components/preview/glass_preview_breaker.dart';
import 'package:universal_glass/glass.dart';
import 'package:universal_glass_example/home/widgets/home_modal_preview.dart';
import 'home_widgets_exports.dart';

// ============================================================================
// HOME PAGE
// ============================================================================

class HomePage extends ConsumerStatefulWidget { // <- PASSAGE EN STATEFUL
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  bool _isBreakerOn = false;
  bool _glow = true;
  bool _aqua = false;

  @override
  Widget build(BuildContext context) {
    final GlassThemeState theme = ref.watch(glassThemeProvider);

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double width = constraints.maxWidth;
        
        final bool isVerySmallMobile = width < 375;
        final bool isStandardMobile = width >= 375 && width < 600;

        final double horizontalPadding = isVerySmallMobile 
            ? 4.0 
            : (isStandardMobile ? 8.0 : 32.0);

        return GlassScaffold(
          title: 'Glass',
          subtitle: 'CONTROL CENTER',
          showLogo: true,
          showBackButton: false,

          useCustomGradient: true,
          customGradientKey: 'appbar_gradient',
          blur: 0.0,
          noise: theme.noise, 
          
          compactMode: false,
          forceMobileLayout: false,
          hideNavigation: true,
          actions: [HomeThemeIndicator(theme: theme)],
          maxWidth: 1200, 
          enableScroll: true,
          
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding, 
            vertical: isStandardMobile ? 12 : 20,
          ),
          
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HomeWelcomeCard(theme: theme, compact: isStandardMobile),
              const SizedBox(height: 28),
              
              // CONTROLES UNIFORMES
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  GlassPreviewSwitch(
                    height: 45,
                    label: 'Glow',
                    value: _glow,
                    onChanged: (v) => setState(() => _glow = v),
                  ),
                  GlassPreviewToggle(
                    height: 45,
                    label: 'Aqua',
                    value: _aqua,
                    onChanged: (v) => setState(() => _aqua = v),
                  ),
                  GlassPreviewBreaker( // <- GENRIQUE
              height: 45,
              label: 'Breaker',
              value: _isBreakerOn,
              onChanged: (v) => setState(() => _isBreakerOn = v),
              // subtitle: 'Custom', // optionnel
              // icon: Icons.flash_on, // optionnel
            ),
                ],
              ),

              const SizedBox(height: 28),

              GlassResponsiveGrid(
                spacing: 24, 
                runSpacing: 24, 
                mobileColumns: 1,  
                tabletColumns: 1,  
                desktopColumns: 2, 
                tabletBreakpoint: 600,
                desktopBreakpoint: 950, 
                children: [
                  const UniversalGlassHomePreview(),
                  _noScroll(const HomePhoneInputPreview()),
                  const UniversalGlassTextBoxView(),
                  const HomeUniversalGlassTextFieldView(),
                  _noScroll(const HomeSearchInputPreview()),
                  _noScroll(const HomeGlassFormPreview()),
                  const HomeConfirmDialogPreview(),
                  const HomeModalPreview(),
                ],
              ),

              const SizedBox(height: 28),
              const HomeQuickAccess(),
              const SizedBox(height: 28),
              const SystemSection(),
              const SizedBox(height: 30),
            ],
          ),
        );
      },
    );
  }

  

  Widget _noScroll(Widget child) {
    return NotificationListener<ScrollNotification>(
      onNotification: (_) => true,
      child: child,
    );
  }
}