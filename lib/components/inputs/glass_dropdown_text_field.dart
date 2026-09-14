import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:universal_glass/components/inputs/fielddrop/glass_dropdown_overlay.dart';
import 'package:universal_glass/enums/glass_enums.dart';
import 'package:universal_glass/models/glass_input_style.dart';
import 'package:universal_glass/theme/glass_effects.dart';
import 'package:universal_glass/utils/glass_field_notch_wrapper.dart'; // <- IMPORTANT
import 'package:universal_glass/utils/glass_input_state_style.dart';
import 'package:universal_glass/utils/glass_input_utils.dart';
import 'package:universal_glass/utils/glass_layout_calibrator.dart';
import 'package:universal_glass/core/layout/glass_layout_context.dart';
import 'package:universal_glass/core/layout/glass_layout_scope.dart';

class GlassDropdownTextField<T> extends ConsumerStatefulWidget{
  final GlassInputStyle style;
  final double width;
  final String label;
  final String hintText;
  final List<T> items;
  final T? value;
  final String Function(T item) itemLabelExtractor;
  final void Function(T? value)? onChanged;
  final IconData? prefixIcon;
  final bool hasError;
  final bool hasSuccess;

  const GlassDropdownTextField({
    super.key,
    required this.style,
    this.width=double.infinity,
    this.label='Sélectionner',
    this.hintText='Choisissez une option...',
    required this.items,
    this.value,
    required this.itemLabelExtractor,
    this.onChanged,
    this.prefixIcon,
    this.hasError = false,
    this.hasSuccess = false,
  });

  @override
  ConsumerState<GlassDropdownTextField<T>> createState()=>_GlassDropdownTextFieldState<T>();
}

class _GlassDropdownTextFieldState<T> extends ConsumerState<GlassDropdownTextField<T>>{
  final LayerLink _layerLink=LayerLink();
  final OverlayPortalController _overlayController=OverlayPortalController();
  final FocusNode _focusNode=FocusNode();
  bool _isOpen=false;
  bool _isHovered=false;

  @override
  void initState(){
    super.initState();
    _focusNode.addListener(_onFocusChanged);
    _focusNode.onKeyEvent = _handleKeyEvent;
  }

  @override
  void dispose(){
    _focusNode.removeListener(_onFocusChanged);
    _focusNode.dispose();
    super.dispose();
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event){
    if (event.logicalKey == LogicalKeyboardKey.escape && _isOpen) {
      _closeDropdown();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  void _onFocusChanged(){if(!_focusNode.hasFocus&&_isOpen){_closeDropdown();}setState((){});}
  void _openDropdown(){if(_isOpen)return;setState((){_isOpen=true;});_focusNode.requestFocus();_overlayController.show();}
  void _closeDropdown(){if(!_isOpen)return;setState((){_isOpen=false;});_focusNode.unfocus();_overlayController.hide();}
  void _toggleDropdown(){if(!widget.style.enabled) return; _isOpen?_closeDropdown():_openDropdown();}
  void _handleSelection(T? value){widget.onChanged?.call(value);_closeDropdown();}

  @override
Widget build(BuildContext context){
  final GlassLayoutContext glass=GlassLayoutScope.of(context); // <- on a déjà glass
  final s = widget.style;
  final decoration = glass.inputDecoration(hasError: widget.hasError, isFocused: _isOpen);

  final stateStyle = GlassInputStateStyle.resolve(
    decoration: decoration,
    hasError: widget.hasError,
    hasSuccess: widget.hasSuccess,
    isFocused: _isOpen,
    isHovered: _isHovered,
    enabled: s.enabled,
  );

  final double baseFontSize=15.0;
  final GlassLayoutCalibrator calibrator=GlassLayoutCalibrator(
    fieldHeight: s.fieldHeight,
    fontSize: baseFontSize,
    hasPrefixIcon: widget.prefixIcon!=null,
  );

  final bool hasValue=widget.value!=null;
  final bool isFloating=_isOpen||hasValue;
  final String displayLabel=hasValue?widget.itemLabelExtractor(widget.value as T):'';
  final bubble = GlassInputUtils.bubbleSize(fieldHeight: s.fieldHeight);

  final baseEffects = GlassEffects.fromTheme(glass.palette);
  final effectiveEffects = baseEffects.copyWith(
    bgBlur: s.enableBlur? s.blur : 0,
    blur: s.enableBlur? s.blur : 0,
    bgNoise: 0,
    noise: 0,
    surfaceOpacity: stateStyle.backgroundOpacity,
    enableBorder: s.enableBorder,
    borderRadius: s.borderRadius,
    borderOpacity: s.borderOpacity,
    borderWidth: s.borderWidth,
    enableShadow: s.enableShadow && stateStyle.isActive,
    shadowOpacity: s.shadowOpacity,
    shadowBlur: s.shadowBlur,
    shadowOffsetY: s.shadowOffsetY,
  );

  final fieldContent = CompositedTransformTarget(
    link: _layerLink,
    child: OverlayPortal(
      controller: _overlayController,
      overlayChildBuilder: (context)=>TapRegion(onTapOutside: (_) => _closeDropdown(),child: GlassDropdownOverlay<T>(layerLink: _layerLink,width: widget.width,items: widget.items,itemLabelExtractor: widget.itemLabelExtractor,glass: glass,onSelected: _handleSelection,selectedValue: widget.value,enableSearch: widget.items.length > 5)),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        cursor: s.enabled? SystemMouseCursors.click : SystemMouseCursors.basic,
        child: SizedBox(
          width: widget.width,
          height: s.fieldHeight,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: s.horizontalPadding),
            child: Row(crossAxisAlignment: CrossAxisAlignment.center,children: [
              if(widget.prefixIcon!=null)...[
                context.buildInputIcon(icon: widget.prefixIcon!, isActive: stateStyle.isActive, enabled: s.enabled, fieldHeight: s.fieldHeight, color: stateStyle.iconColor, onTap: _toggleDropdown),
                SizedBox(width: bubble * 0.25)
              ],
              Expanded(child: GestureDetector(behavior: HitTestBehavior.opaque, onTap: _toggleDropdown, child: Padding(padding: EdgeInsets.symmetric(vertical: s.verticalPadding), child: Text(isFloating?(hasValue?displayLabel:widget.hintText):'', style: TextStyle(color: hasValue?stateStyle.textColor:stateStyle.hintColor, fontSize: baseFontSize, fontWeight: FontWeight.w400), maxLines: 1, overflow: TextOverflow.ellipsis)))),
              GestureDetector(behavior: HitTestBehavior.opaque, onTap: _toggleDropdown, child: AnimatedRotation(duration: const Duration(milliseconds: 200),turns: _isOpen? 0.5 : 0,child: Icon(Icons.keyboard_arrow_down_rounded,size: 22,color: stateStyle.iconColor))),
            ]),
          ),
        ),
      ),
    ),
  );

  return GlassFieldNotchWrapper(
    label: widget.label,
    isFloating: isFloating,
    inputStyle: stateStyle,
    enabled: s.enabled,
    fieldHeight: s.fieldHeight,
    fontSize: baseFontSize,
    borderRadius: BorderRadius.circular(s.borderRadius),
    decoration: decoration,
    geo: calibrator,
    style: glass.effectiveGlassStyle, // <- FIX ICI. vient du GlassLayoutContext
    effects: effectiveEffects,
    shape: GlassShapeType.squareRounded,
    width: widget.width,
    helperText: widget.hasError ? 'Champ requis' : null,
    child: fieldContent,
  );
}
}