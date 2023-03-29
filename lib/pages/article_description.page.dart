import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:bia_assistant/state/ai_provider.dart';
import 'package:bia_assistant_api/bia_assistant_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ArticleDescriptionPage extends ConsumerStatefulWidget {
  final NewsItem newsItem;

  const ArticleDescriptionPage({required this.newsItem, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ArticleDescriptionPageState();
}

class _ArticleDescriptionPageState
    extends ConsumerState<ArticleDescriptionPage> {
  bool showButton = false;

  @override
  Widget build(BuildContext context) {
    var aiState = ref.watch(aiStateNotifierProvider);

    switch (aiState.loadingStatus) {
      case AiLoadingStatus.loading:
      case AiLoadingStatus.initial:
        return Scaffold(
          appBar: AppBar(
            title: Text("BIA Assistant"),
          ),
          body: Center(
            child: CircularProgressIndicator.adaptive(),
          ),
        );

      default:
        return Scaffold(
          appBar: AppBar(title: Text("BIA Assistant")),
          floatingActionButton: showButton
              ? FloatingActionButton(
                  onPressed: () {
                    ref
                        .read(aiStateNotifierProvider.notifier)
                        .askAiToReviewArticle(widget.newsItem);
                  },
                  child: Icon(Icons.refresh),
                )
              : SizedBox(),
          body: ListView(
            // mainAxisAlignment: MainAxisAlignment.center,

            children: [
              SizedBox(
                width: double.infinity,
                child: (widget.newsItem.imgUrl != null)
                    ? Image.network(
                        widget.newsItem.imgUrl!,
                        height: 250,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            SizedBox(),
                      )
                    : SizedBox(),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                // child: AnimatedTextKit(
                //   animatedTexts: [
                //     TypewriterAnimatedText(
                //         Widget.,
                //         textStyle: TextStyle(
                //             fontSize: 24, fontWeight: FontWeight.bold))
                //   ],
                //   displayFullTextOnTap: true,
                //   isRepeatingAnimation: false,
                //   repeatForever: false,
                //   totalRepeatCount: 0,
                // ),
                child:
                    Text(widget.newsItem.title, style: TextStyle(fontSize: 24)),
              ),
              Divider(),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: AnimatedTextKit(
                  animatedTexts: [TypewriterAnimatedText(aiState.text)],
                  displayFullTextOnTap: false,
                  isRepeatingAnimation: false,
                  repeatForever: false,
                  totalRepeatCount: 0,
                  onFinished: () => setState(() {
                    showButton = true;
                  }),
                ),
              ),
            ],
          ),
        );
    }
  }
}
