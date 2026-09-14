// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:universal_glass/glass.dart';

class HomeUniversalGlassTextFieldView extends ConsumerStatefulWidget {
  const HomeUniversalGlassTextFieldView({super.key});

  @override
  ConsumerState<HomeUniversalGlassTextFieldView> createState() =>
      _HomeUniversalGlassTextFieldViewState();
}

class _HomeUniversalGlassTextFieldViewState
    extends ConsumerState<HomeUniversalGlassTextFieldView> {
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _textFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  bool _enabled = true;
  bool _readOnly = false;
  bool _useValidation = false;
  bool _useAutovalidation = false;

  final ValueNotifier<String> _lastChangedValue = ValueNotifier('');
  final ValueNotifier<String> _lastSubmittedValue = ValueNotifier('');

  @override
  void dispose() {
    _textController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _textFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _lastChangedValue.dispose();
    _lastSubmittedValue.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final GlassLayoutContext glass = GlassLayoutScope.of(context);

    return GlassSurfaceContainer(
      style: glass.effectiveGlassStyle,
      effects: glass.effects,
      borderRadius: BorderRadius.circular(glass.isSmallMobile ? 14 : 20),
      padding: glass.dynamicPadding,
      liftOnHover: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Universal Glass Text Field',
            style: TextStyle(
              color: Colors.white,
              fontSize: glass.isSmallMobile ? 16 : 18,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Style: ${glass.effectiveGlassStyle.name}, GlassLayoutContext',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.6),
              fontSize: glass.isSmallMobile ? 11 : 13,
            ),
          ),

          SizedBox(height: glass.isSmallMobile ? 16 : 24),

          GlassResponsiveGrid(
            spacing: 16,
            runSpacing: 16,
            mobileColumns: 1,
            tabletColumns: 2,
            desktopColumns: 3,
            children: [
              _buildGlassField(
                controller: _textController,
                focusNode: _textFocus,
                label: 'Nom',
                hintText: 'Entrez votre nom',
                prefixIcon: Icons.person_outline_rounded,
                suffixIcon: Icons.clear_rounded,
                onSuffixTap: () {
                  _textController.clear();
                  _lastChangedValue.value = '';
                },
                validator: _useValidation ? _validateName : null,
                glass: glass,
              ),
              _buildGlassField(
                controller: _emailController,
                focusNode: _emailFocus,
                label: 'Email',
                hintText: 'exemple@email.com',
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: _useValidation ? _validateEmail : null,
                glass: glass,
              ),
              _buildGlassField(
                controller: _passwordController,
                focusNode: _passwordFocus,
                label: 'Mot de passe',
                hintText: 'Votre mot de passe',
                prefixIcon: Icons.lock_outline_rounded,
                obscureText: true,
                textInputAction: TextInputAction.done,
                validator: _useValidation ? _validatePassword : null,
                glass: glass,
              ),
            ],
          ),

          SizedBox(height: glass.isSmallMobile ? 20 : 26),
          const GlassPreviewLabel('Options'),
          const SizedBox(height: 10),

          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              GlassPreviewSwitch(
                label: 'Enabled',
                value: _enabled,
                onChanged: (v) => setState(() => _enabled = v),
              ),
              GlassPreviewSwitch(
                label: 'Read only',
                value: _readOnly,
                onChanged: (v) => setState(() => _readOnly = v),
              ),
              GlassPreviewSwitch(
                label: 'Validation',
                value: _useValidation,
                onChanged: (v) => setState(() => _useValidation = v),
              ),
              GlassPreviewSwitch(
                label: 'Auto validation',
                value: _useAutovalidation,
                onChanged: (v) => setState(() => _useAutovalidation = v),
              ),
            ],
          ),

          const SizedBox(height: 20),
          const GlassPreviewLabel('État'),
          const SizedBox(height: 8),

          _buildStatusCard(glass: glass),
        ],
      ),
    );
  }

  Widget _buildGlassField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String label,
    required String hintText,
    IconData? prefixIcon,
    IconData? suffixIcon,
    VoidCallback? onSuffixTap,
    bool obscureText = false,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
    String? Function(String?)? validator,
    required GlassLayoutContext glass,
  }) {
    final bool useAqua = glass.theme.useAquaStyle;
    final Color focusColor = useAqua ? Colors.cyanAccent : Colors.orangeAccent;
    final double bgOpacity = glass.theme.effectiveBlur > 25 ? 0.12 : 0.18;

    // FIX: Plus de GlassContainer + AnimatedBuilder. Direct UniversalGlassTextField
    return UniversalGlassTextField(
      controller: controller,
      focusNode: focusNode,
      label: label,
      hintText: hintText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      onSuffixTap: onSuffixTap,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      enabled: _enabled,
      readOnly: _readOnly,
      validator: validator,
      autovalidateMode: _useAutovalidation
          ? AutovalidateMode.onUserInteraction
          : AutovalidateMode.disabled,
      onChanged: (value) => _lastChangedValue.value = value,
      onSubmitted: (value) => _lastSubmittedValue.value = value,
      decoration: GlassInputDecoration(
        color: useAqua
            ? focusColor.withValues(alpha: 0.06)
            : Colors.white.withValues(alpha: 0.04),
        backgroundOpacity: focusNode.hasFocus ? bgOpacity + 0.1 : bgOpacity,
        focusOpacity: bgOpacity + 0.14,
        borderColor: Colors.white.withValues(alpha: 0.12),
        focusBorderColor: focusColor,
        errorColor: Colors.redAccent,
        borderWidth: 1.2,
        focusBorderWidth: 1.8,
        borderRadius: glass.isSmallMobile ? 14 : 16,
        fontSize: 15,
        fontWeight: FontWeight.w600,
      ),
      style: glass.effectiveGlassStyle,
      shape: GlassShapeType.squareRounded,
      height: glass.isSmallMobile ? 52 : 58,
    );
  }

  Widget _buildStatusCard({required GlassLayoutContext glass}) {
    // FIX: Container simple
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ValueListenableBuilder<String>(
            valueListenable: _lastChangedValue,
            builder: (context, value, _) => Text(
              'onChanged : ${value.isEmpty ? '—' : value}',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(height: 6),
          ValueListenableBuilder<String>(
            valueListenable: _lastSubmittedValue,
            builder: (context, value, _) => Text(
              'onSubmitted : ${value.isEmpty ? '—' : value}',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) return 'Le nom est obligatoire';
    if (value.trim().length < 2) return 'Minimum 2 caractères';
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty)
      return 'L\'email est obligatoire';
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) return 'Adresse email invalide';
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty)
      return 'Le mot de passe est obligatoire';
    if (value.length < 6) return 'Minimum 6 caractères';
    return null;
  }
}
