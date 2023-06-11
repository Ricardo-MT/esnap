import 'package:esnap/app_views/items_overview/view/view.dart';
import 'package:esnap/l10n/l10n.dart';
import 'package:esnap_repository/esnap_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wid_design_system/wid_design_system.dart';

class App extends StatelessWidget {
  const App({required this.esnapRepository, super.key});

  final EsnapRepository esnapRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: esnapRepository,
      child: const AppView(),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: WidAppTheme.light,
      darkTheme: WidAppTheme.dark,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const ItemsOverviewPage(),
    );
  }
}
