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
}
