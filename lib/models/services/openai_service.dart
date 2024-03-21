import 'dart:convert';

import '../../localdb/localdb.dart';
import '../../constants/model_constants.dart';
import 'i_service.dart';

class OpenAIService implements IService {

  static const openAIModels = [ModelConstants.chatGPT3dot5, ModelConstants.chatGPT4, ModelConstants.chatGPT4Vision];
  static const openAIModelNameMapping = {
    ModelConstants.chatGPT3dot5 : ModelConstants.chatGPT3dot5Id,
    ModelConstants.chatGPT4 : ModelConstants.chatGPT4Id,
    ModelConstants.chatGPT4Vision : ModelConstants.chatGPT4VisionId
  };
  static const double defaultTemperature = 1;
  static const double maxTemperature = 2;

  @override
  final ServiceType serviceType = ServiceType.openAI;
  @override
  final String characterId;

  final int? id;
  final String modelName;
  final String? modelId;
  final double temperature;
  final List<String> systemPrompts;

  OpenAIService({
    this.id,
    required this.characterId,
    required this.modelName,
    required this.temperature,
    required this.systemPrompts,
  }) : modelId = openAIModelNameMapping[modelName];

  @override
  Map<String, dynamic> toMap() {
    return {
      SQFliteHelper.openAIColumnServiceType: serviceType.index,
      SQFliteHelper.openAIColumnCharacterId: characterId,
      SQFliteHelper.openAIColumnModelName: modelName,
      SQFliteHelper.openAIColumnModelId: modelId,
      SQFliteHelper.openAIColumnTemperature: temperature,
      SQFliteHelper.openAIColumnSystemPrompts: jsonEncode(systemPrompts),
    };
  }

  factory OpenAIService.fromMap(Map<String, dynamic> map) {
    return OpenAIService(
      id: map[SQFliteHelper.openAIColumnId] as int?,
      characterId: map[SQFliteHelper.openAIColumnCharacterId] as String,
      modelName: map[SQFliteHelper.openAIColumnModelName] as String,
      temperature: map[SQFliteHelper.openAIColumnTemperature] as double,
      systemPrompts: (jsonDecode(map[SQFliteHelper.openAIColumnSystemPrompts]) as List<dynamic>)
          .map((e) => e as String).toList(),
    );
  }
}