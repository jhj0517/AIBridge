import 'dart:async';
import 'package:aibridge/providers/theme_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../../models/models.dart';
import '../../views.dart';
import '../../../providers/providers.dart';
import '../../../constants/constants.dart';
import '../../../utils/utils.dart';
import 'package:aibridge/views/common/character/profile_picture.dart';
import 'package:aibridge/views/chat/widgets/messages/base/base_message.dart';


class UserMessage extends BaseMessage {

  const UserMessage({
    super.key,
    required super.chatMessage,
    required super.settings,
    required super.mode,
    required super.chatTextEditingController,
    required super.editChatFocusNode,
    required super.dialogCallback,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const SizedBox(width: 70),
              buildTimestamp(context),
              const SizedBox(width: 4.0),
              _buildChatBox(context),
              const SizedBox(width: 10.0),
            ],
          ),
          const SizedBox(height: 15),
        ],
      );
  }
  
  Widget _buildChatBox(BuildContext context){
    return Flexible(
      child: Material(
        color: Colors.transparent,
        child: Ink(
            decoration: BoxDecoration(
              color: settings.userChatBoxBackgroundColor,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: InkWell(
              splashColor: settings.userChatBoxBackgroundColor.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12.0),
              onLongPress: dialogCallback,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                child: buildMessageContent(context),
              ),
            )
        ),
      ),
    );
  }
}

class UserMessageDeleteMode extends BaseMessage {
  final ValueNotifier<List<ChatMessage>> messagesToDeleteNotifier;

  const UserMessageDeleteMode({
    super.key,
    required this.messagesToDeleteNotifier,
    required super.chatMessage,
    required super.settings,
    required super.mode,
    required super.chatTextEditingController,
    required super.editChatFocusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 8),
        ValueListenableBuilder<List<ChatMessage>>(
          valueListenable: messagesToDeleteNotifier,
          builder: (context, messagesToDelete, child) {
            return Stack(
              children: [
                Positioned(
                  left: 0.0,
                  top: 0.0,
                  bottom: 0.0,
                  child: buildMessageCheckbox(
                      context, isMessageToDelete(messagesToDelete, chatMessage)
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: () {
                      if (isMessageToDelete(messagesToDelete, chatMessage)) {
                        messagesToDeleteNotifier.value = List.from(messagesToDelete)
                          ..removeWhere((entry) => entry == chatMessage);
                      } else {
                        messagesToDeleteNotifier.value = [...messagesToDelete, chatMessage];
                      }
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const SizedBox(width: 70),
                        buildTimestamp(context),
                        const SizedBox(width: 4.0),
                        _buildChatBox(context),
                        const SizedBox(width: 10.0),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget _buildChatBox(BuildContext context){
    return Flexible(
      child: Material(
        color: Colors.transparent,
        child: Ink(
            decoration: BoxDecoration(
              color: settings.userChatBoxBackgroundColor,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                child: buildMessageContent(context)
            )
        ),
      ),
    );
  }
}

class CharacterMessage extends BaseMessage {

  final Future<void> Function() profileCallback;

  const CharacterMessage({
    super.key,
    required super.chatMessage,
    required super.settings,
    required super.mode,
    required super.chatTextEditingController,
    required super.editChatFocusNode,
    required super.dialogCallback,
    required super.charactersProvider,
    required this.profileCallback
  });

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(width: 10.0),
              ProfilePicture(
                width: 50,
                height: 50,
                onPickImage: profileCallback,
                imageBLOBData: charactersProvider!.currentCharacter.photoBLOB,
              ),
              const SizedBox(width: 8.0),
              Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildCharacterName(context),
                      const SizedBox(height: 4),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          _buildChatBox(context),
                          const SizedBox(width: 4.0),
                          buildTimestamp(context),
                          const SizedBox(width: 35.0),
                        ],
                      )
                    ],
                  )
              )
            ],
          ),
          const SizedBox(height: 8)
        ],
      );
  }

  Widget _buildChatBox(BuildContext context){
    return Flexible(
      child: Material(
        color: Colors.transparent,
        child: Ink(
            decoration: BoxDecoration(
              color: settings.characterChatBoxBackgroundColor,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: InkWell(
              splashColor: settings.characterChatBoxBackgroundColor.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12.0),
              onLongPress: dialogCallback,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                child: buildMessageContent(context),
              ),
            )
        ),
      ),
    );
  }
}

class CharacterMessageDeleteMode extends BaseMessage {

  final ValueNotifier<List<ChatMessage>> messagesToDeleteNotifier;

  const CharacterMessageDeleteMode({
    super.key,
    required this.messagesToDeleteNotifier,
    required super.chatMessage,
    required super.settings,
    required super.mode,
    required super.chatTextEditingController,
    required super.editChatFocusNode,
    required super.charactersProvider,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ValueListenableBuilder<List<ChatMessage>>(
          valueListenable: messagesToDeleteNotifier,
          builder: (context, messagesToDelete, child) {
            return InkWell(
              onTap: () {
                if (isMessageToDelete(messagesToDelete, chatMessage)) {
                  messagesToDeleteNotifier.value = List.from(messagesToDelete)
                    ..removeWhere((entry) => entry == chatMessage);
                } else {
                  messagesToDeleteNotifier.value = [...messagesToDelete, chatMessage];
                }
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildMessageCheckbox(
                      context, isMessageToDelete(messagesToDelete, chatMessage)
                  ),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(width: 10.0),
                        ProfilePicture(
                          width: 50,
                          height: 50,
                          imageBLOBData: charactersProvider!.currentCharacter.photoBLOB,
                        ),
                        const SizedBox(width: 8.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              buildCharacterName(context),
                              const SizedBox(height: 4),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  _buildChatBox(context),
                                  const SizedBox(width: 4.0),
                                  buildTimestamp(context),
                                  const SizedBox(width:35.0)
                                ],
                              ),
                            ],
                          )
                        )
                      ],
                    )
                  )
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 8),
      ]
    );
  }

  Widget _buildChatBox(BuildContext context){
    return Flexible(
      child: Material(
        color: Colors.transparent,
        child: Ink(
            decoration: BoxDecoration(
              color: settings.characterChatBoxBackgroundColor,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: buildMessageContent(context),
            )
        ),
      ),
    );
  }
}

class CharacterMessageLoading extends BaseMessage{

  const CharacterMessageLoading({
    super.key,
    required super.chatMessage,
    required super.settings,
    required super.mode,
    required super.chatTextEditingController,
    required super.editChatFocusNode,
    required super.charactersProvider,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const SizedBox(width: 10.0),
            ProfilePicture(
              width: 50,
              height: 50,
              imageBLOBData: charactersProvider!.currentCharacter.photoBLOB,
            ),
            const SizedBox(width: 8.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildCharacterName(context),
                  const SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _buildChatBox(),
                      const SizedBox(width: 4.0),
                      buildTimestamp(context),
                      const SizedBox(width: 35.0),
                    ],
                  )
                ],
              )
            )
          ],
        ),
        const SizedBox(height: 8)
      ],
    );
  }

  Widget _buildChatBox(){
    return Flexible(
      child: Material(
        color: Colors.transparent,
        child: Ink(
          decoration: BoxDecoration(
            color: ColorConstants.defaultCharacterChatBoxColor,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 7.0, vertical: 8.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 7.0, vertical: 8.0),
              child: Image.asset(
                PathConstants.typingDotAnimation,
                width: 30,
                height: 20,
                fit: BoxFit.fitHeight,
              ), // replace with the path to your GIF
            ),
          )
        ),
      ),
    );
  }

}