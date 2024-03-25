// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ja locale. All the
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
  String get localeName => 'ja';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "InitializingTokenizer":
            MessageLookupByLibrary.simpleMessage("トークナイザーの初期化.."),
        "appTitle": MessageLookupByLibrary.simpleMessage("AIブリッジ"),
        "appleSignIn":
            MessageLookupByLibrary.simpleMessage("Sign in with Apple"),
        "background": MessageLookupByLibrary.simpleMessage("背景"),
        "backupData": MessageLookupByLibrary.simpleMessage("Backup Data"),
        "cancel": MessageLookupByLibrary.simpleMessage("キャンセル"),
        "characterChatBoxBackgroundColor":
            MessageLookupByLibrary.simpleMessage("キャラクターのチャットボックス背景色"),
        "characterFontColor":
            MessageLookupByLibrary.simpleMessage("キャラクターのフォントカラー"),
        "characterFontSize":
            MessageLookupByLibrary.simpleMessage("キャラクターのフォントサイズ"),
        "characterNameHint":
            MessageLookupByLibrary.simpleMessage("これはプロンプトでは<char>に置き換えられる。"),
        "characterRecognizeUserName":
            MessageLookupByLibrary.simpleMessage("あなたが認識される名前"),
        "characterRecognizeUserNameHint":
            MessageLookupByLibrary.simpleMessage("これはプロンプトでは<user>に置き換えられる。"),
        "charactersPageTitle": MessageLookupByLibrary.simpleMessage("キャラクター"),
        "chatGPT": MessageLookupByLibrary.simpleMessage("ChatGPT"),
        "chatGPTAPI": MessageLookupByLibrary.simpleMessage("ChatGPT API"),
        "chatGPTAPIKeyErrorTitle":
            MessageLookupByLibrary.simpleMessage("無効なChatGPT APIキー"),
        "chatGPTAPIisInvalid": MessageLookupByLibrary.simpleMessage(
            "ChatGPT APIキーが無効です。登録できるページに移動しますか?"),
        "chatGPTAPIisNotRegistered": MessageLookupByLibrary.simpleMessage(
            "ChatGPT APIキーはまだ登録されていません。登録できるページに移動しますか？"),
        "chatGPTKey": MessageLookupByLibrary.simpleMessage("ChatGPT API キー"),
        "chatInputHint": MessageLookupByLibrary.simpleMessage("メッセージを入力..."),
        "chatOption": MessageLookupByLibrary.simpleMessage("チャット"),
        "chatRoomSetting": MessageLookupByLibrary.simpleMessage("チャットルームの設定"),
        "chatRoomsPageTitle": MessageLookupByLibrary.simpleMessage("チャット"),
        "chatroomBackgroundColor":
            MessageLookupByLibrary.simpleMessage("チャットルームの背景色"),
        "checkingAPIKeys": MessageLookupByLibrary.simpleMessage("APIキーのチェック.."),
        "colors": MessageLookupByLibrary.simpleMessage("色相"),
        "copyChatOption": MessageLookupByLibrary.simpleMessage("コピー"),
        "darkTheme": MessageLookupByLibrary.simpleMessage("ダークテーマ"),
        "defaultCharacterFirstMessage":
            MessageLookupByLibrary.simpleMessage("こんにちは！ 何してるの？"),
        "defaultCharacterName": MessageLookupByLibrary.simpleMessage("キャラクターA"),
        "defaultCharacterPersonalityPrompt": MessageLookupByLibrary.simpleMessage(
            "<char> has a very friendly personality. <char> wants to know many things about <user>."),
        "defaultCharacterSystemPrompt": MessageLookupByLibrary.simpleMessage(
            "Write <char>\'s reply in a chat between <char> and <user>."),
        "deleteCharacterConfirm": MessageLookupByLibrary.simpleMessage(
            "キャラクター削除を確認しますか？\nこのキャラクターとのチャット履歴はすべて失われます！"),
        "deleteCharacterOption":
            MessageLookupByLibrary.simpleMessage("キャラクターの削除"),
        "deleteChatOption": MessageLookupByLibrary.simpleMessage("削除"),
        "deleteChatroom": MessageLookupByLibrary.simpleMessage("チャットを削除"),
        "deleteChatroomConfirm": MessageLookupByLibrary.simpleMessage(
            "チャットの削除を確認しますか？\nすべてのチャット履歴が失われます！"),
        "deleteOption": MessageLookupByLibrary.simpleMessage("削除"),
        "description": MessageLookupByLibrary.simpleMessage("説明"),
        "descriptionHint":
            MessageLookupByLibrary.simpleMessage("これはキャラクターの説明のためのプロンプトです。"),
        "done": MessageLookupByLibrary.simpleMessage("完了"),
        "editCharacterOption": MessageLookupByLibrary.simpleMessage("編集キャラクター"),
        "editChatOption": MessageLookupByLibrary.simpleMessage("編集"),
        "editProfile": MessageLookupByLibrary.simpleMessage("プロフィール編集"),
        "enableMarkdownRendering":
            MessageLookupByLibrary.simpleMessage("マークダウンを有効"),
        "export": MessageLookupByLibrary.simpleMessage("輸出"),
        "failedToImport":
            MessageLookupByLibrary.simpleMessage("画像が正しいV2カード形式ではありません。"),
        "firstMessageHint": MessageLookupByLibrary.simpleMessage(
            "キャラクターの最初のメッセージはカスタマイズすることもできます。"),
        "firstMessageLabel":
            MessageLookupByLibrary.simpleMessage("キャラクターのファーストメッセージ"),
        "fontSize": MessageLookupByLibrary.simpleMessage("フォントサイズ"),
        "googleSignIn":
            MessageLookupByLibrary.simpleMessage("Sign in with Google"),
        "gpt4VisionOnly": MessageLookupByLibrary.simpleMessage(
            "この機能は「GPT-4 Vision」のみに対応しています。"),
        "image": MessageLookupByLibrary.simpleMessage("画像"),
        "import": MessageLookupByLibrary.simpleMessage("輸入"),
        "isSaved": MessageLookupByLibrary.simpleMessage("が保存されました."),
        "keyPageTitle": MessageLookupByLibrary.simpleMessage("API キー管理"),
        "lightTheme": MessageLookupByLibrary.simpleMessage("ライトテーマ"),
        "loadData": MessageLookupByLibrary.simpleMessage("Load Data"),
        "name": MessageLookupByLibrary.simpleMessage("Name"),
        "neverLeakAPIKey":
            MessageLookupByLibrary.simpleMessage("APIキーを他へ漏らさないこと！"),
        "newCharacter": MessageLookupByLibrary.simpleMessage("新キャラクター"),
        "noCharacter": MessageLookupByLibrary.simpleMessage("登場人物はいない"),
        "paLM": MessageLookupByLibrary.simpleMessage("PaLM"),
        "paLMAPI": MessageLookupByLibrary.simpleMessage("PaLM API"),
        "paLMAPIKey": MessageLookupByLibrary.simpleMessage("PaLM API キー"),
        "paLMAPIKeyErrorTitle":
            MessageLookupByLibrary.simpleMessage("無効なPaLM APIキー"),
        "paLMAPIisInvalid": MessageLookupByLibrary.simpleMessage(
            "あなたのPaLM APIキーは無効です。それを登録することができるページに行きたいですか？"),
        "paLMContextPromptHint": MessageLookupByLibrary.simpleMessage(
            "PaLMに何をすべきか指示するためのプロンプトです。例えば、「ロールプレイをしろ」と指示すると、PaLMはロールプレイング（ロールプレイ）を試みます。"),
        "paLMContextPromptLabel":
            MessageLookupByLibrary.simpleMessage("コンテキストプロンプト"),
        "paLMExampleInputHint":
            MessageLookupByLibrary.simpleMessage("サンプル入力を記入してください。"),
        "paLMExampleInputLabel": MessageLookupByLibrary.simpleMessage("サンプル入力"),
        "paLMExampleOutputHint": MessageLookupByLibrary.simpleMessage(
            "サンプル入力に対してPaLMが回答として生成するように推奨するサンプルの回答を記入してください。"),
        "paLMExampleOutputLabel":
            MessageLookupByLibrary.simpleMessage("サンプル回答"),
        "paLMExamplePromptHint": MessageLookupByLibrary.simpleMessage(
            "このプロンプトは、PaLMに生成するように推奨するサンプルの会話を提供します。入力と回答のサンプルプロンプトは同時に提供する必要があります。このプロンプトを入力したくない場合は、フィールドをすべて空にしてください。"),
        "paLMExamplePromptLabel":
            MessageLookupByLibrary.simpleMessage("サンプル会話プロンプト"),
        "paLMKey": MessageLookupByLibrary.simpleMessage("PaLM API キー"),
        "pasteAPIKey": MessageLookupByLibrary.simpleMessage("APIキーをここに貼り付ける"),
        "pasteImageURL": MessageLookupByLibrary.simpleMessage("画像のURLを貼り付ける"),
        "privacyPolicy": MessageLookupByLibrary.simpleMessage("プライバシーポリシー"),
        "registerAPI": MessageLookupByLibrary.simpleMessage("登録"),
        "resetToDefaults": MessageLookupByLibrary.simpleMessage("デフォルトの初期化"),
        "savedInGallery":
            MessageLookupByLibrary.simpleMessage("画像がギャラリーに保存されました。"),
        "searchCharacter": MessageLookupByLibrary.simpleMessage("キャラクター名を検索"),
        "selectModel": MessageLookupByLibrary.simpleMessage("モデルを選択"),
        "settingsPageTitle": MessageLookupByLibrary.simpleMessage("設定"),
        "signIn": MessageLookupByLibrary.simpleMessage("Sign in"),
        "systemPrompt": MessageLookupByLibrary.simpleMessage("システムプロンプト"),
        "systemPromptHint": MessageLookupByLibrary.simpleMessage(
            "ChatGPT に何をさせたいかを指示するプロンプトを表示します。"),
        "temperatureLabel":
            MessageLookupByLibrary.simpleMessage("Temperature（ランダム性）"),
        "textIsPasted": MessageLookupByLibrary.simpleMessage("テキストを貼り付けました。"),
        "upload": MessageLookupByLibrary.simpleMessage("アップロード"),
        "uploadImage": MessageLookupByLibrary.simpleMessage("画像のアップロード"),
        "usagePolicy": MessageLookupByLibrary.simpleMessage("利用規約"),
        "usagePolicy1Content": MessageLookupByLibrary.simpleMessage(
            "当社のアプリを利用することで、あなたはこの利用規約を承認し、それに従うことに同意したことになります。このポリシーに同意できない場合は、当社のアプリを利用することはできません。将来参照するために、この利用規約のコピーを印刷することをお勧めします。"),
        "usagePolicy1Title": MessageLookupByLibrary.simpleMessage("1. 利用規約の承認"),
        "usagePolicy2Content": MessageLookupByLibrary.simpleMessage(
            "当社のアプリは、法的に許可された目的のみで使用することができます。あなたは当社のアプリを次のような目的で使用してはなりません：\n- 適用可能な地方、国内、国際法または規制に違反する方法で。\n- 内容規定に違反するマテリアルを送信、受信、アップロード、ダウンロード、使用、または再使用する。\n- 承認されていない広告や宣伝材料、または他の類似した勧誘（スパム）の送信または送信の手配を行う。"),
        "usagePolicy2Title": MessageLookupByLibrary.simpleMessage("2. 禁止事項"),
        "usagePolicy3Content": MessageLookupByLibrary.simpleMessage(
            "これらのコンテンツ基準は、アプリのすべてのユーザー生成コンテンツに適用されます。ユーザー生成コンテンツは以下を含んではいけません：\n- 名誉毀損的、わいせつ的、攻撃的、憎悪的、または炎上を引き起こす可能性のある素材。\n- 性的に露骨な素材、暴力、または人種、性別、宗教、国籍、障害、性的指向、年齢に基づく差別を促進するもの。\n- 他の人の著作権、データベースの権利、または商標を侵害するもの。\n- 他人を欺く可能性がある、または他人にな"),
        "usagePolicy3Title": MessageLookupByLibrary.simpleMessage("3. コンテンツ基準"),
        "usagePolicy4Content": MessageLookupByLibrary.simpleMessage(
            "この利用規約に違反した場合、それはあなたが私たちのアプリを利用するために許可されている利用規約の重大な違反を構成し、私たちは以下の全てまたはいずれかの行動を取る可能性があります：\n- あなたのアプリ利用権の即時、一時的、または恒久的な取り消し。\n- 違反から生じた全費用の補償基準に基づく法的手続き。\n- あなたに対するさらなる法的行動。\n私たちは、この利用規約の違反に対する対応として取られた行動に対する責任を排除します。"),
        "usagePolicy4Title":
            MessageLookupByLibrary.simpleMessage("4. この利用規約の違反"),
        "usagePolicy5Content": MessageLookupByLibrary.simpleMessage(
            "私たちはこのページを修正することにより、いつでもこの利用規約を改訂することができます。あなたは定期的にこのページを確認し、我々が行った変更を確認することが期待されます。これらは法的にあなたに対して拘束力があります。"),
        "usagePolicy5Title": MessageLookupByLibrary.simpleMessage("5. 利用規約の変更"),
        "usagePolicy6Content1": MessageLookupByLibrary.simpleMessage(
            "私たちのアプリのサービスを提供する上で、私たちはChatGPTのAPIを利用しています。したがって、私たちはChatGPTの利用規約に従っています。ChatGPTの利用規約は "),
        "usagePolicy6Content2": MessageLookupByLibrary.simpleMessage("こちら"),
        "usagePolicy6Content3": MessageLookupByLibrary.simpleMessage(
            "で確認することができます。当社のアプリを利用することで、あなたはまた、ChatGPTの利用規約を遵守することに同意します。\nあなたが第三者のサービスやAPIを利用することは、そのような第三者サービスに適用される利用規約、プライバシーポリシー、その他のポリシーと契約に従うことを含みます。それらの文書を注意深く読むことをお勧めします。"),
        "usagePolicy6Title":
            MessageLookupByLibrary.simpleMessage("6. 第三者のサービスとAPI"),
        "usagePolicyExplain": MessageLookupByLibrary.simpleMessage(
            "私たちのアプリケーション（「アプリ」）は、ユーザーがテキストベースの会話を通じてバーチャルキャラクターとコミュニケーションを取るためのプラットフォームを提供します。この利用規約は、私たちのアプリの利用を規定します。"),
        "usagePolicySubTitle":
            MessageLookupByLibrary.simpleMessage("AIブリッジ利用規約"),
        "usagePolicyTitle": MessageLookupByLibrary.simpleMessage("利用規約"),
        "userChatBoxBackgroundColor":
            MessageLookupByLibrary.simpleMessage("ユーザーのチャットボックス背景色"),
        "userFontColor": MessageLookupByLibrary.simpleMessage("ユーザーのフォントカラー"),
        "userFontSize": MessageLookupByLibrary.simpleMessage("ユーザーのフォントサイズ"),
        "yes": MessageLookupByLibrary.simpleMessage("はい")
      };
}
