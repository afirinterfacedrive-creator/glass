import 'package:flutter/material.dart';

import 'package:universal_glass/glass.dart';

// ============================================================================
// HOME ACTION CARD
// ============================================================================
//
// Carte interactive du menu Quick Access.
//
// Responsabilités :
//
// - Hover desktop
// - Animation
// - Icône
// - Titre
// - Sous-titre
// - Flèche
// - Interaction utilisateur
//
// Aucune logique de navigation ici.
//
// ============================================================================

class HomeActionCard extends StatefulWidget {
  final GlassThemeState theme;

  final IconData icon;

  final String title;

  final String subtitle;

  final VoidCallback onTap;

  const HomeActionCard({
    super.key,
    required this.theme,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  State<HomeActionCard> createState() => _HomeActionCardState();
}

class _HomeActionCardState extends State<HomeActionCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final Color accent = widget.theme.useAquaStyle
        ? Colors.cyanAccent
        : Colors.orangeAccent;

    return MouseRegion(
      onEnter: (_) {
        if (!_hovered) {
          setState(() {
            _hovered = true;
          });
        }
      },
      onExit: (_) {
        if (_hovered) {
          setState(() {
            _hovered = false;
          });
        }
      },
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(20),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,

            width: 250,

            constraints: const BoxConstraints(minHeight: 108),

            transform: Matrix4.translationValues(0, _hovered ? -3 : 0, 0),

            padding: const EdgeInsets.all(17),

            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),

              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: widget.theme.useAquaStyle
                    ? [
                        Colors.white.withValues(alpha: _hovered ? .16 : .11),
                        accent.withValues(alpha: .035),
                      ]
                    : [
                        Colors.white.withValues(alpha: _hovered ? .12 : .075),
                        Colors.white.withValues(alpha: .025),
                      ],
              ),

              border: Border.all(
                color: _hovered
                    ? accent.withValues(alpha: .28)
                    : Colors.white.withValues(alpha: .11),
              ),

              boxShadow: [
                BoxShadow(
                  color: _hovered
                      ? accent.withValues(alpha: .10)
                      : Colors.black.withValues(alpha: .14),
                  blurRadius: _hovered ? 22 : 16,
                  offset: const Offset(0, 7),
                ),
              ],
            ),

            child: Row(
              children: [
                // ============================================================
                // ICÔNE
                // ============================================================
                AnimatedContainer(
                  duration: const Duration(milliseconds: 180),

                  width: 46,
                  height: 46,

                  decoration: BoxDecoration(
                    shape: BoxShape.circle,

                    color: accent.withValues(alpha: _hovered ? .15 : .08),

                    border: Border.all(
                      color: accent.withValues(alpha: _hovered ? .30 : .17),
                    ),
                  ),

                  child: Icon(widget.icon, size: 22, color: accent),
                ),

                const SizedBox(width: 13),

                // ============================================================
                // TEXTE
                // ============================================================
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 5),

                      Text(
                        widget.subtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 11,
                          height: 1.25,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 5),

                // ============================================================
                // FLÈCHE
                // ============================================================
                AnimatedContainer(
                  duration: const Duration(milliseconds: 180),

                  transform: Matrix4.translationValues(_hovered ? 3 : 0, 0, 0),

                  child: Icon(
                    Icons.chevron_right,
                    size: 20,
                    color: accent.withValues(alpha: _hovered ? .95 : .55),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
