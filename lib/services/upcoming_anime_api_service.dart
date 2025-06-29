import 'api_base_service.dart';

class UpcomingAnimeService extends BaseAnimeService {
  Future<Map<String, dynamic>> fetchUpcomingAnimes() async {
    try {
      const url =
          'https://api.myanimelist.net/v2/anime/ranking?ranking_type=upcoming&fields=alternative_titles,main_picture,genres';

      return await fetchAnimesWithPaging(url);
    } catch (e) {
      rethrow;
    }
  }
}
