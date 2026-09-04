import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:universal_glass/components/inputs/fieldoutlined/outlined_field_decoration.dart';
import 'package:universal_glass/components/surface/glass_surface_container.dart';
import 'package:universal_glass/enums/glass_enums.dart';
import 'package:universal_glass/utils/glass_layout_calibrator.dart';
import 'package:universal_glass/utils/glass_theme_extension.dart';
import '../../utils/glass_input_utils.dart';

class GlassDatePickerTextField extends ConsumerStatefulWidget {
  final double fieldHeight;
  final double width;
  final String label;
  final String hintText;
  final DateTime? selectedDate;
  final void Function(DateTime date)? onDateSelected;

  const GlassDatePickerTextField({
    super.key,
    this.fieldHeight = 55.0,
    this.width = double.infinity,
    this.label = 'Date',
    this.hintText = 'Sélectionner une date...',
    this.selectedDate,
    this.onDateSelected,
  });

  @override
  ConsumerState<GlassDatePickerTextField> createState() => _GlassDatePickerTextFieldState();
}

class _GlassDatePickerTextFieldState extends ConsumerState<GlassDatePickerTextField> {
  bool _isPickerActive = false;

  Future<void> _openDatePicker(dynamic glass, Color focusColor) async {
    setState(() => _isPickerActive = true);
    
    // FIX : Utilisation du showDatePicker natif habillé aux couleurs de ton package
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: widget.selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: focusColor, // Couleur de l'en-tête et du jour sélectionné (cyan ou orange)
              surface: glass.palette.darkForStyle(glass.theme.useAquaStyle), // Fond sombre du calendrier
              onSurface: glass.palette.textPrimary, // Couleur des numéros de jours
            ),
            // ignore: deprecated_member_use
            dialogBackgroundColor: glass.palette.darkForStyle(glass.theme.useAquaStyle),
          ),
          child: child!,
        );
      },
    );

    setState(() => _isPickerActive = false);
    if (picked != null && widget.onDateSelected != null) {
      widget.onDateSelected!(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final glass = ref.watchGlassContext(context);
    final bool useAqua = glass.theme.useAquaStyle;
    final Color focusColor = useAqua ? Colors.cyanAccent : Colors.orangeAccent;
    const double baseFontSize = 15.0;

    final calibrator = GlassLayoutCalibrator(
      fieldHeight: widget.fieldHeight,
      fontSize: baseFontSize,
      hasPrefixIcon: true,
    );

    final bool hasValue = widget.selectedDate != null;
    final bool isFloating = _isPickerActive || hasValue;

    // Formate la date au format local lisible (ex: 02/09/2026)
    final String formattedDate = hasValue 
        ? "${widget.selectedDate!.day.toString().padLeft(2, '0')}/${widget.selectedDate!.month.toString().padLeft(2, '0')}/${widget.selectedDate!.year}"
        : '';

    return GestureDetector(
      onTap: () => _openDatePicker(glass, focusColor),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: SizedBox(
          width: widget.width,
          height: widget.fieldHeight,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              ClipPath(
                clipper: isFloating ? NotchClipper(notchStart: calibrator.notchStart, notchWidth: calibrator.getLabelWidth(widget.label)) : null,
                child: GlassSurfaceContainer(
                  isFocused: _isPickerActive,
                  height: widget.fieldHeight,
                  style: glass.effectiveGlassStyle,
                  shape: GlassShapeType.squareRounded,
                  effects: glass.effects,
                  enabled: true,
                  decoration: glass.inputDecoration(hasError: false, isFocused: _isPickerActive),
                  borderRadius: BorderRadius.circular(glass.isSmallMobile ? 12 : 16),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  clipBehavior: Clip.none,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      context.buildInputIcon(
                        icon: Icons.calendar_month_outlined,
                        isActive: _isPickerActive,
                        enabled: true,
                        onTap: () => _openDatePicker(glass, focusColor),
                        fieldHeight: widget.fieldHeight,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Padding(
                          padding: calibrator.contentPadding,
                          child: Text(
                            isFloating ? (hasValue ? formattedDate : widget.hintText) : '',
                            style: TextStyle(
                              color: hasValue ? glass.palette.textPrimary : glass.palette.textSecondary.withValues(alpha: 0.5),
                              fontSize: baseFontSize,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              AnimatedPositioned(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeInOutQuad,
                top: isFloating ? -8.5 : calibrator.labelTopAtRest,
                left: calibrator.getLabelLeft(isFloating),
                child: IgnorePointer(
                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 180),
                    style: TextStyle(
                      color: _isPickerActive ? focusColor : Colors.white.withValues(alpha: isFloating ? 0.6 : 0.4),
                      fontSize: isFloating ? 10.5 : (calibrator.isVeryCompact ? 14 : baseFontSize),
                      fontWeight: isFloating ? FontWeight.w700 : FontWeight.w500,
                      letterSpacing: 0.2,
                      backgroundColor: Colors.transparent,
                    ),
                    child: Text(widget.label),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
