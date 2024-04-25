import 'package:flutter/material.dart';

class PromptBox extends StatelessWidget {
  final String labelText;
  final String hintText;
  final TextEditingController controller;
  final int? index;
  final Function(int index)? onRemove;

  const PromptBox({
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