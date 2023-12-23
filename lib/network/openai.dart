import 'package:flutter/material.dart';
import 'package:dart_openai/dart_openai.dart';
import 'package:tiktoken/tiktoken.dart' as tiktokenizer;

import '../models/models.dart';
import '../constants/model_constants.dart';

const openAIOutputTokenSafetyMargin = 800;

const openAIMaximumToken = {
  ModelConstants.chatGPT3dot5Id : 4096,
  ModelConstants.chatGPT4Id: 8192,
  ModelConstants.chatGPT4VisionId: 128000
};

class OpenAINetwork{

  static Future<Stream<OpenAIStreamChatCompletionModel>> requestChatStream(
      String key,
      OpenAIService openAIParams,
      List<ChatMessage> chatMessages,
      Character character
    ) async {
      OpenAI.apiKey = key;
      List<OpenAIChatCompletionChoiceMessageModel> messages = formattingToOpenAI(chatMessages);
      messages = embedSystemPrompts(messages, openAIParams, character);
      messages = limitInputTokens(
          messages,
          openAIMaximumToken[openAIParams.modelId]!,
          openAIParams.modelId!
      );
      return OpenAI.instance.chat.createStream(
        model: openAIParams.modelId!,
        messages: messages,
        temperature: openAIParams.temperature,
        maxTokens: openAIParams.modelId! == ModelConstants.chatGPT4VisionId ? 4096 : null
      );
      // note : `maxTokens` must be specified when use gpt-4-vision. unless, It generates too small output. For other models, by default it's 4096 - promptTokens
  }

  static List<OpenAIChatCompletionChoiceMessageModel> formattingToOpenAI(List<ChatMessage> chatMessages) {
    List<OpenAIChatCompletionChoiceMessageModel> formatted = chatMessages
        .map((message) => OpenAIChatCompletionChoiceMessageModel(
      content: message.imageUrl.isEmpty
              ? [OpenAIChatCompletionChoiceMessageContentItemModel.text(
                  message.content
               )]
              : [OpenAIChatCompletionChoiceMessageContentItemModel.imageUrl(
                  message.imageUrl
               )],
      role: message.role == 'user'
          ? OpenAIChatMessageRole.user
          : OpenAIChatMessageRole.assistant,
    )).toList();
    debugPrint("formattedMessage : ${formatted}");
    return formatted;
  }

  static List<OpenAIChatCompletionChoiceMessageModel> embedSystemPrompts(
      List<OpenAIChatCompletionChoiceMessageModel> chatMessages,
      OpenAIService openAIParams,
      Character character
  ){
    final systemPrompts = [];
    for (final (index, systemPrompt) in openAIParams.systemPrompts.indexed){
      systemPrompts.add(
        OpenAIChatCompletionChoiceMessageModel(
          content: [
            OpenAIChatCompletionChoiceMessageContentItemModel.text(
              formattingSystemPrompt(systemPrompt, character)
            )
          ],
          role: OpenAIChatMessageRole.system
        )
      );
    }
    return systemPrompts.isEmpty ? chatMessages : [...systemPrompts, ...chatMessages];
  }

  static String formattingSystemPrompt(String chat, Character character){
    return chat.replaceAll('<user>', character.userName).replaceAll('<char>', character.characterName);
  }

  static List<OpenAIChatCompletionChoiceMessageModel> limitInputTokens(
      List<OpenAIChatCompletionChoiceMessageModel> chatMessages,
      int tokenLimitation,
      String modelId
  ){
    int totalTokens=0;
    List<OpenAIChatCompletionChoiceMessageModel> filteredList = [];
    int outputTokenSafetyMargin = tokenLimitation > openAIOutputTokenSafetyMargin ? openAIOutputTokenSafetyMargin : 0;

    List<OpenAIChatCompletionChoiceMessageModel> systemTemp = [];
    chatMessages.removeWhere((chat) {
      if (chat.role == OpenAIChatMessageRole.system) {
        totalTokens += numTokensFromString(chat.content![0].text!, modelId);
        systemTemp.add(chat);
        return true;
      }
      return false;
    });

    for(var chat in chatMessages.reversed){
      String content = "";
      if (chat.content![0].text != null){
        content = chat.content![0].text!;
      } else {
        content = chat.content![0].imageUrl!;
      }
      totalTokens += numTokensFromString(content, modelId);
      if(totalTokens < tokenLimitation-outputTokenSafetyMargin){
        filteredList.add(chat);
      } else{
        debugPrint("Context tokens are : $totalTokens ,Context token exceed Maximum ${tokenLimitation-outputTokenSafetyMargin} (tokenLimitation-ensuredTokenForAnswer) tokens, returns filteredList");
        return [...systemTemp, ...filteredList.reversed.toList()];
      }
    }
    debugPrint("Context tokens are : $totalTokens ,token does not exceed Maximum ${tokenLimitation-outputTokenSafetyMargin} (tokenLimitation-ensuredTokenForAnswer) tokens. returns the list itself");
    return [...systemTemp, ...filteredList.reversed.toList()];
  }

  static int numTokensFromString(String string, String modelName) {
    final encoding = tiktokenizer.encodingForModel(modelName);
    final numTokens = encoding.encode(string).length;
    return numTokens;
  }

}