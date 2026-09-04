import 'package:flutter/material.dart';
import 'package:universal_glass/glass.dart';

/// ============================================================================
/// HOME NAME INPUT PREVIEW
/// ============================================================================
///
/// Démonstration de UniversalGlassNameInput.
///
/// Le preview reçoit [GlassThemeState] depuis la HomePage afin que toutes les
/// couleurs liées au style Glass suivent le mode global.
///
/// ============================================================================
///
/// STYLE GLOBAL
///
/// Classic
/// → GlassColorPalette.classicPreset()
///
/// Aqua
/// → GlassColorPalette.aquaPreset()
///
/// ============================================================================
///
/// IMPORTANT
///
/// Ce preview ne contient aucune couleur d'identité codée en dur.
///
/// Les couleurs sont toujours obtenues depuis [GlassColorPalette].
///
/// Cela concerne :
///
/// • titres
/// • sous-titres
/// • boutons de contrôle
/// • bordures
/// • icône
/// • gradient de démonstration
/// • texte AK
/// • états sélectionnés / non sélectionnés
///
/// ============================================================================

class HomeNameInputPreview extends StatefulWidget {
  // ==========================================================================
  // THEME GLASS
  // ==========================================================================

  final GlassThemeState theme;

  // ==========================================================================
  // CONSTRUCTEUR
  // ==========================================================================

  const HomeNameInputPreview({
    super.key,
    required this.theme,
  });

  @override
  State<HomeNameInputPreview> createState() =>
      _HomeNameInputPreviewState();
}

// ============================================================================
// STATE
// ============================================================================

class _HomeNameInputPreviewState
    extends State<HomeNameInputPreview> {
  // ==========================================================================
  // CONTROLE
  // ==========================================================================

  late final TextEditingController _controller;

  late final FocusNode _focusNode;

  // ==========================================================================
  // ETAT
  // ==========================================================================

  GlassInputBubbleFit _fit =
      GlassInputBubbleFit.contain;

  GlassInputBubbleShape _bubbleShape =
      GlassInputBubbleShape.circle;

  bool _enabled = true;

  bool _readOnly = false;

  // ==========================================================================
  // PALETTE
  // ==========================================================================

  /// Palette effectivement utilisée par le preview.
  ///
  /// Aqua
  /// → aquaPreset()
  ///
  /// Classic
  /// → classicPreset()
  ///
  /// Toute l'interface du preview utilise cette palette.
  GlassColorPalette get _palette =>
      widget.theme.useAquaStyle
          ? GlassColorPalette.aquaPreset()
          : GlassColorPalette.classicPreset();

  // ==========================================================================
  // COULEUR PRINCIPALE
  // ==========================================================================

  Color get _primaryColor =>
      _palette.primaryForStyle(
        widget.theme.useAquaStyle,
      );

  // ==========================================================================
  // COULEUR CLAIRE
  // ==========================================================================

  Color get _lightColor =>
      _palette.lightForStyle(
        widget.theme.useAquaStyle,
      );

  // ==========================================================================
  // COULEUR SOMBRE
  // ==========================================================================

  Color get _darkColor =>
      _palette.darkForStyle(
        widget.theme.useAquaStyle,
      );

  // ==========================================================================
  // INIT
  // ==========================================================================

  @override
  void initState() {
    super.initState();

    _controller =
        TextEditingController();

    _focusNode =
        FocusNode();

    _focusNode.addListener(
      _onFocusChanged,
    );
  }

  // ==========================================================================
  // FOCUS
  // ==========================================================================

  void _onFocusChanged() {
    if (!mounted) {
      return;
    }

    setState(() {});
  }

  // ==========================================================================
  // DISPOSE
  // ==========================================================================

  @override
  void dispose() {
    _focusNode.removeListener(
      _onFocusChanged,
    );

    _controller.dispose();

    _focusNode.dispose();

    super.dispose();
  }

  // ==========================================================================
  // BUILD
  // ==========================================================================

  @override
  Widget build(
    BuildContext context,
  ) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        // ====================================================================
        // TITRE
        // ====================================================================

        Text(
          'NAME INPUT',
          style:
              TextStyle(
            color:
                _palette.textPrimary,

            fontSize:
                13,

            fontWeight:
                FontWeight.w700,

            letterSpacing:
                1.2,
          ),
        ),

        const SizedBox(
          height: 6,
        ),

        // ====================================================================
        // SOUS-TITRE
        // ====================================================================

        Text(
          'UniversalGlassNameInput',
          style:
              TextStyle(
            color:
                _palette.textSecondary.withValues(
              alpha:
                  0.50,
            ),

            fontSize:
                11,
          ),
        ),

        const SizedBox(
          height: 16,
        ),

        // ====================================================================
        // INPUT
        // ====================================================================

        UniversalGlassNameInput(
          controller:
              _controller,

          focusNode:
              _focusNode,

          hintText:
              'Nom complet',

          enabled:
              _enabled,

          readOnly:
              _readOnly,

          textInputAction:
              TextInputAction.done,

          decoration:
              const GlassInputDecoration(),

          // ------------------------------------------------------------------
          // IMPORTANT
          //
          // Aucune couleur n'est imposée à l'Icon.
          //
          // Le composant UniversalGlassNameInput / GlassInputIconBubble
          // peut donc appliquer la couleur correspondant au style global.
          // ------------------------------------------------------------------

          leadingChild:
              const Icon(
            Icons.person_outline_rounded,
            size:
                21,
          ),

          validator:
              (value) {
            if (value == null ||
                value.trim().isEmpty) {
              return 'Veuillez saisir votre nom';
            }

            return null;
          },

          autovalidateMode:
              AutovalidateMode.onUserInteraction,

          onChanged:
              (_) {
            setState(() {});
          },
        ),

        const SizedBox(
          height: 18,
        ),

        // ====================================================================
        // CONTROLES
        // ====================================================================

        _buildControls(),

        const SizedBox(
          height: 20,
        ),

        // ====================================================================
        // PREVIEW DES BULLES
        // ====================================================================

        _buildBubblePreview(),
      ],
    );
  }

  // ==========================================================================
  // CONTROLES
  // ==========================================================================

  Widget _buildControls() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        // ----------------------------------------------------------------------
        // CONTAIN
        // ----------------------------------------------------------------------

        _buildChoiceButton(
          label:
              'Contain',

          selected:
              _fit ==
                  GlassInputBubbleFit.contain,

          onTap: () {
            setState(() {
              _fit =
                  GlassInputBubbleFit.contain;
            });
          },
        ),

        // ----------------------------------------------------------------------
        // COVER
        // ----------------------------------------------------------------------

        _buildChoiceButton(
          label:
              'Cover',

          selected:
              _fit ==
                  GlassInputBubbleFit.cover,

          onTap: () {
            setState(() {
              _fit =
                  GlassInputBubbleFit.cover;
            });
          },
        ),

        // ----------------------------------------------------------------------
        // CIRCLE
        // ----------------------------------------------------------------------

        _buildChoiceButton(
          label:
              'Circle',

          selected:
              _bubbleShape ==
                  GlassInputBubbleShape.circle,

          onTap: () {
            setState(() {
              _bubbleShape =
                  GlassInputBubbleShape.circle;
            });
          },
        ),

        // ----------------------------------------------------------------------
        // SQUARE
        // ----------------------------------------------------------------------

        _buildChoiceButton(
          label:
              'Square',

          selected:
              _bubbleShape ==
                  GlassInputBubbleShape.square,

          onTap: () {
            setState(() {
              _bubbleShape =
                  GlassInputBubbleShape.square;
            });
          },
        ),

        // ----------------------------------------------------------------------
        // RECTANGLE
        // ----------------------------------------------------------------------

        _buildChoiceButton(
          label:
              'Rectangle',

          selected:
              _bubbleShape ==
                  GlassInputBubbleShape.rectangle,

          onTap: () {
            setState(() {
              _bubbleShape =
                  GlassInputBubbleShape.rectangle;
            });
          },
        ),

        // ----------------------------------------------------------------------
        // ENABLED
        // ----------------------------------------------------------------------

        _buildChoiceButton(
          label:
              _enabled
                  ? 'Enabled'
                  : 'Disabled',

          selected:
              _enabled,

          onTap: () {
            setState(() {
              _enabled =
                  !_enabled;
            });
          },
        ),

        // ----------------------------------------------------------------------
        // READ ONLY
        // ----------------------------------------------------------------------

        _buildChoiceButton(
          label:
              _readOnly
                  ? 'ReadOnly'
                  : 'Editable',

          selected:
              _readOnly,

          onTap: () {
            setState(() {
              _readOnly =
                  !_readOnly;
            });
          },
        ),
      ],
    );
  }

  // ==========================================================================
  // CHOICE BUTTON
  // ==========================================================================

  Widget _buildChoiceButton({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    // =========================================================================
    // COULEURS
    // =========================================================================

    final Color backgroundColor =
        selected
            ? _primaryColor.withValues(
                alpha:
                    0.14,
              )
            : _palette.white.withValues(
                alpha:
                    0.05,
              );

    final Color borderColor =
        selected
            ? _lightColor.withValues(
                alpha:
                    0.40,
              )
            : _palette.white.withValues(
                alpha:
                    0.08,
              );

    final Color textColor =
        selected
            ? _lightColor
            : _palette.textSecondary.withValues(
                alpha:
                    0.70,
              );

    return GestureDetector(
      onTap:
          onTap,

      child:
          AnimatedContainer(
        duration:
            const Duration(
          milliseconds: 160,
        ),

        curve:
            Curves.easeOut,

        padding:
            const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 7,
        ),

        decoration:
            BoxDecoration(
          color:
              backgroundColor,

          borderRadius:
              BorderRadius.circular(
            9,
          ),

          border:
              Border.all(
            color:
                borderColor,

            width:
                selected
                    ? 0.85
                    : 0.65,
          ),

          boxShadow:
              selected
                  ? [
                      BoxShadow(
                        color:
                            _primaryColor
                                .withValues(
                          alpha:
                              0.10,
                        ),

                        blurRadius:
                            6,

                        spreadRadius:
                            0,

                        offset:
                            Offset.zero,
                      ),
                    ]
                  : const [],
        ),

        child:
            Text(
          label,

          style:
              TextStyle(
            color:
                textColor,

            fontSize:
                11,

            fontWeight:
                selected
                    ? FontWeight.w600
                    : FontWeight.w400,
          ),
        ),
      ),
    );
  }

  // ==========================================================================
  // BUBBLE PREVIEW
  // ==========================================================================

  Widget _buildBubblePreview() {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [
        // ====================================================================
        // LABEL
        // ====================================================================

        Text(
          'BUBBLE',

          style:
              TextStyle(
            color:
                _palette.textSecondary.withValues(
              alpha:
                  0.45,
            ),

            fontSize:
                10,

            fontWeight:
                FontWeight.w700,

            letterSpacing:
                1,
          ),
        ),

        const SizedBox(
          height: 12,
        ),

        // ====================================================================
        // BULLES
        // ====================================================================

        Row(
          children: [
            // ==================================================================
            // ICON BUBBLE
            // ==================================================================

            GlassInputIconBubble(
              size:
                  46,

              // ----------------------------------------------------------------
              // STYLE GLOBAL
              // ----------------------------------------------------------------

              useAquaStyle:
                  widget.theme.useAquaStyle,

              // ----------------------------------------------------------------
              // PALETTE
              // ----------------------------------------------------------------
              //
              // On transmet explicitement la palette active.
              //
              // Cela garantit que la bulle et son contenu utilisent exactement
              // la même identité visuelle que le reste du preview.
              //
              // ----------------------------------------------------------------

              palette:
                  _palette,

              isActive:
                  _focusNode.hasFocus,

              enabled:
                  _enabled,

              fit:
                  _fit,

              shape:
                  _bubbleShape,

              child:
                  const Icon(
                Icons.person_outline_rounded,
                size:
                    21,
              ),
            ),

            const SizedBox(
              width: 12,
            ),

            // ==================================================================
            // IMAGE / COVER
            // ==================================================================

            GlassInputIconBubble(
              size:
                  46,

              // ----------------------------------------------------------------
              // STYLE GLOBAL
              // ----------------------------------------------------------------

              useAquaStyle:
                  widget.theme.useAquaStyle,

              // ----------------------------------------------------------------
              // PALETTE ACTIVE
              // ----------------------------------------------------------------

              palette:
                  _palette,

              enabled:
                  _enabled,

              fit:
                  GlassInputBubbleFit.cover,

              shape:
                  _bubbleShape,

              child:
                  Container(
                decoration:
                    BoxDecoration(
                  gradient:
                      LinearGradient(
                    begin:
                        Alignment.topLeft,

                    end:
                        Alignment.bottomRight,

                    colors: [
                      _lightColor.withValues(
                        alpha:
                            0.95,
                      ),

                      _primaryColor.withValues(
                        alpha:
                            0.80,
                      ),

                      _darkColor.withValues(
                        alpha:
                            0.95,
                      ),
                    ],
                  ),
                ),

                child:
                    Center(
                  child:
                      Text(
                    'AK',

                    style:
                        TextStyle(
                      color:
                          _palette.textPrimary,

                      fontSize:
                          15,

                      fontWeight:
                          FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}