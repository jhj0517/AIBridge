import 'package:aibridge/localdb/localdb.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../repositories/repositories.dart';
import '../dependency_injection.dart';
import 'base_module.dart';

final class RepositoryModule extends BaseModule {

  @override
  Future<void> register() async {
    locator.registerFactory(() => CharactersRepository(
      characterDao: locator.get<CharacterDao>(),
      chatMessageDao: locator<ChatMessageDao>()
    ));
    locator.registerFactory(() => ChatRepository(prefs: locator.get<SharedPreferences>(), sqfliteHelper: locator.get<SQFliteHelper>()));
    locator.registerFactory(() => ChatRoomRepository(prefs: locator.get<SharedPreferences>(), sqfliteHelper: locator.get<SQFliteHelper>()));
    locator.registerFactory(() => KeyRepository(secureStorage: locator.get<FlutterSecureStorage>()));
  }

}