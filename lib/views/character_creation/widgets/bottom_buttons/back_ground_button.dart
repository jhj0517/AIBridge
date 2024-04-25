import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BackGroundButton extends StatelessWidget {
  final Future<void> Function() onPressed;

  const BackGroundButton({
    super.key,
    required this.onPressed
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
                Icons.image, // Use any icon you want
                color: Colors.white,
                size: 30,
              ),
              const SizedBox(height: 5),
              Text(
                Intl.message("background"),
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