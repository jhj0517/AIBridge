import 'i_service.dart';
import '../../localdb/localdb.dart';
import '../../constants/model_constants.dart';
import '../sqflite/chat_message.dart';

class PaLMService implements IService {
  static const paLMModels = [ModelConstants.paLMBison];
  static const paLMModelNameMapping = {
    ModelConstants.paLMBison : ModelConstants.paLMBisonId
  };

  @override
  final ServiceType serviceType = ServiceType.paLM;
  @override
  final String characterId;

  final int? id;
  final String modelName;
  final String modelId;
  final String context;
  final String exampleInput;
  final String exampleOutput;
  final double temperature;
  final int candidateCount;
  final double? topP;
  final int? topK;

  PaLMService({
    this.id,
    required this.characterId,
    required this.modelName,
    required this.temperature,
    required this.candidateCount,
    required this.exampleInput,
    required this.exampleOutput,
    required this.context,
    this.topP,
    this.topK,
  }): modelId = paLMModelNameMapping[modelName]!;

  @override
  Map<String, dynamic> toMap() {
    return {
      SQFliteHelper.paLMColumnServiceType: serviceType.index,
      SQFliteHelper.paLMColumnCharacterId: characterId,
      SQFliteHelper.paLMColumnModelName: modelName,
      SQFliteHelper.paLMColumnModelId: modelId,
      SQFliteHelper.paLMColumnTemperature: temperature,
      SQFliteHelper.paLMColumnCandidateCount: candidateCount,
      SQFliteHelper.paLMColumnContext: context,
      SQFliteHelper.paLMColumnExampleInput: exampleInput,
      SQFliteHelper.paLMColumnExampleOutput: exampleOutput,
    };
  }

  factory PaLMService.fromMap(Map<String, dynamic> map) {
    return PaLMService(
      id: map[SQFliteHelper.paLMColumnId] as int?,
      characterId: map[SQFliteHelper.paLMColumnCharacterId] as String,
      modelName: map[SQFliteHelper.paLMColumnModelName] as String,
      temperature: map[SQFliteHelper.paLMColumnTemperature] as double,
      candidateCount: map[SQFliteHelper.paLMColumnCandidateCount] as int,
      exampleInput: map[SQFliteHelper.paLMColumnExampleInput] as String,
      exampleOutput: map[SQFliteHelper.paLMColumnExampleOutput] as String,
      context: map[SQFliteHelper.paLMColumnContext] as String,
    );
  }

  @override
  String toString() {
    return 'PaLMService(\n'
        '  serviceType: $serviceType,\n'
        '  id: $id,\n'
        '  characterId: $characterId,\n'
        '  modelName: $modelName,\n'
        '  modelId: $modelId,\n'
        '  context: $context,\n'
        '  exampleInput: $exampleInput,\n'
        '  exampleOutput: $exampleOutput,\n'
        '  temperature: $temperature,\n'
        '  candidateCount: $candidateCount,\n'
        '  topP: $topP,\n'
        '  topK: $topK,\n'
        ')';
  }

}

/*
 Response
*/

class PaLMResponse {

  final List<PaLMResponseCandidate>? candidates;
  final List<PaLMResponseMessage> messages;
  final List<PaLMResponseContentFilter>? filters; // nullable because it is included only when gets filtered.

  PaLMResponse({this.candidates, required this.messages, this.filters});

  factory PaLMResponse.fromJson(Map<String, dynamic> json) {
    return PaLMResponse(
      candidates: json['candidates'] != null
          ? (json['candidates'] as List).map((e) => PaLMResponseCandidate.fromJson(e)).toList()
          : null,
      messages: (json['messages'] as List).map((e) => PaLMResponseMessage.fromJson(e)).toList(),
      filters: json['filters'] != null
          ? (json['filters'] as List).map((e) => PaLMResponseContentFilter.fromJson(e)).toList()
          : null,
    );
  }

  @override
  String toString() {
    return 'PaLMResponse(candidates: $candidates, messages: $messages, filters: $filters)';
  }
}

class PaLMResponseCandidate {
  final String author;
  final String content;

  PaLMResponseCandidate({required this.author, required this.content});

  factory PaLMResponseCandidate.fromJson(Map<String, dynamic> json) {
    return PaLMResponseCandidate(
      author: json['author'],
      content: json['content'],
    );
  }
}

class PaLMResponseMessage {
  final String author;
  final String content;

  PaLMResponseMessage({required this.author, required this.content});

  factory PaLMResponseMessage.fromJson(Map<String, dynamic> json) {
    return PaLMResponseMessage(
      author: json['author'],
      content: json['content'],
    );
  }
}

enum BlockedReason {
  BLOCKED_REASON_UNSPECIFIED,
  SAFETY,
  OTHER
}

class PaLMResponseContentFilter {
  final BlockedReason reason;
  final String? message;

  PaLMResponseContentFilter({required this.reason, this.message});

  factory PaLMResponseContentFilter.fromJson(Map<String, dynamic> json) {
    return PaLMResponseContentFilter(
      reason: BlockedReason.values.firstWhere((e) => e.toString().split('.').last == json['reason']),
      message: json['message'],
    );
  }

  @override
  String toString() {
    return 'ContentFilter(reason: $reason, message: $message)';
  }
}

/*
 Request
*/

class PaLMRequest {
  final PaLMPrompt prompt;
  final double temperature;
  final int candidateCount;
  final double? topP;
  final int? topK;

  PaLMRequest({
    required this.prompt,
    required this.temperature,
    required this.candidateCount,
    this.topP,
    this.topK,
  });

  Map<String, dynamic> toJson() {
    return {
      'prompt': prompt.toJson(),
      'temperature': temperature,
      'candidate_count': candidateCount,
      // 'topP': topP,
      // 'topK': topK,  // these are advanced value, I don't know its default value
    };
  }
}

class PaLMPrompt {
  final String? context;
  final List<PaLMExample>? examples;
  final List<PaLMMessage> messages;

  PaLMPrompt({
    required this.context,
    required this.examples,
    required this.messages
  });

  Map<String, dynamic> toJson() {
    return {
      'context': context,
      'examples': examples?.map((example) => example.toJson()).toList(),
      'messages': messages.map((message) => message.toJson()).toList(),
    };
  }

}

class PaLMExample {
  final PaLMMessage input;
  final PaLMMessage output;

  PaLMExample({
    required this.input,
    required this.output,
  });

  Map<String, dynamic> toJson() {
    return {
      'input': input.toJson(),
      'output': output.toJson(),
    };
  }

  factory PaLMExample.fromMap(Map<String, dynamic> map) {
    return PaLMExample(
      input: PaLMMessage.fromJson(map['input']),
      output: PaLMMessage.fromJson(map['output']),
    );
  }

}

enum PaLMMessageRole{
  user,
  assistant
}

class PaLMMessage {
  final PaLMMessageRole author;
  final String content;

  PaLMMessage({required this.author, required this.content});

  Map<String, dynamic> toJson() {
    return {
      'author': author.name, // Convert the enum to a string
      'content': content,
    };
  }

  factory PaLMMessage.fromJson(Map<String, dynamic> map) {
    return PaLMMessage(
      author: PaLMMessageRole.values.firstWhere((e) => e.toString().split('.').last == map['author']), // Convert the string back to an enum
      content: map['content'],
    );
  }

}

