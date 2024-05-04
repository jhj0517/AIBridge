// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ko locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'ko';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "InitializingTokenizer":
            MessageLookupByLibrary.simpleMessage("토크나이저 초기화 중.."),
        "appTitle": MessageLookupByLibrary.simpleMessage("AI 브리지"),
        "appleSignIn": MessageLookupByLibrary.simpleMessage("Apple 로그인"),
        "background": MessageLookupByLibrary.simpleMessage("배경"),
        "backupData": MessageLookupByLibrary.simpleMessage("데이터 백업"),
        "cancel": MessageLookupByLibrary.simpleMessage("취소"),
        "characterChatBoxBackgroundColor":
            MessageLookupByLibrary.simpleMessage("캐릭터 채팅 배경 색상"),
        "characterFontColor": MessageLookupByLibrary.simpleMessage("캐릭터 폰트 색상"),
        "characterFontSize": MessageLookupByLibrary.simpleMessage("캐릭터 폰트 크기"),
        "characterNameHint":
            MessageLookupByLibrary.simpleMessage("프롬프트에서 <char> 와 대치됩니다."),
        "characterRecognizeUserName":
            MessageLookupByLibrary.simpleMessage("캐릭터가 인식할 당신의 이름"),
        "characterRecognizeUserNameHint":
            MessageLookupByLibrary.simpleMessage("프롬프트에서 <user> 와 대치됩니다."),
        "charactersPageTitle": MessageLookupByLibrary.simpleMessage("캐릭터"),
        "chatGPT": MessageLookupByLibrary.simpleMessage("ChatGPT"),
        "chatGPTAPI": MessageLookupByLibrary.simpleMessage("ChatGPT API"),
        "chatGPTAPIKeyErrorTitle":
            MessageLookupByLibrary.simpleMessage("ChatGPT API 키 오류"),
        "chatGPTAPIisInvalid": MessageLookupByLibrary.simpleMessage(
            "ChatGPT API 키가 유효하지 않습니다. 등록할 수 있는 페이지로 이동하시겠습니까?"),
        "chatGPTAPIisNotRegistered": MessageLookupByLibrary.simpleMessage(
            "ChatGPT API 키가 아직 등록되지 않았습니다. 등록할 수 있는 페이지로 이동하시겠습니까?"),
        "chatGPTKey": MessageLookupByLibrary.simpleMessage("ChatGPT API 키"),
        "chatInputHint": MessageLookupByLibrary.simpleMessage("메시지를 입력하세요.."),
        "chatOption": MessageLookupByLibrary.simpleMessage("채팅"),
        "chatRoomSetting": MessageLookupByLibrary.simpleMessage("채팅방 설정"),
        "chatRoomsPageTitle": MessageLookupByLibrary.simpleMessage("채팅방"),
        "chatroomBackgroundColor":
            MessageLookupByLibrary.simpleMessage("채팅방 배경 색상"),
        "checkingAPIKeys": MessageLookupByLibrary.simpleMessage("API 키 확인 중.."),
        "colors": MessageLookupByLibrary.simpleMessage("색상"),
        "copyChatOption": MessageLookupByLibrary.simpleMessage("복사"),
        "darkTheme": MessageLookupByLibrary.simpleMessage("다크 테마"),
        "defaultCharacterFirstMessage":
            MessageLookupByLibrary.simpleMessage("안녕! 뭐해?"),
        "defaultCharacterName": MessageLookupByLibrary.simpleMessage("캐릭터 A"),
        "defaultCharacterPersonalityPrompt": MessageLookupByLibrary.simpleMessage(
            "<char> has a very friendly personality. <char> wants to know many things about <user>."),
        "defaultCharacterSystemPrompt": MessageLookupByLibrary.simpleMessage(
            "Write <char>\'s reply in a chat between <char> and <user>."),
        "deleteCharacterConfirm": MessageLookupByLibrary.simpleMessage(
            "캐릭터를 삭제하고 싶으신가요?\n해당 캐릭터와의 모든 대화기록 또한 삭제됩니다!"),
        "deleteCharacterOption": MessageLookupByLibrary.simpleMessage("캐릭터 삭제"),
        "deleteChatOption": MessageLookupByLibrary.simpleMessage("삭제"),
        "deleteChatroom": MessageLookupByLibrary.simpleMessage("채팅방 삭제"),
        "deleteChatroomConfirm": MessageLookupByLibrary.simpleMessage(
            "채팅방을 삭제하고 싶으신가요?\n해당 채팅방의 모든 대화기록이 삭제됩니다!"),
        "deleteOption": MessageLookupByLibrary.simpleMessage("삭제"),
        "description": MessageLookupByLibrary.simpleMessage("설명"),
        "descriptionHint":
            MessageLookupByLibrary.simpleMessage("캐릭터의 설명에 대한 프롬프트입니다."),
        "done": MessageLookupByLibrary.simpleMessage("완료"),
        "editCharacterOption": MessageLookupByLibrary.simpleMessage("캐릭터 수정"),
        "editChatOption": MessageLookupByLibrary.simpleMessage("수정"),
        "editProfile": MessageLookupByLibrary.simpleMessage("프로필 수정"),
        "enableMarkdownRendering":
            MessageLookupByLibrary.simpleMessage("마크다운 렌더링 허용"),
        "export": MessageLookupByLibrary.simpleMessage("익스포트"),
        "failedToImport":
            MessageLookupByLibrary.simpleMessage("V2 데이터를 포함하고 있지 않은 이미지입니다."),
        "firstMessageHint":
            MessageLookupByLibrary.simpleMessage("캐릭터의 첫 메시지를 정할 수 있습니다."),
        "firstMessageLabel": MessageLookupByLibrary.simpleMessage("캐릭터의 첫 메시지"),
        "fontSize": MessageLookupByLibrary.simpleMessage("글자 크기"),
        "googleSignIn": MessageLookupByLibrary.simpleMessage("Google 로그인"),
        "gpt4VisionOnly": MessageLookupByLibrary.simpleMessage(
            "이 기능은 현재 GPT-4 Vision 에서만 지원됩니다."),
        "image": MessageLookupByLibrary.simpleMessage("이미지"),
        "import": MessageLookupByLibrary.simpleMessage("임포트"),
        "insertingDefaultCharacter":
            MessageLookupByLibrary.simpleMessage("기본 캐릭터 삽입 중.."),
        "isSaved": MessageLookupByLibrary.simpleMessage(" 가 저장되었습니다."),
        "keyPageTitle": MessageLookupByLibrary.simpleMessage("API 키 관리"),
        "lightTheme": MessageLookupByLibrary.simpleMessage("라이트 테마"),
        "loadData": MessageLookupByLibrary.simpleMessage("데이터 로드"),
        "name": MessageLookupByLibrary.simpleMessage("이름"),
        "neverLeakAPIKey":
            MessageLookupByLibrary.simpleMessage("절대 API 키를 유출하지 마세요!"),
        "newCharacter": MessageLookupByLibrary.simpleMessage("캐릭터 생성"),
        "noCharacter": MessageLookupByLibrary.simpleMessage("캐릭터가 없습니다."),
        "notSupportedImage":
            MessageLookupByLibrary.simpleMessage("지원되는 형식이 아닙니다."),
        "paLM": MessageLookupByLibrary.simpleMessage("PaLM"),
        "paLMAPI": MessageLookupByLibrary.simpleMessage("PaLM API"),
        "paLMAPIKey": MessageLookupByLibrary.simpleMessage("PaLM API 키"),
        "paLMAPIKeyErrorTitle":
            MessageLookupByLibrary.simpleMessage("PaLM API 키 오류"),
        "paLMAPIisInvalid": MessageLookupByLibrary.simpleMessage(
            "PaLM API 키가 유효하지 않습니다. 등록할 수 있는 페이지로 이동하시겠습니까?"),
        "paLMContextPromptHint": MessageLookupByLibrary.simpleMessage(
            "PaLM에게 어떤 것을 해야할지 가이드를 주는 프롬프트입니다. 예를 들면, \"롤플레잉을 해라\"라고 말하면, PaLM은 역할놀이 (롤플레잉)을 하려고 할 것입니다"),
        "paLMContextPromptLabel":
            MessageLookupByLibrary.simpleMessage("컨텍스트 프롬프트"),
        "paLMExampleInputHint":
            MessageLookupByLibrary.simpleMessage("예시 입력을 입력하세요"),
        "paLMExampleInputLabel": MessageLookupByLibrary.simpleMessage("예시 입력"),
        "paLMExampleOutputHint": MessageLookupByLibrary.simpleMessage(
            "예시 입력에 대하여 PaLM이 대답으로 생성하도록 권장할 예시 대답을 입력하세요"),
        "paLMExampleOutputLabel": MessageLookupByLibrary.simpleMessage("예시 대답"),
        "paLMExamplePromptHint": MessageLookupByLibrary.simpleMessage(
            "이 프롬프트는 PaLM에게 생성하도록 권장할 예시 대화를 제공합니다. 입력 및 대답 예시 프롬프트는 동시에 제공되어야 하니, 이 프롬프트를 입력하고 싶지 않으면 필드를 모두 비워 주세요"),
        "paLMExamplePromptLabel":
            MessageLookupByLibrary.simpleMessage("예시 대화 프롬프트"),
        "paLMKey": MessageLookupByLibrary.simpleMessage("PaLM API 키"),
        "pasteAPIKey": MessageLookupByLibrary.simpleMessage("API 키를 붙여넣으십시오."),
        "pasteImageURL": MessageLookupByLibrary.simpleMessage("이미지 URL 붙여넣기"),
        "privacyPolicy": MessageLookupByLibrary.simpleMessage("개인정보 처리방침"),
        "registerAPI": MessageLookupByLibrary.simpleMessage("등록하기"),
        "resetToDefaults": MessageLookupByLibrary.simpleMessage("기본값 초기화"),
        "savedInGallery":
            MessageLookupByLibrary.simpleMessage("V2 이미지가 갤러리에 저장되었습니다."),
        "searchCharacter": MessageLookupByLibrary.simpleMessage("캐릭터 명 검색"),
        "selectModel": MessageLookupByLibrary.simpleMessage("모델 선택"),
        "settingsPageTitle": MessageLookupByLibrary.simpleMessage("설정"),
        "signIn": MessageLookupByLibrary.simpleMessage("로그인"),
        "systemPrompt": MessageLookupByLibrary.simpleMessage("시스템 프롬프트"),
        "systemPromptHint": MessageLookupByLibrary.simpleMessage(
            "ChatGPT 에게 어떤 것을 해야할지 주입시키는 프롬프트입니다."),
        "temperatureLabel":
            MessageLookupByLibrary.simpleMessage("Temperature (랜덤성)"),
        "textIsPasted": MessageLookupByLibrary.simpleMessage("텍스트가 붙여넣기되었습니다."),
        "upload": MessageLookupByLibrary.simpleMessage("업로드"),
        "uploadImage": MessageLookupByLibrary.simpleMessage("이미지 업로드"),
        "usagePolicy": MessageLookupByLibrary.simpleMessage("사용자 정책"),
        "usagePolicy1Content": MessageLookupByLibrary.simpleMessage(
            "우리의 앱을 사용함으로써, 당신은 이 이용 정책을 수락하며 이에 따라 행동함을 확인합니다. 만약 이 정책에 동의하지 않는다면, 우리의 앱을 사용하면 안 됩니다. 이 이용 정책을 인쇄해 두는 것이 좋습니다."),
        "usagePolicy1Title":
            MessageLookupByLibrary.simpleMessage("1. 이용 정책의 수락"),
        "usagePolicy2Content": MessageLookupByLibrary.simpleMessage(
            "당신은 법적인 범주 내에서만 우리의 앱을 사용할 수 있습니다. 당신은 우리의 앱을 다음과 같은 방법으로 사용하면 안 됩니다:\n- 어떠한 현지, 국가, 또는 국제법이나 규정을 위반하는 방법.\n- 우리의 콘텐츠 기준에 부합하지 않는 재료를 보내거나, 받거나, 업로드하거나, 다운로드하거나, 사용하거나, 재사용하는 방법.\n- 원치 않는 광고나 프로모션 자료, 또는 비슷한 유형의 광고(스팸)를 보내거나 보내는 것을 도모하는 방법."),
        "usagePolicy2Title": MessageLookupByLibrary.simpleMessage("2. 금지된 사용"),
        "usagePolicy3Content": MessageLookupByLibrary.simpleMessage(
            "이 콘텐츠 기준은 우리 앱의 모든 사용자 생성 콘텐츠에 적용됩니다. 사용자 생성 콘텐츠는 다음을 포함하지 않아야 합니다:\n- 명예훼손, 음란, 공격적, 혐오스럽거나 선동적인 재료.\n- 성적으로 명시적인 재료, 폭력, 또는 인종, 성별, 종교, 국적, 장애, 성적 지향, 또는 나이에 기반한 차별을 촉진하는 것.\n- 다른 사람의 저작권, 데이터베이스 권리, 또는 상표를 침해하는 것.\n- 어떠한 사람도 속이려 하거나, 어떤 사람을 사칭하거나, 당신의 신원이나 소속을 잘못 표시하는데 사용되는 것.\n- 어떤 사람에게 속일 가능성이 있거나, 어떤 사람을 사칭하거나, 당신의 정체성 또는 어떤 사람과의 관련을 잘못 표시하는 것."),
        "usagePolicy3Title": MessageLookupByLibrary.simpleMessage("3. 콘텐츠 기준"),
        "usagePolicy4Content": MessageLookupByLibrary.simpleMessage(
            "이 이용 정책을 준수하지 않는 것은 우리 앱의 이용 약관에 대한 중대한 위반으로, 다음과 같은 조치를 취할 수 있습니다:\n- 당신이 우리 앱을 사용하는 권리를 즉각적으로, 일시적으로, 또는 영구적으로 철회함.\n- 위반으로 인한 모든 비용에 대한 법적 소송.\n- 당신에 대한 추가적인 법적 조치.\n우리는 이 이용 정책 위반에 대한 반응으로 취한 조치에 대한 책임을 부인합니다."),
        "usagePolicy4Title":
            MessageLookupByLibrary.simpleMessage("4. 이 이용 정책 위반"),
        "usagePolicy5Content": MessageLookupByLibrary.simpleMessage(
            "우리는 이 페이지를 수정함으로써 언제든지 이 이용 정책을 수정할 수 있습니다. 당신은 정기적으로 이 페이지를 확인하여 우리가 만든 변경 사항에 대해 알아야 하며, 그들은 당신에게 법적으로 구속력이 있습니다."),
        "usagePolicy5Title":
            MessageLookupByLibrary.simpleMessage("5. 이용 정책의 변경"),
        "usagePolicy6Content1": MessageLookupByLibrary.simpleMessage(
            "우리 앱의 서비스를 제공하기 위해, 우리는 ChatGPT의 API를 이용합니다. 따라서, 우리는 ChatGPT의 이용 정책을 준수합니다. ChatGPT의 이용 정책을 "),
        "usagePolicy6Content2": MessageLookupByLibrary.simpleMessage("여기서"),
        "usagePolicy6Content3": MessageLookupByLibrary.simpleMessage(
            " 확인할 수 있습니다. 우리 앱을 사용함으로써, 당신은 또한 ChatGPT의 이용 정책을 준수하는 것에 동의합니다.\n당신이 사용하는 제3자 서비스와 API, ChatGPT를 포함하여, 그것들은 해당 제3자 서비스에 적용되는 이용 약관, 개인정보 보호 정책, 그리고 다른 정책 및 합의에 의해 규제됩니다. 우리는 당신이 그 문서들을 주의 깊게 읽는 것을 권장합니다."),
        "usagePolicy6Title":
            MessageLookupByLibrary.simpleMessage("6. 제3자 서비스와 API"),
        "usagePolicyExplain": MessageLookupByLibrary.simpleMessage(
            "우리의 애플리케이션(\"앱\")은 사용자가 외부 API를 연결하여 텍스트 기반의 대화를 통해 가상 캐릭터와 소통할 수 있는 플랫폼을 제공합니다. 이 이용 정책은 우리의 앱을 사용하는데 있어서 당신의 행동을 규제합니다."),
        "usagePolicySubTitle":
            MessageLookupByLibrary.simpleMessage("AI 브리지 사용자 정책"),
        "usagePolicyTitle": MessageLookupByLibrary.simpleMessage("사용자 정책"),
        "userChatBoxBackgroundColor":
            MessageLookupByLibrary.simpleMessage("유저 채팅 배경 색상"),
        "userFontColor": MessageLookupByLibrary.simpleMessage("유저 폰트 색상"),
        "userFontSize": MessageLookupByLibrary.simpleMessage("유저 폰트 사이즈"),
        "yes": MessageLookupByLibrary.simpleMessage("예")
      };
}
