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
  }) {
    _storage = storage;
    _themeStreamController.add(initialTheme);
  }
  late final FlutterSecureStorage _storage;

  /// Stream of the user's theme preference
  final _themeStreamController =
      BehaviorSubject<ThemeType>.seeded(ThemeType.system);

  /// Reads the initial theme from the secure storage and returns an instance
  static Future<PreferencesApiServices> initializer() async {
    const storage = FlutterSecureStorage();
    final res = await storage.read(key: SecureStorageKeys.theme);
    final initialTheme = ThemeType.values.firstWhere(
      (element) => element.name == res,
      orElse: () => ThemeType.system,
    );
    return PreferencesApiServices(
      storage: storage,
      initialTheme: initialTheme,
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
    await _storage.write(key: SecureStorageKeys.theme, value: theme.name);
    _themeStreamController.add(theme);
  }
}

/// Keys used for storing values in the secure storage
class SecureStorageKeys {
  /// Key for storing the onboarding status
  static const onboardingCompleted = 'onboarding_completed';

  /// Key for storing the theme
  static const theme = 'theme';
}
