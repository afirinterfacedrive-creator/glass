
import 'package:flutter/material.dart';

/// ============================================================================
/// GLASS FIELD NOTCH
/// ============================================================================
///
/// Composant visuel utilisé par les champs Universal Glass.
///
/// RESPONSABILITÉS
///
/// - dessiner visuellement l'encoche du label flottant ;
/// - dessiner le fond situé sous le label ;
/// - dessiner la bordure spécifique à l'encoche ;
/// - rester totalement indépendant du hit-test ;
/// - ne jamais clipper le TextField/TextFormField.
///
/// IMPORTANT
///
/// Ce composant ne constitue PAS une surface Glass.
///
/// La surface reste entièrement gérée par [GlassSurfaceContainer].
///
/// Le notch est simplement superposé à la surface lorsque le label flotte.
///
/// Architecture :
///
/// Stack(
///   clipBehavior: Clip.none,
///   children: [
///     GlassSurfaceContainer(...),
///
///     if (isFloating)
///       GlassFieldNotch(...),
///
///     if (isFloating)
///       Positioned(
///         ...,
///         child: IgnorePointer(
///           child: label,
///         ),
///       ),
///   ],
/// )
///
/// Le notch ne doit donc jamais être utilisé comme ClipPath autour
/// du TextField.
///
/// ============================================================================

class GlassFieldNotch extends StatelessWidget {
  /// Position horizontale de début du notch.
  final double notchStart;

  /// Largeur du notch.
  final double notchWidth;

  /// Couleur de remplissage du notch.
  ///
  /// Cette couleur correspond au fond visuel situé directement sous
  /// le label flottant.
  final Color color;

  /// Couleur de la bordure du notch.
  final Color borderColor;

  /// Épaisseur de la bordure du notch.
  final double borderWidth;

  /// Rayon de la surface du champ.
  ///
  /// Conservé dans l'API afin que la géométrie du notch reste synchronisée
  /// avec celle du champ et puisse évoluer ultérieurement.
  ///
  /// Le painter actuel n'en dépend pas directement car le notch est une
  /// géométrie locale située au sommet du champ.
  final BorderRadius borderRadius;

  /// Indique si le notch doit être affiché.
  final bool visible;

  const GlassFieldNotch({
    super.key,
    required this.notchStart,
    required this.notchWidth,
    required this.color,
    required this.borderColor,
    required this.borderWidth,
    required this.borderRadius,
    this.visible = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!visible) {
      return const SizedBox.shrink();
    }

    return Positioned.fill(
      child: IgnorePointer(
        ignoring: true,
        child: CustomPaint(
          painter: GlassFieldNotchPainter(
            notchStart: notchStart,
            notchWidth: notchWidth,
            color: color,
            borderColor: borderColor,
            borderWidth: borderWidth,
            borderRadius: borderRadius,
          ),
        ),
      ),
    );
  }
}

/// ============================================================================
/// GLASS FIELD NOTCH PAINTER
/// ============================================================================
///
/// Painter purement visuel du notch.
///
/// Le painter :
///
/// - ne reçoit aucun controller ;
/// - ne connaît aucun TextField ;
/// - ne connaît aucun état de focus ;
/// - ne connaît pas Riverpod ;
/// - ne connaît pas GlassSurfaceRenderer.
///
/// Il reçoit uniquement les paramètres graphiques nécessaires.
///
/// Le notch est dessiné au-dessus de la surface existante.
///
/// Il ne découpe donc jamais la surface et n'interfère pas avec :
///
/// - le TextField ;
/// - le TextFormField ;
/// - le curseur ;
/// - la sélection ;
/// - le clavier ;
/// - le premier clic ;
/// - le hit-test.
///
/// ============================================================================

class GlassFieldNotchPainter extends CustomPainter {
  final double notchStart;
  final double notchWidth;
  final Color color;
  final Color borderColor;
  final double borderWidth;
  final BorderRadius borderRadius;

  const GlassFieldNotchPainter({
    required this.notchStart,
    required this.notchWidth,
    required this.color,
    required this.borderColor,
    required this.borderWidth,
    required this.borderRadius,
  });

  // --------------------------------------------------------------------------
  // CONSTANTES DE GÉOMÉTRIE
  // --------------------------------------------------------------------------

  /// Profondeur verticale du notch.
  static const double notchDepth = 6.0;

  /// Rayon des extrémités du notch.
  static const double notchRadius = 4.0;

  /// Petit décalage permettant d'aligner le notch avec la bordure.
  static const double notchInset = 2.0;

  // --------------------------------------------------------------------------
  // GÉOMÉTRIE COMMUNE
  // --------------------------------------------------------------------------
  //
  // Le calcul start/end est partagé par le remplissage et la bordure.
  //
  // Cela garantit que les deux chemins utilisent exactement la même
  // géométrie.
  // --------------------------------------------------------------------------

  _NotchGeometry _getGeometry(Size size) {
    if (size.width <= 0) {
      return const _NotchGeometry(
        start: 0,
        end: 0,
      );
    }

    final double minX = notchRadius;
    final double maxX = size.width - notchRadius;

    final double start = (notchStart + notchInset).clamp(
      minX,
      maxX,
    );

    final double safeWidth = notchWidth.clamp(
      0.0,
      size.width,
    );

    final double end = (start + safeWidth).clamp(
      start + notchRadius,
      maxX,
    );

    return _NotchGeometry(
      start: start,
      end: end,
    );
  }

  // --------------------------------------------------------------------------
  // NOTCH PATH
  // --------------------------------------------------------------------------

  Path _buildNotchPath(Size size) {
    final _NotchGeometry geometry = _getGeometry(size);

    final double start = geometry.start;
    final double end = geometry.end;

    final Path path = Path();

    // ------------------------------------------------------------------------
    // DÉBUT DU NOTCH
    // ------------------------------------------------------------------------

    path.moveTo(
      start - notchRadius,
      0,
    );

    path.quadraticBezierTo(
      start,
      0,
      start,
      notchRadius,
    );

    // ------------------------------------------------------------------------
    // DESCENTE
    // ------------------------------------------------------------------------

    path.lineTo(
      start,
      notchDepth - notchRadius,
    );

    path.quadraticBezierTo(
      start,
      notchDepth,
      start + notchRadius,
      notchDepth,
    );

    // ------------------------------------------------------------------------
    // FOND DU NOTCH
    // ------------------------------------------------------------------------

    path.lineTo(
      end - notchRadius,
      notchDepth,
    );

    // ------------------------------------------------------------------------
    // REMONTÉE
    // ------------------------------------------------------------------------

    path.quadraticBezierTo(
      end,
      notchDepth,
      end,
      notchDepth - notchRadius,
    );

    path.lineTo(
      end,
      notchRadius,
    );

    // ------------------------------------------------------------------------
    // FIN DU NOTCH
    // ------------------------------------------------------------------------

    path.quadraticBezierTo(
      end,
      0,
      end + notchRadius,
      0,
    );

    path.close();

    return path;
  }

  // --------------------------------------------------------------------------
  // BORDER PATH
  // --------------------------------------------------------------------------
  //
  // Même géométrie que le notch, mais sans fermeture.
  //
  // Le chemin commence et se termine sur la bordure supérieure du champ.
  //
  // --------------------------------------------------------------------------

  Path _buildBorderPath(Size size) {
    final _NotchGeometry geometry = _getGeometry(size);

    final double start = geometry.start;
    final double end = geometry.end;

    final Path path = Path();

    // ------------------------------------------------------------------------
    // DÉBUT
    // ------------------------------------------------------------------------

    path.moveTo(
      start - notchRadius,
      0,
    );

    path.quadraticBezierTo(
      start,
      0,
      start,
      notchRadius,
    );

    // ------------------------------------------------------------------------
    // DESCENTE
    // ------------------------------------------------------------------------

    path.lineTo(
      start,
      notchDepth - notchRadius,
    );

    path.quadraticBezierTo(
      start,
      notchDepth,
      start + notchRadius,
      notchDepth,
    );

    // ------------------------------------------------------------------------
    // FOND
    // ------------------------------------------------------------------------

    path.lineTo(
      end - notchRadius,
      notchDepth,
    );

    // ------------------------------------------------------------------------
    // REMONTÉE
    // ------------------------------------------------------------------------

    path.quadraticBezierTo(
      end,
      notchDepth,
      end,
      notchDepth - notchRadius,
    );

    path.lineTo(
      end,
      notchRadius,
    );

    // ------------------------------------------------------------------------
    // FIN
    // ------------------------------------------------------------------------

    path.quadraticBezierTo(
      end,
      0,
      end + notchRadius,
      0,
    );

    return path;
  }

  // --------------------------------------------------------------------------
  // PAINT
  // --------------------------------------------------------------------------

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    if (size.width <= 0 || size.height <= 0) {
      return;
    }

    // ------------------------------------------------------------------------
    // FOND
    // ------------------------------------------------------------------------

    final Path notchPath = _buildNotchPath(size);

    final Paint backgroundPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = color;

    canvas.drawPath(
      notchPath,
      backgroundPaint,
    );

    // ------------------------------------------------------------------------
    // BORDURE
    // ------------------------------------------------------------------------

    final double safeBorderWidth = borderWidth.clamp(
      0.0,
      20.0,
    );

    if (safeBorderWidth <= 0.0) {
      return;
    }

    final Path borderPath = _buildBorderPath(size);

    final Paint borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = safeBorderWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..color = borderColor;

    canvas.drawPath(
      borderPath,
      borderPaint,
    );
  }

  // --------------------------------------------------------------------------
  // REPAINT
  // --------------------------------------------------------------------------

  @override
  bool shouldRepaint(
    covariant GlassFieldNotchPainter oldDelegate,
  ) {
    return oldDelegate.notchStart != notchStart ||
        oldDelegate.notchWidth != notchWidth ||
        oldDelegate.color != color ||
        oldDelegate.borderColor != borderColor ||
        oldDelegate.borderWidth != borderWidth ||
        oldDelegate.borderRadius != borderRadius;
  }

  // --------------------------------------------------------------------------
  // SEMANTICS
  // --------------------------------------------------------------------------

  @override
  bool shouldRebuildSemantics(
    covariant GlassFieldNotchPainter oldDelegate,
  ) {
    return false;
  }
}

/// ============================================================================
/// NOTCH GEOMETRY
/// ============================================================================
///
/// Géométrie normalisée du notch.
///
/// Permet au chemin de remplissage et au chemin de bordure de partager
/// exactement les mêmes coordonnées.
/// ============================================================================

class _NotchGeometry {
  final double start;
  final double end;

  const _NotchGeometry({
    required this.start,
    required this.end,
  });
}
