import 'dart:typed_data';
import 'dart:convert';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';

import '../../localdb/localdb.dart';
import '../../constants/constants.dart';
import '../models.dart';

class Character {
  final String? id;
  final Uint8List photoBLOB;
  final Uint8List backgroundPhotoBLOB;
  final String characterName;
  final String userName;
  final String firstMessage;
  final IService service;

  Character({
    this.id,
    required this.photoBLOB,
    required this.backgroundPhotoBLOB,
    required this.characterName,
    required this.userName,
    required this.firstMessage,
    required this.service,
  });

  Map<String, dynamic> toMap() {
    var uuid = const Uuid();
    return {
      SQFliteHelper.charactersColumnId: id ?? uuid.v4(),
      SQFliteHelper.charactersColumnCharacterPhotoBLOB: photoBLOB,
      SQFliteHelper.charactersColumnCharacterBackgroundPhotoBLOB: backgroundPhotoBLOB,
      SQFliteHelper.charactersColumnCharacterName: characterName,
      SQFliteHelper.charactersColumnUserName: userName,
      SQFliteHelper.charactersColumnFirstMessage: firstMessage,
      SQFliteHelper.charactersColumnService: json.encode(service.toMap()), // Encode the service as JSON
    };
  }

  Map<String, dynamic>? toV2Card(){
    if(service.serviceType == ServiceType.openAI){
      final _service = service as OpenAIService;
      return V2(
          name: characterName,
          description: _service.systemPrompts.first,
          firstMes: firstMessage
      ).toMap();
    }

    else {
      debugPrint("Not supported format to share.");
      return null;
    }
  }

  factory Character.fromV2Card({
    required V2 v2Card,
    required Uint8List photoBLOB,
    required Uint8List backgroundPhotoBLOB
  }) {
    String _id = const Uuid().v4();
    return Character(
        id: _id,
        photoBLOB: photoBLOB,
        backgroundPhotoBLOB: backgroundPhotoBLOB,
        characterName: v2Card.name,
        firstMessage: v2Card.firstMes,
        userName: "",
        service: OpenAIService(
          characterId: _id,
          modelName: ModelConstants.chatGPT4,
          systemPrompts: [v2Card.description],
          temperature: 1
        )
    );
  }

  factory Character.fromMap(Map<String, dynamic> map) {
    IService service;
    Map<String, dynamic> serviceMap = json.decode(map[SQFliteHelper.charactersColumnService] as String); // Decode the JSON
    ServiceType type = ServiceType.values[serviceMap['service_type'] as int];
    switch (type) {
      case ServiceType.openAI:
        service = OpenAIService.fromMap(serviceMap);
        break;
      case ServiceType.paLM:
        service = PaLMService.fromMap(serviceMap);
        break;
      default:
        throw Exception('Unknown service type: $type');
    }
    return Character(
      id: map[SQFliteHelper.charactersColumnId] as String?,
      photoBLOB: map[SQFliteHelper.charactersColumnCharacterPhotoBLOB] as Uint8List,
      backgroundPhotoBLOB: map[SQFliteHelper.charactersColumnCharacterBackgroundPhotoBLOB] as Uint8List,
      characterName: map[SQFliteHelper.charactersColumnCharacterName] as String,
      userName: map[SQFliteHelper.charactersColumnUserName] as String,
      firstMessage: map[SQFliteHelper.charactersColumnFirstMessage] as String,
      service: service,
    );
  }

  factory Character.defaultCharacter() {
    var uuid = const Uuid().v4();
    return Character(
      id: uuid,
      photoBLOB: Uint8List(0),
      backgroundPhotoBLOB: Uint8List(0),
      characterName: "",
      userName: "",
      firstMessage: "",
      service: OpenAIService(
        characterId: uuid,
        modelName: ModelConstants.chatGPT3dot5,
        temperature: 1,
        systemPrompts: [],
      ),
    );
  }

  @override
  String toString() {
    return 'Character(id: $id, photoBLOB: ${photoBLOB.length}, backgroundPhotoBLOB: ${backgroundPhotoBLOB.length}, characterName: $characterName, userName: $userName, firstMessage: $firstMessage, service: $service)';
  }
}