
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

export 'package:flutter_colorpicker/flutter_colorpicker.dart';
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
// GLASS EFFECTS
// ----------------------------------------------------------------------------

export 'theme/glass_effects.dart';



// ----------------------------------------------------------------------------
// GLASS BACKGROUND
// ----------------------------------------------------------------------------

export 'theme/glass_background.dart';

// ----------------------------------------------------------------------------
// GLASS SCAFFOLD
// ----------------------------------------------------------------------------

export 'theme/glass_scaffold.dart';

// ----------------------------------------------------------------------------
// COLOR STORAGE
// ----------------------------------------------------------------------------

export 'settings/widgets/glass_color_storage.dart';

// ============================================================================
// THEME / LAYOUT CONTEXT
// ============================================================================
//
// Source centrale des décisions visuelles dérivées du thème.
//
// Architecture:
//
//   GlassThemeState
//          ↓
//   GlassLayoutContext
//          ↓
//   Components
//
// Les composants doivent privilégier GlassLayoutContext plutôt que de
// recalculer eux-mêmes Aqua / Classic / accent / effets.
// ============================================================================


export 'utils/glass_theme_extension.dart';

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
// ICON GLASS BUBBLE
// ----------------------------------------------------------------------------

export 'components/icon_glass_bubble.dart';

// ============================================================================
// DIALOGS
// ============================================================================

export 'components/dialog/universal_glass_confirm_dialog.dart';
export 'components/dialog/universal_glass_modal.dart';

export 'components/modal/glass_modal.dart';


export 'components/modal/glass_modal_controller.dart';

export 'components/dialog/glass_dialog.dart';



// ============================================================================
// PAINTER / DECORATIONS
// ============================================================================

export 'components/glass_painter.dart';

export 'utils/glass_classic_sb_decoration.dart';
export 'utils/glass_palettes.dart';

// ============================================================================
// GLASS SURFACE
// ============================================================================
//
// API publique de la surface Glass.
//
// GlassSurfaceContainer est le point d'entrée principal.
//
// Les classes Renderer / Layers / Style restent internes tant qu'elles ne
// sont pas nécessaires aux utilisateurs du package.
// ============================================================================

export 'components/surface/glass_surface_container.dart';
export 'components/surface/glass_surface_config.dart';
export 'components/surface/glass_content_style.dart';

// ============================================================================
// CHIPS / PICKERS
// ============================================================================

// ----------------------------------------------------------------------------
// GLASS MODE CHIP
// ----------------------------------------------------------------------------

export 'components/chips/glass_mode_chip.dart';

// ----------------------------------------------------------------------------
// GLASS COLOR LIST PICKER
// ----------------------------------------------------------------------------

export 'components/picker/glass_color_list_picker.dart';

// ----------------------------------------------------------------------------
// GLASS SCROLL VIEW WITH ARROWS
// ----------------------------------------------------------------------------

export 'components/chips/glass_scroll_view_with_arrows.dart';

// ============================================================================
// PREVIEW / UTILS
// ============================================================================

export 'components/preview/glass_preview_switch.dart';
export 'components/preview/breaker_switch_preview.dart';
export 'components/preview/glass_section.dart';
export 'components/preview/glass_preview_label.dart';
export 'components/preview/glass_preview_toggle.dart';
export 'components/preview/glass_preview_breaker.dart';
// ============================================================================
// GLASS TEXT
// ============================================================================
//
// Widgets de texte utilisant automatiquement la palette Glass.
//
// - GlassText
// - GlassSubText
// - GlassSectionHeader
// ============================================================================

export 'settings/widgets/glass_text.dart';

// ============================================================================
// GLASS INPUTS
// ============================================================================

// ----------------------------------------------------------------------------
// INPUT DECORATION
// ----------------------------------------------------------------------------

export 'utils/glass_input_decoration.dart';

// ----------------------------------------------------------------------------
// INPUT STATE
// ----------------------------------------------------------------------------
//
// Résolution centralisée des états:
//
// ERROR > FOCUS > SUCCESS > HOVER > NORMAL > DISABLED
//
// Aucun composant ne doit recréer cette logique localement.
// ----------------------------------------------------------------------------

export 'utils/glass_input_state_style.dart';

// ----------------------------------------------------------------------------
// INPUT UTILS
// ----------------------------------------------------------------------------
//
// Helpers communs aux champs Glass:
// - icônes
// - bulles
// - séparateurs
// - couleurs d'état
// ----------------------------------------------------------------------------

export 'utils/glass_input_utils.dart';

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

// ----------------------------------------------------------------------------
// UNIVERSAL GLASS USERNAME INPUT
// ----------------------------------------------------------------------------

export 'components/inputs/universal_glass_username_input.dart';

// ----------------------------------------------------------------------------
// UNIVERSAL GLASS TEXT FIELD OUTLINED
// ----------------------------------------------------------------------------

export 'components/inputs/universal_glass_text_field_outlined.dart';


// ----------------------------------------------------------------------------
// GLASS INPUT ICON BUBBLE
// ----------------------------------------------------------------------------

export 'components/inputs/glass_input_icon_bubble.dart';

// ----------------------------------------------------------------------------
// GLASS DATE PICKER
// ----------------------------------------------------------------------------

export 'components/inputs/glass_date_picker_text_field.dart';

// ----------------------------------------------------------------------------
// GLASS DROPDOWN
// ----------------------------------------------------------------------------

export 'components/inputs/glass_dropdown_text_field.dart';

// ----------------------------------------------------------------------------
// GLASS SEARCH AUTOCOMPLETE
// ----------------------------------------------------------------------------

export 'components/inputs/glass_search_auto_complete_text_field.dart';

// ============================================================================
// PHONE
// ============================================================================

export 'components/inputs/phone/phone_input_controller.dart';

export 'phone/phone_country.dart';
export 'phone/phone_country_registry.dart';
export 'phone/phone_country_database.dart';
export 'phone/phone_flag.dart';
export 'phone/phone_flag_registry.dart';
export 'phone/phone_formatter.dart';

// ============================================================================
// LAYOUT / RESPONSIVE
// ============================================================================

// ----------------------------------------------------------------------------
// LAYOUT CALIBRATOR
// ----------------------------------------------------------------------------

export 'utils/glass_layout_calibrator.dart';

// ----------------------------------------------------------------------------
// RESPONSIVE GRID
// ----------------------------------------------------------------------------

export 'components/grids/glass_responsive_grid.dart';

// ============================================================================
// TEXT / FORMATTING UTILS
// ============================================================================

export 'utils/glass_text_formatter.dart';

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

// ----------------------------------------------------------------------------
// GLASS BREAKER SWITCH
// ----------------------------------------------------------------------------

export 'components/glass_breaker_switch.dart';

// ----------------------------------------------------------------------------
// PHYSICAL TOGGLES
// ----------------------------------------------------------------------------

export 'components/toggle/physical_toggles.dart';

// ----------------------------------------------------------------------------
// TOGGLE TYPES
// ----------------------------------------------------------------------------

export 'components/toggle/toggle_types.dart';

// ----------------------------------------------------------------------------
// TOGGLE FACTORY
// ----------------------------------------------------------------------------

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

// ----------------------------------------------------------------------------
// MECHANICAL TOGGLE
// ----------------------------------------------------------------------------

export 'components/toggle/mechanical_toggle_switch.dart';

// ============================================================================
// TOASTS
// ============================================================================

export 'components/toasts/universal_glass_toast.dart';

// ============================================================================
// CONTROLLERS
// ============================================================================

// ----------------------------------------------------------------------------
// GLASS ACTION CONTROLLER
// ----------------------------------------------------------------------------

export 'controllers/glass_action_controller.dart';

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

export 'components/dialog/glass_dialog_action.dart';


export'core/layout/glass_layout_extensions.dart';

export 'core/layout/glass_layout_context.dart';

export 'core/layout/glass_layout_scope.dart';

export 'theme/glass_display_settings.dart';

export 'theme/glass_scale_engine.dart';
 export 'provider/glass_theme_state.dart';

 export 'constants/app_constants.dart';

 export 'theme/glass_app_bar_settings.dart';

 export 'appearance/platform/appearance_platform.dart';

 export 'models/glass_input_style.dart';
// ============================================================================
// END OF PUBLIC API
// ============================================================================
