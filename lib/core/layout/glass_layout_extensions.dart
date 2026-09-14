import 'package:flutter/material.dart';

import 'glass_layout_context.dart';
import 'glass_layout_scope.dart';

extension GlassLayoutExtension on BuildContext {
  GlassLayoutContext get glassLayout {
    return GlassLayoutScope.of(this);
  }

  GlassLayoutContext? get maybeGlassLayout {
    return GlassLayoutScope.maybeOf(this);
  }
}