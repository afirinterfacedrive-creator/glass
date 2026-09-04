import 'package:flutter/material.dart';

class GlassLayoutCalibrator {
  final double fieldHeight;
  final double fontSize;
  final bool hasPrefixIcon;

  const GlassLayoutCalibrator({
    required this.fieldHeight,
    required this.fontSize,
    this.hasPrefixIcon = false,
  });

  // =========================================================================
  // MODE
  // =========================================================================

  /// Champ très compact.
  bool get isVeryCompact => fieldHeight <= 48;

  // =========================================================================
  // ICON / BUBBLE
  // =========================================================================

  /// Diamètre de la bulle d'icône.
  double get iconSize =>
      isVeryCompact ? 26.0 : 36.0;

  // =========================================================================
  // NOTCH
  // =========================================================================

  /// Position horizontale de départ de l'encoche.
  double get notchStart =>
      hasPrefixIcon
          ? iconSize + 16.0
          : 14.0;

  /// Largeur de l'encoche du label.
  double getLabelWidth(String label) {
  final TextPainter painter = TextPainter(
    text: TextSpan(
      text: label,
      style: TextStyle(
        fontSize: 10.5,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.2,
      ),
    ),
    textDirection: TextDirection.ltr,
  )..layout();

  return painter.width + 10.0;
}

  // =========================================================================
  // LABEL
  // =========================================================================

  /// Position verticale du label lorsqu'il est au repos.
  double get labelTopAtRest {
    return isVeryCompact
        ? (fieldHeight - 14) / 2 - 1.0
        : (fieldHeight - fontSize) / 2 - 1.5;
  }

  /// Position horizontale du label.
  double getLabelLeft(bool isFloating) {
    if (isFloating) {
      return notchStart + 4.0;
    }

    return hasPrefixIcon
        ? iconSize + 28.0
        : 16.0;
  }

  // =========================================================================
  // TEXT FIELD
  // =========================================================================

  /// Padding interne du TextFormField.
  EdgeInsets get contentPadding {
    return EdgeInsets.only(
      left: 1.0,
      top: isVeryCompact ? 0.0 : 2.0,
      bottom: isVeryCompact ? 4.0 : 8.0,
    );
  }

  /// Décalage vertical visuel du texte, du hint et du curseur.
  ///
  /// Une valeur négative fait monter le contenu.
  // double get textVerticalOffset {
  //   return isVeryCompact
  //       ? -0.9
  //       : -2.0;
  // }
  double get textVerticalOffset {
  return isVeryCompact
      ? -2.0
      : -3.5;
}

  /// Décalage horizontal du texte/hint.
  ///
  /// Permet d'aligner le texte avec les autres éléments
  /// du champ sans modifier le padding structurel.
  double get textHorizontalOffset => 0.0;

  /// Translation complète du contenu texte.
  Offset get textTranslation {
    return Offset(
      textHorizontalOffset,
      textVerticalOffset,
    );
  }

  /// Taille du hintText.
  double get hintFontSize {
    return isVeryCompact
        ? 16.0
        : fontSize - 1.0;
  }

  // =========================================================================
  // COUNTRY SELECTOR
  // =========================================================================

  /// Décalage vertical du contenu du sélecteur de pays.
  ///
  /// Le chevron peut être légèrement différent du texte du téléphone.
  double get countrySelectorVerticalOffset {
    return isVeryCompact
        ? -0.5
        : -1.5;
  }

  /// Décalage horizontal du contenu du sélecteur.
  double get countrySelectorHorizontalOffset => 0.0;

  /// Translation du sélecteur de pays.
  Offset get countrySelectorTranslation {
    return Offset(
      countrySelectorHorizontalOffset,
      countrySelectorVerticalOffset,
    );
  }

  /// Décalage vertical spécifique du chevron.
  // double get chevronVerticalOffset {
  //   return isVeryCompact
  //       ? 0.0
  //       : -1.0;
  // }

  double get chevronVerticalOffset {
  return isVeryCompact
      ? 1.0
      : 2.0;
}

  /// Décalage horizontal spécifique du chevron.
  double get chevronHorizontalOffset => 0.0;

  /// Translation du chevron.
  Offset get chevronTranslation {
    return Offset(
      chevronHorizontalOffset,
      chevronVerticalOffset,
    );
  }

  // =========================================================================
  // HELPERS
  // =========================================================================

  /// Transform directement utilisable autour d'un widget.
  Widget translateTextVertically(
    Widget child,
  ) {
    return Transform.translate(
      offset: textTranslation,
      child: child,
    );
  }

  /// Translation générique du sélecteur de pays.
  Widget translateCountrySelector(
    Widget child,
  ) {
    return Transform.translate(
      offset: countrySelectorTranslation,
      child: child,
    );
  }

  /// Translation spécifique du chevron.
  Widget translateChevron(
    Widget child,
  ) {
    return Transform.translate(
      offset: chevronTranslation,
      child: child,
    );
  }
}