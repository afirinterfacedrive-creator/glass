import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:universal_glass/controllers/glass_panel_controller.dart';

class GlassSection extends ConsumerWidget { 
  final String title; 
  final String? subtitle; 
  final List<Widget> children; 
  final EdgeInsetsGeometry? padding; 
  final bool showDivider; 
 
  const GlassSection({ 
    super.key, 
    required this.title, 
    this.subtitle, 
    required this.children, 
    this.padding, 
    this.showDivider = true, 
  }); 
 
  @override 
  Widget build(BuildContext context, WidgetRef ref) { 
    final panel = GlassPanelController(ref); 
    final screenWidth = MediaQuery.sizeOf(context).width;
    final bool isSmallMobile = screenWidth < 375;
 
    return Column( 
      crossAxisAlignment: CrossAxisAlignment.start, 
      children: [ 
        // Titre adaptatif
        Text( 
          title, 
          style: TextStyle( 
            color: panel.textPrimaryColor, 
            fontSize: isSmallMobile ? 16 : 18, 
            fontWeight: FontWeight.w700, 
            letterSpacing: 0.3, 
          ), 
        ), 
 
        // Sous-titre adaptatif
        if (subtitle != null) ...[ 
          const SizedBox(height: 4), 
          Text( 
            subtitle!, 
            style: TextStyle( 
              color: panel.textSecondaryColor, 
              fontSize: isSmallMobile ? 12 : 13, 
              fontWeight: FontWeight.w400, 
            ), 
          ), 
        ], 
 
        const SizedBox(height: 16), 
 
        // Contenu de la section posé "à plat", sans recréer de sous-cadre de fond
        Padding(
          padding: padding ?? EdgeInsets.zero,
          child: Column( 
            crossAxisAlignment: CrossAxisAlignment.stretch, 
            children: [ 
              for (int i = 0; i < children.length; i++) ...[ 
                children[i], 
                if (showDivider && i < children.length - 1) 
                  Padding( 
                    padding: EdgeInsets.symmetric(
                      vertical: isSmallMobile ? 10 : 14
                    ), 
                    child: Divider( 
                      height: 1, 
                      color: panel.borderColor.withValues(alpha: 0.15), 
                    ), 
                  ), 
              ] 
            ], 
          ),
        ), 
      ], 
    ); 
  } 
}
