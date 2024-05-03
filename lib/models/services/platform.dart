enum AIPlatformType {
  openAI,
  paLM
}

abstract class AIPlatform {
  final AIPlatformType serviceType;
  final String characterId;

  AIPlatform({
    required this.serviceType,
    required this.characterId,
  });

  Map<String, dynamic> toMap();
}