import 'package:shared_preferences/shared_preferences.dart';
import 'package:theme/local_storage/local_storage_keys.dart';

class LocalStorage {
  static late final SharedPreferences _storage;

  static Future<void> initialize() async {
    _storage = await SharedPreferences.getInstance();
  }

  static String? getDataFromKey(final LocalStorageKeys key) {
    final String? value = _storage.getString(key.value);

    return value;
  }

  static Future<void> removeDataFromKey(final LocalStorageKeys key) async {
    try {
      await _storage.remove(key.value);
    } catch (failure) {
      print(failure);
    }
  }

  static Future<void> saveDataFromKey(
      final LocalStorageKeys key, final String data) async {
    try {
      await _storage.setString(key.value, data);
    } catch (failure) {
      print(failure);
    }
  }
}
