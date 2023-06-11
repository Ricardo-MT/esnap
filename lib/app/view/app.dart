import 'package:esnap/counter/counter.dart';
import 'package:esnap/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:wid_design_system/wid_design_system.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: WidAppTheme.light,
      darkTheme: WidAppTheme.dark,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const CounterPage(),
    );
  }
}
