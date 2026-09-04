// ============================================================================
// GLASS
// ============================================================================
//
// Public API of the Universal Glass Flutter package.
//
// This file is the single public entry point of the package.
//
// External applications should use only:
//
//   import 'package:universal_glass/glass.dart';
//
// Do NOT import internal Glass files directly from an application.
//
// ============================================================================

// ============================================================================
// CORE
// ============================================================================

// ----------------------------------------------------------------------------
// APP BAR
// ----------------------------------------------------------------------------
export 'core/app_bar/universal_app_bar.dart';
export 'core/app_bar/universal_tab_item.dart';

// ============================================================================
// ENUMS
// ============================================================================
export 'enums/glass_enums.dart';

// ============================================================================
// PROVIDERS
// ============================================================================

// ----------------------------------------------------------------------------
// SHARED PREFERENCES
// ----------------------------------------------------------------------------
export 'providers/shared_preferences_provider.dart';
export 'package:flutter_colorpicker/flutter_colorpicker.dart';

// ----------------------------------------------------------------------------
// THEME PROVIDER
// ----------------------------------------------------------------------------
export 'providers/theme_provider.dart';

// ----------------------------------------------------------------------------
// GLASS BUTTON PROVIDER
// ----------------------------------------------------------------------------
export 'provider/glass_button_provider.dart';

// ----------------------------------------------------------------------------
// GLASS THEME PROVIDER
// ----------------------------------------------------------------------------
export 'provider/glass_theme_provider.dart';

// ----------------------------------------------------------------------------
// GLASS COLOR PROVIDER
// ----------------------------------------------------------------------------
export 'provider/glass_color_provider.dart';
export 'provider/glass_color_notifier.dart';
export 'provider/glass_color_provider_provider.dart';


// ============================================================================
// THEME
// ============================================================================

// ----------------------------------------------------------------------------
// GLASS COLOR PALETTE
// ----------------------------------------------------------------------------
export 'theme/glass_color_palette.dart';

// ----------------------------------------------------------------------------
// EFFECTS
// ----------------------------------------------------------------------------
export 'theme/glass_effects.dart';

// ----------------------------------------------------------------------------
// BACKGROUND
// ----------------------------------------------------------------------------
export 'theme/glass_background.dart';

// ----------------------------------------------------------------------------
// SCAFFOLD
// ----------------------------------------------------------------------------
export 'theme/glass_scaffold.dart';
export 'settings/widgets/glass_color_storage.dart';

// ============================================================================
// COMPONENTS
// ============================================================================

// ----------------------------------------------------------------------------
// GLASS BUTTON
// ----------------------------------------------------------------------------
export 'components/glass_button.dart';

// ----------------------------------------------------------------------------
// UNIVERSAL GLASS BUTTON
// ----------------------------------------------------------------------------
export 'components/universal_glass_button.dart';

// ----------------------------------------------------------------------------
// GLASS ICON
// ----------------------------------------------------------------------------
export 'components/glass_icon.dart';
export 'components/glass_action_icon.dart';

// ----------------------------------------------------------------------------
// GLASS CONTAINER
// ----------------------------------------------------------------------------
export 'components/glass_container.dart';

// ----------------------------------------------------------------------------
// DIALOGS
// ----------------------------------------------------------------------------
export 'components/dialogs/universal_glass_confirm_dialog.dart';
export 'components/dialogs/universal_glass_modal.dart';

// ----------------------------------------------------------------------------
// GLASS PAINTER
// ----------------------------------------------------------------------------

export 'components/glass_painter.dart';
export 'utils/glass_classic_sb_decoration.dart';
export 'utils/glass_theme_extension.dart';
export 'utils/glass_palettes.dart';

// ----------------------------------------------------------------------------
// ICON GLASS BUBBLE
// ----------------------------------------------------------------------------
export 'components/icon_glass_bubble.dart';

// ----------------------------------------------------------------------------
// GLASS SURFACE CONTAINER
// ----------------------------------------------------------------------------
export 'components/surface/glass_surface_container.dart';

// ============================================================================
// CHIPS / PICKERS
// ============================================================================
//
// Composants réutilisables pour les sélections de mode et de couleur.
//
// ----------------------------------------------------------------------------
// GLASS MODE CHIP
// ----------------------------------------------------------------------------
export 'components/chips/glass_mode_chip.dart';

// ----------------------------------------------------------------------------
// GLASS COLOR LIST PICKER
// ----------------------------------------------------------------------------
export 'components/picker/glass_color_list_picker.dart';

// ============================================================================
// PREVIEW / UTILS
// ============================================================================
//
// Composants utilitaires pour les previews et la doc
//
// - PreviewLabel
// - GlassSwitch
// - GlassSection
//
// ============================================================================
export 'components/preview/glass_preview_switch.dart';
export 'components/preview/breaker_switch_preview.dart';
export 'components/preview/glass_section.dart';
export 'components/preview/glass_preview_label.dart';
export 'components/preview/glass_preview_toggle.dart';

//E:\Flutter\universal_glass\lib\utils\glass_layout_calibrator.dart
export 'utils/glass_layout_calibrator.dart';
export 'utils/glass_text_formatter.dart';

// ============================================================================
// GLASS INPUTS
// ============================================================================

// ----------------------------------------------------------------------------
// GLASS INPUT DECORATION
// ----------------------------------------------------------------------------
export 'components/inputs/glass_input_decoration.dart';

// ----------------------------------------------------------------------------
// UNIVERSAL GLASS TEXT FIELD
// ----------------------------------------------------------------------------
export 'components/inputs/universal_glass_text_field.dart';

// ----------------------------------------------------------------------------
// UNIVERSAL GLASS PHONE INPUT
// ----------------------------------------------------------------------------
export 'components/inputs/universal_glass_phone_input.dart';

// ----------------------------------------------------------------------------
// UNIVERSAL GLASS TEXT BOX
// ----------------------------------------------------------------------------
export 'components/inputs/universal_glass_text_box.dart';

// ----------------------------------------------------------------------------
// UNIVERSAL GLASS PASSWORD INPUT
// ----------------------------------------------------------------------------
export 'components/inputs/universal_glass_password_input.dart';

// ----------------------------------------------------------------------------
// UNIVERSAL GLASS ADDRESS INPUT
// ----------------------------------------------------------------------------
export 'components/inputs/universal_glass_address_input.dart';

// ----------------------------------------------------------------------------
// UNIVERSAL GLASS SEARCH INPUT
// ----------------------------------------------------------------------------
export 'components/inputs/universal_glass_search_input.dart';

// ----------------------------------------------------------------------------
// UNIVERSAL GLASS NAME INPUT
// ----------------------------------------------------------------------------
export 'components/inputs/universal_glass_name_input.dart';
export 'components/inputs/universal_glass_text_field_outlined.dart';

// ----------------------------------------------------------------------------
// UNIVERSAL GLASS USERNAME INPUT
// ----------------------------------------------------------------------------
export 'components/inputs/universal_glass_username_input.dart';


export 'components/inputs/glass_date_picker_text_field.dart';

export 'components/inputs/glass_dropdown_text_field.dart';

export 'components/inputs/glass_search_auto_complete_text_field.dart';
// ----------------------------------------------------------------------------
// GLASS INPUT ICON BUBBLE
// ----------------------------------------------------------------------------
export 'components/inputs/glass_input_icon_bubble.dart';

// ----------------------------------------------------------------------------
// UNIVERSAL GLASS TEXT FIELD PLAIN
// ----------------------------------------------------------------------------
export 'components/inputs/universal_glass_text_field_plain.dart';




//E:\Flutter\universal_glass\lib\components\inputs\glass_search_auto_complete_text_field.dart
export 'settings/widgets/glass_text.dart';

// ============================================================================
// CARDS / PANELS
// ============================================================================

// ----------------------------------------------------------------------------
// PANEL HEADER
// ----------------------------------------------------------------------------
export 'components/panel_header.dart';

// ----------------------------------------------------------------------------
// THEME GLASS CARD
// ----------------------------------------------------------------------------
export 'components/theme_glass_card.dart';

// ============================================================================
// PHYSICAL CONTROLS
// ============================================================================
export 'components/glass_breaker_switch.dart';

// ============================================================================
// PHYSICAL TOGGLES
// ============================================================================
export 'components/toggle/physical_toggles.dart';

// ============================================================================
// TOGGLE TYPES
// ============================================================================
export 'components/toggle/toggle_types.dart';

// ============================================================================
// TOGGLE FACTORY
// ============================================================================
export 'components/toggle/physical_toggle_factory.dart';

// ============================================================================
// GLASS TOGGLE
// ============================================================================

// ----------------------------------------------------------------------------
// MAIN TOGGLE
// ----------------------------------------------------------------------------
export 'components/toggle/glass_toggle.dart';

// ----------------------------------------------------------------------------
// TOGGLE KNOB
// ----------------------------------------------------------------------------
export 'components/toggle/glass_toggle_knob.dart';

// ----------------------------------------------------------------------------
// TOGGLE TRACK
// ----------------------------------------------------------------------------
export 'components/toggle/glass_toggle_track.dart';

// ----------------------------------------------------------------------------
// TOGGLE HIGHLIGHT
// ----------------------------------------------------------------------------
export 'components/toggle/glass_highlight.dart';

// ============================================================================
// OTHER TOGGLES
// ============================================================================
export 'components/toggle/mechanical_toggle_switch.dart';
export 'components/grids/glass_responsive_grid.dart';

//E:\Flutter\universal_glass\lib\components\toasts\universal_glass_toast.dart
export 'components/toasts/universal_glass_toast.dart';

// ============================================================================
// CONTROLLERS
// ============================================================================

// ----------------------------------------------------------------------------
// GLASS ACTION CONTROLLER
// ----------------------------------------------------------------------------
export 'controllers/glass_action_controller.dart';

// ============================================================================
// PHONE
// ============================================================================
export 'phone/phone_country.dart';
export 'phone/phone_country_registry.dart';
export 'phone/phone_country_database.dart';
export 'phone/phone_flag.dart';
export 'phone/phone_flag_registry.dart';
export 'phone/phone_formatter.dart';

// ============================================================================
// GLASS FORM
// ============================================================================

// ----------------------------------------------------------------------------
// MAIN FORM
// ----------------------------------------------------------------------------
export 'components/forms/glass_form.dart';

// ----------------------------------------------------------------------------
// FORM ACTIONS
// ----------------------------------------------------------------------------
export 'components/forms/glass_form_actions.dart';

// ----------------------------------------------------------------------------
// FORM SECTION
// ----------------------------------------------------------------------------
export 'components/forms/glass_form_section.dart';

// ============================================================================
// END OF PUBLIC API
// ============================================================================