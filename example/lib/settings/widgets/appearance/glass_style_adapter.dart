import 'package:universal_glass/models/glass_input_style.dart';
import '../../../../../settings/widgets/appearance/models/appearance_input_settings.dart'; // <- CORRIGE ICI

extension AppearanceInputToGlassStyle on AppearanceInputSettings {
  GlassInputStyle toGlassStyle() => GlassInputStyle(
    fieldHeight: fieldHeight, // <- dynamique
    horizontalPadding: horizontalPadding,
    verticalPadding: verticalPadding,
    borderRadius: borderRadius,
    blur: blur,
    backgroundOpacity: backgroundOpacity,
    enableBorder: enableBorder,
    borderOpacity: borderOpacity,
    borderWidth: borderWidth,
    enabled: enabled,
  );
}