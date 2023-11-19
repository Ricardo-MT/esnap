import 'package:flutter/material.dart';
import 'package:wid_design_system/wid_design_system.dart';

class SpinnerPage extends StatelessWidget {
  const SpinnerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator.adaptive(
          backgroundColor: WidAppColors.callToAction,
          valueColor: AlwaysStoppedAnimation(WidAppColors.n300),
        ),
      ),
    );
  }
}
