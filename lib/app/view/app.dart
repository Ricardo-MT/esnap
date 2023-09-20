import 'package:esnap/app_views/home/view/home_view.dart';
import 'package:esnap/app_views/onboard/view/onboard.dart';
import 'package:esnap/app_views/preferences/bloc/preferences_bloc.dart';
import 'package:esnap/l10n/l10n.dart';
import 'package:esnap_repository/esnap_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:preferences_repository/preferences_repository.dart';
import 'package:wid_design_system/wid_design_system.dart';

class App extends StatelessWidget {
  const App({
    required this.preferencesRepository,
    required this.outfitRepository,
    required this.esnapRepository,
    required this.colorRepository,
    required this.classificationRepository,
    required this.classificationTypeRepository,
    required this.occasionRepository,
    super.key,
  });

  final PreferencesRepository preferencesRepository;
  final EsnapRepository esnapRepository;
  final OutfitRepository outfitRepository;
  final ColorRepository colorRepository;
  final ClassificationRepository classificationRepository;
  final ClassificationTypeRepository classificationTypeRepository;
  final OccasionRepository occasionRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<PreferencesRepository>(
          create: (context) => preferencesRepository,
        ),
        RepositoryProvider<EsnapRepository>(
          create: (context) => esnapRepository,
        ),
        RepositoryProvider<OutfitRepository>(
          create: (context) => outfitRepository,
        ),
        RepositoryProvider<ColorRepository>(
          create: (context) => colorRepository,
        ),
        RepositoryProvider<ClassificationRepository>(
          create: (context) => classificationRepository,
        ),
        RepositoryProvider<ClassificationTypeRepository>(
          create: (context) => classificationTypeRepository,
        ),
        RepositoryProvider<OccasionRepository>(
          create: (context) => occasionRepository,
        ),
      ],
      child: BlocProvider(
        create: (context) =>
            PreferencesBloc(preferencesRepository: preferencesRepository)
              ..add(const PreferencesCheckFirstLogin()),
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatefulWidget {
  const AppView({super.key});

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => _navigatorKey.currentState!;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: WidAppTheme.light,
      darkTheme: WidAppTheme.dark,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, child) =>
          BlocListener<PreferencesBloc, PreferencesState>(
        listenWhen: (previous, current) =>
            previous.isFirstLogin != current.isFirstLogin,
        listener: (context, state) async {
          if (state.isFirstLogin == true) {
            /// Cache images using the build context
            await Future.wait([
              precacheImage(
                const AssetImage('assets/img/section_1.png'),
                context,
              ),
              precacheImage(
                const AssetImage('assets/img/section_2.png'),
                context,
              ),
              precacheImage(
                const AssetImage('assets/img/section_3.png'),
                context,
              ),
            ]);
            await _navigator.pushReplacement(
              MaterialPageRoute<void>(
                builder: (context) => const OnboardPage(),
              ),
            );
          } else {
            await _navigator.pushReplacement(
              MaterialPageRoute<void>(
                builder: (context) => const HomePage(),
              ),
            );
          }
        },
        child: child,
      ),
      onGenerateRoute: (settings) => MaterialPageRoute(
        settings: settings,
        builder: (context) => const Scaffold(
          body: Center(
            child: CircularProgressIndicator.adaptive(),
          ),
        ),
      ),
    );
  }
}
