import 'package:flutter/material.dart';
import 'package:universal_glass/components/surface/glass_surface_container.dart';
import 'package:universal_glass/enums/glass_enums.dart';

class GlassGradientAnimationDemo extends StatelessWidget {
  const GlassGradientAnimationDemo({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Démo Animation Glass'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 1. AQUA - Reflet cyan animé
            GlassSurfaceContainer(
              style: GlassStyle.transparentAqua, 
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              borderRadius: BorderRadius.circular(16),
              child: const Text(
                'Hover me - Aqua Frost',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 20),
            
            // 2. SAGE PRO - Glow rouge animé
            GlassSurfaceContainer(
              style: GlassStyle.sagePro, 
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              borderRadius: BorderRadius.circular(16),
              child: const Text(
                'Hover me - Sage Pro',
                style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            
            // 3. SAGE GLASS - Miroir rouge animé
            GlassSurfaceContainer(
              style: GlassStyle.sageGlass, 
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              borderRadius: BorderRadius.circular(16),
              child: const Text(
                'Hover me - Sage Glass',
                style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}