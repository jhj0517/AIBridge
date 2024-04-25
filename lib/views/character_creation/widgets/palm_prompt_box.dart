import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'prompt_box.dart';

class PaLMPromptBox extends StatelessWidget {
  final TextEditingController inputExampleController;
  final TextEditingController outputExampleController;

  const PaLMPromptBox({
    super.key,
    required this.inputExampleController,
    required this.outputExampleController,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      color: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: const BorderSide(color: Colors.white, width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Text(
                  Intl.message("paLMExamplePromptLabel"),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  Intl.message("paLMExamplePromptHint"),
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 40, right: 10),
            child: PromptBox(
                labelText:  Intl.message("paLMExampleInputLabel"),
                hintText: Intl.message("paLMExampleInputHint"),
                controller: inputExampleController
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 40, right: 10),
            child: PromptBox(
                labelText:  Intl.message("paLMExampleOutputLabel"),
                hintText: Intl.message("paLMExampleOutputHint"),
                controller: outputExampleController
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}