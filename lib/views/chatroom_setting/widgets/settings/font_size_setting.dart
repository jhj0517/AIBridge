import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:aibridge/models/chatroom_settings.dart';

class FontSizeSetting extends StatefulWidget {
  final ChatRoomSetting currentSetting;

  const FontSizeSetting({super.key, required this.currentSetting});

  @override
  FontSizeSettingState createState() => FontSizeSettingState();
}

class FontSizeSettingState extends State<FontSizeSetting> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(Intl.message("fontSize"), style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 10),
        _fontSizeSelector(Intl.message("characterFontSize"), widget.currentSetting.characterFontSize, (value) {
          setState(() {
            widget.currentSetting.setCharacterFontSize = value;
          });
        }),
        const SizedBox(height: 20),
        _fontSizeSelector(Intl.message("userFontSize"), widget.currentSetting.userFontSize, (value) {
          setState(() {
            widget.currentSetting.setUserFontSize = value;
          });
        }),
      ],
    );
  }

  Widget _fontSizeSelector(String label, double fontSize, ValueChanged<double> onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
            label,
            style: const TextStyle(
                fontWeight: FontWeight.bold
            )
        ),
        Row(
          children: [
            Text(fontSize.toStringAsFixed(0), style: TextStyle(fontSize: fontSize)),
            const SizedBox(width: 5),
            IconButton(
              icon: const Icon(Icons.remove, size: 20),
              onPressed: () {
                if (fontSize > 10) {
                  onChanged(fontSize - 1);
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.add, size: 20),
              onPressed: () {
                if (fontSize < 32) {
                  onChanged(fontSize + 1);
                }
              },
            ),
          ],
        )
      ],
    );
  }
}