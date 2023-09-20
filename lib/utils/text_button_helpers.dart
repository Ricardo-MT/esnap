import 'package:flutter/material.dart';

ButtonStyle removeSplashEffect(BuildContext context) => ButtonStyle(
      overlayColor: const MaterialStatePropertyAll<Color>(
        Colors.transparent,
      ),
      foregroundColor: MaterialStateProperty.resolveWith<Color?>((states) {
        if (states.contains(MaterialState.disabled)) {
          return Theme.of(context).disabledColor;
        }
        final mainColor = Theme.of(context).colorScheme.onBackground;
        if (states.contains(MaterialState.pressed)) {
          return mainColor.withOpacity(0.5);
        }
        return mainColor;
      }),
    );
