import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ColorSettingTile extends StatefulWidget {
  final String title;
  final Color currentColor;
  final ValueChanged<Color> onColorChanged;

  const ColorSettingTile({
    Key? key,
    required this.title,
    required this.currentColor,
    required this.onColorChanged,
  }) : super(key: key);

  @override
  ColorSettingTileState createState() => ColorSettingTileState();
}

class ColorSettingTileState extends State<ColorSettingTile> {
  late Color currentColor;

  @override
  void initState() {
    super.initState();
    currentColor = widget.currentColor;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        widget.title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      trailing: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black38, width: 0.5),
        ),
        child: Center(
          child: Icon(
            Icons.circle,
            color: currentColor,
            size: 22,
          ),
        ),
      ),
      onTap: () => _showColorPicker(),
    );
  }

  Future<void> _showColorPicker() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(widget.title),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: currentColor,
              onColorChanged: (color) {
                setState(() {
                  currentColor = color;
                  widget.onColorChanged(color);
                });
              },
              labelTypes: const [],
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Done'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }
}
