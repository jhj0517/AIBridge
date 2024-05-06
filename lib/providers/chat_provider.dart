import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';

import '../repositories/chat_repository.dart';
import '../utils/utilities.dart';
import '../models/models.dart';
import '../providers/providers.dart';
import '../network/network.dart';

enum RequestState{
  initialized,
  loading,
  answering,
  invalidOpenAIAPIKey,
  invalidPaLMAPIKey,
  done,
}

class ChatProvider extends ChangeNotifier {

  final ChatRepository chatRepository;
  final CharactersProvider charactersProvider;
  final ChatRoomsProvider chatRoomsProvider;
  final KeyProvider keyProvider;

  List<ChatMessage> _chatMessages = [];
  List<ChatMessage> get chatMessages => _chatMessages;

  RequestState requestState = RequestState.done;

  ChatProvider({required this.chatRepository,
    required this.charactersProvider,
    required this.chatRoomsProvider,
    required this.keyProvider,
  }) {
    //Initialize something
  }

  Future<void> getChatMessages(String roomId) async {
    _chatMessages = await chatRepository.getChatMessages(roomId);
    notifyListeners();
  }

  Future<void> insertChatMessage(ChatMessage chatMessage) async {
    await chatRepository.insertChatMessage(chatMessage);
    if(charactersProvider.currentCharacter.id == chatMessage.characterId){
      getChatMessages(chatMessage.roomId);
    }
    chatRoomsProvider.getChatRooms();
  }

  Future<void> updateChatMessage(ChatMessage chatMessage) async {
    await chatRepository.updateChatMessage(chatMessage);
    getChatMessages(chatMessage.roomId);
  }

  Future<void> deleteOneChatMessage(String id,String roomId) async {
    await chatRepository.deleteOneChatMessage(id);
   getChatMessages(roomId);
  }

  Future<void> deleteChatMessages(List<ChatMessage> messagesToDelete, String roomId) async {
    await chatRepository.deleteChatMessages(messagesToDelete);
    getChatMessages(roomId);
  }

  Future<void> openAIStreamCompletion(
      OpenAIPlatform openAIParams,
      List<ChatMessage> chatMessages,
      String roomId,
      Character character
  ) async {
    if(!keyProvider.isKeyValid(AIPlatformType.openAI)){
      setRequestState(RequestState.invalidOpenAIAPIKey);
      return;
    }
    setRequestState(RequestState.loading);

    final answerStream = await OpenAINetwork.requestChatStream(
        keyProvider.openAPIKey!,
        openAIParams,
        chatMessages,
        character
    );

    final message = ChatMessage.firstMessage(roomId, character.id!, "");
    String answer = "";

    answerStream.handleError((error) {
      debugPrint("Error during Stream: $error");
      switch (error.statusCode){
        case 401:
          setRequestState(RequestState.invalidOpenAIAPIKey);
        default:
          showToastMessage('${error.message}');
          setRequestState(RequestState.done);
      }
    })
    .listen((event) async {
      answer += event.choices.first.delta.content?[0].text ?? "";
      setRequestState(RequestState.answering);
      updateChatMessage(
        message.copyWith(
          content: answer
        )
      );
    },
    onDone: () async {
      chatRoomsProvider.getChatRooms();
      setRequestState(RequestState.done);
    });
  }

  Future<void> paLMChatCompletion(
      PaLMPlatform paLMParams,
      List<ChatMessage> chatMessages,
      String roomId,
      Character character
  ) async {
    if (!keyProvider.isKeyValid(AIPlatformType.paLM)){
      setRequestState(RequestState.invalidPaLMAPIKey);
      return;
    }

    setRequestState(RequestState.loading);
    final response = await PaLM.requestChat(
        keyProvider.paLMAPIKey!,
        paLMParams,
        chatMessages,
        character
    );

    response.fold(
        success: (value) async {
          if (value.candidates!=null){
            final answer = ChatMessage(
                roomId: roomId,
                characterId: character.id!,
                chatMessageType: ChatMessageType.characterMessage,
                timestamp: Utilities.getTimestamp(),
                content: value.candidates!.first.content
            );
            insertChatMessage(answer);
            chatRoomsProvider.getChatRooms();
            setRequestState(RequestState.done);
          } else if (value.candidates== null && value.filters != null){
            debugPrint("error : $value");
            showToastMessage("Content filtered due to: \"${value.filters!.first.reason.name}\"");
            setRequestState(RequestState.done);
          }
        },
        error: (value){
          debugPrint("error : $value");
          setRequestState(RequestState.done);
          showToastMessage(value.errorMessage);
        }
    );
  }

  void setRequestState(RequestState state){
    requestState = state;
    notifyListeners();
  }

  void showToastMessage(String message) {
    Fluttertoast.showToast( // All property will be ignored in above Android 11
        msg: "Error : $message",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  Future<void> setKeyboardHeight(double keyboardHeight) async{
    await chatRepository.setKeyboardHeight(keyboardHeight);
  }

  double getKeyboardHeight(BuildContext context) {
    return chatRepository.getKeyboardHeight() ?? MediaQuery.of(context).size.height*0.3;
  }

}
