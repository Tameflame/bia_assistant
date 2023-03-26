import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class NewsApi {
  static const _NEWS_API_KEY = 'WbAldN6TqUO4egbx1uNkCRg5EU1cswRBXwIv1euT';
  static const _NEWS_API_ORG_KEY = 'fe21d6f88c864e308c531a52054529be';

  static Future<List<NewsItem>> getLatestNews({int limit = 1}) async {
    var dateTime = DateTime.now().subtract(Duration(days: 1));
    var dateTimeString =
        "${dateTime.year}-${dateTime.month}-${dateTime.day}T${dateTime.hour}:${dateTime.minute}";

    var formattedDate = DateFormat('yyyy-MM-ddThh:mm').format(dateTime);

    // final url2 = Uri.parse(
    //     'https://api.marketaux.com/v1/news/all?&limit=${10}&language=en&published_after=$formattedDate&api_token=$_NEWS_API_KEY');

    final url = Uri.parse(
        'https://newsapi.org/v2/top-headlines?apiKey=${_NEWS_API_ORG_KEY}&category=business&pageSize=20&country=US');

    try {
      final response = await http
          .get(url)
          .onError((error, stackTrace) => http.Response(error.toString(), 200));

      // final List<dynamic> newsItemsJsonList =
      //     jsonDecode(utf8.decode(response.bodyBytes))["data"];

      final List<dynamic> newsItemsJsonList =
          jsonDecode(response.body)["articles"];

      final toReturn = newsItemsJsonList
          .map((itemJson) => NewsItem.fromMarketAuxJson(itemJson))
          .toList();
      return toReturn;
    } catch (e) {
      print("Error $e");
      rethrow;
    }
  }
}

class NewsItem {
  final String title;
  final String body;
  final String? imgUrl;

  NewsItem({required this.title, required this.body, required this.imgUrl});

  static NewsItem fromMarketAuxJson(Map<String, dynamic> json) {
    return NewsItem(
        title: json["title"] ?? "ErrorTitle",
        body: json["description"] ?? "ErrorDescription",
        imgUrl: json["urlToImage"]);
  }
}
