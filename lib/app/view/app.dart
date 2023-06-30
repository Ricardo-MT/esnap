import 'package:esnap/app_views/home/view/home_view.dart';
import 'package:esnap/l10n/l10n.dart';
import 'package:esnap_repository/esnap_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wid_design_system/wid_design_system.dart';

class App extends StatelessWidget {
  const App({
    required this.esnapRepository,
    required this.colorRepository,
    required this.classificationRepository,
    required this.occasionRepository,
    super.key,
  });

  final EsnapRepository esnapRepository;
  final ColorRepository colorRepository;
  final ClassificationRepository classificationRepository;
  final OccasionRepository occasionRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<EsnapRepository>(
          create: (context) => esnapRepository,
        ),
        RepositoryProvider<ColorRepository>(
          create: (context) => colorRepository,
        ),
        RepositoryProvider<ClassificationRepository>(
          create: (context) => classificationRepository,
        ),
        RepositoryProvider<OccasionRepository>(
          create: (context) => occasionRepository,
        ),
      ],
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
      home: const HomePage(),
    );
  }
}
