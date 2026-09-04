// ignore: dangling_library_doc_comments
/// UNIVERSAL GLASS COMPONENTS
/// ============================================================================
///
/// Barrel file centralisant les composants réutilisables.
///
/// Utilisation :
///
///   import 'package:universal_glass/components/components.dart';
///
/// Ce fichier ne contient aucune logique métier.
/// Il sert uniquement de point d'entrée public pour les composants.
///
/// ============================================================================

// ============================================================================
// DIALOGS
// ============================================================================

export 'dialogs/universal_glass_dialog.dart';
export 'dialogs/universal_glass_confirm_dialog.dart';
export 'dialogs/universal_glass_email_input.dart';
export 'dialogs/universal_glass_modal.dart';

// ============================================================================
// FORMS
// ============================================================================

export 'forms/glass_form.dart';
export 'forms/glass_form_actions.dart';
export 'forms/glass_form_section.dart';


// ============================================================================
// INPUTS
// ============================================================================

export 'inputs/glass_input_decoration.dart';
export 'inputs/glass_input_icon_bubble.dart';

export 'inputs/universal_glass_address_input.dart';
export 'inputs/universal_glass_name_input.dart';
export 'inputs/universal_glass_password_input.dart';
export 'inputs/universal_glass_phone_input.dart';
export 'inputs/universal_glass_search_input.dart';
export 'inputs/universal_glass_text_box.dart';
export 'inputs/universal_glass_text_field.dart';
export 'inputs/universal_glass_username_input.dart';

// ============================================================================
// GLASS BUTTONS
// ============================================================================

export 'glass_button.dart';
export 'universal_glass_button.dart';

// ============================================================================
// GLASS ICONS
// ============================================================================

export 'glass_icon.dart';
export 'icon_glass.dart';
export 'icon_glass_bubble.dart';
export 'icon_glass_button.dart';

// ============================================================================
// GLASS PAINTER
// ============================================================================

export 'glass_painter.dart';

// ============================================================================
// CARDS
// ============================================================================

export 'connectivity_card.dart';
export 'nike_card.dart';
export 'theme_glass_card.dart';
export 'theme_selector_card.dart';
export 'theme_selector_glass_card.dart';

// ============================================================================
// PANELS
// ============================================================================

export 'panel_header.dart';

// ============================================================================
// BREAKER SWITCH
// ============================================================================
//
// `BreakerSwitch` est défini dans :
//
//   components/glass_breaker_switch.dart
//
// Il ne fait plus partie de `toggle/physical_toggles.dart`.
//
// ============================================================================

export 'glass_breaker_switch.dart';

// ============================================================================
// TOGGLES PHYSIQUES
// ============================================================================
//
// `physical_toggles.dart` contient les toggles physiques suivants :
//
// - MetalToggleSwitch
// - RockerSwitch
// - RotarySwitch
// - PushButtonSwitch
// - GuardedSwitch
// - SliderSwitch
// - GlassToggleSwitch
//
// `BreakerSwitch` est volontairement séparé dans
// `glass_breaker_switch.dart`.
//
// `ToggleOrientation` et `PhysicalToggleType` sont définis dans
// `toggle_types.dart`.
//
// ============================================================================

export 'toggle/physical_toggles.dart';
export 'toggle/toggle_types.dart';

// ============================================================================
// TOGGLE FACTORY
// ============================================================================
//
// Factory / façade permettant de sélectionner automatiquement le toggle
// physique à partir de `PhysicalToggleType`.
//
// ============================================================================

export 'toggle/physical_toggle_factory.dart';

// ============================================================================
// GLASS TOGGLE COMPONENTS
// ============================================================================
//
// Éléments internes du GlassToggle également accessibles individuellement.
//
// ============================================================================

export 'toggle/glass_toggle.dart';
export 'toggle/glass_toggle_knob.dart';
export 'toggle/glass_toggle_track.dart';
export 'toggle/glass_highlight.dart';

// ============================================================================
// AUTRES TOGGLES
// ============================================================================

export 'toggle/mechanical_toggle_switch.dart';

// ============================================================================
// FIN
// ============================================================================

/// ============================================================================
/// END OF COMPONENTS BARREL
/// ============================================================================