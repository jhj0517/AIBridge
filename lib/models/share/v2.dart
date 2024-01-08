class V2 {
  final String name;
  final String description;
  final String firstMes;

  V2({
    required this.name,
    required this.description,
    required this.firstMes
  });

  Map<String, dynamic> toMap() {
    return {"spec":"chara_card_v2",
      "spec_version":"2.0",
      "data":{"name":name,
        "description": description,
        "personality":"",
        "scenario":"",
        "first_mes":firstMes,
        "mes_example":"",
        "creator_notes":"",
        "system_prompt":"",
        "post_history_instructions":"",
        "alternate_greetings":[],
        "character_book":{"extensions":{},"entries":[]},
        "tags":[],
        "creator":"",
        "character_version":"",
        "extensions":{}
      }
    };
  }

  factory V2.fromMap(Map<String, dynamic> map) {
    final data = map["data"];
    return V2(
      name: data["name"],
      description: data["description"],
      firstMes: data["first_mes"]
    );
  }

  Map<String, dynamic> toRisuAIMap() {
    return {"spec":"chara_card_v2",
      "spec_version":"2.0",
      "data":{"name":name,
        "description":description,
        "personality":"",
        "scenario":"",
        "first_mes":firstMes,
        "mes_example":"",
        "creator_notes":"",
        "system_prompt":"",
        "post_history_instructions":"",
        "alternate_greetings":[],
        "character_book":{"extensions":{"risu_fullWordMatching":false},"entries":[]},
        "tags":[],
        "creator":"",
        "character_version":"",
        "extensions":{
          "risuai":{
            "emotions":[],
            "bias":[],
            "viewScreen":"none",
            "customScripts":[],
            "utilityBot":false,
            "sdData":[["always","solo, 1girl"],["negative",""],["|character's appearance",""],["current situation",""],["\$character's pose",""],["\$character's emotion",""],["current location",""]],
            "triggerscript":[],
            "additionalText":"",
            "largePortrait":false,
            "lorePlus":true,
            "newGenData":{"prompt":"","negative":"","instructions":"","emotionInstructions":""}},
          "depth_prompt":{"depth":0,"prompt":""}
        }
      }
    };
  }

  Map<String, dynamic> toTavernAIMap() {
    return {"name": name,
      "description": description,
      "personality":"summary",
      "scenario":"scenario",
      "first_mes": firstMes,
      "mes_example":"",
      "creatorcomment":"",
      "avatar":"none",
      "chat":"${name} - 2024-1-1 @00h 00m 00s 000ms",
      "talkativeness":"0.5",
      "fav":false,
      "spec":"chara_card_v2",
      "spec_version":"2.0",
      "data":{"name":name,
        "description":description,
        "personality":"summary",
        "scenario":"scenario",
        "first_mes":firstMes,
        "mes_example":"",
        "creator_notes":"",
        "system_prompt":"",
        "post_history_instructions":"",
        "tags":[],
        "creator":"",
        "character_version":"",
        "alternate_greetings":[],
        "extensions":{"talkativeness":"0.5","fav":false,"world":"","depth_prompt":{"prompt":"","depth":0}}},
      "create_date":"2024-1-4 @19h 06m 48s 932ms"
    };
  }
}