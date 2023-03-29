import 'package:bia_assistant/state/ai_provider.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class ChagePage extends ConsumerStatefulWidget {
  const ChagePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChagePageState();
}

class _ChagePageState extends ConsumerState<ChagePage> {
  @override
  Widget build(BuildContext context) {
    var state = ref.watch(aiStateNotifierProvider);
    var notifier = ref.read(aiStateNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text('Chat Page')),
      body: Chat(
        messages: state.messages,
        onSendPressed: _onSendPressed,
        user: types.User(id: "User", firstName: "User"),
      ),
    );
  }

  _onSendPressed(types.PartialText partialText) {
    ref.read(aiStateNotifierProvider.notifier).sendMessage(partialText);
    ref.read(aiStateNotifierProvider.notifier).getAiMessage();
  }
}
