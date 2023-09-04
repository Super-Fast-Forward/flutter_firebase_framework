import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:theme/local_storage/local_storage_keys.dart';

class SecureStorage {
  static FlutterSecureStorage _storage = FlutterSecureStorage();

  static Future<String?> getDataFromKey(final SecureStorageKeys key) async {
    final String? value = await _storage.read(
      key: key.value,
    );

    return value;
  }

  static Future<void> removeDataFromKey(final SecureStorageKeys key) async {
    try {
      await _storage.delete(key: key.value);
    } catch (failure) {
      print(failure);
    }
  }

  static Future<void> saveDataFromKey(
      final SecureStorageKeys key, final String data) async {
    try {
      await _storage.write(
        key: key.value,
        value: data,
      );
    } catch (failure) {
      print(failure);
    }
  }
}
