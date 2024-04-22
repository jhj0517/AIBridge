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
    // SQLite
    locator.registerLazySingleton<SQFliteHelper>(() => SQFliteHelper(prefs: locator.get<SharedPreferences>()));
    // Secure Storage
    locator.registerLazySingleton<FlutterSecureStorage>(() => const FlutterSecureStorage());
    // DotEnv
    await dotenv.load(fileName: ".env");
    locator.registerLazySingleton<DotEnv>(() => dotenv);
  }

}