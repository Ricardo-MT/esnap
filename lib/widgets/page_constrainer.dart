import 'package:esnap/utils/dimensions.dart';
import 'package:flutter/material.dart';

class PageConstrainer extends StatelessWidget {
  const PageConstrainer({
    required this.child,
    super.key,
  });
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: AppDimenssions.maxPageWidth),
        child: child,
      ),
    );
  }
}
