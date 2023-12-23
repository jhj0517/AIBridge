import 'package:flutter/material.dart';

import '../constants/sharedpreference_constants.dart';
import '../constants/color_constants.dart';

class ChatRoomSetting{
  bool isRenderMarkdown;
  double characterFontSize;
  double userFontSize;
  Color characterFontColor;
  Color userFontColor;
  Color characterChatBoxBackgroundColor;
  Color userChatBoxBackgroundColor;
  Color chatRoomBackgroundColor;

  ChatRoomSetting({
    required this.isRenderMarkdown,
    required this.characterFontSize,
    required this.userFontSize,
    required this.characterFontColor,
    required this.userFontColor,
    required this.characterChatBoxBackgroundColor,
    required this.userChatBoxBackgroundColor,
    required this.chatRoomBackgroundColor,
  });

  // Setters
  set setIsRenderMarkdown(bool value) => isRenderMarkdown = value;
  set setCharacterFontSize(double value) => characterFontSize = value;
  set setUserFontSize(double value) => userFontSize = value;
  set setCharacterFontColor(Color value) => characterFontColor = value;
  set setUserFontColor(Color value) => userFontColor = value;
  set setCharacterChatBoxBackgroundColor(Color value) => characterChatBoxBackgroundColor = value;
  set setUserChatBoxBackgroundColor(Color value) => userChatBoxBackgroundColor = value;
  set setChatRoomBackgroundColor(Color value) => chatRoomBackgroundColor = value;

  ChatRoomSetting.copy(ChatRoomSetting other)
      : isRenderMarkdown = other.isRenderMarkdown,
        characterFontSize = other.characterFontSize,
        userFontSize = other.userFontSize,
        characterFontColor = other.characterFontColor,
        userFontColor = other.userFontColor,
        characterChatBoxBackgroundColor = other.characterChatBoxBackgroundColor,
        userChatBoxBackgroundColor = other.userChatBoxBackgroundColor,
        chatRoomBackgroundColor = other.chatRoomBackgroundColor;

  Map<String, dynamic> toJson() {
    return {
      SharedPreferenceConstants.settingIsRenderMarkdown: isRenderMarkdown,
      SharedPreferenceConstants.settingCharacterFontSize: characterFontSize,
      SharedPreferenceConstants.settingUserFontSize: userFontSize,
      SharedPreferenceConstants.settingCharacterFontColor: characterFontColor.value,
      SharedPreferenceConstants.settingUserFontColor: userFontColor.value,
      SharedPreferenceConstants.settingCharacterChatBoxBackgroundColor: characterChatBoxBackgroundColor.value,
      SharedPreferenceConstants.settingUserChatBoxBackgroundColor: userChatBoxBackgroundColor.value,
      SharedPreferenceConstants.settingChatRoomBackgroundColor: chatRoomBackgroundColor.value,
    };
  }

  factory ChatRoomSetting.fromJson(Map<String, dynamic> json) {
    return ChatRoomSetting(
      isRenderMarkdown: json[SharedPreferenceConstants.settingIsRenderMarkdown],
      characterFontSize: json[SharedPreferenceConstants.settingCharacterFontSize],
      userFontSize: json[SharedPreferenceConstants.settingUserFontSize],
      characterFontColor: Color(json[SharedPreferenceConstants.settingCharacterFontColor]),
      userFontColor: Color(json[SharedPreferenceConstants.settingUserFontColor]),
      characterChatBoxBackgroundColor: Color(json[SharedPreferenceConstants.settingCharacterChatBoxBackgroundColor]),
      userChatBoxBackgroundColor: Color(json[SharedPreferenceConstants.settingUserChatBoxBackgroundColor]),
      chatRoomBackgroundColor: Color(json[SharedPreferenceConstants.settingChatRoomBackgroundColor]),
    );
  }

  factory ChatRoomSetting.defaultChatRoomSetting() {
    return ChatRoomSetting(
      isRenderMarkdown: true,
      characterFontSize: 16,
      userFontSize: 16,
      characterFontColor: Colors.black,
      userFontColor: Colors.white,
      characterChatBoxBackgroundColor: ColorConstants.defaultCharacterChatBoxColor,
      userChatBoxBackgroundColor: ColorConstants.defaultUserChatBoxColor,
      chatRoomBackgroundColor: Colors.white,
    );
  }
}