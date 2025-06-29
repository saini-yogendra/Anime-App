import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import '../model/animeModel.dart';

class BaseAnimeService {
  Future<Map<String, dynamic>> fetchAnimesWithPaging(String url) async {
    const fields = 'id,title,main_picture,alternative_titles,genres';
    final uri = Uri.parse(
      url.contains('fields=')
          ? url
          : (url.contains('?') ? '$url&fields=$fields' : '$url?fields=$fields'),
    );

    try {
      final response = await http.get(
        uri,
        headers: {
          'X-MAL-CLIENT-ID': clientId,
        },
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final List data = decoded['data'];
        final String? nextUrl = decoded['paging']?['next'];

        final animes = data.map((item) => Anime.fromJson(item['node'])).toList();

        return {
          'animes': animes,
          'nextUrl': nextUrl,
        };
      } else {
        throw Exception('Failed to load anime');
      }
    } catch (e) {
      rethrow;
    }
  }
}
