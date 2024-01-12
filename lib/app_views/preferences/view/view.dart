import 'package:country_flags/country_flags.dart';
import 'package:esnap/app_views/launcher/launcher_cubit.dart';
import 'package:esnap/app_views/preferences/bloc/preferences_bloc.dart';
import 'package:esnap/app_views/report/report_view.dart';
import 'package:esnap/l10n/l10n.dart';
import 'package:esnap/utils/dimensions.dart';
import 'package:esnap/widgets/list_navigator.dart';
import 'package:esnap/widgets/page_constrainer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:preferences_api/preferences_api.dart';
import 'package:wid_design_system/wid_design_system.dart';

class PreferencesPage extends StatelessWidget {
  const PreferencesPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute(
      builder: (context) => const PreferencesPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(l10n.preferencesPageTitle),
      ),
      body: const PageConstrainer(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              spacerM,
              _LanguageController(),
              spacerXL,
              _ThemeController(),
              spacerXL,
              _RateThisAppLauncher(),
              spacerL,
              _SendFeedback(),
              spacerL,
              _UpdateApp(),
              spacerExpanded,
              _PrivacyLauncher(),
            ],
          ),
        ),
      ),
    );
  }
}

class _ThemeController extends StatelessWidget {
  const _ThemeController();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final labels = {
      ThemeType.light: l10n.light,
      ThemeType.dark: l10n.dark,
      ThemeType.system: l10n.system,
    };
    return BlocBuilder<PreferencesBloc, PreferencesState>(
      buildWhen: (previous, current) => previous.themeMode != current.themeMode,
      builder: (context, state) {
        return DropdownButtonFormField<ThemeType>(
          decoration: InputDecoration(label: Text(l10n.themeControllerLabel)),
          menuMaxHeight: AppDimenssions.menuMaxHeight,
          items: ThemeType.values
              .map(
                (e) => DropdownMenuItem<ThemeType>(
                  value: e,
                  child: Row(
                    children: [
                      Icon(_themeIcons[e]),
                      const SizedBox(width: 8),
                      Text(labels[e]!),
                    ],
                  ),
                ),
              )
              .toList(),
          onChanged: (themeType) {
            context.read<PreferencesBloc>().add(
                  PreferencesThemeChangeRequest(themeType!),
                );
          },
          value: ThemeType.values.firstWhere(
            (e) => e.name == state.themeMode.name,
            orElse: () => ThemeType.system,
          ),
        );
      },
    );
  }
}

class _LanguageController extends StatelessWidget {
  const _LanguageController();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final languages = {
      'en': l10n.english,
      'es': l10n.spanish,
    };
    return BlocBuilder<PreferencesBloc, PreferencesState>(
      buildWhen: (previous, current) => previous.language != current.language,
      builder: (context, state) {
        return DropdownButtonFormField<String>(
          decoration:
              InputDecoration(label: Text(l10n.languageControllerLabel)),
          menuMaxHeight: AppDimenssions.menuMaxHeight,
          items: ['en', 'es']
              .map(
                (e) => DropdownMenuItem<String>(
                  value: e,
                  child: Row(
                    children: [
                      CountryFlag.fromLanguageCode(e, width: 24, height: 24),
                      const SizedBox(width: 8),
                      Text(languages[e]!),
                    ],
                  ),
                ),
              )
              .toList(),
          onChanged: (themeType) {
            context.read<PreferencesBloc>().add(
                  PreferencesLanguageChangeRequest(themeType!),
                );
          },
          value: state.language,
        );
      },
    );
  }
}

class _RateThisAppLauncher extends StatelessWidget {
  const _RateThisAppLauncher();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ListNavigator(
      text: l10n.rateThisAppCTA,
      onPressed: context.read<LauncherCubit>().launchAppStore,
    );
  }
}

class _SendFeedback extends StatelessWidget {
  const _SendFeedback();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return TextButton(
      onPressed: () => showAdaptiveDialog<void>(
        context: context,
        builder: (_) => const ReportView(),
      ),
      child: Text(
        l10n.sendFeedbackCTA,
      ),
    );
  }
}

class _UpdateApp extends StatelessWidget {
  const _UpdateApp();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<PreferencesBloc, PreferencesState>(
      buildWhen: (previous, current) =>
          previous.isUpToDate != current.isUpToDate,
      builder: (context, state) {
        return Visibility(
          visible: !state.isUpToDate,
          child: ElevatedButton(
            onPressed: context.read<LauncherCubit>().launchAppStore,
            child: Text(l10n.updateAvailable),
          ),
        );
      },
    );
  }
}

class _PrivacyLauncher extends StatelessWidget {
  const _PrivacyLauncher();

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: context.read<LauncherCubit>().launchPrivacyPolicy,
      child: Text(
        context.l10n.privacyPolicyCTA,
      ),
    );
  }
}

const _themeIcons = {
  ThemeType.light: Icons.light_mode,
  ThemeType.dark: Icons.dark_mode,
  ThemeType.system: Icons.contrast,
};
