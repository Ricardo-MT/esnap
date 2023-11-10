import 'package:preferences_api/src/models/models.dart';

/// {@template preferences_api}
/// A collection of models and functions for handling user preferences
/// {@endtemplate}
abstract class PreferencesApi {
  /// {@macro preferences_api}
  const PreferencesApi();

  /// Returns whether the user has completed the onboarding process
  Future<bool> isFirstLogin();

  /// Sets the user's onboarding status to complete
  Future<void> finishOnboarding();

  /// Returns the user's preferred theme
  Future<ThemeType> getTheme();

  /// Provides a [Stream] of the user's preferred theme
  Stream<ThemeType> getThemeAsStream();

  /// Sets the user's preferred theme
  Future<void> setTheme(ThemeType theme);
}
