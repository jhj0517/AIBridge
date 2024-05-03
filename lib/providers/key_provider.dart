import 'package:aibridge/models/platforms/platform.dart';
import 'package:flutter/material.dart';

import '../repositories/key_repository.dart';
import '../constants/secure_storage_constants.dart';


class KeyProvider extends ChangeNotifier {

  KeyProvider({required this.keyRepository}){}

  final KeyRepository keyRepository;

  String? _openAPIKey;
  String? get openAPIKey => _openAPIKey;

  String? _paLMAPIKey;
  String? get paLMAPIKey => _paLMAPIKey;

  Future<void> initKeys() async {
    _openAPIKey = await keyRepository.readValue(SecureStorageConstants.openAI);
    _paLMAPIKey = await keyRepository.readValue(SecureStorageConstants.paLM);
  }

  Future<void> saveKey(String key,String value) async {
    await keyRepository.writeValue(key, value);
    initKeys();
  }

  bool isKeyValid(AIPlatformType type){
    switch (type){
      case AIPlatformType.openAI:
        return openAPIKey != null && openAPIKey!.isNotEmpty;
      case AIPlatformType.paLM:
        return paLMAPIKey != null && paLMAPIKey!.isNotEmpty;
    }
  }

}