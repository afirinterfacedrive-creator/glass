import 'package:flutter/material.dart';

import '../../enums/glass_enums.dart';
import '../../theme/glass_color_palette.dart';

/// ============================================================================
/// GLASS INPUT ICON BUBBLE
///
/// Zone visuelle Glass utilisée dans les champs de saisie.
///
/// Supporte :
///
/// • IconData
/// • texte court
/// • initiales
/// • image
/// • drapeau
///
/// ============================================================================

class GlassInputIconBubble extends StatefulWidget {

  // ==========================================================================
  // CONTENU
  // ==========================================================================

  final Widget child;


  // ==========================================================================
  // PALETTE
  // ==========================================================================

  final GlassColorPalette? palette;


  // ==========================================================================
  // STYLE
  // ==========================================================================

  /// true  → Aqua
  /// false → Classic
  /// null  → contexte parent

  final bool? useAquaStyle;



  // ==========================================================================
  // COMPATIBILITE
  // ==========================================================================

  final Color accent;



  // ==========================================================================
  // DIMENSIONS
  // ==========================================================================

  final double size;

  final double? width;

  final double? height;



  // ==========================================================================
  // ETAT
  // ==========================================================================

  final bool isActive;

  final bool enabled;



  // ==========================================================================
  // ACTION
  // ==========================================================================

  final VoidCallback? onTap;



  // ==========================================================================
  // CONTENU
  // ==========================================================================

  final GlassInputBubbleFit fit;



  // ==========================================================================
  // FORME
  // ==========================================================================

  final GlassInputBubbleShape shape;

  final double? borderRadius;



  // ==========================================================================
  // EFFETS
  // ==========================================================================

  final bool showContentGlow;



  const GlassInputIconBubble({

    super.key,

    required this.child,


    this.palette,

    this.useAquaStyle,


    this.accent =
    Colors.transparent,


    this.size = 46,


    this.width,

    this.height,


    this.isActive = false,

    this.enabled = true,


    this.onTap,


    this.fit =
        GlassInputBubbleFit.contain,


    this.shape =
        GlassInputBubbleShape.circle,


    this.borderRadius,


    this.showContentGlow = false,

  });



  @override
  State<GlassInputIconBubble> createState() =>
      _GlassInputIconBubbleState();
}




// ============================================================================
// GLOBAL STYLE CONTEXT
// ============================================================================

class GlassInputBubbleStyle extends InheritedWidget {


  final bool useAquaStyle;



  const GlassInputBubbleStyle({

    super.key,

    required this.useAquaStyle,

    required super.child,

  });



  static bool? maybeOf(
    BuildContext context,
  ) {

    return context
        .dependOnInheritedWidgetOfExactType<
            GlassInputBubbleStyle>()
        ?.useAquaStyle;

  }



  @override
  bool updateShouldNotify(
    GlassInputBubbleStyle oldWidget,
  ) {

    return oldWidget.useAquaStyle !=
        useAquaStyle;

  }
}




// ============================================================================
// STATE
// ============================================================================

class _GlassInputIconBubbleState
    extends State<GlassInputIconBubble> {


  bool _hovered = false;

  bool _pressed = false;



  // ==========================================================================
  // STYLE GLOBAL
  // ==========================================================================

  bool? get _globalUseAquaStyle {

    return GlassInputBubbleStyle.maybeOf(
      context,
    );

  }




  // ==========================================================================
  // STYLE EFFECTIF
  // ==========================================================================

 bool get _effectiveUseAquaStyle {

  if (widget.useAquaStyle != null) {
    return widget.useAquaStyle!;
  }

  if (_globalUseAquaStyle != null) {
    return _globalUseAquaStyle!;
  }

  return false;
}



  // ==========================================================================
  // PALETTE EFFECTIVE
  // ==========================================================================

  GlassColorPalette get _palette {


    if (widget.palette != null) {

      return widget.palette!;

    }


    return _effectiveUseAquaStyle

        ? GlassColorPalette.aquaPreset()

        : GlassColorPalette.classicPreset();

  }




  // ==========================================================================
  // COULEURS
  // ==========================================================================

 Color get _primaryColor {

  return _resolvedPrimaryColor;

}



  Color get _lightColor {

    return _palette.lightForStyle(
      _effectiveUseAquaStyle,
    );

  }



  Color get _darkColor {

    return _palette.darkForStyle(
      _effectiveUseAquaStyle,
    );

  }



  Color get _iconColor {


    if (!widget.enabled) {

      return _palette.textDisabled;

    }


    return _primaryColor;

  }


Color get _resolvedPrimaryColor {

  if (widget.accent != Colors.transparent) {
    return widget.accent;
  }

  return _palette.primaryForStyle(
    _effectiveUseAquaStyle,
  );
}

  // ==========================================================================
  // TAILLE CONTENU
  // ==========================================================================

  double get _contentSize {


    final size = _baseSize();



    if (size <= 40) {

      return 18;

    }


    if (size <= 55) {

      return 22;

    }


    if (size <= 80) {

      return 30;

    }


    return 36;

  }



  // ==========================================================================
  // DIMENSION SAFE
  // ==========================================================================

  double _safeDimension(

    double? value,

    double fallback,

  ) {


    if (value == null ||
        !value.isFinite ||
        value <= 0) {

      return fallback;

    }



    return value
        .clamp(
          32,
          240,
        )
        .toDouble();

  }



  double _baseSize() {

    return _safeDimension(
      widget.size,
      46,
    );

  }

    // ==========================================================================
  // WIDTH
  // ==========================================================================

  double _bubbleWidth() {

    final double base =
        _baseSize();


    switch (widget.shape) {


      case GlassInputBubbleShape.circle:

        return base;



      case GlassInputBubbleShape.square:

        return base;



      case GlassInputBubbleShape.rectangle:

      case GlassInputBubbleShape.pill:

        return _safeDimension(
          widget.width,
          base,
        );
    }
  }




  // ==========================================================================
  // HEIGHT
  // ==========================================================================

  double _bubbleHeight() {

    final double base =
        _baseSize();


    switch (widget.shape) {


      case GlassInputBubbleShape.circle:

        return base;



      case GlassInputBubbleShape.square:

        return base;



      case GlassInputBubbleShape.rectangle:

      case GlassInputBubbleShape.pill:

        return _safeDimension(
          widget.height,
          base,
        );
    }
  }




  // ==========================================================================
  // BORDER WIDTH
  // ==========================================================================

  double get _borderWidth {


    if (widget.isActive) {

      return 1.20;

    }


    if (_hovered) {

      return 0.95;

    }


    return 0.65;

  }




  // ==========================================================================
  // BACKGROUND GRADIENT
  // ==========================================================================

  List<Color> _backgroundGradient() {


    if (!widget.enabled) {

      return [

        _palette.white.withValues(
          alpha: 0.025,
        ),


        _palette.white.withValues(
          alpha: 0.010,
        ),

      ];

    }



    if (widget.isActive) {


      return [

        _lightColor.withValues(
          alpha: 0.30,
        ),


        _primaryColor.withValues(
          alpha: 0.18,
        ),

      ];

    }




    if (_hovered) {


      return [

        _lightColor.withValues(
          alpha: 0.20,
        ),


        _primaryColor.withValues(
          alpha: 0.08,
        ),

      ];

    }




    return [

      _primaryColor.withValues(
        alpha: 0.12,
      ),


      _primaryColor.withValues(
        alpha: 0.035,
      ),

    ];

  }




  // ==========================================================================
  // BORDER COLOR
  // ==========================================================================

  Color _borderColor() {


    if (!widget.enabled) {


      return _palette.border.withValues(
        alpha: 0.03,
      );

    }




    if (widget.isActive) {


      return _primaryColor.withValues(
        alpha: 0.90,
      );

    }




    if (_hovered) {


      return _primaryColor.withValues(
        alpha: 0.45,
      );

    }




    // IMPORTANT :
    //
    // Avant :
    // alpha 0.42 permanent
    //
    // Résultat :
    // bordure cyan visible même Classic
    //
    // Correction :
    // identité faible au repos


    return _primaryColor.withValues(
      alpha: 0.18,
    );

  }




  // ==========================================================================
  // BOX SHAPE
  // ==========================================================================

  BoxShape _boxShape() {


    switch(widget.shape) {


      case GlassInputBubbleShape.circle:

        return BoxShape.circle;



      case GlassInputBubbleShape.square:

      case GlassInputBubbleShape.rectangle:

      case GlassInputBubbleShape.pill:

        return BoxShape.rectangle;

    }

  }




  // ==========================================================================
  // BORDER RADIUS
  // ==========================================================================

  BorderRadius? _borderRadius(
    double height,
  ) {


    switch(widget.shape) {


      case GlassInputBubbleShape.circle:

        return null;



      case GlassInputBubbleShape.square:

        return BorderRadius.zero;



      case GlassInputBubbleShape.rectangle:


        return BorderRadius.circular(

          widget.borderRadius ?? 14,

        );



      case GlassInputBubbleShape.pill:


        return BorderRadius.circular(

          height / 2,

        );

    }

  }




  // ==========================================================================
  // CONTENT CLIP
  // ==========================================================================

  Widget _buildClippedContent(

    double width,

    double height,

  ) {


    final content =
        _buildContent(
          width,
          height,
        );



    switch(widget.shape) {



      case GlassInputBubbleShape.circle:


        return ClipOval(

          child: content,

        );




      case GlassInputBubbleShape.square:


        return ClipRect(

          child: content,

        );




      case GlassInputBubbleShape.rectangle:


        return ClipRRect(

          borderRadius:
              BorderRadius.circular(

                widget.borderRadius ?? 14,

              ),


          child: content,

        );




      case GlassInputBubbleShape.pill:


        return ClipRRect(

          borderRadius:
              BorderRadius.circular(

                height / 2,

              ),


          child: content,

        );

    }

  }

    // ==========================================================================
  // BUILD
  // ==========================================================================

  @override
  Widget build(
    BuildContext context,
  ) {


    final double width =
        _bubbleWidth();


    final double height =
        _bubbleHeight();



    return MouseRegion(


      cursor:
          widget.enabled
              ? SystemMouseCursors.click
              : SystemMouseCursors.basic,



      onEnter: (_) {


        if (!widget.enabled) {

          return;

        }


        setState(() {

          _hovered = true;

        });

      },



      onExit: (_) {


        if (_hovered) {

          setState(() {

            _hovered = false;

          });

        }

      },



      child: GestureDetector(


        behavior:
            HitTestBehavior.opaque,



        onTapDown: (_) {


          if (!widget.enabled) {

            return;

          }


          setState(() {

            _pressed = true;

          });

        },



        onTapUp: (_) {


          if (!widget.enabled) {

            return;

          }


          setState(() {

            _pressed = false;

          });



          widget.onTap?.call();

        },



        onTapCancel: () {


          if (_pressed) {


            setState(() {

              _pressed = false;

            });

          }

        },



        child: AnimatedScale(


          scale:


              _pressed

                  ? 0.94


                  : widget.isActive

                      ? 1.06


                      : _hovered

                          ? 1.03


                          : 1.0,



          duration:
              const Duration(
            milliseconds: 140,
          ),



          curve:
              Curves.easeOutBack,




          child: AnimatedContainer(


            duration:
                const Duration(
              milliseconds: 180,
            ),



            curve:
                Curves.easeOut,



            width:
                width,



            height:
                height,



            decoration:
                BoxDecoration(



              shape:
                  _boxShape(),




              borderRadius:
                  _borderRadius(
                    height,
                  ),




              gradient:
                  LinearGradient(


                begin:
                    Alignment.topLeft,



                end:
                    Alignment.bottomRight,



                colors:
                    _backgroundGradient(),

              ),




              border:
                  Border.all(


                color:
                    _borderColor(),



                width:
                    _borderWidth,

              ),




              boxShadow:
                  _buildGlow(),

            ),




            child:
                _buildClippedContent(
                  width,
                  height,
                ),


          ),

        ),

      ),

    );

  }




  // ==========================================================================
  // CONTENT BUILDER
  // ==========================================================================

  Widget _buildContent(

    double width,

    double height,

  ) {



    final Widget child =
        _buildStyledChild(
          widget.child,
        );




    switch(widget.fit) {



      case GlassInputBubbleFit.contain:



        return SizedBox(


          width:
              width,



          height:
              height,



          child:
              Center(

            child:
                _buildContentGlow(
                  child,
                ),

          ),

        );





      case GlassInputBubbleFit.cover:



        return SizedBox(


          width:
              width,



          height:
              height,



          child:
              FittedBox(


            fit:
                BoxFit.cover,



            child:
                _buildContentGlow(
                  child,
                ),

          ),

        );

    }

  }




  // ==========================================================================
  // STYLE CHILD
  // ==========================================================================

  Widget _buildStyledChild(

    Widget child,

  ) {


    return IconTheme(


      data:
          IconThemeData(


        color:
            _iconColor,



        size:
            _contentSize,

      ),




      child:
          DefaultTextStyle(



        style:
            TextStyle(



          color:
              _iconColor,



          fontWeight:
              FontWeight.w600,



        ),




        child:
            child,

      ),


    );

  }




  // ==========================================================================
  // CONTENT GLOW
  // ==========================================================================

  Widget _buildContentGlow(

    Widget child,

  ) {



    if (!widget.showContentGlow ||
        !widget.enabled) {


      return child;

    }




    final double opacity =



        widget.isActive

            ? 0.35



            : _hovered

                ? 0.20



                : 0.12;




    return DecoratedBox(


      decoration:
          BoxDecoration(


        shape:
            _boxShape(),



        borderRadius:
            _borderRadius(
              _bubbleHeight(),
            ),



        boxShadow: [



          BoxShadow(


            color:
                _primaryColor.withValues(
                  alpha: opacity,
                ),



            blurRadius:
                widget.isActive
                    ? 10
                    : 6,



          ),

        ],


      ),



      child:
          child,

    );

  }

    // ==========================================================================
  // GLOW BULLE GLASS
  // ==========================================================================

  List<BoxShadow> _buildGlow() {


    if (!widget.enabled) {

      return const [];

    }



    // =========================================================================
    // ACTIVE
    // =========================================================================

    if (widget.isActive) {


      return [


        // ------------------------------------------------------------
        // IDENTITE
        // ------------------------------------------------------------

        BoxShadow(

          color:
              _primaryColor.withValues(
                alpha: 0.22,
              ),


          blurRadius:
              12,


          spreadRadius:
              0,

        ),




        // ------------------------------------------------------------
        // HIGHLIGHT GLASS
        // ------------------------------------------------------------

        BoxShadow(

          color:
              _lightColor.withValues(
                alpha: 0.20,
              ),


          blurRadius:
              5,


          offset:
              const Offset(
                0,
                -1,
              ),

        ),




        // ------------------------------------------------------------
        // PROFONDEUR
        // ------------------------------------------------------------

        BoxShadow(

          color:
              _darkColor.withValues(
                alpha: 0.12,
              ),


          blurRadius:
              8,


          offset:
              const Offset(
                0,
                3,
              ),

        ),

      ];

    }





    // =========================================================================
    // HOVER
    // =========================================================================

    if (_hovered) {


      return [



        BoxShadow(

          color:
              _primaryColor.withValues(
                alpha: 0.12,
              ),


          blurRadius:
              8,

        ),




        BoxShadow(

          color:
              _lightColor.withValues(
                alpha: 0.10,
              ),


          blurRadius:
              4,


          offset:
              const Offset(
                0,
                -1,
              ),

        ),

      ];

    }





    // =========================================================================
    // NORMAL
    // =========================================================================

    return [



      BoxShadow(

        color:
            _primaryColor.withValues(
              alpha: 0.045,
            ),


        blurRadius:
            4,


      ),





      BoxShadow(

        color:
            _palette.black.withValues(
              alpha: 0.10,
            ),


        blurRadius:
            6,


        offset:
            const Offset(
              0,
              2,
            ),

      ),

    ];

  }

}

