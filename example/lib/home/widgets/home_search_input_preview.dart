import 'package:flutter/material.dart';
import 'package:universal_glass/glass.dart';

/// ============================================================================
/// HOME SEARCH INPUT PREVIEW
/// ============================================================================

class HomeSearchInputPreview extends StatefulWidget {
  const HomeSearchInputPreview({super.key});

  @override
  State<HomeSearchInputPreview> createState() => _HomeSearchInputPreviewState();
}

class _HomeSearchInputPreviewState extends State<HomeSearchInputPreview> {
  // CONTROLE
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  // ETAT
  bool _showBubbleGlow = false;
  bool _enabled = true;
  bool _readOnly = false;
  bool _hasFocus = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode()..addListener(_handleFocusChanged);
  }

  void _handleFocusChanged() {
    if (!mounted) return;
    setState(() => _hasFocus = _focusNode.hasFocus);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChanged);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  // HARMONISATION AVEC PHONE INPUT
  bool get _isAqua => Theme.of(context).brightness == Brightness.dark; // remplace par glassThemeProvider si tu l'as
  Color get _focusColor => _isAqua ? Colors.cyanAccent : Colors.orangeAccent;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // TITRE
        const Text('SEARCH INPUT', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700, letterSpacing: 1.2)),
        const SizedBox(height: 6),
        Text('UniversalGlassSearchInput', style: TextStyle(color: Colors.white.withValues(alpha: 0.50), fontSize: 11)),
        const SizedBox(height: 16),

        // SEARCH INPUT AVEC GLOW PROJETE
        _buildSearchInputWithGlow(),

        const SizedBox(height: 18),

        // CONTROLES
        _buildControls(),
      ],
    );
  }

  Widget _buildSearchInputWithGlow() {
    // On calcule la taille du glow en fonction de la hauteur du champ
    final double fieldHeight = 58; 
    final double bubbleSize = fieldHeight * 0.6; // même ratio que dans le widget

    return Stack(
      alignment: Alignment.center,
      children: [
        // 1. LUMIERE PROJETEE DERRIERE LE BUBBLE
        if (_showBubbleGlow && _hasFocus && _enabled)
          Container(
            width: bubbleSize + 16, 
            height: bubbleSize + 16,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: _focusColor.withValues(alpha: 0.4), blurRadius: 20, spreadRadius: 2),
              ],
            ),
          ),
        
        // 2. L'INPUT NORMAL
        UniversalGlassSearchInput(
          controller: _controller,
          focusNode: _focusNode,
          enabled: _enabled,
          readOnly: _readOnly,
          showClearButton: true,
          bubbleFit: GlassInputBubbleFit.contain, // <- valeur fixe
          bubbleShape: GlassInputBubbleShape.circle, // <- valeur fixe
          showBubbleContentGlow: false, // on desactive pour utiliser le notre
          onChanged: (_) => setState(() {}),
        ),
      ],
    );
  }

  Widget _buildControls() {
    return Wrap(
      spacing: 8, runSpacing: 8,
      children: [
        _buildChoiceButton(_showBubbleGlow ? 'Glow ON' : 'Glow OFF', _showBubbleGlow, () => setState(() => _showBubbleGlow = !_showBubbleGlow)),
        _buildChoiceButton(_enabled ? 'Enabled' : 'Disabled', _enabled, () => setState(() => _enabled = !_enabled)),
        _buildChoiceButton(_readOnly ? 'ReadOnly' : 'Editable', _readOnly, () => setState(() => _readOnly = !_readOnly)),
      ],
    );
  }

  Widget _buildChoiceButton(String label, bool selected, VoidCallback onTap) {
    final Color borderColor = selected ? _focusColor.withValues(alpha: 0.4) : Colors.white.withValues(alpha: 0.08);
    
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: selected ? _focusColor.withValues(alpha: 0.14) : Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(9),
          border: Border.all(color: borderColor),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? _focusColor : Colors.white.withValues(alpha: 0.60),
            fontSize: 11,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}