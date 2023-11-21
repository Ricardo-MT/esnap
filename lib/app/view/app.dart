import 'package:esnap/app_views/home/view/home_view.dart';
import 'package:esnap/app_views/launcher/launcher_cubit.dart';
import 'package:esnap/app_views/onboard/view/onboard.dart';
import 'package:esnap/app_views/preferences/bloc/preferences_bloc.dart';
import 'package:esnap/app_views/translations/translations_bloc.dart';
import 'package:esnap/l10n/l10n.dart';
import 'package:esnap/utils/classification_asset_pairer.dart';
import 'package:esnap/widgets/spinner.dart';
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
    required this.initialPreferencesState,
    super.key,
  });

  final PreferencesRepository preferencesRepository;
  final EsnapRepository esnapRepository;
  final OutfitRepository outfitRepository;
  final ColorRepository colorRepository;
  final ClassificationRepository classificationRepository;
  final ClassificationTypeRepository classificationTypeRepository;
  final OccasionRepository occasionRepository;
  final PreferencesState initialPreferencesState;

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
        RepositoryProvider(create: (context) => LauncherCubit()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => PreferencesBloc(
              preferencesRepository: preferencesRepository,
              initialPreferencesState: initialPreferencesState,
            )..add(const PreferencesInitialCheck()),
          ),
          BlocProvider(
            create: (context) => TranslationsBloc(
              classificationRepository: classificationRepository,
              colorRepository: colorRepository,
              occasionRepository: occasionRepository,
            )..add(const TranslationsLanguageChanged(languageCode: 'en')),
          ),
        ],
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
      themeMode: context.select((PreferencesBloc bloc) => bloc.state.themeMode),

      /// TODO: Make this fix in the wid_design_system package
      theme: WidAppTheme.light.copyWith(
        appBarTheme: WidAppTheme.light.appBarTheme.copyWith(
          backgroundColor: WidAppTheme.light.scaffoldBackgroundColor,
        ),
      ),
      darkTheme: WidAppTheme.dark.copyWith(
        appBarTheme: WidAppTheme.dark.appBarTheme.copyWith(
          backgroundColor: WidAppTheme.dark.scaffoldBackgroundColor,
        ),
      ),
      locale:
          context.select((PreferencesBloc bloc) => Locale(bloc.state.language)),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      builder: (context, child) => MultiBlocListener(
        listeners: [
          BlocListener<PreferencesBloc, PreferencesState>(
            listenWhen: (previous, current) =>
                previous.isFirstLogin != current.isFirstLogin,
            listener: (context, state) async {
              if (state.isFirstLogin == true) {
                /// Cache images using the build context
                await Future.wait([
                  precacheImage(
                    const AssetImage('assets/img/section_1.webp'),
                    context,
                  ),
                  precacheImage(
                    const AssetImage('assets/img/section_2.webp'),
                    context,
                  ),
                  precacheImage(
                    const AssetImage('assets/img/section_3.webp'),
                    context,
                  ),
                ]);
                await _navigator.pushReplacement(
                  OnboardPage.route(),
                );
              } else {
                await Future.wait(
                  getAllClassificationItemsAssets()
                      .map((e) => precacheImage(AssetImage(e), context))
                      .toList(),
                );
                await _navigator.pushReplacement(
                  HomePage.route(),
                );
              }
            },
          ),
          BlocListener<PreferencesBloc, PreferencesState>(
            listenWhen: (previous, current) =>
                previous.language != current.language,
            listener: (context, state) {
              context.read<TranslationsBloc>().add(
                    TranslationsLanguageChanged(languageCode: state.language),
                  );
            },
          ),
        ],
        child: Builder(
          builder: (context) {
            Widget error = const Text('...rendering error...');
            if (child is Scaffold || child is Navigator) {
              error = Scaffold(body: Center(child: error));
            }
            ErrorWidget.builder = (errorDetails) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    'Error: ${errorDetails.exceptionAsString()}',
                    errorDetails.stack.toString(),
                    errorDetails.stackFilter.toString(),
                    errorDetails.library.toString(),
                    errorDetails.exception.toString(),
                  ].map(Text.new).toList(),
                ),
              );
            };
            if (child != null) return child;
            throw 'child is null';
          },
        ),
      ),
      onGenerateRoute: (settings) => MaterialPageRoute(
        settings: settings,
        builder: (_) => const SpinnerPage(),
      ),
    );
  }
}
