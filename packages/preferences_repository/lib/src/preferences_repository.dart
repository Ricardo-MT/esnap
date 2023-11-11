import 'package:preferences_api/preferences_api.dart';

/// {@template preferences_repository}
/// A gateway to access the preferences api
/// {@endtemplate}
class PreferencesRepository {
  /// {@macro preferences_repository}
  const PreferencesRepository({
    required PreferencesApi client,
  }) : _client = client;
  final PreferencesApi _client;

  /// Returns whether the user has completed the onboarding process
  Future<bool> isFirstLogin() => _client.isFirstLogin();

  /// Sets the user's onboarding status to complete
  Future<void> finishOnboarding() => _client.finishOnboarding();

  /// Returns the user's preferred theme
  Future<ThemeType> getTheme() => _client.getTheme();

  /// Provides a [Stream] of the user's preferred theme
  Stream<ThemeType> getThemeAsStream() => _client.getThemeAsStream();

  /// Sets the user's preferred theme
  Future<void> setTheme(ThemeType theme) => _client.setTheme(theme);

  /// Returns the user's preferred language
  Future<String?> getLanguage() => _client.getLanguage();

  /// Provides a [Stream] of the user's preferred language
  Stream<String> getLanguageAsStream() => _client.getLanguageAsStream();

  /// Sets the user's preferred language
  Future<void> setLanguage(String language) => _client.setLanguage(language);
}
