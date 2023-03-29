import 'dart:convert';

import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bia_assistant_api/bia_assistant_api.dart';
import 'package:http/http.dart' as http;

class AiState {
  final String text;
  final AiLoadingStatus loadingStatus;
  final List<types.TextMessage> messages;

  AiState(
      {required this.text,
      required this.loadingStatus,
      required this.messages});
}

enum AiLoadingStatus {
  initial,
  loading,
  loaded,
}

class AiStateNotifier extends StateNotifier<AiState> {
  AiStateNotifier()
      : super(AiState(
            text: "InitialText",
            loadingStatus: AiLoadingStatus.initial,
            messages: [
              types.TextMessage(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  author: types.User(id: 'assistant'),
                  text:
                      "Hello! I am BIA-Assistant, an AI assistant for Brunei Investment Agency. How may I assist you today?")
            ]));

  Future<void> askAiToReviewArticle(NewsItem article) async {
    state = AiState(
        text: state.text,
        loadingStatus: AiLoadingStatus.loading,
        messages: state.messages);

    final prompt = "Title: ${article.title} \n Description: ${article.body}";

    var response = await BiaAssistant.getResponse(prompt: prompt);

    state = AiState(
        text: response.text,
        loadingStatus: AiLoadingStatus.loaded,
        messages: state.messages);
  }

  void sendMessage(types.PartialText partialText) {
    state = AiState(
        text: state.text,
        loadingStatus: AiLoadingStatus.loaded,
        messages: [
          types.TextMessage(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              author: types.User(id: "User"),
              text: partialText.text),
          ...state.messages
        ]);
  }

  Future<void> getAiMessage() async {
    var messages = state.messages
        .map<Map<String, dynamic>>((message) => <String, dynamic>{
              'role': message.author.id.toLowerCase(),
              'content': message.text,
            })
        .toList()
        .reversed
        .toList();

    // insert into state
    state = AiState(
        text: state.text,
        loadingStatus: AiLoadingStatus.loaded,
        messages: [
          types.TextMessage(
              author: types.User(id: 'assistant'),
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              text: "🔄 Loading..."),
          ...state.messages
        ]);

    try {
      var responseGPTMessage = await http.post(
        Uri.parse('https://avo-test-api-4epvpy2kbq-as.a.run.app/api/ai/chat'),
        body: jsonEncode({'messages': messages}),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      // remove from state
      var messagesWithLoadingRemoved = [...state.messages];
      messagesWithLoadingRemoved.removeAt(0);

      state = AiState(
          text: state.text,
          loadingStatus: AiLoadingStatus.loaded,
          messages: messagesWithLoadingRemoved);

      var responseJson = jsonDecode(responseGPTMessage.body);
      var encoder = JsonEncoder.withIndent('    ');
      print(encoder.convert(responseJson));
      var responseText = responseJson['choices'][0]['message']['content'];

      var responseMessage = types.TextMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          author: types.User(id: 'assistant'),
          text: responseText);

      var newMessageList = <types.TextMessage>[
        responseMessage,
        ...state.messages,
      ];

      state = AiState(
          text: state.text,
          loadingStatus: AiLoadingStatus.loaded,
          messages: newMessageList);
    } catch (e) {
      print('error fetching chat message: $e');
      rethrow;
    }
  }
}

final aiStateNotifierProvider =
    StateNotifierProvider<AiStateNotifier, AiState>((ref) {
  return AiStateNotifier();
});
