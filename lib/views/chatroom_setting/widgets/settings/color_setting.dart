import 'package:aibridge/views/chatroom_setting/widgets/settings/color_setting_tile.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:aibridge/models/chatroom_settings.dart'
;
class ColorSetting extends StatefulWidget {
  final ChatRoomSetting currentSetting;

  const ColorSetting({super.key, required this.currentSetting});

  @override
  ColorSettingState createState() => ColorSettingState();
}

class ColorSettingState extends State<ColorSetting> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(Intl.message("colors"), style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 10),
        ColorSettingTile(
          title: Intl.message("characterFontColor"),
          currentColor: widget.currentSetting.characterFontColor,
          onColorChanged: (selectedColor) {
            widget.currentSetting.setCharacterFontColor = selectedColor;
          }
        ),
        ColorSettingTile(
            title: Intl.message("userFontColor"),
            currentColor: widget.currentSetting.userFontColor,
            onColorChanged: (selectedColor) {
              widget.currentSetting.setUserFontColor = selectedColor;
            }
        ),
        ColorSettingTile(
            title: Intl.message("characterChatBoxBackgroundColor"),
            currentColor: widget.currentSetting.characterChatBoxBackgroundColor,
            onColorChanged: (selectedColor) {
              widget.currentSetting.setCharacterChatBoxBackgroundColor = selectedColor;
            }
        ),
        ColorSettingTile(
            title: Intl.message("userChatBoxBackgroundColor"),
            currentColor: widget.currentSetting.userChatBoxBackgroundColor,
            onColorChanged: (selectedColor) {
              widget.currentSetting.userChatBoxBackgroundColor = selectedColor;
            }
        ),
        ColorSettingTile(
            title: Intl.message("chatroomBackgroundColor"),
            currentColor: widget.currentSetting.chatRoomBackgroundColor,
            onColorChanged: (selectedColor) {
              widget.currentSetting.setChatRoomBackgroundColor = selectedColor;
            }
        ),
      ],
    );
  }
}