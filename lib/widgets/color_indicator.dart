import 'package:flutter/material.dart';

class ColorIndicator extends StatelessWidget {
  const ColorIndicator({
    required this.hexColor,
    super.key,
  });

  final int hexColor;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Color(hexColor),
      ),
      child: const SizedBox(
        height: 10,
        width: 10,
      ),
    );
  }
}
