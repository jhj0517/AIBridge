enum ServiceType {
  openAI,
  paLM
}

abstract class IService {
  final ServiceType serviceType;
  final String characterId;

  IService({
    required this.serviceType,
    required this.characterId,
  });

  Map<String, dynamic> toMap();
}