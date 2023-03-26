import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bia_assistant_api/bia_assistant_api.dart';

class AiState {
  final String text;
  final AiLoadingStatus loadingStatus;

  AiState({required this.text, required this.loadingStatus});
}

enum AiLoadingStatus {
  initial,
  loading,
  loaded,
}

class AiStateNotifier extends StateNotifier<AiState> {
  AiStateNotifier()
      : super(AiState(
            text: "InitialText", loadingStatus: AiLoadingStatus.initial));

  Future<void> askAiToReviewArticle(NewsItem article) async {
    state = AiState(text: state.text, loadingStatus: AiLoadingStatus.loading);

    final prompt = "Title: ${article.title} \n Description: ${article.body}";

    var response = await BiaAssistant.getResponse(prompt: prompt);

    state = AiState(text: response.text, loadingStatus: AiLoadingStatus.loaded);
  }
}

final aiStateNotifierProvider =
    StateNotifierProvider<AiStateNotifier, AiState>((ref) {
  return AiStateNotifier();
});
