# Universal Glass

A reusable Flutter UI library for building modern glassmorphism interfaces with customizable themes, effects, surfaces, controls, dialogs, forms, and more.

[![pub package](https://img.shields.io/pub/v/universal_glass.svg)](https://pub.dev/packages/universal_glass)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

## Features

Universal Glass provides reusable glass-style components designed to help you build consistent and customizable Flutter interfaces.

- Glassmorphism surfaces and effects
- Customizable Aqua and Classic glass styles
- Light, Dark, Aqua, Classic, and System appearance modes
- Persistent appearance and theme settings
- Configurable blur, gradients, borders, shadows, glow, and hover effects
- Reusable glass buttons and controls
- Glass toggles and physical controls
- Universal app bar and tab components
- Reusable dialogs and modals
- Glass forms and input components
- Customizable input dimensions, padding, radius, and font size
- Toast and tooltip components
- Phone input with country and operator data
- Flutter and Riverpod integration
- Responsive glass UI components
- Customizable colors and appearance settings

## Installation

Add `universal_glass` to your `pubspec.yaml`:

```yaml
dependencies:
  universal_glass: ^2.1.2
```

Then run:

```bash
flutter pub get
```

## Import

Import the public package API:

```dart
import 'package:universal_glass/glass.dart';
```

The package is designed to expose its reusable functionality through the public `glass.dart` entry point.

## Basic Usage

A simple glass surface can be created using the package components:

```dart
import 'package:flutter/material.dart';
import 'package:universal_glass/glass.dart';

class GlassExample extends StatelessWidget {
  const GlassExample({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassSurface(
      child: const Padding(
        padding: EdgeInsets.all(24),
        child: Text(
          'Universal Glass',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
```

## Appearance

Universal Glass supports multiple appearance modes:

- `system`
- `aqua`
- `classic`
- `light`
- `dark`

Appearance settings can be customized and persisted independently for the supported modes.

The glass appearance can be configured through options such as:

- Blur
- Background opacity
- Gradient
- Gradient density
- Gradient opacity
- Border
- Border opacity and width
- Glow
- Hover effects
- Shadows
- Border radius
- Custom glass colors

## Glass Effects

The package provides reusable glass effects that can be applied to surfaces and components.

```dart
final effect = GlassEffects.aqua();
```

Additional predefined effects are available for different visual styles.

Explicit effect values can also be used to control individual visual properties when needed.

## Glass Components

Universal Glass includes reusable components for common application interfaces, including:

- App bars
- Buttons
- Tabs
- Surfaces
- Toggles
- Dialogs
- Modals
- Forms
- Inputs
- Toasts
- Tooltips
- Physical controls

Components are designed to work together so that applications can maintain a consistent glass visual language.

## Glass Inputs

Universal Glass provides reusable input styling that can be shared across text fields, phone inputs, forms, and other input components.

Input appearance can be customized through properties such as:

- Field height
- Horizontal padding
- Vertical padding
- Font size
- Border radius
- Blur
- Background opacity
- Border opacity and width
- Shadows
- Hover effects
- Enabled state
- Glass shape

Example:

```dart
const inputStyle = GlassInputStyle(
  fieldHeight: 55,
  horizontalPadding: 16,
  verticalPadding: 8,
  fontSize: 16,
  borderRadius: 14,
  blur: 8,
  backgroundOpacity: 0.62,
);
```

Compact and dense input presets are also available:

```dart
final compact = GlassInputStyle.compact();
final dense = GlassInputStyle.dense();
```

## Phone Input

Universal Glass also provides a reusable phone number input with country and operator support.

The phone input system supports:

- Country selection
- Country flags
- Country calling codes
- Operator prefixes
- Custom country data
- Custom operator data
- Persistent custom phone data

## Example Application

The repository includes an example application demonstrating the package components and appearance system.

The example showcases:

- Glass surfaces
- Buttons and controls
- Appearance settings
- Glass effects
- Dialogs and modals
- Forms and inputs
- Phone input
- Theme customization

## Requirements

Universal Glass is built for Flutter applications and uses Flutter's standard widget system.

Make sure your Flutter SDK satisfies the SDK constraints defined in `pubspec.yaml`.

## Documentation

API documentation is available on pub.dev:

https://pub.dev/packages/universal_glass

Source code and examples are available on GitHub:

https://github.com/afirinterfacedrive-creator/glass

## License

Universal Glass is released under the MIT License.

See the [LICENSE](LICENSE) file for the complete license text.

## Contributing

Contributions, bug reports, feature requests, and improvements are welcome.

Please open an issue or pull request on the GitHub repository.

---

Made with Flutter and Universal Glass.