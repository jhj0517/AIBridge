import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../providers/providers.dart';
import '../../models/chatroom_settings.dart';
import '../common/loading/loading_view.dart';
import 'widgets/settings/font_size_setting.dart';
import 'widgets/appbars/chatroom_setting_app_bar.dart';
import 'widgets/settings/markdown_render_setting.dart';
import 'widgets/settings/color_setting.dart';

class ChatRoomSettingPage extends StatefulWidget {
  const ChatRoomSettingPage({Key? key}) : super(key: key);

  @override
  ChatRoomSettingPageState createState() => ChatRoomSettingPageState();
}

class ChatRoomSettingPageState extends State<ChatRoomSettingPage> {

  bool _isLoading = true;
  late ChatRoomsProvider chatRoomsProvider;
  ChatRoomSetting? currentSettings;

  @override
  void initState() {
    super.initState();
    chatRoomsProvider = context.read<ChatRoomsProvider>();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _init();
    });
  }

  Future<void> _init() async {
    await chatRoomsProvider.readChatRoomSetting(context);
    setState(() {
      currentSettings = ChatRoomSetting.copy(chatRoomsProvider.chatRoomSetting!);
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: ChatRoomSettingAppBar(currentSettings: currentSettings!),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  elevation: 3.0,
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: MarkdownRenderSetting(currentSetting: currentSettings!),
                  ),
                ),
                const SizedBox(height: 10),
                Card(
                  elevation: 3.0,
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: FontSizeSetting(currentSetting: currentSettings!),
                  ),
                ),
                const SizedBox(height: 10),
                Card(
                  elevation: 3.0,
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: ColorSetting(currentSetting: currentSettings!),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _resetToDefaults,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).textTheme.bodyMedium!.color,
                  ),
                  child: Text(
                    Intl.message("resetToDefaults"),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.background,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
          Positioned(
            child: _isLoading ? const LoadingView() : const SizedBox.shrink(),
          )
        ],
      ),
    );
  }

  void _resetToDefaults() {
    currentSettings = ChatRoomSetting.defaultChatRoomSetting(context);
    setState(() {});
  }
}

// class MarkdownRenderSetting extends StatefulWidget {
//   final ChatRoomSetting currentSetting;
//
//   const MarkdownRenderSetting({super.key, required this.currentSetting});
//
//   @override
//   MarkdownRenderSettingState createState() => MarkdownRenderSettingState();
// }
//
// class MarkdownRenderSettingState extends State<MarkdownRenderSetting> {
//   late bool isRenderMarkdown;
//
//   @override
//   void initState() {
//     super.initState();
//     isRenderMarkdown = widget.currentSetting.isRenderMarkdown;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SwitchListTile(
//       title: Text(Intl.message("enableMarkdownRendering")),
//       value: widget.currentSetting.isRenderMarkdown,
//       onChanged: (bool value) {
//         setState(() {
//           widget.currentSetting.setIsRenderMarkdown = value;
//         });
//       },
//       activeColor: Colors.indigo,
//     );
//   }
// }
//
// class ColorSetting extends StatefulWidget {
//   final ChatRoomSetting currentSetting;
//
//   const ColorSetting({super.key, required this.currentSetting});
//
//   @override
//   ColorSettingState createState() => ColorSettingState();
// }
//
// class ColorSettingState extends State<ColorSetting> {
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(Intl.message("colors"), style: Theme.of(context).textTheme.titleLarge),
//         const SizedBox(height: 10),
//         _colorSettingTile(Intl.message("characterFontColor"), widget.currentSetting.characterFontColor, (selectedColor) {
//           setState(() {
//             widget.currentSetting.setCharacterFontColor = selectedColor;
//           });
//         }),
//         _colorSettingTile(Intl.message("userFontColor"), widget.currentSetting.userFontColor, (selectedColor) {
//           setState(() {
//             widget.currentSetting.setUserFontColor = selectedColor;
//           });
//         }),
//         _colorSettingTile(Intl.message("characterChatBoxBackgroundColor"), widget.currentSetting.characterChatBoxBackgroundColor, (selectedColor) {
//           setState(() {
//             widget.currentSetting.setCharacterChatBoxBackgroundColor = selectedColor;
//           });
//         }),
//         _colorSettingTile(Intl.message("userChatBoxBackgroundColor"), widget.currentSetting.userChatBoxBackgroundColor, (selectedColor) {
//           setState(() {
//             widget.currentSetting.setUserChatBoxBackgroundColor = selectedColor;
//           });
//         }),
//         _colorSettingTile(Intl.message("chatroomBackgroundColor"), widget.currentSetting.chatRoomBackgroundColor, (selectedColor) {
//           setState(() {
//             widget.currentSetting.setChatRoomBackgroundColor = selectedColor;
//           });
//         }),
//       ],
//     );
//   }
//
//   ListTile _colorSettingTile(String title, Color currentColor, ValueChanged<Color> onColorChanged) {
//     return ListTile(
//       title: Text(
//         title,
//         style: const TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.bold
//         ),
//       ),
//       trailing: Container(
//         width: 24,
//         height: 24,
//         decoration: BoxDecoration(
//           shape: BoxShape.circle,
//           border: Border.all(color: Colors.black38, width: 0.5),
//         ),
//         child: Center(
//           child: Icon(
//             Icons.circle,
//             color: currentColor,
//             size: 22, // Increase the icon size
//           ),
//         ),
//       ),
//       onTap: () async {
//         await _showColorPicker(title, currentColor, onColorChanged);
//       },
//     );
//   }
//
//   Future<void> _showColorPicker(String title, Color currentColor, ValueChanged<Color> onColorChanged) async {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text(title),
//           content: SingleChildScrollView(
//             child: ColorPicker(
//               pickerColor: currentColor,
//               onColorChanged: onColorChanged,
//               labelTypes: const [],
//               pickerAreaHeightPercent: 0.8,
//             ),
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: Text(Intl.message("done")),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
