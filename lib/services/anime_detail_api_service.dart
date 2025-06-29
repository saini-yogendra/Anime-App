import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import '../model/animeModel.dart';

class AnimeDetailService {
  final String _baseUrl = 'https://api.myanimelist.net/v2/anime';

  Future<Anime> fetchAnimeDetailById(int id) async {
    final fields = 'id,title,main_picture,alternative_titles,start_date,end_date,synopsis,mean,rank,popularity,num_list_users,num_scoring_users,nsfw,created_at,updated_at,media_type,status,genres,my_list_status,num_episodes,start_season,broadcast,source,average_episode_duration,rating,pictures,background,related_anime,related_manga,recommendations,studios,statistics';

    final url = '$_baseUrl/$id?fields=$fields';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'X-MAL-CLIENT-ID': clientId,
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return Anime.fromJson(jsonData);
      } else {
        throw Exception('Failed to load anime detail');
      }
    } catch (e) {
      rethrow;
    }
  }
}
