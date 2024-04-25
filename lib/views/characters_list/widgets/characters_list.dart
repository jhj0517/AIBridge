import 'package:aibridge/views/characters_list/widgets/characters_list_placeholder.dart';
import 'package:flutter/material.dart';

import 'package:aibridge/models/models.dart';
import 'package:aibridge/views/common/character/profile_picture.dart';

class CharacterList extends StatelessWidget {
  final List<Character?> items;
  final Future<void> Function(Character?) onLongPress;
  final void Function(Character?) onTap;

  const CharacterList({
    super.key,
    required this.items,
    required this.onLongPress,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if(items.isEmpty){
      return const CharactersListPlaceHolder();
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(0.5, 0.5, 0.5, 50),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final character = items[index];
        return CharacterItem(
          character: character,
          onLongPress: onLongPress,
          onTap: onTap,
        );
      },
    );
  }
}

class CharacterItem extends StatelessWidget {
  final Character? character;
  final Future<void> Function(Character?) onLongPress;  // Define the type here
  final void Function(Character?) onTap;

  const CharacterItem({
    super.key,
    this.character,
    required this.onLongPress,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (character == null) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        Ink(
          color: Theme.of(context).colorScheme.background,
          child: InkWell(
            onLongPress: () => onLongPress(character!),  // Use the function here
            onTap: () => onTap(character!),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              child: Row(
                children: [
                  ProfilePicture(
                    width: 50,
                    height: 50,
                    imageBLOBData: character!.photoBLOB,
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          character!.characterName,
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodyMedium!.color,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
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