import 'package:flutter/material.dart';

class ToggleTestBox extends StatelessWidget {
  final String title;
  final Widget child;

  final double height;

  const ToggleTestBox({
    super.key,

    required this.title,
    required this.child,

    this.height = 90,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,

      children: [
        SizedBox(
          height: height,

          child: Center(child: child),
        ),

        const SizedBox(height: 8),

        Text(
          title,

          style: const TextStyle(
            color: Colors.white54,
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }
}
