import 'package:esnap/app_views/preferences/bloc/preferences_bloc.dart';
import 'package:esnap/utils/dimensions.dart';
import 'package:flutter/cupertino.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preferences'),
      ),
      body: const CupertinoScrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                spacerM,
                _ThemeController(),
              ],
            ),
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
    return BlocBuilder<PreferencesBloc, PreferencesState>(
      buildWhen: (previous, current) => previous.themeMode != current.themeMode,
      builder: (context, state) {
        return DropdownButtonFormField<ThemeType>(
          decoration: const InputDecoration(label: Text('Theme mode')),
          menuMaxHeight: AppDimenssions.menuMaxHeight,
          items: ThemeType.values
              .map(
                (e) => DropdownMenuItem<ThemeType>(
                  value: e,
                  child: Row(
                    children: [
                      Icon(_themeIcons[e]),
                      const SizedBox(width: 8),
                      Text(e.name),
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
          value: ThemeType.light,
        );
      },
    );
  }
}

const _themeIcons = {
  ThemeType.light: Icons.light_mode,
  ThemeType.dark: Icons.dark_mode,
  ThemeType.system: Icons.settings,
};
