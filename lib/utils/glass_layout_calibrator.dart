
import 'package:flutter/material.dart';

class GlassLayoutCalibrator {
  final double fieldHeight;
  final double fontSize;
  final bool hasPrefixIcon;
  final double textScaleFactor;

  const GlassLayoutCalibrator({
    required this.fieldHeight,
    required this.fontSize,
    this.hasPrefixIcon = false,
    this.textScaleFactor = 1.0,
  });

  // ===========================================================================
  // MODE
  // ===========================================================================

  bool get isVeryCompact => fieldHeight <= 48.0;

  // ===========================================================================
  // ICON / BUBBLE
  // ===========================================================================

  double get iconSize {
    return isVeryCompact ? 26.0 : 36.0;
  }

  // ===========================================================================
  // NOTCH
  // ===========================================================================

  double get notchStart {
    return hasPrefixIcon
        ? iconSize + 20.0
        : 18.0;
  }

  double getLabelWidth(String label) {
    final double effectiveScale =
        textScaleFactor.clamp(0.5, 3.0);

    final TextPainter painter = TextPainter(
      text: TextSpan(
        text: label,
        style: TextStyle(
          fontSize: 10.5 * effectiveScale,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
        ),
      ),
      textDirection: TextDirection.ltr,
      maxLines: 1,
    )..layout();

    return painter.width + 16.0;
  }

  // ===========================================================================
  // LABEL
  // ===========================================================================

  double get labelTopAtRest {
    final double effectiveFontSize =
        fontSize * textScaleFactor.clamp(0.5, 3.0);

    if (isVeryCompact) {
      return (fieldHeight - 14.0) / 2.0 - 1.0 + 3.0;
    }

    return (fieldHeight - effectiveFontSize) / 2.0 - 1.5 + 3.0;
  }

  double getLabelLeft(bool isFloating) {
    if (isFloating) {
      return notchStart + 6.0;
    }

    return hasPrefixIcon
        ? iconSize + 28.0
        : 16.0;
  }

  // ===========================================================================
  // TEXT FIELD : CENTRAGE
  // ===========================================================================

  EdgeInsets get contentPadding {
    final double effectiveFontSize =
        fontSize * textScaleFactor.clamp(0.5, 3.0);

    final double textHeight =
        effectiveFontSize;

    final double vertical =
        (fieldHeight - textHeight) / 2.0;

    final double top =
        (vertical - 4.5).clamp(0.0, 40.0);

    final double bottom =
        (vertical - 4.1).clamp(0.0, 40.0);

    return EdgeInsets.only(
      left: 2.0,
      top: top,
      bottom: bottom,
    );
  }

  double get hintFontSize {
    final double effectiveFontSize =
        fontSize * textScaleFactor.clamp(0.5, 3.0);

    final double value = isVeryCompact
        ? effectiveFontSize - 2.0
        : effectiveFontSize - 1.0;

    return value.clamp(8.0, 100.0);
  }

  double get textVerticalOffset => 0.0;

  double get textHorizontalOffset => 0.0;

  Offset get textTranslation {
    return Offset(
      textHorizontalOffset,
      textVerticalOffset,
    );
  }

  // ===========================================================================
  // COUNTRY SELECTOR
  // ===========================================================================

  double get countrySelectorVerticalOffset {
    return isVeryCompact ? -0.5 : -1.5;
  }

  double get countrySelectorHorizontalOffset => 0.0;

  Offset get countrySelectorTranslation {
    return Offset(
      countrySelectorHorizontalOffset,
      countrySelectorVerticalOffset,
    );
  }

  // ===========================================================================
  // CHEVRON
  // ===========================================================================

  double get chevronVerticalOffset {
    return isVeryCompact ? 1.0 : 2.0;
  }

  double get chevronHorizontalOffset => 0.0;

  Offset get chevronTranslation {
    return Offset(
      chevronHorizontalOffset,
      chevronVerticalOffset,
    );
  }

  // ===========================================================================
  // HELPERS
  // ===========================================================================

  Widget translateTextVertically(Widget child) {
    if (textTranslation == Offset.zero) {
      return child;
    }

    return Transform.translate(
      offset: textTranslation,
      child: child,
    );
  }

  Widget translateCountrySelector(Widget child) {
    if (countrySelectorTranslation == Offset.zero) {
      return child;
    }

    return Transform.translate(
      offset: countrySelectorTranslation,
      child: child,
    );
  }

  Widget translateChevron(Widget child) {
    if (chevronTranslation == Offset.zero) {
      return child;
    }

    return Transform.translate(
      offset: chevronTranslation,
      child: child,
    );
  }
}
