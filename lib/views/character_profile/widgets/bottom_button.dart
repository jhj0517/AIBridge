import 'package:flutter/material.dart';

class BottomButton extends StatelessWidget {
  final String label;
  final Future<void> Function() onTap;
  final IconData iconData;

  const BottomButton({
    super.key,
    required this.label,
    required this.onTap,
    required this.iconData, // Default icon if not specified
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 80, minHeight: 80),
        child: InkWell(
          onTap: onTap,
          child: Column(
            children: [
              const SizedBox(height: 15),
              Icon(
                iconData,
                color: Colors.white,
              ),
              const SizedBox(height: 10),
              Text(
                label,
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
