
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../enums/glass_enums.dart';
import '../providers/theme_provider.dart';
import '../theme/glass_color_palette.dart';
import '../theme/glass_effects.dart';

import 'glass_button.dart';
import 'glass_icon.dart';

// ============================================================================
// THEME GLASS CARD
// ============================================================================
//
// Sélecteur visuel du thème système de l'application.
//
// Modes disponibles:
//
//   0 → Système
//   1 → Sombre
//   2 → Clair
//
// RESPONSABILITÉS
// ----------------
//
// • afficher les trois modes disponibles
// • gérer la sélection du mode
// • utiliser GlassColorPalette pour toutes les couleurs
// • gérer l'animation de sélection
// • transmettre GlassEffects au GlassButton
//
// NE GÈRE PAS
// ------------
//
// • la palette globale
// • Riverpod de la palette
// • la création de GlassEffects
// • le style Aqua / Classic global
//
// La palette est injectée depuis l'extérieur.
//
// ============================================================================

class ThemeGlassCard extends ConsumerStatefulWidget {
  // ==========================================================================
  // STYLE GLASS
  // ==========================================================================

  final GlassEffects effects;

  final GlassShapeType shape;

  final GlassStyle style;

  // ==========================================================================
  // PALETTE
  // ==========================================================================

  /// Palette de couleurs utilisée par le composant.
  ///
  /// ThemeGlassCard ne récupère pas directement le provider.
  ///
  /// La palette est injectée par le parent afin de conserver un composant
  /// réutilisable et indépendant de la source de la palette.
  final GlassColorPalette palette;

  // ==========================================================================
  // DIMENSIONS
  // ==========================================================================

  final double width;

  final double height;

  // ==========================================================================
  // ICÔNES
  // ==========================================================================

  /// Pourcentage de la hauteur utilisé pour la taille des icônes.
  ///
  /// Exemple:
  ///
  /// 60 → 60 % de la hauteur du bouton.
  final double iconSizePercent;

  // ==========================================================================
  // ESPACEMENT
  // ==========================================================================

  final double horizontalPadding;

  final double spacing;

  // ==========================================================================
  // CONSTRUCTEUR
  // ==========================================================================

  const ThemeGlassCard({
    super.key,

    // ------------------------------------------------------------------------
    // GLASS
    // ------------------------------------------------------------------------

    required this.effects,
    required this.shape,
    required this.style,

    // ------------------------------------------------------------------------
    // PALETTE
    // ------------------------------------------------------------------------

    required this.palette,

    // ------------------------------------------------------------------------
    // DIMENSIONS
    // ------------------------------------------------------------------------

    this.width = 210,
    this.height = 75,

    // ------------------------------------------------------------------------
    // ICÔNES
    // ------------------------------------------------------------------------

    this.iconSizePercent = 60,

    // ------------------------------------------------------------------------
    // ESPACEMENT
    // ------------------------------------------------------------------------

    this.horizontalPadding = 2,
    this.spacing = 3,
  }) : assert(
         iconSizePercent >= 0 && iconSizePercent <= 100,
         'iconSizePercent doit être compris entre 0 et 100.',
       );

  @override
  ConsumerState<ThemeGlassCard> createState() => _ThemeGlassCardState();
}

// ============================================================================
// STATE
// ============================================================================

class _ThemeGlassCardState extends ConsumerState<ThemeGlassCard>
    with SingleTickerProviderStateMixin {
  // ==========================================================================
  // ANIMATION
  // ==========================================================================

  late final AnimationController _animController;

  // ==========================================================================
  // MAPPING INDEX → MODE
  // ==========================================================================

  static const Map<int, AppThemeMode> _indexToMode = {
    0: AppThemeMode.system,
    1: AppThemeMode.dark,
    2: AppThemeMode.light,
  };

  // ==========================================================================
  // MAPPING MODE → INDEX
  // ==========================================================================

  static const Map<AppThemeMode, int> _modeToIndex = {
    AppThemeMode.system: 0,
    AppThemeMode.dark: 1,
    AppThemeMode.light: 2,
  };

  // ==========================================================================
  // INIT
  // ==========================================================================

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    // ------------------------------------------------------------------------
    // ANIMATION INITIALE
    // ------------------------------------------------------------------------

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      final AppThemeMode currentMode =
          ref.read(themeProvider).mode;

      if (currentMode != AppThemeMode.system) {
        _animController.forward(from: 0);
      }
    });
  }

  // ==========================================================================
  // DISPOSE
  // ==========================================================================

  @override
  void dispose() {
    _animController.dispose();

    super.dispose();
  }

  // ==========================================================================
  // TAILLE RÉELLE DES ICÔNES
  // ==========================================================================

  double get _realIconSize {
    return widget.height *
        widget.iconSizePercent /
        100.0;
  }

  // ==========================================================================
  // COULEUR PRINCIPALE DU STYLE GLASS
  // ==========================================================================

  Color get _primaryColor {
    final bool useAquaStyle =
        widget.style == GlassStyle.transparentAqua;

    return widget.palette.primaryForStyle(
      useAquaStyle,
    );
  }

  // ==========================================================================
  // COULEUR SYSTÈME
  // ==========================================================================

  Color get _systemColor {
    return widget.palette.info;
  }

  // ==========================================================================
  // COULEUR SOMBRE
  // ==========================================================================

  Color get _darkColor {
    return widget.palette.textSecondary;
  }

  // ==========================================================================
  // COULEUR CLAIRE
  // ==========================================================================

  Color get _lightColor {
    final bool useAquaStyle =
        widget.style == GlassStyle.transparentAqua;

    return widget.palette.primaryForStyle(
      useAquaStyle,
    );
  }

  // ==========================================================================
  // COULEUR INACTIVE
  // ==========================================================================

  Color get _inactiveColor {
    return widget.palette.textSecondary;
  }

  // ==========================================================================
  // COULEUR ACTIVE
  // ==========================================================================

  Color get _activeColor {
    return _primaryColor;
  }

  // ==========================================================================
  // COULEUR D'ICÔNE SELON LE MODE
  // ==========================================================================

  Color _iconColorForIndex(int index) {
    switch (index) {
      case 0:
        return _systemColor;

      case 1:
        return _darkColor;

      case 2:
        return _lightColor;

      default:
        return _inactiveColor;
    }
  }

  // ==========================================================================
  // SÉLECTION DU MODE
  // ==========================================================================

  void _selectMode(int index) {
    final AppThemeMode? newMode =
        _indexToMode[index];

    if (newMode == null) {
      return;
    }

    final AppThemeMode currentMode =
        ref.read(themeProvider).mode;

    // ------------------------------------------------------------------------
    // AUCUN CHANGEMENT
    // ------------------------------------------------------------------------

    if (currentMode == newMode) {
      return;
    }

    // ------------------------------------------------------------------------
    // APPLICATION DU THÈME
    // ------------------------------------------------------------------------

    ref
        .read(themeProvider.notifier)
        .setTheme(newMode);

    // ------------------------------------------------------------------------
    // ANIMATION
    // ------------------------------------------------------------------------

    _animController.forward(from: 0);

    debugPrint(
      '🎨 ThemeGlassCard → Mode $newMode appliqué',
    );
  }

  // ==========================================================================
  // BUILD
  // ==========================================================================

  @override
  Widget build(BuildContext context) {
    // =========================================================================
    // ÉTAT RIVERPOD
    // =========================================================================

    final AppThemeMode currentMode =
        ref.watch(themeProvider).mode;

    final int selectedModeIndex =
        _modeToIndex[currentMode] ?? 0;

    // =========================================================================
    // HAUTEUR TOTALE
    // =========================================================================

    final double totalHeight =
        widget.height + 22;

    // =========================================================================
    // CARTE
    // =========================================================================

    return SizedBox(
      width: widget.width,
      height: totalHeight,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // ===================================================================
          // BOUTON GLASS
          // ===================================================================

          Positioned(
            top: 0,
            child: GlassButton(
              width: widget.width,
              height: widget.height,

              shape: widget.shape,

              effects: widget.effects,

              style: widget.style,

              onTap: () {},

              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal:
                      widget.horizontalPadding,
                ),
                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: [
                    // =========================================================
                    // SYSTÈME
                    // =========================================================

                    _buildIcon(
                      icon: Icons.brightness_auto,
                      color: _iconColorForIndex(0),
                      index: 0,
                      selectedIndex:
                          selectedModeIndex,
                    ),

                    SizedBox(
                      width: widget.spacing,
                    ),

                    // =========================================================
                    // SOMBRE
                    // =========================================================

                    _buildIcon(
                      icon: Icons.dark_mode,
                      color: _iconColorForIndex(1),
                      index: 1,
                      selectedIndex:
                          selectedModeIndex,
                    ),

                    SizedBox(
                      width: widget.spacing,
                    ),

                    // =========================================================
                    // CLAIR
                    // =========================================================

                    _buildIcon(
                      icon: Icons.light_mode,
                      color: _iconColorForIndex(2),
                      index: 2,
                      selectedIndex:
                          selectedModeIndex,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ===================================================================
          // LABEL SYSTÈME
          // ===================================================================

          _buildAnimatedLabel(
            position: 0,
            text: 'Système',
            activeColor: _activeColor,
            selectedIndex: selectedModeIndex,
          ),

          // ===================================================================
          // LABEL SOMBRE
          // ===================================================================

          _buildAnimatedLabel(
            position: 1,
            text: 'Sombre',
            activeColor: _activeColor,
            selectedIndex: selectedModeIndex,
          ),

          // ===================================================================
          // LABEL CLAIR
          // ===================================================================

          _buildAnimatedLabel(
            position: 2,
            text: 'Clair',
            activeColor: _activeColor,
            selectedIndex: selectedModeIndex,
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // ICÔNE
  // ==========================================================================

  Widget _buildIcon({
    required IconData icon,
    required Color color,
    required int index,
    required int selectedIndex,
  }) {
    final bool isActive =
        selectedIndex == index;

    return Expanded(
      child: Center(
        child: AnimatedScale(
          scale: isActive ? 1.15 : 1.0,

          duration:
              const Duration(milliseconds: 250),

          curve: Curves.easeOutBack,

          child: SizedBox(
            width: _realIconSize,
            height: _realIconSize,

            child: GlassIcon(
              icon: icon,

              baseColor: color,

              size: _realIconSize,

              isActive: isActive,

              onTap: () => _selectMode(index),
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================================================
  // LABEL ANIMÉ
  // ==========================================================================

  Widget _buildAnimatedLabel({
    required int position,
    required String text,
    required Color activeColor,
    required int selectedIndex,
  }) {
    final bool isActive =
        selectedIndex == position;

    // =========================================================================
    // LARGEUR D'UNE ZONE
    // =========================================================================

    final double itemWidth =
        (widget.width -
                widget.horizontalPadding * 2) /
            3;

    // =========================================================================
    // POSITION HORIZONTALE
    // =========================================================================

    final double left =
        widget.horizontalPadding +
        (itemWidth * position) +
        (itemWidth / 2) -
        30;

    // =========================================================================
    // LABEL
    // =========================================================================

    return Positioned(
      top: widget.height + 4,
      left: left,
      width: 60,

      child: GestureDetector(
        behavior: HitTestBehavior.opaque,

        onTap: () => _selectMode(position),

        child: AnimatedBuilder(
          animation: _animController,

          builder: (
            BuildContext context,
            Widget? child,
          ) {
            // ===============================================================
            // VALEUR D'ANIMATION
            // ===============================================================

            final double animValue =
                isActive
                    ? _animController.value
                    : 0.0;

            // ===============================================================
            // OPACITÉ
            // ===============================================================

            final double opacity =
                (
                  0.6 +
                  (0.4 *
                      (isActive ? 1 : 0)) +
                  (0.4 * animValue)
                ).clamp(
                  0.0,
                  1.0,
                );

            // ===============================================================
            // SCALE
            // ===============================================================

            final double scale =
                1.0 +
                (0.15 *
                    (isActive ? 1 : 0)) +
                (0.1 * animValue);

            // ===============================================================
            // TRANSLATION
            // ===============================================================

            final double translateY =
                -6 * animValue;

            // ===============================================================
            // TRANSFORM
            // ===============================================================

            return Transform.translate(
              offset: Offset(
                0,
                translateY,
              ),

              child: Opacity(
                opacity: opacity,

                child: Transform.scale(
                  scale: scale,
                  child: child,
                ),
              ),
            );
          },

          child: Text(
            text,

            textAlign: TextAlign.center,

            maxLines: 1,

            overflow: TextOverflow.ellipsis,

            style: TextStyle(
              fontSize: 10,

              fontWeight:
                  isActive
                      ? FontWeight.w900
                      : FontWeight.w600,

              color:
                  isActive
                      ? activeColor
                      : widget.palette.textSecondary,

              letterSpacing: 0.5,

              shadows: [
                if (isActive)
                  Shadow(
                    color:
                        activeColor.withValues(
                      alpha: 0.6,
                    ),
                    blurRadius: 8,
                  )
                else
                  Shadow(
                    color:
                        widget.palette.black
                            .withValues(
                      alpha: 0.22,
                    ),
                    blurRadius: 2,
                    offset: const Offset(
                      0,
                      1,
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
