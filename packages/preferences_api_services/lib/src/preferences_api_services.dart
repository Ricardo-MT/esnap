import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:preferences_api/preferences_api.dart';

/// {@template preferences_api_services}
/// A Flutter implementation of the PreferencesApi using flutter_secure_storage
/// {@endtemplate}
class PreferencesApiServices extends PreferencesApi {
  /// {@macro preferences_api_services}
  PreferencesApiServices() {
    _storage = const FlutterSecureStorage();
  }
  late final FlutterSecureStorage _storage;

  @override
  Future<void> finishOnboarding() =>
      _storage.write(key: 'onboarding_completed', value: 'true');

  @override
  Future<bool> isFirstLogin() async {
    final value = await _storage.read(key: 'onboarding_completed');
    return value == null;
  }
}
