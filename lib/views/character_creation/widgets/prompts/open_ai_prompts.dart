import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'prompt_box.dart';

class OpenAIPrompts extends StatelessWidget {

  const OpenAIPrompts({
    super.key,
    required this.systemPromptsController,
    required this.onAdd,
    required this.onRemove
  });

  final List<TextEditingController> systemPromptsController;
  final Function() onAdd;
  final Function(int) onRemove;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (int index = 0; index < systemPromptsController.length; index++)
          PromptBox(
            labelText: index == 0 ? Intl.message("description") : Intl.message("systemPrompt"),
            hintText: index == 0 ? Intl.message("descriptionHint") : Intl.message("systemPromptHint"),
            controller: systemPromptsController[index],
            index: index,
            onRemove: (index) => onRemove,
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
              onPressed: () => onAdd
            ),
          ],
        ),
      ],
    );
  }


}