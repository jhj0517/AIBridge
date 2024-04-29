import 'package:flutter/material.dart';

class SettingRow extends StatelessWidget {

  const SettingRow({
    super.key,
    required this.label,
    required this.onTap,
    this.icon,
    this.imagePath,
  });

  final IconData? icon;
  final String? imagePath;
  final String label;
  final Future<void> Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Row(
              children: [
                const SizedBox(width: 10),
                // Check if the object is IconData or String
                icon != null
                ? Icon(
                  icon,
                  size: 24,
                  color: Theme.of(context).textTheme.bodyMedium!.color,
                )
                : Image.asset(
                  imagePath!,
                  width: 24,
                  height: 24,
                  fit: BoxFit.cover,
                ),
                const SizedBox(width: 20),
                Text(
                  label,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: Theme.of(context).textTheme.bodyMedium!.color,
                  ),
                ),
              ],
            ),
          ),
        ),
        Divider(
          height: 0.1,
          thickness: 0.2,
          color: Theme.of(context).dividerColor,
        ),
      ],
    );
  }

}