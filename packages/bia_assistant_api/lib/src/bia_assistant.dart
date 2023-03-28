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
    };

    var url = Uri.parse('azamURL');

    try {
      var res = await http
          .post(url, headers: headers, body: jsonEncode({'article': prompt}))
          .onError((error, stackTrace) => http.Response(error.toString(), 400));

      toReturn = ChatGptResponse(text: res.body);
    } catch (e) {
      print("Error getting to chatGPT: $e");
    }

    return toReturn;
  }
}

class ChatGptResponse {
  final String text;

  ChatGptResponse({required this.text});
}
