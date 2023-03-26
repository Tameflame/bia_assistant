import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bia_assistant_api/bia_assistant_api.dart';

class NewsState {
  final List<NewsItem> items;
  final NewsLoadingState loadingState;

  const NewsState(this.items, this.loadingState);
}

enum NewsLoadingState {
  initial,
  loading,
  loaded,
}

class NewsStateNotifier extends StateNotifier<NewsState> {
  NewsStateNotifier()
      : super(NewsState(List.empty(growable: false), NewsLoadingState.initial));

  Future<void> fetchArticles({int limit = 10}) async {
    state = NewsState(state.items, NewsLoadingState.loading);

    var newsItems = await NewsApi.getLatestNews(limit: limit);

    state = NewsState(newsItems, NewsLoadingState.loaded);
  }
}

final newsStateNotifierProvider =
    StateNotifierProvider<NewsStateNotifier, NewsState>((ref) {
  return NewsStateNotifier();
});
