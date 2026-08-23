import 'package:flutter/material.dart';

// ============================================================================
// UNIVERSAL TAB ITEM
// ============================================================================
//
// Élément générique de navigation utilisé par UniversalAppBar.
//
// ============================================================================

class UniversalTabItem {
  final String label;
  final String route;
  final IconData? icon;

  const UniversalTabItem({required this.label, required this.route, this.icon});
}
