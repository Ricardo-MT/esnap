import 'package:flutter/material.dart';
import 'package:wid_design_system/wid_design_system.dart';

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

ButtonStyle confirmButtonStyle(BuildContext context) {
  final mainColor = WidAppColors.primary;
  return removeSplashEffect(context).copyWith(
    foregroundColor: MaterialStateProperty.resolveWith<Color?>((states) {
      if (states.contains(MaterialState.disabled)) {
        return mainColor.withOpacity(0.5);
      }
      if (states.contains(MaterialState.pressed)) {
        return mainColor.withOpacity(0.5);
      }
      return mainColor;
    }),
  );
}

ButtonStyle cancelButtonStyle(BuildContext context) {
  final mainColor =
      Theme.of(context).textTheme.headlineLarge?.color ?? Colors.black;
  return removeSplashEffect(context).copyWith(
    foregroundColor: MaterialStateProperty.resolveWith<Color?>((states) {
      if (states.contains(MaterialState.disabled)) {
        return mainColor.withOpacity(0.5);
      }
      if (states.contains(MaterialState.pressed)) {
        return mainColor.withOpacity(0.5);
      }
      return mainColor;
    }),
  );
}
