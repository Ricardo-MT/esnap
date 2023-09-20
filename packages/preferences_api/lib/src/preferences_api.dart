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
}
