import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:aibridge/models/models.dart';

class MarkdownRenderSetting extends StatefulWidget {
  final ChatRoomSetting currentSetting;

  const MarkdownRenderSetting({super.key, required this.currentSetting});

  @override
  MarkdownRenderSettingState createState() => MarkdownRenderSettingState();
}

class MarkdownRenderSettingState extends State<MarkdownRenderSetting> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text(Intl.message("enableMarkdownRendering")),
      value: widget.currentSetting.isRenderMarkdown,
      onChanged: (bool value) {
        widget.currentSetting.setIsRenderMarkdown = value;
        setState(() {});
      },
      activeColor: Colors.indigo,
    );
  }
}