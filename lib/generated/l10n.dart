// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `AI Bridge`
  String get appTitle {
    return Intl.message(
      'AI Bridge',
      name: 'appTitle',
      desc: '',
      args: [],
    );
  }

  /// `API Key Management`
  String get keyPageTitle {
    return Intl.message(
      'API Key Management',
      name: 'keyPageTitle',
      desc: '',
      args: [],
    );
  }

  /// `Character`
  String get charactersPageTitle {
    return Intl.message(
      'Character',
      name: 'charactersPageTitle',
      desc: '',
      args: [],
    );
  }

  /// `Chat`
  String get chatRoomsPageTitle {
    return Intl.message(
      'Chat',
      name: 'chatRoomsPageTitle',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settingsPageTitle {
    return Intl.message(
      'Settings',
      name: 'settingsPageTitle',
      desc: '',
      args: [],
    );
  }

  /// `ChatGPT`
  String get chatGPT {
    return Intl.message(
      'ChatGPT',
      name: 'chatGPT',
      desc: '',
      args: [],
    );
  }

  /// `PaLM`
  String get paLM {
    return Intl.message(
      'PaLM',
      name: 'paLM',
      desc: '',
      args: [],
    );
  }

  /// `ChatGPT API`
  String get chatGPTAPI {
    return Intl.message(
      'ChatGPT API',
      name: 'chatGPTAPI',
      desc: '',
      args: [],
    );
  }

  /// `PaLM API`
  String get paLMAPI {
    return Intl.message(
      'PaLM API',
      name: 'paLMAPI',
      desc: '',
      args: [],
    );
  }

  /// `ChatGPT API Key`
  String get chatGPTKey {
    return Intl.message(
      'ChatGPT API Key',
      name: 'chatGPTKey',
      desc: '',
      args: [],
    );
  }

  /// `PaLM API Key`
  String get paLMKey {
    return Intl.message(
      'PaLM API Key',
      name: 'paLMKey',
      desc: '',
      args: [],
    );
  }

  /// `Paste the API key here`
  String get pasteAPIKey {
    return Intl.message(
      'Paste the API key here',
      name: 'pasteAPIKey',
      desc: '',
      args: [],
    );
  }

  /// `Never leak the API key to anywhere else!`
  String get neverLeakAPIKey {
    return Intl.message(
      'Never leak the API key to anywhere else!',
      name: 'neverLeakAPIKey',
      desc: '',
      args: [],
    );
  }

  /// `Register`
  String get registerAPI {
    return Intl.message(
      'Register',
      name: 'registerAPI',
      desc: '',
      args: [],
    );
  }

  /// ` is saved.`
  String get isSaved {
    return Intl.message(
      ' is saved.',
      name: 'isSaved',
      desc: '',
      args: [],
    );
  }

  /// `No Characters.`
  String get noCharacter {
    return Intl.message(
      'No Characters.',
      name: 'noCharacter',
      desc: '',
      args: [],
    );
  }

  /// `Edit Character`
  String get editCharacterOption {
    return Intl.message(
      'Edit Character',
      name: 'editCharacterOption',
      desc: '',
      args: [],
    );
  }

  /// `Delete Character`
  String get deleteCharacterOption {
    return Intl.message(
      'Delete Character',
      name: 'deleteCharacterOption',
      desc: '',
      args: [],
    );
  }

  /// `Confirm character deletion?\nAll chat history with this character will be lost!`
  String get deleteCharacterConfirm {
    return Intl.message(
      'Confirm character deletion?\nAll chat history with this character will be lost!',
      name: 'deleteCharacterConfirm',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Yes`
  String get yes {
    return Intl.message(
      'Yes',
      name: 'yes',
      desc: '',
      args: [],
    );
  }

  /// `New Character`
  String get newCharacter {
    return Intl.message(
      'New Character',
      name: 'newCharacter',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get editChatOption {
    return Intl.message(
      'Edit',
      name: 'editChatOption',
      desc: '',
      args: [],
    );
  }

  /// `Copy`
  String get copyChatOption {
    return Intl.message(
      'Copy',
      name: 'copyChatOption',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get deleteChatOption {
    return Intl.message(
      'Delete',
      name: 'deleteChatOption',
      desc: '',
      args: [],
    );
  }

  /// `Type your message...`
  String get chatInputHint {
    return Intl.message(
      'Type your message...',
      name: 'chatInputHint',
      desc: '',
      args: [],
    );
  }

  /// `Invalid ChatGPT API Key`
  String get chatGPTAPIKeyErrorTitle {
    return Intl.message(
      'Invalid ChatGPT API Key',
      name: 'chatGPTAPIKeyErrorTitle',
      desc: '',
      args: [],
    );
  }

  /// `Your ChatGPT API Key is not registered yet. Would you like to go to the page where you can register it?`
  String get chatGPTAPIisNotRegistered {
    return Intl.message(
      'Your ChatGPT API Key is not registered yet. Would you like to go to the page where you can register it?',
      name: 'chatGPTAPIisNotRegistered',
      desc: '',
      args: [],
    );
  }

  /// `Your ChatGPT API Key is invalid. Would you like to go to the page where you can register it?`
  String get chatGPTAPIisInvalid {
    return Intl.message(
      'Your ChatGPT API Key is invalid. Would you like to go to the page where you can register it?',
      name: 'chatGPTAPIisInvalid',
      desc: '',
      args: [],
    );
  }

  /// `PaLM API Key`
  String get paLMAPIKey {
    return Intl.message(
      'PaLM API Key',
      name: 'paLMAPIKey',
      desc: '',
      args: [],
    );
  }

  /// `Context Prompt`
  String get paLMContextPromptLabel {
    return Intl.message(
      'Context Prompt',
      name: 'paLMContextPromptLabel',
      desc: '',
      args: [],
    );
  }

  /// `Provide a prompt to guide PaLM on what you want it to do. For example, if you say "Do Role-playing" here, PaLM will do its best to role-play`
  String get paLMContextPromptHint {
    return Intl.message(
      'Provide a prompt to guide PaLM on what you want it to do. For example, if you say "Do Role-playing" here, PaLM will do its best to role-play',
      name: 'paLMContextPromptHint',
      desc: '',
      args: [],
    );
  }

  /// `Example Conversation Prompt`
  String get paLMExamplePromptLabel {
    return Intl.message(
      'Example Conversation Prompt',
      name: 'paLMExamplePromptLabel',
      desc: '',
      args: [],
    );
  }

  /// `This prompt gives PaLM an example of what it should generate in conversation. Both input and output example prompts must be provided simultaneously. If not, leave both fields empty`
  String get paLMExamplePromptHint {
    return Intl.message(
      'This prompt gives PaLM an example of what it should generate in conversation. Both input and output example prompts must be provided simultaneously. If not, leave both fields empty',
      name: 'paLMExamplePromptHint',
      desc: '',
      args: [],
    );
  }

  /// `Example Input`
  String get paLMExampleInputLabel {
    return Intl.message(
      'Example Input',
      name: 'paLMExampleInputLabel',
      desc: '',
      args: [],
    );
  }

  /// `Enter an example input for the conversation`
  String get paLMExampleInputHint {
    return Intl.message(
      'Enter an example input for the conversation',
      name: 'paLMExampleInputHint',
      desc: '',
      args: [],
    );
  }

  /// `Example Output`
  String get paLMExampleOutputLabel {
    return Intl.message(
      'Example Output',
      name: 'paLMExampleOutputLabel',
      desc: '',
      args: [],
    );
  }

  /// `Enter an example of what PaLM should generate as output`
  String get paLMExampleOutputHint {
    return Intl.message(
      'Enter an example of what PaLM should generate as output',
      name: 'paLMExampleOutputHint',
      desc: '',
      args: [],
    );
  }

  /// `Invalid PaLM API Key`
  String get paLMAPIKeyErrorTitle {
    return Intl.message(
      'Invalid PaLM API Key',
      name: 'paLMAPIKeyErrorTitle',
      desc: '',
      args: [],
    );
  }

  /// `Your PaLM API Key is invalid. Would you like to go to the page where you can register it?`
  String get paLMAPIisInvalid {
    return Intl.message(
      'Your PaLM API Key is invalid. Would you like to go to the page where you can register it?',
      name: 'paLMAPIisInvalid',
      desc: '',
      args: [],
    );
  }

  /// `Usage Policies`
  String get usagePolicyTitle {
    return Intl.message(
      'Usage Policies',
      name: 'usagePolicyTitle',
      desc: '',
      args: [],
    );
  }

  /// `AI Bridge Usage Policies`
  String get usagePolicySubTitle {
    return Intl.message(
      'AI Bridge Usage Policies',
      name: 'usagePolicySubTitle',
      desc: '',
      args: [],
    );
  }

  /// `Our application ("App") provides a platform for users to communicate with virtual characters through text-based conversations using external APIs. This Usage Policy governs your use of our App.`
  String get usagePolicyExplain {
    return Intl.message(
      'Our application ("App") provides a platform for users to communicate with virtual characters through text-based conversations using external APIs. This Usage Policy governs your use of our App.',
      name: 'usagePolicyExplain',
      desc: '',
      args: [],
    );
  }

  /// `1. Acceptance of Usage Policy`
  String get usagePolicy1Title {
    return Intl.message(
      '1. Acceptance of Usage Policy',
      name: 'usagePolicy1Title',
      desc: '',
      args: [],
    );
  }

  /// `By using our App, you confirm that you accept this Usage Policy and agree to comply with it. If you do not agree to this policy, you must not use our App. We recommend that you print a copy of this Usage Policy for future reference.`
  String get usagePolicy1Content {
    return Intl.message(
      'By using our App, you confirm that you accept this Usage Policy and agree to comply with it. If you do not agree to this policy, you must not use our App. We recommend that you print a copy of this Usage Policy for future reference.',
      name: 'usagePolicy1Content',
      desc: '',
      args: [],
    );
  }

  /// `2. Prohibited Uses`
  String get usagePolicy2Title {
    return Intl.message(
      '2. Prohibited Uses',
      name: 'usagePolicy2Title',
      desc: '',
      args: [],
    );
  }

  /// `You may use our App only for lawful purposes. You may not use our App:\n- In any way that breaches any applicable local, national or international law or regulation.\n- To send, knowingly receive, upload, download, use or re-use any material that does not comply with our content standards.\n- To transmit, or procure the sending of, any unsolicited or unauthorized advertising or promotional material or any other form of similar solicitation (spam).`
  String get usagePolicy2Content {
    return Intl.message(
      'You may use our App only for lawful purposes. You may not use our App:\n- In any way that breaches any applicable local, national or international law or regulation.\n- To send, knowingly receive, upload, download, use or re-use any material that does not comply with our content standards.\n- To transmit, or procure the sending of, any unsolicited or unauthorized advertising or promotional material or any other form of similar solicitation (spam).',
      name: 'usagePolicy2Content',
      desc: '',
      args: [],
    );
  }

  /// `3. Content Standards`
  String get usagePolicy3Title {
    return Intl.message(
      '3. Content Standards',
      name: 'usagePolicy3Title',
      desc: '',
      args: [],
    );
  }

  /// `These content standards apply to any and all user-generated content on our App. User-generated content must not:\n- Contain any material that is defamatory, obscene, offensive, hateful or inflammatory.\n- Promote sexually explicit material, violence or discrimination based on race, sex, religion, nationality, disability, sexual orientation or age.\n- Infringe any copyright, database right or trademark of any other person.\n- Be likely to deceive any person or be used to impersonate any person, or to misrepresent your identity or affiliation with any person.`
  String get usagePolicy3Content {
    return Intl.message(
      'These content standards apply to any and all user-generated content on our App. User-generated content must not:\n- Contain any material that is defamatory, obscene, offensive, hateful or inflammatory.\n- Promote sexually explicit material, violence or discrimination based on race, sex, religion, nationality, disability, sexual orientation or age.\n- Infringe any copyright, database right or trademark of any other person.\n- Be likely to deceive any person or be used to impersonate any person, or to misrepresent your identity or affiliation with any person.',
      name: 'usagePolicy3Content',
      desc: '',
      args: [],
    );
  }

  /// `4. Breach of This Usage Policy`
  String get usagePolicy4Title {
    return Intl.message(
      '4. Breach of This Usage Policy',
      name: 'usagePolicy4Title',
      desc: '',
      args: [],
    );
  }

  /// `Failure to comply with this Usage Policy constitutes a material breach of the terms of use upon which you are permitted to use our App, and may result in our taking all or any of the following actions:\n- Immediate, temporary or permanent withdrawal of your right to use our App.\n- Legal proceedings against you for reimbursement of all costs on an indemnity basis resulting from the breach.\n- Further legal action against you.\nWe exclude liability for actions taken in response to breaches of this Usage Policy.`
  String get usagePolicy4Content {
    return Intl.message(
      'Failure to comply with this Usage Policy constitutes a material breach of the terms of use upon which you are permitted to use our App, and may result in our taking all or any of the following actions:\n- Immediate, temporary or permanent withdrawal of your right to use our App.\n- Legal proceedings against you for reimbursement of all costs on an indemnity basis resulting from the breach.\n- Further legal action against you.\nWe exclude liability for actions taken in response to breaches of this Usage Policy.',
      name: 'usagePolicy4Content',
      desc: '',
      args: [],
    );
  }

  /// `5. Changes to the Usage Policy`
  String get usagePolicy5Title {
    return Intl.message(
      '5. Changes to the Usage Policy',
      name: 'usagePolicy5Title',
      desc: '',
      args: [],
    );
  }

  /// `We may revise this Usage Policy at any time by amending this page. You are expected to check this page regularly to take notice of any changes we made, as they are legally binding on you.`
  String get usagePolicy5Content {
    return Intl.message(
      'We may revise this Usage Policy at any time by amending this page. You are expected to check this page regularly to take notice of any changes we made, as they are legally binding on you.',
      name: 'usagePolicy5Content',
      desc: '',
      args: [],
    );
  }

  /// `6. Third-Party Services and APIs`
  String get usagePolicy6Title {
    return Intl.message(
      '6. Third-Party Services and APIs',
      name: 'usagePolicy6Title',
      desc: '',
      args: [],
    );
  }

  /// `In delivering the services of our App, we utilize the API of ChatGPT. Consequently, we adhere to the usage policies of ChatGPT. You can review the ChatGPT's Usage Policy `
  String get usagePolicy6Content1 {
    return Intl.message(
      'In delivering the services of our App, we utilize the API of ChatGPT. Consequently, we adhere to the usage policies of ChatGPT. You can review the ChatGPT\'s Usage Policy ',
      name: 'usagePolicy6Content1',
      desc: '',
      args: [],
    );
  }

  /// `here,`
  String get usagePolicy6Content2 {
    return Intl.message(
      'here,',
      name: 'usagePolicy6Content2',
      desc: '',
      args: [],
    );
  }

  /// ` By using our App, you also agree to abide by the usage policies of ChatGPT.\nYour use of third-party services and APIs, including ChatGPT, PaLM API is subject to the terms and conditions, privacy policies, and other policies and agreements applicable to such third-party services. We encourage you to read those documents carefully.`
  String get usagePolicy6Content3 {
    return Intl.message(
      ' By using our App, you also agree to abide by the usage policies of ChatGPT.\nYour use of third-party services and APIs, including ChatGPT, PaLM API is subject to the terms and conditions, privacy policies, and other policies and agreements applicable to such third-party services. We encourage you to read those documents carefully.',
      name: 'usagePolicy6Content3',
      desc: '',
      args: [],
    );
  }

  /// `Delete Chat Room`
  String get deleteChatroom {
    return Intl.message(
      'Delete Chat Room',
      name: 'deleteChatroom',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Chat deletion?\nAll chat history in this chatroom will be lost!`
  String get deleteChatroomConfirm {
    return Intl.message(
      'Confirm Chat deletion?\nAll chat history in this chatroom will be lost!',
      name: 'deleteChatroomConfirm',
      desc: '',
      args: [],
    );
  }

  /// `ChatRoom Settings`
  String get chatRoomSetting {
    return Intl.message(
      'ChatRoom Settings',
      name: 'chatRoomSetting',
      desc: '',
      args: [],
    );
  }

  /// `Enable Markdown Rendering`
  String get enableMarkdownRendering {
    return Intl.message(
      'Enable Markdown Rendering',
      name: 'enableMarkdownRendering',
      desc: '',
      args: [],
    );
  }

  /// `Font Size`
  String get fontSize {
    return Intl.message(
      'Font Size',
      name: 'fontSize',
      desc: '',
      args: [],
    );
  }

  /// `Character font size`
  String get characterFontSize {
    return Intl.message(
      'Character font size',
      name: 'characterFontSize',
      desc: '',
      args: [],
    );
  }

  /// `User font size`
  String get userFontSize {
    return Intl.message(
      'User font size',
      name: 'userFontSize',
      desc: '',
      args: [],
    );
  }

  /// `User font color`
  String get userFontColor {
    return Intl.message(
      'User font color',
      name: 'userFontColor',
      desc: '',
      args: [],
    );
  }

  /// `CharacterFontColor`
  String get characterFontColor {
    return Intl.message(
      'CharacterFontColor',
      name: 'characterFontColor',
      desc: '',
      args: [],
    );
  }

  /// `User's ChatBox Background Color`
  String get userChatBoxBackgroundColor {
    return Intl.message(
      'User\'s ChatBox Background Color',
      name: 'userChatBoxBackgroundColor',
      desc: '',
      args: [],
    );
  }

  /// `Character's ChatBox Background Color`
  String get characterChatBoxBackgroundColor {
    return Intl.message(
      'Character\'s ChatBox Background Color',
      name: 'characterChatBoxBackgroundColor',
      desc: '',
      args: [],
    );
  }

  /// `ChatRoom Background Color`
  String get chatroomBackgroundColor {
    return Intl.message(
      'ChatRoom Background Color',
      name: 'chatroomBackgroundColor',
      desc: '',
      args: [],
    );
  }

  /// `Colors`
  String get colors {
    return Intl.message(
      'Colors',
      name: 'colors',
      desc: '',
      args: [],
    );
  }

  /// `Reset to Defaults`
  String get resetToDefaults {
    return Intl.message(
      'Reset to Defaults',
      name: 'resetToDefaults',
      desc: '',
      args: [],
    );
  }

  /// `Privacy Policy`
  String get privacyPolicy {
    return Intl.message(
      'Privacy Policy',
      name: 'privacyPolicy',
      desc: '',
      args: [],
    );
  }

  /// `Usage Policies`
  String get usagePolicy {
    return Intl.message(
      'Usage Policies',
      name: 'usagePolicy',
      desc: '',
      args: [],
    );
  }

  /// `Text has been pasted.`
  String get textIsPasted {
    return Intl.message(
      'Text has been pasted.',
      name: 'textIsPasted',
      desc: '',
      args: [],
    );
  }

  /// `System Prompt`
  String get systemPrompt {
    return Intl.message(
      'System Prompt',
      name: 'systemPrompt',
      desc: '',
      args: [],
    );
  }

  /// `Provide a prompt to instruct ChatGPT on what you want it to do.`
  String get systemPromptHint {
    return Intl.message(
      'Provide a prompt to instruct ChatGPT on what you want it to do.',
      name: 'systemPromptHint',
      desc: '',
      args: [],
    );
  }

  /// `Select Model`
  String get selectModel {
    return Intl.message(
      'Select Model',
      name: 'selectModel',
      desc: '',
      args: [],
    );
  }

  /// `The name by which you will be recognized`
  String get characterRecognizeUserName {
    return Intl.message(
      'The name by which you will be recognized',
      name: 'characterRecognizeUserName',
      desc: '',
      args: [],
    );
  }

  /// `This is replaced by <user> in the prompts.`
  String get characterRecognizeUserNameHint {
    return Intl.message(
      'This is replaced by <user> in the prompts.',
      name: 'characterRecognizeUserNameHint',
      desc: '',
      args: [],
    );
  }

  /// `Character's First Message`
  String get firstMessageLabel {
    return Intl.message(
      'Character\'s First Message',
      name: 'firstMessageLabel',
      desc: '',
      args: [],
    );
  }

  /// `Customize Character's first message if you wish, or leave it empty if you prefer not to.`
  String get firstMessageHint {
    return Intl.message(
      'Customize Character\'s first message if you wish, or leave it empty if you prefer not to.',
      name: 'firstMessageHint',
      desc: '',
      args: [],
    );
  }

  /// `Temperature (Randomness)`
  String get temperatureLabel {
    return Intl.message(
      'Temperature (Randomness)',
      name: 'temperatureLabel',
      desc: '',
      args: [],
    );
  }

  /// `Done`
  String get done {
    return Intl.message(
      'Done',
      name: 'done',
      desc: '',
      args: [],
    );
  }

  /// `Chat`
  String get chatOption {
    return Intl.message(
      'Chat',
      name: 'chatOption',
      desc: '',
      args: [],
    );
  }

  /// `Edit Profile`
  String get editProfile {
    return Intl.message(
      'Edit Profile',
      name: 'editProfile',
      desc: '',
      args: [],
    );
  }

  /// `Search character name`
  String get searchCharacter {
    return Intl.message(
      'Search character name',
      name: 'searchCharacter',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get deleteOption {
    return Intl.message(
      'Delete',
      name: 'deleteOption',
      desc: '',
      args: [],
    );
  }

  /// `Checking API Keys..`
  String get checkingAPIKeys {
    return Intl.message(
      'Checking API Keys..',
      name: 'checkingAPIKeys',
      desc: '',
      args: [],
    );
  }

  /// `Initializing Tokenizer..`
  String get InitializingTokenizer {
    return Intl.message(
      'Initializing Tokenizer..',
      name: 'InitializingTokenizer',
      desc: '',
      args: [],
    );
  }

  /// `This feature is supported for GPT-4 Vision only.`
  String get gpt4VisionOnly {
    return Intl.message(
      'This feature is supported for GPT-4 Vision only.',
      name: 'gpt4VisionOnly',
      desc: '',
      args: [],
    );
  }

  /// `Upload image`
  String get uploadImage {
    return Intl.message(
      'Upload image',
      name: 'uploadImage',
      desc: '',
      args: [],
    );
  }

  /// `Paste the URL of the image`
  String get pasteImageURL {
    return Intl.message(
      'Paste the URL of the image',
      name: 'pasteImageURL',
      desc: '',
      args: [],
    );
  }

  /// `Upload`
  String get upload {
    return Intl.message(
      'Upload',
      name: 'upload',
      desc: '',
      args: [],
    );
  }

  /// `Image`
  String get image {
    return Intl.message(
      'Image',
      name: 'image',
      desc: '',
      args: [],
    );
  }

  /// `Character A`
  String get defaultCharacterName {
    return Intl.message(
      'Character A',
      name: 'defaultCharacterName',
      desc: '',
      args: [],
    );
  }

  /// `Hi! What are you doing?`
  String get defaultCharacterFirstMessage {
    return Intl.message(
      'Hi! What are you doing?',
      name: 'defaultCharacterFirstMessage',
      desc: '',
      args: [],
    );
  }

  /// `Write <char>'s reply in a chat between <char> and <user>.`
  String get defaultCharacterSystemPrompt {
    return Intl.message(
      'Write <char>\'s reply in a chat between <char> and <user>.',
      name: 'defaultCharacterSystemPrompt',
      desc: '',
      args: [],
    );
  }

  /// `<char> has a very friendly personality. <char> wants to know many things about <user>.`
  String get defaultCharacterPersonalityPrompt {
    return Intl.message(
      '<char> has a very friendly personality. <char> wants to know many things about <user>.',
      name: 'defaultCharacterPersonalityPrompt',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message(
      'Name',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  /// `This is replaced by <char> in the prompts.`
  String get characterNameHint {
    return Intl.message(
      'This is replaced by <char> in the prompts.',
      name: 'characterNameHint',
      desc: '',
      args: [],
    );
  }

  /// `Background`
  String get background {
    return Intl.message(
      'Background',
      name: 'background',
      desc: '',
      args: [],
    );
  }

  /// `Export`
  String get export {
    return Intl.message(
      'Export',
      name: 'export',
      desc: '',
      args: [],
    );
  }

  /// `Import`
  String get import {
    return Intl.message(
      'Import',
      name: 'import',
      desc: '',
      args: [],
    );
  }

  /// `The image is not the correct V2 card format.`
  String get failedToImport {
    return Intl.message(
      'The image is not the correct V2 card format.',
      name: 'failedToImport',
      desc: '',
      args: [],
    );
  }

  /// `The image has been saved to the Gallery.`
  String get savedInGallery {
    return Intl.message(
      'The image has been saved to the Gallery.',
      name: 'savedInGallery',
      desc: '',
      args: [],
    );
  }

  /// `Description`
  String get description {
    return Intl.message(
      'Description',
      name: 'description',
      desc: '',
      args: [],
    );
  }

  /// `This is the prompt for the character's description.`
  String get descriptionHint {
    return Intl.message(
      'This is the prompt for the character\'s description.',
      name: 'descriptionHint',
      desc: '',
      args: [],
    );
  }

  /// `Dark Theme`
  String get darkTheme {
    return Intl.message(
      'Dark Theme',
      name: 'darkTheme',
      desc: '',
      args: [],
    );
  }

  /// `Light Theme`
  String get lightTheme {
    return Intl.message(
      'Light Theme',
      name: 'lightTheme',
      desc: '',
      args: [],
    );
  }

  /// `Sign in`
  String get signIn {
    return Intl.message(
      'Sign in',
      name: 'signIn',
      desc: '',
      args: [],
    );
  }

  /// `Sign in with Google`
  String get googleSignIn {
    return Intl.message(
      'Sign in with Google',
      name: 'googleSignIn',
      desc: '',
      args: [],
    );
  }

  /// `Sign in with Apple`
  String get appleSignIn {
    return Intl.message(
      'Sign in with Apple',
      name: 'appleSignIn',
      desc: '',
      args: [],
    );
  }

  /// `Backup Data`
  String get backupData {
    return Intl.message(
      'Backup Data',
      name: 'backupData',
      desc: '',
      args: [],
    );
  }

  /// `Load Data`
  String get loadData {
    return Intl.message(
      'Load Data',
      name: 'loadData',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ja'),
      Locale.fromSubtags(languageCode: 'ko'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
