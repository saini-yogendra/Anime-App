import 'api_base_service.dart';

class PopularAnimeService extends BaseAnimeService {
  Future<Map<String, dynamic>> fetchPopularAnimes({String? nextUrl}) async {
    final url = nextUrl ??
        'https://api.myanimelist.net/v2/anime/ranking'
            '?ranking_type=all'
            '&limit=10'
            '&fields=id,title,alternative_titles,main_picture';

    try {
      return await fetchAnimesWithPaging(url);
    } catch (e) {
      rethrow;
    }
  }
}
