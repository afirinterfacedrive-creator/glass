import 'package:flutter/material.dart';

import '../theme/glass_color_palette.dart';


class GlassThemeScope extends InheritedWidget {

  final bool useAquaStyle;

  final GlassColorPalette palette;


  const GlassThemeScope({
    super.key,

    required this.useAquaStyle,

    required this.palette,

    required super.child,
  });



  static GlassThemeScope of(
    BuildContext context,
  ) {

    final GlassThemeScope? scope =
        context.dependOnInheritedWidgetOfExactType<
            GlassThemeScope>();


    assert(
      scope != null,
      'GlassThemeScope absent',
    );


    return scope!;
  }



  @override
  bool updateShouldNotify(
    GlassThemeScope oldWidget,
  ) {

    return oldWidget.useAquaStyle != useAquaStyle
        ||
        oldWidget.palette != palette;
  }
}