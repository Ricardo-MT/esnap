import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:preferences_api/preferences_api.dart';
import 'package:rxdart/rxdart.dart';

/// {@template preferences_api_services}
/// A Flutter implementation of the PreferencesApi using flutter_secure_storage
/// {@endtemplate}
class PreferencesApiServices extends PreferencesApi {
  /// {@macro preferences_api_services}
  PreferencesApiServices({
    required FlutterSecureStorage storage,
    required ThemeType initialTheme,
    required String initialLanguage,
  }) {
    _storage = storage;
    _themeStreamController.add(initialTheme);
    _languageStreamController.add(initialLanguage);
  }
  late final FlutterSecureStorage _storage;

  /// Stream of the user's theme preference
  final _themeStreamController =
      BehaviorSubject<ThemeType>.seeded(ThemeType.system);

  /// Stream of the user's theme preference
  final _languageStreamController = BehaviorSubject<String>();

  /// Reads the initial theme from the secure storage and returns an instance
  static Future<PreferencesApiServices> initializer() async {
    const storage = FlutterSecureStorage();
    final resTheme = await storage.read(key: SecureStorageKeys.theme);
    final resLanguage = await storage.read(key: SecureStorageKeys.language);
    final initialTheme = ThemeType.values.firstWhere(
      (element) => element.name == resTheme,
      orElse: () => ThemeType.system,
    );
    return PreferencesApiServices(
      storage: storage,
      initialTheme: initialTheme,
      initialLanguage: resLanguage ?? Platform.localeName,
    );
  }

  @override
  Future<void> finishOnboarding() =>
      _storage.write(key: SecureStorageKeys.onboardingCompleted, value: 'true');

  @override
  Future<bool> isFirstLogin() async {
    final value =
        await _storage.read(key: SecureStorageKeys.onboardingCompleted);
    return value == null;
  }

  @override
  Future<ThemeType> getTheme() async {
    final res = await _storage.read(key: SecureStorageKeys.theme);
    return ThemeType.values.firstWhere(
      (element) => element.name == res,
      orElse: () => ThemeType.system,
    );
  }

  @override
  Stream<ThemeType> getThemeAsStream() =>
      _themeStreamController.asBroadcastStream();

  @override
  Future<void> setTheme(ThemeType theme) async {
    _themeStreamController.add(theme);
    await _storage.write(key: SecureStorageKeys.theme, value: theme.name);
  }

  @override
  Future<String?> getLanguage() =>
      _storage.read(key: SecureStorageKeys.language);

  @override
  Stream<String> getLanguageAsStream() =>
      _languageStreamController.asBroadcastStream();

  @override
  Future<void> setLanguage(String language) {
    _languageStreamController.add(language);
    return _storage.write(key: SecureStorageKeys.language, value: language);
  }
}

/// Keys used for storing values in the secure storage
class SecureStorageKeys {
  /// Key for storing the onboarding status
  static const onboardingCompleted = 'onboarding_completed';

  /// Key for storing the theme
  static const theme = 'theme';

  /// Key for storing the language
  static const language = 'language';
}
