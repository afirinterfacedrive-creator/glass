import 'package:flutter/material.dart';

class GlassResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final double spacing;
  final double runSpacing;
  final int mobileColumns;
  final int tabletColumns;
  final int desktopColumns;
  final double tabletBreakpoint;
  final double desktopBreakpoint;
  final bool expandItems; // <- AJOUT: true pour inputs, false pour switchs

  const GlassResponsiveGrid({
    super.key,
    required this.children,
    this.spacing = 16.0,
    this.runSpacing = 16.0,
    this.mobileColumns = 1,
    this.tabletColumns = 2,
    this.desktopColumns = 3,
    this.tabletBreakpoint = 550.0,
    this.desktopBreakpoint = 850.0,
    this.expandItems = true, // <- defaut: etirer comme les inputs
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double maxWidth = constraints.maxWidth;

        int columns = mobileColumns;
        if (maxWidth >= desktopBreakpoint) {
          columns = desktopColumns;
        } else if (maxWidth >= tabletBreakpoint) {
          columns = tabletColumns;
        }

        final double safeWidth = (maxWidth.isFinite && maxWidth > 0) 
            ? maxWidth 
            : 500.0;

        double itemWidth = (safeWidth - (spacing * (columns - 1))) / columns;
        if (itemWidth <= 0) itemWidth = 10.0;

        return Wrap(
          spacing: spacing,
          runSpacing: runSpacing,
          alignment: WrapAlignment.start,
          crossAxisAlignment: WrapCrossAlignment.start,
          children: children.map((child) {
            if (expandItems) {
              // Mode Input: prend toute la largeur de la colonne
              return SizedBox(width: itemWidth, child: child);
            } else {
              // Mode Switch: prend seulement la largeur du contenu
              return IntrinsicWidth(child: child);
            }
          }).toList(),
        );
      },
    );
  }
}