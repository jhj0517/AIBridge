import 'package:flutter/material.dart';

class KeyRow extends StatelessWidget {

  const KeyRow({
    super.key,
    required this.title,
    required this.imagePath,
    required this.onTap,
  });

  final String title;
  final String imagePath;
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
                Image.asset(
                  imagePath,
                  width: 24,
                  height: 24,
                  fit: BoxFit.contain,
                ),
                const SizedBox(width: 20),
                Text(
                  title,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: Theme.of(context).textTheme.bodyMedium!.color
                  ),
                ),
              ],
            ),
          ),
        ),
        Divider(
          height: 0.1,
          thickness: 0.3,
          color: Theme.of(context).dividerColor,
        ),
      ],
    );
  }


}