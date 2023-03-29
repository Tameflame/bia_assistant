import 'package:bia_assistant/pages/article_description.page.dart';
import 'package:bia_assistant/state/ai_provider.dart';
import 'package:bia_assistant/state/providers.dart';
import 'package:bia_assistant_api/bia_assistant_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'pages/chat.page.dart';

const NEWS_API_KEY = 'WbAldN6TqUO4egbx1uNkCRg5EU1cswRBXwIv1euT';
const OPENAI_API_KEY = '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';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProviderScope(
      child: MaterialApp(
        home: HomePage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class HomePage extends ConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final newsState = ref.watch(newsStateNotifierProvider);
    final newsBloc = ref.read(newsStateNotifierProvider.notifier);

    switch (newsState.loadingState) {
      case NewsLoadingState.initial:
        return Scaffold(
            appBar: AppBar(
              title: const Text('BIA Assistant'),
              actions: [
                IconButton(
                    onPressed: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (_) => ChagePage()));
                    },
                    icon: Icon(Icons.chat))
              ],
            ),
            body: Center(
              child: Text("Click the refresh button to get articles!"),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                newsBloc.fetchArticles();
              },
              child: Icon(Icons.refresh),
            ));

      case NewsLoadingState.loading:
        return Scaffold(
          appBar: AppBar(
            title: const Text('BIA Assistant'),
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (_) => ChagePage()));
                  },
                  icon: Icon(Icons.chat))
            ],
          ),
          body: Center(
            child: CircularProgressIndicator.adaptive(),
          ),
        );
      default:
        return Scaffold(
            appBar: AppBar(
              title: const Text('BIA Assistant'),
              actions: [
                IconButton(
                    onPressed: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (_) => ChagePage()));
                    },
                    icon: Icon(Icons.chat))
              ],
            ),
            body: ListView.builder(
              itemCount: newsState.items.length,
              itemBuilder: (context, index) => NewsListItem(
                item: newsState.items[index],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                newsBloc.fetchArticles();
              },
              child: Icon(Icons.refresh),
            ));
    }
  }
}

class NewsListItem extends ConsumerWidget {
  final NewsItem item;

  const NewsListItem({required this.item, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      width: double.infinity,
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            (item.imgUrl != null)
                ? SizedBox(
                    // height: 150,
                    width: double.infinity,
                    child: Image.network(
                      height: 150,
                      fit: BoxFit.cover,
                      item.imgUrl!,
                      errorBuilder: (context, error, stackTract) =>
                          const SizedBox(),
                    ),
                  )
                : const SizedBox(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Text(item.title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ),
            // Divider(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Text(item.body),
            ),
            TextButton(
                onPressed: () {
                  ref
                      .read(aiStateNotifierProvider.notifier)
                      .askAiToReviewArticle(item);

                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          ArticleDescriptionPage(newsItem: item)));
                },
                child: Text('Ask BIA Assistant'))
          ],
        ),
      ),
    );
  }

  List<Widget> buildTags() {
    var toReturn = [];

    return [];
  }
}
