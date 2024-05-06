import 'package:aibridge/utils/chat_parser.dart';
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
      OpenAIPlatform openAIParams,
      List<ChatMessage> chatMessages,
      Character character
    ) async {
    /*
    * Request chat completion stream to OpenAI server.
    * ------------
    * key : OpenAI API key
    * openAIParams : parameters for OpenAI chat completion including temperature, model name, system prompts.
    * chatMessages : input chat messages.
    * character :character data including character name etc.
    * ------------
    * returns streams for chat completion
    * */
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
      ); // NOTE : `maxTokens` must be specified when use gpt-4-vision. unless, It generates too small output. For other models, by default it's (4096 - promptTokens)
  }

  static List<OpenAIChatCompletionChoiceMessageModel> formattingToOpenAI(
      List<ChatMessage> chatMessages
      ) {
    /*
    * receive chat message model and formatting to model for `dart_openai` package
    * ------------
    * chatMessages : chat message model
    * ------------
    * returns model for `dart_openai` package
    * */
    List<OpenAIChatCompletionChoiceMessageModel> formatted = chatMessages
        .map((message) => OpenAIChatCompletionChoiceMessageModel(
      content: message.imageUrl.isEmpty
              ? [OpenAIChatCompletionChoiceMessageContentItemModel.text(
                  message.content
               )]
              : [OpenAIChatCompletionChoiceMessageContentItemModel.imageUrl(
                  message.imageUrl
               )],
      role: message.chatMessageType == ChatMessageType.userMessage
          ? OpenAIChatMessageRole.user
          : OpenAIChatMessageRole.assistant,
    )).toList();
    return formatted;
  }

  static List<OpenAIChatCompletionChoiceMessageModel> embedSystemPrompts(
      List<OpenAIChatCompletionChoiceMessageModel> chatMessages,
      OpenAIPlatform openAIParams,
      Character character
  ){
    /*
    * Embed system prompts before chat prompts. Use system prompts from character data.
    * ------------
    * chatMessages : chat message model
    * openAIParams : parameters for OpenAI chat completion including temperature, model name, system prompts.
    * character : character data including character name etc.
    * ------------
    * Returns prompts that are embedded system prompts.
    * */
    final systemPrompts = [];
    for (final (index, systemPrompt) in openAIParams.systemPrompts.indexed){
      systemPrompts.add(
        OpenAIChatCompletionChoiceMessageModel(
          content: [
            OpenAIChatCompletionChoiceMessageContentItemModel.text(
              ChatParser.parsePrompt(systemPrompt, character)
            )
          ],
          role: OpenAIChatMessageRole.system
        )
      );
    }
    return systemPrompts.isEmpty ? chatMessages : [...systemPrompts, ...chatMessages];
  }

  static List<OpenAIChatCompletionChoiceMessageModel> limitInputTokens(
      List<OpenAIChatCompletionChoiceMessageModel> chatMessages,
      int tokenLimitation,
      String modelId
  ){
    /*
    * Filter input messages as maximum tokens for the model. see more detailed info here : https://platform.openai.com/docs/models/gpt-4-and-gpt-4-turbo
    * "Context window" meant maximum token, this function calculates and filters input messages to be (system prompts + chat messages) + answer < maximum token.
    * ------------
    * chatMessages : chat message model
    * tokenLimitation : max token limitation
    * character : chat completion model id
    * ------------
    * returns List of input models that is filtered as maximum tokens
    * */
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
    /*
    * get tokens for string. This function uses ported tiktokenizer for the dart.
    * ------------
    * string : string to examine token
    * modelName : OpenAI chat completion model name
    * ------------
    * returns int number tokens
    * */
    final encoding = tiktokenizer.encodingForModel(modelName);
    final numTokens = encoding.encode(string).length;
    return numTokens;
  }

}