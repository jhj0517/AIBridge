import 'package:aibridge/localdb/localdb.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../dependency_injection.dart';
import 'base_module.dart';

final class LocalDBModule extends BaseModule {

  @override
  Future<void> register() async {
    // SharedPreference
    locator.registerLazySingletonAsync<SharedPreferences>(() async => SharedPreferences.getInstance());
    await locator.isReady<SharedPreferences>();
    // SQLite Database
    locator.registerLazySingleton<SQFliteHelper>(() => SQFliteHelper(prefs: locator.get<SharedPreferences>()));
    // SQLite Daos
    locator.registerLazySingleton<CharacterDao>(() => CharacterDao(localDB: locator<SQFliteHelper>()));
    locator.registerLazySingleton<ChatMessageDao>(() => ChatMessageDao(localDB: locator<SQFliteHelper>()));
    locator.registerLazySingleton<ChatRoomDao>(() => ChatRoomDao(localDB: locator<SQFliteHelper>()));
    // Secure Storage
    locator.registerLazySingleton<FlutterSecureStorage>(() => const FlutterSecureStorage());
    // DotEnv
    await dotenv.load(fileName: ".env");
    locator.registerLazySingleton<DotEnv>(() => dotenv);
  }

}