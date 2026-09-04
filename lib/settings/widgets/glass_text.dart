import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:universal_glass/utils/glass_theme_extension.dart';

class GlassText extends ConsumerWidget {
  final String data;
  final double? fontSize;
  final FontWeight? fontWeight;
  final double? letterSpacing;
  final double? height; // <- AJOUTÉ
  final Color? color;
  final double alpha;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const GlassText(
    this.data, {
    super.key,
    this.fontSize,
    this.fontWeight,
    this.letterSpacing,
    this.height, // <- AJOUTÉ
    this.color,
    this.alpha = 1.0,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final glass = ref.watchGlassContext(context);
    final finalColor = color ?? glass.palette.textPrimary.withValues(alpha: alpha);
    
    return Text(
      data,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: TextStyle(
        color: finalColor,
        fontSize: fontSize,
        fontWeight: fontWeight,
        letterSpacing: letterSpacing,
        height: height ?? 1.3, // <- DEFAULT 1.3 SI NULL
      ),
    );
  }
}

class GlassSubText extends GlassText {
  const GlassSubText(
    super.data, {
    super.key,
    super.fontSize,
    super.alpha = 0.6,
    super.height, // <- FORWARD
    super.maxLines,
    super.overflow,
  });
}

class GlassSectionHeader extends ConsumerWidget {
  final String title;
  final String? subtitle;
  final IconData? icon;

  const GlassSectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final glass = ref.watchGlassContext(context);
    final bool isSage = glass.theme.glassStyle.name.contains('sage'); // <- DETECT SAGE
    
    // ACCENT DYNAMIQUE: Rouge KDTV pour Sage, sinon Aqua/Classic
    final Color accent = isSage 
        ? const Color(0xFFE91E63) 
        : glass.theme.useAquaStyle 
            ? Colors.cyanAccent 
            : Colors.orangeAccent;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: accent, size: 22),
              const SizedBox(width: 10),
            ],
            GlassText(
              title,
              fontSize: glass.isSmallMobile ? 16 : 18,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
              height: 1.2, // <- PLUS SERRÉ POUR TITRE
            ),
          ],
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 4),
          GlassSubText(
            subtitle!,
            fontSize: glass.isSmallMobile ? 11 : 13,
            height: 1.25, // <- MEILLEUR POUR 2 LIGNES
          ),
        ],
      ],
    );
  }
}