import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'prompt_box.dart';

class OpenAIPrompts extends StatefulWidget {
  const OpenAIPrompts({
    super.key,
    required this.systemPromptsController,
  });

  final List<TextEditingController> systemPromptsController;

  @override
  OpenAIPromptsState createState() => OpenAIPromptsState();
}

class OpenAIPromptsState extends State<OpenAIPrompts> {

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (int index = 0; index < widget.systemPromptsController.length; index++)
          PromptBox(
            labelText: index == 0 ? Intl.message("description") : Intl.message("systemPrompt"),
            hintText: index == 0 ? Intl.message("descriptionHint") : Intl.message("systemPromptHint"),
            controller: widget.systemPromptsController[index],
            index: index,
            onRemove: (index) {
              widget.systemPromptsController.removeAt(index);
              setState(() { });
            }
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ), // Circular shape
                fixedSize: const Size(30, 30),
              ),
              child: const Icon(
                Icons.add,
                color: Colors.black,
                size: 24,
              ),
              onPressed: () {
                widget.systemPromptsController.add(TextEditingController());
                setState(() { });
              }
            ),
          ],
        ),
      ],
    );
  }


}