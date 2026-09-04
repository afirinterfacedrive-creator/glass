import 'package:flutter/material.dart';

/// ============================================================================
/// GLASS FORM
///
/// Conteneur de formulaire Glass générique.
///
/// RESPONSABILITÉS
///
/// • centraliser la validation du formulaire
// ignore: unintended_html_in_doc_comment
/// • gérer le GlobalKey<FormState>
/// • gérer l'autovalidation
/// • permettre l'injection libre des champs
/// • gérer l'espacement vertical
/// • permettre le scroll
/// • gérer le padding
/// • gérer la largeur
/// • gérer la largeur maximale
/// • gérer la hauteur
/// • gérer la fermeture du clavier pendant le scroll
/// • gérer les callbacks de validation
///
/// IMPORTANT
///
/// Ce composant ne contient aucune logique métier.
///
/// Les champs restent entièrement indépendants.
///
/// Exemple :
///
/// GlassForm(
///   formKey: _formKey,
///
///   onValidSubmit: () {
///     // traitement
///   },
///
///   children: [
///     UniversalGlassNameInput(...),
///     UniversalGlassEmailInput(...),
///     UniversalGlassPasswordInput(...),
///   ],
/// )
/// ============================================================================

class GlassForm extends StatefulWidget {
  // ==========================================================================
  // CONTENU
  // ==========================================================================

  /// Champs et widgets contenus dans le formulaire.
  final List<Widget> children;

  // ==========================================================================
  // FORM KEY
  // ==========================================================================

  /// Permet au parent de contrôler directement le formulaire.
  ///
  /// Si aucune clé n'est fournie, GlassForm crée sa propre clé.
  final GlobalKey<FormState>? formKey;

  // ==========================================================================
  // VALIDATION
  // ==========================================================================

  /// Mode d'autovalidation Flutter.
  final AutovalidateMode autovalidateMode;

  /// Appelé uniquement lorsque le formulaire est valide.
  final VoidCallback? onValidSubmit;

  /// Appelé lorsque le formulaire est invalide.
  final VoidCallback? onInvalidSubmit;

  // ==========================================================================
  // ESPACEMENT
  // ==========================================================================

  /// Espace vertical entre les widgets.
  final double spacing;

  // ==========================================================================
  // PADDING
  // ==========================================================================

  /// Padding interne du formulaire.
  final EdgeInsetsGeometry padding;

  // ==========================================================================
  // SCROLL
  // ==========================================================================

  /// Active le défilement vertical.
  final bool scrollable;

  /// Contrôleur de scroll externe facultatif.
  final ScrollController? scrollController;

  /// Physique de scroll personnalisée.
  final ScrollPhysics? physics;

  /// Comportement de fermeture du clavier pendant le scroll.
  final ScrollViewKeyboardDismissBehavior
      keyboardDismissBehavior;

  // ==========================================================================
  // ALIGNEMENT
  // ==========================================================================

  /// Alignement horizontal des enfants.
  final CrossAxisAlignment crossAxisAlignment;

  // ==========================================================================
  // DIMENSIONS
  // ==========================================================================

  /// Largeur explicite facultative.
  final double? width;

  /// Hauteur explicite facultative.
  final double? height;

  /// Largeur maximale facultative.
  final double? maxWidth;

  // ==========================================================================
  // CONSTRUCTEUR
  // ==========================================================================

  const GlassForm({
    super.key,

    // CONTENU
    this.children = const <Widget>[],

    // FORM KEY
    this.formKey,

    // VALIDATION
    this.autovalidateMode =
        AutovalidateMode.disabled,

    this.onValidSubmit,

    this.onInvalidSubmit,

    // ESPACEMENT
    this.spacing = 12.0,

    // PADDING
    this.padding = EdgeInsets.zero,

    // SCROLL
    this.scrollable = false,

    this.scrollController,

    this.physics,

    this.keyboardDismissBehavior =
        ScrollViewKeyboardDismissBehavior.onDrag,

    // ALIGNEMENT
    this.crossAxisAlignment =
        CrossAxisAlignment.stretch,

    // DIMENSIONS
    this.width,

    this.height,

    this.maxWidth,
  });

  @override
  State<GlassForm> createState() =>
      GlassFormState();
}

// ============================================================================
// STATE
// ============================================================================
//
// IMPORTANT
//
// Cette classe reste PUBLIQUE.
//
// Cela permet notamment :
//
// final GlobalKey<GlassFormState> _formKey =
//     GlobalKey<GlassFormState>();
//
// puis :
//
// _formKey.currentState?.submit();
//
// ============================================================================

class GlassFormState extends State<GlassForm> {
  // ==========================================================================
  // FORM KEY INTERNE
  // ==========================================================================

  late final GlobalKey<FormState> _internalFormKey;

  GlobalKey<FormState> get _formKey =>
      widget.formKey ?? _internalFormKey;

  // ==========================================================================
  // INIT
  // ==========================================================================

  @override
  void initState() {
    super.initState();

    _internalFormKey =
        GlobalKey<FormState>();
  }

  // ==========================================================================
  // VALIDATE
  // ==========================================================================

  /// Valide le formulaire.
  ///
  /// Retourne `true` si tous les champs sont valides.
  bool validate() {
    return _formKey
            .currentState
            ?.validate() ??
        false;
  }

  // ==========================================================================
  // SAVE
  // ==========================================================================

  /// Sauvegarde tous les champs du formulaire.
  void save() {
    _formKey
        .currentState
        ?.save();
  }

  // ==========================================================================
  // RESET
  // ==========================================================================

  /// Réinitialise tous les champs du formulaire.
  void reset() {
    _formKey
        .currentState
        ?.reset();
  }

  // ==========================================================================
  // SUBMIT
  // ==========================================================================

  /// Valide puis sauvegarde le formulaire.
  ///
  /// Retourne `true` si le formulaire est valide.
  ///
  /// En cas de succès :
  ///
  /// 1. validation
  /// 2. sauvegarde
  /// 3. onValidSubmit
  ///
  /// En cas d'échec :
  ///
  /// 1. validation
  /// 2. onInvalidSubmit
  bool submit() {
    final FormState? state =
        _formKey.currentState;

    // ------------------------------------------------------------------------
    // FORMULAIRE NON DISPONIBLE
    // ------------------------------------------------------------------------

    if (state == null) {
      return false;
    }

    // ------------------------------------------------------------------------
    // VALIDATION
    // ------------------------------------------------------------------------

    final bool valid =
        state.validate();

    // ------------------------------------------------------------------------
    // INVALIDE
    // ------------------------------------------------------------------------

    if (!valid) {
      widget.onInvalidSubmit?.call();

      return false;
    }

    // ------------------------------------------------------------------------
    // SAUVEGARDE
    // ------------------------------------------------------------------------

    state.save();

    // ------------------------------------------------------------------------
    // CALLBACK VALIDE
    // ------------------------------------------------------------------------

    widget.onValidSubmit?.call();

    return true;
  }

  // ==========================================================================
  // VALIDATE + SUBMIT
  // ==========================================================================

  /// Alias explicite de [submit].
  ///
  /// Utile lorsque le nom `validateAndSubmit`
  /// est plus lisible dans le code appelant.
  bool validateAndSubmit() {
    return submit();
  }

  // ==========================================================================
  // BUILD CHILDREN
  // ==========================================================================

  List<Widget> _buildChildren() {
    if (widget.children.isEmpty) {
      return const <Widget>[];
    }

    final List<Widget> result =
        <Widget>[];

    for (
      int i = 0;
      i < widget.children.length;
      i++
    ) {
      result.add(
        widget.children[i],
      );

      if (
        i <
        widget.children.length - 1
      ) {
        result.add(
          SizedBox(
            height:
                widget.spacing,
          ),
        );
      }
    }

    return result;
  }

  // ==========================================================================
  // CONTENT
  // ==========================================================================

  Widget _buildContent() {
    final Widget column =
        Column(
      mainAxisSize:
          MainAxisSize.min,

      crossAxisAlignment:
          widget.crossAxisAlignment,

      children:
          _buildChildren(),
    );

    // ------------------------------------------------------------------------
    // SANS SCROLL
    // ------------------------------------------------------------------------

    if (!widget.scrollable) {
      return column;
    }

    // ------------------------------------------------------------------------
    // AVEC SCROLL
    // ------------------------------------------------------------------------

    return SingleChildScrollView(
      controller:
          widget.scrollController,

      physics:
          widget.physics,

      keyboardDismissBehavior:
          widget.keyboardDismissBehavior,

      child:
          column,
    );
  }

  // ==========================================================================
  // BUILD
  // ==========================================================================

  @override
  Widget build(
    BuildContext context,
  ) {
    // =========================================================================
    // FORM
    // =========================================================================

    Widget content =
        Form(
      key:
          _formKey,

      autovalidateMode:
          widget.autovalidateMode,

      child:
          _buildContent(),
    );

    // =========================================================================
    // PADDING
    // =========================================================================

    content =
        Padding(
      padding:
          widget.padding,

      child:
          content,
    );

    // =========================================================================
    // DIMENSIONS
    // =========================================================================

    if (
      widget.width != null ||
      widget.height != null ||
      widget.maxWidth != null
    ) {
      content =
          SizedBox(
        width:
            widget.width,

        height:
            widget.height,

        child:
            ConstrainedBox(
          constraints:
              BoxConstraints(
            maxWidth:
                widget.maxWidth ??
                double.infinity,
          ),

          child:
              content,
        ),
      );
    }

    return content;
  }
}