import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ImportCharacterButton extends StatelessWidget {
  final Future<void> Function() onPressed;

  const ImportCharacterButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: SizedBox(
        height: 80,
        width: 80,
        child: InkWell(
          onTap: onPressed,
          child: Column(
            children: [
              const SizedBox(height: 15),
              const Icon(
                Icons.file_download_outlined,
                color: Colors.white,
                size: 30,
              ),
              const SizedBox(height: 5),
              Text(
                Intl.message("import"),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}