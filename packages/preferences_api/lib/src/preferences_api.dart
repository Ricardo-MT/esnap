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

  /// Returns the user's preferred language
  Future<String?> getLanguage();

  /// Provides a [Stream] of the user's preferred language
  Stream<String> getLanguageAsStream();

  /// Sets the user's preferred language
  Future<void> setLanguage(String language);

  /// Gets App Version from Firebase release collection
  Future<String?> getAppVersionInFireBase();

  /// Gets current App Version
  Future<String?> getCurrentAppVersion();

  /// Returns whether the app is up to date
  Future<bool> isAppUpToDate();
}
