import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bia_assistant_api/bia_assistant_api.dart';
import 'package:http/http.dart' as http;

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

    // var newsItems = await NewsApi.getLatestNews(limit: limit);

    var response = await http.post(
      Uri.parse('https://avo-test-api-4epvpy2kbq-as.a.run.app/api/news'),
      headers: {
        // 'Content-Type': 'text/plain',
      },
    ).onError((error, stackTrace) {
      print("Error fetching thing: $error");
      return http.Response("body", 500);
    });

    var jsonList = jsonDecode(response.body) as List<dynamic>;
    var newsItems = jsonList
        .map((e) =>
            NewsItem(title: e['title'], body: e['body'], imgUrl: e['imgUrl']))
        .toList();

    state = NewsState(newsItems, NewsLoadingState.loaded);
  }
}

final newsStateNotifierProvider =
    StateNotifierProvider<NewsStateNotifier, NewsState>((ref) {
  return NewsStateNotifier();
});
