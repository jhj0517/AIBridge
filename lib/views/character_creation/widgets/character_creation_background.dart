import 'package:flutter/material.dart';
import 'dart:typed_data';

import 'package:aibridge/constants/path_constants.dart';

class CharacterCreationBackground extends StatelessWidget {
  final Uint8List? backgroundImageBLOB;

  const CharacterCreationBackground({
    super.key,
    required this.backgroundImageBLOB,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: backgroundImageBLOB != null && backgroundImageBLOB!.isNotEmpty
              ? MemoryImage(backgroundImageBLOB!) as ImageProvider
              : const AssetImage(PathConstants.characterCreationPageBackgroundPlaceholderImage),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        color: Colors.black.withOpacity(0.8), // Adding a dark filter
      ),
    );
  }
}
