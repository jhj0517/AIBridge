import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tiktoken/tiktoken.dart' as tiktokenizer;

import '../constants/constants.dart';
import '../models/models.dart';

const paLMMaximumInputToken = {
  ModelConstants.paLMBisonId: 4096,
};

const paLMMaximumOutputToken = {
  ModelConstants.paLMBisonId: 1024,
};

const paLMTokenSafetyMargin = 500; // Since google does not provide open-sourced tokenizer now, I temporally use this safety margin in tokenizer.

// Issues for PaLM for now
// 1. currently google does not provide tokenizer, so I use tokenizer instead for now.
// see more info : https://github.com/davidmigloz/langchain_dart/blob/main/packages/langchain_google/lib/src/chat_models/vertex_ai.dart
// 2. it does not support Stream Session ,
// see more info : https://github.com/googleapis/python-aiplatform/issues/2246

class PaLM{

  static String baseUrl = 'https://generativelanguage.googleapis.com/v1beta1/';

  static Future<Result<PaLMResponse>> requestChat(
      String apiKey,
      PaLMService paLMParams,
      List<ChatMessage> chatMessages,
      Character character
    ) async{
    try{
      List<PaLMMessage> messages = formattingToPaLM(chatMessages);
      messages = limitInputTokens(messages, paLMMaximumInputToken[paLMParams.modelId]!, paLMParams.modelId);
      PaLMPrompt prompts = embedOtherPrompts(paLMParams, messages, character);

      final url = Uri.parse('${baseUrl}models/${paLMParams.modelId}:generateMessage?key=$apiKey');
      final headers = {
        'Content-Type': 'application/json'
      };
      final body = PaLMRequest(
          prompt: prompts,
          temperature: paLMParams.temperature,
          candidateCount: paLMParams.candidateCount
      ).toJson();
      debugPrint("body : $body");
      final response = await http.post(url, headers: headers, body: jsonEncode(body));
      if (response.statusCode == 200) {
        // note : 1. When random string is inserted, it returns content filter with "OTHERS" reason
        // note : 2. When unsupported language is inserted, it returns content filter with "OTHERS" reason
        final decodedResponse = json.decode(response.body);
        return Success(PaLMResponse.fromJson(decodedResponse));
      } else {
        debugPrint("error : ${response.body}");
        // note : error code 400 -> message must alternate between authors.
        return Error(
          errorCode: response.statusCode,
          errorMessage: json.decode(response.body)['error']['message'],
        );
      }
    } catch (e) {
      throw Exception('Failed during PaLM Post Request: $e');
    }
  }

  static List<PaLMMessage> formattingToPaLM(List<ChatMessage> chatMessages) {
    return chatMessages
        .map((message) => PaLMMessage(
      author: message.role == 'user'
          ? PaLMMessageRole.user
          : PaLMMessageRole.assistant,
      content: message.content,
    )).toList();
  }

  static PaLMPrompt embedOtherPrompts(
      PaLMService paLMParams,
      List<PaLMMessage> chatMessages,
      Character character
      ) {
    return PaLMPrompt(
        context: paLMParams.context.isNotEmpty ? formattingPrompt(paLMParams.context, character) : null,
        examples: paLMParams.exampleInput.isNotEmpty && paLMParams.exampleOutput.isNotEmpty
        ? [
            PaLMExample(
              input: PaLMMessage(
                  author: PaLMMessageRole.user,
                  content: formattingPrompt(paLMParams.exampleInput, character)
              ),
              output: PaLMMessage(
                  author: PaLMMessageRole.assistant,
                  content: formattingPrompt(paLMParams.exampleOutput, character)
              ),
            )
          ]
        : null,
        messages: chatMessages
    );
  }

  static List<PaLMMessage> limitInputTokens(
      List<PaLMMessage> chatMessages,
      int tokenLimitation,
      String modelName
      ){
    int totalTokens = 0;
    List<PaLMMessage> filteredList = [];
    int tokenSafetyMargin = paLMTokenSafetyMargin < paLMMaximumInputToken[modelName]! ? paLMTokenSafetyMargin : 0;

    for(var chat in chatMessages.reversed){
      totalTokens += numTokensFromString(chat.content);
      if (totalTokens < tokenLimitation - tokenSafetyMargin){
        filteredList.add(chat);
      } else {
        debugPrint("Context tokens are : $totalTokens ,Context token exceed Maximum ${tokenLimitation-tokenSafetyMargin} (tokenLimitation-tokenSafetyMargin) tokens, returns filteredList");
        return filteredList.reversed.toList();
      }
    }
    debugPrint("Context tokens are : $totalTokens ,Context token exceed Maximum ${tokenLimitation-tokenSafetyMargin} (tokenLimitation-tokenSafetyMargin) tokens, returns filteredList");
    return filteredList.reversed.toList();
  }

  static String formattingPrompt(String chat, Character character){
    return chat.replaceAll('<user>', character.userName).replaceAll('<character>', character.characterName);
  }

  // note : Since google does not provide tokenizer, use tiktokenizer instead for now.
  // note : it looks like this tokenizer count more tokens than tiktokenizer.
  static int numTokensFromString(String string) {
    final encoding = tiktokenizer.encodingForModel(ModelConstants.chatGPT3dot5Id);
    final numTokens = encoding.encode(string).length;
    return numTokens;
  }

}