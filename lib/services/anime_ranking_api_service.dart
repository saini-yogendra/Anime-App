import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import '../model/animeModel.dart';

class AnimeRankingResponse {
  final List<Anime> animes;
  final String? nextPageUrl;

  AnimeRankingResponse({required this.animes, this.nextPageUrl});
}

class TopRankingAnimeService {
  final String _rankingType;

  TopRankingAnimeService({String rankingType = 'airing'}) : _rankingType = rankingType;

  /// Fetch first page
  Future<Map<String, dynamic>> fetchTopRankingAnimes() async {
    final uri = Uri.https(
      'api.myanimelist.net', // fixed domain
      '/v2/anime/ranking',
      {
        'ranking_type': _rankingType,
        'fields': 'id,title,alternative_titles,main_picture',
      },
    );

    try {
      final response = await http.get(
        uri,
        headers: {'X-MAL-CLIENT-ID': clientId},
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final List<dynamic> data = json['data'];

        final List<Anime> animes = data
            .where((item) => item['node']?['main_picture'] != null)
            .map<Anime>((item) {
          final node = item['node'];
          final title = node['alternative_titles']?['en'] ?? node['title'];
          return Anime.fromJson({...node, 'title': title});
        }).toList();

        return {
          'animes': animes,
          'nextUrl': json['paging']?['next'],
        };
      } else {
        throw Exception('Failed to fetch ranked anime: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Fetch next pages using nextUrl
  Future<Map<String, dynamic>> fetchAnimesWithPaging(String nextUrl) async {
    try {
      final uri = Uri.parse(nextUrl);
      final response = await http.get(
        uri,
        headers: {'X-MAL-CLIENT-ID': clientId},
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final List<dynamic> data = json['data'];

        final List<Anime> animes = data
            .where((item) => item['node']?['main_picture'] != null)
            .map<Anime>((item) {
          final node = item['node'];
          final title = node['alternative_titles']?['en'] ?? node['title'];
          return Anime.fromJson({...node, 'title': title});
        }).toList();

        return {
          'animes': animes,
          'nextUrl': json['paging']?['next'],
        };
      } else {
        throw Exception('Failed to fetch more ranked anime: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }
}
