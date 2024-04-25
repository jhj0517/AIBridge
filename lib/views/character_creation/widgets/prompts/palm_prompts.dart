import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'prompt_box.dart';
import 'palm_prompt_box.dart';

class PaLMPrompts extends StatelessWidget{
  final TextEditingController contextController;
  final TextEditingController exampleInputController;
  final TextEditingController exampleOutputController;

  const PaLMPrompts({
    super.key,
    required this.contextController,
    required this.exampleInputController,
    required this.exampleOutputController
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PromptBox(
            labelText: Intl.message("paLMContextPromptLabel"),
            hintText: Intl.message("paLMContextPromptHint"),
            controller: contextController
        ),
        const SizedBox(height: 15),
        PaLMPromptBox(
            inputExampleController: exampleInputController,
            outputExampleController: exampleOutputController
        )
      ],
    );
  }

}