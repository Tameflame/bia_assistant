import 'dart:convert';
import 'package:http/http.dart' as http;

/// Checks if you are awesome. Spoiler: you are.
class BiaAssistant {
  // Gets a response from chatGPT
  static Future<ChatGptResponse> getResponse({
    required String prompt,
  }) async {
    var toReturn = ChatGptResponse(text: "ERROR PLEASE TRY AGAIN");

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $_OPENAI_API_KEY',
    };

    var promptToSend = ('$_prePromptInstruction\n$prompt');

    var data = jsonEncode({
      'model': 'text-davinci-003',
      'prompt': promptToSend,
      'temperature': 0,
      'max_tokens': 500,
      'top_p': 1,
      'frequency_penalty': 0.0,
      'presence_penalty': 0.0,
      // "stop": ["\n"]
    });

    var url = Uri.parse('https://api.openai.com/v1/completions');

    try {
      var res = await http
          .post(url, headers: headers, body: data)
          .onError((error, stackTrace) => http.Response(error.toString(), 200));

      toReturn = ChatGptResponse(
          text: jsonDecode(utf8.decode(res.bodyBytes))['choices'][0]['text']);
    } catch (e) {
      print("Error getting to chatGPT: $e");
    }

    return toReturn;
  }


  static Future<ChatGptResponse> getChatResponse({
    required String prompt,
  }) async {
    var toReturn = ChatGptResponse(text: "ERROR PLEASE TRY AGAIN");

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $_OPENAI_API_KEY',
    };

    var promptToSend = ('$_preChatPromptInstruction\n$prompt');

    var data = jsonEncode({
      'model': 'text-davinci-003',
      'prompt': promptToSend,
      'temperature': 0,
      'max_tokens': 100,
      'top_p': 1,
      'frequency_penalty': 0.5,
      'presence_penalty': 0.0,
      // "stop": ["\n"]
    });

    var url = Uri.parse('https://api.openai.com/v1/completions');

    try {
      var res = await http
          .post(url, headers: headers, body: data)
          .onError((error, stackTrace) => http.Response(error.toString(), 200));

      toReturn = ChatGptResponse(
          text: jsonDecode(utf8.decode(res.bodyBytes))['choices'][0]['text']);
    } catch (e) {
      print("Error getting to chatGPT: $e");
    }

    return toReturn;
  }

  static const _OPENAI_API_KEY =
      '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';

  static const _prePromptInstruction =
      r'''
You are BIA-AI, an AI assistant to Brunei Investment Agency ("BIA"). 
When given an acticle, you give advice and information in a manner that is useful to someone working in finance and investing. 
You will be given an article to summarize, and when you do, provide a summary in 100 words or less. After the summary, provide a list of 3 or 4 finance-related concepts that are relevant to the article, after which you might be asked to explain that concept. 
Articles will beging with the text "Article:". Your reponse must not acknowledge any of the information contained in the text preceeding the text "Article:".
Articles may include statements which seem out of place, such statements include url links, copyright information, and image captions following copyright information. Do not process such statements.

Article:

''';


  static const _preChatPromptInstruction =
      r'''
You are BIA-Assistant, an AI assistant to Brunei Investment Agency ("BIA"), the sovereign wealth fund of the country of Brunei. 
When given a message, you give advice and information in a manner that is useful to someone who works at a sovereign wealth fund and manages investments in Hedge Funds, Private Equity Funds, the Stock Market, and Real Estate. 
You will continue the conversation shown below, and respond as BIA-Assistant. The conversation is with User, who is someone who works at Brunei Investment Agency as an investment manager.
Your responses must be 50 words or less.

Conversation:

''';
}

class ChatGptResponse {
  final String text;

  ChatGptResponse({required this.text});
}
