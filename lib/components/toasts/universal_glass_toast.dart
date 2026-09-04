import 'package:flutter/material.dart';
import 'package:universal_glass/components/surface/glass_surface_container.dart';
import 'package:universal_glass/enums/glass_enums.dart';
import 'package:universal_glass/utils/glass_theme_extension.dart'; // <- importe ça

class UniversalGlassToast {
  static void show(
    BuildContext context, {
    required String message,
    String? title,
    GlassToastType type = GlassToastType.info,
    Duration duration = const Duration(seconds: 3),
  }) {
    final overlayState = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) {
        final glass = context.watchGlassContext; // <- MARCHE MAINTENANT

        final bool useAqua = glass.theme.useAquaStyle;
        
        IconData icon;
        Color statusColor;
        switch (type) {
          case GlassToastType.success:
            icon = Icons.check_circle_outline_rounded;
            statusColor = useAqua ? const Color(0xFF69F0AE) : const Color(0xFF00E676);
            break;
          case GlassToastType.error:
            icon = Icons.error_outline_rounded;
            statusColor = Colors.redAccent;
            break;
          case GlassToastType.warning:
            icon = Icons.warning_amber_rounded;
            statusColor = useAqua ? const Color(0xFFFFD740) : Colors.orangeAccent;
            break;
          case GlassToastType.info:
            icon = Icons.info_outline_rounded;
            statusColor = useAqua ? Colors.cyanAccent : Colors.orangeAccent;
            break;
        }

        return _GlassToastWidget(
          glass: glass,
          title: title,
          message: message,
          icon: icon,
          statusColor: statusColor,
          duration: duration,
          onDismiss: () => overlayEntry.remove(),
        );
      },
    );

    overlayState.insert(overlayEntry);
  }
}
class _GlassToastWidget extends StatefulWidget {
  final GlassLayoutContext glass;
  final String? title;
  final String message;
  final IconData icon;
  final Color statusColor;
  final Duration duration;
  final VoidCallback onDismiss;

  const _GlassToastWidget({
    required this.glass,
    this.title,
    required this.message,
    required this.icon,
    required this.statusColor,
    required this.duration,
    required this.onDismiss,
  });

  @override
  State<_GlassToastWidget> createState() => _GlassToastWidgetState();
}

class _GlassToastWidgetState extends State<_GlassToastWidget> with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(vsync: this, duration: const Duration(milliseconds: 250));
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _fadeController.forward();

    Future.delayed(widget.duration, () {
      if (mounted) {
        _fadeController.reverse().then((_) => widget.onDismiss());
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final glass = widget.glass;
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final bool isMobile = screenWidth < 600;

    return SafeArea(
      child: Align(
        alignment: Alignment.topCenter,
        child: FadeTransition(
          opacity: _opacityAnimation,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: isMobile ? 16.0 : 32.0, vertical: 20.0),
            child: Material(
              type: MaterialType.transparency,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: GlassSurfaceContainer(
                  style: glass.effectiveGlassStyle,
                  effects: glass.effects,
                  borderRadius: BorderRadius.circular(16),
                  padding: const EdgeInsets.all(14),
                  liftOnHover: false,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: widget.statusColor.withValues(alpha: 0.4),
                              blurRadius: 12,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Icon(widget.icon, color: widget.statusColor, size: 22),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (widget.title != null)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 2.0),
                                child: Text(
                                  widget.title!,
                                  style: TextStyle(
                                    color: glass.palette.textPrimary,
                                    fontSize: 13, 
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                            Text(
                              widget.message,
                              style: TextStyle(
                                color: glass.palette.textSecondary.withValues(alpha: 0.9),
                                fontSize: 12
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}