import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PromptField extends StatelessWidget {
  final String labelText;
  final String hintText;
  final TextEditingController controller;
  final int? index;
  final Function(int index)? onRemove;

  const PromptField({
    super.key,
    required this.labelText,
    required this.hintText,
    required this.controller,
    this.index,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              scrollPhysics: const BouncingScrollPhysics(),
              cursorColor: Colors.white,
              maxLines: null, // unlimited lines
              keyboardType: TextInputType.multiline,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              controller: controller,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontWeight: FontWeight.w300,
                ),
                hintMaxLines: 10,
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                labelText: labelText,
                labelStyle: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                ),
                counterStyle: const TextStyle(color: Colors.white),
                suffixIcon: index != null
                ? IconButton(
                  icon: const CircleAvatar(
                    backgroundColor: Colors.black,
                    child: Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 15,
                    ),
                  ),
                  onPressed: () => onRemove!(index!),
                )
                : null,
              ),
            ),
            const SizedBox(height: 15),
          ],
        );
      },
    );
  }
}

class PaLMExamplePromptFields extends StatelessWidget {
  final TextEditingController inputExampleController;
  final TextEditingController outputExampleController;

  const PaLMExamplePromptFields({
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
            child: PromptField(
              labelText:  Intl.message("paLMExampleInputLabel"),
              hintText: Intl.message("paLMExampleInputHint"),
              controller: inputExampleController
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 40, right: 10),
            child: PromptField(
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