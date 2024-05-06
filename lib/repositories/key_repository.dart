import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class KeyRepository {

  KeyRepository({required this.secureStorage});

  final FlutterSecureStorage secureStorage;

  Future<void> writeValue(String key, String value) async {
    await secureStorage.write(key: key, value: value);
  }

  Future<String?> readValue(String key) async {
    return await secureStorage.read(key: key);
  }

}