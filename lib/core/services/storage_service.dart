import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import '../constants/storage_keys.dart';

class StorageService extends GetxService {
  late SharedPreferences _prefs;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  Future<StorageService> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

  // Secure Auth Tokens
  Future<void> saveTokens({required String access, required String refresh}) async {
    await _secureStorage.write(key: StorageKeys.accessToken, value: access);
    await _secureStorage.write(key: StorageKeys.refreshToken, value: refresh);
  }

  Future<String?> getAccessToken() async {
    return await _secureStorage.read(key: StorageKeys.accessToken);
  }

  Future<String?> getRefreshToken() async {
    return await _secureStorage.read(key: StorageKeys.refreshToken);
  }

  Future<void> clearAuthData() async {
    await _secureStorage.delete(key: StorageKeys.accessToken);
    await _secureStorage.delete(key: StorageKeys.refreshToken);
    await _prefs.remove(StorageKeys.userId);
    await _prefs.remove(StorageKeys.userPhone);
    await _prefs.remove(StorageKeys.userName);
    await _prefs.remove(StorageKeys.userRole);
  }

  // Preferences
  Future<void> saveString(String key, String value) async => await _prefs.setString(key, value);
  String? getString(String key) => _prefs.getString(key);

  Future<void> saveBool(String key, bool value) async => await _prefs.setBool(key, value);
  bool getBool(String key, {bool defaultValue = false}) => _prefs.getBool(key) ?? defaultValue;

  // Language
  String getLanguageCode() => _prefs.getString(StorageKeys.languageCode) ?? 'bn';
  String getCountryCode() => _prefs.getString(StorageKeys.countryCode) ?? 'BD';
  Future<void> saveLocale(String langCode, String countryCode) async {
    await _prefs.setString(StorageKeys.languageCode, langCode);
    await _prefs.setString(StorageKeys.countryCode, countryCode);
  }
}
