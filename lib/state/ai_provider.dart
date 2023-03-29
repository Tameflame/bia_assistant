import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bia_assistant_api/bia_assistant_api.dart';

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
            messages: []));

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

  Future<void> getAiMessage(types.PartialText partialText) async {
    var newMessage = partialText.text;

    var prompt = "";

    for (var message in state.messages) {
      types.TextMessage;

      prompt += "\n${message.author.id}: ${message.text}";
    }

    prompt += "\n User: $newMessage \nBIA-Assistant: ";

    var responseGPTMessage = await BiaAssistant.getChatResponse(prompt: prompt);
    var responseText = responseGPTMessage.text;

    var responseMessage = types.TextMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        author: types.User(id: "BIA-Assistant"),
        text: responseText.substring(1));

    var newMessageList = <types.TextMessage>[
      responseMessage,
      ...state.messages,
    ];

    state = AiState(
        text: state.text,
        loadingStatus: AiLoadingStatus.loaded,
        messages: newMessageList);
  }
}

final aiStateNotifierProvider =
    StateNotifierProvider<AiStateNotifier, AiState>((ref) {
  return AiStateNotifier();
});
