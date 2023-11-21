import 'package:esnap/utils/text_button_helpers.dart';
import 'package:flutter/material.dart';
import 'package:wid_design_system/wid_design_system.dart';

class ListNavigator extends StatelessWidget {
  const ListNavigator({required this.text, required this.onPressed, super.key});
  final String text;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: removeSplashEffect(context).copyWith(
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
        ),
      ),
      child: Row(
        children: [
          Expanded(child: WidText.headlineMedium(text: text)),
          const Icon(Icons.arrow_forward_ios, size: 20),
        ],
      ),
    );
  }
}
