import 'package:flutter/material.dart';

ButtonStyle removeSplashEffect(BuildContext context) => ButtonStyle(
      overlayColor: const MaterialStatePropertyAll<Color>(
        Colors.transparent,
      ),
      foregroundColor: MaterialStateProperty.resolveWith<Color?>((states) {
        final mainColor =
            Theme.of(context).textTheme.headlineLarge?.color ?? Colors.black;
        if (states.contains(MaterialState.disabled)) {
          return mainColor.withOpacity(0.5);
        }
        if (states.contains(MaterialState.pressed)) {
          return mainColor.withOpacity(0.5);
        }
        return mainColor;
      }),
    );
