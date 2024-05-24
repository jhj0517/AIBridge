import 'package:flutter/material.dart';

import 'package:aibridge/models/sqflite/character.dart';

class CharacterName extends StatelessWidget {
  const CharacterName({
    super.key,
    required this.character,
  });

  final Character? character;

  @override
  Widget build(BuildContext context) {
    return Text(
      character!.characterName,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16.0,
        color: Theme.of(context).textTheme.bodyMedium!.color,
      ),
    );
  }
}